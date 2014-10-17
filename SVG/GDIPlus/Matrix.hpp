// Borland C++ Builder
// Copyright (c) 1995, 2005 by Borland Software Corporation
// All rights reserved

// (DO NOT EDIT: machine generated header) 'Matrix.pas' rev: 10.00

#ifndef MatrixHPP
#define MatrixHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member functions
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <Sysinit.hpp>	// Pascal unit
#include <Gdipobj.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Matrix
{
//-- type declarations -------------------------------------------------------
struct TMatrix
{
	
public:
	float Cells[3][3];
} ;

//-- var, const, procedure ---------------------------------------------------
extern PACKAGE TMatrix __fastcall MultiplyMatrices(const TMatrix &M1, const TMatrix &M2);
extern PACKAGE TMatrix __fastcall GetRotationMatrix(float X, float Y, float Angle);
extern PACKAGE Gdipobj::TGPMatrix* __fastcall GetGPMatrix(const TMatrix &Matrix);

}	/* namespace Matrix */
using namespace Matrix;
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// Matrix
