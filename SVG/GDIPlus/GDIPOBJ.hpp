// Borland C++ Builder
// Copyright (c) 1995, 2005 by Borland Software Corporation
// All rights reserved

// (DO NOT EDIT: machine generated header) 'Gdipobj.pas' rev: 10.00

#ifndef GdipobjHPP
#define GdipobjHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member functions
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <Sysinit.hpp>	// Pascal unit
#include <Windows.hpp>	// Pascal unit
#include <Activex.hpp>	// Pascal unit
#include <Directdraw.hpp>	// Pascal unit
#include <Gdipapi.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Gdipobj
{
//-- type declarations -------------------------------------------------------
class DELPHICLASS TGPRegion;
class DELPHICLASS TGPGraphicsPath;
class DELPHICLASS TGPMatrix;
class DELPHICLASS TGPGraphics;
class PASCALIMPLEMENTATION TGPRegion : public Gdipapi::TGdiplusBase 
{
	typedef Gdipapi::TGdiplusBase inherited;
	
protected:
	void *nativeRegion;
	Status lastResult;
	Status __fastcall SetStatus(Status status);
	void __fastcall SetNativeRegion(void * nativeRegion);
	__fastcall TGPRegion(void * nativeRegion)/* overload */;
	
public:
	__fastcall TGPRegion(void)/* overload */;
	__fastcall TGPRegion(const Gdipapi::TGPRectF &rect)/* overload */;
	__fastcall TGPRegion(const Gdipapi::TGPRect &rect)/* overload */;
	__fastcall TGPRegion(TGPGraphicsPath* path)/* overload */;
	__fastcall TGPRegion(System::PByte regionData, int size)/* overload */;
	__fastcall TGPRegion(HRGN hRgn)/* overload */;
	TGPRegion* __fastcall FromHRGN(HRGN hRgn);
	__fastcall virtual ~TGPRegion(void);
	TGPRegion* __fastcall Clone(void);
	Status __fastcall MakeInfinite(void);
	Status __fastcall MakeEmpty(void);
	unsigned __fastcall GetDataSize(void);
	Status __fastcall GetData(System::PByte buffer, unsigned bufferSize, PUINT sizeFilled = (void *)(0x0));
	Status __fastcall Intersect(const Gdipapi::TGPRect &rect)/* overload */;
	Status __fastcall Intersect(const Gdipapi::TGPRectF &rect)/* overload */;
	Status __fastcall Intersect(TGPGraphicsPath* path)/* overload */;
	Status __fastcall Intersect(TGPRegion* region)/* overload */;
	Status __fastcall Union(const Gdipapi::TGPRect &rect)/* overload */;
	Status __fastcall Union(const Gdipapi::TGPRectF &rect)/* overload */;
	Status __fastcall Union(TGPGraphicsPath* path)/* overload */;
	Status __fastcall Union(TGPRegion* region)/* overload */;
	Status __fastcall Xor_(const Gdipapi::TGPRect &rect)/* overload */;
	Status __fastcall Xor_(const Gdipapi::TGPRectF &rect)/* overload */;
	Status __fastcall Xor_(TGPGraphicsPath* path)/* overload */;
	Status __fastcall Xor_(TGPRegion* region)/* overload */;
	Status __fastcall Exclude(const Gdipapi::TGPRect &rect)/* overload */;
	Status __fastcall Exclude(const Gdipapi::TGPRectF &rect)/* overload */;
	Status __fastcall Exclude(TGPGraphicsPath* path)/* overload */;
	Status __fastcall Exclude(TGPRegion* region)/* overload */;
	Status __fastcall Complement(const Gdipapi::TGPRect &rect)/* overload */;
	Status __fastcall Complement(const Gdipapi::TGPRectF &rect)/* overload */;
	Status __fastcall Complement(TGPGraphicsPath* path)/* overload */;
	Status __fastcall Complement(TGPRegion* region)/* overload */;
	Status __fastcall Translate(float dx, float dy)/* overload */;
	Status __fastcall Translate(int dx, int dy)/* overload */;
	Status __fastcall Transform(TGPMatrix* matrix);
	Status __fastcall GetBounds(/* out */ Gdipapi::TGPRect &rect, TGPGraphics* g)/* overload */;
	Status __fastcall GetBounds(/* out */ Gdipapi::TGPRectF &rect, TGPGraphics* g)/* overload */;
	HRGN __fastcall GetHRGN(TGPGraphics* g);
	BOOL __fastcall IsEmpty(TGPGraphics* g);
	BOOL __fastcall IsInfinite(TGPGraphics* g);
	BOOL __fastcall IsVisible(int x, int y, TGPGraphics* g = (TGPGraphics*)(0x0))/* overload */;
	BOOL __fastcall IsVisible(const Gdipapi::TGPPoint &point, TGPGraphics* g = (TGPGraphics*)(0x0))/* overload */;
	BOOL __fastcall IsVisible(float x, float y, TGPGraphics* g = (TGPGraphics*)(0x0))/* overload */;
	BOOL __fastcall IsVisible(const Gdipapi::TGPPointF &point, TGPGraphics* g = (TGPGraphics*)(0x0))/* overload */;
	BOOL __fastcall IsVisible(int x, int y, int width, int height, TGPGraphics* g)/* overload */;
	BOOL __fastcall IsVisible(const Gdipapi::TGPRect &rect, TGPGraphics* g = (TGPGraphics*)(0x0))/* overload */;
	BOOL __fastcall IsVisible(float x, float y, float width, float height, TGPGraphics* g = (TGPGraphics*)(0x0))/* overload */;
	BOOL __fastcall IsVisible(const Gdipapi::TGPRectF &rect, TGPGraphics* g = (TGPGraphics*)(0x0))/* overload */;
	BOOL __fastcall Equals(TGPRegion* region, TGPGraphics* g);
	unsigned __fastcall GetRegionScansCount(TGPMatrix* matrix);
	Status __fastcall GetRegionScans(TGPMatrix* matrix, Gdipapi::PGPRectF rects, /* out */ int &count)/* overload */;
	Status __fastcall GetRegionScans(TGPMatrix* matrix, Gdipapi::PGPRect rects, /* out */ int &count)/* overload */;
	Status __fastcall GetLastStatus(void);
};


class DELPHICLASS TGPFontFamily;
class DELPHICLASS TGPFontCollection;
class PASCALIMPLEMENTATION TGPFontFamily : public Gdipapi::TGdiplusBase 
{
	typedef Gdipapi::TGdiplusBase inherited;
	
protected:
	void *nativeFamily;
	Status lastResult;
	Status __fastcall SetStatus(Status status);
	__fastcall TGPFontFamily(void * nativeOrig, Status status)/* overload */;
	
public:
	__fastcall TGPFontFamily(void)/* overload */;
	__fastcall TGPFontFamily(WideString name, TGPFontCollection* fontCollection)/* overload */;
	__fastcall virtual ~TGPFontFamily(void);
	/*         class method */ static TGPFontFamily* __fastcall GenericSansSerif(TMetaClass* vmt);
	/*         class method */ static TGPFontFamily* __fastcall GenericSerif(TMetaClass* vmt);
	/*         class method */ static TGPFontFamily* __fastcall GenericMonospace(TMetaClass* vmt);
	Status __fastcall GetFamilyName(/* out */ AnsiString &name, Word language = (Word)(0x0));
	TGPFontFamily* __fastcall Clone(void);
	BOOL __fastcall IsAvailable(void);
	BOOL __fastcall IsStyleAvailable(int style);
	Gdipapi::UINT16 __fastcall GetEmHeight(int style);
	Gdipapi::UINT16 __fastcall GetCellAscent(int style);
	Gdipapi::UINT16 __fastcall GetCellDescent(int style);
	Gdipapi::UINT16 __fastcall GetLineSpacing(int style);
	Status __fastcall GetLastStatus(void);
};


class PASCALIMPLEMENTATION TGPFontCollection : public Gdipapi::TGdiplusBase 
{
	typedef Gdipapi::TGdiplusBase inherited;
	
protected:
	void *nativeFontCollection;
	Status lastResult;
	Status __fastcall SetStatus(Status status);
	
public:
	__fastcall TGPFontCollection(void);
	__fastcall virtual ~TGPFontCollection(void);
	int __fastcall GetFamilyCount(void);
	Status __fastcall GetFamilies(int numSought, /* out */ TGPFontFamily* * gpfamilies, const int gpfamilies_Size, /* out */ int &numFound);
	Status __fastcall GetLastStatus(void);
};


class DELPHICLASS TGPInstalledFontCollection;
class PASCALIMPLEMENTATION TGPInstalledFontCollection : public TGPFontCollection 
{
	typedef TGPFontCollection inherited;
	
public:
	__fastcall TGPInstalledFontCollection(void);
	__fastcall virtual ~TGPInstalledFontCollection(void);
};


class DELPHICLASS TGPPrivateFontCollection;
class PASCALIMPLEMENTATION TGPPrivateFontCollection : public TGPFontCollection 
{
	typedef TGPFontCollection inherited;
	
public:
	__fastcall TGPPrivateFontCollection(void);
	__fastcall virtual ~TGPPrivateFontCollection(void);
	Status __fastcall AddFontFile(WideString filename);
	Status __fastcall AddMemoryFont(void * memory, int length);
};


class DELPHICLASS TGPFont;
class PASCALIMPLEMENTATION TGPFont : public Gdipapi::TGdiplusBase 
{
	typedef Gdipapi::TGdiplusBase inherited;
	
protected:
	void *nativeFont;
	Status lastResult;
	void __fastcall SetNativeFont(void * Font);
	Status __fastcall SetStatus(Status status);
	__fastcall TGPFont(void * font, Status status)/* overload */;
	
public:
	__fastcall TGPFont(HDC hdc)/* overload */;
	__fastcall TGPFont(HDC hdc, Windows::PLogFontA logfont)/* overload */;
	__fastcall TGPFont(HDC hdc, Windows::PLogFontW logfont)/* overload */;
	__fastcall TGPFont(HDC hdc, HFONT hfont)/* overload */;
	__fastcall TGPFont(TGPFontFamily* family, float emSize, int style, Gdipapi::Unit_ unit_)/* overload */;
	__fastcall TGPFont(WideString familyName, float emSize, int style, Gdipapi::Unit_ unit_, TGPFontCollection* fontCollection)/* overload */;
	Status __fastcall GetLogFontA(TGPGraphics* g, /* out */ tagLOGFONTA &logfontA);
	Status __fastcall GetLogFontW(TGPGraphics* g, /* out */ tagLOGFONTW &logfontW);
	TGPFont* __fastcall Clone(void);
	__fastcall virtual ~TGPFont(void);
	BOOL __fastcall IsAvailable(void);
	int __fastcall GetStyle(void);
	float __fastcall GetSize(void);
	Gdipapi::Unit_ __fastcall GetUnit(void);
	Status __fastcall GetLastStatus(void);
	float __fastcall GetHeight(TGPGraphics* graphics)/* overload */;
	float __fastcall GetHeight(float dpi)/* overload */;
	Status __fastcall GetFamily(TGPFontFamily* family);
};


class DELPHICLASS TGPImage;
class PASCALIMPLEMENTATION TGPImage : public Gdipapi::TGdiplusBase 
{
	typedef Gdipapi::TGdiplusBase inherited;
	
protected:
	void *nativeImage;
	Status lastResult;
	Status loadStatus;
	void __fastcall SetNativeImage(void * nativeImage);
	Status __fastcall SetStatus(Status status);
	__fastcall TGPImage(void * nativeImage, Status status)/* overload */;
	
public:
	__fastcall TGPImage(WideString filename, BOOL useEmbeddedColorManagement)/* overload */;
	__fastcall TGPImage(_di_IStream stream, BOOL useEmbeddedColorManagement)/* overload */;
	TGPImage* __fastcall FromFile(WideString filename, BOOL useEmbeddedColorManagement = false);
	TGPImage* __fastcall FromStream(_di_IStream stream, BOOL useEmbeddedColorManagement = false);
	__fastcall virtual ~TGPImage(void);
	TGPImage* __fastcall Clone(void);
	Status __fastcall Save(WideString filename, const GUID &clsidEncoder, Gdipapi::PEncoderParameters encoderParams = (void *)(0x0))/* overload */;
	Status __fastcall Save(_di_IStream stream, const GUID &clsidEncoder, Gdipapi::PEncoderParameters encoderParams = (void *)(0x0))/* overload */;
	Status __fastcall SaveAdd(Gdipapi::PEncoderParameters encoderParams)/* overload */;
	Status __fastcall SaveAdd(TGPImage* newImage, Gdipapi::PEncoderParameters encoderParams)/* overload */;
	ImageType __fastcall GetType(void);
	Status __fastcall GetPhysicalDimension(/* out */ Gdipapi::TGPSizeF &size);
	Status __fastcall GetBounds(/* out */ Gdipapi::TGPRectF &srcRect, /* out */ Gdipapi::Unit_ &srcUnit);
	unsigned __fastcall GetWidth(void);
	unsigned __fastcall GetHeight(void);
	float __fastcall GetHorizontalResolution(void);
	float __fastcall GetVerticalResolution(void);
	unsigned __fastcall GetFlags(void);
	Status __fastcall GetRawFormat(/* out */ GUID &format);
	int __fastcall GetPixelFormat(void);
	int __fastcall GetPaletteSize(void);
	Status __fastcall GetPalette(Gdipapi::PColorPalette palette, int size);
	Status __fastcall SetPalette(Gdipapi::PColorPalette palette);
	TGPImage* __fastcall GetThumbnailImage(unsigned thumbWidth, unsigned thumbHeight, ImageAbort callback = 0x0, void * callbackData = (void *)(0x0));
	unsigned __fastcall GetFrameDimensionsCount(void);
	Status __fastcall GetFrameDimensionsList(System::PGUID dimensionIDs, unsigned count);
	unsigned __fastcall GetFrameCount(const GUID &dimensionID);
	Status __fastcall SelectActiveFrame(const GUID &dimensionID, unsigned frameIndex);
	Status __fastcall RotateFlip(RotateFlipType rotateFlipType);
	unsigned __fastcall GetPropertyCount(void);
	Status __fastcall GetPropertyIdList(unsigned numOfProperty, Activex::PPropID list);
	unsigned __fastcall GetPropertyItemSize(unsigned propId);
	Status __fastcall GetPropertyItem(unsigned propId, unsigned propSize, Gdipapi::PPropertyItem buffer);
	Status __fastcall GetPropertySize(/* out */ unsigned &totalBufferSize, /* out */ unsigned &numProperties);
	Status __fastcall GetAllPropertyItems(unsigned totalBufferSize, unsigned numProperties, Gdipapi::PPropertyItem allItems);
	Status __fastcall RemovePropertyItem(unsigned propId);
	Status __fastcall SetPropertyItem(const PropertyItem &item);
	unsigned __fastcall GetEncoderParameterListSize(const GUID &clsidEncoder);
	Status __fastcall GetEncoderParameterList(const GUID &clsidEncoder, unsigned size, Gdipapi::PEncoderParameters buffer);
	Status __fastcall GetLastStatus(void);
};


class DELPHICLASS TGPBitmap;
class PASCALIMPLEMENTATION TGPBitmap : public TGPImage 
{
	typedef TGPImage inherited;
	
protected:
	__fastcall TGPBitmap(void * nativeBitmap)/* overload */;
	
public:
	__fastcall TGPBitmap(WideString filename, BOOL useEmbeddedColorManagement)/* overload */;
	__fastcall TGPBitmap(_di_IStream stream, BOOL useEmbeddedColorManagement)/* overload */;
	HIDESBASE TGPBitmap* __fastcall FromFile(WideString filename, BOOL useEmbeddedColorManagement = false);
	HIDESBASE TGPBitmap* __fastcall FromStream(_di_IStream stream, BOOL useEmbeddedColorManagement = false);
	__fastcall TGPBitmap(int width, int height, int stride, int format, System::PByte scan0)/* overload */;
	__fastcall TGPBitmap(int width, int height, int format)/* overload */;
	__fastcall TGPBitmap(int width, int height, TGPGraphics* target)/* overload */;
	HIDESBASE TGPBitmap* __fastcall Clone(const Gdipapi::TGPRect &rect, int format)/* overload */;
	HIDESBASE TGPBitmap* __fastcall Clone(int x, int y, int width, int height, int format)/* overload */;
	HIDESBASE TGPBitmap* __fastcall Clone(const Gdipapi::TGPRectF &rect, int format)/* overload */;
	HIDESBASE TGPBitmap* __fastcall Clone(float x, float y, float width, float height, int format)/* overload */;
	Status __fastcall LockBits(const Gdipapi::TGPRect &rect, unsigned flags, int format, /* out */ BitmapData &lockedBitmapData);
	Status __fastcall UnlockBits(BitmapData &lockedBitmapData);
	Status __fastcall GetPixel(int x, int y, /* out */ unsigned &color);
	Status __fastcall SetPixel(int x, int y, unsigned color);
	Status __fastcall SetResolution(float xdpi, float ydpi);
	__fastcall TGPBitmap(_di_IDirectDrawSurface7 surface)/* overload */;
	__fastcall TGPBitmap(tagBITMAPINFO &gdiBitmapInfo, void * gdiBitmapData)/* overload */;
	__fastcall TGPBitmap(HBITMAP hbm, HPALETTE hpal)/* overload */;
	__fastcall TGPBitmap(HICON hicon)/* overload */;
	__fastcall TGPBitmap(unsigned hInstance, WideString bitmapName)/* overload */;
	TGPBitmap* __fastcall FromDirectDrawSurface7(_di_IDirectDrawSurface7 surface);
	TGPBitmap* __fastcall FromBITMAPINFO(tagBITMAPINFO &gdiBitmapInfo, void * gdiBitmapData);
	TGPBitmap* __fastcall FromHBITMAP(HBITMAP hbm, HPALETTE hpal);
	TGPBitmap* __fastcall FromHICON(HICON hicon);
	TGPBitmap* __fastcall FromResource(unsigned hInstance, WideString bitmapName);
	Status __fastcall GetHBITMAP(unsigned colorBackground, /* out */ HBITMAP &hbmReturn);
	Status __fastcall GetHICON(/* out */ HICON &hicon);
public:
	#pragma option push -w-inl
	/* TGPImage.Destroy */ inline __fastcall virtual ~TGPBitmap(void) { }
	#pragma option pop
	
};


class DELPHICLASS TGPCustomLineCap;
class PASCALIMPLEMENTATION TGPCustomLineCap : public Gdipapi::TGdiplusBase 
{
	typedef Gdipapi::TGdiplusBase inherited;
	
protected:
	void *nativeCap;
	Status lastResult;
	void __fastcall SetNativeCap(void * nativeCap);
	Status __fastcall SetStatus(Status status);
	__fastcall TGPCustomLineCap(void * nativeCap, Status status)/* overload */;
	
public:
	__fastcall TGPCustomLineCap(void)/* overload */;
	__fastcall TGPCustomLineCap(TGPGraphicsPath* fillPath, TGPGraphicsPath* strokePath, int baseCap, float baseInset)/* overload */;
	__fastcall virtual ~TGPCustomLineCap(void);
	TGPCustomLineCap* __fastcall Clone(void);
	Status __fastcall SetStrokeCap(int strokeCap);
	Status __fastcall SetStrokeCaps(int startCap, int endCap);
	Status __fastcall GetStrokeCaps(/* out */ int &startCap, /* out */ int &endCap);
	Status __fastcall SetStrokeJoin(LineJoin lineJoin);
	LineJoin __fastcall GetStrokeJoin(void);
	Status __fastcall SetBaseCap(int baseCap);
	int __fastcall GetBaseCap(void);
	Status __fastcall SetBaseInset(float inset);
	float __fastcall GetBaseInset(void);
	Status __fastcall SetWidthScale(float widthScale);
	float __fastcall GetWidthScale(void);
	Status __fastcall GetLastStatus(void);
};


class DELPHICLASS TGPCachedBitmap;
class PASCALIMPLEMENTATION TGPCachedBitmap : public Gdipapi::TGdiplusBase 
{
	typedef Gdipapi::TGdiplusBase inherited;
	
protected:
	void *nativeCachedBitmap;
	Status lastResult;
	
public:
	__fastcall TGPCachedBitmap(TGPBitmap* bitmap, TGPGraphics* graphics);
	__fastcall virtual ~TGPCachedBitmap(void);
	Status __fastcall GetLastStatus(void);
};


class DELPHICLASS TGPImageAttributes;
class PASCALIMPLEMENTATION TGPImageAttributes : public Gdipapi::TGdiplusBase 
{
	typedef Gdipapi::TGdiplusBase inherited;
	
protected:
	void *nativeImageAttr;
	Status lastResult;
	void __fastcall SetNativeImageAttr(void * nativeImageAttr);
	Status __fastcall SetStatus(Status status);
	__fastcall TGPImageAttributes(void * imageAttr, Status status)/* overload */;
	
public:
	__fastcall TGPImageAttributes(void)/* overload */;
	__fastcall virtual ~TGPImageAttributes(void);
	TGPImageAttributes* __fastcall Clone(void);
	Status __fastcall SetToIdentity(ColorAdjustType type_ = (ColorAdjustType)(0x0));
	Status __fastcall Reset(ColorAdjustType type_ = (ColorAdjustType)(0x0));
	Status __fastcall SetColorMatrix(float const * colorMatrix, ColorMatrixFlags mode = (ColorMatrixFlags)(0x0), ColorAdjustType type_ = (ColorAdjustType)(0x0));
	Status __fastcall ClearColorMatrix(ColorAdjustType type_ = (ColorAdjustType)(0x0));
	Status __fastcall SetColorMatrices(float const * colorMatrix, float const * grayMatrix, ColorMatrixFlags mode = (ColorMatrixFlags)(0x0), ColorAdjustType type_ = (ColorAdjustType)(0x0));
	Status __fastcall ClearColorMatrices(ColorAdjustType Type_ = (ColorAdjustType)(0x0));
	Status __fastcall SetThreshold(float threshold, ColorAdjustType type_ = (ColorAdjustType)(0x0));
	Status __fastcall ClearThreshold(ColorAdjustType type_ = (ColorAdjustType)(0x0));
	Status __fastcall SetGamma(float gamma, ColorAdjustType type_ = (ColorAdjustType)(0x0));
	Status __fastcall ClearGamma(ColorAdjustType type_ = (ColorAdjustType)(0x0));
	Status __fastcall SetNoOp(ColorAdjustType type_ = (ColorAdjustType)(0x0));
	Status __fastcall ClearNoOp(ColorAdjustType Type_ = (ColorAdjustType)(0x0));
	Status __fastcall SetColorKey(unsigned colorLow, unsigned colorHigh, ColorAdjustType type_ = (ColorAdjustType)(0x0));
	Status __fastcall ClearColorKey(ColorAdjustType type_ = (ColorAdjustType)(0x0));
	Status __fastcall SetOutputChannel(ColorChannelFlags channelFlags, ColorAdjustType type_ = (ColorAdjustType)(0x0));
	Status __fastcall ClearOutputChannel(ColorAdjustType type_ = (ColorAdjustType)(0x0));
	Status __fastcall SetOutputChannelColorProfile(WideString colorProfileFilename, ColorAdjustType type_ = (ColorAdjustType)(0x0));
	Status __fastcall ClearOutputChannelColorProfile(ColorAdjustType type_ = (ColorAdjustType)(0x0));
	Status __fastcall SetRemapTable(unsigned mapSize, Gdipapi::PColorMap map, ColorAdjustType type_ = (ColorAdjustType)(0x0));
	Status __fastcall ClearRemapTable(ColorAdjustType type_ = (ColorAdjustType)(0x0));
	Status __fastcall SetBrushRemapTable(unsigned mapSize, Gdipapi::PColorMap map);
	Status __fastcall ClearBrushRemapTable(void);
	Status __fastcall SetWrapMode(WrapMode wrap, unsigned color = (unsigned)(0xff000000), BOOL clamp = false);
	Status __fastcall GetAdjustedPalette(Gdipapi::PColorPalette colorPalette, ColorAdjustType colorAdjustType);
	Status __fastcall GetLastStatus(void);
};


typedef float TMatrixArray[6];

class PASCALIMPLEMENTATION TGPMatrix : public Gdipapi::TGdiplusBase 
{
	typedef Gdipapi::TGdiplusBase inherited;
	
protected:
	void *nativeMatrix;
	Status lastResult;
	void __fastcall SetNativeMatrix(void * nativeMatrix);
	Status __fastcall SetStatus(Status status);
	__fastcall TGPMatrix(void * nativeMatrix)/* overload */;
	
public:
	__fastcall TGPMatrix(void)/* overload */;
	__fastcall TGPMatrix(float m11, float m12, float m21, float m22, float dx, float dy)/* overload */;
	__fastcall TGPMatrix(const Gdipapi::TGPRectF &rect, const Gdipapi::TGPPointF &dstplg)/* overload */;
	__fastcall TGPMatrix(const Gdipapi::TGPRect &rect, const Gdipapi::TGPPoint &dstplg)/* overload */;
	__fastcall virtual ~TGPMatrix(void);
	TGPMatrix* __fastcall Clone(void);
	Status __fastcall GetElements(float const * m);
	Status __fastcall SetElements(float m11, float m12, float m21, float m22, float dx, float dy);
	float __fastcall OffsetX(void);
	float __fastcall OffsetY(void);
	Status __fastcall Reset(void);
	Status __fastcall Multiply(TGPMatrix* matrix, MatrixOrder order = (MatrixOrder)(0x0));
	Status __fastcall Translate(float offsetX, float offsetY, MatrixOrder order = (MatrixOrder)(0x0));
	Status __fastcall Scale(float scaleX, float scaleY, MatrixOrder order = (MatrixOrder)(0x0));
	Status __fastcall Rotate(float angle, MatrixOrder order = (MatrixOrder)(0x0));
	Status __fastcall RotateAt(float angle, const Gdipapi::TGPPointF &center, MatrixOrder order = (MatrixOrder)(0x0));
	Status __fastcall Shear(float shearX, float shearY, MatrixOrder order = (MatrixOrder)(0x0));
	Status __fastcall Invert(void);
	Status __fastcall TransformPoints(Gdipapi::PGPPointF pts, int count = 0x1)/* overload */;
	Status __fastcall TransformPoints(Gdipapi::PGPPoint pts, int count = 0x1)/* overload */;
	Status __fastcall TransformVectors(Gdipapi::PGPPointF pts, int count = 0x1)/* overload */;
	Status __fastcall TransformVectors(Gdipapi::PGPPoint pts, int count = 0x1)/* overload */;
	BOOL __fastcall IsInvertible(void);
	BOOL __fastcall IsIdentity(void);
	BOOL __fastcall Equals(TGPMatrix* matrix);
	Status __fastcall GetLastStatus(void);
};


class DELPHICLASS TGPBrush;
class PASCALIMPLEMENTATION TGPBrush : public Gdipapi::TGdiplusBase 
{
	typedef Gdipapi::TGdiplusBase inherited;
	
protected:
	void *nativeBrush;
	Status lastResult;
	void __fastcall SetNativeBrush(void * nativeBrush);
	Status __fastcall SetStatus(Status status);
	__fastcall TGPBrush(void * nativeBrush, Status status)/* overload */;
	
public:
	__fastcall TGPBrush(void)/* overload */;
	__fastcall virtual ~TGPBrush(void);
	virtual TGPBrush* __fastcall Clone(void);
	BrushType __fastcall GetType(void);
	Status __fastcall GetLastStatus(void);
};


class DELPHICLASS TGPSolidBrush;
class PASCALIMPLEMENTATION TGPSolidBrush : public TGPBrush 
{
	typedef TGPBrush inherited;
	
public:
	__fastcall TGPSolidBrush(unsigned color)/* overload */;
	__fastcall TGPSolidBrush(void)/* overload */;
	Status __fastcall GetColor(/* out */ unsigned &color);
	Status __fastcall SetColor(unsigned color);
public:
	#pragma option push -w-inl
	/* TGPBrush.Destroy */ inline __fastcall virtual ~TGPSolidBrush(void) { }
	#pragma option pop
	
};


class DELPHICLASS TGPTextureBrush;
class PASCALIMPLEMENTATION TGPTextureBrush : public TGPBrush 
{
	typedef TGPBrush inherited;
	
public:
	__fastcall TGPTextureBrush(TGPImage* image, WrapMode wrapMode)/* overload */;
	__fastcall TGPTextureBrush(TGPImage* image, WrapMode wrapMode, const Gdipapi::TGPRectF &dstRect)/* overload */;
	__fastcall TGPTextureBrush(TGPImage* image, const Gdipapi::TGPRectF &dstRect, TGPImageAttributes* imageAttributes)/* overload */;
	__fastcall TGPTextureBrush(TGPImage* image, const Gdipapi::TGPRect &dstRect, TGPImageAttributes* imageAttributes)/* overload */;
	__fastcall TGPTextureBrush(TGPImage* image, WrapMode wrapMode, const Gdipapi::TGPRect &dstRect)/* overload */;
	__fastcall TGPTextureBrush(TGPImage* image, WrapMode wrapMode, float dstX, float dstY, float dstWidth, float dstHeight)/* overload */;
	__fastcall TGPTextureBrush(TGPImage* image, WrapMode wrapMode, int dstX, int dstY, int dstWidth, int dstHeight)/* overload */;
	__fastcall TGPTextureBrush(void)/* overload */;
	Status __fastcall SetTransform(TGPMatrix* matrix);
	Status __fastcall GetTransform(TGPMatrix* matrix);
	Status __fastcall ResetTransform(void);
	Status __fastcall MultiplyTransform(TGPMatrix* matrix, MatrixOrder order = (MatrixOrder)(0x0));
	Status __fastcall TranslateTransform(float dx, float dy, MatrixOrder order = (MatrixOrder)(0x0));
	Status __fastcall ScaleTransform(float sx, float sy, MatrixOrder order = (MatrixOrder)(0x0));
	Status __fastcall RotateTransform(float angle, MatrixOrder order = (MatrixOrder)(0x0));
	Status __fastcall SetWrapMode(WrapMode wrapMode);
	WrapMode __fastcall GetWrapMode(void);
	TGPImage* __fastcall GetImage(void);
public:
	#pragma option push -w-inl
	/* TGPBrush.Destroy */ inline __fastcall virtual ~TGPTextureBrush(void) { }
	#pragma option pop
	
};


class DELPHICLASS TGPLinearGradientBrush;
class PASCALIMPLEMENTATION TGPLinearGradientBrush : public TGPBrush 
{
	typedef TGPBrush inherited;
	
public:
	__fastcall TGPLinearGradientBrush(void)/* overload */;
	__fastcall TGPLinearGradientBrush(const Gdipapi::TGPPointF &point1, const Gdipapi::TGPPointF &point2, unsigned color1, unsigned color2)/* overload */;
	__fastcall TGPLinearGradientBrush(const Gdipapi::TGPPoint &point1, const Gdipapi::TGPPoint &point2, unsigned color1, unsigned color2)/* overload */;
	__fastcall TGPLinearGradientBrush(const Gdipapi::TGPRectF &rect, unsigned color1, unsigned color2, LinearGradientMode mode)/* overload */;
	__fastcall TGPLinearGradientBrush(const Gdipapi::TGPRect &rect, unsigned color1, unsigned color2, LinearGradientMode mode)/* overload */;
	__fastcall TGPLinearGradientBrush(const Gdipapi::TGPRectF &rect, unsigned color1, unsigned color2, float angle, BOOL isAngleScalable)/* overload */;
	__fastcall TGPLinearGradientBrush(const Gdipapi::TGPRect &rect, unsigned color1, unsigned color2, float angle, BOOL isAngleScalable)/* overload */;
	Status __fastcall SetLinearColors(unsigned color1, unsigned color2);
	Status __fastcall GetLinearColors(/* out */ unsigned &color1, /* out */ unsigned &color2);
	Status __fastcall GetRectangle(/* out */ Gdipapi::TGPRectF &rect)/* overload */;
	Status __fastcall GetRectangle(/* out */ Gdipapi::TGPRect &rect)/* overload */;
	Status __fastcall SetGammaCorrection(BOOL useGammaCorrection);
	BOOL __fastcall GetGammaCorrection(void);
	int __fastcall GetBlendCount(void);
	Status __fastcall SetBlend(Windows::PSingle blendFactors, Windows::PSingle blendPositions, int count);
	Status __fastcall GetBlend(Windows::PSingle blendFactors, Windows::PSingle blendPositions, int count);
	int __fastcall GetInterpolationColorCount(void);
	Status __fastcall SetInterpolationColors(Gdipapi::PGPColor presetColors, Windows::PSingle blendPositions, int count);
	Status __fastcall GetInterpolationColors(Gdipapi::PGPColor presetColors, Windows::PSingle blendPositions, int count);
	Status __fastcall SetBlendBellShape(float focus, float scale = 1.000000E+00);
	Status __fastcall SetBlendTriangularShape(float focus, float scale = 1.000000E+00);
	Status __fastcall SetTransform(TGPMatrix* matrix);
	Status __fastcall GetTransform(TGPMatrix* matrix);
	Status __fastcall ResetTransform(void);
	Status __fastcall MultiplyTransform(TGPMatrix* matrix, MatrixOrder order = (MatrixOrder)(0x0));
	Status __fastcall TranslateTransform(float dx, float dy, MatrixOrder order = (MatrixOrder)(0x0));
	Status __fastcall ScaleTransform(float sx, float sy, MatrixOrder order = (MatrixOrder)(0x0));
	Status __fastcall RotateTransform(float angle, MatrixOrder order = (MatrixOrder)(0x0));
	Status __fastcall SetWrapMode(WrapMode wrapMode);
	WrapMode __fastcall GetWrapMode(void);
public:
	#pragma option push -w-inl
	/* TGPBrush.Destroy */ inline __fastcall virtual ~TGPLinearGradientBrush(void) { }
	#pragma option pop
	
};


class DELPHICLASS TGPHatchBrush;
class PASCALIMPLEMENTATION TGPHatchBrush : public TGPBrush 
{
	typedef TGPBrush inherited;
	
public:
	__fastcall TGPHatchBrush(void)/* overload */;
	__fastcall TGPHatchBrush(HatchStyle hatchStyle, unsigned foreColor, unsigned backColor)/* overload */;
	HatchStyle __fastcall GetHatchStyle(void);
	Status __fastcall GetForegroundColor(/* out */ unsigned &color);
	Status __fastcall GetBackgroundColor(/* out */ unsigned &color);
public:
	#pragma option push -w-inl
	/* TGPBrush.Destroy */ inline __fastcall virtual ~TGPHatchBrush(void) { }
	#pragma option pop
	
};


class DELPHICLASS TGPPen;
class PASCALIMPLEMENTATION TGPPen : public Gdipapi::TGdiplusBase 
{
	typedef Gdipapi::TGdiplusBase inherited;
	
protected:
	void *nativePen;
	Status lastResult;
	void __fastcall SetNativePen(void * nativePen);
	Status __fastcall SetStatus(Status status);
	__fastcall TGPPen(void * nativePen, Status status)/* overload */;
	
public:
	__fastcall TGPPen(unsigned color, float width)/* overload */;
	__fastcall TGPPen(TGPBrush* brush, float width)/* overload */;
	__fastcall virtual ~TGPPen(void);
	TGPPen* __fastcall Clone(void);
	Status __fastcall SetWidth(float width);
	float __fastcall GetWidth(void);
	Status __fastcall SetLineCap(int startCap, int endCap, int dashCap);
	Status __fastcall SetStartCap(int startCap);
	Status __fastcall SetEndCap(int endCap);
	Status __fastcall SetDashCap(int dashCap);
	int __fastcall GetStartCap(void);
	int __fastcall GetEndCap(void);
	int __fastcall GetDashCap(void);
	Status __fastcall SetLineJoin(LineJoin lineJoin);
	LineJoin __fastcall GetLineJoin(void);
	Status __fastcall SetCustomStartCap(TGPCustomLineCap* customCap);
	Status __fastcall GetCustomStartCap(TGPCustomLineCap* customCap);
	Status __fastcall SetCustomEndCap(TGPCustomLineCap* customCap);
	Status __fastcall GetCustomEndCap(TGPCustomLineCap* customCap);
	Status __fastcall SetMiterLimit(float miterLimit);
	float __fastcall GetMiterLimit(void);
	Status __fastcall SetAlignment(PenAlignment penAlignment);
	PenAlignment __fastcall GetAlignment(void);
	Status __fastcall SetTransform(TGPMatrix* matrix);
	Status __fastcall GetTransform(TGPMatrix* matrix);
	Status __fastcall ResetTransform(void);
	Status __fastcall MultiplyTransform(TGPMatrix* matrix, MatrixOrder order = (MatrixOrder)(0x0));
	Status __fastcall TranslateTransform(float dx, float dy, MatrixOrder order = (MatrixOrder)(0x0));
	Status __fastcall ScaleTransform(float sx, float sy, MatrixOrder order = (MatrixOrder)(0x0));
	Status __fastcall RotateTransform(float angle, MatrixOrder order = (MatrixOrder)(0x0));
	int __fastcall GetPenType(void);
	Status __fastcall SetColor(unsigned color);
	Status __fastcall SetBrush(TGPBrush* brush);
	Status __fastcall GetColor(/* out */ unsigned &Color);
	TGPBrush* __fastcall GetBrush(void);
	DashStyle __fastcall GetDashStyle(void);
	Status __fastcall SetDashStyle(DashStyle dashStyle);
	float __fastcall GetDashOffset(void);
	Status __fastcall SetDashOffset(float dashOffset);
	Status __fastcall SetDashPattern(Windows::PSingle dashArray, int count);
	int __fastcall GetDashPatternCount(void);
	Status __fastcall GetDashPattern(Windows::PSingle dashArray, int count);
	Status __fastcall SetCompoundArray(Windows::PSingle compoundArray, int count);
	int __fastcall GetCompoundArrayCount(void);
	Status __fastcall GetCompoundArray(Windows::PSingle compoundArray, int count);
	Status __fastcall GetLastStatus(void);
};


class DELPHICLASS TGPStringFormat;
class PASCALIMPLEMENTATION TGPStringFormat : public Gdipapi::TGdiplusBase 
{
	typedef Gdipapi::TGdiplusBase inherited;
	
protected:
	void *nativeFormat;
	Status lastError;
	Status __fastcall SetStatus(Status newStatus);
	void __fastcall Assign(TGPStringFormat* source);
	__fastcall TGPStringFormat(void * clonedStringFormat, Status status)/* overload */;
	
public:
	__fastcall TGPStringFormat(int formatFlags, Word language)/* overload */;
	__fastcall TGPStringFormat(TGPStringFormat* format)/* overload */;
	__fastcall virtual ~TGPStringFormat(void);
	/*         class method */ static TGPStringFormat* __fastcall GenericDefault(TMetaClass* vmt);
	/*         class method */ static TGPStringFormat* __fastcall GenericTypographic(TMetaClass* vmt);
	TGPStringFormat* __fastcall Clone(void);
	Status __fastcall SetFormatFlags(int flags);
	int __fastcall GetFormatFlags(void);
	Status __fastcall SetAlignment(StringAlignment align);
	StringAlignment __fastcall GetAlignment(void);
	Status __fastcall SetLineAlignment(StringAlignment align);
	StringAlignment __fastcall GetLineAlignment(void);
	Status __fastcall SetHotkeyPrefix(HotkeyPrefix hotkeyPrefix);
	HotkeyPrefix __fastcall GetHotkeyPrefix(void);
	Status __fastcall SetTabStops(float firstTabOffset, int count, Windows::PSingle tabStops);
	int __fastcall GetTabStopCount(void);
	Status __fastcall GetTabStops(int count, Windows::PSingle firstTabOffset, Windows::PSingle tabStops);
	Status __fastcall SetDigitSubstitution(Word language, StringDigitSubstitute substitute);
	Word __fastcall GetDigitSubstitutionLanguage(void);
	StringDigitSubstitute __fastcall GetDigitSubstitutionMethod(void);
	Status __fastcall SetTrimming(StringTrimming trimming);
	StringTrimming __fastcall GetTrimming(void);
	Status __fastcall SetMeasurableCharacterRanges(int rangeCount, Gdipapi::PCharacterRange ranges);
	int __fastcall GetMeasurableCharacterRangeCount(void);
	Status __fastcall GetLastStatus(void);
};


class PASCALIMPLEMENTATION TGPGraphicsPath : public Gdipapi::TGdiplusBase 
{
	typedef Gdipapi::TGdiplusBase inherited;
	
protected:
	void *nativePath;
	Status lastResult;
	void __fastcall SetNativePath(void * nativePath);
	Status __fastcall SetStatus(Status status);
	__fastcall TGPGraphicsPath(void * nativePath)/* overload */;
	
public:
	__fastcall TGPGraphicsPath(TGPGraphicsPath* path)/* overload */;
	__fastcall TGPGraphicsPath(FillMode fillMode)/* overload */;
	__fastcall TGPGraphicsPath(Gdipapi::PGPPointF points, System::PByte types, int count, FillMode fillMode)/* overload */;
	__fastcall TGPGraphicsPath(Gdipapi::PGPPoint points, System::PByte types, int count, FillMode fillMode)/* overload */;
	__fastcall virtual ~TGPGraphicsPath(void);
	TGPGraphicsPath* __fastcall Clone(void);
	Status __fastcall Reset(void);
	FillMode __fastcall GetFillMode(void);
	Status __fastcall SetFillMode(FillMode fillmode);
	Status __fastcall GetPathData(Gdipapi::TPathData* pathData);
	Status __fastcall StartFigure(void);
	Status __fastcall CloseFigure(void);
	Status __fastcall CloseAllFigures(void);
	Status __fastcall SetMarker(void);
	Status __fastcall ClearMarkers(void);
	Status __fastcall Reverse(void);
	Status __fastcall GetLastPoint(/* out */ Gdipapi::TGPPointF &lastPoint);
	Status __fastcall AddLine(const Gdipapi::TGPPointF &pt1, const Gdipapi::TGPPointF &pt2)/* overload */;
	Status __fastcall AddLine(float x1, float y1, float x2, float y2)/* overload */;
	Status __fastcall AddLines(Gdipapi::PGPPointF points, int count)/* overload */;
	Status __fastcall AddLine(const Gdipapi::TGPPoint &pt1, const Gdipapi::TGPPoint &pt2)/* overload */;
	Status __fastcall AddLine(int x1, int y1, int x2, int y2)/* overload */;
	Status __fastcall AddLines(Gdipapi::PGPPoint points, int count)/* overload */;
	Status __fastcall AddArc(const Gdipapi::TGPRectF &rect, float startAngle, float sweepAngle)/* overload */;
	Status __fastcall AddArc(float x, float y, float width, float height, float startAngle, float sweepAngle)/* overload */;
	Status __fastcall AddArc(const Gdipapi::TGPRect &rect, float startAngle, float sweepAngle)/* overload */;
	Status __fastcall AddArc(int x, int y, int width, int height, float startAngle, float sweepAngle)/* overload */;
	Status __fastcall AddBezier(const Gdipapi::TGPPointF &pt1, const Gdipapi::TGPPointF &pt2, const Gdipapi::TGPPointF &pt3, const Gdipapi::TGPPointF &pt4)/* overload */;
	Status __fastcall AddBezier(float x1, float y1, float x2, float y2, float x3, float y3, float x4, float y4)/* overload */;
	Status __fastcall AddBeziers(Gdipapi::PGPPointF points, int count)/* overload */;
	Status __fastcall AddBezier(const Gdipapi::TGPPoint &pt1, const Gdipapi::TGPPoint &pt2, const Gdipapi::TGPPoint &pt3, const Gdipapi::TGPPoint &pt4)/* overload */;
	Status __fastcall AddBezier(int x1, int y1, int x2, int y2, int x3, int y3, int x4, int y4)/* overload */;
	Status __fastcall AddBeziers(Gdipapi::PGPPoint points, int count)/* overload */;
	Status __fastcall AddCurve(Gdipapi::PGPPointF points, int count)/* overload */;
	Status __fastcall AddCurve(Gdipapi::PGPPointF points, int count, float tension)/* overload */;
	Status __fastcall AddCurve(Gdipapi::PGPPointF points, int count, int offset, int numberOfSegments, float tension)/* overload */;
	Status __fastcall AddCurve(Gdipapi::PGPPoint points, int count)/* overload */;
	Status __fastcall AddCurve(Gdipapi::PGPPoint points, int count, float tension)/* overload */;
	Status __fastcall AddCurve(Gdipapi::PGPPoint points, int count, int offset, int numberOfSegments, float tension)/* overload */;
	Status __fastcall AddClosedCurve(Gdipapi::PGPPointF points, int count)/* overload */;
	Status __fastcall AddClosedCurve(Gdipapi::PGPPointF points, int count, float tension)/* overload */;
	Status __fastcall AddClosedCurve(Gdipapi::PGPPoint points, int count)/* overload */;
	Status __fastcall AddClosedCurve(Gdipapi::PGPPoint points, int count, float tension)/* overload */;
	Status __fastcall AddRectangle(const Gdipapi::TGPRectF &rect)/* overload */;
	Status __fastcall AddRectangles(Gdipapi::PGPRectF rects, int count)/* overload */;
	Status __fastcall AddRectangle(const Gdipapi::TGPRect &rect)/* overload */;
	Status __fastcall AddRectangles(Gdipapi::PGPRect rects, int count)/* overload */;
	Status __fastcall AddEllipse(const Gdipapi::TGPRectF &rect)/* overload */;
	Status __fastcall AddEllipse(float x, float y, float width, float height)/* overload */;
	Status __fastcall AddEllipse(const Gdipapi::TGPRect &rect)/* overload */;
	Status __fastcall AddEllipse(int x, int y, int width, int height)/* overload */;
	Status __fastcall AddPie(const Gdipapi::TGPRectF &rect, float startAngle, float sweepAngle)/* overload */;
	Status __fastcall AddPie(float x, float y, float width, float height, float startAngle, float sweepAngle)/* overload */;
	Status __fastcall AddPie(const Gdipapi::TGPRect &rect, float startAngle, float sweepAngle)/* overload */;
	Status __fastcall AddPie(int x, int y, int width, int height, float startAngle, float sweepAngle)/* overload */;
	Status __fastcall AddPolygon(Gdipapi::PGPPointF points, int count)/* overload */;
	Status __fastcall AddPolygon(Gdipapi::PGPPoint points, int count)/* overload */;
	Status __fastcall AddPath(TGPGraphicsPath* addingPath, BOOL connect);
	Status __fastcall AddString(WideString string_, int length, TGPFontFamily* family, int style, float emSize, const Gdipapi::TGPPointF &origin, TGPStringFormat* format)/* overload */;
	Status __fastcall AddString(WideString string_, int length, TGPFontFamily* family, int style, float emSize, const Gdipapi::TGPRectF &layoutRect, TGPStringFormat* format)/* overload */;
	Status __fastcall AddString(WideString string_, int length, TGPFontFamily* family, int style, float emSize, const Gdipapi::TGPPoint &origin, TGPStringFormat* format)/* overload */;
	Status __fastcall AddString(WideString string_, int length, TGPFontFamily* family, int style, float emSize, const Gdipapi::TGPRect &layoutRect, TGPStringFormat* format)/* overload */;
	Status __fastcall Transform(TGPMatrix* matrix);
	Status __fastcall GetBounds(/* out */ Gdipapi::TGPRectF &bounds, TGPMatrix* matrix = (TGPMatrix*)(0x0), TGPPen* pen = (TGPPen*)(0x0))/* overload */;
	Status __fastcall GetBounds(/* out */ Gdipapi::TGPRect &bounds, TGPMatrix* matrix = (TGPMatrix*)(0x0), TGPPen* pen = (TGPPen*)(0x0))/* overload */;
	Status __fastcall Flatten(TGPMatrix* matrix = (TGPMatrix*)(0x0), float flatness = 2.500000E-01);
	Status __fastcall Widen(TGPPen* pen, TGPMatrix* matrix = (TGPMatrix*)(0x0), float flatness = 2.500000E-01);
	Status __fastcall Outline(TGPMatrix* matrix = (TGPMatrix*)(0x0), float flatness = 2.500000E-01);
	Status __fastcall Warp(Gdipapi::PGPPointF destPoints, int count, const Gdipapi::TGPRectF &srcRect, TGPMatrix* matrix = (TGPMatrix*)(0x0), WarpMode warpMode = (WarpMode)(0x0), float flatness = 2.500000E-01);
	int __fastcall GetPointCount(void);
	Status __fastcall GetPathTypes(System::PByte types, int count);
	Status __fastcall GetPathPoints(Gdipapi::PGPPointF points, int count)/* overload */;
	Status __fastcall GetPathPoints(Gdipapi::PGPPoint points, int count)/* overload */;
	Status __fastcall GetLastStatus(void);
	BOOL __fastcall IsVisible(const Gdipapi::TGPPointF &point, TGPGraphics* g = (TGPGraphics*)(0x0))/* overload */;
	BOOL __fastcall IsVisible(float x, float y, TGPGraphics* g = (TGPGraphics*)(0x0))/* overload */;
	BOOL __fastcall IsVisible(const Gdipapi::TGPPoint &point, TGPGraphics* g = (TGPGraphics*)(0x0))/* overload */;
	BOOL __fastcall IsVisible(int x, int y, TGPGraphics* g = (TGPGraphics*)(0x0))/* overload */;
	BOOL __fastcall IsOutlineVisible(const Gdipapi::TGPPointF &point, TGPPen* pen, TGPGraphics* g = (TGPGraphics*)(0x0))/* overload */;
	BOOL __fastcall IsOutlineVisible(float x, float y, TGPPen* pen, TGPGraphics* g = (TGPGraphics*)(0x0))/* overload */;
	BOOL __fastcall IsOutlineVisible(const Gdipapi::TGPPoint &point, TGPPen* pen, TGPGraphics* g = (TGPGraphics*)(0x0))/* overload */;
	BOOL __fastcall IsOutlineVisible(int x, int y, TGPPen* pen, TGPGraphics* g = (TGPGraphics*)(0x0))/* overload */;
};


class DELPHICLASS TGPGraphicsPathIterator;
class PASCALIMPLEMENTATION TGPGraphicsPathIterator : public Gdipapi::TGdiplusBase 
{
	typedef Gdipapi::TGdiplusBase inherited;
	
protected:
	void *nativeIterator;
	Status lastResult;
	void __fastcall SetNativeIterator(void * nativeIterator);
	Status __fastcall SetStatus(Status status);
	
public:
	__fastcall TGPGraphicsPathIterator(TGPGraphicsPath* path);
	__fastcall virtual ~TGPGraphicsPathIterator(void);
	int __fastcall NextSubpath(/* out */ int &startIndex, /* out */ int &endIndex, /* out */ BOOL &isClosed)/* overload */;
	int __fastcall NextSubpath(TGPGraphicsPath* path, /* out */ BOOL &isClosed)/* overload */;
	int __fastcall NextPathType(/* out */ Byte &pathType, /* out */ int &startIndex, /* out */ int &endIndex);
	int __fastcall NextMarker(/* out */ int &startIndex, /* out */ int &endIndex)/* overload */;
	int __fastcall NextMarker(TGPGraphicsPath* path)/* overload */;
	int __fastcall GetCount(void);
	int __fastcall GetSubpathCount(void);
	BOOL __fastcall HasCurve(void);
	void __fastcall Rewind(void);
	int __fastcall Enumerate(Gdipapi::PGPPointF points, System::PByte types, int count);
	int __fastcall CopyData(Gdipapi::PGPPointF points, System::PByte types, int startIndex, int endIndex);
	Status __fastcall GetLastStatus(void);
};


class DELPHICLASS TGPPathGradientBrush;
class PASCALIMPLEMENTATION TGPPathGradientBrush : public TGPBrush 
{
	typedef TGPBrush inherited;
	
public:
	__fastcall TGPPathGradientBrush(Gdipapi::PGPPointF points, int count, WrapMode wrapMode)/* overload */;
	__fastcall TGPPathGradientBrush(Gdipapi::PGPPoint points, int count, WrapMode wrapMode)/* overload */;
	__fastcall TGPPathGradientBrush(TGPGraphicsPath* path)/* overload */;
	__fastcall TGPPathGradientBrush(void)/* overload */;
	Status __fastcall GetCenterColor(/* out */ unsigned &Color);
	Status __fastcall SetCenterColor(unsigned color);
	int __fastcall GetPointCount(void);
	int __fastcall GetSurroundColorCount(void);
	Status __fastcall GetSurroundColors(Gdipapi::PARGB colors, int &count);
	Status __fastcall SetSurroundColors(Gdipapi::PARGB colors, int &count);
	Status __fastcall GetGraphicsPath(TGPGraphicsPath* path);
	Status __fastcall SetGraphicsPath(TGPGraphicsPath* path);
	Status __fastcall GetCenterPoint(/* out */ Gdipapi::TGPPointF &point)/* overload */;
	Status __fastcall GetCenterPoint(/* out */ Gdipapi::TGPPoint &point)/* overload */;
	Status __fastcall SetCenterPoint(const Gdipapi::TGPPointF &point)/* overload */;
	Status __fastcall SetCenterPoint(const Gdipapi::TGPPoint &point)/* overload */;
	Status __fastcall GetRectangle(/* out */ Gdipapi::TGPRectF &rect)/* overload */;
	Status __fastcall GetRectangle(/* out */ Gdipapi::TGPRect &rect)/* overload */;
	Status __fastcall SetGammaCorrection(BOOL useGammaCorrection)/* overload */;
	BOOL __fastcall GetGammaCorrection(void)/* overload */;
	int __fastcall GetBlendCount(void);
	Status __fastcall GetBlend(Windows::PSingle blendFactors, Windows::PSingle blendPositions, int count);
	Status __fastcall SetBlend(Windows::PSingle blendFactors, Windows::PSingle blendPositions, int count);
	int __fastcall GetInterpolationColorCount(void);
	Status __fastcall SetInterpolationColors(Gdipapi::PARGB presetColors, Windows::PSingle blendPositions, int count);
	Status __fastcall GetInterpolationColors(Gdipapi::PARGB presetColors, Windows::PSingle blendPositions, int count);
	Status __fastcall SetBlendBellShape(float focus, float scale = 1.000000E+00);
	Status __fastcall SetBlendTriangularShape(float focus, float scale = 1.000000E+00);
	Status __fastcall GetTransform(TGPMatrix* matrix);
	Status __fastcall SetTransform(TGPMatrix* matrix);
	Status __fastcall ResetTransform(void);
	Status __fastcall MultiplyTransform(TGPMatrix* matrix, MatrixOrder order = (MatrixOrder)(0x0));
	Status __fastcall TranslateTransform(float dx, float dy, MatrixOrder order = (MatrixOrder)(0x0));
	Status __fastcall ScaleTransform(float sx, float sy, MatrixOrder order = (MatrixOrder)(0x0));
	Status __fastcall RotateTransform(float angle, MatrixOrder order = (MatrixOrder)(0x0));
	Status __fastcall GetFocusScales(/* out */ float &xScale, /* out */ float &yScale);
	Status __fastcall SetFocusScales(float xScale, float yScale);
	WrapMode __fastcall GetWrapMode(void);
	Status __fastcall SetWrapMode(WrapMode wrapMode);
public:
	#pragma option push -w-inl
	/* TGPBrush.Destroy */ inline __fastcall virtual ~TGPPathGradientBrush(void) { }
	#pragma option pop
	
};


class DELPHICLASS TGPMetafile;
class PASCALIMPLEMENTATION TGPGraphics : public Gdipapi::TGdiplusBase 
{
	typedef Gdipapi::TGdiplusBase inherited;
	
protected:
	void *FnativeGraphics;
	Status lastResult;
	void __fastcall SetNativeGraphics(void * graphics);
	Status __fastcall SetStatus(Status status);
	void * __fastcall GetNativeGraphics(void);
	void * __fastcall GetNativePen(TGPPen* pen);
	__fastcall TGPGraphics(void * graphics)/* overload */;
	
public:
	TGPGraphics* __fastcall FromHDC(HDC hdc)/* overload */;
	TGPGraphics* __fastcall FromHDC(HDC hdc, unsigned hdevice)/* overload */;
	TGPGraphics* __fastcall FromHWND(HWND hwnd, BOOL icm = false);
	TGPGraphics* __fastcall FromImage(TGPImage* image);
	__fastcall TGPGraphics(HDC hdc)/* overload */;
	__fastcall TGPGraphics(HDC hdc, unsigned hdevice)/* overload */;
	__fastcall TGPGraphics(HWND hwnd, BOOL icm)/* overload */;
	__fastcall TGPGraphics(TGPImage* image)/* overload */;
	__fastcall TGPGraphics(void * Graphics, int Dummy);
	__fastcall virtual ~TGPGraphics(void);
	void __fastcall Flush(FlushIntention intention = (FlushIntention)(0x0));
	HDC __fastcall GetHDC(void);
	void __fastcall ReleaseHDC(HDC hdc);
	Status __fastcall SetRenderingOrigin(int x, int y);
	Status __fastcall GetRenderingOrigin(/* out */ int &x, /* out */ int &y);
	Status __fastcall SetCompositingMode(CompositingMode compositingMode);
	CompositingMode __fastcall GetCompositingMode(void);
	Status __fastcall SetCompositingQuality(int compositingQuality);
	int __fastcall GetCompositingQuality(void);
	Status __fastcall SetTextRenderingHint(TextRenderingHint newMode);
	TextRenderingHint __fastcall GetTextRenderingHint(void);
	Status __fastcall SetTextContrast(unsigned contrast);
	unsigned __fastcall GetTextContrast(void);
	int __fastcall GetInterpolationMode(void);
	Status __fastcall SetInterpolationMode(int interpolationMode);
	int __fastcall GetSmoothingMode(void);
	Status __fastcall SetSmoothingMode(int smoothingMode);
	int __fastcall GetPixelOffsetMode(void);
	Status __fastcall SetPixelOffsetMode(int pixelOffsetMode);
	Status __fastcall SetTransform(TGPMatrix* matrix);
	Status __fastcall ResetTransform(void);
	Status __fastcall MultiplyTransform(TGPMatrix* matrix, MatrixOrder order = (MatrixOrder)(0x0));
	Status __fastcall TranslateTransform(float dx, float dy, MatrixOrder order = (MatrixOrder)(0x0));
	Status __fastcall ScaleTransform(float sx, float sy, MatrixOrder order = (MatrixOrder)(0x0));
	Status __fastcall RotateTransform(float angle, MatrixOrder order = (MatrixOrder)(0x0));
	Status __fastcall GetTransform(TGPMatrix* matrix);
	Status __fastcall SetPageUnit(Gdipapi::Unit_ unit_);
	Status __fastcall SetPageScale(float scale);
	Gdipapi::Unit_ __fastcall GetPageUnit(void);
	float __fastcall GetPageScale(void);
	float __fastcall GetDpiX(void);
	float __fastcall GetDpiY(void);
	Status __fastcall TransformPoints(CoordinateSpace destSpace, CoordinateSpace srcSpace, Gdipapi::PGPPointF pts, int count)/* overload */;
	Status __fastcall TransformPoints(CoordinateSpace destSpace, CoordinateSpace srcSpace, Gdipapi::PGPPoint pts, int count)/* overload */;
	Status __fastcall GetNearestColor(unsigned &color);
	Status __fastcall DrawLine(TGPPen* pen, float x1, float y1, float x2, float y2)/* overload */;
	Status __fastcall DrawLine(TGPPen* pen, const Gdipapi::TGPPointF &pt1, const Gdipapi::TGPPointF &pt2)/* overload */;
	Status __fastcall DrawLines(TGPPen* pen, Gdipapi::PGPPointF points, int count)/* overload */;
	Status __fastcall DrawLine(TGPPen* pen, int x1, int y1, int x2, int y2)/* overload */;
	Status __fastcall DrawLine(TGPPen* pen, const Gdipapi::TGPPoint &pt1, const Gdipapi::TGPPoint &pt2)/* overload */;
	Status __fastcall DrawLines(TGPPen* pen, Gdipapi::PGPPoint points, int count)/* overload */;
	Status __fastcall DrawArc(TGPPen* pen, float x, float y, float width, float height, float startAngle, float sweepAngle)/* overload */;
	Status __fastcall DrawArc(TGPPen* pen, const Gdipapi::TGPRectF &rect, float startAngle, float sweepAngle)/* overload */;
	Status __fastcall DrawArc(TGPPen* pen, int x, int y, int width, int height, float startAngle, float sweepAngle)/* overload */;
	Status __fastcall DrawArc(TGPPen* pen, const Gdipapi::TGPRect &rect, float startAngle, float sweepAngle)/* overload */;
	Status __fastcall DrawBezier(TGPPen* pen, float x1, float y1, float x2, float y2, float x3, float y3, float x4, float y4)/* overload */;
	Status __fastcall DrawBezier(TGPPen* pen, const Gdipapi::TGPPointF &pt1, const Gdipapi::TGPPointF &pt2, const Gdipapi::TGPPointF &pt3, const Gdipapi::TGPPointF &pt4)/* overload */;
	Status __fastcall DrawBeziers(TGPPen* pen, Gdipapi::PGPPointF points, int count)/* overload */;
	Status __fastcall DrawBezier(TGPPen* pen, int x1, int y1, int x2, int y2, int x3, int y3, int x4, int y4)/* overload */;
	Status __fastcall DrawBezier(TGPPen* pen, const Gdipapi::TGPPoint &pt1, const Gdipapi::TGPPoint &pt2, const Gdipapi::TGPPoint &pt3, const Gdipapi::TGPPoint &pt4)/* overload */;
	Status __fastcall DrawBeziers(TGPPen* pen, Gdipapi::PGPPoint points, int count)/* overload */;
	Status __fastcall DrawRectangle(TGPPen* pen, const Gdipapi::TGPRectF &rect)/* overload */;
	Status __fastcall DrawRectangle(TGPPen* pen, float x, float y, float width, float height)/* overload */;
	Status __fastcall DrawRectangles(TGPPen* pen, Gdipapi::PGPRectF rects, int count)/* overload */;
	Status __fastcall DrawRectangle(TGPPen* pen, const Gdipapi::TGPRect &rect)/* overload */;
	Status __fastcall DrawRectangle(TGPPen* pen, int x, int y, int width, int height)/* overload */;
	Status __fastcall DrawRectangles(TGPPen* pen, Gdipapi::PGPRect rects, int count)/* overload */;
	Status __fastcall DrawEllipse(TGPPen* pen, const Gdipapi::TGPRectF &rect)/* overload */;
	Status __fastcall DrawEllipse(TGPPen* pen, float x, float y, float width, float height)/* overload */;
	Status __fastcall DrawEllipse(TGPPen* pen, const Gdipapi::TGPRect &rect)/* overload */;
	Status __fastcall DrawEllipse(TGPPen* pen, int x, int y, int width, int height)/* overload */;
	Status __fastcall DrawPie(TGPPen* pen, const Gdipapi::TGPRectF &rect, float startAngle, float sweepAngle)/* overload */;
	Status __fastcall DrawPie(TGPPen* pen, float x, float y, float width, float height, float startAngle, float sweepAngle)/* overload */;
	Status __fastcall DrawPie(TGPPen* pen, const Gdipapi::TGPRect &rect, float startAngle, float sweepAngle)/* overload */;
	Status __fastcall DrawPie(TGPPen* pen, int x, int y, int width, int height, float startAngle, float sweepAngle)/* overload */;
	Status __fastcall DrawPolygon(TGPPen* pen, Gdipapi::PGPPointF points, int count)/* overload */;
	Status __fastcall DrawPolygon(TGPPen* pen, Gdipapi::PGPPoint points, int count)/* overload */;
	Status __fastcall DrawPath(TGPPen* pen, TGPGraphicsPath* path);
	Status __fastcall DrawCurve(TGPPen* pen, Gdipapi::PGPPointF points, int count)/* overload */;
	Status __fastcall DrawCurve(TGPPen* pen, Gdipapi::PGPPointF points, int count, float tension)/* overload */;
	Status __fastcall DrawCurve(TGPPen* pen, Gdipapi::PGPPointF points, int count, int offset, int numberOfSegments, float tension = 5.000000E-01)/* overload */;
	Status __fastcall DrawCurve(TGPPen* pen, Gdipapi::PGPPoint points, int count)/* overload */;
	Status __fastcall DrawCurve(TGPPen* pen, Gdipapi::PGPPoint points, int count, float tension)/* overload */;
	Status __fastcall DrawCurve(TGPPen* pen, Gdipapi::PGPPoint points, int count, int offset, int numberOfSegments, float tension = 5.000000E-01)/* overload */;
	Status __fastcall DrawClosedCurve(TGPPen* pen, Gdipapi::PGPPointF points, int count)/* overload */;
	Status __fastcall DrawClosedCurve(TGPPen* pen, Gdipapi::PGPPointF points, int count, float tension)/* overload */;
	Status __fastcall DrawClosedCurve(TGPPen* pen, Gdipapi::PGPPoint points, int count)/* overload */;
	Status __fastcall DrawClosedCurve(TGPPen* pen, Gdipapi::PGPPoint points, int count, float tension)/* overload */;
	Status __fastcall Clear(unsigned color);
	Status __fastcall FillRectangle(TGPBrush* brush, const Gdipapi::TGPRectF &rect)/* overload */;
	Status __fastcall FillRectangle(TGPBrush* brush, float x, float y, float width, float height)/* overload */;
	Status __fastcall FillRectangles(TGPBrush* brush, Gdipapi::PGPRectF rects, int count)/* overload */;
	Status __fastcall FillRectangle(TGPBrush* brush, const Gdipapi::TGPRect &rect)/* overload */;
	Status __fastcall FillRectangle(TGPBrush* brush, int x, int y, int width, int height)/* overload */;
	Status __fastcall FillRectangles(TGPBrush* brush, Gdipapi::PGPRect rects, int count)/* overload */;
	Status __fastcall FillPolygon(TGPBrush* brush, Gdipapi::PGPPointF points, int count)/* overload */;
	Status __fastcall FillPolygon(TGPBrush* brush, Gdipapi::PGPPointF points, int count, FillMode fillMode)/* overload */;
	Status __fastcall FillPolygon(TGPBrush* brush, Gdipapi::PGPPoint points, int count)/* overload */;
	Status __fastcall FillPolygon(TGPBrush* brush, Gdipapi::PGPPoint points, int count, FillMode fillMode)/* overload */;
	Status __fastcall FillEllipse(TGPBrush* brush, const Gdipapi::TGPRectF &rect)/* overload */;
	Status __fastcall FillEllipse(TGPBrush* brush, float x, float y, float width, float height)/* overload */;
	Status __fastcall FillEllipse(TGPBrush* brush, const Gdipapi::TGPRect &rect)/* overload */;
	Status __fastcall FillEllipse(TGPBrush* brush, int x, int y, int width, int height)/* overload */;
	Status __fastcall FillPie(TGPBrush* brush, const Gdipapi::TGPRectF &rect, float startAngle, float sweepAngle)/* overload */;
	Status __fastcall FillPie(TGPBrush* brush, float x, float y, float width, float height, float startAngle, float sweepAngle)/* overload */;
	Status __fastcall FillPie(TGPBrush* brush, const Gdipapi::TGPRect &rect, float startAngle, float sweepAngle)/* overload */;
	Status __fastcall FillPie(TGPBrush* brush, int x, int y, int width, int height, float startAngle, float sweepAngle)/* overload */;
	Status __fastcall FillPath(TGPBrush* brush, TGPGraphicsPath* path);
	Status __fastcall FillClosedCurve(TGPBrush* brush, Gdipapi::PGPPointF points, int count)/* overload */;
	Status __fastcall FillClosedCurve(TGPBrush* brush, Gdipapi::PGPPointF points, int count, FillMode fillMode, float tension = 5.000000E-01)/* overload */;
	Status __fastcall FillClosedCurve(TGPBrush* brush, Gdipapi::PGPPoint points, int count)/* overload */;
	Status __fastcall FillClosedCurve(TGPBrush* brush, Gdipapi::PGPPoint points, int count, FillMode fillMode, float tension = 5.000000E-01)/* overload */;
	Status __fastcall FillRegion(TGPBrush* brush, TGPRegion* region);
	Status __fastcall DrawString(WideString string_, int length, TGPFont* font, const Gdipapi::TGPRectF &layoutRect, TGPStringFormat* stringFormat, TGPBrush* brush)/* overload */;
	Status __fastcall DrawString(WideString string_, int length, TGPFont* font, const Gdipapi::TGPPointF &origin, TGPBrush* brush)/* overload */;
	Status __fastcall DrawString(WideString string_, int length, TGPFont* font, const Gdipapi::TGPPointF &origin, TGPStringFormat* stringFormat, TGPBrush* brush)/* overload */;
	Status __fastcall MeasureString(WideString string_, int length, TGPFont* font, const Gdipapi::TGPRectF &layoutRect, TGPStringFormat* stringFormat, /* out */ Gdipapi::TGPRectF &boundingBox, System::PInteger codepointsFitted = (void *)(0x0), System::PInteger linesFilled = (void *)(0x0))/* overload */;
	Status __fastcall MeasureString(WideString string_, int length, TGPFont* font, const Gdipapi::TGPSizeF &layoutRectSize, TGPStringFormat* stringFormat, /* out */ Gdipapi::TGPSizeF &size, System::PInteger codepointsFitted = (void *)(0x0), System::PInteger linesFilled = (void *)(0x0))/* overload */;
	Status __fastcall MeasureString(WideString string_, int length, TGPFont* font, const Gdipapi::TGPPointF &origin, TGPStringFormat* stringFormat, /* out */ Gdipapi::TGPRectF &boundingBox)/* overload */;
	Status __fastcall MeasureString(WideString string_, int length, TGPFont* font, const Gdipapi::TGPRectF &layoutRect, /* out */ Gdipapi::TGPRectF &boundingBox)/* overload */;
	Status __fastcall MeasureString(WideString string_, int length, TGPFont* font, const Gdipapi::TGPPointF &origin, /* out */ Gdipapi::TGPRectF &boundingBox)/* overload */;
	Status __fastcall MeasureCharacterRanges(WideString string_, int length, TGPFont* font, const Gdipapi::TGPRectF &layoutRect, TGPStringFormat* stringFormat, int regionCount, TGPRegion* const * regions, const int regions_Size)/* overload */;
	Status __fastcall DrawDriverString(Gdipapi::PUINT16 text, int length, TGPFont* font, TGPBrush* brush, Gdipapi::PGPPointF positions, int flags, TGPMatrix* matrix);
	Status __fastcall MeasureDriverString(Gdipapi::PUINT16 text, int length, TGPFont* font, Gdipapi::PGPPointF positions, int flags, TGPMatrix* matrix, /* out */ Gdipapi::TGPRectF &boundingBox);
	Status __fastcall DrawCachedBitmap(TGPCachedBitmap* cb, int x, int y);
	Status __fastcall DrawImage(TGPImage* image, const Gdipapi::TGPPointF &point)/* overload */;
	Status __fastcall DrawImage(TGPImage* image, float x, float y)/* overload */;
	Status __fastcall DrawImage(TGPImage* image, const Gdipapi::TGPRectF &rect)/* overload */;
	Status __fastcall DrawImage(TGPImage* image, float x, float y, float width, float height)/* overload */;
	Status __fastcall DrawImage(TGPImage* image, const Gdipapi::TGPPoint &point)/* overload */;
	Status __fastcall DrawImage(TGPImage* image, int x, int y)/* overload */;
	Status __fastcall DrawImage(TGPImage* image, const Gdipapi::TGPRect &rect)/* overload */;
	Status __fastcall DrawImage(TGPImage* image, int x, int y, int width, int height)/* overload */;
	Status __fastcall DrawImage(TGPImage* image, Gdipapi::PGPPointF destPoints, int count)/* overload */;
	Status __fastcall DrawImage(TGPImage* image, Gdipapi::PGPPoint destPoints, int count)/* overload */;
	Status __fastcall DrawImage(TGPImage* image, float x, float y, float srcx, float srcy, float srcwidth, float srcheight, Gdipapi::Unit_ srcUnit)/* overload */;
	Status __fastcall DrawImage(TGPImage* image, const Gdipapi::TGPRectF &destRect, float srcx, float srcy, float srcwidth, float srcheight, Gdipapi::Unit_ srcUnit, TGPImageAttributes* imageAttributes = (TGPImageAttributes*)(0x0), ImageAbort callback = 0x0, void * callbackData = (void *)(0x0))/* overload */;
	Status __fastcall DrawImage(TGPImage* image, Gdipapi::PGPPointF destPoints, int count, float srcx, float srcy, float srcwidth, float srcheight, Gdipapi::Unit_ srcUnit, TGPImageAttributes* imageAttributes = (TGPImageAttributes*)(0x0), ImageAbort callback = 0x0, void * callbackData = (void *)(0x0))/* overload */;
	Status __fastcall DrawImage(TGPImage* image, int x, int y, int srcx, int srcy, int srcwidth, int srcheight, Gdipapi::Unit_ srcUnit)/* overload */;
	Status __fastcall DrawImage(TGPImage* image, const Gdipapi::TGPRect &destRect, int srcx, int srcy, int srcwidth, int srcheight, Gdipapi::Unit_ srcUnit, TGPImageAttributes* imageAttributes = (TGPImageAttributes*)(0x0), ImageAbort callback = 0x0, void * callbackData = (void *)(0x0))/* overload */;
	Status __fastcall DrawImage(TGPImage* image, Gdipapi::PGPPoint destPoints, int count, int srcx, int srcy, int srcwidth, int srcheight, Gdipapi::Unit_ srcUnit, TGPImageAttributes* imageAttributes = (TGPImageAttributes*)(0x0), ImageAbort callback = 0x0, void * callbackData = (void *)(0x0))/* overload */;
	Status __fastcall EnumerateMetafile(TGPMetafile* metafile, const Gdipapi::TGPPointF &destPoint, EnumerateMetafileProc callback, void * callbackData = (void *)(0x0), TGPImageAttributes* imageAttributes = (TGPImageAttributes*)(0x0))/* overload */;
	Status __fastcall EnumerateMetafile(TGPMetafile* metafile, const Gdipapi::TGPPoint &destPoint, EnumerateMetafileProc callback, void * callbackData = (void *)(0x0), TGPImageAttributes* imageAttributes = (TGPImageAttributes*)(0x0))/* overload */;
	Status __fastcall EnumerateMetafile(TGPMetafile* metafile, const Gdipapi::TGPRectF &destRect, EnumerateMetafileProc callback, void * callbackData = (void *)(0x0), TGPImageAttributes* imageAttributes = (TGPImageAttributes*)(0x0))/* overload */;
	Status __fastcall EnumerateMetafile(TGPMetafile* metafile, const Gdipapi::TGPRect &destRect, EnumerateMetafileProc callback, void * callbackData = (void *)(0x0), TGPImageAttributes* imageAttributes = (TGPImageAttributes*)(0x0))/* overload */;
	Status __fastcall EnumerateMetafile(TGPMetafile* metafile, Gdipapi::PGPPointF destPoints, int count, EnumerateMetafileProc callback, void * callbackData = (void *)(0x0), TGPImageAttributes* imageAttributes = (TGPImageAttributes*)(0x0))/* overload */;
	Status __fastcall EnumerateMetafile(TGPMetafile* metafile, Gdipapi::PGPPoint destPoints, int count, EnumerateMetafileProc callback, void * callbackData = (void *)(0x0), TGPImageAttributes* imageAttributes = (TGPImageAttributes*)(0x0))/* overload */;
	Status __fastcall EnumerateMetafile(TGPMetafile* metafile, const Gdipapi::TGPPointF &destPoint, const Gdipapi::TGPRectF &srcRect, Gdipapi::Unit_ srcUnit, EnumerateMetafileProc callback, void * callbackData = (void *)(0x0), TGPImageAttributes* imageAttributes = (TGPImageAttributes*)(0x0))/* overload */;
	Status __fastcall EnumerateMetafile(TGPMetafile* metafile, const Gdipapi::TGPPoint &destPoint, const Gdipapi::TGPRect &srcRect, Gdipapi::Unit_ srcUnit, EnumerateMetafileProc callback, void * callbackData = (void *)(0x0), TGPImageAttributes* imageAttributes = (TGPImageAttributes*)(0x0))/* overload */;
	Status __fastcall EnumerateMetafile(TGPMetafile* metafile, const Gdipapi::TGPRectF &destRect, const Gdipapi::TGPRectF &srcRect, Gdipapi::Unit_ srcUnit, EnumerateMetafileProc callback, void * callbackData = (void *)(0x0), TGPImageAttributes* imageAttributes = (TGPImageAttributes*)(0x0))/* overload */;
	Status __fastcall EnumerateMetafile(TGPMetafile* metafile, const Gdipapi::TGPRect &destRect, const Gdipapi::TGPRect &srcRect, Gdipapi::Unit_ srcUnit, EnumerateMetafileProc callback, void * callbackData = (void *)(0x0), TGPImageAttributes* imageAttributes = (TGPImageAttributes*)(0x0))/* overload */;
	Status __fastcall EnumerateMetafile(TGPMetafile* metafile, Gdipapi::PGPPointF destPoints, int count, const Gdipapi::TGPRectF &srcRect, Gdipapi::Unit_ srcUnit, EnumerateMetafileProc callback, void * callbackData = (void *)(0x0), TGPImageAttributes* imageAttributes = (TGPImageAttributes*)(0x0))/* overload */;
	Status __fastcall EnumerateMetafile(TGPMetafile* metafile, Gdipapi::PGPPoint destPoints, int count, const Gdipapi::TGPRect &srcRect, Gdipapi::Unit_ srcUnit, EnumerateMetafileProc callback, void * callbackData = (void *)(0x0), TGPImageAttributes* imageAttributes = (TGPImageAttributes*)(0x0))/* overload */;
	Status __fastcall SetClip(TGPGraphics* g, CombineMode combineMode = (CombineMode)(0x0))/* overload */;
	Status __fastcall SetClip(const Gdipapi::TGPRectF &rect, CombineMode combineMode = (CombineMode)(0x0))/* overload */;
	Status __fastcall SetClip(const Gdipapi::TGPRect &rect, CombineMode combineMode = (CombineMode)(0x0))/* overload */;
	Status __fastcall SetClip(TGPGraphicsPath* path, CombineMode combineMode = (CombineMode)(0x0))/* overload */;
	Status __fastcall SetClip(TGPRegion* region, CombineMode combineMode = (CombineMode)(0x0))/* overload */;
	Status __fastcall SetClip(HRGN hRgn, CombineMode combineMode = (CombineMode)(0x0))/* overload */;
	Status __fastcall IntersectClip(const Gdipapi::TGPRectF &rect)/* overload */;
	Status __fastcall IntersectClip(const Gdipapi::TGPRect &rect)/* overload */;
	Status __fastcall IntersectClip(TGPRegion* region)/* overload */;
	Status __fastcall ExcludeClip(const Gdipapi::TGPRectF &rect)/* overload */;
	Status __fastcall ExcludeClip(const Gdipapi::TGPRect &rect)/* overload */;
	Status __fastcall ExcludeClip(TGPRegion* region)/* overload */;
	Status __fastcall ResetClip(void);
	Status __fastcall TranslateClip(float dx, float dy)/* overload */;
	Status __fastcall TranslateClip(int dx, int dy)/* overload */;
	Status __fastcall GetClip(TGPRegion* region);
	Status __fastcall GetClipBounds(/* out */ Gdipapi::TGPRectF &rect)/* overload */;
	Status __fastcall GetClipBounds(/* out */ Gdipapi::TGPRect &rect)/* overload */;
	BOOL __fastcall IsClipEmpty(void);
	Status __fastcall GetVisibleClipBounds(/* out */ Gdipapi::TGPRectF &rect)/* overload */;
	Status __fastcall GetVisibleClipBounds(/* out */ Gdipapi::TGPRect &rect)/* overload */;
	BOOL __fastcall IsVisibleClipEmpty(void);
	BOOL __fastcall IsVisible(int x, int y)/* overload */;
	BOOL __fastcall IsVisible(const Gdipapi::TGPPoint &point)/* overload */;
	BOOL __fastcall IsVisible(int x, int y, int width, int height)/* overload */;
	BOOL __fastcall IsVisible(const Gdipapi::TGPRect &rect)/* overload */;
	BOOL __fastcall IsVisible(float x, float y)/* overload */;
	BOOL __fastcall IsVisible(const Gdipapi::TGPPointF &point)/* overload */;
	BOOL __fastcall IsVisible(float x, float y, float width, float height)/* overload */;
	BOOL __fastcall IsVisible(const Gdipapi::TGPRectF &rect)/* overload */;
	unsigned __fastcall Save(void);
	Status __fastcall Restore(unsigned gstate);
	unsigned __fastcall BeginContainer(const Gdipapi::TGPRectF &dstrect, const Gdipapi::TGPRectF &srcrect, Gdipapi::Unit_ unit_)/* overload */;
	unsigned __fastcall BeginContainer(const Gdipapi::TGPRect &dstrect, const Gdipapi::TGPRect &srcrect, Gdipapi::Unit_ unit_)/* overload */;
	unsigned __fastcall BeginContainer(void)/* overload */;
	Status __fastcall EndContainer(unsigned state);
	Status __fastcall AddMetafileComment(System::PByte data, unsigned sizeData);
	HPALETTE __fastcall GetHalftonePalette(void);
	Status __fastcall GetLastStatus(void);
	__property void * NativeGraphics = {read=GetNativeGraphics, write=SetNativeGraphics};
};


class DELPHICLASS TGPAdjustableArrowCap;
class PASCALIMPLEMENTATION TGPAdjustableArrowCap : public TGPCustomLineCap 
{
	typedef TGPCustomLineCap inherited;
	
public:
	__fastcall TGPAdjustableArrowCap(float height, float width, BOOL isFilled);
	Status __fastcall SetHeight(float height);
	float __fastcall GetHeight(void);
	Status __fastcall SetWidth(float width);
	float __fastcall GetWidth(void);
	Status __fastcall SetMiddleInset(float middleInset);
	float __fastcall GetMiddleInset(void);
	Status __fastcall SetFillState(BOOL isFilled);
	BOOL __fastcall IsFilled(void);
public:
	#pragma option push -w-inl
	/* TGPCustomLineCap.Destroy */ inline __fastcall virtual ~TGPAdjustableArrowCap(void) { }
	#pragma option pop
	
};


class PASCALIMPLEMENTATION TGPMetafile : public TGPImage 
{
	typedef TGPImage inherited;
	
public:
	__fastcall TGPMetafile(HMETAFILE hWmf, WmfPlaceableFileHeader &wmfPlaceableFileHeader, BOOL deleteWmf)/* overload */;
	__fastcall TGPMetafile(HENHMETAFILE hEmf, BOOL deleteEmf)/* overload */;
	__fastcall TGPMetafile(WideString filename)/* overload */;
	__fastcall TGPMetafile(WideString filename, WmfPlaceableFileHeader &wmfPlaceableFileHeader)/* overload */;
	__fastcall TGPMetafile(_di_IStream stream)/* overload */;
	__fastcall TGPMetafile(HDC referenceHdc, int type_, WideChar * description)/* overload */;
	__fastcall TGPMetafile(HDC referenceHdc, const Gdipapi::TGPRectF &frameRect, int frameUnit, int type_, WideChar * description)/* overload */;
	__fastcall TGPMetafile(HDC referenceHdc, const Gdipapi::TGPRect &frameRect, int frameUnit, int type_, WideChar * description)/* overload */;
	__fastcall TGPMetafile(WideString fileName, HDC referenceHdc, int type_, WideChar * description)/* overload */;
	__fastcall TGPMetafile(WideString fileName, HDC referenceHdc, const Gdipapi::TGPRectF &frameRect, int frameUnit, int type_, WideChar * description)/* overload */;
	__fastcall TGPMetafile(WideString fileName, HDC referenceHdc, const Gdipapi::TGPRect &frameRect, int frameUnit, int type_, WideChar * description)/* overload */;
	__fastcall TGPMetafile(_di_IStream stream, HDC referenceHdc, int type_, WideChar * description)/* overload */;
	__fastcall TGPMetafile(_di_IStream stream, HDC referenceHdc, const Gdipapi::TGPRectF &frameRect, int frameUnit, int type_, WideChar * description)/* overload */;
	__fastcall TGPMetafile(_di_IStream stream, HDC referenceHdc, const Gdipapi::TGPRect &frameRect, int frameUnit, int type_, WideChar * description)/* overload */;
	__fastcall TGPMetafile(void)/* overload */;
	Status __fastcall GetMetafileHeader(HMETAFILE hWmf, WmfPlaceableFileHeader &wmfPlaceableFileHeader, Gdipapi::TMetafileHeader* header)/* overload */;
	Status __fastcall GetMetafileHeader(HENHMETAFILE hEmf, Gdipapi::TMetafileHeader* header)/* overload */;
	Status __fastcall GetMetafileHeader(WideString filename, Gdipapi::TMetafileHeader* header)/* overload */;
	Status __fastcall GetMetafileHeader(_di_IStream stream, Gdipapi::TMetafileHeader* header)/* overload */;
	Status __fastcall GetMetafileHeader(Gdipapi::TMetafileHeader* header)/* overload */;
	HENHMETAFILE __fastcall GetHENHMETAFILE(void);
	Status __fastcall PlayRecord(int recordType, unsigned flags, unsigned dataSize, System::PByte data);
	Status __fastcall SetDownLevelRasterizationLimit(unsigned metafileRasterizationLimitDpi);
	unsigned __fastcall GetDownLevelRasterizationLimit(void);
	unsigned __fastcall EmfToWmfBits(HENHMETAFILE hemf, unsigned cbData16, System::PByte pData16, int iMapMode = 0x8, int eFlags = 0x0);
public:
	#pragma option push -w-inl
	/* TGPImage.Destroy */ inline __fastcall virtual ~TGPMetafile(void) { }
	#pragma option pop
	
};


//-- var, const, procedure ---------------------------------------------------
extern PACKAGE TGPFontFamily* GenericSansSerifFontFamily;
extern PACKAGE TGPFontFamily* GenericSerifFontFamily;
extern PACKAGE TGPFontFamily* GenericMonospaceFontFamily;
extern PACKAGE TGPStringFormat* GenericTypographicStringFormatBuffer;
extern PACKAGE TGPStringFormat* GenericDefaultStringFormatBuffer;
extern PACKAGE Status __fastcall GetImageDecodersSize(/* out */ unsigned &numDecoders, /* out */ unsigned &size);
extern PACKAGE Status __fastcall GetImageDecoders(unsigned numDecoders, unsigned size, Gdipapi::PImageCodecInfo decoders);
extern PACKAGE Status __fastcall GetImageEncodersSize(/* out */ unsigned &numEncoders, /* out */ unsigned &size);
extern PACKAGE Status __fastcall GetImageEncoders(unsigned numEncoders, unsigned size, Gdipapi::PImageCodecInfo encoders);

}	/* namespace Gdipobj */
using namespace Gdipobj;
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// Gdipobj
