unit HtmPrintH;

(*
  HTMLayout License terms could be found here http://www.terrainformatica.com/htmlayout/prices.whtm
  SDK - http://www.terrainformatica.com/htmlayout/HTMLayoutSDK.zip

  Delphi binding of HTMLayout published under LGPL. Visit https://github.com/Keksov/HtmlayoutDelphi

  This file contains object wrapper for function from include\htmprint.h
  Most accurate documentation could be found in include\htmprint.h itself
*)

//
// file htmprint.h
//
// Printing (windowless HTML rendering) API.
//

interface

{$IFDEF USER_DEFINES_INC}{$I user_defines.inc}{$ENDIF}

uses Windows, sysutils
    , HtmlLayoutH
    , HtmlTypes
;

type
    // It's really a pointer - HTMLITE = Pointer. Class is used here for detection of logical errors during compilation.
    HTMPRINT = class end;
    PHTMPRINT = ^HTMPRINT;
    
    // enum HPRESULT
    HPRESULT = (
        HPR_OK                  = 0,
        HPR_INVALID_HANDLE      = 1,
        HPR_INVALID_FORMAT      = 2,
        HPR_FILE_NOT_FOUND      = 3,
        HPR_INVALID_PARAMETER   = 4,
        HPR_INVALID_STATE       = 5 // attempt to do operation on empty document
    );

//
// Callback function type
//
// HtmLayout will call it each time when it needs to to download any type of external
// resource referred in this document - image, script or CSS.
//
// return FALSE if you dont want to load any images
// return TRUE if you want image to be provessed. You may call set_data_ready() to supply your own
// image or css content
// 
// While handling this callback host application may call HTMPrintSetDataReady
//
HTMPRINT_LOAD_DATA = function( hPrint : HTMPRINT; tag : LPVOID; url : LPCSTR ) : boolean; stdcall;

//
// Callback function type
//
// HtmLayout will call it each time when it renderes hyperlinked area
//
HTMPRINT_HYPERLINK_AREA = procedure( hPrint : HTMPRINT; tag : LPVOID; area : PRECT; url : LPCSTR ); stdcall;

//
// Callback function type: next page required.
//
// HtmLayout will call it in measuring phase when next page is needed.
// Parameters:
//   pPageViewportHeight - address of current pageViewportHeight variable. On input it contains viewportHeight value.
//                         You can change this value thus to handle pages with variable content area heights.
//                          
HTMPRINT_NEXT_PAGE = procedure( hPrint : HTMPRINT; tag : LPVOID;
    pageNo : cardinal; // in, number of page to be measured 
    pageOffsetY : integer; // in, "CSS pixels", offset of this page from the beginning of the document
    pPageViewportHeight : LPUINT; // inout, "CSS pixels", current height of the content area (viewport) on the page
    pbContinue : LPBOOL // out, true if you need to measure document further
); stdcall;

//-- THTMLiteBase

    THTMPrintExBase = class;
    PHTMPrintExBase = ^THTMPrintExBase;

    {***************************************************************************
    * THTMPrintExBase
    ***************************************************************************}    
    THTMPrintExBase = class
protected
    FhPrint                     : HTMPRINT;

