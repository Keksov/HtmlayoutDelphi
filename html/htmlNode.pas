unit htmlNode;

interface

uses classes, sysutils, Contnrs
    , htmlUtils
    , htmlConst
    , HtmlElement
    , htmlViewEvents
    , htmlStyle
    , htmlNodeInterface
;

type
    THTMLDocView = class;

    {***************************************************************************
    * THTMLNode
    ***************************************************************************}
    THTMLNode = class( TObject, IHTMLNode )
protected
    Fdocument                   : THTMLDocView;

    //THTMLNode = class( TInterfacedObject, IHTMLNode )
protected
    function    QueryInterface( const IID : TGUID; out Obj ) : HResult; stdcall;
    function    _AddRef() : integer; stdcall;
    function    _Release() : integer; stdcall;
    function    getISelf() : IHTMLNode;
    function    getSelf() : TObject;

    constructor Create( aDocument : THTMLDocView; aText : string = '' ); virtual;// abstract;
    function    getHtml() : string; virtual; abstract;
    procedure   clear(); virtual; abstract;

public
    procedure   saveToFile( const aFileName : string );

public // property
    property document : THTMLDocView read Fdocument;
    
    end;

    THTMLNodeClass = class of THTMLNode;

{-- THTMLTextNode --------------------------------------------------------------}

    {***************************************************************************
    * THTMLTextNode
    ***************************************************************************}
    THTMLTextNode = class( THTMLNode )
protected
    Ftext                       : string;

private
    function    getText() : string;
    procedure   setText( const aText : string );

protected
    function    internalGetText() : string; virtual;
    procedure   internalSetText( const aText : string ); virtual;

    function    getHtml() : string; override;
    procedure   clear(); override;

public
    constructor Create( aDocument : THTMLDocView; aText : string = '' ); override;

public // property
    property text : string read getText write setText;

    end;

//    THTMLTextNodeClass = class of THTMLTextNode;

{-- THTMLTextShim --------------------------------------------------------------}

    THTMLTagNode = class;

    {***************************************************************************
    * THTMLTextShim
    ***************************************************************************}
    THTMLTextShim = class( THTMLNode )
protected
    FtagNode                    : THTMLTagNode;

protected
    function    getText() : string;
    procedure   setText( const aText : string );
    function    getHTML() : string; override;
    procedure   clear(); override;

public
    constructor Create( aNode : THTMLTagNode ); reintroduce;
    destructor  Destroy(); override;

    end;

{-- THTMLNodeList -------------------------------------------------------------}

    {***************************************************************************
    * THTMLNodeList
    ***************************************************************************}
    THTMLNodeList = class( TInterfaceList ) // TInterfaceList
protected
    Fdocument                   : THTMLDocView;

private
    function    getHTML() : string;
    procedure   setHTML( const aString : string );
    function    getNode( aIndex : integer ) : TObject;

public
    constructor Create( aDocument : THTMLDocView );
    destructor  Destroy(); override;

    procedure   clear(); reintroduce;

    function    addNode( aClass : THTMLNodeClass ) : THTMLNode; overload;
    function    addNode( aClass : THTMLNodeClass { THTMLTextNodeClass }; aText : string ) : THTMLNode {THTMLTextNode}; overload;

public //property
    property html : string read getHTML write setHTML;
    property nodes[ aIndex : integer ] : TObject read getNode;

    end;

{-- THTMLTagNode -------------------------------------------------------------}

    {***************************************************************************
    * THTMLTagNode
    ***************************************************************************}
    THTMLTagNode = class( THTMLTextNode )
private
    Fchildren                   : THTMLNodeList;
    FtextShim                   : THTMLTextShim;
//    Fdocument                   : THTMLDocView;
    Fevents                     : THtmlEventHandler;
    FptrAttr                    : string;

protected
    //Fhtml                       : TStringList;
    // top level HTML tag, div by default
    Ftag                        : string;
    // objects ids, empty by default
    Fids                        : TStringList;
    // Delimiter used for list of ids, default '_' underscore
    FidDelimiter                : string;
    // List of objects classes, empty by default
    Fclasses                    : TStringList;
    // styles list for object, empty by default
    Fstyle                      : TStyleList;
    // misc attrs for the tag, empty by default
    Fattrs                      : TAttrList;

private
    function    getInnerHtml() : string;
    procedure   setInnerHtml( const aString : string );
    function    getChildren() : THTMLNodeList;
    function    getChildrenCount() : integer;
    function    getEvents() : THtmlEventHandler;
    function    getAttribute( const aAttrName : string ) : string;
    procedure   setAttribute( const aAttrName, aValue : string );

    procedure   setInitializationHandler( aEventType : THtmlEventType; aHandler : HTMLElementInitializationEventHandler );
    function    getInitializationHandler( aEventType : THtmlEventType ) : HTMLElementInitializationEventHandler;

    procedure   setMouseHandler( aEventType : THtmlEventType; aHandler : HTMLElementMouseEventHandler );
    function    getMouseHandler( aEventType : THtmlEventType ) : HTMLElementMouseEventHandler;

    procedure   setKeyHandler( aEventType : THtmlEventType; aHandler : HTMLElementKeyEventHandler );
    function    getKeyHandler( aEventType : THtmlEventType ) : HTMLElementKeyEventHandler;

    procedure   setFocusHandler( aEventType : THtmlEventType; aHandler : HTMLElementFocusEventHandler );
    function    getFocusHandler( aEventType : THtmlEventType ) : HTMLElementFocusEventHandler;

    procedure   setScrollHandler( aEventType : THtmlEventType; aHandler : HTMLElementScrollEventHandler );
    function    getScrollHandler( aEventType : THtmlEventType ) : HTMLElementScrollEventHandler;

    procedure   setTimerHandler( aEventType : THtmlEventType; aHandler : HTMLElementTimerEventHandler );
    function    getTimerHandler( aEventType : THtmlEventType ) : HTMLElementTimerEventHandler;

    procedure   setSizeHandler( aEventType : THtmlEventType; aHandler : HTMLElementSizeEventHandler );
    function    getSizeHandler( aEventType : THtmlEventType ) : HTMLElementSizeEventHandler;

    procedure   setDrawHandler( aEventType : THtmlEventType; aHandler : HTMLElementDrawEventHandler );
    function    getDrawHandler( aEventType : THtmlEventType ) : HTMLElementDrawEventHandler;

    procedure   setDataArrivedHandler( aEventType : THtmlEventType; aHandler : HTMLElementDataArrivedEventHandler );
    function    getDataArrivedHandler( aEventType : THtmlEventType ) : HTMLElementDataArrivedEventHandler;

    procedure   setExchangeHandler( aEventType : THtmlEventType; aHandler : HTMLElementExchangeEventHandler );
    function    getExchangeHandler( aEventType : THtmlEventType ) : HTMLElementExchangeEventHandler;

    procedure   setGestureHandler( aEventType : THtmlEventType; aHandler : HTMLElementGestureEventHandler );
    function    getGestureHandler( aEventType : THtmlEventType ) : HTMLElementGestureEventHandler;

    procedure   setBehaviorHandler( aEventType : THtmlEventType; aHandler : HTMLElementBehaviorEventHandler );
    function    getBehaviorHandler( aEventType : THtmlEventType ) : HTMLElementBehaviorEventHandler;

