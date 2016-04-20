unit HtmLiteH;

(*
  HTMLayout License terms could be found here http://www.terrainformatica.com/htmlayout/prices.whtm
  SDK - http://www.terrainformatica.com/htmlayout/HTMLayoutSDK.zip

  Delphi binding of HTMLayout published under LGPL. Visit https://github.com/Keksov/HtmlayoutDelphi

  This file contains object wrapper for function from include\htmlite.h
  Most accurate documentation could be found in include\htmlite.h itself
*)

interface

{$IFDEF USER_DEFINES_INC}{$I user_defines.inc}{$ENDIF}

uses Windows, sysutils
    , HtmlLayoutH
    , HtmlTypes
    , HtmlBehaviorH    
;

// HTMLite - Windowless but still interactive HTML/CSS engine. 

const 

    // REFRESH_AREA notification.
    // - HLN_REFRESH_AREA
    HLN_REFRESH_AREA = $AFF + $20;

    // HLN_SET_TIMER notification.
    // - HLN_SET_TIMER
    HLN_SET_TIMER = $AFF + $21;

    // HLN_SET_CURSOR notification.
    // - HLN_SET_CURSOR
    HLN_SET_CURSOR = $AFF + $22;

type
    // It's really a pointer - HTMLITE = Pointer. Class is used here for detection of logical errors during compilation.
    HTMLITE = class end;
    PHTMLITE = ^HTMLITE;

    // enum HLTRESULT
    HLTRESULT = (
        HLT_OK                = 0,
        HLT_INVALID_HANDLE    = 1,
        HLT_INVALID_FORMAT    = 2,
        HLT_FILE_NOT_FOUND    = 3,
        HLT_INVALID_PARAMETER = 4,
        HLT_INVALID_STATE     = 5, // attempt to do operation on empty document
        HLT_OK_DELAYED        = 6 // load operation is accepted but delayed.
    );

    FOCUS_ADVANCE_CMD = (
        FOCUS_REMOVE          = -2, // Remove focus from the view. This for example will stop caret timer if focus was set on &lt;input type=edit &gt;
        FOCUS_RESTORE         = -1, // Set focus on the element that had the focus before or to the first focusable element if the view had no focus set before.
        FOCUS_NEXT            = 0, // Advance focus to the next element. If current focus element is the last one in tab order pRes will receive FALSE;
        FOCUS_PREV            = 1, // Advance focus to the previous element. If current focus element is the first one in tab order pRes will receive FALSE;
        FOCUS_HOME            = 2, // Advance focus to the first element in tab order. pRes will always receive TRUE.
        FOCUS_END             = 3 // Advance focus to the last element in tab order. pRes will always receive TRUE.
    );

    NMHL_REFRESH_AREA = record
        hfr                     : NMHDR; // Default WM_NOTIFY header, only code field is used in HTMLite
        area                    : TRECT; // [in] area to refresh.
    end;
    LPNMHL_REFRESH_AREA = ^NMHL_REFRESH_AREA;

    NMHL_SET_TIMER = record
        hfr                     : NMHDR; // Default WM_NOTIFY header, only code field is used in HTMLite
        timerId                 : UINT_PTR; // [in] id of the timer event.
        elapseTime              : UINT; // [in] elapseTime of the timer event, milliseconds. If it is 0 then this timer has to be stoped.
    end;
    LPNMHL_SET_TIMER = ^NMHL_SET_TIMER;

    NMHL_SET_CURSOR = record
        hfr                     : NMHDR; // Default WM_NOTIFY header, only code field is used in HTMLite
        cursorId                : UINT; // [in] id of the cursor
    end;
    LPNMHL_SET_CURSOR = ^NMHL_SET_CURSOR;

    HTMLITE_TIMER_ID = (
        TIMER_IDLE_ID      = 1, // nIDEvent in SetTimer cannot be zero
        TIMER_ANIMATION_ID = 2
    );
    
//|
//| Callback function type
//|
//| HtmLayout will call it for callbacks defined in htmlayout.h, e.g. NMHL_ATTACH_BEHAVIOR
//|
HTMLITE_CALLBACK = function( aHLite : HTMLITE; hdr : LPNMHDR ) : UINT; stdcall;
    
//-- THTMLiteBase

    THTMLiteBase = class;
    PHTMLiteBase = ^THTMLiteBase;

    {***************************************************************************
    * THTMLiteBase
    ***************************************************************************}    
    THTMLiteBase = class
protected
    FhLite                      : HTMLITE;

protected
    function    is_closed_tab_cycle() : boolean;