public
    constructor Create( const aMediaType : LPCSTR );
    destructor  Destroy(); override;

    function    load( aPath : LPCSTR ) : boolean; overload;
    function    load( aPath : LPCWSTR ) : boolean; overload;
    function    load( aDataPtr : LPCBYTE; aDataSize : DWORD; aBaseURI : LPCWSTR ) : boolean; overload;
    // Read for explanation http://www.terrainformatica.com/2007/03/htmprintmeasure-or-basics-of-htmlcss-printing/
    function    measure( aDc : HDC;
                    aScaledWidth, // number of "HTML pixels" between left and right border of the page.
                    aViewWidth, // number of "printer physical pixels" or dots between left and right border of the page (a.k.a. physical page width).
                    aViewHeight : double // number of "printer physical pixels" or dots between left and right border of the page (a.k.a. physical page width).
                ) : integer; //return number of pages
    function    render( aDc : HDC; aViewportX, aViewportY, aPageNo : integer ) : boolean;
    function    setDataReady( aUrl : LPCSTR; aData : LPCBYTE; aDataSize : DWORD ) : boolean;
    // Get current document measured height for width given in measure scaledWidth/viewportWidth parameters.
    // ATTN: You need call first measure to get valid result.
    // return value is in screen pixels.
    function    getDocumentHeight() : integer;
    // Get current document measured minimum (intrinsic) width.
    // ATTN: You need call first measure to get valid result.
    // return value is in screen pixels.
    function    getDocumentMinWidth() : integer;
    function    getRootElement() : HELEMENT;
    // override this if you need other image loading policy
    function    loadUrlData( aUrl : LPCSTR ) : boolean; overload; virtual;
    function    loadUrlData( aUrl : string ) : boolean; overload; virtual;
    // override this if you want some special processing for hyperlinks.
    procedure   registerHyperlinkArea( aArea : PRect; aUrl : LPCSTR ); virtual;
    // override this if you have variable height pages.
    procedure   onNextPage( aPageNo : cardinal; aPageOffsetY : integer; var aPageViewportHeight : cardinal );

public
    property hPrint : HTMPRINT read FhPrint;
        
    end;

// Create instance of the engine
function HTMPrintCreateInstance() : HTMPRINT; stdcall;

// Destroy instance of the engine
function HTMPrintDestroyInstance( hPrint : HTMPRINT ) : HPRESULT; stdcall;

// Set custom tag value to the instance of the engine.
// This tag value will be used in all callback invocations.
function HTMPrintSetTag( hPrint : HTMPRINT; tag : LPVOID ) : HPRESULT; stdcall;

// Get custom tag value from the instance of the engine.
function HTMPrintGetTag( hPrint : HTMPRINT; tag : PLPVOID ) : HPRESULT; stdcall;

// Load HTML from file 
function HTMPrintLoadHtmlFromFile( hPrint : HTMPRINT; path : LPCSTR ) : HPRESULT; stdcall;

// Load HTML from file 
function HTMPrintLoadHtmlFromFileW( hPrint : HTMPRINT; path : LPCWSTR ) : HPRESULT; stdcall;

// Load HTML from memory buffer
function HTMPrintLoadHtmlFromMemory( hPrint : HTMPRINT; baseURI : LPCWSTR; dataptr : LPCBYTE; datasize : DWORD ) : HPRESULT; stdcall;

// Measure loaded HTML
// Read for explanation http://www.terrainformatica.com/2007/03/htmprintmeasure-or-basics-of-htmlcss-printing/
// https://rsdn.ru/forum/htmlayout/2427278.flat
function HTMPrintMeasure( hPrint : HTMPRINT; hds : HDC;
          scaledWidth : integer; // number of screen pixels in viewportWidth
          viewportWidth : integer; // width of rendering area in device (physical) units  
          viewportHeight : integer; // height of rendering area in device (physical) units  
          pOutNumberOfPages : INT_PTR // out, number of pages if HTML does not fit into viewportHeight
) : HPRESULT; stdcall; 

// Render , per se
function HTMPrintRender( hPrint : HTMPRINT; hds : HDC; 
          viewportX : integer; // x position of rendering area in device (physical) units
          viewportY : integer; // y position of rendering area in device (physical) units   
          pageNo : integer // number of page to render
) : HPRESULT; stdcall;   

// Set data of requested resource 
function HTMPrintSetDataReady( hPrint : HTMPRINT; url : LPCSTR; data : LPCBYTE; dataSize : DWORD ) : HPRESULT; stdcall;

// Get minimum width of loaded document 
function HTMPrintGetDocumentMinWidth( hPrint : HTMPRINT; v : LPDWORD ) : HPRESULT; stdcall;

