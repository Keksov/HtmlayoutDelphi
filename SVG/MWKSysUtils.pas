unit MWKSysUtils;

      {******************************************************************}
      { MWKSysUtils                                                      }
      {                                                                  }
      { home page : http://www.mwcs.de                                   }
      { email     : martin.walter@mwcs.de                                }
      {                                                                  }
      { date      : 23-03-2007                                           }
      { version   : v2.7                                                 }
      {                                                                  }
      { Special thanks to Bernd Wasseige (Date compare in NatCompare)    }
      {                                                                  }
      {                                                                  }
      { Use of this file is permitted for commercial and non-commercial  }
      { use, as long as the original author is credited.                 }
      { This file (c) 2005, 2007 Martin Walter                           }
      {                                                                  }
      { This Software is distributed on an "AS IS" basis, WITHOUT        }
      { WARRANTY OF ANY KIND, either express or implied.                 }
      {                                                                  }
      { *****************************************************************}

interface

{$IFDEF USER_DEFINES_INC}{$I user_defines.inc}{$ENDIF}

uses
  Windows, Classes;

function StringReplace(const Source, OldPattern,
  NewPattern: AnsiString): AnsiString; overload;

function StringReplace(const Source, OldPattern,
  NewPattern: WideString): WideString; overload;

function StringReplaceOnce(const Source, OldPattern,
  NewPattern: AnsiString): AnsiString; overload;

function StringReplaceOnce(const Source, OldPattern,
  NewPattern: WideString): WideString; overload;

function StringReplaceMultiple(const Source: AnsiString;
  const OldPatterns, NewPatterns: array of AnsiString;
  CaseSensitive: Boolean = True): AnsiString; overload;

function StringReplaceMultipleW(const Source: WideString;
  const OldPatterns, NewPatterns: array of WideString;
  CaseSensitive: Boolean = True): WideString; overload;

function StrToInt(const S: AnsiString): Integer; overload;

function StrToInt(const S: WideString): Integer; overload;

function StrToDouble(const S: AnsiString): Double; overload;

function StrToDouble(const S: WideString): Double; overload;

function StrToBool(const S: WideString): Boolean;

function DupeString(const AText: WideString; ACount: Integer): WideString; overload;

function DupeString(const AText: AnsiString; ACount: Integer): AnsiString; overload;

function UpperCaseW(const S: WideString): WideString;

function LowerCaseW(const S: WideString): WideString;

function UpperCaseA(const S: AnsiString): AnsiString;

function LowerCaseA(const S: AnsiString): AnsiString;

function LowerCase(const S: WideString): WideString;

function UpperCase(const S: WideString): WideString;

function ConvertToDate(const S: WideString): TDateTime;

function NatCompare(const Item1, Item2: WideString): Integer;

function GetIntf(const Obj: TObject): IInterface;

function GetShellFolder(CSIDL: Integer): WideString;

function AddTrailingPathDelimiter(const Path: WideString): WideString;

function RemoveTrailingPathDelimiter(const Path: WideString): WideString;

function EncodeBase64(const Value: AnsiString): AnsiString; overload;

function EncodeBase64(St: TStream): AnsiString; overload;

function DecodeBase64(const Value: AnsiString): AnsiString; overload;

procedure DecodeBase64(const S: AnsiString; St: TStream); overload;

function CountFirstSpaces(const S: WideString): Integer;

function CountLastSpaces(const S: WideString): Integer;

function FitToRect(Source, Dest: TRect): TRect;

implementation

uses
  SysUtils, Math, ShlObj, ActiveX, Types;

const
  Codes64 = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/';

function CompareMem(P1, P2: Pointer; Length: Integer): Boolean; assembler;
asm
     PUSH    ESI
     PUSH    EDI
     MOV     ESI, P1
     MOV     EDI, P2
     MOV     EDX, ECX
     XOR     EAX, EAX
     AND     EDX, 3
     SAR     ECX, 2
     JS      @@1     // Negative Length implies identity.
     REPE    CMPSD
     JNE     @@2
     MOV     ECX, EDX
     REPE    CMPSB
     JNE     @@2
@@1: INC     EAX
@@2: POP     EDI
     POP     ESI
end;

type
  PDayTable = ^TDayTable;
  TDayTable = array[1..12] of Word;

const
  DateDelta = 693594;

  HoursPerDay   = 24;
  MinsPerHour   = 60;
  SecsPerMin    = 60;
  MSecsPerSec   = 1000;
  MinsPerDay    = HoursPerDay * MinsPerHour;
  SecsPerDay    = MinsPerDay * SecsPerMin;
  MSecsPerDay   = SecsPerDay * MSecsPerSec;
  
  MonthDays: array [Boolean] of TDayTable =
    ((31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31),
     (31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31));

function IsLeapYear(Year: Word): Boolean;
begin
  Result := (Year mod 4 = 0) and ((Year mod 100 <> 0) or (Year mod 400 = 0));
end;

function EncodeDate(Year, Month, Day: Word): TDateTime;
var
  I: Integer;
  DayTable: PDayTable;
begin
  Result := 0;
  DayTable := @MonthDays[IsLeapYear(Year)];
  if (Year >= 1) and (Year <= 9999) and (Month >= 1) and (Month <= 12) and
    (Day >= 1) and (Day <= DayTable^[Month]) then
  begin
    for I := 1 to Month - 1 do
      Inc(Day, DayTable^[I]);
    I := Year - 1;
    Result := I * 365 + I div 4 - I div 100 + I div 400 + Day - DateDelta;
  end;
end;

function EncodeTime(Hour, Min, Sec, MSec: Word): TDateTime;
begin
  Result := 0;
  if (Hour < HoursPerDay) and (Min < MinsPerHour) and (Sec < SecsPerMin) and (MSec < MSecsPerSec) then
    Result := (Hour * (MinsPerHour * SecsPerMin * MSecsPerSec) +
             Min * (SecsPerMin * MSecsPerSec) +
             Sec * MSecsPerSec +
             MSec) / MSecsPerDay;
end;

procedure ReplaceTime(var DateTime: TDateTime; const NewTime: TDateTime);
begin
  DateTime := Trunc(DateTime);
  if DateTime >= 0 then
    DateTime := DateTime + Abs(Frac(NewTime))
  else
    DateTime := DateTime - Abs(Frac(NewTime));
end;

function Now: TDateTime;
var
  SystemTime: TSystemTime;
begin
  GetLocalTime(SystemTime);
  with SystemTime do
    Result := EncodeDate(wYear, wMonth, wDay) +
      EncodeTime(wHour, wMinute, wSecond, wMilliseconds);
end;

function StringReplace(const Source, OldPattern, NewPattern: AnsiString): AnsiString;
// Replace every occurrence, case sensitive
var
  C: Integer;
  FoundCount: Integer;
  SourcePosition: Integer;
  Positions: array of Integer;

  SourceLength, OldPatternLength, NewPatternLength: Integer;

  PSource, PDest, PNew: PAnsiChar;
begin
  // Is there anything to do?
  if (OldPattern = NewPattern) or
     (Source = '') or
     (OldPattern = '') then
  begin
    Result := Source;
    Exit;
  end;

  try
    // Initialize some variables
    SourceLength := Length(Source);
    OldPatternLength := Length(OldPattern);
    NewPatternLength := Length(NewPattern);

    FoundCount := 0;

    // We *should* range check here, but who has strings > 4GB ?
    SetLength(Positions, SourceLength div OldPatternLength + 1);

    C := 1;
    while C <= SourceLength - OldPatternLength + 1 do
    begin
      if Source[C] = OldPattern[1] then // Check first char before we waste a jump to CompareMem
      begin
        if CompareMem(@Source[C], @OldPattern[1], OldPatternLength) then
        begin
          Positions[FoundCount] := C; // Store the found position
          Inc(FoundCount);
          Inc(C, OldPatternLength - 1); // Jump to after OldPattern
        end;
      end;
      Inc(C);
    end;

    if FoundCount > 0 then // Have we found anything?
    begin
      // We know the length of the result
      // Again, we *should* range check here...
      SetLength(Result, SourceLength + FoundCount * (NewPatternLength - OldPatternLength));

      // Initialize some variables
      SourcePosition := 1;
      PSource := PAnsiChar(Source);
      PDest := PAnsiChar(Result);
      PNew := PAnsiChar(NewPattern);

      // Replace...
      for C := 0 to FoundCount - 1 do
      begin
        // Copy original and advance resultpos
        Move(PSource^, PDest^, Positions[C] - SourcePosition);
        Inc(PDest, Positions[C] - SourcePosition);

        // Append NewPattern and advance resultpos
        Move(PNew^, PDest^, NewPatternLength);
        Inc(PDest, NewPatternLength);

        // Jump to after OldPattern
        Inc(PSource, Positions[C] - SourcePosition + OldPatternLength);
        SourcePosition := Positions[C] + OldPatternLength;
      end;
      // Append characters after last OldPattern
      Move(PSource^, PDest^, SourceLength - SourcePosition + 1);
    end else
      Result := Source; // Nothing to replace

    // Clean up
    Finalize(Positions);
  except
  end;
end;

function StringReplace(const Source, OldPattern, NewPattern: WideString): WideString;
// Replace every occurrence, case sensitive
var
  C: Integer;
  FoundCount: Integer;
  SourcePosition: Integer;
  Positions: array of Integer;

  SourceLength, OldPatternLength, NewPatternLength: Integer;
  WideCharLength: Integer;
  Helper: Integer;

  PSource, PDest, PNew: PWideChar;
begin
  // Is there anything to do?
  if (OldPattern = NewPattern) or
     (Source = '') or
     (OldPattern = '') then
  begin
    Result := Source;
    Exit;
  end;

  try
    // Initialize some variables
    SourceLength := Length(Source);
    OldPatternLength := Length(OldPattern);
    NewPatternLength := Length(NewPattern);
    WideCharLength := SizeOf(WideChar);

    FoundCount := 0;

    // We *should* range check here, but who has strings > 4GB ?
    SetLength(Positions, SourceLength div OldPatternLength + 1);

    Helper := OldPatternLength * WideCharLength;

    C := 1;
    while C <= SourceLength - OldPatternLength + 1 do
    begin
      if Source[C] = OldPattern[1] then // Check first char before we waste a jump to CompareMem
      begin
        if CompareMem(@Source[C], @OldPattern[1], Helper) then
        begin
          Positions[FoundCount] := C; // Store the found position
          Inc(FoundCount);
          Inc(C, OldPatternLength - 1); // Jump to after OldPattern
        end;
      end;
      Inc(C);
    end;

    if FoundCount > 0 then // Have we found anything?
    begin
      // We know the length of the result
      // Again, we *should* range check here...
      SetLength(Result, SourceLength + FoundCount * (NewPatternLength - OldPatternLength));

      // Initialize some variables
      SourcePosition := 1;
      PSource := PWideChar(Source);
      PDest := PWideChar(Result);
      PNew := PWideChar(NewPattern);
      Helper := NewPatternLength * WideCharLength;

      // Replace...
      for C := 0 to FoundCount - 1 do
      begin
        // Copy original and advance resultpos
        Move(PSource^, PDest^, (Positions[C] - SourcePosition) * WideCharLength);
        Inc(PDest, Positions[C] - SourcePosition);

        // Append NewPattern and advance resultpos
        Move(PNew^, PDest^, Helper);
        Inc(PDest, NewPatternLength);

        // Jump to after OldPattern
        Inc(PSource, Positions[C] - SourcePosition + OldPatternLength);
        SourcePosition := Positions[C] + OldPatternLength;
      end;
      // Append characters after last OldPattern
      Move(PSource^, PDest^, (SourceLength - SourcePosition + 1) * WideCharLength);
    end else
      Result := Source; // Nothing to replace

    // Clean up
    Finalize(Positions);
  except
  end;
end;


function StringReplaceOnce(const Source, OldPattern, NewPattern: AnsiString): AnsiString;
// Replace first occurrence, case sensitive
var
  C: Integer;
  Found: Integer;
  SourcePosition: Integer;

  SourceLength, OldPatternLength, NewPatternLength: Integer;

  PSource, PDest, PNew: PAnsiChar;
begin
  // Is there anything to do?
  if (OldPattern = NewPattern) or
     (Source = '') or
     (OldPattern = '') then
  begin
    Result := Source;
    Exit;
  end;

  try
    // Initialize some variables
    SourceLength := Length(Source);
    OldPatternLength := Length(OldPattern);
    NewPatternLength := Length(NewPattern);

    Found := 0;

    C := 1;
    while C <= SourceLength - OldPatternLength + 1 do
    begin
      if Source[C] = OldPattern[1] then // Check first char before we waste a jump to CompareMem
      begin
        if CompareMem(@Source[C], @OldPattern[1], OldPatternLength) then
        begin
          Found := C; // Store the found position
          Break
        end;
      end;
      Inc(C);
    end;

    if Found > 0 then // Have we found anything?
    begin
      // We know the length of the result
      // Again, we *should* range check here...
      SetLength(Result, SourceLength + NewPatternLength - OldPatternLength);

      // Initialize some variables
      PSource := PAnsiChar(Source);
      PDest := PAnsiChar(Result);
      PNew := PAnsiChar(NewPattern);

      Move(PSource^, PDest^, Found - 1);
      Inc(PDest, Found - 1);

      Move(PNew^, PDest^, NewPatternLength);
      Inc(PDest, NewPatternLength);

      Inc(PSource, Found - 1 + OldPatternLength);
      SourcePosition := Found + OldPatternLength;
      Move(PSource^, PDest^, SourceLength - SourcePosition + 1);
    end else
      Result := Source; // Nothing to replace
  except
  end;
end;

function StringReplaceOnce(const Source, OldPattern, NewPattern: WideString): WideString;
// Replace first occurrence, case sensitive
var
  C: Integer;
  Found: Integer;
  SourcePosition: Integer;

  SourceLength, OldPatternLength, NewPatternLength: Integer;
  WideCharLength: Integer;
  Helper: Integer;

  PSource, PDest, PNew: PWideChar;
begin
  // Is there anything to do?
  if (OldPattern = NewPattern) or
     (Source = '') or
     (OldPattern = '') then
  begin
    Result := Source;
    Exit;
  end;

  try
    // Initialize some variables
    SourceLength := Length(Source);
    OldPatternLength := Length(OldPattern);
    NewPatternLength := Length(NewPattern);
    WideCharLength := SizeOf(WideChar);

    Found := 0;

    Helper := OldPatternLength * WideCharLength;

    C := 1;
    while C <= SourceLength - OldPatternLength + 1 do
    begin
      if Source[C] = OldPattern[1] then // Check first char before we waste a jump to CompareMem
      begin
        if CompareMem(@Source[C], @OldPattern[1], Helper) then
        begin
          Found := C; // Store the found position
          Break
        end;
      end;
      Inc(C);
    end;

    if Found > 0 then // Have we found anything?
    begin
      // We know the length of the result
      // Again, we *should* range check here...
      SetLength(Result, SourceLength + NewPatternLength - OldPatternLength);

      // Initialize some variables
      PSource := PWideChar(Source);
      PDest := PWideChar(Result);
      PNew := PWideChar(NewPattern);
      Helper := NewPatternLength * WideCharLength;

      Move(PSource^, PDest^, (Found - 1) * WideCharLength);
      Inc(PDest, Found - 1);

      Move(PNew^, PDest^, Helper);
      Inc(PDest, NewPatternLength);

      Inc(PSource, Found - 1 + OldPatternLength);
      SourcePosition := Found + OldPatternLength;
      Move(PSource^, PDest^, (SourceLength - SourcePosition + 1) * WideCharLength);
    end else
      Result := Source; // Nothing to replace
  except
  end;
end;

function StringReplaceMultiple(const Source: AnsiString;
  const OldPatterns, NewPatterns: array of AnsiString;
  CaseSensitive: Boolean = True): AnsiString;
// Replace every occurrence

type
  TFoundPos = record
    Position: Integer;
    PatternNum: Integer;
  end;

  TPattern = record
    Old: AnsiString;
    New: PAnsiChar;
    LengthOld: Integer;
    LengthNew: Integer;
    Diff: Integer;
  end;

var
  C: Integer;
  FoundCount: Integer;

  Positions: array of TFoundPos;
  PositionLength: Integer;

  Patterns: array of TPattern;
  PatternCount: Integer;
  PNum: Integer;

  SourcePosition: Integer;
  SourceLength: Integer;
  SearchSource: AnsiString;

  DeltaOld: Integer;
  Delta: Integer;

  PSource, PDest, PNew: PAnsiChar;
begin
  // Is there anything to do at all?
  if (Source = '') or (Length(OldPatterns) <> Length(NewPatterns)) then
  begin
    Result := Source;
    Exit;
  end;

  // Initialize the Pattern records
  PatternCount := Length(OldPatterns);

  FoundCount := 0;
  SetLength(Patterns, PatternCount);
  for C := 0 to PatternCount - 1 do
    if (OldPatterns[C] <> '') and (OldPatterns[C] <> NewPatterns[C]) then
    begin
      if CaseSensitive then
        Patterns[FoundCount].Old := OldPatterns[C]
      else
        Patterns[FoundCount].Old := AnsiLowerCase(OldPatterns[C]);
      Patterns[FoundCount].LengthOld := Length(OldPatterns[C]);
      Patterns[FoundCount].New := PAnsiChar(NewPatterns[C]);
      Patterns[FoundCount].LengthNew := Length(NewPatterns[C]);
      Patterns[FoundCount].Diff :=
        Patterns[FoundCount].LengthNew - Patterns[FoundCount].LengthOld;

      Inc(FoundCount);
    end;
  PatternCount := FoundCount;
  SetLength(Patterns, PatternCount);

  // Nothing to replace
  if PatternCount = 0 then
  begin
    Result := Source;
    Exit;
  end;

  if CaseSensitive then
    SearchSource := Source
  else
    SearchSource := AnsiLowerCase(Source);

  try
    // Initialize some variables
    SourceLength := Length(SearchSource);
    Delta := 0;

    DeltaOld := 0;
    for C := 0 to PatternCount - 1 do
      Inc(DeltaOld, Patterns[C].LengthOld);
    DeltaOld := Round(DeltaOld / PatternCount);

    FoundCount := 0;

    // ----------------------------------
    // Check the amount of replaces
    // ----------------------------------

    // We *should* range check here, but who has strings > 2GB ?
    PositionLength := SourceLength div DeltaOld + 1;
    SetLength(Positions, PositionLength);

    C := 1;
    while C <= SourceLength do
    begin
      for PNum := 0 to PatternCount - 1 do
      begin
        // Check first char before we waste a jump to CompareMem
        if (SearchSource[C]) = (Patterns[PNum].Old[1]) then
        begin
          if CompareMem(@SearchSource[C], @Patterns[PNum].Old[1], Patterns[PNum].LengthOld) then
          begin
            if FoundCount >= PositionLength then
            begin
              // Make room for more Positions
              Inc(PositionLength, 4);
              SetLength(Positions, PositionLength);
            end;

            Positions[FoundCount].Position := C; // Store the found position
            Positions[FoundCount].PatternNum := PNum;
            Inc(FoundCount);
            Inc(C, Patterns[PNum].LengthOld - 1); // Jump to after OldPattern
            Inc(Delta, Patterns[PNum].Diff);
            Break;
          end;
        end;
      end;
      Inc(C);
    end;

    // ----------------------------------
    // Actual replace
    // ----------------------------------

    if FoundCount > 0 then // Have we found anything?
    begin
      // We know the length of the result
      // Again, we *should* range check here...
      SetLength(Result, SourceLength + Delta);

      // Initialize some variables
      SourcePosition := 1;
      PSource := PAnsiChar(Source);
      PDest := PAnsiChar(Result);

      // Replace...

      for C := 0 to FoundCount - 1 do
      begin
        PNum := Positions[C].PatternNum;

        // Copy original and advance resultpos
        PNew := Patterns[PNum].New;

        Delta := Positions[C].Position - SourcePosition;
        Move(PSource^, PDest^, Delta);
        Inc(PDest, Delta);

        // Append NewPattern and advance resultpos
        Move(PNew^, PDest^, Patterns[PNum].LengthNew);
        Inc(PDest, Patterns[PNum].LengthNew);

        // Jump to after OldPattern
        Inc(PSource, Delta + Patterns[PNum].LengthOld);
        SourcePosition := Positions[C].Position + Patterns[PNum].LengthOld;
      end;

      // Append characters after last OldPattern
      Move(PSource^, PDest^, SourceLength - SourcePosition + 1);
    end else
      Result := Source; // Nothing to replace

  finally
    // Clean up
    Finalize(Positions);
    Finalize(Patterns);
  end;
end;

function StringReplaceMultipleW(const Source: WideString;
  const OldPatterns, NewPatterns: array of WideString;
  CaseSensitive: Boolean = True): WideString;
// Replace every occurrence

type
  TFoundPos = record
    Position: Integer;
    PatternNum: Integer;
  end;

  TPattern = record
    Old: WideString;
    New: PWideChar;
    LengthOld: Integer;
    LengthNew: Integer;
    Diff: Integer;
  end;

var
  C: Integer;
  FoundCount: Integer;

  Positions: array of TFoundPos;
  PositionLength: Integer;

  Patterns: array of TPattern;
  PatternCount: Integer;
  PNum: Integer;

  SourcePosition: Integer;
  SourceLength: Integer;
  SearchSource: WideString;

  DeltaOld: Integer;
  Delta: Integer;

  PSource, PDest, PNew: PWideChar;
begin
  // Is there anything to do at all?
  if (Source = '') or (Length(OldPatterns) <> Length(NewPatterns)) then
  begin
    Result := Source;
    Exit;
  end;

  // Initialize the Pattern records
  PatternCount := Length(OldPatterns);

  FoundCount := 0;
  SetLength(Patterns, PatternCount);
  for C := 0 to PatternCount - 1 do
    if (OldPatterns[C] <> '') and (OldPatterns[C] <> NewPatterns[C]) then
    begin
      if CaseSensitive then
        Patterns[FoundCount].Old := OldPatterns[C]
      else
        Patterns[FoundCount].Old := WideLowerCase(OldPatterns[C]);
      Patterns[FoundCount].LengthOld := Length(OldPatterns[C]);
      Patterns[FoundCount].New := PWideChar(NewPatterns[C]);
      Patterns[FoundCount].LengthNew := Length(NewPatterns[C]);
      Patterns[FoundCount].Diff :=
        Patterns[FoundCount].LengthNew - Patterns[FoundCount].LengthOld;

      Inc(FoundCount);
    end;
  PatternCount := FoundCount;
  SetLength(Patterns, PatternCount);

  // Nothing to replace
  if PatternCount = 0 then
  begin
    Result := Source;
    Exit;
  end;

  if CaseSensitive then
    SearchSource := Source
  else
    SearchSource := WideLowerCase(Source);

  try
    // Initialize some variables
    SourceLength := Length(SearchSource);
    Delta := 0;

    DeltaOld := 0;
    for C := 0 to PatternCount - 1 do
      Inc(DeltaOld, Patterns[C].LengthOld);
    DeltaOld := Round(DeltaOld / PatternCount);

    FoundCount := 0;

    // ----------------------------------
    // Check the amount of replaces
    // ----------------------------------

    // We *should* range check here, but who has strings > 2GB ?
    PositionLength := SourceLength div DeltaOld + 1;
    SetLength(Positions, PositionLength);

    C := 1;
    while C <= SourceLength do
    begin
      for PNum := 0 to PatternCount - 1 do
      begin
        // Check first char before we waste a jump to CompareMem
        if (SearchSource[C]) = (Patterns[PNum].Old[1]) then
        begin
          if CompareMem(@SearchSource[C], @Patterns[PNum].Old[1],
             Patterns[PNum].LengthOld * SizeOf(WideChar)) then
          begin
            if FoundCount >= PositionLength then
            begin
              // Make room for more Positions
              Inc(PositionLength, 4);
              SetLength(Positions, PositionLength);
            end;

            Positions[FoundCount].Position := C; // Store the found position
            Positions[FoundCount].PatternNum := PNum;
            Inc(FoundCount);
            Inc(C, Patterns[PNum].LengthOld - 1); // Jump to after OldPattern
            Inc(Delta, Patterns[PNum].Diff);
            Break;
          end;
        end;
      end;
      Inc(C);
    end;

    // ----------------------------------
    // Actual replace
    // ----------------------------------

    if FoundCount > 0 then // Have we found anything?
    begin
      // We know the length of the result
      // Again, we *should* range check here...
      SetLength(Result, SourceLength + Delta);

      // Initialize some variables
      SourcePosition := 1;
      PSource := PWideChar(Source);
      PDest := PWideChar(Result);

      // Replace...

      for C := 0 to FoundCount - 1 do
      begin
        PNum := Positions[C].PatternNum;

        // Copy original and advance resultpos
        PNew := Patterns[PNum].New;

        Delta := Positions[C].Position - SourcePosition;
        Move(PSource^, PDest^, Delta * SizeOf(WideChar));
        Inc(PDest, Delta);

        // Append NewPattern and advance resultpos
        Move(PNew^, PDest^, Patterns[PNum].LengthNew * SizeOf(WideChar));
        Inc(PDest, Patterns[PNum].LengthNew);

        // Jump to after OldPattern
        Inc(PSource, (Delta + Patterns[PNum].LengthOld));
        SourcePosition := Positions[C].Position + Patterns[PNum].LengthOld;
      end;

      // Append characters after last OldPattern
      Move(PSource^, PDest^, (SourceLength - SourcePosition + 1) * SizeOf(WideChar));
    end else
      Result := Source; // Nothing to replace

  finally
    // Clean up
    Finalize(Positions);
    Finalize(Patterns);
  end;
end;

function Base10(X: Integer): Integer;
var
  C: Integer;
begin
  Result := 1;

  for C := 1 to X do
    Result := Result * 10;
end;

{function TryStrToInt(const S: AnsiString; var I: Integer): Boolean;
var
  C: Integer;
  Size: Integer;
  Minus: Boolean;
  P: PChar;
begin
  Result := False;
  if S = '' then
    Exit;

  I := 0;
  P := PChar(S);
  Size := Length(S);

  if (S[1] = '-') or
     (S[1] = '+') then
  begin
    Minus := S[1] = '-';
    Inc(P);
    Dec(Size);
  end else
    Minus := False;

  C := 1;
  while C <= Size do
  begin
    if Byte(P^) in [48..57] then
      Inc(I, (Byte(P^) - 48) * Base10(Size - C))
    else
      Exit;
    Inc(P);
    Inc(C);
  end;
  if Minus then
    I := I * -1;
  Result := True;
end;

function TryStrToInt(const S: WideString; var I: Integer): Boolean;
var
  C: Integer;
  Size: Integer;
  Minus: Boolean;
  P: PWideChar;
begin
  Result := False;
  if S = '' then
    Exit;

  I := 0;
  P := PWideChar(S);
  Size := Length(S);

  if (S[1] = '-') or
     (S[1] = '+') then
  begin
    Minus := S[1] = '-';
    Inc(P);
    Dec(Size);
  end else
    Minus := False;

  C := 1;
  while C <= Size do
  begin
    if Word(P^) in [48..57] then
      Inc(I, (Word(P^) - 48) * Base10(Size - C))
    else
      Exit;
    Inc(P);
    Inc(C);
  end;
  if Minus then
    I := I * -1;
  Result := True;
end;


function TryStrToDouble(const S: AnsiString; var D: Double): Boolean;
var
  C: Integer;
  Size: Integer;
  Minus: Boolean;
  Comma: Integer;
  P: PChar;
begin
  Result := False;
  if S = '' then
    Exit;

  D := 0;
  P := PChar(S);
  Size := Length(S);

  if (S[1] = '-') or
     (S[1] = '+') then
  begin
    Minus := S[1] = '-';
    Inc(P);
    Dec(Size);
  end else
    Minus := False;

  Comma := 0;  
  C := 1;
  while C <= Size do
  begin
    if Byte(P^) in [48..57] then
    begin
      D := D + (Byte(P^) - 48) * Base10(Size - C);
    end else
      if (Byte(P^) in [44, 46]) and
         (Comma = 0) then
      begin
        Comma := C;
        D := D / 10;
      end else
        Exit;
    Inc(P);
    Inc(C);
  end;

  if Comma <> 0 then
    D := D / Base10(Size - Comma);

  if Minus then
    D := D * -1;
  Result := True;
end;

function TryStrToDouble(const S: WideString; var D: Double): Boolean;
var
  C: Integer;
  Size: Integer;
  Minus: Boolean;
  Comma: Integer;
  P: PWideChar;
begin
  Result := False;
  if S = '' then
    Exit;

  D := 0;
  P := PWideChar(S);
  Size := Length(S);

  if (S[1] = '-') or
     (S[1] = '+') then
  begin
    Minus := S[1] = '-';
    Inc(P);
    Dec(Size);
  end else
    Minus := False;

  Comma := 0;  
  C := 1;
  while C <= Size do
  begin
    if Word(P^) in [48..57] then
    begin
      D := D + (Word(P^) - 48) * Base10(Size - C);
    end else
      if (Word(P^) in [44, 46]) and
         (Comma = 0) then
      begin
        Comma := C;
        D := D / 10;
      end else
        Exit;
    Inc(P);
    Inc(C);
  end;

  if Comma <> 0 then
    D := D / Base10(Size - Comma);

  if Minus then
    D := D * -1;
  Result := True;
end;}

function StrToInt(const S: AnsiString): Integer;
begin
  if not TryStrToInt(S, Result) then
    Result := 0;
end;

function StrToInt(const S: WideString): Integer;
begin
  if not TryStrToInt(S, Result) then
    Result := 0;
end;

function StrToDouble(const S: AnsiString): Double;
begin
  if not TryStrToFloat(S, Result) then
    Result := 0;
end;

function StrToDouble(const S: WideString): Double;
begin
  if not TryStrToFloat(S, Result) then
    Result := 0;
end;

function StrToBool(const S: WideString): Boolean;
begin
  if LowerCase(S) = 'true' then
  begin
    Result := True;
    Exit;
  end;

  if LowerCase(S) = 'false' then
  begin
    Result := False;
    Exit;
  end;

  Result := Boolean(StrToInt(S));
end;

function DupeString(const AText: WideString; ACount: Integer): WideString;
var
  P: PWideChar;
  C, I: Integer;
begin
  C := Length(AText);
  SetLength(Result, C * ACount);
  P := Pointer(Result);
  if P = nil then
    Exit;
  for I := 0 to ACount - 1 do
  begin
    Move(Pointer(AText)^, P^, C * SizeOf(WideChar));
    Inc(P, C);
  end;
end;

function DupeString(const AText: AnsiString; ACount: Integer): AnsiString;
var
  P: PChar;
  C, I: Integer;
begin
  C := Length(AText);
  SetLength(Result, C * ACount);
  P := Pointer(Result);
  if P = nil then
    Exit;
  for I := 0 to ACount - 1 do
  begin
    Move(Pointer(AText)^, P^, C);
    Inc(P, C);
  end;
end;

function UpperCaseW(const S: WideString): WideString;
var
  Len: Integer;
begin
  Len := Length(S);
  SetString(Result, PWideChar(S), Len);
  if Len > 0 then
    CharUpperBuffW(Pointer(Result), Len);
end;

function UpperCaseA(const S: AnsiString): AnsiString;
var
  Len: Integer;
begin
  Len := Length(S);
  SetString(Result, PChar(S), Len);
  if Len > 0 then
    CharUpperBuffA(Pointer(Result), Len);
end;

function LowerCaseW(const S: WideString): WideString;
var
  Len: Integer;
begin
  Len := Length(S);
  SetString(Result, PWideChar(S), Len);
  if Len > 0 then
    CharLowerBuffW(Pointer(Result), Len);
end;

function LowerCaseA(const S: AnsiString): AnsiString;
var
  Len: Integer;
begin
  Len := Length(S);
  SetString(Result, PChar(S), Len);
  if Len > 0 then
    CharLowerBuffA(Pointer(Result), Len);
end;

function LowerCase(const S: WideString): WideString;
begin
  Result := LowerCaseW(S);
end;

function UpperCase(const S: WideString): WideString;
begin
  Result := UpperCaseW(S);
end;

function ConvertToDate(const S: WideString): TDateTime;
var
  Year, Month, Day, Hours, Minutes, Seconds: WideString;
  Date, Time: WideString;
  C: Integer;

  procedure ExplodeDate;
  const
    DELIM: array [0..3] of WideChar = ('-', '.', '/', ':');
  var
    C, P: Integer;
  begin
    C := 0;
    P := 0;
    while (P = 0) and (C <= High(DELIM)) do
    begin
      P := Pos(DELIM[C], Date);
      Inc(C);
    end;

    if (P = 3) then
    begin
      Day := Copy(Date, 1, 2);
      Month := Copy(Date, 4, 2);
      Year := Copy(Date, 7, 4);
    end;

    if (P = 5) then
    begin
      Year := Copy(Date, 1, 4);
      Month := Copy(Date, 6, 2);
      Day := Copy(Date, 9, 2);
    end;
  end;

  procedure ExplodeTime;
  begin
    Hours := Copy(Time, 1, 2);
    Minutes := Copy(Time, 4, 2);
    Seconds := Copy(Time, 7, 2);
  end;

begin
  Result := Now;
  if S = '' then
    Exit;

  C := Pos(' ', S);
  if C = 11 then
  begin
    Date := Copy(S, 1, 11);
    Time := Copy(S, 12, 8);
  end;

  if C = 9 then
  begin
    Time := Copy(S, 1, 8);
    Date := Copy(S, 10, 10);
  end;

  if C = 0 then
  begin
    if Length(S) = 10 then
      Date := S;
    if Length(S) = 8 then
      Time := S;
  end;

  if (Date = '') and (Time = '') then
    Exit;

  ExplodeDate;
  ExplodeTime;

  if Time = '' then
    Result := EncodeDate(StrToInt(Year), StrToInt(Month), StrToInt(Day))
  else
    if Date = '' then
      ReplaceTime(Result, EncodeTime(StrToInt(Hours), StrToInt(Minutes), StrToInt(Seconds), 0))
    else
      Result := EncodeDate(StrToInt(Year), StrToInt(Month), StrToInt(Day)) +
        EncodeTime(StrToInt(Hours), StrToInt(Minutes), StrToInt(Seconds), 0);
end;

function NatCompare(const Item1, Item2: WideString): Integer;
var
  Start1, Start2: Integer;
  S1, S2: WideString;
  N1, N2: Boolean;
  D1, D2: TDateTime;

  function IsDigit(const C: WideChar): Boolean;
  begin
    Result := (C in [WideChar('0')..WideChar('9')]);
  end;

  function GetNext(const S: WideString; var Start: Integer;
    var IsNumber: Boolean): WideString;
  var
    Len,
    Laenge,
    C: Integer;
  begin
    Len := Length(S);
    if Start > Len then
    begin
      Result := '';
      Exit;
    end;

    // Beginnt eine Zahl? 
    IsNumber := IsDigit(S[Start]); 
    Laenge := 1; 

    for C := Start + 1 to Len do
    begin 
      // Weiterhin eine Zahl/ein Wort? 
      if IsDigit(S[C]) = IsNumber then 
        Inc(Laenge) 
      else 
        Break; 
    end; 

    Result := Copy(S, Start, Laenge);
    Inc(Start, Laenge); 
  end; 

begin
  Result := 0;

  // Beide gleich -> Raus hier 
  if Item1 = Item2 then 
    Exit; 

  // Haben wir zwei Datumsangaben
  // Dank an Bernd Wasseige
  if TryStrToDate(Item1, D1) and TryStrToDate(Item2, D2) then
  begin
    Result := Round(D1 - D2);
    Exit;
  end;

  Start1 := 1;
  Start2 := 1;

  // Alle Teile durchgehen
  repeat
    // Teile holen
    S1 := GetNext(Item1, Start1, N1);
    S2 := GetNext(Item2, Start2, N2);

    // Haben wir zwei Zahlen?
    if N1 and N2 then // Ja -> Zahlen Vergleichen
      Result := StrToInt(S1) - StrToInt(S2)
    else // Nein -> Normaler Stringvergleich
      Result := WideCompareStr(S1, S2);

  until (Result <> 0) or 
        (Start1 > Length(Item1)) or 
        (Start2 > Length(Item2)); 
end;

function GetIntf(const Obj: TObject): IInterface;
begin
  Result := IInterface(Pointer(Obj));
end;

function GetShellFolder(CSIDL: Integer): WideString;
var
  pidl: PItemIdList;
  FolderPath: WideString;
  Malloc: IMalloc;
begin
  Malloc := nil;
  FolderPath := '';
  SHGetMalloc(Malloc);
  if Malloc = nil then
  begin
    Result := FolderPath;
    Exit;
  end;
  try
    if SUCCEEDED(SHGetSpecialFolderLocation(0, CSIDL, pidl)) then
    begin
      SetLength(FolderPath, MAX_PATH * SizeOf(WideChar));
      if SHGetPathFromIDListW(pidl, PWideChar(FolderPath)) then
        SetLength(FolderPath, Length(PWideChar(FolderPath)));
    end;
    Result := FolderPath;
  finally
    Malloc.Free(pidl);
  end;
end;

function IsPathDelimiter(const Path: WideString; Index: Integer): Boolean;
begin
  Result := (Index > 0) and
    (Index <= Length(Path)) and
    (Path[Index] = PathDelim);
end;

function AddTrailingPathDelimiter(const Path: WideString): WideString;
begin
  if IsPathDelimiter(Path, Length(Path)) then
    Result := Path
  else
    Result := Path + PathDelim;
end;

function RemoveTrailingPathDelimiter(const Path: WideString): WideString;
begin
  if IsPathDelimiter(Path, Length(Path)) then
    Result := Copy(Path, 1, Length(Path) - 1)
  else
    Result := Path;
end;


function EncodeBase64(const Value: AnsiString): AnsiString;
var
  C: Cardinal;
  A: Integer;
  X: Integer;
  B: Integer;
  By: Byte;
  P: Integer;
begin
  SetLength(Result, Ceil(Length(Value) / 3) * 4);
  A := 0;
  B := 0;

  P := 0;

  for C := 1 to Length(Value) do
  begin
    By := Ord(Value[C]);
    X := By;

    B := B * 256 + X;
    A := A + 8;

    while A >= 6 do
    begin
      a := a - 6;
      X := B div (1 shl A);
      B := B mod (1 shl A);
      Inc(P);
      Result[P] := Codes64[X + 1];
    end;
  end;

  if A > 0 then
  begin
    X := B shl (6 - A);
    Inc(P);
    Result[P] := Codes64[X + 1];
  end;
end;

function EncodeBase64(St: TStream): AnsiString;
var
  C: Cardinal;
  A: Integer;
  X: Integer;
  B: Integer;
  By: Byte;
begin
  Result := '';
  A := 0;
  B := 0;
  St.Position := 0;
  if St.Size = 0 then
    Exit;
  for C := 0 to St.Size - 1 do
  begin
    St.Read(By, 1);
    X := By;

    B := B * 256 + X;
    A := A + 8;

    while A >= 6 do
    begin
      a := a - 6; 
      X := B div (1 shl A);
      B := B mod (1 shl A);
      Result := Result + Codes64[X + 1];
    end; 
  end; 
  if A > 0 then
  begin 
    X := B shl (6 - A);
    Result := Result + Codes64[X + 1];
  end; 
end;

function DecodeBase64(const Value: AnsiString): AnsiString;
var
  C: Integer;
  A: Integer;
  X: Integer;
  B: Integer;
  By: Byte;
  P: Integer;
begin
  A := 0;
  B := 0;
  SetLength(Result, Length(Value) div 4 * 3);
  P := 0;

  for C := 1 to Length(Value) do
  begin
    X := Pos(Value[C], Codes64) - 1;
    if X >= 0 then
    begin
      B := B * 64 + X;
      A := A + 6;
      if A >= 8 then
      begin
        A := A - 8;
        X := B shr A;
        B := B mod (1 shl A);
        X := X mod 256;
        By := X;
        Inc(P);
        Result[P] := Chr(By);
      end;
    end else
      Break;
  end;
  SetLength(Result, P);
end;

procedure DecodeBase64(const S: AnsiString; St: TStream);
var
  C: Integer;
  A: Integer;
  X: Integer;
  B: Integer;
  By: Byte;
begin
  A := 0;
  B := 0;
  St.Position := 0;
  St.Size := 0;

  for C := 1 to Length(S) do
  begin
    X := Pos(S[C], Codes64) - 1;
    if X >= 0 then
    begin
      B := B * 64 + X;
      A := A + 6;
      if A >= 8 then
      begin
        A := A - 8;
        X := B shr A;
        B := B mod (1 shl A);
        X := X mod 256;
        By := X;
        St.Write(By, 1);
      end;
    end else
      Exit;
  end;
end;

function CountFirstSpaces(const S: WideString): Integer;
begin
  Result := 1;
  while S[Result] = ' ' do
    Inc(Result);

  Dec(Result);
end;

function CountLastSpaces(const S: WideString): Integer;
var
  C: Integer;
begin
  Result := 0;
  C := System.Length(S);

  while S[C] = ' ' do
  begin
    Dec(C);
    Inc(Result);
  end;
  if Result = System.Length(S) then
    Result := 0;
end;

function FitToRect(Source, Dest: TRect): TRect;
var
  R: Double;
  SW, SH, DW, DH: Integer;
begin
  SW := (Source.Right - Source.Left);
  SH := (Source.Bottom - Source.Top);
  DW := (Dest.Right - Dest.Left);
  DH := (Dest.Bottom - Dest.Top);

  if (DH = 0) or (DW = 0) then
  begin
    Result := Rect(0, 0, 0, 0);
    Exit;
  end;

  if SH > 0 then
    R :=  SW / SH
  else
    R := 1;

  if DW / DH > R then
  begin
    Result.Right := Round(DW * R);
    Result.Bottom := DH;
  end else
  begin
    Result.Right := DH;
    Result.Bottom := Round(DW / R);
  end;

  Result := Rect(Source.Left, Source.Top,
    Source.Left + Result.Right, Source.Top + Result.Bottom);
end;


end.