public
    constructor Create( const aMediaType : LPCSTR );
    destructor  Destroy(); override;

    function    load( aPath : LPCWSTR ) : boolean; overload;
    function    load( aDataPtr : LPCBYTE; aDataSize : DWORD; aBaseURI : LPCWSTR ) : boolean; overload;
    function    load( aData : string; aBaseURI : widestring = ''  ) : boolean; overload;

    function    measure( aViewWidth, aViewHeight : integer ) : boolean;
    function    render( aDc : HDC; aX, aY, aSx, aSy : integer ) : boolean; overload; virtual;
    function    render( aDc : HDC; aDstX, aDstY, aDstSx, aDstSy, aSrcX, aSrcY, aSrcSx, aSrcSy : integer ) : boolean; overload; virtual;
    function    bmpRender( aBmp : HBITMAP; aX, aY, aSx, aSy : integer ) : boolean;
    function    setDataReady( aData : LPCBYTE; aDataSize : DWORD ) : boolean;
    function    setDataReadyAsync( aUrl : LPCWSTR; aData : LPCBYTE; aDataSize : DWORD; aDataType : UINT ) : boolean;
    // Get current document measured height for width given in measure scaledWidth/viewportWidth parameters.
    // ATTN: You need call first "measure" to get valid result. Return value is in screen pixels.
    function    getDocumentMinHeight() : integer;
    // Get current document measured minimum (intrinsic) width.
    // ATTN: You need call first "measure" to get valid result. Return value is in screen pixels.
    function    getDocumentMinWidth() : integer;
    function    getRootElement() : HELEMENT;
    // request to load data, override this if you need other data loading policy
    function    handleLoadUrlData( aParam : LPNMHL_LOAD_DATA ) : cardinal; virtual;
    // data loaded
    function    handleUrlDataLoaded( aParam : LPNMHL_DATA_LOADED ) : cardinal; virtual;
    // override this if you need other image loading policy
    function    handleAttachBehavior( aParam : LPNMHL_ATTACH_BEHAVIOR ) : cardinal; virtual;
    procedure   handleRefreshArea( aParam : LPNMHL_REFRESH_AREA ); virtual;
    procedure   handleSetTimer( aParam : LPNMHL_SET_TIMER ); virtual;
    procedure   handleSetCursor( aParam : LPNMHL_SET_CURSOR ); virtual;
    procedure   handleUpdate(); virtual;
    // process mouse event, see HTMLayoutMouseParams (in HtmlBehaviorH.pas) for the meaning of parameters
    function    traverseMouseEvent( aMouseCmd : UINT; aPoint : TPOINT; aButtons : UINT; aAltState : UINT ) : boolean;
    // process keyboard event, see PHTMLayoutKeyParams (in HtmlBehaviorH.pas) for the meaning of parameters
    function    traverseKeyboardEvent( aKeyCmd, aCode, aAltState : UINT ) : boolean;
    // process timer event,
    function    traverseTimerEvent( aTimerId : UINT ) : boolean;

    end;

(** Create instance of the engine
 * return HTMLITE, instance handle of the engine.
 **)
function HTMLiteCreateInstance() : HTMLITE; stdcall;

(** Destroy instance of the engine
 * param[in] FhLite HTMLITE, handle.
 * return HLTRESULT.
 **)
function HTMLiteDestroyInstance( aHLite : HTMLITE ) : HLTRESULT; stdcall;

(** Set custom tag value to the instance of the engine.
 * param[in] FhLite HTMLITE, handle.
 * param[in] tag LPVOID, any pointer.
 * return HLTRESULT.
 **)
function HTMLiteSetTag( aHLite : HTMLITE; tag : LPVOID ) : HLTRESULT; stdcall;

(** Get custom tag value from the instance of the engine.
 * param[in] FhLite HTMLITE, handle.
 * param[in] tag LPVOID*, pointer to value receiving tag value.
 * return HLTRESULT.
 **)
function HTMLiteGetTag( aHLite : HTMLITE; tag : PLPVOID ) : HLTRESULT; stdcall;

(** Load HTML from file 
 * param[in] FhLite HTMLITE, handle.
 * param[out] path LPCWSTR, path or URL of the html file to load.
 * return HLTRESULT.
 **)
function HTMLiteLoadHtmlFromFile( aHLite : HTMLITE; path : LPCWSTR ) : HLTRESULT; stdcall;

(** Load HTML from memory buffer 
 * param[in] FhLite HTMLITE, handle.
 * param[in] baseURI LPCWSTR, base url.
 * param[in] dataptr LPCBYTE, pointer to the buffer
 * param[in] datasize DWORD, length of the data in the buffer
 * return HLTRESULT.
 **)
function HTMLiteLoadHtmlFromMemory( aHLite : HTMLITE; baseURI : LPCWSTR; dataptr : LPCBYTE; datasize : DWORD ) : HLTRESULT; stdcall;