protected
    function    getHtml() : string; override;
    procedure   internalSetText( const aText : string ); override;

    function    getId() : string;
    procedure   addId( const aId : string );
    procedure   setId( const aId : string );

    function    getClass() : string;
    procedure   addClass( const aClass : string );

    procedure   setAttr( aAttr : EHTMLAttributes; const aValue : string );
    function    getAttr( aAttr : EHTMLAttributes ) : string;

    procedure   setIntAttr( aAttr : EHTMLAttributes; const aValue : integer );
    function    getIntAttr( aAttr : EHTMLAttributes ) : integer;

    procedure   internalSetAttr( aAttr : EHTMLAttributes; const aValue : string ); virtual;
    function    internalGetAttr( aAttr : EHTMLAttributes ) : string; virtual;

    function    getPtrAttr() : string;
    function    getPtrSelector() : string;

protected
//    procedure   internalSetInnerHTML( const aText : string ); virtual;

    // add the new tag description at the end of Fhtml
    //procedure   append( const aTag, aId, aClass, aStyle, aAttrs, aText : string ); virtual;
    // wrap current content of Fhtml into the given tag
    //procedure   enclose( const aTag, aId, aClass, aStyle, aAttrs : string ); virtual;


public
    constructor Create( aDocument : THTMLDocView; aText : string = '' ); override;
    destructor  Destroy(); override;

    procedure   clear(); override;

    function    addNode( aClass : THTMLNodeClass ) : THTMLNode; overload; virtual;
    function    addNode( aClass : THTMLNodeClass {THTMLTextNodeClass}; aText : string ) : THTMLNode {THTMLTextNode}; overload; virtual;
    function    addNode( const aTag : string; aText : string = '' ) : THTMLTagNode {THTMLTextNode}; overload; virtual;

    function    addText( const aString : string ) : THTMLTextNode; overload; virtual;
    procedure   addText( aStrings : array of string ); overload; virtual;

    procedure   addHtml( aNode : IHTMLNode ); overload; virtual;
    procedure   addHtml( aNodes : array of IHTMLNode ); overload; virtual;

    procedure   addNode( aNode : IHTMLNode ); overload; virtual;
    procedure   addNodes( aNodes : array of IHTMLNode ); overload; virtual;

