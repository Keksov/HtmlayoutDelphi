// Borland C++ Builder
// Copyright (c) 1995, 2005 by Borland Software Corporation
// All rights reserved

// (DO NOT EDIT: machine generated header) 'Gdipobj2.pas' rev: 10.00

#ifndef Gdipobj2HPP
#define Gdipobj2HPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member functions
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <Sysinit.hpp>	// Pascal unit
#include <Graphics.hpp>	// Pascal unit
#include <Gdipapi.hpp>	// Pascal unit
#include <Gdipobj.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Gdipobj2
{
//-- type declarations -------------------------------------------------------
class DELPHICLASS TGPGraphicsPath2;
class PASCALIMPLEMENTATION TGPGraphicsPath2 : public Gdipobj::TGPGraphicsPath 
{
	typedef Gdipobj::TGPGraphicsPath inherited;
	
public:
	Status __fastcall AddRoundRect(const Gdipapi::TGPRectF &Rect, float RX, float RY)/* overload */;
	Status __fastcall AddRoundRect(float X, float Y, float Width, float Height, float RX, float RY)/* overload */;
	HIDESBASE TGPGraphicsPath2* __fastcall Clone(void);
protected:
	#pragma option push -w-inl
	/* TGPGraphicsPath.Create */ inline __fastcall TGPGraphicsPath2(void * nativePath)/* overload */ : Gdipobj::TGPGraphicsPath(nativePath) { }
	#pragma option pop
	
public:
	#pragma option push -w-inl
	/* TGPGraphicsPath.Destroy */ inline __fastcall virtual ~TGPGraphicsPath2(void) { }
	#pragma option pop
	
};


class DELPHICLASS TGPGraphics2;
class PASCALIMPLEMENTATION TGPGraphics2 : public Gdipobj::TGPGraphics 
{
	typedef Gdipobj::TGPGraphics inherited;
	
public:
	Status __fastcall DrawRoundRect(Gdipobj::TGPPen* Pen, const Gdipapi::TGPRectF &Rect, const float RX, const float RY)/* overload */;
	Status __fastcall DrawRoundRect(Gdipobj::TGPPen* Pen, float X, float Y, float Width, float Height, float RX, float RY)/* overload */;
	Status __fastcall DrawRoundRect(Gdipobj::TGPPen* Pen, const Gdipapi::TGPRect &Rect, const int RX, const int RY)/* overload */;
	Status __fastcall DrawRoundRect(Gdipobj::TGPPen* Pen, int X, int Y, int Width, int Height, int RX, int RY)/* overload */;
	Status __fastcall FillRoundRect(Gdipobj::TGPBrush* Brush, const Gdipapi::TGPRectF &Rect, const float RX, const float RY)/* overload */;
	Status __fastcall FillRoundRect(Gdipobj::TGPBrush* Brush, float X, float Y, float Width, float Height, float RX, float RY)/* overload */;
protected:
	#pragma option push -w-inl
	/* TGPGraphics.Create */ inline __fastcall TGPGraphics2(void * graphics)/* overload */ : Gdipobj::TGPGraphics(graphics) { }
	#pragma option pop
	
public:
	#pragma option push -w-inl
	/* TGPGraphics.CreateFromGraphics */ inline __fastcall TGPGraphics2(void * Graphics, int Dummy) : Gdipobj::TGPGraphics(Graphics, Dummy) { }
	#pragma option pop
	#pragma option push -w-inl
	/* TGPGraphics.Destroy */ inline __fastcall virtual ~TGPGraphics2(void) { }
	#pragma option pop
	
};


class DELPHICLASS TGPImageEx;
class PASCALIMPLEMENTATION TGPImageEx : public Gdipobj::TGPImage 
{
	typedef Gdipobj::TGPImage inherited;
	
public:
	__fastcall TGPImageEx(const void * Image)/* overload */;
	__property void * Image = {read=nativeImage};
public:
	#pragma option push -w-inl
	/* TGPImage.Destroy */ inline __fastcall virtual ~TGPImageEx(void) { }
	#pragma option pop
	
};


class DELPHICLASS TGPBitmapEx;
class PASCALIMPLEMENTATION TGPBitmapEx : public Gdipobj::TGPBitmap 
{
	typedef Gdipobj::TGPBitmap inherited;
	
public:
	__property void * Image = {read=nativeImage};
protected:
	#pragma option push -w-inl
	/* TGPBitmap.Create */ inline __fastcall TGPBitmapEx(void * nativeBitmap)/* overload */ : Gdipobj::TGPBitmap(nativeBitmap) { }
	#pragma option pop
	
public:
	#pragma option push -w-inl
	/* TGPImage.Destroy */ inline __fastcall virtual ~TGPBitmapEx(void) { }
	#pragma option pop
	
};


//-- var, const, procedure ---------------------------------------------------
extern PACKAGE Graphics::TBitmap* __fastcall TGPImageToBitmap(Gdipobj::TGPImage* Image);

}	/* namespace Gdipobj2 */
using namespace Gdipobj2;
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// Gdipobj2