// Get minimum height of loaded document measured for viewportWidth
function HTMPrintGetDocumentHeight( hPrint : HTMPRINT; v : LPDWORD ) : HPRESULT; stdcall;

// Set media type for CSS engine, use this before loading the document
// See: http://www.w3.org/TR/REC-CSS2/media.html 
function HTMPrintSetMediaType( hPrint : HTMPRINT; mediatype : LPCSTR ) : HPRESULT; stdcall;

//-- CALLBACK FUNCTIONS

// Set callback method. tag is used for passing into future calls of HTMPRINT_LOAD_DATA "as is"
function HTMPrintSetLoadDataCallback( hPrint : HTMPRINT; cd : HTMPRINT_LOAD_DATA ) : HPRESULT; stdcall;

// Set standard notification callback handler. tag is used for passing into future calls of LPHTMLAYOUT_NOTIFY "as is"
function HTMPrintSetCallback( hPrint : HTMPRINT; cb : HTMLayoutNotify; cbParam : LPVOID ) : HPRESULT; stdcall;

// Set callback method. tag is used for passing into  future calls of HTMPRINT_LOAD_DATA "as is"
function HTMPrintSetHyperlinkAreaCallback( hPrint : HTMPRINT; cb : HTMPRINT_HYPERLINK_AREA ) : HPRESULT; stdcall;

// Set callback method. tag is used for passing into 
// future calls of HTMPRINT_LOAD_DATA "as is"
function HTMPrintSetNextPageCallback( hPrint : HTMPRINT; cb : HTMPRINT_NEXT_PAGE ) : HPRESULT; stdcall;

// Get root DOM element of loaded HTML document. 
function HTMPrintGetRootElement( hPrint : HTMPRINT; phe : HELEMENT ) : HPRESULT; stdcall;


implementation

uses HtmlDll;

function HTMPrintCreateInstance() : HTMPRINT; external HTMLayoutDLL; stdcall;
function HTMPrintDestroyInstance( hPrint : HTMPRINT ) : HPRESULT; external HTMLayoutDLL; stdcall;
function HTMPrintSetTag( hPrint : HTMPRINT; tag : LPVOID ) : HPRESULT; external HTMLayoutDLL; stdcall;
function HTMPrintGetTag( hPrint : HTMPRINT; tag : PLPVOID ) : HPRESULT; external HTMLayoutDLL; stdcall;
function HTMPrintLoadHtmlFromFile( hPrint : HTMPRINT; path : LPCSTR ) : HPRESULT; external HTMLayoutDLL; stdcall;
function HTMPrintLoadHtmlFromFileW( hPrint : HTMPRINT; path : LPCWSTR ) : HPRESULT; external HTMLayoutDLL; stdcall;
function HTMPrintLoadHtmlFromMemory( hPrint : HTMPRINT; baseURI : LPCWSTR; dataptr : LPCBYTE; datasize : DWORD ) : HPRESULT; external HTMLayoutDLL; stdcall;
function HTMPrintMeasure( hPrint : HTMPRINT; hds : HDC;
          scaledWidth : integer; // number of screen pixels in viewportWidth
          viewportWidth : integer; // width of rendering area in device (physical) units  
          viewportHeight : integer; // height of rendering area in device (physical) units  
          pOutNumberOfPages : INT_PTR // out, number of pages if HTML does not fit into viewportHeight
) : HPRESULT; external HTMLayoutDLL; stdcall;
function HTMPrintRender( hPrint : HTMPRINT; hds : HDC; 
          viewportX : integer; // x position of rendering area in device (physical) units
          viewportY : integer; // y position of rendering area in device (physical) units   
          pageNo : integer // number of page to render
) : HPRESULT; external HTMLayoutDLL; stdcall;   
function HTMPrintSetDataReady( hPrint : HTMPRINT; url : LPCSTR; data : LPCBYTE; dataSize : DWORD ) : HPRESULT; external HTMLayoutDLL; stdcall;
function HTMPrintGetDocumentMinWidth( hPrint : HTMPRINT; v : LPDWORD ) : HPRESULT; external HTMLayoutDLL; stdcall;
function HTMPrintGetDocumentHeight( hPrint : HTMPRINT; v : LPDWORD ) : HPRESULT; external HTMLayoutDLL; stdcall;
function HTMPrintSetMediaType( hPrint : HTMPRINT; mediatype : LPCSTR ) : HPRESULT; external HTMLayoutDLL; stdcall;
function HTMPrintSetLoadDataCallback( hPrint : HTMPRINT; cd : HTMPRINT_LOAD_DATA ) : HPRESULT; external HTMLayoutDLL; stdcall;
function HTMPrintSetCallback( hPrint : HTMPRINT; cb : HTMLayoutNotify; cbParam : LPVOID ) : HPRESULT; external HTMLayoutDLL; stdcall;
function HTMPrintSetHyperlinkAreaCallback( hPrint : HTMPRINT; cb : HTMPRINT_HYPERLINK_AREA ) : HPRESULT; external HTMLayoutDLL; stdcall;
function HTMPrintSetNextPageCallback( hPrint : HTMPRINT; cb : HTMPRINT_NEXT_PAGE ) : HPRESULT; external HTMLayoutDLL; stdcall;
function HTMPrintGetRootElement( hPrint : HTMPRINT; phe : HELEMENT ) : HPRESULT; external HTMLayoutDLL; stdcall;

