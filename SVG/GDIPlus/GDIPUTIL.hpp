// Borland C++ Builder
// Copyright (c) 1995, 2005 by Borland Software Corporation
// All rights reserved

// (DO NOT EDIT: machine generated header) 'Gdiputil.pas' rev: 10.00

#ifndef GdiputilHPP
#define GdiputilHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member functions
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <Sysinit.hpp>	// Pascal unit
#include <Windows.hpp>	// Pascal unit
#include <Gdipapi.hpp>	// Pascal unit
#include <Gdipobj.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Gdiputil
{
//-- type declarations -------------------------------------------------------
//-- var, const, procedure ---------------------------------------------------
extern PACKAGE AnsiString __fastcall ValueTypeFromULONG(unsigned Type_);
extern PACKAGE AnsiString __fastcall GetMetaDataIDString(unsigned id);
extern PACKAGE int __fastcall GetEncoderClsid(const AnsiString format, /* out */ GUID &pClsid);
extern PACKAGE AnsiString __fastcall GetStatus(Status Stat);
extern PACKAGE AnsiString __fastcall PixelFormatString(int PixelFormat);
extern PACKAGE Word __fastcall MakeLangID(Word PrimaryLanguage, Word SubLanguage);

}	/* namespace Gdiputil */
using namespace Gdiputil;
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// Gdiputil
