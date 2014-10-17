// Borland C++ Builder
// Copyright (c) 1995, 2005 by Borland Software Corporation
// All rights reserved

// (DO NOT EDIT: machine generated header) 'Gdiputils.pas' rev: 10.00

#ifndef GdiputilsHPP
#define GdiputilsHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member functions
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <Sysinit.hpp>	// Pascal unit
#include <Gdipapi.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Gdiputils
{
//-- type declarations -------------------------------------------------------
#pragma option push -b-
enum TBoxAlignment { baTopLeft, baTopCenter, baTopRight, baCenterLeft, baCenterCenter, baCenterRight, baBottomLeft, baBottomCenter, baBottomRight };
#pragma option pop

//-- var, const, procedure ---------------------------------------------------
extern PACKAGE Gdipapi::TGPRectF __fastcall CalcRect(const Gdipapi::TGPRectF &Bounds, double Width, double Height, TBoxAlignment Alignment);

}	/* namespace Gdiputils */
using namespace Gdiputils;
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// Gdiputils