{*******************************************************************************
* HyperlinkAreaCB
*******************************************************************************}
procedure HyperlinkAreaCB( hPrint : HTMPRINT; tag : LPVOID; area : PRect; url : LPCSTR ); stdcall;
var
    pex : PHTMPrintExBase;

begin
    pex := PHTMPrintExBase( tag );
    assert( Assigned( pex ) );
    pex.registerHyperlinkArea( area, url );
end;

{*******************************************************************************
* NextPageCB
*******************************************************************************}
procedure NextPageCB( hPrint : HTMPRINT; tag : LPVOID; pageNo : UINT; pageOffsetY : integer; pPageViewportHeight : LPUINT; pbContinue : LPBOOL ); stdcall;
var
    pex : PHTMPrintExBase;
begin
    pex := PHTMPrintExBase( tag );
    assert( Assigned( pex ) );

    pex.onNextPage( pageNo, pageOffsetY, pPageViewportHeight^ );
end;

{*******************************************************************************
* Create
*******************************************************************************}
constructor THTMPrintExBase.Create( const aMediaType : LPCSTR );
begin
    FhPrint := HTMPrintCreateInstance();
    assert( Assigned( FhPrint ) );

    // set tag
    HTMPrintSetTag( FhPrint, self );

    // register callbacks
    //setup_callback(hPrint);
    //HTMPrintSetCallback( printex, callback, static_cast< BASE* >( this ) );
    HTMPrintSetHyperlinkAreaCallback( FhPrint, HyperlinkAreaCB );
    HTMPrintSetNextPageCallback( FhPrint, NextPageCB );

    //set media type
    HTMPrintSetMediaType( FhPrint, aMediaType );
end;

{*******************************************************************************
* Destroy
*******************************************************************************}
destructor THTMPrintExBase.Destroy();
begin
    if ( Assigned( FhPrint ) ) then
    begin
        HTMPrintDestroyInstance( FhPrint );
        FhPrint := nil;
    end;

    inherited;
end;

{*******************************************************************************
* load
*******************************************************************************}
function THTMPrintExBase.load( aPath : LPCSTR ) : boolean;
var
    hr : HPRESULT;
begin
    hr := HTMPrintLoadHtmlFromFile( FhPrint, aPath );

    Result := ( hr = HPR_OK );
    assert( Result );
end;

{*******************************************************************************
* load
*******************************************************************************}
function THTMPrintExBase.load( aPath : LPCWSTR ) : boolean;
var
    hr : HPRESULT;
begin
    hr := HTMPrintLoadHtmlFromFileW( FhPrint, aPath );

    Result := ( hr = HPR_OK );
    assert( Result );