public // events
    property onInitialization : HTMLElementInitializationEventHandler index etINITIALIZATION_ALL read getInitializationHandler write setInitializationHandler;
    property onBehaviorDetach : HTMLElementInitializationEventHandler index etBEHAVIOR_DETACH read getInitializationHandler write setInitializationHandler;
    property onBehaviorAttach : HTMLElementInitializationEventHandler index etBEHAVIOR_ATTACH read getInitializationHandler write setInitializationHandler;

    property onMouse : HTMLElementMouseEventHandler index etMOUSE_ALL read getMouseHandler write setMouseHandler;
    property onMouseEnter : HTMLElementMouseEventHandler index etMOUSE_ENTER read getMouseHandler write setMouseHandler;
    property onMouseLeave : HTMLElementMouseEventHandler index etMOUSE_LEAVE read getMouseHandler write setMouseHandler;
    property onMouseMove : HTMLElementMouseEventHandler index etMOUSE_MOVE read getMouseHandler write setMouseHandler;
    property onMouseUp : HTMLElementMouseEventHandler index etMOUSE_UP read getMouseHandler write setMouseHandler;
    property onMouseDown : HTMLElementMouseEventHandler index etMOUSE_DOWN read getMouseHandler write setMouseHandler;
    property onMouseClick : HTMLElementMouseEventHandler index etMOUSE_CLICK read getMouseHandler write setMouseHandler;
    property onClick : HTMLElementMouseEventHandler index etMOUSE_CLICK read getMouseHandler write setMouseHandler;
    property onMouseDClick : HTMLElementMouseEventHandler index etMOUSE_DCLICK read getMouseHandler write setMouseHandler;
    property onDblClick : HTMLElementMouseEventHandler index etMOUSE_DCLICK read getMouseHandler write setMouseHandler;
    property onMouseWheel : HTMLElementMouseEventHandler index etMOUSE_WHEEL read getMouseHandler write setMouseHandler;
    property onWheel : HTMLElementMouseEventHandler index etMOUSE_WHEEL read getMouseHandler write setMouseHandler;
    property onMouseTick : HTMLElementMouseEventHandler index etMOUSE_TICK read getMouseHandler write setMouseHandler;
    property onMouseIdle : HTMLElementMouseEventHandler index etMOUSE_IDLE read getMouseHandler write setMouseHandler;
    property onDrop : HTMLElementMouseEventHandler index etDROP read getMouseHandler write setMouseHandler;
    property onDragEnter : HTMLElementMouseEventHandler index etDRAG_ENTER read getMouseHandler write setMouseHandler;
    property onDragLeave : HTMLElementMouseEventHandler index etDRAG_LEAVE read getMouseHandler write setMouseHandler;
    property onDragRequest : HTMLElementMouseEventHandler index etDRAG_REQUEST read getMouseHandler write setMouseHandler;
    property onMouseDraggingEnter : HTMLElementMouseEventHandler index etDRAG_MOUSE_ENTER read getMouseHandler write setMouseHandler;
    property onMouseDraggingLeave : HTMLElementMouseEventHandler index etDRAG_MOUSE_LEAVE read getMouseHandler write setMouseHandler;
    property onMouseDraggingMove : HTMLElementMouseEventHandler index etDRAG_MOUSE_MOVE read getMouseHandler write setMouseHandler;
    property onMouseDraggingUp : HTMLElementMouseEventHandler index etDRAG_MOUSE_UP read getMouseHandler write setMouseHandler;
    property onMouseDraggingDown : HTMLElementMouseEventHandler index etDRAG_MOUSE_DOWN read getMouseHandler write setMouseHandler;

    property onKey : HTMLElementKeyEventhandler index etKEY_ALL read getKeyHandler write setKeyHandler;
    property onKeyDown : HTMLElementKeyEventhandler index etKEY_DOWN read getKeyHandler write setKeyHandler;
    property onKeyUp : HTMLElementKeyEventhandler index etKEY_UP read getKeyHandler write setKeyHandler;
    property onKeyChar : HTMLElementKeyEventhandler index etKEY_CHAR read getKeyHandler write setKeyHandler;

    property onFocus : HTMLElementFocusEventhandler index etFOCUS_ALL read getFocusHandler write setFocusHandler;
    property onFocusLost : HTMLElementFocusEventhandler index etFOCUS_LOST read getFocusHandler write setFocusHandler;
    property onFocusGot : HTMLElementFocusEventhandler index etFOCUS_GOT read getFocusHandler write setFocusHandler;

    property onScroll : HTMLElementScrollEventhandler index etSCROLL_ALL read getScrollHandler write setScrollHandler;
    property onScrollHome : HTMLElementScrollEventhandler index etSCROLL_HOME read getScrollHandler write setScrollHandler;
    property onScrollEnd : HTMLElementScrollEventhandler index etSCROLL_END read getScrollHandler write setScrollHandler;
    property onScrollStepPlus : HTMLElementScrollEventhandler index etSCROLL_STEP_PLUS read getScrollHandler write setScrollHandler;
    property onScrollStepMinus : HTMLElementScrollEventhandler index etSCROLL_STEP_MINUS read getScrollHandler write setScrollHandler;
    property onScrollPagePlus : HTMLElementScrollEventhandler index etSCROLL_PAGE_PLUS read getScrollHandler write setScrollHandler;
    property onScrollPageMinus : HTMLElementScrollEventhandler index etSCROLL_PAGE_MINUS read getScrollHandler write setScrollHandler;
    property onScrollPos : HTMLElementScrollEventhandler index etSCROLL_POS read getScrollHandler write setScrollHandler;
    property onScrollSliderReleased : HTMLElementScrollEventhandler index etSCROLL_SLIDER_RELEASED read getScrollHandler write setScrollHandler;

    property onTimer : HTMLElementTimerEventHandler index etTIMER read getTimerHandler write setTimerHandler;

    property onSize : HTMLElementSizeEventHandler index etSIZE read getSizeHandler write setSizeHandler;

    property onDraw : HTMLElementDrawEventhandler index etDRAW_ALL read getDrawHandler write setDrawHandler;
    property onDrawBackground : HTMLElementDrawEventhandler index etDRAW_BACKGROUND read getDrawHandler write setDrawHandler;
    property onDrawContent : HTMLElementDrawEventhandler index etDRAW_CONTENT read getDrawHandler write setDrawHandler;
    property onDrawForeground : HTMLElementDrawEventhandler index etDRAW_FOREGROUND read getDrawHandler write setDrawHandler;

    property onDataArrived : HTMLElementDataArrivedEventHandler index etDATA_ARRIVED read getDataArrivedHandler write setDataArrivedHandler;

    property onExchange : HTMLElementExchangeEventhandler index etEXC_ALL read getExchangeHandler write setExchangeHandler;
    property onExchangeNone : HTMLElementExchangeEventhandler index etEXC_NONE read getExchangeHandler write setExchangeHandler;
    property onExchangeCopy : HTMLElementExchangeEventhandler index etEXC_COPY read getExchangeHandler write setExchangeHandler;
    property onExchangeMove : HTMLElementExchangeEventhandler index etEXC_MOVE read getExchangeHandler write setExchangeHandler;
    property onExchangeLink : HTMLElementExchangeEventhandler index etEXC_LINK read getExchangeHandler write setExchangeHandler;

    property onGesture : HTMLElementGestureEventhandler index etGESTURE_ALL read getGestureHandler write setGestureHandler;
    property onGestureResuest : HTMLElementGestureEventhandler index etGESTURE_REQUEST read getGestureHandler write setGestureHandler;
    property onGestureZoom : HTMLElementGestureEventhandler index etGESTURE_ZOOM read getGestureHandler write setGestureHandler;
    property onGesturePan : HTMLElementGestureEventhandler index etGESTURE_PAN read getGestureHandler write setGestureHandler;
    property onGestureRotate : HTMLElementGestureEventhandler index etGESTURE_ROTATE read getGestureHandler write setGestureHandler;
    property onGestureTap1 : HTMLElementGestureEventhandler index etGESTURE_TAP1 read getGestureHandler write setGestureHandler;
    property onGestureTap2 : HTMLElementGestureEventhandler index etGESTURE_TAP2 read getGestureHandler write setGestureHandler;

    property onButtonClick : HTMLElementBehaviorEventhandler index etBUTTON_CLICK read getBehaviorHandler write setBehaviorHandler;
    property onButtonPress : HTMLElementBehaviorEventhandler index etBUTTON_PRESS read getBehaviorHandler write setBehaviorHandler;
    property onButtonStateChanged : HTMLElementBehaviorEventhandler index etBUTTON_STATE_CHANGED read getBehaviorHandler write setBehaviorHandler;
    property onEditValueChanging : HTMLElementBehaviorEventhandler index etEDIT_VALUE_CHANGING read getBehaviorHandler write setBehaviorHandler;
    property onEditValueChanged : HTMLElementBehaviorEventhandler index etEDIT_VALUE_CHANGED read getBehaviorHandler write setBehaviorHandler;
    property onSelectSelectionChanged : HTMLElementBehaviorEventhandler index etSELECT_SELECTION_CHANGED read getBehaviorHandler write setBehaviorHandler;
    property onSelectStateChanged : HTMLElementBehaviorEventhandler index etSELECT_STATE_CHANGED read getBehaviorHandler write setBehaviorHandler;
    property onPopupRequest : HTMLElementBehaviorEventhandler index etPOPUP_REQUEST read getBehaviorHandler write setBehaviorHandler;
    property onPopupReady : HTMLElementBehaviorEventhandler index etPOPUP_READY read getBehaviorHandler write setBehaviorHandler;
    property onPopupDismissed : HTMLElementBehaviorEventhandler index etPOPUP_DISMISSED read getBehaviorHandler write setBehaviorHandler;
    property onMenuItemActive : HTMLElementBehaviorEventhandler index etMENU_ITEM_ACTIVE read getBehaviorHandler write setBehaviorHandler;
    property onMenuItemClick : HTMLElementBehaviorEventhandler index etMENU_ITEM_CLICK read getBehaviorHandler write setBehaviorHandler;
    property onContextMenuSetup : HTMLElementBehaviorEventhandler index etCONTEXT_MENU_SETUP read getBehaviorHandler write setBehaviorHandler;
    property onContextMenuRequest : HTMLElementBehaviorEventhandler index etCONTEXT_MENU_REQUEST read getBehaviorHandler write setBehaviorHandler;
    property onVisiualStatusChanged : HTMLElementBehaviorEventhandler index etVISIUAL_STATUS_CHANGED read getBehaviorHandler write setBehaviorHandler;
    property onDisabledStatusChanged : HTMLElementBehaviorEventhandler index etDISABLED_STATUS_CHANGED read getBehaviorHandler write setBehaviorHandler;
    property onPopupDismissing : HTMLElementBehaviorEventhandler index etPOPUP_DISMISSING read getBehaviorHandler write setBehaviorHandler;
    // "grey" event codes  - notfications from behaviors from this SDK
    property onHyperLinkClick : HTMLElementBehaviorEventhandler index etHYPERLINK_CLICK read getBehaviorHandler write setBehaviorHandler;
    property onTableHeaderClick : HTMLElementBehaviorEventhandler index etTABLE_HEADER_CLICK read getBehaviorHandler write setBehaviorHandler;
    property onTableRowClick : HTMLElementBehaviorEventhandler index etTABLE_ROW_CLICK read getBehaviorHandler write setBehaviorHandler;
    property onTableRowDblClick : HTMLElementBehaviorEventhandler index etTABLE_ROW_DBL_CLICK read getBehaviorHandler write setBehaviorHandler;
    property onElementCollapsed : HTMLElementBehaviorEventhandler index etELEMENT_COLLAPSED read getBehaviorHandler write setBehaviorHandler;
    property onElementExpanded : HTMLElementBehaviorEventhandler index etELEMENT_EXPANDED read getBehaviorHandler write setBehaviorHandler;
    property onActivateChild : HTMLElementBehaviorEventhandler index etACTIVATE_CHILD read getBehaviorHandler write setBehaviorHandler;
    property onDoSwitchTab : HTMLElementBehaviorEventhandler index etDO_SWITCH_TAB read getBehaviorHandler write setBehaviorHandler;
    property onInitDataView : HTMLElementBehaviorEventhandler index etINIT_DATA_VIEW read getBehaviorHandler write setBehaviorHandler;
    property onRowsDataRequest : HTMLElementBehaviorEventhandler index etROWS_DATA_REQUEST read getBehaviorHandler write setBehaviorHandler;
    property onUiStateChanged : HTMLElementBehaviorEventhandler index etUI_STATE_CHANGED read getBehaviorHandler write setBehaviorHandler;
    property onFormSubmit : HTMLElementBehaviorEventhandler index etFORM_SUBMIT read getBehaviorHandler write setBehaviorHandler;
    property onFormReset : HTMLElementBehaviorEventhandler index etFORM_RESET read getBehaviorHandler write setBehaviorHandler;
    property onDocumentComplete : HTMLElementBehaviorEventhandler index etDOCUMENT_COMPLETE read getBehaviorHandler write setBehaviorHandler;
    property onHistoryPush : HTMLElementBehaviorEventhandler index etHISTORY_PUSH read getBehaviorHandler write setBehaviorHandler;
    property onHistoryDrop : HTMLElementBehaviorEventhandler index etHISTORY_DROP read getBehaviorHandler write setBehaviorHandler;
    property onHistoryPrior : HTMLElementBehaviorEventhandler index etHISTORY_PRIOR read getBehaviorHandler write setBehaviorHandler;
    property onHistoryNext : HTMLElementBehaviorEventhandler index etHISTORY_NEXT read getBehaviorHandler write setBehaviorHandler;
    property onHistoryStateChanged : HTMLElementBehaviorEventhandler index etHISTORY_STATE_CHANGED read getBehaviorHandler write setBehaviorHandler;
    property onClosePopup : HTMLElementBehaviorEventhandler index etCLOSE_POPUP read getBehaviorHandler write setBehaviorHandler;
    property onRequestTooltip : HTMLElementBehaviorEventhandler index etREQUEST_TOOLTIP read getBehaviorHandler write setBehaviorHandler;
    property onAnimation : HTMLElementBehaviorEventhandler index etANIMATION read getBehaviorHandler write setBehaviorHandler;

