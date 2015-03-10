unit htmlViewEvents;

interface

uses classes, sysutils
    , HtmlBehaviorH
    , HtmlElement
    , HtmlEvents
;

type

// More on each event type in HtmlBehaviorH

THtmlEventType = (
    // INITIALIZATION
      etINITIALIZATION_ALL, etBEHAVIOR_DETACH, etBEHAVIOR_ATTACH

    // MOUSE
    , etMOUSE_ALL, etMOUSE_ENTER, etMOUSE_LEAVE, etMOUSE_MOVE, etMOUSE_UP, etMOUSE_DOWN, etMOUSE_CLICK, etMOUSE_DCLICK, etMOUSE_WHEEL
    , etMOUSE_TICK, etMOUSE_IDLE, etDROP, etDRAG_ENTER, etDRAG_LEAVE, etDRAG_REQUEST, etDRAG_MOUSE_ENTER, etDRAG_MOUSE_LEAVE, etDRAG_MOUSE_MOVE, etDRAG_MOUSE_UP, etDRAG_MOUSE_DOWN

    // KEY
    , etKEY_ALL, etKEY_DOWN, etKEY_UP, etKEY_CHAR

    // FOCUS
    , etFOCUS_ALL, etFOCUS_LOST, etFOCUS_GOT

    // SCROLL
    , etSCROLL_ALL, etSCROLL_HOME, etSCROLL_END, etSCROLL_STEP_PLUS, etSCROLL_STEP_MINUS, etSCROLL_PAGE_PLUS, etSCROLL_PAGE_MINUS, etSCROLL_POS, etSCROLL_SLIDER_RELEASED

    // TIMER
    , etTIMER

    // SIZE
    , etSIZE

    // DRAW
    , etDRAW_ALL, etDRAW_BACKGROUND, etDRAW_CONTENT, etDRAW_FOREGROUND

    // HANDLE_DATA_ARRIVED
    , etDATA_ARRIVED

    // EXCHANGE
    , etEXC_ALL, etEXC_NONE, etEXC_COPY, etEXC_MOVE, etEXC_LINK

    // GESTURE
    , etGESTURE_ALL, etGESTURE_REQUEST, etGESTURE_ZOOM, etGESTURE_PAN, etGESTURE_ROTATE, etGESTURE_TAP1, etGESTURE_TAP2

    // BEHAVIOR_EVENT
    , etBUTTON_CLICK, etBUTTON_PRESS, etBUTTON_STATE_CHANGED, etEDIT_VALUE_CHANGING, etEDIT_VALUE_CHANGED, etSELECT_SELECTION_CHANGED, etSELECT_STATE_CHANGED, etPOPUP_REQUEST, etPOPUP_READY, etPOPUP_DISMISSED
    , etMENU_ITEM_ACTIVE, etMENU_ITEM_CLICK, etCONTEXT_MENU_SETUP, etCONTEXT_MENU_REQUEST, etVISIUAL_STATUS_CHANGED, etDISABLED_STATUS_CHANGED, etPOPUP_DISMISSING
    // "grey" event codes  - notfications from behaviors from this SDK
    , etHYPERLINK_CLICK, etTABLE_HEADER_CLICK, etTABLE_ROW_CLICK, etTABLE_ROW_DBL_CLICK, etELEMENT_COLLAPSED, etELEMENT_EXPANDED, etACTIVATE_CHILD, etDO_SWITCH_TAB, etINIT_DATA_VIEW, etROWS_DATA_REQUEST
    , etUI_STATE_CHANGED, etFORM_SUBMIT, etFORM_RESET, etDOCUMENT_COMPLETE, etHISTORY_PUSH, etHISTORY_DROP, etHISTORY_PRIOR, etHISTORY_NEXT, etHISTORY_STATE_CHANGED, etCLOSE_POPUP, etREQUEST_TOOLTIP
    , etANIMATION
);

THtmlEventGroupType = ( gtINITIALIZATION, gtMOUSE, gtKEY, gtFOCUS, gtSCROLL, gtTIMER, gtSIZE, gtDRAW, gtDATA_ARRIVED, gtEXCHANGE, gtGESTURE, gtBEHAVIOR );

    {***************************************************************************
    * RHtmlEventHandler
    ***************************************************************************}
    RHtmlEventHandler = record
        selector  : string;
        eventType : THtmlEventType;

        case THtmlEventGroupType of
        gtINITIALIZATION :
            ( initializationEvent : HTMLElementInitializationEventHandler );
        gtMOUSE :
            ( mouseEvent : HTMLElementMouseEventHandler );
        gtKEY :
            ( keyEvent : HTMLElementKeyEventHandler );
        gtFOCUS :
            ( focusEvent : HTMLElementFocusEventHandler );
        gtSCROLL :
            ( scrollEvent : HTMLElementScrollEventHandler );
        gtTIMER :
            ( timerEvent : HTMLElementTimerEventHandler );
        gtSIZE :
            ( sizeEvent : HTMLElementSizeEventHandler );
        gtDRAW :
            ( drawEvent : HTMLElementDrawEventHandler );
        gtDATA_ARRIVED :
            ( dataArridedEvent : HTMLElementDataArrivedEventHandler );
        gtEXCHANGE :
            ( exchangeEvent : HTMLElementExchangeEventHandler );
        gtGESTURE :
            ( gestureEvent : HTMLElementGestureEventHandler );
        gtBEHAVIOR :
            ( behaviorEvent : HTMLElementBehaviorEventHandler );
    end;

    PHtmlEventHandler = ^RHtmlEventHandler;
    THtmlEventHandlerArray = array of RHtmlEventHandler;

    {***************************************************************************
    * THtmlEventHandler
    ***************************************************************************}
    THtmlEventHandler = class
private
    Fevents                     : THtmlEventHandlerArray;
    //FnodeId                     : string;
    //Fowner                      : TObject; //THTMLTagNode

    FeventsHead                 : integer;

protected
    function    setHandler( aEventType : THtmlEventType; const aSelector : string ) : PHtmlEventHandler;
    function    getHandler( aEventType : THtmlEventType; const aSelector : string ) : PHtmlEventHandler;

public
    constructor Create( {aOwner : TObject} {THTMLTagNode} );
    destructor  Destroy(); override;

    procedure   bind( aDomRoot : THtmlElement );

