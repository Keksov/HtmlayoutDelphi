unit IntList;

interface

{$IFDEF USER_DEFINES_INC}{$I user_defines.inc}{$ENDIF}

uses
  IntListIntf, Classes;

type
  TIntList = class(TInterfacedObject, IIntList)
  private
    FList: TList;
  protected
    function Get(const Index: Integer): Integer; stdcall;
    function GetCapacity: Integer; stdcall;
    function GetCount: Integer; stdcall;
    procedure Put(const Index: Integer; const Item: Integer); stdcall;
    procedure SetCapacity(const NewCapacity: Integer); stdcall;
  public
    constructor Create;
    destructor Destroy; override;

    function GetEnumerator: IIntListEnumerator; stdcall;
    procedure Clear; stdcall;
    procedure Delete(const Index: Integer); stdcall;
    procedure Exchange(const Index1, Index2: Integer); stdcall;
    procedure Move(const CurIndex, NewIndex: Integer); stdcall;
    function First: Integer; stdcall;
    function Add(const Item: Integer): Integer; stdcall;
    procedure Insert(const Index: Integer; const Item: Integer); stdcall;
    function Last: Integer; stdcall;
    property Capacity: Integer read GetCapacity write SetCapacity;
    property Count: Integer read GetCount;
    property Items[const Index: Integer]: Integer read Get write Put; default;
  end;

implementation

type
  TIntListEnumerator = class(TInterfacedObject, IIntListEnumerator)
  private
    FList: TIntList;
    FIndex: Integer;
    function GetCurrent: Integer; stdcall;
  public
    constructor Create(List: TIntList);
    function MoveNext: Boolean; stdcall;
    property Current: Integer read GetCurrent;
  end;


{ TIntList }

function TIntList.Add(const Item: Integer): Integer;
begin
  Result := FList.Add(Pointer(Item));
end;

procedure TIntList.Clear;
begin
  FList.Clear;
end;

constructor TIntList.Create;
begin
  inherited;
  FList := TList.Create;
end;

procedure TIntList.Delete(const Index: Integer);
begin
  FList.Delete(Index);
end;

destructor TIntList.Destroy;
begin
  FList.Free;
  inherited;
end;

procedure TIntList.Exchange(const Index1, Index2: Integer);
begin
  FList.Exchange(Index1, Index2);
end;

function TIntList.First: Integer;
begin
  Result := Integer(FList.First);
end;

function TIntList.Get(const Index: Integer): Integer;
begin
  Result := Integer(FList[Index]);
end;

function TIntList.GetCapacity: Integer;
begin
  Result := FList.Capacity;
end;

function TIntList.GetCount: Integer;
begin
  Result := FList.Count;
end;

function TIntList.GetEnumerator: IIntListEnumerator;
begin
  Result := TIntListEnumerator.Create(Self);
end;

procedure TIntList.Insert(const Index, Item: Integer);
begin
  FList.Insert(Index, Pointer(Item));
end;

function TIntList.Last: Integer;
begin
  Result := Integer(FList.Last);
end;

procedure TIntList.Move(const CurIndex, NewIndex: Integer);
begin
  FList.Move(CurIndex, NewIndex);
end;

procedure TIntList.Put(const Index, Item: Integer);
begin
  FList[Index] := Pointer(Item);
end;

procedure TIntList.SetCapacity(const NewCapacity: Integer);
begin
  FList.Capacity := NewCapacity;
end;

{ TIntListEnumerator }

constructor TIntListEnumerator.Create(List: TIntList);
begin
  inherited Create;
  FIndex := -1;
  FList := List;
end;

function TIntListEnumerator.GetCurrent: Integer;
begin
  Result := FList[FIndex];
end;

function TIntListEnumerator.MoveNext: Boolean;
begin
  Result := FIndex < FList.Count - 1;
  if Result then
    Inc(FIndex);
end;

end.
