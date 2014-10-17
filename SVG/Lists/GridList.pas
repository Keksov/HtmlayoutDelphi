unit GridList;

interface

{$IFDEF USER_DEFINES_INC}{$I user_defines.inc}{$ENDIF}

uses
  Contnrs;

type
  TAddEvent = procedure(Row, Column: Integer; var Item: TObject) of object;

  TGridList = class(TObject)
  private
    FRowCount: Integer;
    FColumnCount: Integer;
    FOwnsObjects: Boolean;
    FRows: TObjectList;
    FOnAdd: TAddEvent;

    function GetObject(const Row, Column: Integer): TObject;

    procedure SetObject(const Row, Column: Integer; const Item: TObject);
  protected
    procedure SetRowSize(const ARowNum: Integer; const ARow: TObjectList);

    function DoAdd(Row, Column: Integer): TObject;
  public
    constructor Create(OwnsObjects: Boolean = True);
    destructor Destroy; override;

    procedure Clear;
    procedure CreateGrid(ARows, AColumns: Integer);
    procedure Resize(ANewRows, ANewColumns: Integer);

    procedure InsertRowBefore(const ARow: Integer);
    procedure InsertRowAfter(const ARow: Integer);
    procedure DeleteRow(const ARow: Integer);
    procedure AppendRow;

    procedure InsertColumnBefore(const AColumn: Integer);
    procedure InsertColumnAfter(const AColumn: Integer);
    procedure DeleteColumn(const AColumn: Integer);
    procedure AppendColumn;

    procedure PositionOf(const AItem: TObject; var ARow, AColumn: Integer);
    function RowOf(AItem: TObject): Integer;
    function ColumnOf(AItem: TObject): Integer;

    property RowCount: Integer read FRowCount;
    property ColumnCount: Integer read FColumnCount;

    property Objects[const Row, Column: Integer]: TObject read GetObject write SetObject; default;

    property OnAdd: TAddEvent read FOnAdd write FOnAdd;
  end;

implementation

{ TGridList }

procedure TGridList.AppendColumn;
var
  R: Integer;
  Row: TObjectList;
begin
  for R := 0 to FRowCount - 1 do
  begin
    Row := TObjectList(FRows[R]);
    Row.Add(DoAdd(R, FColumnCount));
  end;
  Inc(FColumnCount);
end;

procedure TGridList.AppendRow;
var
  Row: TObjectList;
begin
  Row := TObjectList.Create(FOwnsObjects);
  FRows.Add(Row);
  SetRowSize(FRowCount, Row);
  Inc(FRowCount);
end;

procedure TGridList.Clear;
begin
  FRows.Clear;
  FRowCount := 0;
  FColumnCount := 0;
end;

function TGridList.ColumnOf(AItem: TObject): Integer;
var
  Help: Integer;
begin
  PositionOf(AItem, Help, Result);
end;

constructor TGridList.Create(OwnsObjects: Boolean);
begin
  inherited Create;

  FRows := TObjectList.Create(True);
  FOwnsObjects := OwnsObjects;
  FRowCount := 0;
  FColumnCount := 0;
end;

procedure TGridList.CreateGrid(ARows, AColumns: Integer);
var
  R: Integer;
  Row: TObjectList;
begin
  Clear;

  for R := 0 to ARows - 1 do
  begin
    Row := TObjectList.Create(FOwnsObjects);
    FRows.Add(Row);
    SetRowSize(R, Row);
  end;
  FRowCount := ARows;
  FColumnCount := AColumns;
end;

procedure TGridList.DeleteColumn(const AColumn: Integer);
var
  R: Integer;
  Row: TObjectList;
begin
  if (AColumn < 0) or (AColumn >= FColumnCount) then
    Exit;

  for R := 0 to FRowCount - 1 do
  begin
    Row := TObjectList(FRows[R]);
    Row.Delete(AColumn);
  end;
  Dec(FColumnCount);
end;

procedure TGridList.DeleteRow(const ARow: Integer);
begin
  if (ARow < 0) or (ARow >= FRowCount) then
    Exit;

  FRows.Delete(ARow);
  Dec(FRowCount);
end;

destructor TGridList.Destroy;
begin
  FRows.Free;
  inherited;
end;

function TGridList.DoAdd(Row, Column: Integer): TObject;
begin
  Result := nil;
  if Assigned(FOnAdd) then
    FOnAdd(Row, Column, Result);