public // events
    procedure   setInitializationHandler( aHandler : HTMLElementInitializationEventHandler; aEventType : THtmlEventType; const aSelector : string );
    procedure   setMouseHandler( aHandler : HTMLElementMouseEventHandler; aEventType : THtmlEventType; const aSelector : string );
    procedure   setKeyHandler( aHandler : HTMLElementKeyEventHandler; aEventType : THtmlEventType; const aSelector : string );
    procedure   setFocusHandler( aHandler : HTMLElementFocusEventHandler; aEventType : THtmlEventType; const aSelector : string );
    procedure   setScrollHandler( aHandler : HTMLElementScrollEventHandler; aEventType : THtmlEventType; const aSelector : string );
    procedure   setTimerHandler( aHandler : HTMLElementTimerEventHandler; aEventType : THtmlEventType; const aSelector : string );
    procedure   setSizeHandler( aHandler : HTMLElementSizeEventHandler; aEventType : THtmlEventType; const aSelector : string );
    procedure   setDrawHandler( aHandler : HTMLElementDrawEventHandler; aEventType : THtmlEventType; const aSelector : string );
    procedure   setDataArrivedHandler( aHandler : HTMLElementDataArrivedEventHandler; aEventType : THtmlEventType; const aSelector : string );
    procedure   setExchangeHandler( aHandler : HTMLElementExchangeEventHandler; aEventType : THtmlEventType; const aSelector : string );
    procedure   setGestureHandler( aHandler : HTMLElementGestureEventHandler; aEventType : THtmlEventType; const aSelector : string );
    procedure   setBehaviorHandler( aHandler : HTMLElementBehaviorEventHandler; aEventType : THtmlEventType; const aSelector : string );


    function    getInitializationHandler( aEventType : THtmlEventType; const aSelector : string ) : HTMLElementInitializationEventHandler;
    function    getMouseHandler( aEventType : THtmlEventType; const aSelector : string ) : HTMLElementMouseEventHandler;
    function    getKeyHandler( aEventType : THtmlEventType; const aSelector : string ) : HTMLElementKeyEventHandler;
    function    getFocusHandler( aEventType : THtmlEventType; const aSelector : string ) : HTMLElementFocusEventHandler;
    function    getScrollHandler( aEventType : THtmlEventType; const aSelector : string ) : HTMLElementScrollEventHandler;
    function    getTimerHandler( aEventType : THtmlEventType; const aSelector : string ) : HTMLElementTimerEventHandler;
    function    getSizeHandler( aEventType : THtmlEventType; const aSelector : string ) : HTMLElementSizeEventHandler;
    function    getDrawHandler( aEventType : THtmlEventType; const aSelector : string ) : HTMLElementDrawEventHandler;
    function    getDataArrivedHandler( aEventType : THtmlEventType; const aSelector : string ) : HTMLElementDataArrivedEventHandler;
    function    getExchangeHandler( aEventType : THtmlEventType; const aSelector : string ) : HTMLElementExchangeEventHandler;
    function    getGestureHandler( aEventType : THtmlEventType; const aSelector : string ) : HTMLElementGestureEventHandler;
    function    getBehaviorHandler( aEventType : THtmlEventType; const aSelector : string ) : HTMLElementBehaviorEventHandler;

    // INITIALIZATION
    procedure   onInitialization( aHandler  : HTMLElementInitializationEventHandler; const aSelector : string );
    procedure   onBehaviorDetach( aHandler  : HTMLElementInitializationEventHandler; const aSelector : string );
    procedure   onBehaviorAttach( aHandler  : HTMLElementInitializationEventHandler; const aSelector : string );

    // MOUSE
    procedure   onMouse( aHandler : HTMLElementMouseEventHandler; const aSelector : string ); // All MOUSE events
    procedure   onMouseEnter( aHandler : HTMLElementMouseEventHandler; const aSelector : string );
    procedure   onMouseLeave( aHandler : HTMLElementMouseEventHandler; const aSelector : string );
    procedure   onMouseMove( aHandler : HTMLElementMouseEventHandler; const aSelector : string );
    procedure   onMouseUp( aHandler : HTMLElementMouseEventHandler; const aSelector : string );
    procedure   onMouseDown( aHandler : HTMLElementMouseEventHandler; const aSelector : string );
    procedure   onMouseClick( aHandler : HTMLElementMouseEventHandler; const aSelector : string );
    procedure   onClick( aHandler : HTMLElementMouseEventHandler; const aSelector : string );
    procedure   onMouseDClick( aHandler : HTMLElementMouseEventHandler; const aSelector : string );
    procedure   onDblClick( aHandler : HTMLElementMouseEventHandler; const aSelector : string );
    procedure   onMouseWheel( aHandler : HTMLElementMouseEventHandler; const aSelector : string );
    procedure   onWheel( aHandler : HTMLElementMouseEventHandler; const aSelector : string );
    procedure   onMouseTick( aHandler : HTMLElementMouseEventHandler; const aSelector : string );
    procedure   onMouseIdle( aHandler : HTMLElementMouseEventHandler; const aSelector : string );
    procedure   onDrop( aHandler : HTMLElementMouseEventHandler; const aSelector : string );
    procedure   onDragEnter( aHandler : HTMLElementMouseEventHandler; const aSelector : string );
    procedure   onDragLeave( aHandler : HTMLElementMouseEventHandler; const aSelector : string );
    procedure   onDragRequest( aHandler : HTMLElementMouseEventHandler; const aSelector : string );
    procedure   onMouseDraggingEnter( aHandler : HTMLElementMouseEventHandler; const aSelector : string );
    procedure   onMouseDraggingLeave( aHandler : HTMLElementMouseEventHandler; const aSelector : string );
    procedure   onMouseDraggingMove( aHandler : HTMLElementMouseEventHandler; const aSelector : string );
    procedure   onMouseDraggingUp( aHandler : HTMLElementMouseEventHandler; const aSelector : string );
    procedure   onMouseDraggingDown( aHandler : HTMLElementMouseEventHandler; const aSelector : string );

    // KEY
    procedure   onKey( aHandler : HTMLElementKeyEventhandler; const aSelector : string );
    procedure   onKeyDown( aHandler : HTMLElementKeyEventhandler; const aSelector : string );
    procedure   onKeyUp( aHandler : HTMLElementKeyEventhandler; const aSelector : string );
    procedure   onKeyChar( aHandler : HTMLElementKeyEventhandler; const aSelector : string );

    // FOCUS
    procedure   onFocus( aHandler : HTMLElementFocusEventhandler; const aSelector : string );
    procedure   onFocusLost( aHandler : HTMLElementFocusEventhandler; const aSelector : string );
    procedure   onFocusGot( aHandler : HTMLElementFocusEventhandler; const aSelector : string );

    // SCROLL
    procedure   onScroll( aHandler : HTMLElementScrollEventhandler; const aSelector : string );
    procedure   onScrollHome( aHandler : HTMLElementScrollEventhandler; const aSelector : string );
    procedure   onScrollEnd( aHandler : HTMLElementScrollEventhandler; const aSelector : string );
    procedure   onScrollStepPlus( aHandler : HTMLElementScrollEventhandler; const aSelector : string );
    procedure   onScrollStepMinus( aHandler : HTMLElementScrollEventhandler; const aSelector : string );
    procedure   onScrollPagePlus( aHandler : HTMLElementScrollEventhandler; const aSelector : string );
    procedure   onScrollPageMinus( aHandler : HTMLElementScrollEventhandler; const aSelector : string );
    procedure   onScrollPos( aHandler : HTMLElementScrollEventhandler; const aSelector : string );
    procedure   onScrollSliderReleased( aHandler : HTMLElementScrollEventhandler; const aSelector : string );

    // TIMER
    procedure   onTimer( aHandler : HTMLElementTimerEventHandler; const aSelector : string );

    // SIZE
    procedure   onSize( aHandler : HTMLElementSizeEventHandler; const aSelector : string );

    // DRAW
    procedure   onDraw( aHandler : HTMLElementDrawEventhandler; const aSelector : string );
    procedure   onDrawBackground( aHandler : HTMLElementDrawEventhandler; const aSelector : string );
    procedure   onDrawContent( aHandler : HTMLElementDrawEventhandler; const aSelector : string );
    procedure   onDrawForeground( aHandler : HTMLElementDrawEventhandler; const aSelector : string );

    // DATA_ARRIVED
    procedure   onDataArrived( aHandler : HTMLElementDataArrivedEventHandler; const aSelector : string );

    // EXCHANGE
    procedure   onExchange( aHandler : HTMLElementExchangeEventhandler; const aSelector : string );
    procedure   onExchangeNone( aHandler : HTMLElementExchangeEventhandler; const aSelector : string );
    procedure   onExchangeCopy( aHandler : HTMLElementExchangeEventhandler; const aSelector : string );
    procedure   onExchangeMove( aHandler : HTMLElementExchangeEventhandler; const aSelector : string );
    procedure   onExchangeLink( aHandler : HTMLElementExchangeEventhandler; const aSelector : string );

    // GESTURE
    procedure   onGesture( aHandler : HTMLElementGestureEventhandler; const aSelector : string );
    procedure   onGestureResuest( aHandler : HTMLElementGestureEventhandler; const aSelector : string );
    procedure   onGestureZoom( aHandler : HTMLElementGestureEventhandler; const aSelector : string );
    procedure   onGesturePan( aHandler : HTMLElementGestureEventhandler; const aSelector : string );
    procedure   onGestureRotate( aHandler : HTMLElementGestureEventhandler; const aSelector : string );
    procedure   onGestureTap1( aHandler : HTMLElementGestureEventhandler; const aSelector : string );
    procedure   onGestureTap2( aHandler : HTMLElementGestureEventhandler; const aSelector : string );

    // BEHAVIOR_EVENT
    procedure   onButtonClick( aHandler : HTMLElementBehaviorEventhandler; const aSelector : string );
    procedure   onButtonPress( aHandler : HTMLElementBehaviorEventhandler; const aSelector : string );
    procedure   onButtonStateChanged( aHandler : HTMLElementBehaviorEventhandler; const aSelector : string );
    procedure   onEditValueChanging( aHandler : HTMLElementBehaviorEventhandler; const aSelector : string );
    procedure   onEditValueChanged( aHandler : HTMLElementBehaviorEventhandler; const aSelector : string );
    procedure   onSelectSelectionChanged( aHandler : HTMLElementBehaviorEventhandler; const aSelector : string );
    procedure   onSelectStateChanged( aHandler : HTMLElementBehaviorEventhandler; const aSelector : string );
    procedure   onPopupRequest( aHandler : HTMLElementBehaviorEventhandler; const aSelector : string );
    procedure   onPopupReady( aHandler : HTMLElementBehaviorEventhandler; const aSelector : string );
    procedure   onPopupDismissed( aHandler : HTMLElementBehaviorEventhandler; const aSelector : string );
    procedure   onMenuItemActive( aHandler : HTMLElementBehaviorEventhandler; const aSelector : string );
    procedure   onMenuItemClick( aHandler : HTMLElementBehaviorEventhandler; const aSelector : string );
    procedure   onContextMenuSetup( aHandler : HTMLElementBehaviorEventhandler; const aSelector : string );
    procedure   onContextMenuRequest( aHandler : HTMLElementBehaviorEventhandler; const aSelector : string );
    procedure   onVisiualStatusChanged( aHandler : HTMLElementBehaviorEventhandler; const aSelector : string );
    procedure   onDisabledStatusChanged( aHandler : HTMLElementBehaviorEventhandler; const aSelector : string );
    procedure   onPopupDismissing( aHandler : HTMLElementBehaviorEventhandler; const aSelector : string );
    // "grey" event codes  - notfications from behaviors from this SDK
    procedure   onHyperLinkClick( aHandler : HTMLElementBehaviorEventhandler; const aSelector : string );
    procedure   onTableHeaderClick( aHandler : HTMLElementBehaviorEventhandler; const aSelector : string );
    procedure   onTableRowClick( aHandler : HTMLElementBehaviorEventhandler; const aSelector : string );
    procedure   onTableRowDblClick( aHandler : HTMLElementBehaviorEventhandler; const aSelector : string );
    procedure   onElementCollapsed( aHandler : HTMLElementBehaviorEventhandler; const aSelector : string );
    procedure   onElementExpanded( aHandler : HTMLElementBehaviorEventhandler; const aSelector : string );
    procedure   onActivateChild( aHandler : HTMLElementBehaviorEventhandler; const aSelector : string );
    procedure   onDoSwitchTab( aHandler : HTMLElementBehaviorEventhandler; const aSelector : string );
    procedure   onInitDataView( aHandler : HTMLElementBehaviorEventhandler; const aSelector : string );
    procedure   onRowsDataRequest( aHandler : HTMLElementBehaviorEventhandler; const aSelector : string );
    procedure   onUiStateChanged( aHandler : HTMLElementBehaviorEventhandler; const aSelector : string );
    procedure   onFormSubmit( aHandler : HTMLElementBehaviorEventhandler; const aSelector : string );
    procedure   onFormReset( aHandler : HTMLElementBehaviorEventhandler; const aSelector : string );
    procedure   onDocumentComplete( aHandler : HTMLElementBehaviorEventhandler; const aSelector : string );
    procedure   onHistoryPush( aHandler : HTMLElementBehaviorEventhandler; const aSelector : string );
    procedure   onHistoryDrop( aHandler : HTMLElementBehaviorEventhandler; const aSelector : string );
    procedure   onHistoryPrior( aHandler : HTMLElementBehaviorEventhandler; const aSelector : string );
    procedure   onHistoryNext( aHandler : HTMLElementBehaviorEventhandler; const aSelector : string );
    procedure   onHistoryStateChanged( aHandler : HTMLElementBehaviorEventhandler; const aSelector : string );
    procedure   onClosePopup( aHandler : HTMLElementBehaviorEventhandler; const aSelector : string );
    procedure   onRequestTooltip( aHandler : HTMLElementBehaviorEventhandler; const aSelector : string );
    procedure   onAnimation( aHandler : HTMLElementBehaviorEventhandler; const aSelector : string );

    end;


