unit IntListIntf;

interface

{$IFDEF USER_DEFINES_INC}{$I user_defines.inc}{$ENDIF}

type
  IIntListEnumerator = interface(IInterface)
   ['{FE300C3D-5330-41CC-B898-86DF617846DD}']
    function GetCurrent: Integer; stdcall;
    function MoveNext: Boolean; stdcall;
    property Current: Integer read GetCurrent;
  end;

  IIntList = interface(IInterface)
  ['{8966432B-B6B9-442F-B0E3-E8ADC3CE7896}']
    function Get(const Index: Integer): Integer; stdcall;
    function GetCapacity: Integer; stdcall;
    function GetCount: Integer; stdcall;
    procedure Put(const Index: Integer; const Item: Integer); stdcall;
    procedure SetCapacity(const NewCapacity: Integer); stdcall;

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

end.