end;

function TGridList.GetObject(const Row, Column: Integer): TObject;
begin
  if (Row >= 0) and (Row < FRowCount) and
     (Column >= 0) and (Column < FColumnCount) then

    Result := TObjectList(FRows[Row])[Column]
  else
    Result := nil;
end;

procedure TGridList.InsertColumnAfter(const AColumn: Integer);
var
  R: Integer;
  Row: TObjectList;
begin
  if (AColumn >= 0) and (AColumn < FColumnCount) then
  begin
    for R := 0 to FRowCount - 1 do
    begin
      Row := TObjectList(FRows[R]);
      Row.Insert(AColumn + 1, DoAdd(R, AColumn + 1));
    end;
    Inc(FColumnCount);
  end;
end;

procedure TGridList.InsertColumnBefore(const AColumn: Integer);
var
  R: Integer;
  Row: TObjectList;
begin
  if (AColumn >= 0) and (AColumn < FColumnCount) then
  begin
    for R := 0 to FRowCount - 1 do
    begin
      Row := TObjectList(FRows[R]);
      Row.Insert(AColumn, DoAdd(R, AColumn));
    end;
    Inc(FColumnCount);
  end;
end;

procedure TGridList.InsertRowAfter(const ARow: Integer);
var
  Row: TObjectList;
begin
  if (ARow >= 0) and (ARow < FRowCount) then
  begin
    Row := TObjectList.Create(FOwnsObjects);
    FRows.Insert(ARow + 1, Row);

    SetRowSize(ARow + 1, Row);
    Inc(FRowCount);
  end;
end;

procedure TGridList.InsertRowBefore(const ARow: Integer);
var
  Row: TObjectList;
begin
  if (ARow >= 0) and (ARow < FRowCount) then
  begin
    Row := TObjectList.Create(FOwnsObjects);
    FRows.Insert(ARow, Row);

    SetRowSize(ARow, Row);
    Inc(FRowCount);
  end;
end;

procedure TGridList.PositionOf(const AItem: TObject; var ARow,
  AColumn: Integer);

var
  R, C: Integer;
  Row: TObjectList;
begin
  for R := 0 to FRowCount - 1 do
  begin
    Row := TObjectlist(FRows[R]);
    C := Row.IndexOf(AItem);
    if (C <> -1) then
    begin
      ARow := R;
      AColumn := C;
      Exit;
    end;
  end;
  ARow := -1;
  AColumn := -1;
end;

procedure TGridList.Resize(ANewRows, ANewColumns: Integer);
var
  R, C: Integer;
  Row: TObjectList;
begin
  if (ANewRows = FRowCount) and (ANewColumns = FColumnCount) then
    Exit;

  if (ANewRows < 0) or (ANewColumns < 0) then
    Exit;

  if ANewRows = 0 then
  begin
    Clear;
    Exit;
  end;

  if ANewRows < FRowCount then
  begin
    for R := FRowCount - 1 downto ANewRows do
      FRows.Delete(R);
    FRowCount := FRows.Count;
  end;

  if ANewColumns < FColumnCount then
  begin
    for R := 0 to FRowCount - 1 do
    begin
      Row := TObjectList(FRows[R]);

      for C := FColumnCount - 1 downto ANewColumns do
        Row.Delete(C);
    end;
    FColumnCount := ANewRows;
  end;

  if ANewRows > FRowCount then
  begin
    for R := FRowCount to ANewRows - 1 do
      AppendRow;
  end;

  if ANewColumns > FColumnCount then
  begin
    for C := FColumnCount to ANewColumns - 1 do
      AppendColumn;
  end;

  FRowCount := ANewRows;
  FColumnCount := ANewColumns;
end;

function TGridList.RowOf(AItem: TObject): Integer;
var
  Help: Integer;
begin
  PositionOf(AItem, Result, Help);
end;

procedure TGridList.SetObject(const Row, Column: Integer; const Item: TObject);
begin
  if (Row >= 0) and (Row < FRowCount) and
     (Column >= 0) and (Column < FColumnCount) then
    TObjectList(FRows[Row])[Column] := Item;
end;

procedure TGridList.SetRowSize(const ARowNum: Integer; const ARow: TObjectList);
var
  C: Integer;
begin
  ARow.Capacity := FColumnCount;
  for C := 0 to FColumnCount - 1 do
    ARow.Add(DoAdd(ARowNum, C));
end;

end.
