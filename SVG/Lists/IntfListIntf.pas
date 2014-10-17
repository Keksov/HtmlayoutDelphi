unit IntfListIntf;
      {******************************************************************}
      { IntfListIntf                                                     }
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
  IIntfListEnumerator = interface(IInterface)
   ['{3B13E0FF-61FB-4066-860E-78BB8009DDA6}']
    function GetCurrent: IInterface; stdcall;
    function MoveNext: Boolean; stdcall;
    property Current: IInterface read GetCurrent;
  end;

  IIntfList = interface(IInterface)
  ['{A9E982CC-7122-4EB4-B010-8C0960A766BC}']
    function GetCapacity: Integer; stdcall;
    function GetCount: Integer; stdcall;
    function GetItem(const Index: Integer): IInterface; stdcall;
    procedure SetCapacity(const NewCapacity: Integer); stdcall;
    procedure SetCount(const NewCount: Integer); stdcall;
    procedure SetItem(const Index: Integer; const Item: IInterface); stdcall;

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

end.
 