unit WideStringList;

      {******************************************************************}
      { WideStringList                                                   }
      {                                                                  }
      { home page : http://www.winningcubed.de                           }
      { email     : martin.walter@winningcubed.de                        }
      {                                                                  }
      { date      : 26-04-2005                                           }
      {                                                                  }
      { Use of this file is permitted for commercial and non-commercial  }
      { use, as long as the author is credited.                          }
      { This file (c) 2005 Martin Walter                                 }
      {                                                                  }
      { This Software is distributed on an "AS IS" basis, WITHOUT        }
      { WARRANTY OF ANY KIND, either express or implied.                 }
      {                                                                  }
      { *****************************************************************}

interface

{$IFDEF USER_DEFINES_INC}{$I user_defines.inc}{$ENDIF}

uses
  Classes,
  WideStringListIntf;

type
  TWideStringItem = record
    FWideString: WideString;
    FObject: TObject;
  end;

  PWideStringItem = ^TWideStringItem;

  PWideStringItemList = ^TWideStringItemList;
  TWideStringItemList = array[0..0] of TWideStringItem;

  TWideStringList = class(TInterfacedObject, IWideStringList)
  private
    FList: PWideStringItemList;
    FCount: Integer;
    FCapacity: Integer;
    FAllowDuplicates: Boolean;
    FDelimiter: WideString;
    FNameValueSeparator: WideChar;

    function InBounds(const Value: Integer): Boolean;
    function GetTextWithDelimiter(const Delimiter: WideString): WideString;
    procedure SetTextWithDelimiter(const NewText, Delimiter: WideString);
    procedure Grow;
    procedure InsertItem(const Index: Integer; const S: WideString;
      const AObject: TObject);
    function GetText: WideString; stdcall;
    procedure SetText(const NewText: WideString); stdcall;
    function GetDelimitedText: WideString; stdcall;
    procedure SetDelimitedText(const NewText: WideString); stdcall;
    function GetCommaText: WideString; stdcall;
    procedure SetCommaText(const NewText: WideString); stdcall;
    function GetItem(const Index: Integer): WideString; stdcall;
    procedure SetItem(const Index: Integer; const S: WideString); stdcall;
    function GetObject(const Index: Integer): TObject; stdcall;
    procedure SetObject(const Index: Integer; const AObject: TObject); stdcall;
    function GetName(const Index: Integer): WideString; stdcall;
    function GetValueFromIndex(const Index: Integer): WideString; stdcall;
    procedure SetValueFromIndex(const Index: Integer; const Value: WideString); stdcall;
    function GetValue(const Name: WideString): WideString; stdcall;
    procedure SetValue(const Name, Value: WideString); stdcall;
    function GetCount: Integer; stdcall;
    function GetAllowDuplicates: Boolean; stdcall;
    function GetCapacity: Integer; stdcall;
    procedure SetCapacity(const NewCapacity: Integer); stdcall;
    function GetDelimiter: WideString; stdcall;
    procedure SetAllowDuplicates(const Value: Boolean); stdcall;
    procedure SetDelimiter(const Value: WideString); stdcall;
    function GetNameValueSeparator: WideChar; stdcall;
    procedure SetNameValueSeparator(const Value: WideChar); stdcall;
  protected
  public
    constructor Create;
    destructor Destroy; override;
    function GetEnumerator: IWideStringListEnumerator; stdcall;
    procedure Clear; stdcall;
    procedure Assign(const Source: TObject); overload; stdcall;
    procedure Assign(const Source: IWideStringList); overload; stdcall;
    procedure LoadFromStream(const Stream: TStream);
    procedure SaveToStream(const Stream: TStream);
    procedure LoadFromFile(const AFileName: WideString);
    procedure SaveToFile(const AFileName: WideString);
    function Add(const S: WideString): Integer; stdcall;
    procedure AddCommaText(const S: WideString); stdcall;
    function AddObject(const S: WideString; const AObject: TObject): Integer; stdcall;
    procedure AddStrings(const List: IWideStringList); stdcall;
    function Insert(const Index: Integer; const S: WideString): Integer; stdcall;
    function InsertObject(const Index: Integer; const S: WideString;
      const AObject: TObject): Integer; stdcall;
    procedure Delete(const Index: Integer); stdcall;
    procedure Remove(const S: WideString); stdcall;
    function IndexOf(const S: WideString): Integer; stdcall;
    function IndexOfName(const Name: WideString): Integer; stdcall;
    function IndexOfObject(const AObject: TObject): Integer; stdcall;
    procedure Move(const CurIndex, NewIndex: Integer); stdcall;
    procedure Exchange(const Index1, Index2: Integer); stdcall;

    property Count: Integer read GetCount;
    property Capacity: Integer read GetCapacity write SetCapacity;
    property Text: WideString read GetText write SetText;
    property NameValueSeparator: WideChar read GetNameValueSeparator write SetNameValueSeparator;
    property Delimiter: WideString read GetDelimiter write SetDelimiter;
    property AllowDuplicates: Boolean read GetAllowDuplicates write SetAllowDuplicates;
    property DelimitedText: WideString read GetDelimitedText write SetDelimitedText;
    property CommaText: WideString read GetCommaText write SetCommaText;

    property Strings[const Index: Integer]: WideString read GetItem write SetItem; default;
    property Objects[const Index: Integer]: TObject read GetObject write SetObject;

    property Names[const Index: Integer]: WideString read GetName;
    property Values[const Name: WideString]: WideString read GetValue write SetValue;
    property ValueFromIndex[const Index: Integer]: WideString read GetValueFromIndex write SetValueFromIndex;
  end;


implementation

uses
  Windows;

const
  CR = WideChar(#13);
  LF = WideChar(#10);
  CRLF = WideString(#13#10);
  WideLineSeparator = WideChar($2028);

type
  TStreamCharSet = (csAnsi, csUnicode, csUnicodeSwapped, csUtf8);

  TWideStringListEnumerator = class(TInterfacedObject, IWideStringListEnumerator)
  private
    FList: TWideStringList;
    FIndex: Integer;
    function GetCurrent: WideString; stdcall;
  public
    constructor Create(List: TWideStringList);
    function MoveNext: Boolean; stdcall;
    property Current: WideString read GetCurrent;
  end;

function DetectCharacterSet(Stream: TStream): TStreamCharSet;
const
  { Each Unicode stream should begin with the code U+FEFF,  }
  {   which the standard defines as the *byte order mark*.  }
  UNICODE = WideChar($FEFF);
  UNICODE_SWAPPED = WideChar($FFFE);
  UTF8 = AnsiString(#$EF#$BB#$BF);

var
  ByteOrderMark: WideChar;
  BytesRead: Integer;
  TestUtf8: array[0..2] of AnsiChar;
begin
  ByteOrderMark := #0;
  if (Stream.Size - Stream.Position) >= SizeOf(ByteOrderMark) then
  begin
    BytesRead := Stream.Read(ByteOrderMark, SizeOf(ByteOrderMark));
    if (ByteOrderMark <> UNICODE) and (ByteOrderMark <> UNICODE_SWAPPED) then
    begin
      ByteOrderMark := #0;
      Stream.Seek(-BytesRead, soFromCurrent);
      if (Stream.Size - Stream.Position) >= Length(TestUtf8) * SizeOf(AnsiChar) then
      begin
        BytesRead := Stream.Read(TestUtf8[0], Length(TestUtf8) * SizeOf(AnsiChar));
        if TestUtf8 <> UTF8 then
          Stream.Seek(-BytesRead, soFromCurrent);
      end;
    end;
  end;

  if ByteOrderMark = UNICODE then
    Result := csUnicode
  else
    if ByteOrderMark = UNICODE_SWAPPED then
      Result := csUnicodeSwapped
    else
      if TestUtf8 = UTF8 then
        Result := csUtf8
      else
        Result := csAnsi;
end;

procedure SwapByteOrder(Str: PWideChar);
var
  P: PWord;
begin
  P := PWord(Str);
  while (P^ <> 0) do
  begin
    P^ := MakeWord(HiByte(P^), LoByte(P^));
    Inc(P);
  end;
end;

{ TWideStringList}

constructor TWideStringList.Create;
begin
  inherited;

  FCount := 0;
  FList := nil;
  FAllowDuplicates := True;
  FNameValueSeparator := '=';

  SetCapacity(4);
end;

destructor TWideStringList.Destroy;
begin
  if FCount > 0 then
    Finalize(FList^[0], FCount);
  ReallocMem(FList, 0);

  inherited;
end;

procedure TWideStringList.Clear;
begin
  if FCount > 0 then
  begin
    Finalize(FList^[0], FCount);
    FCount := 0;
  end;

  ReallocMem(FList, 0);
  FList := nil;
  FCapacity := 0;
  SetCapacity(4);
end;

procedure TWideStringList.Assign(const Source: TObject);
var
  C: Integer;
begin
  if Source is TWideStringList then
  begin
    Clear;
    FDelimiter := TWideStringList(Source).Delimiter;
    FNameValueSeparator := TWideStringList(Source).NameValueSeparator;
    for C := 0 to TWideStringList(Source).Count - 1 do
      Add(TWideStringList(Source)[C]);
  end;

  if Source is TStringList then
  begin
    Clear;
    FDelimiter := WideChar(TStringList(Source).Delimiter);
    FNameValueSeparator := WideChar(TStringList(Source).NameValueSeparator);
    for C := 0 to TStringList(Source).Count - 1 do
      Add(TStringList(Source)[C]);
  end;
end;

procedure TWideStringList.Assign(const Source: IWideStringList);
var
  C: Integer;
begin
  Clear;
  FDelimiter := Source.Delimiter;
  FNameValueSeparator := Source.NameValueSeparator;
  for C := 0 to Source.Count - 1 do
    Add(Source[C]);
end;

procedure TWideStringList.LoadFromStream(const Stream: TStream);
var
  CharSet: TStreamCharSet;
  Remaining: Integer;

  WideStr: WideString;
  AnsiStr: AnsiString;
begin
  Clear;
  try
    CharSet := DetectCharacterSet(Stream);
    Remaining := Stream.Size - Stream.Position;

    case CharSet of
      csUnicode, csUnicodeSwapped :
      begin
      if Remaining < SizeOf(WideChar) then
        WideStr := ''
      else
        begin
          SetLength(WideStr, Remaining div SizeOf(WideChar));
          Stream.Read(PWideChar(WideStr)^, Remaining);
          if CharSet = csUnicodeSwapped then
            SwapByteOrder(PWideChar(WideStr));
        end;
        SetText(WideStr);
      end;

      csUtf8 :
      begin
        SetLength(AnsiStr, Remaining div SizeOf(AnsiChar));
        Stream.Read(PAnsiChar(AnsiStr)^, Remaining);
        SetText(UTF8Decode(AnsiStr));
      end;

      csAnsi :
      begin
        SetLength(AnsiStr, Remaining div SizeOf(AnsiChar));
        Stream.Read(PAnsiChar(AnsiStr)^, Remaining);
        SetText(AnsiStr);
      end;
    end;
  except
  end;
end;

procedure TWideStringList.SaveToStream(const Stream: TStream);
var
  WideStr: WideString;
  ByteMark: WideChar;
begin
  ByteMark := WideChar($FEFF);
  Stream.WriteBuffer(ByteMark, SizeOf(WideChar));

  WideStr := GetText;
  Stream.WriteBuffer(PWideChar(WideStr)^, Length(WideStr) * SizeOf(WideChar));
end;

procedure TWideStringList.LoadFromFile(const AFileName: WideString);
const
  fmOpenRead = $0000;
var
  S: TFileStream;
begin
  S := nil;
  try
    S := TFileStream.Create(AFileName, fmOpenRead);
    LoadFromStream(S);
  finally
    S.Free;
  end;
end;

procedure TWideStringList.SaveToFile(const AFileName: WideString);
var
  S: TFileStream;
begin
  S := nil;
  try
    S := TFileStream.Create(AFileName, fmCreate);
    SaveToStream(S);
  finally
    S.Free;
  end;
end;

procedure TWideStringList.SetCapacity(const NewCapacity: Integer);
begin
  if NewCapacity < FCapacity then
    Exit;

  ReallocMem(FList, NewCapacity * SizeOf(TWideStringItem));
  FCapacity := NewCapacity;
end;

function TWideStringList.InBounds(const Value: Integer): Boolean;
begin
  Result := (Value >= 0) and (Value < FCount);
end;

function TWideStringList.GetTextWithDelimiter(const Delimiter: WideString): WideString;
var
  I, L, Size: Integer;
  P: PWideChar;
  S: WideString;
begin
  Size := 0;
  for I := 0 to FCount - 1 do
    Inc(Size, Length(GetItem(I)) + Length(Delimiter));
  if FCount > 0 then
    Dec(Size, Length(Delimiter));

  SetString(Result, nil, Size);
  P := Pointer(Result);
  for I := 0 to Count - 1 do
  begin
    S := GetItem(I);
    L := Length(S);
    if L <> 0 then
    begin
      System.Move(Pointer(S)^, P^, L * SizeOf(WideChar));
      Inc(P, L);
    end;
    L := Length(Delimiter);
    if (L <> 0) and (I < Count - 1) then
    begin
      System.Move(Pointer(Delimiter)^, P^, L * SizeOf(WideChar));
      Inc(P, L);
    end;
  end;
end;

procedure TWideStringList.SetTextWithDelimiter(const NewText, Delimiter: WideString);
var
  Position, Laenge: Integer;
  Help: WideString;
begin
  Clear;
  Position := Pos(Delimiter, NewText);
  Laenge := Length(Delimiter);

  Help := NewText;
  while Position > 0 do
  begin
    Add(Copy(Help, 1, Position - 1));
    Help := Copy(Help, Position + Laenge, MaxInt);
    Position := Pos(Delimiter, Help);
  end;

  if Length(Help) > 0 then
    Add(Help);
end;

procedure TWideStringList.Grow;
var
  Delta: Integer;
begin
  if FCapacity > 64 then Delta := FCapacity div 4 else
    if FCapacity > 8 then Delta := 16 else
      Delta := 4;
  SetCapacity(FCapacity + Delta);
end;

procedure TWideStringList.InsertItem(const Index: Integer; const S: WideString;
  const AObject: TObject);
begin
  if FCount = FCapacity then
    Grow;

  if Index < FCount then
  begin
    {$IFOPT R+}{$DEFINE RANGEON}{$R-}{$ELSE}{$UNDEF RANGEON}{$ENDIF}
    System.Move( FList^[Index], FList^[Index + 1], ( FCount - Index ) * SizeOf( TWideStringItem ) );
    {$IFDEF RANGEON}{$R+}{$UNDEF RANGEON}{$ENDIF}
  end;

  {$IFOPT R+}{$DEFINE RANGEON}{$R-}{$ELSE}{$UNDEF RANGEON}{$ENDIF}
  with FList^[Index] do
  begin
    FillChar(FList^[Index], SizeOf(TWideStringItem), 0);
    FObject := AObject;
    FWideString := S;
  end;
  {$IFDEF RANGEON}{$R+}{$UNDEF RANGEON}{$ENDIF}

  Inc( FCount );
end;

function TWideStringList.GetText: WideString;
begin
  Result := GetTextWithDelimiter(sLineBreak);
end;

procedure TWideStringList.SetText(const NewText: WideString);
var
  P, Start: PWideChar;
  S: WideString;
begin
  try
    Clear;
    P := Pointer(NewText);
    if P <> nil then
      while P^ <> #0 do
      begin
        Start := P;
        while not (P^ in [WideChar(#0), WideChar(#10), WideChar(#13)]) and
          (P^ <> WideLineSeparator) do
          Inc(P);
        SetString(S, Start, P - Start);
        Add(S);
        if P^ = #13 then
          Inc(P);
        if P^ = #10 then
          Inc(P);
        if P^ = WideLineSeparator then
          Inc(P);
      end;
  finally
  end;
end;

function TWideStringList.GetDelimitedText: WideString;
begin
  Result := GetTextWithDelimiter(FDelimiter);
end;

procedure TWideStringList.SetDelimitedText(const NewText: WideString);
begin
  SetTextWithDelimiter(NewText, FDelimiter);
end;

function TWideStringList.GetCommaText: WideString;
begin
  Result := GetTextWithDelimiter(',');
end;

procedure TWideStringList.SetCommaText(const NewText: WideString);
begin
  SetTextWithDelimiter(NewText, ',');
end;

function TWideStringList.GetItem(const Index: Integer): WideString;
begin

  if InBounds(Index) then
    {$IFOPT R+}{$DEFINE RANGEON}{$R-}{$ELSE}{$UNDEF RANGEON}{$ENDIF}
    Result := FList^[Index].FWideString
    {$IFDEF RANGEON}{$R+}{$UNDEF RANGEON}{$ENDIF}
  else
    Result := '';

end;

procedure TWideStringList.SetItem(const Index: Integer; const S: WideString);
begin

  if InBounds(Index) then
    {$IFOPT R+}{$DEFINE RANGEON}{$R-}{$ELSE}{$UNDEF RANGEON}{$ENDIF}
    FList^[Index].FWideString := S;
    {$IFDEF RANGEON}{$R+}{$UNDEF RANGEON}{$ENDIF}
end;

function TWideStringList.GetObject(const Index: Integer): TObject;
begin

  if InBounds(Index) then
    {$IFOPT R+}{$DEFINE RANGEON}{$R-}{$ELSE}{$UNDEF RANGEON}{$ENDIF}
    Result := FList^[Index].FObject
    {$IFDEF RANGEON}{$R+}{$UNDEF RANGEON}{$ENDIF}
  else
    Result := nil;

end;

procedure TWideStringList.SetObject(const Index: Integer; const AObject: TObject);
begin

  if InBounds(Index) then
    {$IFOPT R+}{$DEFINE RANGEON}{$R-}{$ELSE}{$UNDEF RANGEON}{$ENDIF}
    FList^[Index].FObject := AObject;
    {$IFDEF RANGEON}{$R+}{$UNDEF RANGEON}{$ENDIF}
end;

procedure TWideStringList.Remove(const S: WideString);
begin
  Delete(IndexOf(S));
end;

function TWideStringList.GetName(const Index: Integer): WideString;
var
  Position: Integer;
begin
  Result := GetItem(Index);
  Position := Pos(FNameValueSeparator, Result);

  if Position > 0 then
    Result := Copy(Result, 1, Position - 1);
end;

function TWideStringList.GetValueFromIndex(const Index: Integer): WideString;
var
  Position: Integer;
begin
  Result := GetItem(Index);
  Position := Pos(FNameValueSeparator, Result);

  if Position > 0 then
    Result := Copy(Result, Position + Length(FNameValueSeparator), MaxInt)
  else
    Result := '';
end;

procedure TWideStringList.SetValueFromIndex(const Index: Integer;
  const Value: WideString);
begin
  if InBounds(Index) then
    SetItem(Index, GetName(Index) + FNameValueSeparator + Value);
end;

function TWideStringList.GetValue(const Name: WideString): WideString;
begin
  Result := GetValueFromIndex(IndexOfName(Name));
end;

procedure TWideStringList.SetValue(const Name, Value: WideString);
var
  Index: Integer;
begin
  Index := IndexOfName(Name);
  if InBounds(Index) then
    SetValueFromIndex(Index, Value)
  else
    Add(Name + FNameValueSeparator + Value);
end;

function TWideStringList.Add(const S: WideString): Integer;
begin
  Result := AddObject(S, nil);
end;

procedure TWideStringList.AddStrings(const List: IWideStringList);
var
  C: Integer;
begin
  for C := 0 to List.Count - 1 do
    {$IFOPT R+}{$DEFINE RANGEON}{$R-}{$ELSE}{$UNDEF RANGEON}{$ENDIF}
    AddObject(List[C], List.Objects[C]);
    {$IFDEF RANGEON}{$R+}{$UNDEF RANGEON}{$ENDIF}
end;

procedure TWideStringList.AddCommaText(const S: WideString);
var
  P: PWideChar;
  C: Integer;
  Laenge: Integer;
  Start: Integer;
begin
  Laenge := Length(S);

  if Laenge = 0 then
    Exit;
  P := PWideChar(S);
  Start := 1;
  C := 0;
  while C < Laenge do
  begin
    Inc(C);
    if P^=',' then
    begin
      Add(Copy(S, Start, C - Start));
      Start := C + 1;
    end;
    Inc(P);
  end;
  Add(Copy(S, Start, MaxInt));
end;

function TWideStringList.AddObject(const S: WideString;
  const AObject: TObject): Integer;
begin
  if (not FAllowDuplicates) and (IndexOf(S) <> -1) then
  begin
    Result := -1;
    Exit;
  end;

  Result := FCount;
  InsertItem(Result, S, AObject);
end;

function TWideStringList.Insert(const Index: Integer;
  const S: WideString): Integer;
begin
  Result := InsertObject(Index, S, nil);
end;

function TWideStringList.InsertObject(const Index: Integer; const S: WideString;
  const AObject: TObject): Integer;
begin
  if (not FAllowDuplicates) and (IndexOf(S) <> -1) then
  begin
    Result := -1;
    Exit;
  end;

  Result := Index;

  if (Index >= 0) and (Index <= FCount) then
    InsertItem(Index, S, AObject)
  else
    Result := -1;
end;

procedure TWideStringList.Delete(const Index: Integer);
begin

  if InBounds(Index) then
  begin
    {$IFOPT R+}{$DEFINE RANGEON}{$R-}{$ELSE}{$UNDEF RANGEON}{$ENDIF}
    Finalize(FList^[Index]);
    {$IFDEF RANGEON}{$R+}{$UNDEF RANGEON}{$ENDIF}
    Dec(FCount);
    if Index < FCount then
      {$IFOPT R+}{$DEFINE RANGEON}{$R-}{$ELSE}{$UNDEF RANGEON}{$ENDIF}
      System.Move(FList^[Index + 1], FList^[Index],(FCount - Index) * SizeOf(TWideStringItem));
      {$IFDEF RANGEON}{$R+}{$UNDEF RANGEON}{$ENDIF}
  end;

end;

function TWideStringList.IndexOf(const S: WideString): Integer;
begin
  for Result := 0 to FCount - 1 do
    if GetItem(Result) = S then
      Exit;

  Result := -1;
end;

function TWideStringList.IndexOfName(const Name: WideString): Integer;
begin
  for Result := 0 to FCount - 1 do
    if GetName(Result) = Name then
      Exit;

  Result := -1;
end;

function TWideStringList.IndexOfObject(const AObject: TObject): Integer;
begin
  for Result := 0 to FCount - 1 do
    if GetObject(Result) = AObject then
      Exit;

  Result := -1;
end;

procedure TWideStringList.Move(const CurIndex, NewIndex: Integer);
var
  TempObject: TObject;
  TempString: WideString;
begin
  if (CurIndex <> NewIndex) and
     InBounds(CurIndex) and
     InBounds(NewIndex) then
  begin
    TempString := GetItem(CurIndex);
    TempObject := GetObject(CurIndex);
    Delete(CurIndex);
    InsertObject(NewIndex, TempString, TempObject);
  end;
end;

procedure TWideStringList.Exchange(const Index1, Index2: Integer);
var
  TempObject: TObject;
  TempWideString: WideString;
begin

  if (Index1 <> Index2) and InBounds(Index1) and InBounds(Index2) then
  begin
    {$IFOPT R+}{$DEFINE RANGEON}{$R-}{$ELSE}{$UNDEF RANGEON}{$ENDIF}
    TempObject := FList^[Index1].FObject;
    TempWideString := FList^[Index1].FWideString;

    FList^[Index1].FObject := FList^[Index2].FObject;
    FList^[Index1].FWideString := FList^[Index2].FWideString;

    FList^[Index2].FObject := TempObject;
    FList^[Index2].FWideString := TempWideString;
    {$IFDEF RANGEON}{$R+}{$UNDEF RANGEON}{$ENDIF}
  end;

end;

function TWideStringList.GetCount: Integer;
begin
  Result := FCount;
end;

function TWideStringList.GetAllowDuplicates: Boolean;
begin
  Result := FAllowDuplicates;
end;

function TWideStringList.GetCapacity: Integer;
begin
  Result := FCapacity;
end;

function TWideStringList.GetDelimiter: WideString;
begin
  Result := FDelimiter;
end;

function TWideStringList.GetEnumerator: IWideStringListEnumerator;
begin
  Result := TWideStringListEnumerator.Create(Self);
end;

procedure TWideStringList.SetAllowDuplicates(const Value: Boolean);
begin
  FAllowDuplicates := Value;
end;

procedure TWideStringList.SetDelimiter(const Value: WideString);
begin
  FDelimiter := Value;
end;

function TWideStringList.GetNameValueSeparator: WideChar;
begin
  Result := FNameValueSeparator;
end;

procedure TWideStringList.SetNameValueSeparator(const Value: WideChar);
begin
  FNameValueSeparator := Value;
end;

{ TWideStringListEnumerator }

constructor TWideStringListEnumerator.Create(List: TWideStringList);
begin
  inherited Create;
  FIndex := -1;
  FList := List;
end;

function TWideStringListEnumerator.GetCurrent: WideString;
begin
  {$IFOPT R+}{$DEFINE RANGEON}{$R-}{$ELSE}{$UNDEF RANGEON}{$ENDIF}
  Result := FList[FIndex];
  {$IFDEF RANGEON}{$R+}{$UNDEF RANGEON}{$ENDIF}
end;

function TWideStringListEnumerator.MoveNext: Boolean;
begin
  Result := FIndex < FList.Count - 1;
  if Result then
    Inc(FIndex);
end;

end.
