unit InterfacedList;
      {******************************************************************}
      { InterfacedList                                                   }
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
  InterfacedListIntf;

type
  TInterfacedList = class(TInterfacedObject, IInterfacedList)
  private
    FList: TList;
  protected
    function GetCapacity: Integer; stdcall;
    function GetCount: Integer; stdcall;
    function GetItem(const Index: Integer): Pointer; stdcall;

    procedure SetCapacity(const NewCapacity: Integer); stdcall;
    procedure SetCount(const NewCount: Integer); stdcall;
    procedure SetItem(const Index: Integer; const Item: Pointer); stdcall;
  public
    constructor Create;
    destructor Destroy; override;
    function GetEnumerator: IInterfacedListEnumerator; stdcall;

    function Add(const Item: Pointer): Integer; stdcall;
    procedure Clear; stdcall;
    procedure Delete(const Index: Integer); stdcall;
    procedure Exchange(const Index1, Index2: Integer); stdcall;
    function First: Pointer; stdcall;
    function IndexOf(const Item: Pointer): Integer; stdcall;
    procedure Insert(const Index: Integer; const Item: Pointer); stdcall;
    function Last: Pointer; stdcall;
    function Remove(const Item: Pointer): Integer; stdcall;

    property Capacity: Integer read GetCapacity write SetCapacity;
    property Count: Integer read GetCount write SetCount;
    property Items[const Index: Integer]: Pointer read GetItem write SetItem; default;
  end;

implementation

type
  TInterfacedListEnumerator = class(TInterfacedObject, IInterfacedListEnumerator)
  private
    FList: TInterfacedList;
    FIndex: Integer;
    function GetCurrent: Pointer; stdcall;
  public
    constructor Create(List: TInterfacedList);
    function MoveNext: Boolean; stdcall;
    property Current: Pointer read GetCurrent;
  end;

{ TInterfacedList }

function TInterfacedList.Add(const Item: Pointer): Integer;
begin
  Result := FList.Add(Item);
end;

procedure TInterfacedList.Clear;
begin
  FList.Clear;
end;

constructor TInterfacedList.Create;
begin
  inherited Create;
  FList := TList.Create;
end;

procedure TInterfacedList.Delete(const Index: Integer);
begin
  FList.Delete(Index);
end;

destructor TInterfacedList.Destroy;
begin
  FList.Free;
  inherited;
end;

procedure TInterfacedList.Exchange(const Index1, Index2: Integer);
begin
  FList.ExChange(Index1, Index2);
end;

function TInterfacedList.First: Pointer;
begin
  Result := FList[0];
end;

function TInterfacedList.GetItem(const Index: Integer): Pointer;
begin
  if (Index >= 0) and (Index < FList.Count) then
    Result := FList[Index]
  else
    Result := nil;
end;

function TInterfacedList.GetCapacity: Integer;
begin
  Result := FList.Capacity;
end;

function TInterfacedList.GetCount: Integer;
begin
  Result := FList.Count;
end;

function TInterfacedList.GetEnumerator: IInterfacedListEnumerator;
begin
  Result := TInterfacedListEnumerator.Create(Self);
end;

function TInterfacedList.IndexOf(const Item: Pointer): Integer;
begin
  Result := FList.IndexOf(Item);
end;

procedure TInterfacedList.Insert(const Index: Integer; const Item: Pointer);
begin
  FList.Insert(INdex, Item);
end;

function TInterfacedList.Last: Pointer;
begin
  Result := FList.Last;
end;

procedure TInterfacedList.SetItem(const Index: Integer; const Item: Pointer);
begin
  if (Index >= 0) or (Index < FList.Count) then
    FList[Index] := Item;
end;

function TInterfacedList.Remove(const Item: Pointer): Integer;
begin
  Result := FList.IndexOf(Item);
  if Result > -1 then
    FList.Delete(Result);
end;

procedure TInterfacedList.SetCapacity(const NewCapacity: Integer);
begin
  FList.Capacity := NewCapacity;
end;

procedure TInterfacedList.SetCount(const NewCount: Integer);
begin
  FList.Count := NewCount;
end;

{ TInterfacedListEnumerator }

constructor TInterfacedListEnumerator.Create(List: TInterfacedList);
begin
  inherited Create;
  FIndex := -1;
  FList := List;
end;

function TInterfacedListEnumerator.GetCurrent: Pointer;
begin
  Result := FList[FIndex];
end;

function TInterfacedListEnumerator.MoveNext: Boolean;
begin
  Result := FIndex < FList.Count - 1;
  if Result then
    Inc(FIndex);
end;

end.