(** Measure loaded HTML
 * param[in] FhLite HTMLITE, handle.
 * param[in] viewWidth integer, width of the view area.
 * param[in] viewHeight integer, height of the view area.
 * return HLTRESULT.
 **)
function HTMLiteMeasure( aHLite : HTMLITE;
    viewWidth : integer; // width of rendering area in pixels 
    viewHeight : integer // height of rendering area in pixels 
) : HLTRESULT; stdcall;  

(** Render HTML
 * param[in] FhLite HTMLITE, handle.
 * param[in] hdc HDC, device context
 * param[in] x integer, x,y,sx and sy have the same meaning as rcPaint in PAINTSTRUCT
 * param[in] y integer, 
 * param[in] sx integer, 
 * param[in] sy integer, "dirty" rectangle coordinates.
 * return HLTRESULT.
 **)
(*
x,y,xs,ys in HTMLiteRender have the same meaning as rcPaint in PAINTSTRUCT. See:
http://msdn2.microsoft.com/en-us/library/ms534910.aspx
Use SetViewportOrgEx if you need to shift origin of canvas.
*)
function HTMLiteRender( aHLite : HTMLITE; dc : HDC;
    x : integer; // x position of area to render in pixels
    y : integer; // y position of area to render in pixels
    sx : integer; // width of area to render in pixels
    sy : integer // height of area to render in pixels
) : HLTRESULT; stdcall;


(** Render portion of HTML 
 * param[in] FhLite HTMLITE, handle.
 * param[in] hdc HDC, device context
 * param[in] dst_x integer, device pixels, dst_x, dst_y, dst_sx and dst_sy have the same meaning as rcPaint in PAINTSTRUCT
 * param[in] dst_y integer, 
 * param[in] dst_sx integer, 
 * param[in] dst_sy integer, "dirty" rectangle coordinates.
 * param[in] src_x integer, pixels, src_x,src_y,src_sx and src_sy define portion of document to render at dst
 * param[in] src_y integer, 
 * param[in] src_sx integer, Not used at the moment!
 * param[in] src_sy integer, Not used at the moment! 
 * return HLTRESULT.
 **)
(*
x,y,xs,ys in HTMLiteRender have the same meaning as rcPaint in PAINTSTRUCT. See:
http://msdn2.microsoft.com/en-us/library/ms534910.aspx
Use SetViewportOrgEx if you need to shift origin of canvas.
*)
function HTMLiteRenderEx( aHLite : HTMLITE; dc : HDC;
    dst_x : integer;  // x position of area to render in pixels
    dst_y : integer;  // y position of area to render in pixels
    dst_sx : integer; // width of area to render in pixels
    dst_sy : integer; // height of area to render in pixels
    src_x : integer;  // x position of document area to render
    src_y : integer;  // y position of document area to render
    src_sx : integer; // width of document area to render
    src_sy : integer // height of document area to render
) : HLTRESULT; stdcall;

(** Render HTML on 24bpp or 32bpp dib
 * param[in] FhLite HTMLITE, handle.
 * param[in] hbmp HBITMAP, device context
 * param[in] x integer, 
 * param[in] y integer, 
 * param[in] sx integer,
 * param[in] sy integer, "dirty" rectangle coordinates.
 * return HLTRESULT.
 **)
function HTMLiteRenderOnBitmap( aHLite : HTMLITE; hbmp : HBITMAP;
    x : integer; // x position of area to render  
    y : integer; // y position of area to render  
    sx : integer; // width of area to render
    sy : integer // height of area to render  
) : HLTRESULT; stdcall;  

(** executes all pending changes 
**)
function HTMLiteUpdateView( aHLite : HTMLITE ) : BOOL; stdcall;

(**This function is used in response to HLN_LOAD_DATA request. 
 *
 * param[in] FhLite HTMLITE, handle.
 * param[in] uri LPCWSTR, URI of the data requested by HTMLayout.
 * param[in] data LPBYTE, pointer to data buffer.
 * param[in] dataSize DWORD, length of the data in bytes.
 *
 **)
function HTMLiteSetDataReady( aHLite : HTMLITE; uri : LPCWSTR; data : LPCBYTE; dataSize : DWORD ) : HLTRESULT; stdcall;

(**Use this function outside of HLN_LOAD_DATA request. This function is needed when
 * you have your own http client implemented in your application.
 *
 * param[in] FhLite HTMLITE, handle.
 * param[in] uri LPCWSTR, URI of the data requested by HTMLayout.
 * param[in] data LPBYTE, pointer to data buffer.
 * param[in] dataLength DWORD, length of the data in bytes.
 * param[in] dataType UINT, type of resource to load. See HTMLayoutResourceType.
 * return BOOL, TRUE if HTMLayout accepts the data or \c FALSE if error occured 
 **)
