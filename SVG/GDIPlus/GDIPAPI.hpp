// Borland C++ Builder
// Copyright (c) 1995, 2005 by Borland Software Corporation
// All rights reserved

// (DO NOT EDIT: machine generated header) 'Gdipapi.pas' rev: 10.00

#ifndef GdipapiHPP
#define GdipapiHPP

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

//-- user supplied -----------------------------------------------------------

namespace Gdipapi
{
//-- type declarations -------------------------------------------------------
typedef short INT16;

typedef Word UINT16;

typedef UINT16 *PUINT16;

typedef unsigned UINT32;

typedef DynamicArray<float >  TSingleDynArray;

class DELPHICLASS TGdiplusBase;
class PASCALIMPLEMENTATION TGdiplusBase : public System::TObject 
{
	typedef System::TObject inherited;
	
public:
	#pragma option push -w-inl
	/* virtual class method */ virtual System::TObject* __fastcall NewInstance() { return NewInstance(__classid(TGdiplusBase)); }
	#pragma option pop
	/*         class method */ static System::TObject* __fastcall NewInstance(TMetaClass* vmt);
	virtual void __fastcall FreeInstance(void);
	__fastcall TGdiplusBase(void);
public:
	#pragma option push -w-inl
	/* TObject.Destroy */ inline __fastcall virtual ~TGdiplusBase(void) { }
	#pragma option pop
	
};


typedef FillMode TFillMode;

typedef CompositingMode TCompositingMode;

typedef int TCompositingQuality;

#pragma option push -b
enum Unit_ { UnitWorld, UnitDisplay, UnitPixel, UnitPoint, UnitInch, UnitDocument, UnitMillimeter };
#pragma option pop

typedef Unit_ TUnit;

typedef int TMetafileFrameUnit;

typedef CoordinateSpace TCoordinateSpace;

typedef WrapMode TWrapMode;

typedef HatchStyle THatchStyle;

typedef DashStyle TDashStyle;

typedef int TDashCap;

typedef int TLineCap;

typedef CustomLineCapType TCustomLineCapType;

typedef LineJoin TLineJoin;

typedef Byte TPathPointType;

typedef WarpMode TWarpMode;

typedef LinearGradientMode TLinearGradientMode;

typedef CombineMode TCombineMode;

typedef ImageType TImageType;

typedef int TInterpolationMode;

typedef PenAlignment TPenAlignment;

typedef BrushType TBrushType;

typedef int TPenType;

typedef MatrixOrder TMatrixOrder;

typedef GenericFontFamily TGenericFontFamily;

typedef int TFontStyle;

typedef int TSmoothingMode;

typedef int TPixelOffsetMode;

typedef TextRenderingHint TTextRenderingHint;

typedef MetafileType TMetafileType;

typedef int TEmfType;

typedef ObjectType TObjectType;

typedef int TEmfPlusRecordType;

typedef int TStringFormatFlags;

typedef StringTrimming TStringTrimming;

typedef StringDigitSubstitute TStringDigitSubstitute;

typedef StringDigitSubstitute *PStringDigitSubstitute;

typedef HotkeyPrefix THotkeyPrefix;

typedef StringAlignment TStringAlignment;

typedef int TDriverStringOptions;

typedef FlushIntention TFlushIntention;

typedef int TEncoderParameterValueType;

typedef EncoderValue TEncoderValue;

typedef int TEmfToWmfBitsFlags;

typedef Status TStatus;

struct TGPSizeF;
typedef TGPSizeF *PGPSizeF;

#pragma pack(push,1)
struct TGPSizeF
{
	
public:
	float Width;
	float Height;
} ;
#pragma pack(pop)

#pragma pack(push,1)
struct TGPSize
{
	
public:
	int Width;
	int Height;
} ;
#pragma pack(pop)

typedef TGPSize *PGPSize;

struct TGPPointF;
typedef TGPPointF *PGPPointF;

#pragma pack(push,1)
struct TGPPointF
{
	
public:
	float X;
	float Y;
} ;
#pragma pack(pop)

typedef DynamicArray<TGPPointF >  TPointFDynArray;

#pragma pack(push,1)
struct TGPPoint
{
	
public:
	int X;
	int Y;
} ;
#pragma pack(pop)

typedef TGPPoint *PGPPoint;

typedef DynamicArray<TGPPoint >  TPointDynArray;

struct TGPRectF;
typedef TGPRectF *PGPRectF;

#pragma pack(push,1)
struct TGPRectF
{
	
public:
	float X;
	float Y;
	float Width;
	float Height;
} ;
#pragma pack(pop)

typedef DynamicArray<TGPRectF >  TRectFDynArray;

#pragma pack(push,1)
struct TGPRect
{
	
public:
	int X;
	int Y;
	int Width;
	int Height;
} ;
#pragma pack(pop)

typedef TGPRect *PGPRect;

typedef DynamicArray<TGPRect >  TRectDynArray;

class DELPHICLASS TPathData;
class PASCALIMPLEMENTATION TPathData : public System::TObject 
{
	typedef System::TObject inherited;
	
public:
	int Count;
	TGPPointF *Points;
	Byte *Types;
	__fastcall TPathData(void);
	__fastcall virtual ~TPathData(void);
};


#pragma pack(push,1)
struct TCharacterRange
{
	
public:
	int First;
	int Length;
} ;
#pragma pack(pop)

typedef TCharacterRange *PCharacterRange;

typedef DebugEventLevel TDebugEventLevel;

typedef GdiplusStartupInput  TGdiplusStartupInput;

typedef GdiplusStartupInput *PGdiplusStartupInput;

typedef GdiplusStartupOutput  TGdiplusStartupOutput;

typedef GdiplusStartupOutput *PGdiplusStartupOutput;

typedef unsigned *PARGB;

typedef int TPixelFormat;

typedef int TPaletteFlags;

typedef ColorPalette  TColorPalette;

typedef ColorPalette *PColorPalette;

typedef ColorMode TColorMode;

typedef ColorChannelFlags TColorChannelFlags;

typedef unsigned *PGPColor;

typedef unsigned TGPColor;

typedef DynamicArray<unsigned >  TColorDynArray;

typedef Types::TRect  RECTL;

typedef tagSIZE  SIZEL;

typedef ENHMETAHEADER3  TENHMETAHEADER3;

typedef ENHMETAHEADER3 *PENHMETAHEADER3;

typedef PWMFRect16  TPWMFRect16;

typedef PWMFRect16 *PPWMFRect16;

typedef WmfPlaceableFileHeader  TWmfPlaceableFileHeader;

typedef WmfPlaceableFileHeader *PWmfPlaceableFileHeader;

#pragma pack(push,1)
struct GDIPAPI__4
{
	