implementation

uses htmlNode;

{*******************************************************************************
* Create
*******************************************************************************}
constructor THtmlEventHandler.Create( {aOwner : TObject} {THTMLTagNode} );
begin
    //Fowner := aOwner;

    SetLength( Fevents, 0 );
    FeventsHead := 0;
end;

{*******************************************************************************
* Destroy
*******************************************************************************}
destructor THtmlEventHandler.Destroy();
begin
    SetLength( Fevents, 0 );
    inherited;
end;

{*******************************************************************************
* setHandler
*******************************************************************************}
function THtmlEventHandler.setHandler( aEventType : THtmlEventType; const aSelector : string ) : PHtmlEventHandler;
begin
    inc( FeventsHead );
    SetLength( Fevents, FeventsHead );
    Result := @Fevents[ FeventsHead - 1 ];

    Result.eventType := aEventType;
    Result.selector  := aSelector;
end;

{*******************************************************************************
* INITIALIZATION
*******************************************************************************}
procedure THtmlEventHandler.setInitializationHandler( aHandler : HTMLElementInitializationEventHandler; aEventType : THtmlEventType; const aSelector : string );
begin
    setHandler( aEventType, aSelector ).initializationEvent := aHandler;
end;
procedure THtmlEventHandler.onInitialization( aHandler : HTMLElementInitializationEventHandler; const aSelector : string );
begin
    setInitializationHandler( aHandler, etINITIALIZATION_ALL, aSelector );
end;
procedure THtmlEventHandler.onBehaviorDetach( aHandler  : HTMLElementInitializationEventHandler; const aSelector : string );
begin
    setInitializationHandler( aHandler, etBEHAVIOR_DETACH, aSelector );
end;
procedure THtmlEventHandler.onBehaviorAttach( aHandler  : HTMLElementInitializationEventHandler; const aSelector : string );
begin
    setInitializationHandler( aHandler, etBEHAVIOR_ATTACH, aSelector );
end;

{*******************************************************************************
* MOUSE
*******************************************************************************}
procedure THtmlEventHandler.setMouseHandler( aHandler : HTMLElementMouseEventHandler; aEventType : THtmlEventType; const aSelector : string );
begin
    setHandler( aEventType, aSelector ).mouseEvent := aHandler;
end;
procedure THtmlEventHandler.onMouse( aHandler : HTMLElementMouseEventHandler; const aSelector : string );
begin
    setMouseHandler( aHandler, etMOUSE_ALL, aSelector );
end;
procedure THtmlEventHandler.onMouseEnter( aHandler : HTMLElementMouseEventHandler; const aSelector : string );
begin
    setMouseHandler( aHandler, etMOUSE_ENTER, aSelector );
end;
procedure THtmlEventHandler.onMouseLeave( aHandler : HTMLElementMouseEventHandler; const aSelector : string );
begin
    setMouseHandler( aHandler, etMOUSE_LEAVE, aSelector );