public // property
    //property html : string read getText;
    property innerHtml : string read getInnerHtml write setInnerHtml;
    property html : string read getHtml;
    property events : THtmlEventHandler read getEvents;

    property tag : string read Ftag write Ftag;
    property ids : string read getId write addId;
    property id : string read getId write setId;
    property cls : string read getClass write addClass;
    property attrs : TAttrList read Fattrs;
    property attribute[ const aAttrName : string ] : string read getAttribute write setAttribute; default; // just a shortcut for attrs
    property style : TStyleList read Fstyle;
    property children : THTMLNodeList read getChildren;
    property childrenCount : integer read getChildrenCount;

    end;

{-- THTMLStyleView ------------------------------------------------------------}

    {***************************************************************************
    * THTMLStyleView
    ***************************************************************************}
    THTMLStyleView = class( THTMLTagNode )
private
    function    getDeclaration( const aElement : string ) : string;
    procedure   setDeclaration( const aElement, aCSSDeclarations : string );

    function    getElement( const aElement : string ) : THTMLStyleElement;

public
    constructor Create( aDocuemnt : THTMLDocView; aInitialContent : string = '' ); override;

//    procedure   add( aStyleElement : THTMLStyleElement ); // overload;
//    procedure   add( const aElement, aCSSDeclarations : string ); overload;

public // property
    property declarations[ const aElement : string ] : string read getDeclaration write setDeclaration; default;

    end;

{-- THTMLHeadView -------------------------------------------------------------}

    {***************************************************************************
    * THTMLHeadView
    ***************************************************************************}
    THTMLHeadView = class( THTMLTagNode )
protected
    Fstyle                      : THTMLStyleView;

public
    constructor Create( aDocuemnt : THTMLDocView; aInitialContent : string = '' ); override;

public // property
    property style : THTMLStyleView read Fstyle;

    end;

{-- THTMLBodyView -------------------------------------------------------------}

    {***************************************************************************
    * THTMLBodyView
    ***************************************************************************}
    THTMLBodyView = class( THTMLTagNode )
public
    constructor Create( aDocuemnt : THTMLDocView; aInitialContent : string = '' ); override;

    end;

{-- THTMLDocView --------------------------------------------------------------}

    {***************************************************************************
    * THTMLDocView
    ***************************************************************************}
    THTMLDocView = class( THTMLTagNode )
protected
    Fhead                       : THTMLHeadView;
    Fbody                       : THTMLBodyView;
    FdomEvents                  : TObjectList;

protected
    function    addEventHandler( {aNodePtrAttr : string} ) : THtmlEventHandler;

public
    constructor Create( aInitialContent : string = '' ); reintroduce;
    destructor  Destroy(); override;

    procedure   attachEvents( aDomElement : THtmlElement );

public // property
    property head : THTMLHeadView read Fhead;
    property body : THTMLBodyView read Fbody;

    end;

implementation

{-- THTMLStyleView ------------------------------------------------------------}

{*******************************************************************************
* Create
*******************************************************************************}
constructor THTMLStyleView.Create( aDocuemnt : THTMLDocView; aInitialContent : string = '' );
begin
    inherited;
    Ftag := 'style';