	union
	{
		struct 
		{
			ENHMETAHEADER3 EmfHeader;
			
		};
		struct 
		{
			tagMETAHEADER WmfHeader;
			
		};
		
	};
} ;
#pragma pack(pop)

class DELPHICLASS TMetafileHeader;
class PASCALIMPLEMENTATION TMetafileHeader : public System::TObject 
{
	typedef System::TObject inherited;
	
public:
	MetafileType Type_;
	unsigned Size;
	unsigned Version;
	unsigned EmfPlusFlags;
	float DpiX;
	float DpiY;
	int X;
	int Y;
	int Width;
	int Height;
	#pragma pack(push,1)
	GDIPAPI__4 Header;
	#pragma pack(pop)
	int EmfPlusHeaderSize;
	int LogicalDpiX;
	int LogicalDpiY;
	__property MetafileType GetType = {read=Type_, nodefault};
	__property unsigned GetMetafileSize = {read=Size, nodefault};
	__property unsigned GetVersion = {read=Version, nodefault};
	__property unsigned GetEmfPlusFlags = {read=EmfPlusFlags, nodefault};
	__property float GetDpiX = {read=DpiX};
	__property float GetDpiY = {read=DpiY};
	void __fastcall GetBounds(/* out */ TGPRect &Rect);
	BOOL __fastcall IsWmf(void);
	BOOL __fastcall IsWmfPlaceable(void);
	BOOL __fastcall IsEmf(void);
	BOOL __fastcall IsEmfOrEmfPlus(void);
	BOOL __fastcall IsEmfPlus(void);
	BOOL __fastcall IsEmfPlusDual(void);
	BOOL __fastcall IsEmfPlusOnly(void);
	BOOL __fastcall IsDisplay(void);
	Windows::PMetaHeader __fastcall GetWmfHeader(void);
	PENHMETAHEADER3 __fastcall GetEmfHeader(void);
public:
	#pragma option push -w-inl
	/* TObject.Create */ inline __fastcall TMetafileHeader(void) : System::TObject() { }
	#pragma option pop
	#pragma option push -w-inl
	/* TObject.Destroy */ inline __fastcall virtual ~TMetafileHeader(void) { }
	#pragma option pop
	
};


typedef ImageCodecInfo  TImageCodecInfo;

typedef ImageCodecInfo *PImageCodecInfo;

typedef int TImageCodecFlags;

typedef int TImageLockMode;

typedef BitmapData  TBitmapData;

typedef BitmapData *PBitmapData;

typedef int TImageFlags;

typedef RotateFlipType TRotateFlipType;

typedef EncoderParameter  TEncoderParameter;

typedef EncoderParameter *PEncoderParameter;

typedef EncoderParameters  TEncoderParameters;

typedef EncoderParameters *PEncoderParameters;

typedef PropertyItem  TPropertyItem;

typedef PropertyItem *PPropertyItem;

typedef float TColorMatrix[5][5];

typedef float *PColorMatrix;

typedef ColorMatrixFlags TColorMatrixFlags;

typedef ColorAdjustType TColorAdjustType;

typedef ColorMap  TColorMap;

typedef ColorMap *PColorMap;

typedef void *GpGraphics;

typedef void *GpBrush;

typedef void *GpTexture;

typedef void *GpSolidFill;

typedef void *GpLineGradient;

typedef void *GpPathGradient;

typedef void *GpHatch;

typedef void *GpPen;

typedef void *GpCustomLineCap;

typedef void *GpAdjustableArrowCap;

typedef void *GpImage;

typedef void *GpBitmap;

typedef void *GpMetafile;

typedef void *GpImageAttributes;

typedef void *GpPath;

typedef void *GpRegion;

typedef void *GpPathIterator;

typedef void *GpFontFamily;

typedef void *GpFont;

typedef void *GpStringFormat;

typedef void *GpFontCollection;

typedef void *GpCachedBitmap;

typedef Status GpStatus;

typedef FillMode GpFillMode;

typedef WrapMode GpWrapMode;

typedef Unit_ GpUnit;

typedef CoordinateSpace GpCoordinateSpace;

typedef TGPPointF *GpPointF;

typedef TGPPoint *GpPoint;

typedef TGPRectF *GpRectF;

typedef TGPRect *GpRect;

typedef TGPSizeF *GpSizeF;

typedef HatchStyle GpHatchStyle;

typedef DashStyle GpDashStyle;

typedef int GpLineCap;

typedef int GpDashCap;

typedef PenAlignment GpPenAlignment;

typedef LineJoin GpLineJoin;

typedef int GpPenType;

typedef void *GpMatrix;

typedef BrushType GpBrushType;

typedef MatrixOrder GpMatrixOrder;

typedef FlushIntention GpFlushIntention;

typedef TPathData GpPathData;
;

//-- var, const, procedure ---------------------------------------------------
#define WINGDIPDLL "gdiplus.dll"
static const Shortint QualityModeInvalid = -1;
static const Shortint QualityModeDefault = 0x0;
static const Shortint QualityModeLow = 0x1;
static const Shortint QualityModeHigh = 0x2;
static const Shortint CompositingQualityInvalid = -1;
static const Shortint CompositingQualityDefault = 0x0;
static const Shortint CompositingQualityHighSpeed = 0x1;
static const Shortint CompositingQualityHighQuality = 0x2;
static const Shortint CompositingQualityGammaCorrected = 0x3;
static const Shortint CompositingQualityAssumeLinear = 0x4;
static const Shortint MetafileFrameUnitPixel = 0x2;
static const Shortint MetafileFrameUnitPoint = 0x3;
static const Shortint MetafileFrameUnitInch = 0x4;
static const Shortint MetafileFrameUnitDocument = 0x5;
static const Shortint MetafileFrameUnitMillimeter = 0x6;
static const Shortint MetafileFrameUnitGdi = 0x7;
#define HatchStyleLargeGrid (HatchStyle)(4)
#define HatchStyleMin (HatchStyle)(0)
#define HatchStyleMax (HatchStyle)(52)
static const Shortint DashCapFlat = 0x0;
static const Shortint DashCapRound = 0x2;
static const Shortint DashCapTriangle = 0x3;
static const Shortint LineCapFlat = 0x0;
static const Shortint LineCapSquare = 0x1;
static const Shortint LineCapRound = 0x2;
static const Shortint LineCapTriangle = 0x3;
static const Shortint LineCapNoAnchor = 0x10;
static const Shortint LineCapSquareAnchor = 0x11;
static const Shortint LineCapRoundAnchor = 0x12;
static const Shortint LineCapDiamondAnchor = 0x13;
static const Shortint LineCapArrowAnchor = 0x14;
static const Byte LineCapCustom = 0xff;
static const Byte LineCapAnchorMask = 0xf0;
extern PACKAGE Byte PathPointTypeStart;
extern PACKAGE Byte PathPointTypeLine;
extern PACKAGE Byte PathPointTypeBezier;
extern PACKAGE Byte PathPointTypePathTypeMask;
extern PACKAGE Byte PathPointTypeDashMode;
extern PACKAGE Byte PathPointTypePathMarker;
extern PACKAGE Byte PathPointTypeCloseSubpath;
extern PACKAGE Byte PathPointTypeBezier3;
static const Shortint InterpolationModeInvalid = -1;
static const Shortint InterpolationModeDefault = 0x0;
static const Shortint InterpolationModeLowQuality = 0x1;
static const Shortint InterpolationModeHighQuality = 0x2;
static const Shortint InterpolationModeBilinear = 0x3;
static const Shortint InterpolationModeBicubic = 0x4;
static const Shortint InterpolationModeNearestNeighbor = 0x5;
static const Shortint InterpolationModeHighQualityBilinear = 0x6;
static const Shortint InterpolationModeHighQualityBicubic = 0x7;
static const Shortint PenTypeSolidColor = 0x0;
static const Shortint PenTypeHatchFill = 0x1;
static const Shortint PenTypeTextureFill = 0x2;
static const Shortint PenTypePathGradient = 0x3;
static const Shortint PenTypeLinearGradient = 0x4;
static const Shortint PenTypeUnknown = -1;
static const int FontStyleRegular = 0;
static const int FontStyleBold = 1;
static const int FontStyleItalic = 2;
static const int FontStyleBoldItalic = 3;
static const int FontStyleUnderline = 4;
static const int FontStyleStrikeout = 8;
static const Shortint SmoothingModeInvalid = -1;
static const Shortint SmoothingModeDefault = 0x0;
static const Shortint SmoothingModeHighSpeed = 0x1;
static const Shortint SmoothingModeHighQuality = 0x2;
static const Shortint SmoothingModeNone = 0x3;
static const Shortint SmoothingModeAntiAlias = 0x4;
static const Shortint PixelOffsetModeInvalid = -1;
static const Shortint PixelOffsetModeDefault = 0x0;
static const Shortint PixelOffsetModeHighSpeed = 0x1;
static const Shortint PixelOffsetModeHighQuality = 0x2;
static const Shortint PixelOffsetModeNone = 0x3;
static const Shortint PixelOffsetModeHalf = 0x4;
static const Shortint EmfTypeEmfOnly = 3;
static const Shortint EmfTypeEmfPlusOnly = 4;
static const Shortint EmfTypeEmfPlusDual = 5;
#define ObjectTypeMax (ObjectType)(9)
#define ObjectTypeMin (ObjectType)(1)
static const int WmfRecordTypeSetBkColor = 0x10201;
static const int WmfRecordTypeSetBkMode = 0x10102;
static const int WmfRecordTypeSetMapMode = 0x10103;
static const int WmfRecordTypeSetROP2 = 0x10104;
static const int WmfRecordTypeSetRelAbs = 0x10105;
static const int WmfRecordTypeSetPolyFillMode = 0x10106;
static const int WmfRecordTypeSetStretchBltMode = 0x10107;
static const int WmfRecordTypeSetTextCharExtra = 0x10108;
static const int WmfRecordTypeSetTextColor = 0x10209;
static const int WmfRecordTypeSetTextJustification = 0x1020a;
static const int WmfRecordTypeSetWindowOrg = 0x1020b;
static const int WmfRecordTypeSetWindowExt = 0x1020c;
static const int WmfRecordTypeSetViewportOrg = 0x1020d;
static const int WmfRecordTypeSetViewportExt = 0x1020e;
static const int WmfRecordTypeOffsetWindowOrg = 0x1020f;
static const int WmfRecordTypeScaleWindowExt = 0x10410;
static const int WmfRecordTypeOffsetViewportOrg = 0x10211;
static const int WmfRecordTypeScaleViewportExt = 0x10412;
static const int WmfRecordTypeLineTo = 0x10213;
static const int WmfRecordTypeMoveTo = 0x10214;
static const int WmfRecordTypeExcludeClipRect = 0x10415;
static const int WmfRecordTypeIntersectClipRect = 0x10416;
static const int WmfRecordTypeArc = 0x10817;
static const int WmfRecordTypeEllipse = 0x10418;
static const int WmfRecordTypeFloodFill = 0x10419;
static const int WmfRecordTypePie = 0x1081a;
static const int WmfRecordTypeRectangle = 0x1041b;
static const int WmfRecordTypeRoundRect = 0x1061c;
static const int WmfRecordTypePatBlt = 0x1061d;
static const int WmfRecordTypeSaveDC = 0x1001e;
static const int WmfRecordTypeSetPixel = 0x1041f;
static const int WmfRecordTypeOffsetClipRgn = 0x10220;
static const int WmfRecordTypeTextOut = 0x10521;
static const int WmfRecordTypeBitBlt = 0x10922;
static const int WmfRecordTypeStretchBlt = 0x10b23;
static const int WmfRecordTypePolygon = 0x10324;
static const int WmfRecordTypePolyline = 0x10325;
static const int WmfRecordTypeEscape = 0x10626;
static const int WmfRecordTypeRestoreDC = 0x10127;
static const int WmfRecordTypeFillRegion = 0x10228;
static const int WmfRecordTypeFrameRegion = 0x10429;
static const int WmfRecordTypeInvertRegion = 0x1012a;
static const int WmfRecordTypePaintRegion = 0x1012b;
static const int WmfRecordTypeSelectClipRegion = 0x1012c;
static const int WmfRecordTypeSelectObject = 0x1012d;
static const int WmfRecordTypeSetTextAlign = 0x1012e;
static const int WmfRecordTypeDrawText = 0x1062f;
static const int WmfRecordTypeChord = 0x10830;
static const int WmfRecordTypeSetMapperFlags = 0x10231;
static const int WmfRecordTypeExtTextOut = 0x10a32;
static const int WmfRecordTypeSetDIBToDev = 0x10d33;
static const int WmfRecordTypeSelectPalette = 0x10234;
static const int WmfRecordTypeRealizePalette = 0x10035;
static const int WmfRecordTypeAnimatePalette = 0x10436;
static const int WmfRecordTypeSetPalEntries = 0x10037;
static const int WmfRecordTypePolyPolygon = 0x10538;
static const int WmfRecordTypeResizePalette = 0x10139;
static const int WmfRecordTypeDIBBitBlt = 0x10940;
static const int WmfRecordTypeDIBStretchBlt = 0x10b41;
static const int WmfRecordTypeDIBCreatePatternBrush = 0x10142;
static const int WmfRecordTypeStretchDIB = 0x10f43;
static const int WmfRecordTypeExtFloodFill = 0x10548;
static const int WmfRecordTypeSetLayout = 0x10149;
static const int WmfRecordTypeResetDC = 0x1014c;
static const int WmfRecordTypeStartDoc = 0x1014d;
static const int WmfRecordTypeStartPage = 0x1004f;
static const int WmfRecordTypeEndPage = 0x10050;
static const int WmfRecordTypeAbortDoc = 0x10052;
static const int WmfRecordTypeEndDoc = 0x1005e;
static const int WmfRecordTypeDeleteObject = 0x101f0;
static const int WmfRecordTypeCreatePalette = 0x100f7;
static const int WmfRecordTypeCreateBrush = 0x100f8;
static const int WmfRecordTypeCreatePatternBrush = 0x101f9;
static const int WmfRecordTypeCreatePenIndirect = 0x102fa;
static const int WmfRecordTypeCreateFontIndirect = 0x102fb;
static const int WmfRecordTypeCreateBrushIndirect = 0x102fc;
static const int WmfRecordTypeCreateBitmapIndirect = 0x102fd;
static const int WmfRecordTypeCreateBitmap = 0x106fe;
static const int WmfRecordTypeCreateRegion = 0x106ff;
static const Shortint EmfRecordTypeHeader = 0x1;
static const Shortint EmfRecordTypePolyBezier = 0x2;
static const Shortint EmfRecordTypePolygon = 0x3;
static const Shortint EmfRecordTypePolyline = 0x4;
static const Shortint EmfRecordTypePolyBezierTo = 0x5;
static const Shortint EmfRecordTypePolyLineTo = 0x6;
static const Shortint EmfRecordTypePolyPolyline = 0x7;
static const Shortint EmfRecordTypePolyPolygon = 0x8;
static const Shortint EmfRecordTypeSetWindowExtEx = 0x9;
static const Shortint EmfRecordTypeSetWindowOrgEx = 0xa;
static const Shortint EmfRecordTypeSetViewportExtEx = 0xb;
static const Shortint EmfRecordTypeSetViewportOrgEx = 0xc;
static const Shortint EmfRecordTypeSetBrushOrgEx = 0xd;
static const Shortint EmfRecordTypeEOF = 0xe;
static const Shortint EmfRecordTypeSetPixelV = 0xf;
static const Shortint EmfRecordTypeSetMapperFlags = 0x10;
static const Shortint EmfRecordTypeSetMapMode = 0x11;
static const Shortint EmfRecordTypeSetBkMode = 0x12;
static const Shortint EmfRecordTypeSetPolyFillMode = 0x13;
static const Shortint EmfRecordTypeSetROP2 = 0x14;
static const Shortint EmfRecordTypeSetStretchBltMode = 0x15;
static const Shortint EmfRecordTypeSetTextAlign = 0x16;
static const Shortint EmfRecordTypeSetColorAdjustment = 0x17;
static const Shortint EmfRecordTypeSetTextColor = 0x18;
static const Shortint EmfRecordTypeSetBkColor = 0x19;
static const Shortint EmfRecordTypeOffsetClipRgn = 0x1a;
static const Shortint EmfRecordTypeMoveToEx = 0x1b;
static const Shortint EmfRecordTypeSetMetaRgn = 0x1c;
static const Shortint EmfRecordTypeExcludeClipRect = 0x1d;
static const Shortint EmfRecordTypeIntersectClipRect = 0x1e;
static const Shortint EmfRecordTypeScaleViewportExtEx = 0x1f;
static const Shortint EmfRecordTypeScaleWindowExtEx = 0x20;
static const Shortint EmfRecordTypeSaveDC = 0x21;
static const Shortint EmfRecordTypeRestoreDC = 0x22;
static const Shortint EmfRecordTypeSetWorldTransform = 0x23;
static const Shortint EmfRecordTypeModifyWorldTransform = 0x24;
static const Shortint EmfRecordTypeSelectObject = 0x25;
static const Shortint EmfRecordTypeCreatePen = 0x26;
static const Shortint EmfRecordTypeCreateBrushIndirect = 0x27;
static const Shortint EmfRecordTypeDeleteObject = 0x28;
static const Shortint EmfRecordTypeAngleArc = 0x29;
static const Shortint EmfRecordTypeEllipse = 0x2a;
static const Shortint EmfRecordTypeRectangle = 0x2b;
static const Shortint EmfRecordTypeRoundRect = 0x2c;
static const Shortint EmfRecordTypeArc = 0x2d;
static const Shortint EmfRecordTypeChord = 0x2e;
static const Shortint EmfRecordTypePie = 0x2f;
static const Shortint EmfRecordTypeSelectPalette = 0x30;
static const Shortint EmfRecordTypeCreatePalette = 0x31;
static const Shortint EmfRecordTypeSetPaletteEntries = 0x32;
static const Shortint EmfRecordTypeResizePalette = 0x33;
static const Shortint EmfRecordTypeRealizePalette = 0x34;
static const Shortint EmfRecordTypeExtFloodFill = 0x35;
static const Shortint EmfRecordTypeLineTo = 0x36;
static const Shortint EmfRecordTypeArcTo = 0x37;
static const Shortint EmfRecordTypePolyDraw = 0x38;
static const Shortint EmfRecordTypeSetArcDirection = 0x39;
static const Shortint EmfRecordTypeSetMiterLimit = 0x3a;
static const Shortint EmfRecordTypeBeginPath = 0x3b;
static const Shortint EmfRecordTypeEndPath = 0x3c;
static const Shortint EmfRecordTypeCloseFigure = 0x3d;
static const Shortint EmfRecordTypeFillPath = 0x3e;
static const Shortint EmfRecordTypeStrokeAndFillPath = 0x3f;
static const Shortint EmfRecordTypeStrokePath = 0x40;
static const Shortint EmfRecordTypeFlattenPath = 0x41;
static const Shortint EmfRecordTypeWidenPath = 0x42;
static const Shortint EmfRecordTypeSelectClipPath = 0x43;
static const Shortint EmfRecordTypeAbortPath = 0x44;
static const Shortint EmfRecordTypeReserved_069 = 0x45;
static const Shortint EmfRecordTypeGdiComment = 0x46;
static const Shortint EmfRecordTypeFillRgn = 0x47;
static const Shortint EmfRecordTypeFrameRgn = 0x48;
static const Shortint EmfRecordTypeInvertRgn = 0x49;
static const Shortint EmfRecordTypePaintRgn = 0x4a;
static const Shortint EmfRecordTypeExtSelectClipRgn = 0x4b;
static const Shortint EmfRecordTypeBitBlt = 0x4c;
static const Shortint EmfRecordTypeStretchBlt = 0x4d;
static const Shortint EmfRecordTypeMaskBlt = 0x4e;
static const Shortint EmfRecordTypePlgBlt = 0x4f;
static const Shortint EmfRecordTypeSetDIBitsToDevice = 0x50;
static const Shortint EmfRecordTypeStretchDIBits = 0x51;
static const Shortint EmfRecordTypeExtCreateFontIndirect = 0x52;
static const Shortint EmfRecordTypeExtTextOutA = 0x53;
static const Shortint EmfRecordTypeExtTextOutW = 0x54;
static const Shortint EmfRecordTypePolyBezier16 = 0x55;
static const Shortint EmfRecordTypePolygon16 = 0x56;
static const Shortint EmfRecordTypePolyline16 = 0x57;
static const Shortint EmfRecordTypePolyBezierTo16 = 0x58;
static const Shortint EmfRecordTypePolylineTo16 = 0x59;
static const Shortint EmfRecordTypePolyPolyline16 = 0x5a;
static const Shortint EmfRecordTypePolyPolygon16 = 0x5b;
static const Shortint EmfRecordTypePolyDraw16 = 0x5c;
static const Shortint EmfRecordTypeCreateMonoBrush = 0x5d;
static const Shortint EmfRecordTypeCreateDIBPatternBrushPt = 0x5e;
static const Shortint EmfRecordTypeExtCreatePen = 0x5f;
static const Shortint EmfRecordTypePolyTextOutA = 0x60;
static const Shortint EmfRecordTypePolyTextOutW = 0x61;
static const Shortint EmfRecordTypeSetICMMode = 0x62;
static const Shortint EmfRecordTypeCreateColorSpace = 0x63;
static const Shortint EmfRecordTypeSetColorSpace = 0x64;
static const Shortint EmfRecordTypeDeleteColorSpace = 0x65;
static const Shortint EmfRecordTypeGLSRecord = 0x66;
static const Shortint EmfRecordTypeGLSBoundedRecord = 0x67;
static const Shortint EmfRecordTypePixelFormat = 0x68;
static const Shortint EmfRecordTypeDrawEscape = 0x69;
static const Shortint EmfRecordTypeExtEscape = 0x6a;
static const Shortint EmfRecordTypeStartDoc = 0x6b;
static const Shortint EmfRecordTypeSmallTextOut = 0x6c;
static const Shortint EmfRecordTypeForceUFIMapping = 0x6d;
static const Shortint EmfRecordTypeNamedEscape = 0x6e;
static const Shortint EmfRecordTypeColorCorrectPalette = 0x6f;
static const Shortint EmfRecordTypeSetICMProfileA = 0x70;
static const Shortint EmfRecordTypeSetICMProfileW = 0x71;
static const Shortint EmfRecordTypeAlphaBlend = 0x72;
static const Shortint EmfRecordTypeSetLayout = 0x73;
static const Shortint EmfRecordTypeTransparentBlt = 0x74;
static const Shortint EmfRecordTypeReserved_117 = 0x75;
static const Shortint EmfRecordTypeGradientFill = 0x76;
static const Shortint EmfRecordTypeSetLinkedUFIs = 0x77;
static const Shortint EmfRecordTypeSetTextJustification = 0x78;
static const Shortint EmfRecordTypeColorMatchToTargetW = 0x79;
static const Shortint EmfRecordTypeCreateColorSpaceW = 0x7a;
static const Shortint EmfRecordTypeMax = 0x7a;
static const Shortint EmfRecordTypeMin = 0x1;
static const Word EmfPlusRecordTypeInvalid = 0x4000;
static const Word EmfPlusRecordTypeHeader = 0x4001;
static const Word EmfPlusRecordTypeEndOfFile = 0x4002;
static const Word EmfPlusRecordTypeComment = 0x4003;
static const Word EmfPlusRecordTypeGetDC = 0x4004;
static const Word EmfPlusRecordTypeMultiFormatStart = 0x4005;
static const Word EmfPlusRecordTypeMultiFormatSection = 0x4006;
static const Word EmfPlusRecordTypeMultiFormatEnd = 0x4007;
static const Word EmfPlusRecordTypeObject = 0x4008;
static const Word EmfPlusRecordTypeClear = 0x4009;
static const Word EmfPlusRecordTypeFillRects = 0x400a;
static const Word EmfPlusRecordTypeDrawRects = 0x400b;
static const Word EmfPlusRecordTypeFillPolygon = 0x400c;
static const Word EmfPlusRecordTypeDrawLines = 0x400d;
static const Word EmfPlusRecordTypeFillEllipse = 0x400e;
static const Word EmfPlusRecordTypeDrawEllipse = 0x400f;
static const Word EmfPlusRecordTypeFillPie = 0x4010;
static const Word EmfPlusRecordTypeDrawPie = 0x4011;
static const Word EmfPlusRecordTypeDrawArc = 0x4012;
static const Word EmfPlusRecordTypeFillRegion = 0x4013;
static const Word EmfPlusRecordTypeFillPath = 0x4014;
static const Word EmfPlusRecordTypeDrawPath = 0x4015;
static const Word EmfPlusRecordTypeFillClosedCurve = 0x4016;
static const Word EmfPlusRecordTypeDrawClosedCurve = 0x4017;
static const Word EmfPlusRecordTypeDrawCurve = 0x4018;
static const Word EmfPlusRecordTypeDrawBeziers = 0x4019;
static const Word EmfPlusRecordTypeDrawImage = 0x401a;
static const Word EmfPlusRecordTypeDrawImagePoints = 0x401b;
static const Word EmfPlusRecordTypeDrawString = 0x401c;
static const Word EmfPlusRecordTypeSetRenderingOrigin = 0x401d;
static const Word EmfPlusRecordTypeSetAntiAliasMode = 0x401e;
static const Word EmfPlusRecordTypeSetTextRenderingHint = 0x401f;
static const Word EmfPlusRecordTypeSetTextContrast = 0x4020;
static const Word EmfPlusRecordTypeSetInterpolationMode = 0x4021;
static const Word EmfPlusRecordTypeSetPixelOffsetMode = 0x4022;
static const Word EmfPlusRecordTypeSetCompositingMode = 0x4023;
static const Word EmfPlusRecordTypeSetCompositingQuality = 0x4024;
static const Word EmfPlusRecordTypeSave = 0x4025;
static const Word EmfPlusRecordTypeRestore = 0x4026;
static const Word EmfPlusRecordTypeBeginContainer = 0x4027;
static const Word EmfPlusRecordTypeBeginContainerNoParams = 0x4028;
static const Word EmfPlusRecordTypeEndContainer = 0x4029;
static const Word EmfPlusRecordTypeSetWorldTransform = 0x402a;
static const Word EmfPlusRecordTypeResetWorldTransform = 0x402b;
static const Word EmfPlusRecordTypeMultiplyWorldTransform = 0x402c;
static const Word EmfPlusRecordTypeTranslateWorldTransform = 0x402d;
static const Word EmfPlusRecordTypeScaleWorldTransform = 0x402e;
static const Word EmfPlusRecordTypeRotateWorldTransform = 0x402f;
static const Word EmfPlusRecordTypeSetPageTransform = 0x4030;
static const Word EmfPlusRecordTypeResetClip = 0x4031;
static const Word EmfPlusRecordTypeSetClipRect = 0x4032;
static const Word EmfPlusRecordTypeSetClipPath = 0x4033;
static const Word EmfPlusRecordTypeSetClipRegion = 0x4034;
static const Word EmfPlusRecordTypeOffsetClip = 0x4035;
static const Word EmfPlusRecordTypeDrawDriverString = 0x4036;
static const Word EmfPlusRecordTotal = 0x4037;
static const Word EmfPlusRecordTypeMax = 0x4036;
static const Word EmfPlusRecordTypeMin = 0x4001;
static const Shortint StringFormatFlagsDirectionRightToLeft = 0x1;
static const Shortint StringFormatFlagsDirectionVertical = 0x2;
static const Shortint StringFormatFlagsNoFitBlackBox = 0x4;
static const Shortint StringFormatFlagsDisplayFormatControl = 0x20;
static const Word StringFormatFlagsNoFontFallback = 0x400;
static const Word StringFormatFlagsMeasureTrailingSpaces = 0x800;
static const Word StringFormatFlagsNoWrap = 0x1000;
static const Word StringFormatFlagsLineLimit = 0x2000;
static const Word StringFormatFlagsNoClip = 0x4000;
static const Shortint DriverStringOptionsCmapLookup = 0x1;
static const Shortint DriverStringOptionsVertical = 0x2;
static const Shortint DriverStringOptionsRealizedAdvance = 0x4;
static const Shortint DriverStringOptionsLimitSubpixel = 0x8;
extern PACKAGE int EncoderParameterValueTypeByte;
extern PACKAGE int EncoderParameterValueTypeASCII;
extern PACKAGE int EncoderParameterValueTypeShort;
extern PACKAGE int EncoderParameterValueTypeLong;
extern PACKAGE int EncoderParameterValueTypeRational;
extern PACKAGE int EncoderParameterValueTypeLongRange;
extern PACKAGE int EncoderParameterValueTypeUndefined;
extern PACKAGE int EncoderParameterValueTypeRationalRange;
static const Shortint EmfToWmfBitsFlagsDefault = 0x0;
static const Shortint EmfToWmfBitsFlagsEmbedEmf = 0x1;
static const Shortint EmfToWmfBitsFlagsIncludePlaceable = 0x2;
static const Shortint EmfToWmfBitsFlagsNoXORClip = 0x4;
static const Extended FLT_MAX = 3.402823E+38;
static const Extended FLT_MIN = 1.175494E-38;
static const Shortint PaletteFlagsHasAlpha = 0x1;
static const Shortint PaletteFlagsGrayScale = 0x2;
static const Shortint PaletteFlagsHalftone = 0x4;
static const unsigned aclAliceBlue = 0xfff0f8ff;
static const unsigned aclAntiqueWhite = 0xfffaebd7;
static const unsigned aclAqua = 0xff00ffff;
static const unsigned aclAquamarine = 0xff7fffd4;
static const unsigned aclAzure = 0xfff0ffff;
static const unsigned aclBeige = 0xfff5f5dc;
static const unsigned aclBisque = 0xffffe4c4;
static const unsigned aclBlack = 0xff000000;
static const unsigned aclBlanchedAlmond = 0xffffebcd;
static const unsigned aclBlue = 0xff0000ff;
static const unsigned aclBlueViolet = 0xff8a2be2;
static const unsigned aclBrown = 0xffa52a2a;
static const unsigned aclBurlyWood = 0xffdeb887;
static const unsigned aclCadetBlue = 0xff5f9ea0;
static const unsigned aclChartreuse = 0xff7fff00;
static const unsigned aclChocolate = 0xffd2691e;
static const unsigned aclCoral = 0xffff7f50;
static const unsigned aclCornflowerBlue = 0xff6495ed;
static const unsigned aclCornsilk = 0xfffff8dc;
static const unsigned aclCrimson = 0xffdc143c;
static const unsigned aclCyan = 0xff00ffff;
static const unsigned aclDarkBlue = 0xff00008b;
static const unsigned aclDarkCyan = 0xff008b8b;
static const unsigned aclDarkGoldenrod = 0xffb8860b;
static const unsigned aclDarkGray = 0xffa9a9a9;
static const unsigned aclDarkGreen = 0xff006400;
static const unsigned aclDarkKhaki = 0xffbdb76b;
static const unsigned aclDarkMagenta = 0xff8b008b;
static const unsigned aclDarkOliveGreen = 0xff556b2f;
static const unsigned aclDarkOrange = 0xffff8c00;
static const unsigned aclDarkOrchid = 0xff9932cc;
static const unsigned aclDarkRed = 0xff8b0000;
static const unsigned aclDarkSalmon = 0xffe9967a;
static const unsigned aclDarkSeaGreen = 0xff8fbc8b;
static const unsigned aclDarkSlateBlue = 0xff483d8b;
static const unsigned aclDarkSlateGray = 0xff2f4f4f;
static const unsigned aclDarkTurquoise = 0xff00ced1;
static const unsigned aclDarkViolet = 0xff9400d3;
static const unsigned aclDeepPink = 0xffff1493;
static const unsigned aclDeepSkyBlue = 0xff00bfff;
static const unsigned aclDimGray = 0xff696969;
static const unsigned aclDodgerBlue = 0xff1e90ff;
static const unsigned aclFirebrick = 0xffb22222;
static const unsigned aclFloralWhite = 0xfffffaf0;
static const unsigned aclForestGreen = 0xff228b22;
static const unsigned aclFuchsia = 0xffff00ff;
static const unsigned aclGainsboro = 0xffdcdcdc;
static const unsigned aclGhostWhite = 0xfff8f8ff;
static const unsigned aclGold = 0xffffd700;
static const unsigned aclGoldenrod = 0xffdaa520;
static const unsigned aclGray = 0xff808080;
static const unsigned aclGreen = 0xff008000;
static const unsigned aclGreenYellow = 0xffadff2f;
static const unsigned aclHoneydew = 0xfff0fff0;
static const unsigned aclHotPink = 0xffff69b4;
static const unsigned aclIndianRed = 0xffcd5c5c;
static const unsigned aclIndigo = 0xff4b0082;
static const unsigned aclIvory = 0xfffffff0;
static const unsigned aclKhaki = 0xfff0e68c;
static const unsigned aclLavender = 0xffe6e6fa;
static const unsigned aclLavenderBlush = 0xfffff0f5;
static const unsigned aclLawnGreen = 0xff7cfc00;
static const unsigned aclLemonChiffon = 0xfffffacd;
static const unsigned aclLightBlue = 0xffadd8e6;
static const unsigned aclLightCoral = 0xfff08080;
static const unsigned aclLightCyan = 0xffe0ffff;
static const unsigned aclLightGoldenrodYellow = 0xfffafad2;
static const unsigned aclLightGray = 0xffd3d3d3;
static const unsigned aclLightGreen = 0xff90ee90;
static const unsigned aclLightPink = 0xffffb6c1;
static const unsigned aclLightSalmon = 0xffffa07a;
static const unsigned aclLightSeaGreen = 0xff20b2aa;
static const unsigned aclLightSkyBlue = 0xff87cefa;
static const unsigned aclLightSlateGray = 0xff778899;
static const unsigned aclLightSteelBlue = 0xffb0c4de;
static const unsigned aclLightYellow = 0xffffffe0;
static const unsigned aclLime = 0xff00ff00;
static const unsigned aclLimeGreen = 0xff32cd32;
static const unsigned aclLinen = 0xfffaf0e6;
static const unsigned aclMagenta = 0xffff00ff;
static const unsigned aclMaroon = 0xff800000;
static const unsigned aclMediumAquamarine = 0xff66cdaa;
static const unsigned aclMediumBlue = 0xff0000cd;
static const unsigned aclMediumOrchid = 0xffba55d3;
static const unsigned aclMediumPurple = 0xff9370db;
static const unsigned aclMediumSeaGreen = 0xff3cb371;
static const unsigned aclMediumSlateBlue = 0xff7b68ee;
static const unsigned aclMediumSpringGreen = 0xff00fa9a;
static const unsigned aclMediumTurquoise = 0xff48d1cc;
static const unsigned aclMediumVioletRed = 0xffc71585;
static const unsigned aclMidnightBlue = 0xff191970;
static const unsigned aclMintCream = 0xfff5fffa;
static const unsigned aclMistyRose = 0xffffe4e1;
static const unsigned aclMoccasin = 0xffffe4b5;
static const unsigned aclNavajoWhite = 0xffffdead;
static const unsigned aclNavy = 0xff000080;
static const unsigned aclOldLace = 0xfffdf5e6;
static const unsigned aclOlive = 0xff808000;
static const unsigned aclOliveDrab = 0xff6b8e23;
static const unsigned aclOrange = 0xffffa500;
static const unsigned aclOrangeRed = 0xffff4500;
static const unsigned aclOrchid = 0xffda70d6;
static const unsigned aclPaleGoldenrod = 0xffeee8aa;
static const unsigned aclPaleGreen = 0xff98fb98;
static const unsigned aclPaleTurquoise = 0xffafeeee;
static const unsigned aclPaleVioletRed = 0xffdb7093;
static const unsigned aclPapayaWhip = 0xffffefd5;
static const unsigned aclPeachPuff = 0xffffdab9;
static const unsigned aclPeru = 0xffcd853f;
static const unsigned aclPink = 0xffffc0cb;
static const unsigned aclPlum = 0xffdda0dd;
static const unsigned aclPowderBlue = 0xffb0e0e6;
static const unsigned aclPurple = 0xff800080;
static const unsigned aclRed = 0xffff0000;
static const unsigned aclRosyBrown = 0xffbc8f8f;
static const unsigned aclRoyalBlue = 0xff4169e1;
static const unsigned aclSaddleBrown = 0xff8b4513;
static const unsigned aclSalmon = 0xfffa8072;
static const unsigned aclSandyBrown = 0xfff4a460;
static const unsigned aclSeaGreen = 0xff2e8b57;
static const unsigned aclSeaShell = 0xfffff5ee;
static const unsigned aclSienna = 0xffa0522d;
static const unsigned aclSilver = 0xffc0c0c0;
static const unsigned aclSkyBlue = 0xff87ceeb;
static const unsigned aclSlateBlue = 0xff6a5acd;
static const unsigned aclSlateGray = 0xff708090;
static const unsigned aclSnow = 0xfffffafa;
static const unsigned aclSpringGreen = 0xff00ff7f;
static const unsigned aclSteelBlue = 0xff4682b4;
static const unsigned aclTan = 0xffd2b48c;
static const unsigned aclTeal = 0xff008080;
static const unsigned aclThistle = 0xffd8bfd8;
static const unsigned aclTomato = 0xffff6347;
static const int aclTransparent = 0xffffff;
static const unsigned aclTurquoise = 0xff40e0d0;
static const unsigned aclViolet = 0xffee82ee;
static const unsigned aclWheat = 0xfff5deb3;
static const unsigned aclWhite = 0xffffffff;
static const unsigned aclWhiteSmoke = 0xfff5f5f5;
static const unsigned aclYellow = 0xffffff00;
static const unsigned aclYellowGreen = 0xff9acd32;
static const Shortint ImageCodecFlagsEncoder = 0x1;
static const Shortint ImageCodecFlagsDecoder = 0x2;
static const Shortint ImageCodecFlagsSupportBitmap = 0x4;
static const Shortint ImageCodecFlagsSupportVector = 0x8;
static const Shortint ImageCodecFlagsSeekableEncode = 0x10;
static const Shortint ImageCodecFlagsBlockingDecode = 0x20;
static const int ImageCodecFlagsBuiltin = 0x10000;
static const int ImageCodecFlagsSystem = 0x20000;
static const int ImageCodecFlagsUser = 0x40000;
static const Shortint ImageLockModeRead = 0x1;
static const Shortint ImageLockModeWrite = 0x2;
static const Shortint ImageLockModeUserInputBuf = 0x4;
static const Shortint ImageFlagsNone = 0x0;
static const Shortint ImageFlagsScalable = 0x1;
static const Shortint ImageFlagsHasAlpha = 0x2;
static const Shortint ImageFlagsHasTranslucent = 0x4;
static const Shortint ImageFlagsPartiallyScalable = 0x8;
static const Shortint ImageFlagsColorSpaceRGB = 0x10;
static const Shortint ImageFlagsColorSpaceCMYK = 0x20;
static const Shortint ImageFlagsColorSpaceGRAY = 0x40;
static const Byte ImageFlagsColorSpaceYCBCR = 0x80;
static const Word ImageFlagsColorSpaceYCCK = 0x100;
static const Word ImageFlagsHasRealDPI = 0x1000;
static const Word ImageFlagsHasRealPixelSize = 0x2000;
static const int ImageFlagsReadOnly = 0x10000;
static const int ImageFlagsCaching = 0x20000;
#define RotateNoneFlipY (RotateFlipType)(6)
#define Rotate90FlipY (RotateFlipType)(7)
#define Rotate180FlipY (RotateFlipType)(4)
#define Rotate270FlipY (RotateFlipType)(5)
#define RotateNoneFlipXY (RotateFlipType)(2)
#define Rotate90FlipXY (RotateFlipType)(3)
#define Rotate180FlipXY (RotateFlipType)(0)
#define Rotate270FlipXY (RotateFlipType)(1)
extern PACKAGE GdiplusStartupInput StartupInput;
extern PACKAGE unsigned gdiplusToken;
extern PACKAGE bool DoGDIPlusInitialization;
extern PACKAGE void __fastcall InitializeGDIPlus(void);
extern PACKAGE void __fastcall FinalizeGDIPlus(void);
extern PACKAGE BOOL __fastcall ObjectTypeIsValid(ObjectType type_);
extern PACKAGE int __fastcall GDIP_WMF_RECORD_TO_EMFPLUS(int n);
extern PACKAGE int __fastcall GDIP_EMFPLUS_RECORD_TO_WMF(int n);
extern PACKAGE BOOL __fastcall GDIP_IS_WMF_RECORDTYPE(int n);
extern PACKAGE TGPPoint __fastcall MakePoint(int X, int Y)/* overload */;
extern PACKAGE TGPPointF __fastcall MakePoint(float X, float Y)/* overload */;
extern PACKAGE TGPSizeF __fastcall MakeSize(float Width, float Height)/* overload */;
extern PACKAGE TGPSize __fastcall MakeSize(int Width, int Height)/* overload */;
extern PACKAGE TCharacterRange __fastcall MakeCharacterRange(int First, int Length);
extern PACKAGE TGPRectF __fastcall MakeRect(float x, float y, float width, float height)/* overload */;
extern PACKAGE TGPRectF __fastcall MakeRect(const TGPPointF &location, const TGPSizeF &size)/* overload */;
extern PACKAGE TGPRect __fastcall MakeRect(int x, int y, int width, int height)/* overload */;
extern PACKAGE TGPRect __fastcall MakeRect(const TGPPoint &location, const TGPSize &size)/* overload */;
extern PACKAGE TGPRect __fastcall MakeRect(const Types::TRect &Rect)/* overload */;
extern PACKAGE unsigned __fastcall MakeColor(Byte r, Byte g, Byte b)/* overload */;
extern PACKAGE unsigned __fastcall MakeColor(Byte a, Byte r, Byte g, Byte b)/* overload */;
extern PACKAGE Byte __fastcall GetAlpha(unsigned color);
extern PACKAGE Byte __fastcall GetRed(unsigned color);
extern PACKAGE Byte __fastcall GetGreen(unsigned color);
extern PACKAGE Byte __fastcall GetBlue(unsigned color);
extern PACKAGE unsigned __fastcall ColorRefToARGB(unsigned rgb);
extern PACKAGE unsigned __fastcall ARGBToColorRef(unsigned Color);
extern PACKAGE unsigned __fastcall TColorToARGB(int Color);

}	/* namespace Gdipapi */
using namespace Gdipapi;
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// Gdipapi