function HTMLiteSetDataReadyAsync( aHLite : HTMLITE; uri : LPCWSTR; data : LPCBYTE; dataSize : DWORD; dataType : UINT ) : HLTRESULT; stdcall;

(**Get minimum width of loaded document 
 * ATTN: for this method to work document shall have following style:
 *    html { overflow: none; }
 * Otherwize consider to use
 *    HTMLayoutGetScrollInfo( root, ... , LPSIZE contentSize );  
 **)
function HTMLiteGetDocumentMinWidth( aHLite : HTMLITE; v : LPINT ) : HLTRESULT; stdcall;

(**Get minimum height of loaded document 
 **)
function HTMLiteGetDocumentMinHeight( aHLite : HTMLITE; v : LPINT ) : HLTRESULT; stdcall;

(**Set media type for CSS engine, use this before loading the document
 * \See: http://www.w3.org/TR/REC-CSS2/media.html 
 **)
function HTMLiteSetMediaType( aHLite : HTMLITE; mediatype : LPCSTR ) : HLTRESULT; stdcall;

(**Get root DOM element of loaded HTML document. 
 * param[in] FhLite HTMLITE, handle.
 * param[out] phe HELEMENT*, address of variable receiving handle of the root element (<html>).
 * return HLTRESULT.
 **)
function HTMLiteGetRootElement( aHLite : HTMLITE; phe : PHELEMENT ) : HLTRESULT; stdcall;

(** Get Element handle by its UID.
 * param[in] hwnd HTMLITE, handle.
 * param[in] uid UINT
 * param[out] phe #HELEMENT*, variable to receive HELEMENT handle
 * return #HLDOM_RESULT
 *
 * This function retrieves element UID by its handle. Returns NULL if it's not found.
 *
 **)
function HTMLiteGetElementByUID( aHLite : HTMLITE; uid : UINT; phe : PHELEMENT ) : HLTRESULT; stdcall;

(** Find DOM element by point (x,y).
 * param[in] FhLite HTMLITE, handle.
 * param[in] x integer, x coordinate of the point.
 * param[in] y integer, y coordinate of the point.
 * param[in] phe HELEMENT*, address of variable receiving handle of the element or 0 if there are no such element.
 * return HLTRESULT.
 **)
function HTMLiteFindElement( aHLite : HTMLITE; x : integer; y : integer; phe : PHELEMENT ) : HLTRESULT; stdcall;

(** Set callback function.
 * param[in] FhLite HTMLITE, handle.
 * param[in] cb HTMLITE_CALLBACK, address of callback function.
 * return HLTRESULT.
 **)
function HTMLiteSetCallback( aHLite : HTMLITE; cd : HTMLITE_CALLBACK ) : HLTRESULT; stdcall;

function HTMLiteTraverseUIEvent( aHLite : HTMLITE; evt : UINT; eventCtlStruct : LPVOID; bOutProcessed : LPBOOL ) : HLTRESULT; stdcall;

(** advance focus to focusable element. 
 * param[in] FhLite HTMLITE, handle.
 * param[in] where FOCUS_ADVANCE_CMD, where to advance.
 * param[out] pRes BOOL*, TRUE if focus was advanced, FLASE - otherwise.
 * return HLTRESULT.
 **)
function HTMLiteAdvanceFocus( aHLite : HTMLITE; where : FOCUS_ADVANCE_CMD; pRes : PBOOL ) : HLTRESULT; stdcall;

(** Get next (proposed) focus element. 
 * param[in] FhLite HTMLITE, handle.
 * param[in] where FOCUS_ADVANCE_CMD, where to advance.
 * param[in] currentElement an element which is a reference point for next focusable element. Could be null if current view focus should be used.
 * param[out] ppElement HELEMENT*, address of variable that will receive handler of found element.
 * param[out] pEndReached BOOL*, address of variable that will receive TRUE if currentElement was the last one in the tab order.
 * return HLTRESULT.
 **)
function HTMLiteGetNextFocusable( aHLite : HTMLITE; where : FOCUS_ADVANCE_CMD; currentElement : HELEMENT; ppElement : PHELEMENT; pEndReached : PBOOL ) : HLTRESULT; stdcall;

(**Get focused DOM element of the document.
 * param[in] FhLite HTMLITE, window for which you need to get focus
 * element
 * param[out ] phe #HELEMENT*, variable to receive focus element.
 * param[out ] pbViewActiveState BOOL*, variable to receive state of the focus element: TRUE the view itself is active (a.k.a. current), FALSE otherwise.
 * return #HLTRESULT
 *
 * phe may receive null value (0) if the view had no focus set yet.
 *
 * COMMENT: To set focus on element use HTMLayoutSetElementState(STATE_FOCUS,0)
 **)
