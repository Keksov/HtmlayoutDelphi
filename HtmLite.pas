unit HtmLite;

(*
  HTMLayout License terms could be found here http://www.terrainformatica.com/htmlayout/prices.whtm
  SDK - http://www.terrainformatica.com/htmlayout/HTMLayoutSDK.zip

  Delphi binding of HTMLayout published under LGPL. Visit https://github.com/Keksov/HtmlayoutDelphi

  This file contains object wrapper for function from include\htmlite.h
  Most accurate documentation could be found in include\htmlite.h itself
*)

interface

{$IFDEF USER_DEFINES_INC}{$I user_defines.inc}{$ENDIF}

uses Classes, SysUtils, Windows, Messages, Math, Forms
    , HtmlBehaviorH
    , HtmLiteH
    , HtmPrintH
    , HtmlTypes
    , HtmlLayoutH
    , HtmlLayoutDomH
    , HtmlElement
    , HtmlDisplay
;

type

    TProxyWindow = class;

//-- THTMLRenderer

    THTMLRendererDCType = ( dtNone, dtScreen, dtPrinter );

    {***************************************************************************
    * THTMLRenderer
    ***************************************************************************}
    THTMLRenderer = class
protected
    Fproxy                      : TProxyWindow;
    Fscreen                     : THTMLiteBase;
    Fprinter                    : THTMPrintExBase;

    Fdc                         : HDC;
    FdcType                     : THTMLRendererDCType;
    FhPixelsPerInch             : double;
    FvPixelsPerInch             : double;

    Fhtml                       : string;
    Fwidth                      : integer;
    Fheight                     : integer;

    FuseDeviceDPI               : boolean;
    //Froot                       : HELEMENT;
    //kdpi : double;

private
    function    getHWin() : THandle;
    procedure   setDC( aDc : HDC );
    procedure   setHtml( const aHtml : string );
//    function    getScreen() : THTMLiteBase;
    function    getPrinter() : THTMPrintExBase;
    function    getIsScreen() : boolean;

protected
    procedure   doOnDocumentComplete(); virtual;
    procedure   measureDocument();
//    function    renderScreen( aX, aY : integer ) : boolean;
//    function    renderPrinter( aX, aY : integer ) : boolean;

public
    constructor Create(); overload;
    constructor Create( aDc : HDC ); overload;
    destructor  Destroy(); override;

    procedure   render( const aHtml : string; aX, aY : integer ); overload;
    procedure   render( aX, aY : integer ); overload;
    procedure   render( aDC : HDC; const aHtml : string; aX, aY : integer ); overload;
    procedure   render( aDC : HDC; aX, aY : integer ); overload;

    function    renderScaled( const aHtml : string; aX, aY : integer; aScaledWidth, aScaledHeight : double ) : boolean; overload;
    function    renderScaled( aX, aY : integer; aScaledWidth, aScaledHeight : double ) : boolean; overload;
    function    renderScaled( const aHtml : string; aX, aY : integer; aScaleFactor : double ) : boolean; overload;
    function    renderScaled( aX, aY : integer; aScaleFactor : double ) : boolean; overload;
    function    renderScaled( aDc : HDC; const aHtml : string; aScaledRect : TRect ) : boolean; overload;
    function    renderScaled( aDc : HDC; aScaledRect : TRect ) : boolean; overload;

    function    deviceX( aValue : double ) : integer;
    function    deviceY( aValue : double ) : integer;

protected
    property hwin : THandle read getHWin;
//    property screen : THTMLiteBase read getScreen;
    property printer : THTMPrintExBase read getPrinter;


//    function    load( const aData : string; aBaseURI : widestring = '' ) : boolean; overload;
//    function    render( aDc : HDC; aX, aY, aSx, aSy : integer ) : boolean; override;
public
    property dc : HDC read Fdc write setDC;
    property html : string read Fhtml write setHtml;
    property width : integer read Fwidth;
    property height : integer read Fheight;
    property useDeviceDPI : boolean read FuseDeviceDPI write FuseDeviceDPI;
    property hPixelsPerInch : double read FhPixelsPerInch;
    property vPixelsPerInch : double read FvPixelsPerInch;
    property isScreen : boolean read getIsScreen;

    end;

