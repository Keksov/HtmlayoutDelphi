unit HtmLiteCls;

(*
  HTMLayout License terms could be found here http://www.terrainformatica.com/htmlayout/prices.whtm
  SDK - http://www.terrainformatica.com/htmlayout/HTMLayoutSDK.zip

  Delphi binding of HTMLayout published under LGPL. Visit https://github.com/Keksov/HtmlayoutDelphi

  This file contains object wrapper for function from include\htmlite.h
  Most accurate documentation could be found in include\htmlite.h itself
*)

interface

{$IFDEF USER_DEFINES_INC}{$I user_defines.inc}{$ENDIF}

uses Classes, SysUtils
    , Windows
    , HtmlBehaviorH
    , HtmLiteH
    , HtmlTypes
    , HtmlLayoutH
;

type

    THTMLiteBase = class;
    PTHMLite = ^THTMLiteBase;

    HTMLITE_TIMER_ID = (
        TIMER_IDLE_ID = 1, // nIDEvent in SetTimer cannot be zero
        TIMER_ANIMATION_ID = 2
    );

//-- THTMLiteBase

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

//-- THTMLite

    {***************************************************************************
    * THTMLite
    ***************************************************************************}    
    THTMLite = class( THTMLiteBase )
public
    constructor Create( aMediaType : string = 'screen' );

    function    load( const aData : string; aBaseURI : widestring = '' ) : boolean; overload;
    function    render( aDc : HDC; aX, aY, aSx, aSy : integer ) : boolean; override;

    end;

implementation

{*******************************************************************************
* THTMLiteCB
*******************************************************************************}
function THTMLiteCB( aHLite : HTMLITE; hdr : LPNMHDR ) : integer;
var
    pex : THTMLiteBase;

begin
    Result := 0;

    HTMLiteGetTag( aHLite, @pex );
    exit;
    
    assert( Assigned( pex ) );

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
    hr := HTMLiteGetRootElement(FhLite, @Result );
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

//-- THTMLite

{*******************************************************************************
* Create
*******************************************************************************}
constructor THTMLite.Create( aMediaType : string = 'screen' );
begin
    inherited Create( PChar( aMediaType ) );
end;

{*******************************************************************************
* load
*******************************************************************************}
function THTMLite.load( const aData : string; aBaseURI : widestring = '' ) : boolean;
begin
//    function    load( aDataPtr : LPCBYTE; aDataSize : DWORD; aBaseURI : LPCWSTR ) : boolean; overload;
    Result := inherited load( LPCBYTE( @aData[1] ), Length( aData ), LPCWSTR( aBaseURI ) );
end;

{*******************************************************************************
* render
*******************************************************************************}
function THTMLite.render( aDc : HDC; aX, aY, aSx, aSy : integer ) : boolean;
var
    pt : TPoint;
begin
    Result := SetViewportOrgEx( aDc, aX, aY, @pt );
    if ( not Result ) then
        exit;

    try
        Result := inherited render( aDc, aX, aY, aSx, aSy );
    finally
        Result := SetViewportOrgEx( aDc, pt.x, pt.y, nil );
    end;
end;

// string = 'screen'
end.