function HTMLiteGetFocusElement( aHLite : HTMLITE; phe : PHELEMENT; pbViewFocusState : PBOOL ) : HLTRESULT; stdcall;

(**Get HTMLITE handler of containing window.
 * param[in] he #HELEMENT
 * param[out] pHTMLite HTMLITE*, variable to receive view handle
 * param[in] reserved BOOL - reserved
 * return #HLTRESULT.
 **)
function HTMLiteGetElementHTMLITE( he : HELEMENT; pHTMLite : PHTMLITE; reserved : BOOL ) : HLTRESULT; stdcall;

(** Attach/Detach ElementEventProc to the htmlite view.
    All events will start first here (in SINKING phase) and if not consumed will end up here.
    You can install EventHandler only once - it will survive all document reloads.
	If you want to change subscription mask, you can call HTMLiteAttachEventHandler again with the
	same "pep" and "tag" params, it will replace the handler subscription mask.
 **)
function HTMLiteAttachEventHandler( aHLite : HTMLITE; pep : HTMLayoutElementEventProc; tag : LPVOID; subscription : UINT ) : HLTRESULT; stdcall;
function HTMLiteDetachEventHandler( aHLite : HTMLITE; pep : HTMLayoutElementEventProc; tag : LPVOID) : HLTRESULT; stdcall;

    
implementation

uses HtmlDll;

function HTMLiteCreateInstance() : HTMLITE; external HTMLayoutDLL; stdcall
function HTMLiteDestroyInstance( aHLite : HTMLITE ) : HLTRESULT; external HTMLayoutDLL; stdcall
function HTMLiteSetTag( aHLite : HTMLITE; tag : LPVOID ) : HLTRESULT; external HTMLayoutDLL; stdcall
function HTMLiteGetTag( aHLite : HTMLITE; tag : PLPVOID ) : HLTRESULT; external HTMLayoutDLL; stdcall
function HTMLiteLoadHtmlFromFile( aHLite : HTMLITE; path : LPCWSTR ) : HLTRESULT; external HTMLayoutDLL; stdcall
function HTMLiteLoadHtmlFromMemory( aHLite : HTMLITE; baseURI : LPCWSTR; dataptr : LPCBYTE; datasize : DWORD ) : HLTRESULT; external HTMLayoutDLL; stdcall
function HTMLiteMeasure( aHLite : HTMLITE;
    viewWidth : integer; // width of rendering area in pixels
    viewHeight : integer // height of rendering area in pixels
) : HLTRESULT; external HTMLayoutDLL; stdcall
function HTMLiteRender( aHLite : HTMLITE; dc : HDC;
    x : integer; // x position of area to render in pixels
    y : integer; // y position of area to render in pixels
    sx : integer; // width of area to render in pixels
    sy : integer // height of area to render in pixels
) : HLTRESULT; external HTMLayoutDLL; stdcall
function HTMLiteRenderEx( aHLite : HTMLITE; dc : HDC;
    dst_x : integer;  // x position of area to render in pixels
    dst_y : integer;  // y position of area to render in pixels
    dst_sx : integer; // width of area to render in pixels
    dst_sy : integer; // height of area to render in pixels
    src_x : integer;  // x position of document area to render
    src_y : integer;  // y position of document area to render
    src_sx : integer; // width of document area to render
    src_sy : integer // height of document area to render
) : HLTRESULT; external HTMLayoutDLL; stdcall
function HTMLiteRenderOnBitmap( aHLite : HTMLITE; hbmp : HBITMAP;
    x : integer; // x position of area to render
    y : integer; // y position of area to render
    sx : integer; // width of area to render
    sy : integer // height of area to render
) : HLTRESULT; external HTMLayoutDLL; stdcall
function HTMLiteUpdateView( aHLite : HTMLITE ) : BOOL; external HTMLayoutDLL; stdcall
function HTMLiteSetDataReady( aHLite : HTMLITE; uri : LPCWSTR; data : LPCBYTE; dataSize : DWORD ) : HLTRESULT; external HTMLayoutDLL; stdcall
function HTMLiteSetDataReadyAsync( aHLite : HTMLITE; uri : LPCWSTR; data : LPCBYTE; dataSize : DWORD; dataType : UINT ) : HLTRESULT; external HTMLayoutDLL; stdcall
function HTMLiteGetDocumentMinWidth( aHLite : HTMLITE; v : LPINT ) : HLTRESULT; external HTMLayoutDLL; stdcall
function HTMLiteGetDocumentMinHeight( aHLite : HTMLITE; v : LPINT ) : HLTRESULT; external HTMLayoutDLL; stdcall
function HTMLiteSetMediaType( aHLite : HTMLITE; mediatype : LPCSTR ) : HLTRESULT; external HTMLayoutDLL; stdcall
function HTMLiteGetRootElement( aHLite : HTMLITE; phe : PHELEMENT ) : HLTRESULT; external HTMLayoutDLL; stdcall
function HTMLiteGetElementByUID( aHLite : HTMLITE; uid : UINT; phe : PHELEMENT ) : HLTRESULT; external HTMLayoutDLL; stdcall
function HTMLiteFindElement( aHLite : HTMLITE; x : integer; y : integer; phe : PHELEMENT ) : HLTRESULT; external HTMLayoutDLL; stdcall
function HTMLiteSetCallback( aHLite : HTMLITE; cd : HTMLITE_CALLBACK ) : HLTRESULT; external HTMLayoutDLL; stdcall
function HTMLiteTraverseUIEvent( aHLite : HTMLITE; evt : UINT; eventCtlStruct : LPVOID; bOutProcessed : LPBOOL ) : HLTRESULT; external HTMLayoutDLL; stdcall
function HTMLiteAdvanceFocus( aHLite : HTMLITE; where : FOCUS_ADVANCE_CMD; pRes : PBOOL ) : HLTRESULT; external HTMLayoutDLL; stdcall
function HTMLiteGetNextFocusable( aHLite : HTMLITE; where : FOCUS_ADVANCE_CMD; currentElement : HELEMENT; ppElement : PHELEMENT; pEndReached : PBOOL ) : HLTRESULT; external HTMLayoutDLL; stdcall
function HTMLiteGetFocusElement( aHLite : HTMLITE; phe : PHELEMENT; pbViewFocusState : PBOOL ) : HLTRESULT; external HTMLayoutDLL; stdcall
function HTMLiteGetElementHTMLITE( he : HELEMENT; pHTMLite : PHTMLITE; reserved : BOOL ) : HLTRESULT; external HTMLayoutDLL; stdcall
function HTMLiteAttachEventHandler( aHLite : HTMLITE; pep : HTMLayoutElementEventProc; tag : LPVOID; subscription : UINT ) : HLTRESULT; external HTMLayoutDLL; stdcall
function HTMLiteDetachEventHandler( aHLite : HTMLITE; pep : HTMLayoutElementEventProc; tag : LPVOID ) : HLTRESULT; external HTMLayoutDLL; stdcall