//-- TProxyWindow

    {***************************************************************************
    * TProxyWindow
    ***************************************************************************}
    //TProxyWindow = class( TForm )
    TProxyWindow = class
protected
    Frenderer                   : THTMLRenderer;
    Finstance                   : Cardinal;
    Fhandle                     : HWND;
    FwindowClass                : TWndClass;

protected
//    procedure   wndProc( var aMsg : TMessage ); override;
    procedure   setCallback( aCallback : HTMLayoutNotify; aCallbackParam : Pointer );
    function    htmlCallback( uMsg: UINT; wParam : WPARAM; lParam : LPARAM ) : LRESULT;
class function  getWindow() : TProxyWindow;
    procedure   setHtml( aRenderer : THTMLRenderer; const aHtml : string );

public
    constructor Create();

    end;

implementation

const
    MMPerInch = 25.4;

var
    ProxyWindow : TProxyWindow;
    FhScreenPPI : double;
    FvScreenPPI : double;

{*****************************************************************************
*  GetDeviceHorSize
******************************************************************************}
procedure uniGetDeviceSize( aDc : HDC; var aWidth, aHeight : integer );
begin
    aWidth := GetDeviceCaps( aDc, HORZSIZE );
    aHeight := GetDeviceCaps( aDc, VERTSIZE );
    exit;

    if ( GetPrimaryMonitorTrueSize( aWidth, aHeight ) ) then
        exit;

    aWidth := GetDeviceCaps( aDc, HORZSIZE );
    aHeight := GetDeviceCaps( aDc, VERTSIZE );
end;

{*****************************************************************************
* CalculateDisplayPixelPerInch
******************************************************************************}
procedure CalculateDisplayPixelPerInch();
var
    screenDc : HDC;
    hRes, vRes : integer;
    hSize, vSize : integer;

begin
    screenDc := getDC(0);

    try
        hRes := GetDeviceCaps( screenDc, HORZRES );
        vRes := GetDeviceCaps( screenDc, VERTRES );

        uniGetDeviceSize( screenDc, hSize, vSize );

        FhScreenPPI := ( MMPerInch * hRes / hSize );
        FvScreenPPI := ( MMPerInch * vRes / vSize );
    finally
        ReleaseDC( 0, screenDc );
    end;
end;

//-- TProxyWindow

{*******************************************************************************
* HtmlCallbackProxy
*******************************************************************************}
function HtmlCallbackProxy( uMsg: UINT; wParam: WPARAM; lParam: LPARAM; vParam: Pointer ): LRESULT; stdcall;
begin
    if vParam <> nil then
        Result := TProxyWindow( vParam ).HtmlCallback( uMsg, wParam, lParam )
    else
        Result := 0;
end;

{*******************************************************************************
* WindowProc
*******************************************************************************}
function WindowProc( hwnd : HWND; uMsg : UINT; wParam : WPARAM; lParam : LPARAM ) : LRESULT; stdcall;
var
    handled : BOOL;

begin
    //try
    Result := HTMLayoutProcND( hwnd, uMsg, wParam,lParam, handled );
    if handled then
        exit;

    case uMsg of
    WM_DESTROY :
        PostQuitMessage(0); // Otherwise app will continue to run
//    WM_CREATE:
//        HTMLayoutSetCallback( hwnd, HtmlCallbackProxy, ProxyWindow );
//    else
//        Result := DefWindowProc( hwnd, uMsg, wParam, lParam );
    end;

    Result := DefWindowProc( hwnd, uMsg, wParam, lParam );
end;

{*******************************************************************************
* Create
*******************************************************************************}
constructor TProxyWindow.Create();
begin
    Finstance := GetModuleHandle( nil );

    FwindowClass.style := CS_HREDRAW or CS_VREDRAW;
    FwindowClass.hIcon := LoadIcon( 0, IDI_APPLICATION );
    FwindowClass.hCursor := LoadCursor( 0, IDC_ARROW );
    FwindowClass.hInstance := Finstance;
    FwindowClass.lpfnWndProc := @WindowProc;
    FwindowClass.hbrBackground := COLOR_BACKGROUND;
    FwindowClass.lpszClassName := 'Example';

    // Регистрируем класс окна
    Windows.RegisterClass( FwindowClass );

    // Создаём окно
    Fhandle := CreateWindow( 'Example', 'Пример создания окна без VCL'
        , WS_OVERLAPPEDWINDOW //WS_CAPTION or WS_SYSMENU or WS_MINIMIZEBOX
        , 100, 100 // position
        , 320, 200 // size
        , 0, 0
        , Finstance
        , nil
    );

    // Показываем окно
    //ShowWindow( Fhandle, SW_SHOW );

    HTMLayoutSetCallback( Fhandle, HtmlCallbackProxy, self );

