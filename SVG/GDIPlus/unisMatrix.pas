      {******************************************************************}
      { Matrix helper unit                                               }
      {                                                                  }
      { home page : http://www.mwcs.de                                   }
      { email     : martin.walter@mwcs.de                                }
      {                                                                  }
      { date      : 28-11-2007                                           }
      {                                                                  }
      { Use of this file is permitted for commercial and non-commercial  }
      { use, as long as the author is credited.                          }
      { This file (c) 2005, 2007 Martin Walter                           }
      {                                                                  }
      { This Software is distributed on an "AS IS" basis, WITHOUT        }
      { WARRANTY OF ANY KIND, either express or implied.                 }
      {                                                                  }
      { *****************************************************************}

unit unisMatrix;

interface

{$IFDEF USER_DEFINES_INC}{$I user_defines.inc}{$ENDIF}

uses
  unisGDIPOBJ;

type
  TMatrix = record
    Cells: array[0..2, 0..2] of Single;
  end;

function MultiplyMatrices(const M1, M2: TMatrix): TMatrix;

function CalcRotationMatrix(X, Y: Single; Angle: Single): TMatrix;

function GetGPMatrix(const Matrix: TMatrix): TGPMatrix;

implementation

function MultiplyMatrices(const M1, M2: TMatrix): TMatrix;
begin
  Result.Cells[0, 0] := M1.Cells[0, 0] * M2.Cells[0, 0] +
    M1.Cells[1, 0] * M2.Cells[0, 1] + M1.Cells[2, 0] * M2.Cells[0, 2];
  Result.Cells[1, 0] := M1.Cells[0, 0] * M2.Cells[1, 0] +
    M1.Cells[1, 0] * M2.Cells[1, 1] + M1.Cells[2, 0] * M2.Cells[1, 2];
  Result.Cells[2, 0] := M1.Cells[0, 0] * M2.Cells[2, 0] +
    M1.Cells[1, 0] * M2.Cells[2, 1] + M1.Cells[2, 0] * M2.Cells[2, 2];

  Result.Cells[0, 1] := M1.Cells[0, 1] * M2.Cells[0, 0] +
    M1.Cells[1, 1] * M2.Cells[0, 1] + M1.Cells[2, 1] * M2.Cells[0, 2];
  Result.Cells[1, 1] := M1.Cells[0, 1] * M2.Cells[1, 0] +
    M1.Cells[1, 1] * M2.Cells[1, 1] + M1.Cells[2, 1] * M2.Cells[1, 2];
  Result.Cells[2, 1] := M1.Cells[0, 1] * M2.Cells[2, 0] +
    M1.Cells[1, 1] * M2.Cells[2, 1] + M1.Cells[2, 1] * M2.Cells[2, 2];

  Result.Cells[0, 2] := M1.Cells[0, 2] * M2.Cells[0, 0] +
    M1.Cells[1, 2] * M2.Cells[0, 1] + M1.Cells[2, 2] * M2.Cells[0, 2];
  Result.Cells[1, 2] := M1.Cells[0, 2] * M2.Cells[1, 0] +
    M1.Cells[1, 2] * M2.Cells[1, 1] + M1.Cells[2, 2] * M2.Cells[1, 2];
  Result.Cells[2, 2] := M1.Cells[0, 2] * M2.Cells[2, 0] +
    M1.Cells[1, 2] * M2.Cells[2, 1] + M1.Cells[2, 2] * M2.Cells[2, 2];
end;

function CalcRotationMatrix(X, Y: Single; Angle: Single): TMatrix;
var
  M1, M2: TMatrix;
begin
  FillChar(M1, SizeOf(M1), 0);
  M1.Cells[2, 2] := 1;
  M1.Cells[0, 0] := 1;
  M1.Cells[0, 1] := 0;
  M1.Cells[1, 0] := 0;
  M1.Cells[1, 1] := 1;
  M1.Cells[2, 0] := X;
  M1.Cells[2, 1] := Y;

  FillChar(M2, SizeOf(M2), 0);
  M2.Cells[2, 2] := 1;
  M2.Cells[0, 0] := Cos(Angle);
  M2.Cells[0, 1] := Sin(Angle);
  M2.Cells[1, 0] := -Sin(Angle);
  M2.Cells[1, 1] := Cos(Angle);
  M2.Cells[2, 0] := 0;
  M2.Cells[2, 1] := 0;

  M1 := MultiplyMatrices(M1, M2);

  FillChar(M2, SizeOf(M2), 0);
  M2.Cells[2, 2] := 1;
  M2.Cells[0, 0] := 1;
  M2.Cells[0, 1] := 0;
  M2.Cells[1, 0] := 0;
  M2.Cells[1, 1] := 1;
  M2.Cells[2, 0] := -X;
  M2.Cells[2, 1] := -Y;

  Result := MultiplyMatrices(M1, M2);
end;

function GetGPMatrix(const Matrix: TMatrix): TGPMatrix;
begin
  Result := TGPMatrix.Create(Matrix.Cells[0, 0], Matrix.Cells[0, 1],
    Matrix.Cells[1, 0], Matrix.Cells[1, 1],
    Matrix.Cells[2, 0], Matrix.Cells[2, 1]);
end;

end.