{*******************************************************************************
* THTMLiteCB
*******************************************************************************}
function THTMLiteCB( aHLite : HTMLITE; hdr : LPNMHDR ) : UINT; stdcall;
var
    pex : THTMLiteBase;

begin
    Result := 0;

    pex := nil;
    HTMLiteGetTag( aHLite, @pex );
    assert( Assigned( pex ) );
    if ( not Assigned( pex ) ) then
        exit;

    case hdr.code of
    HLN_LOAD_DATA :
        Result := (pex).handleLoadUrlData( LPNMHL_LOAD_DATA( hdr ) );
    HLN_DATA_LOADED :
        Result := (pex).handleUrlDataLoaded( LPNMHL_DATA_LOADED( hdr ) );
    HLN_ATTACH_BEHAVIOR :
        Result := (pex).handleAttachBehavior( LPNMHL_ATTACH_BEHAVIOR( hdr ) );
    HLN_REFRESH_AREA :
        (pex).handleRefreshArea( LPNMHL_REFRESH_AREA( hdr ) );
    HLN_SET_TIMER :
        (pex).handleSetTimer( LPNMHL_SET_TIMER( hdr ) );
    HLN_SET_CURSOR :
        (pex).handleSetCursor( LPNMHL_SET_CURSOR( hdr ) );
    HLN_UPDATE_UI :
        (pex).handleUpdate();
    end;

end;

{*******************************************************************************
* Create
*******************************************************************************}
constructor THTMLiteBase.Create( const aMediaType : LPCSTR );
begin

    FhLite := HTMLiteCreateInstance();
    assert( Assigned( FhLite ) );
    // set tag
    HTMLiteSetTag( FhLite, self );
    //HTMLiteSetTag( FhLite, Pointer(5) );
    //set media type
    HTMLiteSetMediaType( FhLite, aMediaType );
    // register callback
    HTMLiteSetCallback( FhLite, THTMLiteCB );
end;

{*******************************************************************************
* Destroy
*******************************************************************************}
destructor THTMLiteBase.Destroy();
begin
    if ( Assigned( FhLite ) ) then
    begin
        HTMLiteDestroyInstance( FhLite );
        FhLite := nil;
    end;

    inherited;