end;

{*******************************************************************************
* add
*******************************************************************************}
{procedure THTMLStyleView.add( aStyleElement : THTMLStyleElement );
begin
    addText( aStyleElement.text );
end;}

{*******************************************************************************
* getElement
*******************************************************************************}
function THTMLStyleView.getElement( const aElement : string ) : THTMLStyleElement;
var
    i : integer;
    node : TObject;
begin
    Result := nil;
    for i := 0 to childrenCount - 1 do
    begin
        node := children.nodes[i];
        if not ( node is THTMLStyleElement ) then
            continue;

        if ( THTMLStyleElement( node ).element = aElement ) then
        begin
            Result := THTMLStyleElement( node );
            break;
        end;
    end;
end;

{*******************************************************************************
* add
*******************************************************************************}
{procedure THTMLStyleView.add( const aElement, aCSSDeclarations : string );
var
    styleElement : THTMLStyleElement;

begin
    styleElement := getElement
    styleElement := THTMLStyleElement.Create( aElement, aCSSDeclarations );
    add( styleElement );
    FreeAndNil( styleElement );
end;}

{*******************************************************************************
* getDeclaration
*******************************************************************************}
function THTMLStyleView.getDeclaration( const aElement : string ) : string;
var
    styleElement : THTMLStyleElement;

begin
    Result := '';
    styleElement := getElement( aElement );
    if ( styleElement = nil ) then
        exit;

    Result := styleElement.text;
end;

{*******************************************************************************
* setDeclaration
*******************************************************************************}
procedure THTMLStyleView.setDeclaration( const aElement, aCSSDeclarations : string );
var
    styleElement : THTMLStyleElement;

begin
    styleElement := getElement( aElement );
    if ( styleElement = nil ) then
    begin
        styleElement := THTMLStyleElement.Create( aElement );
        addNode( styleElement );
    end;

    styleElement.declarations := aCSSDeclarations;
end;

{-- THTMLHeadView -------------------------------------------------------------}

{*******************************************************************************
* Create
*******************************************************************************}
constructor THTMLHeadView.Create( aDocuemnt : THTMLDocView; aInitialContent : string = '' );
begin
    inherited;
    Ftag := 'head';

    Fstyle := THTMLStyleView( children.addNode( THTMLStyleView, aInitialContent ) );
end;

{-- THTMLBodyView -------------------------------------------------------------}

{*******************************************************************************
* Create
*******************************************************************************}
constructor THTMLBodyView.Create( aDocuemnt : THTMLDocView; aInitialContent : string = '' );
begin
    inherited;
    Ftag := 'body';
end;

{-- THTMLDocView --------------------------------------------------------------}

{*******************************************************************************
* Create
*******************************************************************************}
constructor THTMLDocView.Create( aInitialContent : string = '' );
begin
    inherited Create( self, aInitialContent );

    Ftag := 'html';

    Fhead := THTMLHeadView( children.addNode( THTMLHeadView, '' ) );
    Fbody := THTMLBodyView( children.addNode( THTMLBodyView, '' ) );

    FdomEvents := TObjectList.Create( true );
    //assert( Fbody.html <> '' );
end;

{*******************************************************************************
* Destroy
*******************************************************************************}
destructor THTMLDocView.Destroy();
begin
    FreeAndNil( FdomEvents );
    
    inherited;
end;

{*******************************************************************************
* THTMLDocView
*******************************************************************************}
function THTMLDocView.addEventHandler( {aNodePtrAttr : string} {aNode : THTMLTagNode} ) : THtmlEventHandler;
begin
    Result := THtmlEventHandler.Create( {aNode} );
    FdomEvents.add( Result );
end;

{*******************************************************************************
* attachEvents
*******************************************************************************}
procedure THTMLDocView.attachEvents( aDomElement : THtmlElement );
var
    i : integer;

begin
    for i := 0 to FdomEvents.Count - 1 do
    begin
        THtmlEventHandler( FdomEvents[i] ).bind( aDomElement );
    end;
end;


{-- THTMLNode -----------------------------------------------------------------}

{*******************************************************************************
* QueryInterface
*******************************************************************************}
function THTMLNode.QueryInterface(const IID: TGUID; out Obj): HResult;
begin
    if GetInterface( IID, Obj ) then
        Result := 0
    else
        Result := E_NOINTERFACE;
end;

{*******************************************************************************
* _AddRef
*******************************************************************************}
function THTMLNode._AddRef() : integer;
begin
    Result := 1;
end;

{*******************************************************************************
* _Release
*******************************************************************************}
function THTMLNode._Release() : integer;
begin
    Result := 1;
//    Free();
end;

{*******************************************************************************
* Create
*******************************************************************************}
constructor THTMLNode.Create( aDocument : THTMLDocView; aText : string = '' );
begin
    Fdocument := aDocument;

    _AddRef()
end;

{*******************************************************************************
* getISelf
*******************************************************************************}
function THTMLNode.getISelf() : IHTMLNode;
begin
    Result := IHTMLNode( self );
end;

{*******************************************************************************
* getSelf
*******************************************************************************}
function THTMLNode.getSelf() : TObject;
begin
    Result := self;
end;

{*******************************************************************************
* saveToFile
*******************************************************************************}
procedure THTMLNode.saveToFile( const aFileName : string );
var
    fs : TFileStream;
    flags: Word;
    s : string;
begin
    flags := fmOpenWrite;
    if not FileExists( aFileName ) then
    begin
        Flags := Flags or fmCreate;
    end;

    fs := TFileStream.Create( aFileName, Flags);
    try
        s := getHtml();
        fs.Position := 0;
        fs.Size := 0;
        fs.Write( s[1], Length(s) );
    finally
        FreeAndNil( fs );
    end;
end;

{-- THTMLTextNode -----------------------------------------------------------}

{*******************************************************************************
* Create
*******************************************************************************}
constructor THTMLTextNode.Create( aDocument : THTMLDocView; aText : string = '' );
begin
    inherited;
    text := aText;
end;

{*******************************************************************************
* getText
*******************************************************************************}
function THTMLTextNode.getText() : string;
begin
    Result := internalGetText();
end;

{*******************************************************************************
* setText
*******************************************************************************}
procedure THTMLTextNode.setText( const aText : string );
begin
    internalSetText( aText );
end;

{*******************************************************************************
* internalGetText
*******************************************************************************}
function THTMLTextNode.internalGetText() : string;
begin
    Result := Ftext;
end;

{*******************************************************************************
* internalSetText
*******************************************************************************}
procedure THTMLTextNode.internalSetText( const aText : string );
begin
    Ftext := aText;
end;

{*******************************************************************************
* getHTML
*******************************************************************************}
function THTMLTextNode.getHTML() : string;
begin
    Result := text;
