unit InterfacedListIntf;
      {******************************************************************}
      { InterfacedListIntf                                               }
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

type
  IInterfacedListEnumerator = interface(IInterface)
  ['{CA201342-5E9B-484F-9214-7FD5E9C0D53A}']
    function GetCurrent: Pointer; stdcall;
    function MoveNext: Boolean; stdcall;
    property Current: Pointer read GetCurrent;
  end;

  IInterfacedList = interface(IInterface)
  ['{B2F0DFED-544C-4E82-B206-F5D989F94A4C}']
    function GetItem(const Index: Integer): Pointer; stdcall;
    function GetCapacity: Integer; stdcall;
    function GetCount: Integer; stdcall;
    procedure SetItem(const Index: Integer; const Item: Pointer); stdcall;
    procedure SetCapacity(const NewCapacity: Integer); stdcall;
    procedure SetCount(const NewCount: Integer); stdcall;

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

end.
 