//    FhScreenDPI := DisplayHorzPixelsPerInch();
//    FvScreenDPI := PixelsPerInchVertDisplay( GetDC(0), true );

//    UpdateWindow( FwindowClass );
end;

{*******************************************************************************
* TProxyWindow
*******************************************************************************}
class function TProxyWindow.getWindow() : TProxyWindow;
begin
    if ( ProxyWindow = nil ) then
    begin
//        Application.CreateForm( TProxyWindow, ProxyWindow );
        ProxyWindow := TProxyWindow.Create();
//        ProxyWindow.Height := 100;
//        ProxyWindow.Width := 100;
//        ProxyWindow.Visible := true;
//        ProxyWindow.Show();
        Application.ProcessMessages();
    end;

    Result := ProxyWindow;
end;

{*******************************************************************************
* WndProc
*******************************************************************************}
(*procedure TProxyWindow.WndProc( var aMsg : TMessage );
var
    handled : BOOL;
    res     : LRESULT;

begin
    //try
        res := HTMLayoutProcND( Handle, aMsg.Msg, aMsg.WParam, aMsg.LParam, handled );
        if handled then
        begin
            aMsg.Result := res;
            exit;
        end;

        case aMsg.Msg of
        WM_CREATE:
            //SetCallback( HtmlCallbackProxy, self );
        end;

        inherited;

    {except
        on e : Exception do
        begin
            if ( e <> nil ) then if ( e <> nil ) then;
            if ( Message.Msg <> 0 ) then if ( Message.Msg <> 0 ) then;
        end;
    end;}
end;*)


{*******************************************************************************
* SetCallback
*******************************************************************************}
procedure TProxyWindow.SetCallback( aCallback : HTMLayoutNotify; aCallbackParam : Pointer );
begin
    HTMLayoutSetCallback( Fhandle, aCallback, aCallbackParam );
end;

{*******************************************************************************
* HtmlCallback
*******************************************************************************}
function TProxyWindow.HtmlCallback( uMsg: UINT; wParam : WPARAM; lParam : LPARAM ) : LRESULT;
begin
    Result := 0;

    assert( Frenderer <> nil );

    case PNMHDR( lParam ).code of
    HLN_DOCUMENT_COMPLETE :
        Frenderer.doOnDocumentComplete();
    end;

    {case PNMHDR( lParam ).code of
    HLN_CREATE_CONTROL :
        Result := doOnCreateControl( PNMHL_CREATE_CONTROL( lParam ) );
    HLN_LOAD_DATA:
        Result := doOnLoadData( PNMHL_LOAD_DATA( lParam ) );
    HLN_CONTROL_CREATED :
        doOnControlCreated();
    HLN_DATA_LOADED :
        Result := doOnDataLoaded( PNMHL_DATA_LOADED( lParam ) );
    HLN_DOCUMENT_COMPLETE :
        doOnDocumentComplete();
    HLN_UPDATE_UI :
        doOnUpdateUI();
    HLN_DESTROY_CONTROL :
        Result := doOnDestroyControl( PNMHL_DESTROY_CONTROL( lParam ) );
    HLN_ATTACH_BEHAVIOR :
        Result := doOnAttachBehavior( PNMHL_ATTACH_BEHAVIOR( lParam ) );
    HLN_BEHAVIOR_CHANGED :
        Result := doOnBehaviorChanged( PNMHL_BEHAVIOR_CHANGED( lParam ) );
    HLN_DIALOG_CREATED :
        Result := doOnDialogCreated();
    HLN_DIALOG_CLOSE_RQ :
        Result := doOnDialogCloseRequest( PNMHL_DIALOG_CLOSE_RQ( lParam ) );
    HLN_DOCUMENT_LOADED :
        Result := doOnDocumentLoaded();
    end;}