end;
procedure THtmlEventHandler.onMouseMove( aHandler : HTMLElementMouseEventHandler; const aSelector : string );
begin
    setMouseHandler( aHandler, etMOUSE_MOVE, aSelector );
end;
procedure THtmlEventHandler.onMouseUp( aHandler : HTMLElementMouseEventHandler; const aSelector : string );
begin
    setMouseHandler( aHandler, etMOUSE_UP, aSelector );
end;
procedure THtmlEventHandler.onMouseDown( aHandler : HTMLElementMouseEventHandler; const aSelector : string );
begin
    setMouseHandler( aHandler, etMOUSE_DOWN, aSelector );
end;
procedure THtmlEventHandler.onMouseClick( aHandler : HTMLElementMouseEventHandler; const aSelector : string );
begin
    setMouseHandler( aHandler,etMOUSE_CLICK, aSelector );
end;
procedure THtmlEventHandler.onClick( aHandler : HTMLElementMouseEventHandler; const aSelector : string );
begin
    setMouseHandler( aHandler, etMOUSE_CLICK, aSelector );
end;
procedure THtmlEventHandler.onMouseDClick( aHandler : HTMLElementMouseEventHandler; const aSelector : string );
begin
    setMouseHandler( aHandler, etMOUSE_DCLICK, aSelector );
end;
procedure THtmlEventHandler.onDblClick( aHandler : HTMLElementMouseEventHandler; const aSelector : string );
begin
    setMouseHandler( aHandler, etMOUSE_DCLICK, aSelector );
end;
procedure THtmlEventHandler.onMouseWheel( aHandler : HTMLElementMouseEventHandler; const aSelector : string );
begin
    setMouseHandler( aHandler, etMOUSE_WHEEL, aSelector );
end;
procedure THtmlEventHandler.onWheel( aHandler : HTMLElementMouseEventHandler; const aSelector : string );
begin
    setMouseHandler( aHandler, etMOUSE_WHEEL, aSelector );
end;
procedure THtmlEventHandler.onMouseTick( aHandler : HTMLElementMouseEventHandler; const aSelector : string );
begin
    setMouseHandler( aHandler, etMOUSE_TICK, aSelector );
end;
procedure THtmlEventHandler.onMouseIdle( aHandler : HTMLElementMouseEventHandler; const aSelector : string );
begin
    setMouseHandler( aHandler, etMOUSE_IDLE, aSelector );
end;
procedure THtmlEventHandler.onDrop( aHandler : HTMLElementMouseEventHandler; const aSelector : string );
begin
    setMouseHandler( aHandler, etDROP, aSelector );
end;
procedure THtmlEventHandler.onDragEnter( aHandler : HTMLElementMouseEventHandler; const aSelector : string );
begin
    setMouseHandler( aHandler, etDRAG_ENTER, aSelector );
end;
procedure THtmlEventHandler.onDragLeave( aHandler : HTMLElementMouseEventHandler; const aSelector : string );
begin
    setMouseHandler( aHandler, etDRAG_LEAVE, aSelector );
end;
procedure THtmlEventHandler.onDragRequest( aHandler : HTMLElementMouseEventHandler; const aSelector : string );
begin
    setMouseHandler( aHandler, etDRAG_REQUEST, aSelector );
end;
procedure THtmlEventHandler.onMouseDraggingEnter( aHandler : HTMLElementMouseEventHandler; const aSelector : string );
begin
    setMouseHandler( aHandler, etDRAG_MOUSE_ENTER, aSelector );
end;
procedure THtmlEventHandler.onMouseDraggingLeave( aHandler : HTMLElementMouseEventHandler; const aSelector : string );
begin
    setMouseHandler( aHandler, etDRAG_MOUSE_LEAVE, aSelector );
end;
procedure THtmlEventHandler.onMouseDraggingMove( aHandler : HTMLElementMouseEventHandler; const aSelector : string );
begin
    setMouseHandler( aHandler, etDRAG_MOUSE_MOVE, aSelector );
end;
procedure THtmlEventHandler.onMouseDraggingUp( aHandler : HTMLElementMouseEventHandler; const aSelector : string );
begin
    setMouseHandler( aHandler, etDRAG_MOUSE_UP, aSelector );
end;
procedure THtmlEventHandler.onMouseDraggingDown( aHandler : HTMLElementMouseEventHandler; const aSelector : string );
begin
    setMouseHandler( aHandler, etDRAG_MOUSE_DOWN, aSelector );
end;

{*******************************************************************************
* KEY
*******************************************************************************}
procedure THtmlEventHandler.setKeyHandler( aHandler : HTMLElementKeyEventHandler; aEventType : THtmlEventType; const aSelector : string );
begin
    setHandler( aEventType, aSelector ).keyEvent := aHandler;
end;
procedure THtmlEventHandler.onKey( aHandler : HTMLElementKeyEventhandler; const aSelector : string );
begin
    setKeyHandler( aHandler, etKEY_ALL, aSelector );
end;
procedure THtmlEventHandler.onKeyDown( aHandler : HTMLElementKeyEventhandler; const aSelector : string );
begin
    setKeyHandler( aHandler, etKEY_DOWN, aSelector );
end;
procedure THtmlEventHandler.onKeyUp( aHandler : HTMLElementKeyEventhandler; const aSelector : string );
begin
    setKeyHandler( aHandler, etKEY_UP, aSelector );
end;
procedure THtmlEventHandler.onKeyChar( aHandler : HTMLElementKeyEventhandler; const aSelector : string );
begin
    setKeyHandler( aHandler, etKEY_CHAR, aSelector );
end;

{*******************************************************************************
* FOCUS
*******************************************************************************}
procedure THtmlEventHandler.setFocusHandler( aHandler : HTMLElementFocusEventHandler; aEventType : THtmlEventType; const aSelector : string );
begin
    setHandler( aEventType, aSelector ).focusEvent := aHandler;
end;
procedure THtmlEventHandler.onFocus( aHandler : HTMLElementFocusEventhandler; const aSelector : string );
begin
    setFocusHandler( aHandler, etFOCUS_ALL, aSelector );
end;
procedure THtmlEventHandler.onFocusLost( aHandler : HTMLElementFocusEventhandler; const aSelector : string );
begin
    setFocusHandler( aHandler, etFOCUS_LOST, aSelector );
end;
procedure THtmlEventHandler.onFocusGot( aHandler : HTMLElementFocusEventhandler; const aSelector : string );
begin
    setFocusHandler( aHandler, etFOCUS_GOT, aSelector );
end;

{*******************************************************************************
* SCROLL
*******************************************************************************}
procedure THtmlEventHandler.setScrollHandler( aHandler : HTMLElementScrollEventHandler; aEventType : THtmlEventType; const aSelector : string );
begin
    setHandler( aEventType, aSelector ).scrollEvent := aHandler;
end;
procedure THtmlEventHandler.onScroll( aHandler : HTMLElementScrollEventhandler; const aSelector : string );
begin
    setScrollHandler( aHandler, etSCROLL_ALL, aSelector );
end;
procedure THtmlEventHandler.onScrollHome( aHandler : HTMLElementScrollEventhandler; const aSelector : string );
begin
    setScrollHandler( aHandler, etSCROLL_HOME, aSelector );
end;
procedure THtmlEventHandler.onScrollEnd( aHandler : HTMLElementScrollEventhandler; const aSelector : string );
begin
    setScrollHandler( aHandler, etSCROLL_END, aSelector );
end;
procedure THtmlEventHandler.onScrollStepPlus( aHandler : HTMLElementScrollEventhandler; const aSelector : string );
begin
    setScrollHandler( aHandler, etSCROLL_STEP_PLUS, aSelector );
end;
procedure THtmlEventHandler.onScrollStepMinus( aHandler : HTMLElementScrollEventhandler; const aSelector : string );
begin
    setScrollHandler( aHandler, etSCROLL_STEP_MINUS, aSelector );