end;

{*******************************************************************************
* load
*******************************************************************************}
function THTMPrintExBase.load( aDataPtr : LPCBYTE; aDataSize : DWORD; aBaseURI : LPCWSTR ) : boolean;
var
    hr : HPRESULT;
begin
    hr := HTMPrintLoadHtmlFromMemory( FhPrint, aBaseURI, aDataPtr, aDataSize );

    Result := ( hr = HPR_OK );
    assert( Result );
end;

{*******************************************************************************
* measure
*******************************************************************************}
function THTMPrintExBase.measure( aDc : HDC; aScaledWidth, aViewWidth, aViewHeight : double ) : integer;
var
    hr : HPRESULT;
begin
    hr := HTMPrintMeasure( FhPrint, aDc, Round( aScaledWidth ), Round( aViewWidth ), Round( aViewHeight ), @Result );
    assert( hr = HPR_OK );
end;

{*******************************************************************************
* render
*******************************************************************************}
function THTMPrintExBase.render( aDc : HDC; aViewportX, aViewportY, aPageNo : integer ) : boolean;
var
    hr : HPRESULT;
begin
    hr := HTMPrintRender( FhPrint, aDc, aViewportX, aViewportY, aPageNo );

    Result := ( hr = HPR_OK );
    assert( Result );
end;

{*******************************************************************************
* setDataReady
*******************************************************************************}
function THTMPrintExBase.setDataReady( aUrl : LPCSTR; aData : LPCBYTE; aDataSize : DWORD ) : boolean;
var
    hr : HPRESULT;
begin
    hr := HTMPrintSetDataReady( FhPrint, aUrl, aData, aDataSize );

    Result := ( hr = HPR_OK );
    assert( Result );
end;

{*******************************************************************************
* getDocumentHeight
*******************************************************************************}
function THTMPrintExBase.getDocumentHeight() : integer;
var
    hr : HPRESULT;
begin
    Result := 0;
    hr := HTMPrintGetDocumentHeight( FhPrint, @Result );
    assert( hr = HPR_OK );
end;

{*******************************************************************************
* getDocumentMinWidth
*******************************************************************************}
function THTMPrintExBase.getDocumentMinWidth() : integer;
var
    hr : HPRESULT;
begin
    Result := 0;
    hr := HTMPrintGetDocumentMinWidth( FhPrint, @Result );
    assert( hr = HPR_OK );
end;

{*******************************************************************************
* getRootElement
*******************************************************************************}
function THTMPrintExBase.getRootElement() : HELEMENT;
var
    hr : HPRESULT;
begin
    Result := nil;
    hr := HTMPrintGetRootElement( FhPrint, @Result );
    assert( hr = HPR_OK );
end;

{*******************************************************************************
* loadUrlData
*******************************************************************************}
function THTMPrintExBase.loadUrlData( aUrl : string ) : boolean;
begin
    Result := loadUrlData( PChar( aUrl ) );
end;

{*******************************************************************************
* loadUrlData
*******************************************************************************}
function THTMPrintExBase.loadUrlData( aUrl : LPCSTR ) : boolean;
begin
    // override this if you need other image loading policy
    Result := true; // proceed with default image loader

    // other options are:
    // discard image loading at all: Result = false;
    //
    // to load data from your own namespace simply call:
    // set_data_ready( url, data, dataSize );
    // Result := true;
end;

{*******************************************************************************
* registerHyperlinkArea
*******************************************************************************}
procedure THTMPrintExBase.registerHyperlinkArea( aArea : PRect; aUrl : LPCSTR );
begin
    // override this if you want some special processing for hyperlinks.
    // e.g. PDF output.
end;

{*******************************************************************************
* onNextPage
*******************************************************************************}
procedure THTMPrintExBase.onNextPage( aPageNo : cardinal; aPageOffsetY : integer; var aPageViewportHeight : cardinal );
begin
    // override this if you have variable height pages.
end;

end.