end;

{*******************************************************************************
* clear
*******************************************************************************}
procedure THTMLTextNode.clear();
begin
    Ftext := '';
end;

{-- THTMLTextShim -------------------------------------------------------------}

{*******************************************************************************
* Create
*******************************************************************************}
constructor THTMLTextShim.Create( aNode : THTMLTagNode );
begin
    FtagNode := aNode;
end;

{*******************************************************************************
* Destroy
*******************************************************************************}
destructor THTMLTextShim.Destroy();
begin
    assert( FtagNode <> nil );
    FtagNode.FtextShim := nil;

    inherited;
end;

{*******************************************************************************
* getText
*******************************************************************************}
function THTMLTextShim.getText() : string;
begin
    assert( FtagNode <> nil );
    Result := FtagNode.text;
end;

{*******************************************************************************
* setText
*******************************************************************************}
procedure THTMLTextShim.setText( const aText : string );
begin
    assert( FtagNode <> nil );
    FtagNode.text := aText;
end;

{*******************************************************************************
* getHTML
*******************************************************************************}
function THTMLTextShim.getHTML() : string;
begin
    Result := getText();
end;

{*******************************************************************************
* clear
*******************************************************************************}
procedure THTMLTextShim.clear();
begin
    assert( FtagNode <> nil );
    //FtagNode.clear();
    FtagNode.text := '';
end;

{-- THTMLNodeList -------------------------------------------------------------}

{*******************************************************************************
* Create
*******************************************************************************}
constructor THTMLNodeList.Create( aDocument : THTMLDocView );
begin
    inherited Create();

    Fdocument := aDocument;
end;

{*******************************************************************************
* Destroy
*******************************************************************************}
destructor THTMLNodeList.Destroy();
var
    i : integer;
begin
    for  i := 0 to Count - 1 do
    begin
        nodes[i].Free();
    end;

    inherited;
end;

{*******************************************************************************
* clear
*******************************************************************************}
procedure THTMLNodeList.clear();
var
    i : integer;
    
begin
    for i := 0 to Count - 1 do
    begin
        IHTMLNode( items[i] ).clear();
    end;

    inherited;
end;

{*******************************************************************************
* addNode
*******************************************************************************}
function THTMLNodeList.addNode( aClass : THTMLNodeClass ) : THTMLNode;
begin
    Result := aClass.Create( Fdocument );
    inherited add( Result.getISelf() );
end;

{*******************************************************************************
* addNode
*******************************************************************************}
function THTMLNodeList.addNode( aClass : THTMLNodeClass; aText : string ) : THTMLNode;
begin
    Result := aClass.Create( Fdocument, aText );
    inherited add( Result.getISelf() );
end;

{*******************************************************************************
* getNode
*******************************************************************************}
function THTMLNodeList.getNode( aIndex : integer ) : TObject;
begin
    Result := IHTMLNode( items[ aIndex ] ).getSelf();
end;

{*******************************************************************************
* getHtml
*******************************************************************************}
function THTMLNodeList.getHtml() : string;
var
    i    : integer;

    {***************************************************************************
    * html
    ***************************************************************************}
    function html( aIndex : integer ) : string;
    begin
        Result := '';
        if ( items[ aIndex ] = nil ) then
            exit;

        //Result := THTMLNode( items[ aIndex ] ).getISelf().getHTML();
        Result := IHTMLNode( items[ aIndex ] ).getHTML();
    end;

    {***************************************************************************
    * add
    ***************************************************************************}
    procedure add( aIndex : integer; aPrefix : string );
    var
        s : string;
    begin
        s := html( aIndex );
        if ( s = '' ) then
            exit;

        Result := Result + aPrefix + s;
    end;