end;
procedure THtmlEventHandler.onScrollPagePlus( aHandler : HTMLElementScrollEventhandler; const aSelector : string );
begin
    setScrollHandler( aHandler, etSCROLL_PAGE_PLUS, aSelector );
end;
procedure THtmlEventHandler.onScrollPageMinus( aHandler : HTMLElementScrollEventhandler; const aSelector : string );
begin
    setScrollHandler( aHandler, etSCROLL_PAGE_MINUS, aSelector );
end;
procedure THtmlEventHandler.onScrollPos( aHandler : HTMLElementScrollEventhandler; const aSelector : string );
begin
    setScrollHandler( aHandler, etSCROLL_POS, aSelector );
end;
procedure THtmlEventHandler.onScrollSliderReleased( aHandler : HTMLElementScrollEventhandler; const aSelector : string );
begin
    setScrollHandler( aHandler, etSCROLL_SLIDER_RELEASED, aSelector );
end;

{*******************************************************************************
* TIMER
*******************************************************************************}
procedure THtmlEventHandler.setTimerHandler( aHandler : HTMLElementTimerEventHandler; aEventType : THtmlEventType; const aSelector : string );
begin
    setHandler( aEventType, aSelector ).timerEvent := aHandler;
end;
procedure THtmlEventHandler.onTimer( aHandler : HTMLElementTimerEventHandler; const aSelector : string );
begin
    setTimerHandler( aHandler, etTIMER, aSelector );
end;

{*******************************************************************************
* TIMER
*******************************************************************************}
procedure THtmlEventHandler.setSizeHandler( aHandler : HTMLElementSizeEventHandler; aEventType : THtmlEventType; const aSelector : string );
begin
    setHandler( aEventType, aSelector ).sizeEvent := aHandler;
end;
procedure THtmlEventHandler.onSize( aHandler : HTMLElementSizeEventHandler; const aSelector : string );
begin
    setSizeHandler( aHandler, etSIZE, aSelector );
end;

{*******************************************************************************
* DRAW
*******************************************************************************}
procedure THtmlEventHandler.setDrawHandler( aHandler : HTMLElementDrawEventHandler; aEventType : THtmlEventType; const aSelector : string );
begin
    setHandler( aEventType, aSelector ).drawEvent := aHandler;
end;
procedure THtmlEventHandler.onDraw( aHandler : HTMLElementDrawEventhandler; const aSelector : string );
begin
    setDrawHandler( aHandler, etDRAW_ALL, aSelector );
end;
procedure THtmlEventHandler.onDrawBackground( aHandler : HTMLElementDrawEventhandler; const aSelector : string );
begin
    setDrawHandler( aHandler, etDRAW_BACKGROUND, aSelector );
end;
procedure THtmlEventHandler.onDrawContent( aHandler : HTMLElementDrawEventhandler; const aSelector : string );
begin
    setDrawHandler( aHandler, etDRAW_CONTENT, aSelector );
end;
procedure THtmlEventHandler.onDrawForeground( aHandler : HTMLElementDrawEventhandler; const aSelector : string );
begin
    setDrawHandler( aHandler, etDRAW_FOREGROUND, aSelector );
end;

{*******************************************************************************
* TIMER
*******************************************************************************}
procedure THtmlEventHandler.setDataArrivedHandler( aHandler : HTMLElementDataArrivedEventHandler; aEventType : THtmlEventType; const aSelector : string );
begin
    setHandler( aEventType, aSelector ).dataArridedEvent := aHandler;
end;
procedure THtmlEventHandler.onDataArrived( aHandler : HTMLElementDataArrivedEventHandler; const aSelector : string );
begin
    setDataArrivedHandler( aHandler, etDATA_ARRIVED, aSelector );
end;

{*******************************************************************************
* EXCHANGE
*******************************************************************************}
procedure THtmlEventHandler.setExchangeHandler( aHandler : HTMLElementExchangeEventHandler; aEventType : THtmlEventType; const aSelector : string );
begin
    setHandler( aEventType, aSelector ).exchangeEvent := aHandler;
end;
procedure THtmlEventHandler.onExchange( aHandler : HTMLElementExchangeEventhandler; const aSelector : string );
begin
    setExchangeHandler( aHandler, etEXC_ALL, aSelector );
end;
procedure THtmlEventHandler.onExchangeNone( aHandler : HTMLElementExchangeEventhandler; const aSelector : string );
begin
    setExchangeHandler( aHandler, etEXC_NONE, aSelector );
end;
procedure THtmlEventHandler.onExchangeCopy( aHandler : HTMLElementExchangeEventhandler; const aSelector : string );
begin
    setExchangeHandler( aHandler, etEXC_COPY, aSelector );
end;
procedure THtmlEventHandler.onExchangeMove( aHandler : HTMLElementExchangeEventhandler; const aSelector : string );
begin
    setExchangeHandler( aHandler, etEXC_MOVE, aSelector );
end;
procedure THtmlEventHandler.onExchangeLink( aHandler : HTMLElementExchangeEventhandler; const aSelector : string );
begin
    setExchangeHandler( aHandler, etEXC_LINK, aSelector );
end;

{*******************************************************************************
* GESTURE
*******************************************************************************}
procedure THtmlEventHandler.setGestureHandler( aHandler : HTMLElementGestureEventHandler; aEventType : THtmlEventType; const aSelector : string );
begin
    setHandler( aEventType, aSelector ).gestureEvent := aHandler;
end;
procedure THtmlEventHandler.onGesture( aHandler : HTMLElementGestureEventhandler; const aSelector : string );
begin
    setGestureHandler( aHandler, etGESTURE_ALL, aSelector );
end;
procedure THtmlEventHandler.onGestureResuest( aHandler : HTMLElementGestureEventhandler; const aSelector : string );
begin
    setGestureHandler( aHandler, etGESTURE_REQUEST, aSelector );
end;
procedure THtmlEventHandler.onGestureZoom( aHandler : HTMLElementGestureEventhandler; const aSelector : string );
begin
    setGestureHandler( aHandler, etGESTURE_ZOOM, aSelector );
end;
procedure THtmlEventHandler.onGesturePan( aHandler : HTMLElementGestureEventhandler; const aSelector : string );
begin
    setGestureHandler( aHandler, etGESTURE_PAN, aSelector );
end;
procedure THtmlEventHandler.onGestureRotate( aHandler : HTMLElementGestureEventhandler; const aSelector : string );
begin
    setGestureHandler( aHandler, etGESTURE_ROTATE, aSelector );
end;
procedure THtmlEventHandler.onGestureTap1( aHandler : HTMLElementGestureEventhandler; const aSelector : string );
begin
    setGestureHandler( aHandler, etGESTURE_TAP1, aSelector );
end;
procedure THtmlEventHandler.onGestureTap2( aHandler : HTMLElementGestureEventhandler; const aSelector : string );
begin
    setGestureHandler( aHandler, etGESTURE_TAP2, aSelector );
end;

{*******************************************************************************
* BEHAVIOR_EVENT
*******************************************************************************}
procedure THtmlEventHandler.setBehaviorHandler( aHandler : HTMLElementBehaviorEventHandler; aEventType : THtmlEventType; const aSelector : string );
begin
    setHandler( aEventType, aSelector ).behaviorEvent := aHandler;
end;
procedure THtmlEventHandler.onButtonClick( aHandler : HTMLElementBehaviorEventhandler; const aSelector : string );
begin
    setBehaviorHandler( aHandler, etBUTTON_CLICK, aSelector );
end;
procedure THtmlEventHandler.onButtonPress( aHandler : HTMLElementBehaviorEventhandler; const aSelector : string );
begin
    setBehaviorHandler( aHandler, etBUTTON_PRESS, aSelector );
end;
procedure THtmlEventHandler.onButtonStateChanged( aHandler : HTMLElementBehaviorEventhandler; const aSelector : string );
begin
    setBehaviorHandler( aHandler, etBUTTON_STATE_CHANGED, aSelector );