end;

{*******************************************************************************
* is_closed_tab_cycle
*******************************************************************************}
function THTMLiteBase.is_closed_tab_cycle() : boolean;
begin
    // this will cause set_focus_on(html::view::FOCUS_NEXT) to return false if there is no next element in the tab order.
    Result := false;
end;

{*******************************************************************************
* load
*******************************************************************************}
function THTMLiteBase.load( aPath : LPCWSTR ) : boolean;
var
    hr : HLTRESULT;
begin
    hr := HTMLiteLoadHtmlFromFile( FhLite, aPath );

    Result := ( hr = HLT_OK );
    assert( Result );
end;

{*******************************************************************************
* load
*******************************************************************************}
function THTMLiteBase.load( aDataPtr : LPCBYTE; aDataSize : DWORD; aBaseURI : LPCWSTR ) : boolean;
var
    hr : HLTRESULT;
begin
    hr := HTMLiteLoadHtmlFromMemory( FhLite, aBaseURI, aDataPtr, aDataSize );

    Result := ( hr = HLT_OK );
    assert( Result );
end;

{*******************************************************************************
* load
*******************************************************************************}
function THTMLiteBase.load( aData : string; aBaseURI : widestring = '' ) : boolean;
begin
    Result := load( PChar( aData ), Length( aData ), LPCWSTR( aBaseURI ) );
end;

{*******************************************************************************
* measure
*******************************************************************************}
function THTMLiteBase.measure( aViewWidth, aViewHeight : integer ) : boolean;
var
    hr : HLTRESULT;
begin
    hr := HTMLiteMeasure( FhLite, aViewWidth, aViewHeight );

    Result := ( hr = HLT_OK );
    assert( Result );
end;

{*******************************************************************************
* render
*******************************************************************************}
function THTMLiteBase.render( aDc : HDC; aX, aY, aSx, aSy : integer ) : boolean;
var
    hr : HLTRESULT;
begin
    hr := HTMLiteRender( FhLite, aDc, aX, aY, aSx, aSy );

    Result := ( hr = HLT_OK );
    assert( Result );
end;

{*******************************************************************************
* render
*******************************************************************************}
function THTMLiteBase.render( aDc : HDC; aDstX, aDstY, aDstSx, aDstSy, aSrcX, aSrcY, aSrcSx, aSrcSy : integer) : boolean;
var
    hr : HLTRESULT;
begin
    hr := HTMLiteRenderEx( FhLite, aDc, aDstX, aDstY, aDstSx, aDstSy, aSrcX, aSrcY, aSrcSx, aSrcSy );

    Result := ( hr = HLT_OK );
    assert( Result );
end;

{*******************************************************************************
* bmpRender
*******************************************************************************}
function THTMLiteBase.bmpRender( aBmp : HBITMAP; aX, aY, aSx, aSy : integer ) : boolean;
var
    hr : HLTRESULT;
begin
    hr := HTMLiteRenderOnBitmap( FhLite, aBmp, aX, aY, aSx, aSy );

    Result := ( hr = HLT_OK );
    assert( Result );
end;

{*******************************************************************************
* setDataReady
*******************************************************************************}
function THTMLiteBase.setDataReady( aData : LPCBYTE; aDataSize : DWORD ) : boolean;
var
    hr : HLTRESULT;
begin
    hr := HTMLiteSetDataReady( FhLite, nil, aData, aDataSize );

    Result := ( hr = HLT_OK );
    assert( Result );
end;

{*******************************************************************************
* setDataReadyAsync
*******************************************************************************}
function THTMLiteBase.setDataReadyAsync( aUrl : LPCWSTR; aData : LPCBYTE; aDataSize : DWORD; aDataType : UINT ) : boolean;
var
    hr : HLTRESULT;
begin
    hr := HTMLiteSetDataReadyAsync( FhLite, aUrl, aData, aDataSize, aDataType );

    Result := ( hr = HLT_OK );
    assert( Result );
end;
  
{*******************************************************************************
* getDocumentMinHeight
*******************************************************************************}
function THTMLiteBase.getDocumentMinHeight() : integer;
var
    hr : HLTRESULT;
begin
    Result := 0;
    hr := HTMLiteGetDocumentMinHeight( FhLite, @Result );
    assert( hr = HLT_OK );
end;

{*******************************************************************************
* getDocumentMinWidth
*******************************************************************************}
function THTMLiteBase.getDocumentMinWidth() : integer;
var
    hr : HLTRESULT;
begin
    Result := 0;
    hr := HTMLiteGetDocumentMinWidth( FhLite, @Result );
    assert( hr = HLT_OK );
end;