begin
    Result := '';
    if ( Count < 1 ) then
        exit;

    add( 0, '' );
    for i := 1 to Count - 1 do
    begin
        add( i, #10 );
    end;
end;

{*******************************************************************************
* setHtml
*******************************************************************************}
procedure THTMLNodeList.setHtml( const aString : string );
begin
    Clear();
    addNode( THTMLTextNode, aString );
end;

{-- THTMLTagNode --------------------------------------------------------------}

{*******************************************************************************
* Create
*******************************************************************************}
constructor THTMLTagNode.Create( aDocument : THTMLDocView; aText : string = '' );
begin
    Fchildren := nil;
    Fevents   := nil;
    
    inherited Create( aDocument, aText );

    Ftag     := 'div';
    Fids     := TStringList.Create();
    Fclasses := TStringList.Create();
    Fstyle   := TStyleList.Create();
    Fattrs   := TAttrList.Create();
end;

{*******************************************************************************
* Destroy
*******************************************************************************}
destructor THTMLTagNode.Destroy();
begin
    clear();

    FreeAndNil( Fids );
    FreeAndNil( Fclasses );
    FreeAndNil( Fstyle );
    FreeAndNil( Fattrs );
    FreeAndNil( Fchildren );

    inherited;
end;

{*******************************************************************************
* clear
*******************************************************************************}
procedure THTMLTagNode.clear();
begin
    Fids.Clear();
    Fclasses.Clear();
    Fstyle.Clear();
    Fattrs.Clear();

    if ( Fchildren <> nil ) then
    begin
        Fchildren.Clear();
    end;
end;

{*******************************************************************************
* THTMLNodeList
*******************************************************************************}
function THTMLTagNode.getChildren() : THTMLNodeList;
begin
    if ( Fchildren = nil ) then
    begin
        Fchildren := THTMLNodeList.Create( Fdocument );
    end;

    Result := Fchildren;
end;

{*******************************************************************************
* getChildrenCount
*******************************************************************************}
function THTMLTagNode.getChildrenCount() : integer;
begin
    if ( Fchildren = nil ) then
        Result := 0
    else
        Result := Fchildren.Count;
end;

{*******************************************************************************
* internalSetText
*******************************************************************************}
procedure THTMLTagNode.internalSetText( const aText : string );
begin
    inherited;

    if ( aText = '' ) then
        exit;

    if ( FtextShim <> nil ) then
        exit;

    FtextShim := THTMLTextShim.Create( self );
    children.Add( FtextShim.getISelf() );
end;

{*******************************************************************************
* getInnerHtml
*******************************************************************************}
function THTMLTagNode.getInnerHtml() : string;
begin
    Result := '';
    if ( Fchildren = nil ) then
        exit;

    Result := Fchildren.html;
end;

{*******************************************************************************
* setInnerHtml
*******************************************************************************}
procedure THTMLTagNode.setInnerHtml( const aString : string );
begin
    if ( aString = '' ) then
    begin
        FreeAndNil( Fchildren );
        exit;
    end;

    children.html := aString;
end;

{*******************************************************************************
* getPtrAttr
*******************************************************************************}
function THTMLTagNode.getPtrAttr() : string;
begin
    if ( FptrAttr = '' ) then
    begin
        FptrAttr := IntToHex( int64( @self ), 1 );
    end;

    Result := FptrAttr
end;

{*******************************************************************************
* getPtrSelector
*******************************************************************************}
function THTMLTagNode.getPtrSelector() : string;
begin
    Result := '[_ptr_="' + getPtrAttr() + '"]';
end;

{*******************************************************************************
* getHTML
*******************************************************************************}
function THTMLTagNode.getHTML() : string;
var
    ch : string;

begin
    ch := '';
    Result := tagOpen( Ftag, id, cls, Fstyle.text, Fattrs.text );
    if ( Fchildren <> nil ) then
    begin
        ch := IfThen( Fchildren.Count = 1, ch, #10 );
        Result := Result + ch + Fchildren.html;
    end;
    Result := Result + ch + tagClose( Ftag );
end;

{*******************************************************************************
* getId
*******************************************************************************}
function THTMLTagNode.getId() : string;
begin
    Result := implode( Fids, FidDelimiter );
end;

{*******************************************************************************
* addId
*******************************************************************************}
procedure THTMLTagNode.addId( const aId : string );
begin
    Fids.Add( aId );
end;

{*******************************************************************************
* setId
*******************************************************************************}
procedure THTMLTagNode.setId( const aId : string );
begin
    Fids.Clear();
    addId( aId );
end;

{*******************************************************************************
* setAttr
*******************************************************************************}
procedure THTMLTagNode.setAttr( aAttr : EHTMLAttributes; const aValue : string );
begin
    internalSetAttr( aAttr, aValue );
end;

{*******************************************************************************
* getAttr
*******************************************************************************}
function THTMLTagNode.getAttr( aAttr : EHTMLAttributes ) : string;
begin
    internalGetAttr( aAttr );
end;

{*******************************************************************************
* setIntAttr
*******************************************************************************}
procedure THTMLTagNode.setIntAttr( aAttr : EHTMLAttributes; const aValue : integer );
var
    v : string;

begin
    v := IntToStr( aValue );
    internalSetAttr( aAttr, v );
end;

{*******************************************************************************
* getIntAttr
*******************************************************************************}
function THTMLTagNode.getIntAttr( aAttr : EHTMLAttributes ) : integer;
begin
    Result := StrToInt( internalGetAttr( aAttr ) );
end;

{*******************************************************************************
* internalSetAttr
*******************************************************************************}
procedure THTMLTagNode.internalSetAttr( aAttr : EHTMLAttributes; const aValue : string );
begin
    attrs[ HTMLAttributes[ aAttr ] ] := aValue;
end;

{*******************************************************************************
* internalGetAttr
*******************************************************************************}
function THTMLTagNode.internalGetAttr( aAttr : EHTMLAttributes ) : string;
begin
    Result := attrs[ HTMLAttributes[ aAttr ] ];
end;

{*******************************************************************************
* getClass
*******************************************************************************}
function THTMLTagNode.getClass() : string;
begin
    Result := implode( Fclasses, ' ' );
end;

{*******************************************************************************
* addClass
*******************************************************************************}
procedure THTMLTagNode.addClass( const aClass : string );
begin
    Fclasses.Add( aClass );
end;

{*******************************************************************************
* addText
*******************************************************************************}
function THTMLTagNode.addText( const aString : string ) : THTMLTextNode;
begin
    Result := THTMLTextNode( children.addNode( THTMLTextNode, aString ) );
end;

{*******************************************************************************
* addText
*******************************************************************************}
procedure THTMLTagNode.addText( aStrings : array of string );
var
    i : integer;
begin
    for i := Low( aStrings ) to High( aStrings ) do
    begin
        addText( aStrings[i] );
    end;
end;

{*******************************************************************************
* addHtml
*******************************************************************************}
procedure THTMLTagNode.addHtml( aNode : IHTMLNode );
begin
    addText( aNode.getHtml() );
end;

{*******************************************************************************
* addHtml
*******************************************************************************}
procedure THTMLTagNode.addHtml( aNodes : array of IHTMLNode );
var
    i : integer;
begin
    for i := Low( aNodes ) to High( aNodes ) do
    begin
        addHtml( aNodes[i] );
    end;
end;

{*******************************************************************************
* addNode
*******************************************************************************}
function THTMLTagNode.addNode( aClass : THTMLNodeClass ) : THTMLNode;
begin
    Result := children.addNode( aClass );
    //assert( html <> '' );
end;

{*******************************************************************************
* addNode
*******************************************************************************}
function THTMLTagNode.addNode( aClass : THTMLNodeClass; aText : string ) : THTMLNode;
begin
    Result := children.addNode( aClass, aText );
end;

{*******************************************************************************
* addNode
*******************************************************************************}
procedure THTMLTagNode.addNode( aNode : IHTMLNode );
begin
//    children.add( aNode.getSelf() );
    children.add( aNode );
end;

{*******************************************************************************
* addNode
*******************************************************************************}
function THTMLTagNode.addNode( const aTag : string; aText : string = '' ) : THTMLTagNode;
begin
    Result := THTMLTagNode( children.addNode( THTMLTagNode, aText ) );
    Result.tag := aTag;
end;

{*******************************************************************************
* addNodes
*******************************************************************************}
procedure THTMLTagNode.addNodes( aNodes : array of IHTMLNode );
var
    i : integer;
begin
    for i := Low( aNodes ) to High( aNodes ) do
    begin
        addNode( aNodes[i] );
    end;
end;

{*******************************************************************************
* getEvents
*******************************************************************************}
function THTMLTagNode.getEvents() : THtmlEventHandler;
begin
    assert( Fdocument <> nil );

    if ( Fevents = nil ) then
    begin
        Fevents := Fdocument.addEventHandler( {self} );
        attrs[ '_ptr_' ] := getPtrAttr();
    end;

    Result := Fevents;
end;

{*******************************************************************************
* getAttribute
*******************************************************************************}
function THTMLTagNode.getAttribute( const aAttrName : string ) : string;
begin
    Result := attrs[ aAttrName ];
end;

{*******************************************************************************
* setAttribute
*******************************************************************************}
procedure THTMLTagNode.setAttribute( const aAttrName, aValue : string );
begin
    attrs[ aAttrName ] := aValue;
end;

{*******************************************************************************
* INITIALIZATION
*******************************************************************************}
procedure THTMLTagNode.setInitializationHandler( aEventType : THtmlEventType; aHandler : HTMLElementInitializationEventHandler );
begin
    events.setInitializationHandler( aHandler, aEventType, getPtrSelector() );
end;
function THTMLTagNode.getInitializationHandler( aEventType : THtmlEventType ) : HTMLElementInitializationEventHandler;
begin
    Result := nil;
    if ( Fevents = nil ) then
        exit;

    Result := Fevents.getInitializationHandler( aEventtype, getPtrSelector() );
end;

{*******************************************************************************
* MOUSE
*******************************************************************************}
procedure THTMLTagNode.setMouseHandler( aEventType : THtmlEventType; aHandler : HTMLElementMouseEventHandler );
begin
    events.setMouseHandler( aHandler, aEventtype, getPtrSelector() );
end;
function THTMLTagNode.getMouseHandler( aEventType : THtmlEventType ) : HTMLElementMouseEventHandler;
begin
    Result := nil;
    if ( Fevents = nil ) then
        exit;

    Result := Fevents.getMouseHandler( aEventtype, getPtrSelector() );
end;

{*******************************************************************************
* KEY
*******************************************************************************}
procedure THTMLTagNode.setKeyHandler( aEventType : THtmlEventType; aHandler : HTMLElementKeyEventHandler );
begin
    events.setKeyHandler( aHandler, aEventtype, getPtrSelector() );
end;
function THTMLTagNode.getKeyHandler( aEventType : THtmlEventType ) : HTMLElementKeyEventHandler;
begin
    Result := nil;
    if ( Fevents = nil ) then
        exit;

    Result := Fevents.getKeyHandler( aEventtype, getPtrSelector() );
end;

{*******************************************************************************
* FOCUS
*******************************************************************************}
procedure THTMLTagNode.setFocusHandler( aEventType : THtmlEventType; aHandler : HTMLElementFocusEventHandler );
begin
    events.setFocusHandler( aHandler, aEventtype, getPtrSelector() );
end;
function THTMLTagNode.getFocusHandler( aEventType : THtmlEventType ) : HTMLElementFocusEventHandler;
begin
    Result := nil;
    if ( Fevents = nil ) then
        exit;

    Result := Fevents.getFocusHandler( aEventtype, getPtrSelector() );
end;

{*******************************************************************************
* SCROLL
*******************************************************************************}
procedure THTMLTagNode.setScrollHandler( aEventType : THtmlEventType; aHandler : HTMLElementScrollEventHandler );
begin
    events.setScrollHandler( aHandler, aEventtype, getPtrSelector() );
end;
function THTMLTagNode.getScrollHandler( aEventType : THtmlEventType ) : HTMLElementScrollEventHandler;
begin
    Result := nil;
    if ( Fevents = nil ) then
        exit;

    Result := Fevents.getScrollHandler( aEventtype, getPtrSelector() );
end;

{*******************************************************************************
* TIMER
*******************************************************************************}
procedure THTMLTagNode.setTimerHandler( aEventType : THtmlEventType; aHandler : HTMLElementTimerEventHandler );
begin
    events.setTimerHandler( aHandler, aEventtype, getPtrSelector() );
end;
function THTMLTagNode.getTimerHandler( aEventType : THtmlEventType ) : HTMLElementTimerEventHandler;
begin
    Result := nil;
    if ( Fevents = nil ) then
        exit;

    Result := Fevents.getTimerHandler( aEventtype, getPtrSelector() );
end;

{*******************************************************************************
* SIZE
*******************************************************************************}
procedure THTMLTagNode.setSizeHandler( aEventType : THtmlEventType; aHandler : HTMLElementSizeEventHandler );
begin
    events.setSizeHandler( aHandler, aEventtype, getPtrSelector() );
end;
function THTMLTagNode.getSizeHandler( aEventType : THtmlEventType ) : HTMLElementSizeEventHandler;
begin
    Result := nil;
    if ( Fevents = nil ) then
        exit;

    Result := Fevents.getSizeHandler( aEventtype, getPtrSelector() );
end;

{*******************************************************************************
* DRAW
*******************************************************************************}
procedure THTMLTagNode.setDrawHandler( aEventType : THtmlEventType; aHandler : HTMLElementDrawEventHandler );
begin
    events.setDrawHandler( aHandler, aEventtype, getPtrSelector() );
end;
function THTMLTagNode.getDrawHandler( aEventType : THtmlEventType ) : HTMLElementDrawEventHandler;
begin
    Result := nil;
    if ( Fevents = nil ) then
        exit;

    Result := Fevents.getDrawHandler( aEventtype, getPtrSelector() );
end;

{*******************************************************************************
* DATA_ARRIVED
*******************************************************************************}
procedure THTMLTagNode.setDataArrivedHandler( aEventType : THtmlEventType; aHandler : HTMLElementDataArrivedEventHandler );
begin
    events.setDataArrivedHandler( aHandler, aEventtype, getPtrSelector() );
end;
function THTMLTagNode.getDataArrivedHandler( aEventType : THtmlEventType ) : HTMLElementDataArrivedEventHandler;
begin
    Result := nil;
    if ( Fevents = nil ) then
        exit;

    Result := Fevents.getDataArrivedHandler( aEventtype, getPtrSelector() );
end;

{*******************************************************************************
* EXCHANGE
*******************************************************************************}
procedure THTMLTagNode.setExchangeHandler( aEventType : THtmlEventType; aHandler : HTMLElementExchangeEventHandler );
begin
    events.setExchangeHandler( aHandler, aEventtype, getPtrSelector() );
end;
function THTMLTagNode.getExchangeHandler( aEventType : THtmlEventType ) : HTMLElementExchangeEventHandler;
begin
    Result := nil;
    if ( Fevents = nil ) then
        exit;

    Result := Fevents.getExchangeHandler( aEventtype, getPtrSelector() );
end;

{*******************************************************************************
* GESTURE
*******************************************************************************}
procedure THTMLTagNode.setGestureHandler( aEventType : THtmlEventType; aHandler : HTMLElementGestureEventHandler );
begin
    events.setGestureHandler( aHandler, aEventtype, getPtrSelector() );
end;
function THTMLTagNode.getGestureHandler( aEventType : THtmlEventType ) : HTMLElementGestureEventHandler;
begin
    Result := nil;
    if ( Fevents = nil ) then
        exit;

    Result := Fevents.getGestureHandler( aEventtype, getPtrSelector() );
end;

{*******************************************************************************
* BEHAVIOR_EVENT
*******************************************************************************}
procedure THTMLTagNode.setBehaviorHandler( aEventType : THtmlEventType; aHandler : HTMLElementBehaviorEventHandler );
begin
    events.setBehaviorHandler( aHandler, aEventtype, getPtrSelector() );
end;
function THTMLTagNode.getBehaviorHandler( aEventType : THtmlEventType ) : HTMLElementBehaviorEventHandler;
begin
    Result := nil;
    if ( Fevents = nil ) then
        exit;

    Result := Fevents.getBehaviorHandler( aEventtype, getPtrSelector() );
end;

end.