end;
procedure THtmlEventHandler.onEditValueChanging( aHandler : HTMLElementBehaviorEventhandler; const aSelector : string );
begin
    setBehaviorHandler( aHandler, etEDIT_VALUE_CHANGING, aSelector );
end;
procedure THtmlEventHandler.onEditValueChanged( aHandler : HTMLElementBehaviorEventhandler; const aSelector : string );
begin
    setBehaviorHandler( aHandler, etEDIT_VALUE_CHANGED, aSelector );
end;
procedure THtmlEventHandler.onSelectSelectionChanged( aHandler : HTMLElementBehaviorEventhandler; const aSelector : string );
begin
    setBehaviorHandler( aHandler, etSELECT_SELECTION_CHANGED, aSelector );
end;
procedure THtmlEventHandler.onSelectStateChanged( aHandler : HTMLElementBehaviorEventhandler; const aSelector : string );
begin
    setBehaviorHandler( aHandler, etSELECT_STATE_CHANGED, aSelector );
end;
procedure THtmlEventHandler.onPopupRequest( aHandler : HTMLElementBehaviorEventhandler; const aSelector : string );
begin
    setBehaviorHandler( aHandler, etPOPUP_REQUEST, aSelector );
end;
procedure THtmlEventHandler.onPopupReady( aHandler : HTMLElementBehaviorEventhandler; const aSelector : string );
begin
    setBehaviorHandler( aHandler, etPOPUP_READY, aSelector );
end;
procedure THtmlEventHandler.onPopupDismissed( aHandler : HTMLElementBehaviorEventhandler; const aSelector : string );
begin
    setBehaviorHandler( aHandler, etPOPUP_DISMISSED, aSelector );
end;
procedure THtmlEventHandler.onMenuItemActive( aHandler : HTMLElementBehaviorEventhandler; const aSelector : string );
begin
    setBehaviorHandler( aHandler, etMENU_ITEM_ACTIVE, aSelector );
end;
procedure THtmlEventHandler.onMenuItemClick( aHandler : HTMLElementBehaviorEventhandler; const aSelector : string );
begin
    setBehaviorHandler( aHandler, etMENU_ITEM_CLICK, aSelector );
end;
procedure THtmlEventHandler.onContextMenuSetup( aHandler : HTMLElementBehaviorEventhandler; const aSelector : string );
begin
    setBehaviorHandler( aHandler, etCONTEXT_MENU_SETUP, aSelector );
end;
procedure THtmlEventHandler.onContextMenuRequest( aHandler : HTMLElementBehaviorEventhandler; const aSelector : string );
begin
    setBehaviorHandler( aHandler, etCONTEXT_MENU_REQUEST, aSelector );
end;
procedure THtmlEventHandler.onVisiualStatusChanged( aHandler : HTMLElementBehaviorEventhandler; const aSelector : string );
begin
    setBehaviorHandler( aHandler, etVISIUAL_STATUS_CHANGED, aSelector );
end;
procedure THtmlEventHandler.onDisabledStatusChanged( aHandler : HTMLElementBehaviorEventhandler; const aSelector : string );
begin
    setBehaviorHandler( aHandler, etDISABLED_STATUS_CHANGED, aSelector );
end;
procedure THtmlEventHandler.onPopupDismissing( aHandler : HTMLElementBehaviorEventhandler; const aSelector : string );
begin
    setBehaviorHandler( aHandler, etPOPUP_DISMISSING, aSelector );
end;
// "grey" event codes  - notfications from behaviors from this SDK
procedure THtmlEventHandler.onHyperLinkClick( aHandler : HTMLElementBehaviorEventhandler; const aSelector : string );
begin
    setBehaviorHandler( aHandler, etHYPERLINK_CLICK, aSelector );
end;
procedure THtmlEventHandler.onTableHeaderClick( aHandler : HTMLElementBehaviorEventhandler; const aSelector : string );
begin
    setBehaviorHandler( aHandler, etTABLE_HEADER_CLICK, aSelector );
end;
procedure THtmlEventHandler.onTableRowClick( aHandler : HTMLElementBehaviorEventhandler; const aSelector : string );
begin
    setBehaviorHandler( aHandler, etTABLE_ROW_CLICK, aSelector );
end;
procedure THtmlEventHandler.onTableRowDblClick( aHandler : HTMLElementBehaviorEventhandler; const aSelector : string );
begin
    setBehaviorHandler( aHandler, etTABLE_ROW_DBL_CLICK, aSelector );
end;
procedure THtmlEventHandler.onElementCollapsed( aHandler : HTMLElementBehaviorEventhandler; const aSelector : string );
begin
    setBehaviorHandler( aHandler, etELEMENT_COLLAPSED, aSelector );
end;
procedure THtmlEventHandler.onElementExpanded( aHandler : HTMLElementBehaviorEventhandler; const aSelector : string );
begin
    setBehaviorHandler( aHandler, etELEMENT_EXPANDED, aSelector );
end;
procedure THtmlEventHandler.onActivateChild( aHandler : HTMLElementBehaviorEventhandler; const aSelector : string );
begin
    setBehaviorHandler( aHandler, etACTIVATE_CHILD, aSelector );
end;
procedure THtmlEventHandler.onDoSwitchTab( aHandler : HTMLElementBehaviorEventhandler; const aSelector : string );
begin
    setBehaviorHandler( aHandler, etDO_SWITCH_TAB, aSelector );
end;
procedure THtmlEventHandler.onInitDataView( aHandler : HTMLElementBehaviorEventhandler; const aSelector : string );
begin
    setBehaviorHandler( aHandler, etINIT_DATA_VIEW, aSelector );
end;
procedure THtmlEventHandler.onRowsDataRequest( aHandler : HTMLElementBehaviorEventhandler; const aSelector : string );
begin
    setBehaviorHandler( aHandler, etROWS_DATA_REQUEST, aSelector );
end;
procedure THtmlEventHandler.onUiStateChanged( aHandler : HTMLElementBehaviorEventhandler; const aSelector : string );
begin
    setBehaviorHandler( aHandler, etUI_STATE_CHANGED, aSelector );
end;
procedure THtmlEventHandler.onFormSubmit( aHandler : HTMLElementBehaviorEventhandler; const aSelector : string );
begin
    setBehaviorHandler( aHandler, etFORM_SUBMIT, aSelector );
end;
procedure THtmlEventHandler.onFormReset( aHandler : HTMLElementBehaviorEventhandler; const aSelector : string );
begin
    setBehaviorHandler( aHandler, etFORM_RESET, aSelector );
end;
procedure THtmlEventHandler.onDocumentComplete( aHandler : HTMLElementBehaviorEventhandler; const aSelector : string );
begin
    setBehaviorHandler( aHandler, etDOCUMENT_COMPLETE, aSelector );
end;
procedure THtmlEventHandler.onHistoryPush( aHandler : HTMLElementBehaviorEventhandler; const aSelector : string );
begin
    setBehaviorHandler( aHandler, etHISTORY_PUSH, aSelector );
end;
procedure THtmlEventHandler.onHistoryDrop( aHandler : HTMLElementBehaviorEventhandler; const aSelector : string );
begin
    setBehaviorHandler( aHandler, etHISTORY_DROP, aSelector );
end;
procedure THtmlEventHandler.onHistoryPrior( aHandler : HTMLElementBehaviorEventhandler; const aSelector : string );
begin
    setBehaviorHandler( aHandler, etHISTORY_PRIOR, aSelector );
end;
procedure THtmlEventHandler.onHistoryNext( aHandler : HTMLElementBehaviorEventhandler; const aSelector : string );
begin
    setBehaviorHandler( aHandler, etHISTORY_NEXT, aSelector );