end;

{*******************************************************************************
* setHtml
*******************************************************************************}
procedure TProxyWindow.setHtml( aRenderer : THTMLRenderer; const aHtml : string );
var
    res : boolean;
begin
    Frenderer := aRenderer;
    res := HTMLayoutLoadHtml( Fhandle, LPCBYTE( @aHtml[1] ), Length( aHtml ) );
    assert( res );
end;

//-- THTMLRenderer

{*******************************************************************************
* Create
*******************************************************************************}
constructor THTMLRenderer.Create();
begin
    Fscreen := nil;
    FdcType := dtNone;
    FuseDeviceDPI := false;
    
    Fproxy := TProxyWindow.getWindow();
end;

{*******************************************************************************
* Create
*******************************************************************************}
constructor THTMLRenderer.Create( aDc : HDC );
begin
    Create();

    dc := aDc;
end;

{*******************************************************************************
* Destroy
*******************************************************************************}
destructor THTMLRenderer.Destroy();
begin
    FreeAndNil( Fscreen );
    inherited;
end;

{*******************************************************************************
* getIsScreen
*******************************************************************************}
function THTMLRenderer.getIsScreen() : boolean;
begin
    Result := ( FdcType = dtScreen );
end;

{*******************************************************************************
* getHWin
*******************************************************************************}
function THTMLRenderer.getHWin() : THandle;
begin
    Result := Fproxy.Fhandle;
end;

{*******************************************************************************
* setDC
*******************************************************************************}
procedure THTMLRenderer.setDC( aDc : HDC );
var
    tech : integer;
begin
    if ( Fdc = aDc ) then
        exit;

    tech := GetDeviceCaps( aDc, TECHNOLOGY );
    case tech of
    DT_PLOTTER :
        FdcType := dtPrinter; // Vector plotter
    DT_RASDISPLAY :
        FdcType := dtScreen; // Raster display
    DT_RASPRINTER :
        FdcType := dtPrinter; // Raster printer
    DT_RASCAMERA :
        FdcType := dtPrinter; // Raster camera
    DT_CHARSTREAM :
        FdcType := dtPrinter; // Character stream
    DT_METAFILE	:
        FdcType := dtPrinter; //Metafile
    DT_DISPFILE	:
        FdcType := dtPrinter; // Display file
    end;

    Fdc := aDc;

    FhPixelsPerInch := GetDeviceCaps( aDc, LOGPIXELSX );
    FvPixelsPerInch := GetDeviceCaps( aDc, LOGPIXELSY );
end;

{*******************************************************************************
* setHtml
*******************************************************************************}
procedure THTMLRenderer.setHtml( const aHtml : string );
begin
    if ( Fhtml = aHtml ) then
        exit;

    Fhtml := aHtml;
    Fproxy.setHtml( self, aHtml );
end;

{*******************************************************************************
* doOnDocumentComplete
*******************************************************************************}
procedure THTMLRenderer.doOnDocumentComplete();
begin
    measureDocument();
end;

{*******************************************************************************
* measureDocument
*******************************************************************************}
procedure THTMLRenderer.measureDocument();
var
    res : HLDOM_RESULT;
    shim : THtmlShim;
    minW : integer;

begin
    shim := THtmlShim.get( hwin );

    if ( not HTMLayoutCommitUpdates( hwin ) ) then
    begin
        assert( false );
        exit;
    end;

    res := HTMLayoutGetElementIntrinsicWidths( shim.handler, minW, Fwidth );
    assert( res = HLDOM_OK );

    res := HTMLayoutGetElementIntrinsicHeight( shim.handler, Fwidth, Fheight );
    assert( res = HLDOM_OK );
end;

{*******************************************************************************
* render
*******************************************************************************}
procedure THTMLRenderer.render( aDC : HDC; const aHtml : string; aX, aY : integer );
begin
    dc := aDC;
    html := aHtml;
    render( aX, aY );
end;

{*******************************************************************************
* render
*******************************************************************************}
procedure THTMLRenderer.render( aDC : HDC; aX, aY : integer );
begin
    dc := aDC;
    render( aX, aY );
