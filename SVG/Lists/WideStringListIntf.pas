unit WideStringListIntf;

interface

{$IFDEF USER_DEFINES_INC}{$I user_defines.inc}{$ENDIF}

type
  IWideStringListEnumerator = interface(IInterface)
   ['{1FC809C2-61C0-45F4-A4B9-690C962DE84B}']
    function GetCurrent: WideString; stdcall;
    function MoveNext: Boolean; stdcall;
    property Current: WideString read GetCurrent;
  end;

  IWideStringList = interface(IInterface)
  ['{99D5F22F-0A1D-464D-ACCA-AC9EAADD48DC}']
    function GetAllowDuplicates: Boolean; stdcall;
    function GetCapacity: Integer; stdcall;
    function GetCommaText: WideString; stdcall;
    function GetCount: Integer; stdcall;
    function GetDelimitedText: WideString; stdcall;
    function GetDelimiter: WideString; stdcall;
    function GetItem(const Index: Integer): WideString; stdcall;
    function GetName(const Index: Integer): WideString; stdcall;
    function GetNameValueSeparator: WideChar; stdcall;
    function GetObject(const Index: Integer): TObject; stdcall;
    function GetText: WideString; stdcall;
    function GetValue(const Name: WideString): WideString; stdcall;
    function GetValueFromIndex(const Index: Integer): WideString; stdcall;

    procedure SetAllowDuplicates(const Value: Boolean); stdcall;
    procedure SetCapacity(const NewCapacity: Integer); stdcall;
    procedure SetCommaText(const NewText: WideString); stdcall;
    procedure SetDelimitedText(const NewText: WideString); stdcall;
    procedure SetDelimiter(const Value: WideString); stdcall;
    procedure SetItem(const Index: Integer; const S: WideString); stdcall;
    procedure SetNameValueSeparator(const Value: WideChar); stdcall;
    procedure SetObject(const Index: Integer; const AObject: TObject); stdcall;
    procedure SetText(const NewText: WideString); stdcall;
    procedure SetValue(const Name, Value: WideString); stdcall;
    procedure SetValueFromIndex(const Index: Integer; const Value: WideString); stdcall;

    function GetEnumerator: IWideStringListEnumerator; stdcall;
    function Add(const S: WideString): Integer; stdcall;
    procedure AddCommaText(const S: WideString); stdcall;
    function AddObject(const S: WideString; const AObject: TObject): Integer; stdcall;
    procedure AddStrings(const List: IWideStringList); stdcall;
    procedure Assign(const Source: TObject); overload; stdcall;
    procedure Assign(const Source: IWideStringList); overload; stdcall;
    procedure Clear; stdcall;
    procedure Delete(const Index: Integer); stdcall;
    procedure Exchange(const Index1, Index2: Integer); stdcall;
    function IndexOf(const S: WideString): Integer; stdcall;
    function IndexOfName(const Name: WideString): Integer; stdcall;
    function IndexOfObject(const AObject: TObject): Integer; stdcall;
    function Insert(const Index: Integer; const S: WideString): Integer; stdcall;
    function InsertObject(const Index: Integer; const S: WideString;
      const AObject: TObject): Integer; stdcall;
    procedure Move(const CurIndex, NewIndex: Integer); stdcall;
    procedure Remove(const S: WideString); stdcall;

    property AllowDuplicates: Boolean read GetAllowDuplicates write SetAllowDuplicates;
    property Capacity: Integer read GetCapacity write SetCapacity;
    property CommaText: WideString read GetCommaText write SetCommaText;
    property Count: Integer read GetCount;
    property DelimitedText: WideString read GetDelimitedText write SetDelimitedText;
    property Delimiter: WideString read GetDelimiter write SetDelimiter;
    property Names[const Index: Integer]: WideString read GetName;
    property NameValueSeparator: WideChar read GetNameValueSeparator write SetNameValueSeparator;
    property Objects[const Index: Integer]: TObject read GetObject write SetObject;
    property Strings[const Index: Integer]: WideString read GetItem write SetItem; default;
    property Text: WideString read GetText write SetText;
    property ValueFromIndex[const Index: Integer]: WideString read GetValueFromIndex write SetValueFromIndex;
    property Values[const Name: WideString]: WideString read GetValue write SetValue;
  end;

implementation

end.