end;
procedure THtmlEventHandler.onHistoryStateChanged( aHandler : HTMLElementBehaviorEventhandler; const aSelector : string );
begin
    setBehaviorHandler( aHandler, etHISTORY_STATE_CHANGED, aSelector );
end;
procedure THtmlEventHandler.onClosePopup( aHandler : HTMLElementBehaviorEventhandler; const aSelector : string );
begin
    setBehaviorHandler( aHandler, etCLOSE_POPUP, aSelector );
end;
procedure THtmlEventHandler.onRequestTooltip( aHandler : HTMLElementBehaviorEventhandler; const aSelector : string );
begin
    setBehaviorHandler( aHandler, etREQUEST_TOOLTIP, aSelector );
end;
procedure THtmlEventHandler.onAnimation( aHandler : HTMLElementBehaviorEventhandler; const aSelector : string );
begin
    setBehaviorHandler( aHandler, etANIMATION, aSelector );
end;

{*******************************************************************************
* getHandler
*******************************************************************************}
function THtmlEventHandler.getHandler( aEventType : THtmlEventType; const aSelector : string ) : PHtmlEventHandler;
var
    i : integer;
begin
    Result := nil;
    for i := 0 to FeventsHead - 1 do
    begin
        if ( ( Fevents[i].eventType <> aEventType ) or ( Fevents[i].selector <> aSelector ) ) then
            continue;

        Result := @Fevents[i];
        break;
    end;

    assert( Result <> nil, 'Event for selector "' + aSelector + '" not found.' );
end;

function THtmlEventHandler.getInitializationHandler( aEventType : THtmlEventType; const aSelector : string ) : HTMLElementInitializationEventHandler;
begin
    Result := getHandler( aEventType, aSelector ).initializationEvent;
end;
function THtmlEventHandler.getMouseHandler( aEventType : THtmlEventType; const aSelector : string ) : HTMLElementMouseEventHandler;
begin
    Result := getHandler( aEventType, aSelector ).mouseEvent;
end;
function THtmlEventHandler.getKeyHandler( aEventType : THtmlEventType; const aSelector : string ) : HTMLElementKeyEventHandler;
begin
    Result := getHandler( aEventType, aSelector ).keyEvent;
end;
function THtmlEventHandler.getFocusHandler( aEventType : THtmlEventType; const aSelector : string ) : HTMLElementFocusEventHandler;
begin
    Result := getHandler( aEventType, aSelector ).focusEvent;
end;
function THtmlEventHandler.getScrollHandler( aEventType : THtmlEventType; const aSelector : string ) : HTMLElementScrollEventHandler;
begin
    Result := getHandler( aEventType, aSelector ).scrollEvent;
end;
function THtmlEventHandler.getTimerHandler( aEventType : THtmlEventType; const aSelector : string ) : HTMLElementTimerEventHandler;
begin
    Result := getHandler( aEventType, aSelector ).timerEvent;
end;
function THtmlEventHandler.getSizeHandler( aEventType : THtmlEventType; const aSelector : string ) : HTMLElementSizeEventHandler;
begin
    Result := getHandler( aEventType, aSelector ).sizeEvent;
end;
function THtmlEventHandler.getDrawHandler( aEventType : THtmlEventType; const aSelector : string ) : HTMLElementDrawEventHandler;
begin
    Result := getHandler( aEventType, aSelector ).drawEvent;
end;
function THtmlEventHandler.getDataArrivedHandler( aEventType : THtmlEventType; const aSelector : string ) : HTMLElementDataArrivedEventHandler;
begin
    Result := getHandler( aEventType, aSelector ).dataArridedEvent;
end;
function THtmlEventHandler.getExchangeHandler( aEventType : THtmlEventType; const aSelector : string ) : HTMLElementExchangeEventHandler;
begin
    Result := getHandler( aEventType, aSelector ).exchangeEvent;
end;
function THtmlEventHandler.getGestureHandler( aEventType : THtmlEventType; const aSelector : string ) : HTMLElementGestureEventHandler;
begin
    Result := getHandler( aEventType, aSelector ).gestureEvent;
end;
function THtmlEventHandler.getBehaviorHandler( aEventType : THtmlEventType; const aSelector : string ) : HTMLElementBehaviorEventHandler;
begin
    Result := getHandler( aEventType, aSelector ).behaviorEvent;
end;

{*******************************************************************************
* bind
*******************************************************************************}
procedure THtmlEventHandler.bind( aDomRoot : THtmlElement );
var
//    ptr : string;
    i : integer;
    nodes : THtmlElementList;
    selector : string;