end;

{*******************************************************************************
* render
*******************************************************************************}
procedure THTMLRenderer.render( const aHtml : string; aX, aY : integer );
begin
    html := aHtml;
    render( aX, aY );
end;

{*******************************************************************************
* render
*******************************************************************************}
procedure THTMLRenderer.render( aX, aY : integer );
begin
    renderScaled( aX, aY, 1 );
{    case FdcType of
    dtScreen :
        renderScreen( aX, aY );
    dtPrinter :
        renderPrinter( aX, aY );
    end;}
end;

{*******************************************************************************
* renderScaled
*******************************************************************************}
function THTMLRenderer.renderScaled( const aHtml : string; aX, aY : integer; aScaleFactor : double ) : boolean;
begin
    html := aHtml;
    Result := renderScaled( aX, aY, ceil( Fwidth * aScaleFactor ), ceil( Fheight * aScaleFactor ) );
end;

{*******************************************************************************
* renderScaled
*******************************************************************************}
function THTMLRenderer.renderScaled( aX, aY : integer; aScaleFactor : double ) : boolean;
begin
    Result := renderScaled( aX, aY, Fwidth * aScaleFactor, Fheight * aScaleFactor );
end;

{*******************************************************************************
* renderScaled
*******************************************************************************}
function THTMLRenderer.renderScaled( const aHtml : string; aX, aY : integer; aScaledWidth, aScaledHeight : double ) : boolean;
begin
    html := aHtml;
    Result := renderScaled( aX, aY, aScaledWidth, aScaledHeight );
end;

{*******************************************************************************
* renderScaled
*******************************************************************************}
function THTMLRenderer.renderScaled( aDc : HDC; const aHtml : string; aScaledRect : TRect ) : boolean;
begin
    dc := aDc;
    html := aHtml;
    Result := renderScaled( aScaledRect.Left, aScaledRect.Top, aScaledRect.Right - aScaledRect.Left, aScaledRect.Bottom - aScaledRect.Top );
end;

{*******************************************************************************
* renderScaled
*******************************************************************************}
function THTMLRenderer.renderScaled( aDc : HDC; aScaledRect : TRect ) : boolean;
begin
    dc := aDc;
    Result := renderScaled( aScaledRect.Left, aScaledRect.Top, aScaledRect.Right - aScaledRect.Left, aScaledRect.Bottom - aScaledRect.Top );
end;

{***************************************************************************
* deviceX
***************************************************************************}
function THTMLRenderer.deviceX( aValue : double ) : integer;
begin
    Result := Round( aValue * FvPixelsPerInch / FhScreenPPI );
end;

{***************************************************************************
* deviceY
***************************************************************************}
function THTMLRenderer.deviceY( aValue : double ) : integer;
begin
    Result := Round( aValue * FhPixelsPerInch / FvScreenPPI )
end;
{*******************************************************************************
* renderScaled
*******************************************************************************}
function THTMLRenderer.renderScaled( aX, aY : integer; aScaledWidth, aScaledHeight : double ) : boolean;
var
    pt : TPoint;
    kx : double;
    baseURI : widestring;
    printWidth : double;
    printHeight : double;
    scaledWidth : double;

    {***************************************************************************
    * adjustViewport
    ***************************************************************************}
    function adjustViewport() : boolean;
    begin
        Result := GetViewportOrgEx( Fdc, pt );
        if ( not Result ) then
            exit;

        aX := aX + pt.X;
        aY := aY + pt.Y;

        Result := SetViewportOrgEx( Fdc, aX, aY, nil );
    end;

    {***************************************************************************
    * vr
    ***************************************************************************}
    function vr( aValue : double ) : integer;
    begin
        if ( FuseDeviceDPI and not isScreen ) then
            Result := deviceY( aValue )
        else
            Result := Round( aValue );
    end;

    {***************************************************************************
    * hr
    ***************************************************************************}
    function hr( aValue : double ) : integer;
    begin
        if ( FuseDeviceDPI and not isScreen ) then
            Result := deviceX( aValue )
        else
            Result := Round( aValue );
    end;

