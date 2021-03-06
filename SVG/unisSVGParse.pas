      {******************************************************************}
      { Parse of SVG property values                                     }
      {                                                                  }
      { home page : http://www.mwcs.de                                   }
      { email     : martin.walter@mwcs.de                                }
      {                                                                  }
      { date      : 05-04-2008                                           }
      {                                                                  }
      { Use of this file is permitted for commercial and non-commercial  }
      { use, as long as the author is credited.                          }
      { This file (c) 2005, 2008 Martin Walter                           }
      {                                                                  }
      { This Software is distributed on an "AS IS" basis, WITHOUT        }
      { WARRANTY OF ANY KIND, either express or implied.                 }
      {                                                                  }
      { *****************************************************************}

unit unisSVGParse;

interface

{$IFDEF USER_DEFINES_INC}{$I user_defines.inc}{$ENDIF}

uses
  Classes,
  unisSVGTypes, unisMatrix;

function ParseAngle(const Angle: WideString): TFloat;

function ParseByte(const S: WideString): Byte;

function ParsePercent(const S: WideString): TFloat;

function ParseInteger(const S: WideString): Integer;

function ParseLength(const S: WideString): TFloat;

function ParseUnit(const S: WideString): TSVGUnit;

function GetFactor(const SVGUnit: TSVGUnit): TFloat;

function ParseDRect(const S: WideString): TFRect;

function ParseURI(const URI: WideString): WideString;

function ParseTransform(const ATransform: WideString): TMatrix;

procedure DecodeBase64(const S: AnsiString; St: TStream);

implementation

uses
  SysUtils, Math,
  WideStringList, unisSVGCommon;

function ParseAngle(const Angle: WideString): TFloat;
var
  D: TFloat;
  C: Integer;
  S: WideString;
begin
  if Angle <> '' then
  begin
    S := Angle;
    C := Pos('deg', S);
    if C <> 0 then
    begin
      S := Copy(S, 1, C - 1);
      if TryStrToTFloat(S, D) then
        Result := DegToRad(D)
      else
        Result := 0;
      Exit;
    end;

    C := Pos('rad', S);
    if C <> 0 then
    begin
      TryStrToTFloat(S, Result);
      Exit;
    end;

    C := Pos('grad', S);
    if C <> 0 then
    begin
      S := Copy(S, 1, C - 1);
      if TryStrToTFloat(S, D) then
        Result := GradToRad(D)
      else
        Result := 0;
      Exit;
    end;

    if TryStrToTFloat(S, D) then
      Result := DegToRad(D)
    else
      Result := 0;
  end else
    Result := 0;
end;

function ParseByte(const S: WideString): Byte;
begin
  Result := ParseInteger(S);
end;

function ParsePercent(const S: WideString): TFloat;
begin
  Result := -1;
  if S = '' then
    Exit;

  if S[Length(S)] = '%' then
    Result := StrToTFloat(Copy(S, 1, Length(S) - 1)) / 100
  else
    Result := StrToTFloat(S);
end;

function ParseInteger(const S: WideString): Integer;
begin
  Result := StrToInt(S);
end;

function ParseLength(const S: WideString): TFloat;
var
  U: WideString;
  SVGUnit: TSVGUnit;
  Factor: TFloat;
begin
  SVGUnit := ParseUnit(S);
  if SVGUnit = suPercent then
    U := Copy(S, Length(S), 1)
  else
    if SVGUnit <> suNone then
      U := Copy(S, Length(S) - 1, 2);

  Factor := GetFactor(SVGUnit);
  if U = 'px' then
    Result := StrToTFloat(Copy(S, 1, Length(S) - 2))
  else
  if U = 'pt' then
    Result := StrToTFloat(Copy(S, 1, Length(S) - 2)) * Factor
  else
  if U = 'pc' then
    Result := StrToTFloat(Copy(S, 1, Length(S) - 2)) * Factor
  else
  if U = 'mm' then
    Result := StrToTFloat(Copy(S, 1, Length(S) - 2)) * Factor
  else
  if U = 'cm' then
    Result := StrToTFloat(Copy(S, 1, Length(S) - 2)) * Factor
  else
  if U = 'in' then
    Result := StrToTFloat(Copy(S, 1, Length(S) - 2)) * Factor
  else
  if U = '%' then
    Result := StrToTFloat(Copy(S, 1, Length(S) - 1)) * Factor
  else
    Result := StrToTFloat(S);
end;

function ParseUnit(const S: WideString): TSVGUnit;
begin
  Result := suNone;

  if Copy(S, Length(S) - 1, 2) = 'px' then
  begin
    Result := suPx;
    Exit;
  end;

  if Copy(S, Length(S) - 1, 2) = 'pt' then
  begin
    Result := suPt;
    Exit;
  end;

  if Copy(S, Length(S) - 1, 2) = 'pc' then
  begin
    Result := suPC;
    Exit;
  end;

  if Copy(S, Length(S) - 1, 2) = 'mm' then
  begin
    Result := suMM;
    Exit;
  end;

  if Copy(S, Length(S) - 1, 2) = 'cm' then
  begin
    Result := suCM;
    Exit;
  end;

  if Copy(S, Length(S) - 1, 2) = 'in' then
  begin
    Result := suIN;
    Exit;
  end;

  if Copy(S, Length(S) - 1, 2) = 'em' then
  begin
    Result := suEM;
    Exit;
  end;

  if Copy(S, Length(S) - 1, 2) = 'ex' then
  begin
    Result := suEX;
    Exit;
  end;

  if Copy(S, Length(S), 1) = '%' then
  begin
    Result := suPercent;
    Exit;
  end;
end;

function GetFactor(const SVGUnit: TSVGUnit): TFloat;
begin
  case SVGUnit of
    suPX: Result := 1;
    suPT: Result := 1.25;
    suPC: Result := 15;
    suMM: Result := 10;
    suCM: Result := 100;
    suIN: Result := 25.4;
    suEM: Result := 1;
    suEX: Result := 1;
    suPercent: Result := 1;
    else
      Result := 1;
  end;
end;

function GetValues(const S: WideString; Delimiter: WideChar): TWideStringList;
var
  C: Integer;
begin

  Result := TWideStringList.Create;
  Result.Delimiter := Delimiter;
  Result.DelimitedText := S;


  for C := Result.Count - 1 downto 0 do
  begin
    {$IFOPT R+}{$DEFINE RANGEON}{$R-}{$ELSE}{$UNDEF RANGEON}{$ENDIF}
    if Result[C] = '' then
    {$IFDEF RANGEON}{$R+}{$UNDEF RANGEON}{$ENDIF}
      Result.Delete(C);
  end;

end;

function ParseDRect(const S: WideString): TFRect;
var
  SL: TWideStringList;
begin
  FillChar(Result, SizeOf(Result), 0);

  SL := GetValues(Trim(S), ' ');

  if SL.Count = 4 then
  begin
    Result.Left   := ParseLength(SL[0]);
    Result.Top    := ParseLength(SL[1]);
    Result.Width  := ParseLength(SL[2]);
    Result.Height := ParseLength(SL[3]);
  end;

  SL.Free;
end;

function ParseURI(const URI: WideString): WideString;
var
  S: WideString;
begin
  Result := '';
  if URI = '' then
    Exit;
  S := Trim(URI);
  if (Copy(S, 1, 5) = 'url(#') and (S[Length(S)] = ')') then
    Result := Copy(S, 6, Length(S) - 6);
end;

function GetMatrix(const S: WideString): TMatrix;
var
  SL: TWideStringList;
begin
  FillChar(Result, SizeOf(Result), 0);

  SL := GetValues(S, ',');
  if SL.Count = 6 then
  begin
    Result.Cells[0, 0] := StrToTFloat(SL[0]);
    Result.Cells[0, 1] := StrToTFloat(SL[1]);
    Result.Cells[1, 0] := StrToTFloat(SL[2]);
    Result.Cells[1, 1] := StrToTFloat(SL[3]);
    Result.Cells[2, 0] := StrToTFloat(SL[4]);
    Result.Cells[2, 1] := StrToTFloat(SL[5]);
    Result.Cells[2, 2] := 1;
  end;
  SL.Free;
end;

function GetTranslate(const S: WideString): TMatrix;
var
  SL: TWideStringList;
begin
  FillChar(Result, SizeOf(Result), 0);
  SL := GetValues(S, ',');
  if SL.Count = 1 then
    SL.Add('0');

  if SL.Count = 2 then
  begin
    Result.Cells[0, 0] := 1;
    Result.Cells[0, 1] := 0;
    Result.Cells[1, 0] := 0;
    Result.Cells[1, 1] := 1;
    Result.Cells[2, 0] := StrToTFloat(SL[0]);
    Result.Cells[2, 1] := StrToTFloat(SL[1]);
    Result.Cells[2, 2] := 1;
  end;
  SL.Free;
end;

function GetScale(const S: WideString): TMatrix;
var
  SL: TWideStringList;
begin
  FillChar(Result, SizeOf(Result), 0);
  SL := GetValues(S, ',');
  if SL.Count = 1 then
    SL.Add(SL[0]);
  if SL.Count = 2 then
  begin
    Result.Cells[0, 0] := StrToTFloat(SL[0]);
    Result.Cells[0, 1] := 0;
    Result.Cells[1, 0] := 0;
    Result.Cells[1, 1] := StrToTFloat(SL[1]);
    Result.Cells[2, 0] := 0;
    Result.Cells[2, 1] := 0;
    Result.Cells[2, 2] := 1;
  end;
  SL.Free;
end;

function GetRotation(const S: WideString): TMatrix;
var
  SL: TWideStringList;
  X, Y, Angle: TFloat;
begin
  SL := GetValues(S, ',');

  Angle := ParseAngle(SL[0]);

  if SL.Count = 3 then
  begin
    X := StrToTFloat(SL[1]);
    Y := StrToTFloat(SL[2]);
  end else
  begin
    X := 0;
    Y := 0;
  end;
  SL.Free;

  Result := CalcRotationMatrix(X, Y, Angle);
end;

function GetSkewX(const S: WideString): TMatrix;
var
  SL: TWideStringList;
begin
  FillChar(Result, SizeOf(Result), 0);

  SL := GetValues(S, ',');
  if SL.Count = 1 then
  begin
    Result.Cells[0, 0] := 1;
    Result.Cells[0, 1] := 0;
    Result.Cells[1, 0] := Tan(StrToTFloat(SL[0]));
    Result.Cells[1, 1] := 1;
    Result.Cells[2, 0] := 0;
    Result.Cells[2, 1] := 0;
    Result.Cells[2, 2] := 1;
  end;
  SL.Free;
end;

function GetSkewY(const S: WideString): TMatrix;
var
  SL: TWideStringList;
begin
  FillChar(Result, SizeOf(Result), 0);

  SL := GetValues(S, ',');
  if SL.Count = 1 then
  begin
    Result.Cells[0, 0] := 1;
    Result.Cells[0, 1] := Tan(StrToTFloat(SL[0]));
    Result.Cells[1, 0] := 0;
    Result.Cells[1, 1] := 1;
    Result.Cells[2, 0] := 0;
    Result.Cells[2, 1] := 0;
    Result.Cells[2, 2] := 1;
  end;
  SL.Free;
end;

function ParseTransform(const ATransform: WideString): TMatrix;
var
  Start, Stop: Integer;
  TType: WideString;
  Values: WideString;
  S: WideString;
  M: TMatrix;
begin
  FillChar(Result, SizeOf(Result), 0);

  S := Trim(ATransform);

  while S <> '' do
  begin
    Start := Pos('(', S);
    Stop := Pos(')', S);
    if (Start = 0) or (Stop = 0) then
      Exit;
    TType := Copy(S, 1, Start - 1);
    Values := Trim(Copy(S, Start + 1, Stop - Start - 1));
    Values := StringReplace(Values, ' ', ',', [rfReplaceAll]);
    M.Cells[2, 2] := 0;

    if TType = 'matrix' then
      M := GetMatrix(Values)
    else if TType = 'translate' then
      M := GetTranslate(Values)
    else if TType = 'scale' then
      M := GetScale(Values)
    else if TType = 'rotate' then
      M := GetRotation(Values)
    else if TType = 'skewX' then
      M := GetSkewX(Values)
    else if TType = 'skewY' then
      M := GetSkewY(Values);
      
    if M.Cells[2, 2] = 1 then
    begin
      if Result.Cells[2, 2] = 0 then
        Result := M
      else
        Result := MultiplyMatrices(Result, M);
    end;

    S := Trim(Copy(S, Stop + 1, Length(S)));
  end;
end;

procedure DecodeBase64(const S: AnsiString; St: TStream);
const
  Codes64 = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/';

var
  C: Integer;
  BitCount: Integer;
  B: Integer;
  X: Integer;
  By: Byte;
begin
  BitCount := 0;
  B := 0;
  St.Position := 0;
  St.Size := 0;

  for C := 1 to Length(S) do
  begin
    X := Pos(S[C], Codes64) - 1;
    if X >= 0 then
    begin
      B := B * 64 + X;
      BitCount := BitCount + 6;
      if BitCount >= 8 then
      begin
        BitCount := BitCount - 8;
        By := (B shr BitCount) mod 256;
        B := B mod (1 shl BitCount);
        St.Write(By, 1);
      end;
    end
  end;
end;

end.