begin
    //ptr := '[_ptr_=' + THTMLTagNode( Fowner ).attrs[ '_ptr_' ] + ']';

    for i := 0 to FeventsHead - 1 do
    begin
        selector := Fevents[i].selector;
        {if ( selector = '' ) then
        begin
            selector := ptr;
        end;}

        nodes := aDomRoot.elements[ selector ];

        case Fevents[i].eventType of
        // INITIALIZATION
        etINITIALIZATION_ALL :
            nodes.onInitialization := Fevents[i].initializationEvent;
        etBEHAVIOR_DETACH :
            nodes.onBehaviorDetach := Fevents[i].initializationEvent;
        etBEHAVIOR_ATTACH :
            nodes.onBehaviorAttach := Fevents[i].initializationEvent;

        // MOUSE
        etMOUSE_ALL :
            nodes.onMouse := Fevents[i].mouseEvent;
        etMOUSE_ENTER :
            nodes.onMouseEnter := Fevents[i].mouseEvent;
        etMOUSE_LEAVE :
            nodes.onMouseLeave := Fevents[i].mouseEvent;
        etMOUSE_MOVE :
            nodes.onMouseMove := Fevents[i].mouseEvent;
        etMOUSE_UP :
            nodes.onMouseUp := Fevents[i].mouseEvent;
        etMOUSE_DOWN :
            nodes.onMouseDown := Fevents[i].mouseEvent;
        etMOUSE_CLICK :
            nodes.onMouseClick := Fevents[i].mouseEvent;
        etMOUSE_DCLICK :
            nodes.onMouseDClick := Fevents[i].mouseEvent;
        etMOUSE_WHEEL :
            nodes.onMouseWheel := Fevents[i].mouseEvent;
        etMOUSE_TICK :
            nodes.onMouseTick := Fevents[i].mouseEvent;
        etMOUSE_IDLE :
            nodes.onMouseIdle := Fevents[i].mouseEvent;
        etDROP :
            nodes.onDrop := Fevents[i].mouseEvent;
        etDRAG_ENTER :
            nodes.onDragEnter := Fevents[i].mouseEvent;
        etDRAG_LEAVE :
            nodes.onDragLeave := Fevents[i].mouseEvent;
        etDRAG_REQUEST :
            nodes.onDragRequest := Fevents[i].mouseEvent;
        etDRAG_MOUSE_ENTER :
            nodes.onMouseDraggingEnter := Fevents[i].mouseEvent;
        etDRAG_MOUSE_LEAVE :
            nodes.onMouseDraggingLeave := Fevents[i].mouseEvent;
        etDRAG_MOUSE_MOVE :
            nodes.onMouseDraggingMove := Fevents[i].mouseEvent;
        etDRAG_MOUSE_UP :
            nodes.onMouseDraggingUp := Fevents[i].mouseEvent;
        etDRAG_MOUSE_DOWN :
            nodes.onMouseDraggingDown := Fevents[i].mouseEvent;

        // KEY
        etKEY_ALL :
            nodes.onKey := Fevents[i].keyEvent;
        etKEY_DOWN :
            nodes.onKeyDown := Fevents[i].keyEvent;
        etKEY_UP :
            nodes.onKeyUp := Fevents[i].keyEvent;
        etKEY_CHAR :
            nodes.onKeyChar := Fevents[i].keyEvent;

        // FOCUS
        etFOCUS_ALL :
            nodes.onFocus := Fevents[i].focusEvent;
        etFOCUS_LOST :
            nodes.onFocusLost := Fevents[i].focusEvent;
        etFOCUS_GOT :
            nodes.onFocusGot := Fevents[i].focusEvent;

        // SCROLL
        etSCROLL_ALL :
            nodes.onScroll := Fevents[i].scrollEvent;
        etSCROLL_HOME :
            nodes.onScrollHome := Fevents[i].scrollEvent;
        etSCROLL_END :
            nodes.onScrollEnd := Fevents[i].scrollEvent;
        etSCROLL_STEP_PLUS :
            nodes.onScrollStepPlus := Fevents[i].scrollEvent;
        etSCROLL_STEP_MINUS :
            nodes.onScrollStepMinus := Fevents[i].scrollEvent;
        etSCROLL_PAGE_PLUS :
            nodes.onScrollPagePlus := Fevents[i].scrollEvent;
        etSCROLL_PAGE_MINUS :
            nodes.onScrollPageMinus := Fevents[i].scrollEvent;
        etSCROLL_POS :
            nodes.onScrollPos := Fevents[i].scrollEvent;
        etSCROLL_SLIDER_RELEASED :
            nodes.onScrollSliderReleased := Fevents[i].scrollEvent;

        // TIMER
        etTIMER :
            nodes.onTimer := Fevents[i].timerEvent;

        // SIZE
        etSIZE :
            nodes.onSize := Fevents[i].sizeEvent;

        // DRAW
        etDRAW_ALL :
            nodes.onDraw := Fevents[i].drawEvent;
        etDRAW_BACKGROUND :
            nodes.onDrawBackground := Fevents[i].drawEvent;
        etDRAW_CONTENT :
            nodes.onDrawContent := Fevents[i].drawEvent;
        etDRAW_FOREGROUND :
            nodes.onDrawForeground := Fevents[i].drawEvent;

        // HANDLE_DATA_ARRIVED
        etDATA_ARRIVED :
            nodes.onDataArrived := Fevents[i].dataArridedEvent;

        // EXCHANGE
        etEXC_ALL :
            nodes.onExchange := Fevents[i].exchangeEvent;
        etEXC_NONE :
            nodes.onExchangeNone := Fevents[i].exchangeEvent;
        etEXC_COPY :
            nodes.onExchangeCopy := Fevents[i].exchangeEvent;
        etEXC_MOVE :
            nodes.onExchangeMove := Fevents[i].exchangeEvent;
        etEXC_LINK :
            nodes.onExchangeLink := Fevents[i].exchangeEvent;

        // GESTURE
        etGESTURE_ALL :
            nodes.onGesture := Fevents[i].gestureEvent;
        etGESTURE_REQUEST :
            nodes.onGestureRequest := Fevents[i].gestureEvent;
        etGESTURE_ZOOM :
            nodes.onGestureZoom := Fevents[i].gestureEvent;
        etGESTURE_PAN :
            nodes.onGesturePan := Fevents[i].gestureEvent;
        etGESTURE_ROTATE :
            nodes.onGestureRotate := Fevents[i].gestureEvent;
        etGESTURE_TAP1 :
            nodes.onGestureTap1 := Fevents[i].gestureEvent;
        etGESTURE_TAP2 :
            nodes.onGestureTap2 := Fevents[i].gestureEvent;

        // BEHAVIOR_EVENT
        etBUTTON_CLICK :
            nodes.onButtonClick := Fevents[i].behaviorEvent;
        etBUTTON_PRESS :
            nodes.onButtonPress := Fevents[i].behaviorEvent;
        etBUTTON_STATE_CHANGED :
            nodes.onButtonStateChanged := Fevents[i].behaviorEvent;
        etEDIT_VALUE_CHANGING :
            nodes.onEditValueChanging := Fevents[i].behaviorEvent;
        etEDIT_VALUE_CHANGED :
            nodes.onEditValueChanged := Fevents[i].behaviorEvent;
        etSELECT_SELECTION_CHANGED :
            nodes.onSelectSelectionChanged := Fevents[i].behaviorEvent;
        etSELECT_STATE_CHANGED :
            nodes.onSelectStateChanged := Fevents[i].behaviorEvent;
        etPOPUP_REQUEST :
            nodes.onPopupRequest := Fevents[i].behaviorEvent;
        etPOPUP_READY :
            nodes.onPopupReady := Fevents[i].behaviorEvent;
        etPOPUP_DISMISSED :
            nodes.onPopupDismissed := Fevents[i].behaviorEvent;
        etMENU_ITEM_ACTIVE :
            nodes.onMenuItemActive := Fevents[i].behaviorEvent;
        etMENU_ITEM_CLICK :
            nodes.onMenuItemClick := Fevents[i].behaviorEvent;
        etCONTEXT_MENU_SETUP :
            nodes.onContextMenuSetup := Fevents[i].behaviorEvent;
        etCONTEXT_MENU_REQUEST :
            nodes.onContextMenuRequest := Fevents[i].behaviorEvent;
        etVISIUAL_STATUS_CHANGED :
            nodes.onVisiualStatusChanged := Fevents[i].behaviorEvent;
        etDISABLED_STATUS_CHANGED :
            nodes.onDisabledStatusChanged := Fevents[i].behaviorEvent;
        etPOPUP_DISMISSING :
            nodes.onPopupDismissing := Fevents[i].behaviorEvent;
        etHYPERLINK_CLICK :
            nodes.onHyperLinkClick := Fevents[i].behaviorEvent;
        etTABLE_HEADER_CLICK :
            nodes.onTableHeaderClick := Fevents[i].behaviorEvent;
        etTABLE_ROW_CLICK :
            nodes.onTableRowClick := Fevents[i].behaviorEvent;
        etTABLE_ROW_DBL_CLICK :
            nodes.onTableRowDblClick := Fevents[i].behaviorEvent;
        etELEMENT_COLLAPSED :
            nodes.onElementCollapsed := Fevents[i].behaviorEvent;
        etELEMENT_EXPANDED :
            nodes.onElementExpanded := Fevents[i].behaviorEvent;
        etACTIVATE_CHILD :
            nodes.onActivateChild := Fevents[i].behaviorEvent;
        etDO_SWITCH_TAB :
            nodes.onDoSwitchTab := Fevents[i].behaviorEvent;
        etINIT_DATA_VIEW :
            nodes.onInitDataView := Fevents[i].behaviorEvent;
        etROWS_DATA_REQUEST :
            nodes.onRowsDataRequest := Fevents[i].behaviorEvent;
        etUI_STATE_CHANGED :
            nodes.onUiStateChanged := Fevents[i].behaviorEvent;
        etFORM_SUBMIT :
            nodes.onFormSubmit := Fevents[i].behaviorEvent;
        etFORM_RESET :
            nodes.onFormReset := Fevents[i].behaviorEvent;
        etDOCUMENT_COMPLETE :
            nodes.onDocumentComplete := Fevents[i].behaviorEvent;
        etHISTORY_PUSH :
            nodes.onHistoryPush := Fevents[i].behaviorEvent;
        etHISTORY_DROP :
            nodes.onHistoryDrop := Fevents[i].behaviorEvent;
        etHISTORY_PRIOR :
            nodes.onHistoryPrior := Fevents[i].behaviorEvent;
        etHISTORY_NEXT :
            nodes.onHistoryNext := Fevents[i].behaviorEvent;
        etHISTORY_STATE_CHANGED :
            nodes.onHistoryStateChanged := Fevents[i].behaviorEvent;
        etCLOSE_POPUP :
            nodes.onClosePopup := Fevents[i].behaviorEvent;
        etREQUEST_TOOLTIP :
            nodes.onRequestTooltip := Fevents[i].behaviorEvent;
        etANIMATION :
            nodes.onAnimation := Fevents[i].behaviorEvent;

        end;
    end;
end;

end.