begin
    Result := adjustViewport();
    if ( not Result ) then
        exit;

    try
        baseURI := 'http://';
        Result := printer.load( LPCBYTE( @Fhtml[1] ), Length( Fhtml ), LPCWSTR( baseURI ) );
        if ( not Result ) then
            exit;

        kx := aScaledWidth / Fwidth;

        scaledWidth := Fwidth + 100;
        printWidth := Fwidth * kx;
        printHeight := Fheight * kx;

        printer.measure( Fdc, scaledWidth, hr( printWidth ), vr( printHeight ) );
        if ( not Result ) then
            exit;

        Result := printer.render( Fdc, hr(aX), vr(aY), 0 );
        if ( not Result ) then
            exit;

    finally
        SetViewportOrgEx( Fdc, pt.x, pt.y, nil );
    end;
end;

{*******************************************************************************
* getScreen
*******************************************************************************}
{function THTMLRenderer.getScreen() : THTMLiteBase;
begin
    if ( not Assigned( Fscreen ) ) then
    begin
        Fscreen := THTMLiteBase.Create( 'screen' );
    end;

    Result := Fscreen;
end;}

{*******************************************************************************
* getPrinter
*******************************************************************************}
function THTMLRenderer.getPrinter() : THTMPrintExBase;
begin
    if ( not Assigned( Fprinter ) ) then
    begin
        Fprinter := THTMPrintExBase.Create( 'print' );
    end;

    Result := Fprinter;
end;


{*******************************************************************************
* renderScreen
*******************************************************************************}
{function THTMLRenderer.renderScreen( aX, aY : integer ) : boolean;
var
    pt : TPoint;
    baseURI : widestring;

begin
    Result := SetViewportOrgEx( Fdc, aX, aY, @pt );
    if ( not Result ) then
        exit;

    try
        baseURI := 'http://';
        Result := screen.load( LPCBYTE( @Fhtml[1] ), Length( Fhtml ), LPCWSTR( baseURI ) );
        if ( not Result ) then
            exit;

        // Fwidth and Fheight calculated in measureDocument
        Result := screen.measure( Fwidth, Fheight  );
        if ( not Result ) then
            exit;

        Result := screen.render( Fdc, aX, aY, aX + Fwidth, aY + Fheight );
        if ( not Result ) then
            exit;

    finally
        SetViewportOrgEx( Fdc, pt.x, pt.y, nil );
    end;
end;}

{*******************************************************************************
* renderPrinter
*******************************************************************************}
(*function THTMLRenderer.renderPrinter( aX, aY : integer ) : boolean;
var
    pt : TPoint;
    baseURI : widestring;
    printWidth : integer;
    printHeight : integer;
    scaledWidth : integer;

    {***************************************************************************
    * vr
    ***************************************************************************}
    function vr( aValue : integer ) : integer;
    begin
        Result := Round( aValue * FvPixelsPerInch / 96 );
    end;

    {***************************************************************************
    * hr
    ***************************************************************************}
    function hr( aValue : integer ) : integer;
    begin
        Result := Round( aValue * FhPixelsPerInch / 96 );
    end;

begin
    Result := SetViewportOrgEx( Fdc, hr( aX ), vr( aY ), @pt );
    if ( not Result ) then
        exit;

    try
        baseURI := 'http://';
        Result := printer.load( LPCBYTE( @Fhtml[1] ), Length( Fhtml ), LPCWSTR( baseURI ) );
        if ( not Result ) then
            exit;

        scaledWidth := Fwidth + GetSystemMetrics( SM_CXVSCROLL );

        printWidth := vr( scaledWidth ) + vr( GetSystemMetrics( SM_CXVSCROLL ) );
        printHeight := hr( Fheight ) + hr( GetSystemMetrics( SM_CYHSCROLL ) );

        printer.measure( Fdc, scaledWidth, printWidth, printHeight );
        if ( not Result ) then
            exit;

        Result := printer.render( Fdc, hr( aX ), vr( aY ), 0 );
        if ( not Result ) then
            exit;

    finally
        SetViewportOrgEx( Fdc, pt.x, pt.y, nil );
    end;
end;*)

INITIALIZATION
    ProxyWindow := nil;

    CalculateDisplayPixelPerInch();

FINALIZATION
    FreeAndNil( ProxyWindow );

end.