{*******************************************************************************
* getRootElement
*******************************************************************************}
function THTMLiteBase.getRootElement() : HELEMENT;
var
    hr : HLTRESULT;
begin
    Result := nil;
    hr := HTMLiteGetRootElement( FhLite, @Result );
    assert( hr = HLT_OK );
end;

{*******************************************************************************
* handleLoadUrlData
*******************************************************************************}
function THTMLiteBase.handleLoadUrlData( aParam : LPNMHL_LOAD_DATA ) : cardinal;
begin
    // OVERRIDE ME
    Result := 0; // proceed with default image loader
end;

{*******************************************************************************
* handleUrlDataLoaded
*******************************************************************************}
function THTMLiteBase.handleUrlDataLoaded( aParam : LPNMHL_DATA_LOADED ) : cardinal;
begin
    // OVERRIDE ME
    Result := 0; // proceed with default image loader
end;

{*******************************************************************************
* handleAttachBehavior
*******************************************************************************}
function THTMLiteBase.handleAttachBehavior( aParam : LPNMHL_ATTACH_BEHAVIOR ) : cardinal;
begin
    // OVERRIDE ME

    Result := 0;
    (*
    TODO: implement
    htmlayout::event_handler *pb = htmlayout::behavior::find( aParam.behaviorName, aParam.element );
    if(pb)
    {
      pn->elementTag = pb;
      pn->elementProc = htmlayout::event_handler::element_proc;
      pn->elementEvents = pb->subscribed_to;
      return TRUE;
    }
    return FALSE; // proceed with default image loader
    *)
end;

{*******************************************************************************
* handleRefreshArea
*******************************************************************************}
procedure THTMLiteBase.handleRefreshArea( aParam : LPNMHL_REFRESH_AREA );
begin
    // OVERRIDE ME
    // pn->area;//e.g. InvalidateRect(..., pn->area).
end;

{*******************************************************************************
* handleSetTimer
*******************************************************************************}
procedure THTMLiteBase.handleSetTimer( aParam : LPNMHL_SET_TIMER );
begin
    // OVERRIDE ME
    (*if( aParam.elapseTime )
      ;// CreateTimerQueueTimer( self, aParam.timerId, aParam.elapseTime )
    else
      ;// DeleteTimerQueueTimer( .... )
    *)
end;

{*******************************************************************************
* handleSetCursor
*******************************************************************************}
procedure THTMLiteBase.handleSetCursor( aParam : LPNMHL_SET_CURSOR );
begin
    // OVERRIDE ME
    // (CURSOR_TYPE) pn->cursorId;
end;

{*******************************************************************************
* handleUpdate
*******************************************************************************}
procedure THTMLiteBase.handleUpdate();
begin
    // OVERRIDE ME
    //e.g. copy invalid area of pixel buffer to the screen.
end;

{*******************************************************************************
* traverseMouseEvent
*******************************************************************************}
function THTMLiteBase.traverseMouseEvent( aMouseCmd : UINT; aPoint : TPOINT; aButtons : UINT; aAltState : UINT ) : boolean;
var
    mp : HTMLayoutMouseParams;
    hr : HLTRESULT;
    
begin
    Result := false;

    ZeroMemory( @mp, SizeOf( HTMLayoutMouseParams ) );
    mp.cmd := aMouseCmd;
    mp.pos_document := aPoint;
    mp.button_state := aButtons;
    mp.alt_state := aAltState;

    hr := HTMLiteTraverseUIEvent( FhLite, HANDLE_MOUSE, @mp, @Result );

    Result := ( hr = HLT_OK );
    assert( Result );
end;

{*******************************************************************************
* traverseKeyboardEvent
*******************************************************************************}
function THTMLiteBase.traverseKeyboardEvent( aKeyCmd, aCode, aAltState : UINT ) : boolean;
var
    kp : HTMLayoutKeyParams;
    hr : HLTRESULT;
begin
    Result := false;

    ZeroMemory( @kp, SizeOf( HTMLayoutKeyParams ) );

    kp.cmd := aKeyCmd;
    kp.key_code := aCode;
    kp.alt_state := aAltState;

    hr := HTMLiteTraverseUIEvent( FhLite, HANDLE_KEY, @kp, @Result );
    
    Result := ( hr = HLT_OK );
    assert( Result );
end;

{*******************************************************************************
* traverseTimerEvent
*******************************************************************************}
function THTMLiteBase.traverseTimerEvent( aTimerId : UINT ) : boolean;
var
    hr : HLTRESULT;
begin
    hr := HTMLiteTraverseUIEvent( FhLite, HANDLE_TIMER, @aTimerId, @Result );

    // host must destroy timer event if result is FALSE.
    Result := ( hr = HLT_OK );
    assert( Result );
end;

end.
