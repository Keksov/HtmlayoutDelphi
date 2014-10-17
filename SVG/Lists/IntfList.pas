unit IntfList;
      {******************************************************************}
      { IntfList                                                         }
      {                                                                  }
      { home page : http://www.winningcubed.de                           }
      { email     : martin.walter@winningcubed.de                        }
      {                                                                  }
      { date      : 09-03-2006                                           }
      { version   : v1.0                                                 }
      {                                                                  }
      { Use of this file is permitted for commercial and non-commercial  }
      { use, as long as the original author is credited.                 }
      { This file (c) 2005, 2006 Martin Walter                           }
      {                                                                  }
      { This Software is distributed on an "AS IS" basis, WITHOUT        }
      { WARRANTY OF ANY KIND, either express or implied.                 }
      {                                                                  }
      { *****************************************************************}

interface

{$IFDEF USER_DEFINES_INC}{$I user_defines.inc}{$ENDIF}

uses
  Classes,
  IntfListIntf;

type
  TIntfList = class(TInterfacedObject, IIntfList)
  private
    FList: TThreadList;
  protected
    function GetCapacity: Integer; stdcall;
    function GetCount: Integer; stdcall;
    function GetItem(const Index: Integer): IInterface; stdcall;
    procedure SetCapacity(const NewCapacity: Integer); stdcall;
    procedure SetCount(const NewCount: Integer); stdcall;
    procedure SetItem(const Index: Integer; const Item: IInterface); stdcall;
  public
    constructor Create;
    destructor Destroy; override;

    function GetEnumerator: IIntfListEnumerator; stdcall;
    function Add(const Item: IInterface): Integer; stdcall;
    procedure Clear; stdcall;
    procedure Delete(const Index: Integer); stdcall;
    procedure Exchange(const Index1, Index2: Integer); stdcall;
    procedure Move(const CurIndex, NewIndex: Integer); stdcall;
    function First: IInterface; stdcall;
    function IndexOf(const Item: IInterface): Integer; stdcall;
    procedure Insert(const Index: Integer; const Item: IInterface); stdcall;
    function Last: IInterface; stdcall;
    procedure Lock; stdcall;
    function Remove(const Item: IInterface): Integer; stdcall;
    procedure Unlock; stdcall;

    property Capacity: Integer read GetCapacity write SetCapacity;
    property Count: Integer read GetCount write SetCount;
    property Items[const Index: Integer]: IInterface read GetItem write SetItem; default;
  end;

implementation

type
  TIntfListEnumerator = class(TInterfacedObject, IIntfListEnumerator)
  private
    FList: TIntfList;
    FIndex: Integer;
    function GetCurrent: IInterface; stdcall;
  public
    constructor Create(List: TIntfList);
    function MoveNext: Boolean; stdcall;
    property Current: IInterface read GetCurrent;
  end;


{ TIntfList }

function TIntfList.Add(const Item: IInterface): Integer;
begin
  with FList.LockList do
  try
    Result := Add(nil);
    IInterface(List[Result]) := Item;
  finally
    FList.UnlockList;
  end;
end;

procedure TIntfList.Clear;
var
  I: Integer;
begin
  if FList <> nil then
  begin
    with FList.LockList do
    try
      for I := 0 to Count - 1 do
        IInterface(List[I]) := nil;
      Clear;
    finally
      FList.UnlockList;
    end;
  end;
end;

constructor TIntfList.Create;
begin
  inherited Create;
  FList := TThreadList.Create;
end;

procedure TIntfList.Delete(const Index: Integer);
begin
  with FList.LockList do
  try
    SetItem(Index, nil);
    Delete(Index);
  finally
    Self.FList.UnlockList;
  end;
end;

destructor TIntfList.Destroy;
begin
  Clear;
  FList.Free;
  inherited;
end;

procedure TIntfList.Exchange(const Index1, Index2: Integer);
begin
  with FList.LockList do
  try
    Exchange(Index1, Index2);
  finally
    FList.UnlockList;
  end;
end;

function TIntfList.First: IInterface;
begin
  Result := GetItem(0);
end;

function TIntfList.GetItem(const Index: Integer): IInterface;
begin
  with FList.LockList do
  try
    if (Index >= 0) and (Index < Count) then
      Result := IInterface(List[Index])
    else
      Result := nil;
  finally
    FList.UnlockList;
  end;
end;

function TIntfList.GetCapacity: Integer;
begin
  with FList.LockList do
  try
    Result := Capacity;
  finally
    FList.UnlockList;
  end;
end;

function TIntfList.GetCount: Integer;
begin
  with FList.LockList do
  try
    Result := Count;
  finally
    FList.UnlockList;
  end;
end;

function TIntfList.GetEnumerator: IIntfListEnumerator;
begin
  Result := TIntfListEnumerator.Create(Self);
end;

function TIntfList.IndexOf(const Item: IInterface): Integer;
begin
  with FList.LockList do
  try
    Result := IndexOf(Pointer(Item));
  finally
    FList.UnlockList;
  end;
end;

procedure TIntfList.Insert(const Index: Integer; const Item: IInterface);
begin
  with FList.LockList do
  try
    Insert(Index, nil);
    IInterface(List[Index]) := Item;
  finally
    FList.UnlockList;
  end;
end;

function TIntfList.Last: IInterface;
begin
  with FList.LockList do
  try
    Result := Self.GetItem(Count - 1);
  finally
    FList.UnlockList;
  end;
end;

procedure TIntfList.Lock;
begin
  FList.LockList;
end;

procedure TIntfList.Move(const CurIndex, NewIndex: Integer);
begin
  with FList.LockList do
  try
    Move(CurIndex, NewIndex);
  finally
    FList.UnlockList;
  end;
end;

procedure TIntfList.SetItem(const Index: Integer; const Item: IInterface);
begin
  with FList.LockList do
  try
    if (Index >= 0) or (Index < Count) then
      IInterface(List[Index]) := Item;
  finally
    FList.UnlockList;
  end;
end;

function TIntfList.Remove(const Item: IInterface): Integer;
begin
  with FList.LockList do
  try
    Result := IndexOf(Pointer(Item));
    if Result > -1 then
    begin
      IInterface(List[Result]) := nil;
      Delete(Result);
    end;
  finally
    FList.UnlockList;
  end;
end;

procedure TIntfList.SetCapacity(const NewCapacity: Integer);
begin
  with FList.LockList do
  try
    Capacity := NewCapacity;
  finally
    FList.UnlockList;
  end;
end;

procedure TIntfList.SetCount(const NewCount: Integer);
begin
  with FList.LockList do
  try
    Count := NewCount;
  finally
    FList.UnlockList;
  end;
end;

procedure TIntfList.Unlock;
begin
  FList.UnlockList;
end;

{ TIntfListEnumerator }

constructor TIntfListEnumerator.Create(List: TIntfList);
begin
  inherited Create;
  FIndex := -1;
  FList := List;
end;

function TIntfListEnumerator.GetCurrent: IInterface;
begin
  Result := FList[FIndex];
end;

function TIntfListEnumerator.MoveNext: Boolean;
begin
  Result := FIndex < FList.Count - 1;
  if Result then
    Inc(FIndex);
end;

end.
