unit HtmlDOM;

interface

uses Windows, sysutils, Contnrs
    , HtmlCommon
    , HtmlBehaviour
    , HtmlTypes
    , HtmlDll
;

type

{---------------------------- HtmlElement -------------------------------------}

    RParentInfo = record
        index                   : cardinal;
        parent                  : HELEMENT;
        children_count          : cardinal;
    end;

    {***************************************************************************
    * THtmlHElement
    ***************************************************************************}
    THtmlHElement = class( TInterfacedObject )
private
    Fhandler                    : HELEMENT;
    FlastError                  : HLDOM_RESULT;

private
    function    getParentInfo() : RParentInfo;
    function    getId() : widestring;
    procedure   setId( const aId : widestring );
    function    getWidth() : integer;
    procedure   setWidth( const aPxValue : integer );
    function    getHeight() : integer;
    procedure   setHeight( const aPxValue : integer );
    function    getTop() : integer;
    procedure   setTop( const aPxValue : integer );
    function    getLeft() : integer;
    procedure   setLeft( const aPxValue : integer );

    function    getOuterHtml() : string;
    procedure   setOuterHtml( const aHtml : string );
    function    getInnerHtml() : string;
    procedure   setInnerHtml( const aHtml : string );
    function    getIndex() : cardinal;
    function    getAttributeByIndex( const aAttrIndex : cardinal ) : widestring;
    procedure   setAttributeByIndex( const aAttrIndex : cardinal; const aValue : widestring );
    function    getAttributeByName( const aAttrName : string ) : widestring;
    function    getAttributeInt( const aAttrName : string ) : integer;
    procedure   setAttributeInt( const aAttrName : string; const aValue : integer );
    function    getAttrExists( const aAttrName : string ) : boolean;
    function    getAttributeIndex( const aAttrName : string ) : integer;
    function    getInnerText() : string;
    procedure   setInnerText( const aUtf8bytes: string );
    function    getInnerText16() : widestring;
    procedure   setInnerText16( const aUtf16words: widestring );
    function    getLocation() : TRect;
    function    getStates() : cardinal;
    procedure   setStates( const aBits : cardinal );
    function    getState( const aBit : cardinal ) : boolean;
    procedure   setState( const aBit : cardinal; const aState : boolean );

protected
    function    getChild( const aIndex : integer ) : HELEMENT;
    function    getChildHandler( const aHandler : HELEMENT; const aIndex : integer ) : HELEMENT;
    function    getParentHandler() : HELEMENT;
    function    cloneHandler() : HELEMENT;
    function    getFirstSiblingHandler() : HELEMENT;
    function    getLastSiblingHandler() : HELEMENT;
    function    getNextSiblingHandler() : HELEMENT;
    function    getPrevSiblingHandler() : HELEMENT;
    function    getHandlerById( const aId : string ) : HELEMENT;
    function    getRootHandler() : HELEMENT;
    function    getElementUid( const aHandler : HELEMENT ) : UINT;
    function    getChildrenCount( const aHandler : HELEMENT ) : cardinal;

public
    constructor Create(); overload; virtual;
    constructor Create( const aHandler : HELEMENT ); overload;
    constructor Create( const aTag : string; const aText : widestring = '' ); overload;
    destructor  Destroy(); override;

    function    clone() : HELEMENT;
    function    get_element_by_id( const aId : string ) : HELEMENT;
    function    next_sibling() : HELEMENT;
    function    prev_sibling() : HELEMENT;
    function    first_sibling() : HELEMENT;
    function    last_sibling() : HELEMENT;
    procedure   insert( const aHandler : HELEMENT; const index : cardinal );
    procedure   append( const aHandler : HELEMENT );

    // delete DOM element given by Fhandler from html
    procedure   delete();
    function    is_valid() : boolean; overload;
    function    is_valid( const aHandler : HELEMENT ) : boolean; overload;
    function    children_count() : cardinal;
    function    get_attribute_count() : cardinal;
    function    get_attribute( const aAttrIndex : cardinal ) : widestring; overload;
    function    get_attribute( const aAttrName : string ) : widestring; overload;
    function    get_attribute_name( const aAttrIndex : cardinal ) : widestring;
    procedure   set_attribute( const aAttrName : string; const aValue : widestring );
    function    get_attribute_int( const aAttrName : string; aDefaultValue : integer = 0 ) : integer;
    procedure   remove_attribute( const aAttrName : string );
    function    get_style_attribute( const aAttrName : string ) : widestring;
    procedure   set_style_attribute( const aAttrName : string; const aValue : widestring );
    procedure   set_capture();
    procedure   select( aCallback : HTMLayoutElementCallback; const aParams : POINTER = nil; const aTag : string = ''; const aAttrName : string = ''; const aAttrValue : widestring = ''; aDepth : integer = 0 );

    procedure   update( const render_now : boolean = false ); overload;
    // aMode - bitwise combination of HTMLUpdateElementFlags
    procedure   update( const aMode : integer ); overload;
    procedure   redraw();
    function    get_location( const aArea : HTMLayoutElementAreas = ROOT_RELATIVE ) : TRect;
    function    is_inside( const client_pt : TPOINT ) : boolean;
    procedure   scroll_to_view( toTopOfView : boolean = false; smooth : boolean = false );
    function    get_element_type() : string;
    function    get_element_hwnd( const root_window : boolean ) : HWND;
    function    get_element_uid() : UINT;
    function    combine_url( const inURL : widestring ) : widestring;
    procedure   set_html( const html : string; where : HTMLayoutSetHTMLWhere = SIH_REPLACE_CONTENT );
    function    get_state( const bits : cardinal ) : boolean;
    procedure   set_state( const bitsToSet : cardinal; const bitsToClear : cardinal = 0; update : boolean = true );
    function    enabled() : boolean;
    function    visible() : boolean;
    procedure   detach(); overload;
    function    send_event( const event_code : cardinal; reason : cardinal = 0; heSource : HELEMENT = nil ) : boolean;
    procedure   post_event( const event_code : cardinal; reason : cardinal = 0; heSource : HELEMENT = nil );
    {** move element to new location given by x_view_rel, y_view_rel - view relative coordinates.
     *  Method defines local styles, so to "stick" it back to the original location you
     *  should call element::clear_all_style_attributes().
     **}
    procedure   move( x_view_rel, y_view_rel : integer ); overload;
    procedure   move( x_view_rel, y_view_rel, aWidth, aHeight : integer ); overload;

    procedure   attach( pevth : HTMLayoutHElementEvent; tag : Pointer = nil; subscription : UINT = HANDLE_ALL );
    procedure   detach( pevth : HTMLayoutHElementEvent; tag : Pointer = nil; subscription : UINT = HANDLE_ALL ); overload;

class procedure release_capture();
class function  cleanHtml( const aHtml : string ) : string; // remove 0xD, 0xA, 0x9 from string

public // property
    property id : widestring read getId write setId;
    property width : integer read getWidth write setWidth;
    property height : integer read getHeight write setHeight;
    property left : integer read getLeft write setLeft;
    property top : integer read getTop write setTop;
    property tag : string read get_element_type; // div, span, p, etc.
    property uid : UINT read get_element_uid;
    property states : cardinal read getStates write setStates;
    property state[ const aState : cardinal ] : boolean read getState write setState;
    property lastError : HLDOM_RESULT read FlastError;
    property handler : HELEMENT read Fhandler;
    property root : HELEMENT read getRootHandler;
    property parent : HELEMENT read getParentHandler;
    property child[ const aIndex : integer ] : HELEMENT read getChild;

    property outerHtml : string read getOuterHtml write setOuterHtml;
    property innerHtml : string read getInnerHtml write setInnerHtml;
    property childrenCount : cardinal read children_count;
    property index : cardinal read getIndex;
    property attributeCount : cardinal read get_attribute_count;
    property attributeByIndex[ const aAttrIndex : cardinal ] : widestring read getAttributeByIndex write setAttributeByIndex;
    property attribute[ const aAttrName : string ] : widestring read getAttributeByName write set_attribute; default;
    property attributeName[ const aIndex : cardinal ] : widestring read get_attribute_name;
    property attributeIndex[ const aAttrName : string ] : integer read getAttributeIndex;
    property attrAsInt[ const aAttrName : string ] : integer read getAttributeInt write setAttributeInt;
    property attrExists[ const aAttrName : string ] : boolean read getAttrExists;
    property style[ const aAttrName : string ] : widestring read get_style_attribute write set_style_attribute;
    property innerText : string read getInnerText write setInnerText;
    property innerText16 : widestring read getInnerText16 write setInnerText16;
    property location : TRect read getLocation;

{    function   FindFirst(sel: PWideChar): HtmlElement;

    procedure  Insert(e: HtmlElement; index: UINT);

    function   GetHtml(): AnsiString;
    procedure  SetHtml(html: WideString; where: UINT);

    procedure  SetBehaviorHandler(cb: IHtmlBehaviorListener);
    procedure  RemoveBehaviorHandler(cb: IHtmlBehaviorListener);
}

    end;

{------------------------------- THtmlElement ---------------------------------}

    THtmlElement = class;
    CHtmlElement = class of THtmlElement;

//    TElementSelectorHandler = function( he : HELEMENT; const aHtmlElement : THtmlElement; aParams : POINTER ) : boolean;

    HTMLElementProcEventHandler   = function( aElement : THtmlElement; aEventGroup : UINT; aEventParams : Pointer; aTag : Pointer ) : boolean;
    HTMLElementMethodEventHandler = function( aElement : THtmlElement; aEventGroup : UINT; aEventParams : Pointer; aTag : Pointer ) : boolean of object;

    HTMLElementInitializationEventHandler = function( const aSender : THtmlElement; const aParams : PHTMLayoutInitializationParams; aTag : Pointer ) : boolean of object;
    HTMLElementMouseEventHandler = function( const aSender : THtmlElement; const aParams : PHTMLayoutMouseParams; aTag : Pointer ) : boolean of object;
    HTMLElementKeyEventHandler   = function( const aSender : THtmlElement; const aParams : PHTMLayoutKeyParams; aTag : Pointer ) : boolean of object;
    HTMLElementFocusEventHandler = function( const aSender : THtmlElement; const aParams : PHTMLayoutFocusParams; aTag : Pointer ) : boolean of object;
    HTMLElementScrollEventHandler = function( const aSender : THtmlElement; const aParams : PHTMLayoutScrollParams; aTag : Pointer ) : boolean of object;
    HTMLElementTimerEventHandler = function( const aSender : THtmlElement; const aParams : PHTMLayoutTimerParams; aTag : Pointer ) : boolean of object;
    HTMLElementSizeEventHandler = function( const aSender : THtmlElement; aTag : Pointer ) : boolean of object;
    HTMLElementDrawEventHandler = function( const aSender : THtmlElement; const aParams : PHTMLayoutDrawParams; aTag : Pointer ) : boolean of object;
    HTMLElementDataArrivedEventHandler = function( const aSender : THtmlElement; const aParams : PHTMLayoutDataArrivedParams; aTag : Pointer ) : boolean of object;
    HTMLElementBehaviorEventHandler = function( const aSender : THtmlElement; const aParams : PHTMLayoutBehaviorEventParams; aTag : Pointer ) : boolean of object;
    HTMLElementExchangeEventHandler = function( const aSender : THtmlElement; const aParams : PHTMLayoutExchangeParams; aTag : Pointer ) : boolean of object;
    HTMLElementGestureEventHandler = function( const aSender : THtmlElement; const aParams : PHTMLayoutGestureParams; aTag : Pointer ) : boolean of object;

    {***************************************************************************
    * TEventHandlerParams
    ***************************************************************************}
    TEventHandlerParams = class
protected
    Felement                    : THtmlElement;
    Ftag                        : Pointer;
    Fsubscription               : UINT;

protected
    function    compare( aTag : Pointer; aSubscription : UINT ) : boolean;
    function    call( aEventGroup : UINT; aEventParams : Pointer ) : boolean; virtual; abstract;

public
    constructor Create( aElement : THtmlElement ); overload; virtual;
    constructor Create( aElement : THtmlElement; aTag : Pointer ); overload; virtual;
    constructor Create( aElement : THtmlElement; aTag : Pointer; aSubscription : UINT ); overload; virtual;

    end;

    {***************************************************************************
    * TProcHandlerParams
    ***************************************************************************}
    TProcHandlerParams = class( TEventHandlerParams )
protected
    Fcallback                   : HTMLElementProcEventHandler;

protected
    function    compare( aCallback : HTMLElementProcEventHandler; aTag : Pointer; aSubscription : UINT ) : boolean;
    function    call( aEventGroup : UINT; aEventParams : Pointer ) : boolean; override;

public
    constructor Create( aElement : THtmlElement; aCallback : HTMLElementProcEventHandler; aTag : Pointer = nil; aSubscription : UINT = HANDLE_ALL or DISABLE_INITIALIZATION );

    end;

    {***************************************************************************
    * TMethodHandlerParams
    ***************************************************************************}
    TMethodHandlerParams = class( TEventHandlerParams )
protected
    Fcallback                   : TMethod;

protected
    function    compare( aCallback : TMethod; aTag : Pointer; aSubscription : UINT ) : boolean;
    function    call( aEventGroup : UINT; aEventParams : Pointer ) : boolean; override;

public
    constructor Create( aElement : THtmlElement; aCallback : TMethod; aTag : Pointer = nil; aSubscription : UINT = HANDLE_ALL or DISABLE_INITIALIZATION );

    end;

    {***************************************************************************
    * THtmlCmdEventParams
    ***************************************************************************}
    THtmlCmdEventParams = class( TMethodHandlerParams )
protected
    Fcmd                : UINT;

public
    constructor Create( aElement : THtmlElement; aCallback : TMethod; aTag : Pointer; aSubscription : UINT = HANDLE_ALL or DISABLE_INITIALIZATION ); overload;
    constructor Create( aElement : THtmlElement; aCmd : UINT; aCallback : TMethod; aTag : Pointer = nil; aSubscription : UINT = HANDLE_ALL or DISABLE_INITIALIZATION  ); overload;

    function    compare( aCmd : UINT; aCallback : TMethod; aTag : Pointer; aSubscription : UINT ) : boolean;
    end;

    {***************************************************************************
    * TEventHandlers
    ***************************************************************************}
    TEventHandlers = class( TObjectList )
protected
    function   getHandlerIndex( aCallback : HTMLElementProcEventHandler; aTag : Pointer; aSubscription : UINT ) : integer; overload;
    function   getHandler( aCallback : HTMLElementProcEventHandler; aTag : Pointer; aSubscription : UINT ) : TProcHandlerParams; overload;
    procedure  removeHandler( aCallback : HTMLElementProcEventHandler; aTag : Pointer; aSubscription : UINT ); overload;

    function   getHandlerIndex( aCallback : TMethod; aTag : Pointer; aSubscription : UINT ) : integer; overload;
    function   getHandler( aCallback : TMethod; aTag : Pointer; aSubscription : UINT ) : TMethodHandlerParams; overload;
    procedure  removeHandler( aCallback : TMethod; aTag : Pointer; aSubscription : UINT ); overload;

    function   getHandlerIndex( aCmd : UINT; aCallback : TMethod; aTag : Pointer; aSubscription : UINT ) : integer; overload;
    function   getHandler( aCmd : UINT; aCallback : TMethod; aTag : Pointer; aSubscription : UINT ) : THtmlCmdEventParams; overload;
    procedure  removeHandler( aCmd : UINT; aCallback : TMethod; aTag : Pointer; aSubscription : UINT ); overload;

    end;

    {***************************************************************************
    * THtmlElement
    ***************************************************************************}
    THtmlElement = class( THtmlHElement )
private // events
    FeventHandlers              : TEventHandlers;

protected
    FelementClass               : CHtmlElement;

private
    function    getRoot() : THtmlElement;
    function    getParent() : THtmlElement;
    function    getChild( const aIndex : integer ) : THtmlElement;
    function    getEventHandlers() : TEventHandlers;

private // events seters and handlers
    procedure   attachInitialization( const aCmd : integer; const aEventHandler : HTMLElementInitializationEventHandler );
    procedure   attachMouse( const aCmd : integer; const aEventHandler : HTMLElementMouseEventHandler );
    procedure   attachKey( const aCmd : integer; const aEventHandler : HTMLElementKeyEventHandler );
    procedure   attachFocus( const aCmd : integer; const aEventHandler : HTMLElementFocusEventHandler );
    procedure   attachScroll( const aCmd : integer; const aEventHandler : HTMLElementScrollEventHandler );
    procedure   attachTimer( const aEventHandler : HTMLElementTimerEventHandler );
    procedure   attachSize( const aEventHandler : HTMLElementSizeEventHandler );
    procedure   attachDraw( const aCmd : integer; const aEventHandler : HTMLElementDrawEventHandler );
    procedure   attachDataArrived( const aEventHandler : HTMLElementDataArrivedEventHandler );
    procedure   attachExchange( const aCmd : integer; const aEventHandler : HTMLElementExchangeEventHandler );
    procedure   attachGesture( const aCmd : integer; const aEventHandler : HTMLElementGestureEventHandler );

private // property
    property    eventHandlers : TEventHandlers read getEventHandlers;

public
    constructor Create(); override;
    destructor  Destroy(); override;

    function    clone() : THtmlElement;
    function    get_element_by_id( const aId : string ) : THtmlElement;
    function    update( const render_now : boolean = false ) : THtmlElement;  overload;
    function    update( const aMode : integer ) : THtmlElement; overload;
    function    redraw() : THtmlElement;
    function    next_sibling() : THtmlElement;
    function    prev_sibling() : THtmlElement;
    function    first_sibling() : THtmlElement;
    function    last_sibling() : THtmlElement;
    function    scroll_to_view( toTopOfView : boolean = false; smooth : boolean = false ) : THtmlElement;
    function    set_state( const bitsToSet : cardinal; const bitsToClear : cardinal = 0; update : boolean = true ) : THtmlElement;
    function    insert( const element : THtmlHElement; const index : cardinal ) : THtmlElement;
    function    append( const element : THtmlHElement ) : THtmlElement;
    function    detach() : THtmlElement; overload;

    procedure   attach( aEventParams : TEventHandlerParams; aEventHandler : HTMLayoutHElementEvent ); overload;
    procedure   detach( aEventParams : TEventHandlerParams; aEventHandler : HTMLayoutHElementEvent ); overload;

    procedure   attach( aEventParams : TEventHandlerParams ); overload;
    procedure   detach( aEventParams : TEventHandlerParams ); overload;

    function    attach( aEventHandler : HTMLElementProcEventHandler; aTag : Pointer = nil; aSubscription : UINT = HANDLE_ALL or DISABLE_INITIALIZATION ) : TProcHandlerParams; overload;
    procedure   detach( aEventHandler : HTMLElementProcEventHandler; aTag : Pointer = nil; aSubscription : UINT = HANDLE_ALL or DISABLE_INITIALIZATION ); overload;

    function    attach( aEventHandler : HTMLElementMethodEventHandler; aTag : Pointer = nil; aSubscription : UINT = HANDLE_ALL or DISABLE_INITIALIZATION ) : TMethodHandlerParams; overload;
    procedure   detach( aEventHandler : HTMLElementMethodEventHandler; aTag : Pointer = nil; aSubscription : UINT = HANDLE_ALL or DISABLE_INITIALIZATION ); overload;

public // Event Handlers
    procedure   attach( aEventParams : THtmlCmdEventParams ); overload;
    procedure   detach( const aEventHandler : TMethod; const aCmd : integer = ALL_CMD; aTag : Pointer = nil; aSubscription : UINT = HANDLE_ALL or DISABLE_INITIALIZATION ); overload;
    // INITIALIZATION
    function    attach( const aEventHandler : HTMLElementInitializationEventHandler; const aCmd : integer = INITIALIZATION_ALL; aTag : Pointer = nil ) : THtmlCmdEventParams; overload;
    procedure   detach( const aEventHandler : HTMLElementInitializationEventHandler; const aCmd : integer = INITIALIZATION_ALL; aTag : Pointer = nil ); overload;
    // MOUSE
    function    attach( const aEventHandler : HTMLElementMouseEventHandler; const aCmd : integer = MOUSE_ALL; aTag : Pointer = nil; aSubscription : UINT = HANDLE_MOUSE or DISABLE_INITIALIZATION ) : THtmlCmdEventParams; overload;
    procedure   detach( const aEventHandler : HTMLElementMouseEventHandler; const aCmd : integer = MOUSE_ALL; aTag : Pointer = nil; aSubscription : UINT = HANDLE_MOUSE or DISABLE_INITIALIZATION ); overload;
    // KEY
    function    attach( const aEventHandler : HTMLElementKeyEventHandler; const aCmd : integer = KEY_ALL; aTag : Pointer = nil; aSubscription : UINT = HANDLE_KEY or DISABLE_INITIALIZATION ) : THtmlCmdEventParams; overload;
    procedure   detach( const aEventHandler : HTMLElementKeyEventHandler; const aCmd : integer = KEY_ALL; aTag : Pointer = nil; aSubscription : UINT = HANDLE_KEY or DISABLE_INITIALIZATION ); overload;
    // FOCUS
    function    attach( const aEventHandler : HTMLElementFocusEventHandler; const aCmd : integer = FOCUS_ALL; aTag : Pointer = nil; aSubscription : UINT = HANDLE_KEY or DISABLE_INITIALIZATION ) : THtmlCmdEventParams; overload;
    procedure   detach( const aEventHandler : HTMLElementFocusEventHandler; const aCmd : integer = FOCUS_ALL; aTag : Pointer = nil; aSubscription : UINT = HANDLE_KEY or DISABLE_INITIALIZATION ); overload;
    // SCROLL
    function    attach( const aEventHandler : HTMLElementScrollEventHandler; const aCmd : integer = SCROLL_ALL; aTag : Pointer = nil; aSubscription : UINT = HANDLE_SCROLL or DISABLE_INITIALIZATION ) : THtmlCmdEventParams; overload;
    procedure   detach( const aEventHandler : HTMLElementScrollEventHandler; const aCmd : integer = SCROLL_ALL; aTag : Pointer = nil; aSubscription : UINT = HANDLE_SCROLL or DISABLE_INITIALIZATION ); overload;
    // TIMER
    function    attach( const aEventHandler : HTMLElementTimerEventHandler; aTag : Pointer = nil; aSubscription : UINT = HANDLE_TIMER or DISABLE_INITIALIZATION ) : THtmlCmdEventParams; overload;
    procedure   detach( const aEventHandler : HTMLElementTimerEventHandler; aTag : Pointer = nil; aSubscription : UINT = HANDLE_TIMER or DISABLE_INITIALIZATION ); overload;
    // SIZE
    function    attach( const aEventHandler : HTMLElementSizeEventHandler; aTag : Pointer = nil; aSubscription : UINT = HANDLE_SIZE or DISABLE_INITIALIZATION ) : THtmlCmdEventParams; overload;
    procedure   detach( const aEventHandler : HTMLElementSizeEventHandler; aTag : Pointer = nil; aSubscription : UINT = HANDLE_SIZE or DISABLE_INITIALIZATION ); overload;
    // DRAW
    function    attach( const aEventHandler : HTMLElementDrawEventHandler; const aCmd : integer = DRAW_ALL; aTag : Pointer = nil; aSubscription : UINT = HANDLE_DRAW or DISABLE_INITIALIZATION ) : THtmlCmdEventParams; overload;
    procedure   detach( const aEventHandler : HTMLElementDrawEventHandler; const aCmd : integer = DRAW_ALL; aTag : Pointer = nil; aSubscription : UINT = HANDLE_DRAW or DISABLE_INITIALIZATION ); overload;
    // DATA_ARRIVED
    function    attach( const aEventHandler : HTMLElementDataArrivedEventHandler; aTag : Pointer = nil; aSubscription : UINT = HANDLE_DATA_ARRIVED or DISABLE_INITIALIZATION ) : THtmlCmdEventParams; overload;
    procedure   detach( const aEventHandler : HTMLElementDataArrivedEventHandler; aTag : Pointer = nil; aSubscription : UINT = HANDLE_DATA_ARRIVED or DISABLE_INITIALIZATION ); overload;
    // EXCHANGE
    function    attach( const aEventHandler : HTMLElementExchangeEventHandler; const aCmd : integer = EXC_ALL; aTag : Pointer = nil; aSubscription : UINT = HANDLE_EXCHANGE or DISABLE_INITIALIZATION ) : THtmlCmdEventParams; overload;
    procedure   detach( const aEventHandler : HTMLElementExchangeEventHandler; const aCmd : integer = EXC_ALL; aTag : Pointer = nil; aSubscription : UINT = HANDLE_EXCHANGE or DISABLE_INITIALIZATION ); overload;
    // GESTURE
    function    attach( const aEventHandler : HTMLElementGestureEventHandler; const aCmd : integer = GESTURE_ALL; aTag : Pointer = nil; aSubscription : UINT = HANDLE_GESTURE or DISABLE_INITIALIZATION ) : THtmlCmdEventParams; overload;
    procedure   detach( const aEventHandler : HTMLElementGestureEventHandler; const aCmd : integer = GESTURE_ALL; aTag : Pointer = nil; aSubscription : UINT = HANDLE_GESTURE or DISABLE_INITIALIZATION ); overload;

public // property
    property root : THtmlElement read getRoot;
    property parent : THtmlElement read getParent;
    property child[ const aIndex : integer ] : THtmlElement read getChild;
    property nextSibling : THtmlElement read next_sibling;
    property prevSibling : THtmlElement read prev_sibling;
    property firstSibling : THtmlElement read first_sibling;
    property lastSibling : THtmlElement read last_sibling;


public // events
    // INITIALIZATION
    property onInitialization : HTMLElementInitializationEventHandler index INITIALIZATION_ALL write attachInitialization; // All INITIALIZATION events
    property onBehaviorDetach : HTMLElementInitializationEventHandler index BEHAVIOR_DETACH write attachInitialization;
    property onBehaviorAttach : HTMLElementInitializationEventHandler index BEHAVIOR_ATTACH write attachInitialization;

    // MOUSE
    property onMouse : HTMLElementMouseEventHandler index MOUSE_ALL write attachMouse; // All MOUSE events
    property onMouseEnter : HTMLElementMouseEventHandler index MOUSE_ENTER write attachMouse;
    property onMouseLeave : HTMLElementMouseEventHandler index MOUSE_LEAVE write attachMouse;
    property onMouseMove : HTMLElementMouseEventHandler index MOUSE_MOVE write attachMouse;
    property onMouseUp : HTMLElementMouseEventHandler index MOUSE_UP write attachMouse;
    property onMouseDown : HTMLElementMouseEventHandler index MOUSE_DOWN write attachMouse;
    property onMouseClick : HTMLElementMouseEventHandler index MOUSE_CLICK write attachMouse;
    property onMouseDClick : HTMLElementMouseEventHandler index MOUSE_DCLICK write attachMouse;
    property onMouseWheel : HTMLElementMouseEventHandler index MOUSE_WHEEL write attachMouse;
    property onMouseTick : HTMLElementMouseEventHandler index MOUSE_TICK write attachMouse;
    property onMouseIdle : HTMLElementMouseEventHandler index MOUSE_IDLE write attachMouse;
    property onDrop : HTMLElementMouseEventHandler index DROP write attachMouse;
    property onDragEnter : HTMLElementMouseEventHandler index DRAG_ENTER write attachMouse;
    property onDragLeave : HTMLElementMouseEventHandler index DRAG_LEAVE write attachMouse;
    property onDragRequest : HTMLElementMouseEventHandler index DRAG_REQUEST write attachMouse;
    property onMouseDraggingEnter : HTMLElementMouseEventHandler index MOUSE_ENTER or DRAGGING write attachMouse;
    property onMouseDraggingLeave : HTMLElementMouseEventHandler index MOUSE_LEAVE or DRAGGING write attachMouse;
    property onMouseDraggingMove : HTMLElementMouseEventHandler index MOUSE_MOVE or DRAGGING write attachMouse;
    property onMouseDraggingUp : HTMLElementMouseEventHandler index MOUSE_UP or DRAGGING write attachMouse;
    property onMouseDraggingDown : HTMLElementMouseEventHandler index MOUSE_DOWN or DRAGGING write attachMouse;

    // KEY
    property onKey : HTMLElementKeyEventHandler index KEY_ALL write attachKey; // All KEY events
    property onKeyDown : HTMLElementKeyEventHandler index KEY_DOWN write attachKey;
    property onKeyUp : HTMLElementKeyEventHandler index KEY_UP write attachKey;
    property onKeyChar : HTMLElementKeyEventHandler index KEY_CHAR write attachKey;

    // FOCUS
    property onFocus : HTMLElementFocusEventHandler index FOCUS_ALL write attachFocus; // All KEY events
    property onFocusLost : HTMLElementFocusEventHandler index FOCUS_LOST write attachFocus;
    property onFocusGot : HTMLElementFocusEventHandler index FOCUS_GOT write attachFocus;

    // SCROLL
    property onScroll : HTMLElementScrollEventHandler index SCROLL_ALL write attachScroll; // All SCROLL events
    property onScrollHome : HTMLElementScrollEventHandler index SCROLL_HOME write attachScroll;
    property onScrollEnd : HTMLElementScrollEventHandler index SCROLL_END write attachScroll;
    property onScrollStepPlus : HTMLElementScrollEventHandler index SCROLL_STEP_PLUS write attachScroll;
    property onScrollStepMinus : HTMLElementScrollEventHandler index SCROLL_STEP_MINUS write attachScroll;
    property onScrollPagePlus : HTMLElementScrollEventHandler index SCROLL_PAGE_PLUS write attachScroll;
    property onScrollPageMinus : HTMLElementScrollEventHandler index SCROLL_PAGE_MINUS write attachScroll;
    property onScrollPos : HTMLElementScrollEventHandler index SCROLL_POS write attachScroll;
    property onScrollSliderReleased : HTMLElementScrollEventHandler index SCROLL_SLIDER_RELEASED write attachScroll;

    // TIMER
    property onTimer : HTMLElementTimerEventHandler write attachTimer;

    // SIZE
    property onSize : HTMLElementSizeEventHandler write attachSize;

    // DRAW
    property onDraw : HTMLElementDrawEventHandler index DRAW_ALL write attachDraw; // All DRAW events
    property onDrawBackground : HTMLElementDrawEventHandler index DRAW_BACKGROUND write attachDraw;
    property onDrawContent : HTMLElementDrawEventHandler index DRAW_CONTENT write attachDraw;
    property onDrawForeground : HTMLElementDrawEventHandler index DRAW_FOREGROUND write attachDraw;

    // HANDLE_DATA_ARRIVED
    property onDataArrived : HTMLElementDataArrivedEventHandler write attachDataArrived;

    // EXCHANGE
    property onExchange : HTMLElementExchangeEventHandler index EXC_ALL write attachExchange; // All EXCHANGE events
    property onExchangeNone : HTMLElementExchangeEventHandler index EXC_NONE write attachExchange;
    property onExchangeCopy : HTMLElementExchangeEventHandler index EXC_COPY write attachExchange;
    property onExchangeMove : HTMLElementExchangeEventHandler index EXC_MOVE write attachExchange;
    property onExchangeLink : HTMLElementExchangeEventHandler index EXC_LINK write attachExchange;

    // GESTURE
    property onGesture : HTMLElementGestureEventHandler index GESTURE_ALL write attachGesture; // All GESTURE events
    property onGestureResuest : HTMLElementGestureEventHandler index GESTURE_REQUEST write attachGesture;
    property onGestureZoom : HTMLElementGestureEventHandler index GESTURE_ZOOM write attachGesture;
    property onGesturePan : HTMLElementGestureEventHandler index GESTURE_PAN write attachGesture;
    property onGestureRotate : HTMLElementGestureEventHandler index GESTURE_ROTATE write attachGesture;
    property onGestureTap1 : HTMLElementGestureEventHandler index GESTURE_TAP1 write attachGesture;
    property onGestureTap2 : HTMLElementGestureEventHandler index GESTURE_TAP2 write attachGesture;

    end;

    {***************************************************************************
    * THtmlShim
    ***************************************************************************}
    THtmlShim = class( THtmlHElement )
private
    function    getRoot() : THtmlShim;
    function    getParent() : THtmlShim;
    function    getChild( const aIndex : integer ) : THtmlShim;
    function    getNextSibling() : THtmlShim;
    function    getPrevSibling() : THtmlShim;
    function    getFirstSibling() : THtmlShim;
    function    getLastSibling() : THtmlShim;


protected
    //function    createElement( const aHandler : HELEMENT ) : THtmlElement; override;

public
    function    clone() : THtmlShim;
    function    get_element_by_id( const aId : string ) : THtmlShim;
    function    update( const render_now : boolean = false ) : THtmlShim;  overload;
    function    update( const aMode : integer ) : THtmlShim; overload;
    function    redraw() : THtmlShim;
    function    next_sibling() : THtmlShim;
    function    prev_sibling() : THtmlShim;
    function    first_sibling() : THtmlShim;
    function    last_sibling() : THtmlShim;
    function    scroll_to_view( toTopOfView : boolean = false; smooth : boolean = false ) : THtmlShim;
    function    set_state( const bitsToSet : cardinal; const bitsToClear : cardinal = 0; update : boolean = true ) : THtmlShim;
    function    insert( const element : THtmlHElement; const index : cardinal ) : THtmlShim;
    function    append( const element : THtmlHElement ) : THtmlShim;
    function    detach() : THtmlShim; overload;

class function  get( const aHandler : HELEMENT ) : THtmlShim; overload;
class function  get( aElement : THtmlElement ) : THtmlShim; overload;

public // property
    property root : THtmlShim read getRoot;
    property child[ const aIndex : integer ] : THtmlShim read getChild;
    property parent : THtmlShim read getParent;
    property nextSibling : THtmlShim read getNextSibling;
    property prevSibling : THtmlShim read getPrevSibling;
    property firstSibling : THtmlShim read getFirstSibling;
    property lastSibling : THtmlShim read getLastSibling;

    end;

implementation

uses HtmlEvents;

var
    GlobalShim : THtmlShim;

{------------------------------ TEventHandlerParams ---------------------------}

{*******************************************************************************
* Create
*******************************************************************************}
constructor TEventHandlerParams.Create( aElement : THtmlElement );
begin
    Felement      := aElement;
    Ftag          := nil;
    Fsubscription := HANDLE_ALL or DISABLE_INITIALIZATION;
end;

{*******************************************************************************
* Create
*******************************************************************************}
constructor TEventHandlerParams.Create( aElement : THtmlElement; aTag : Pointer );
begin
    Create( aElement );
    Ftag := aTag;
end;

{*******************************************************************************
* Create
*******************************************************************************}
constructor TEventHandlerParams.Create( aElement : THtmlElement; aTag : Pointer; aSubscription : UINT );
begin
    Create( aElement, aTag );
    Fsubscription := aSubscription;
end;

{*******************************************************************************
* compare
*******************************************************************************}
function TEventHandlerParams.compare( aTag : Pointer; aSubscription : UINT ) : boolean;
begin
    Result := ( Fsubscription = aSubscription ) and ( Ftag = aTag );
end;

{------------------------------ TProcHandlerParams ----------------------------}

{*******************************************************************************
* Create
*******************************************************************************}
constructor TProcHandlerParams.Create( aElement : THtmlElement; aCallback : HTMLElementProcEventHandler; aTag : Pointer = nil; aSubscription : UINT = HANDLE_ALL or DISABLE_INITIALIZATION );
begin
    inherited Create( aElement, aTag, aSubscription );
    Fcallback := aCallback;
end;

{*******************************************************************************
* compare
*******************************************************************************}
function TProcHandlerParams.compare( aCallback : HTMLElementProcEventHandler; aTag : Pointer; aSubscription : UINT ) : boolean;
begin
    Result := inherited compare( aTag, aSubscription )
        and ( Addr( Fcallback ) = Addr( aCallback ) );
end;

{*******************************************************************************
* TProcHandlerParams
*******************************************************************************}
function TProcHandlerParams.call( aEventGroup : UINT; aEventParams : Pointer ) : boolean;
begin
    Result := Fcallback( Felement, aEventGroup, aEventParams, Ftag );
end;

{---------------------------- TMethodHandlerParams ----------------------------}

{*******************************************************************************
* Create
*******************************************************************************}
constructor TMethodHandlerParams.Create( aElement : THtmlElement; aCallback : TMethod; aTag : Pointer = nil; aSubscription : UINT = HANDLE_ALL or DISABLE_INITIALIZATION );
begin
    inherited Create( aElement, aTag, aSubscription );
    Fcallback := aCallback;
end;

{*******************************************************************************
* compare
*******************************************************************************}
function TMethodHandlerParams.compare( aCallback : TMethod; aTag : Pointer; aSubscription : UINT ) : boolean;
begin
    Result := inherited compare( aTag, aSubscription )
        and ( TMethod( Fcallback ).Code = TMethod( aCallback ).Code )
        and ( TMethod( Fcallback ).Data = TMethod( aCallback ).Data );
end;

{*******************************************************************************
* call
*******************************************************************************}
function TMethodHandlerParams.call( aEventGroup : UINT; aEventParams : Pointer ) : boolean;
begin
    Result := HTMLElementMethodEventHandler( Fcallback )( Felement, aEventGroup, aEventParams, Ftag );
end;

{------------------------------- THtmlCmdEventParams -----------------------------}

{*******************************************************************************
* Create
*******************************************************************************}
constructor THtmlCmdEventParams.Create( aElement : THtmlElement; aCallback : TMethod; aTag : Pointer; aSubscription : UINT = HANDLE_ALL or DISABLE_INITIALIZATION );
begin
    inherited Create( aElement, aCallback, aTag, aSubscription );
    Fcmd := ALL_CMD;
end;

{*******************************************************************************
* Create
*******************************************************************************}
constructor THtmlCmdEventParams.Create( aElement : THtmlElement; aCmd : UINT; aCallback : TMethod;  aTag : Pointer = nil; aSubscription : UINT = HANDLE_ALL or DISABLE_INITIALIZATION );
begin
    Create( aElement, aCallback, aTag, aSubscription );
    Fcmd := aCmd;
end;

{*******************************************************************************
* compare
*******************************************************************************}
function THtmlCmdEventParams.compare( aCmd : UINT; aCallback : TMethod; aTag : Pointer; aSubscription : UINT ) : boolean;
begin
    Result := inherited compare( aCallback, aTag, aSubscription ) and ( Fcmd = aCmd );
end;

{------------------------------ TEventHandlers --------------------------------}

{*******************************************************************************
* getHandlerIndex
*******************************************************************************}
function TEventHandlers.getHandlerIndex( aCallback : HTMLElementProcEventHandler; aTag : Pointer; aSubscription : UINT ) : integer;
var
    i : integer;
begin
    Result := -1;
    for i := 0 to Count - 1 do
    begin
        if ( not TProcHandlerParams( Items[i] ).compare( aCallback, aTag, aSubscription ) ) then
            continue;

        Result := i;
        exit;
    end;
end;

{*******************************************************************************
* getHandler
*******************************************************************************}
function TEventHandlers.getHandler( aCallback : HTMLElementProcEventHandler; aTag : Pointer; aSubscription : UINT ) : TProcHandlerParams;
var
    i : integer;
begin
    Result := nil;
    i := getHandlerIndex( aCallback, aTag, aSubscription );
    if ( i < 0 ) then
        exit;

    Result := TProcHandlerParams( Items[i] );
end;

{*******************************************************************************
* removeHandler
*******************************************************************************}
procedure TEventHandlers.removeHandler( aCallback : HTMLElementProcEventHandler; aTag : Pointer; aSubscription : UINT );
var
    i : integer;
begin
    i := getHandlerIndex( aCallback, aTag, aSubscription );
    if ( i < 0 ) then
        exit;

    Remove( Items[i] );
end;

{*******************************************************************************
* getHandlerIndex
*******************************************************************************}
function TEventHandlers.getHandlerIndex( aCallback : TMethod; aTag : Pointer; aSubscription : UINT ) : integer;
var
    i : integer;
begin
    Result := -1;
    for i := 0 to Count - 1 do
    begin
        if ( not TMethodHandlerParams( Items[i] ).compare( aCallback, aTag, aSubscription ) ) then
            continue;

        Result := i;
        exit;
    end;
end;

{*******************************************************************************
* getHandler
*******************************************************************************}
function TEventHandlers.getHandler( aCallback : TMethod; aTag : Pointer; aSubscription : UINT ) : TMethodHandlerParams;
var
    i : integer;
begin
    Result := nil;
    i := getHandlerIndex( aCallback, aTag, aSubscription );
    if ( i < 0 ) then
        exit;

    Result := TMethodHandlerParams( Items[i] );
end;

{*******************************************************************************
* removeHandler
*******************************************************************************}
procedure TEventHandlers.removeHandler( aCallback : TMethod; aTag : Pointer; aSubscription : UINT );
var
    i : integer;
begin
    i := getHandlerIndex( aCallback, aTag, aSubscription );
    if ( i < 0 ) then
        exit;

    Remove( Items[i] );
end;

{*******************************************************************************
* getHandlerIndex
*******************************************************************************}
function TEventHandlers.getHandlerIndex( aCmd : UINT; aCallback : TMethod; aTag : Pointer; aSubscription : UINT ) : integer;
var
    i : integer;
begin
    Result := -1;
    for i := 0 to Count - 1 do
    begin
        if ( not THtmlCmdEventParams( Items[i] ).compare( aCmd, aCallback, aTag, aSubscription ) ) then
            continue;

        Result := i;
        exit;
    end;
end;

{*******************************************************************************
* getHandler
*******************************************************************************}
function TEventHandlers.getHandler( aCmd : UINT; aCallback : TMethod; aTag : Pointer; aSubscription : UINT ) : THtmlCmdEventParams;
var
    i : integer;
begin
    Result := nil;
    i := getHandlerIndex( aCmd, aCallback, aTag, aSubscription );
    if ( i < 0 ) then
        exit;

    Result := THtmlCmdEventParams( Items[i] );
end;

{*******************************************************************************
* removeHandler
*******************************************************************************}
procedure TEventHandlers.removeHandler( aCmd : UINT; aCallback : TMethod; aTag : Pointer; aSubscription : UINT );
var
    i : integer;
begin
    i := getHandlerIndex( aCmd, aCallback, aTag, aSubscription );
    if ( i < 0 ) then
        exit;

    Remove( Items[i] );
end;

{-------------------------------- THtmlHElement -------------------------------}

{*******************************************************************************
* Create
*******************************************************************************}
constructor THtmlHElement.Create();
begin
    Fhandler := nil;
end;

{*******************************************************************************
* Create
*******************************************************************************}
constructor THtmlHElement.Create( const aHandler : HELEMENT );
begin
    Create();
    Fhandler := aHandler;
end;

{*******************************************************************************
* Create
*******************************************************************************}
constructor THtmlHElement.Create( const aTag : string; const aText : widestring = '' );
begin
    Create();
    FlastError := HTMLayoutCreateElement( LPCSTR( aTag ), LPCWSTR( aText ), Fhandler );
    assert( FlastError = HLDOM_OK );
end;

{*******************************************************************************
* Destroy
*******************************************************************************}
destructor THtmlHElement.Destroy();
begin
    inherited;
end;

{*******************************************************************************
* clone
*******************************************************************************}
function THtmlHElement.clone() : HELEMENT;
begin
    Result := cloneHandler();
end;

{*******************************************************************************
* get_element_by_id
*******************************************************************************}
function THtmlHElement.get_element_by_id( const aId : string ) : HELEMENT;
begin
    Result := getHandlerById( aId );
end;

{*******************************************************************************
* next_sibling
*******************************************************************************}
function THtmlHElement.next_sibling() : HELEMENT;
begin
    Result := getNextSiblingHandler();
end;

{*******************************************************************************
* prev_sibling
*******************************************************************************}
function THtmlHElement.prev_sibling() : HELEMENT;
begin
    Result := getPrevSiblingHandler();
end;

{*******************************************************************************
* first_sibling
*******************************************************************************}
function THtmlHElement.first_sibling() : HELEMENT;
begin
    Result := getFirstSiblingHandler();
end;

{*******************************************************************************
* last_sibling
*******************************************************************************}
function THtmlHElement.last_sibling() : HELEMENT;
begin
    Result := getLastSiblingHandler();
end;

{*******************************************************************************
* delete
*******************************************************************************}
procedure THtmlHElement.delete();
begin
    assert( is_valid() );
    FlastError := HTMLayoutDeleteElement( Fhandler );
    assert( FlastError = HLDOM_OK );
end;

{*******************************************************************************
* getElementUid
*******************************************************************************}
function THtmlHElement.getElementUid( const aHandler : HELEMENT ) : UINT;
begin
    FlastError := HTMLayoutGetElementUID( aHandler, Result );
end;

{*******************************************************************************
* get_element_uid
*******************************************************************************}
function THtmlHElement.get_element_uid() : UINT;
begin
    Result := getElementUid( Fhandler );
    assert( FlastError = HLDOM_OK );
end;

{*******************************************************************************
* is_valid
*******************************************************************************}
function THtmlHElement.is_valid() : boolean;
begin
    getElementUid( Fhandler );
    Result := ( FlastError = HLDOM_OK );
end;

{*******************************************************************************
* is_valid
*******************************************************************************}
function THtmlHElement.is_valid( const aHandler : HELEMENT ) : boolean;
begin
    getElementUid( aHandler );
    Result := ( FlastError = HLDOM_OK );
end;

{*******************************************************************************
* getChildrenCount
*******************************************************************************}
function THtmlHElement.getChildrenCount( const aHandler : HELEMENT ) : cardinal;
begin
    assert( is_valid( aHandler ) );
    FlastError := HTMLayoutGetChildrenCount( aHandler, Result );
    assert( FlastError = HLDOM_OK );
end;

{*******************************************************************************
* children_count
*******************************************************************************}
function THtmlHElement.children_count() : cardinal;
begin
    Result := getChildrenCount( Fhandler );
end;

{*******************************************************************************
* getOuterHtml
*******************************************************************************}
function THtmlHElement.getOuterHtml() : string;
var
    bytes : PCHAR;
begin
    assert( is_valid() );
    FlastError := HTMLayoutGetElementHtml( Fhandler, bytes, true );
    assert( FlastError = HLDOM_OK );

    Result := cleanHtml( bytes );
end;

{*******************************************************************************
* setOuterHtml
*******************************************************************************}
procedure THtmlHElement.setOuterHtml( const aHtml : string );
begin
    set_html( aHtml, SOH_REPLACE );
end;

{*******************************************************************************
* getInnerHtml
*******************************************************************************}
function THtmlHElement.getInnerHtml() : string;
var
    bytes : PCHAR;
begin
    assert( is_valid() );
    FlastError := HTMLayoutGetElementHtml( Fhandler, bytes, false );
    assert( FlastError = HLDOM_OK );

    Result := cleanHtml( bytes );
end;

{*******************************************************************************
* setInnerHtml
*******************************************************************************}
procedure THtmlHElement.setInnerHtml( const aHtml : string );
begin
    set_html( aHtml, SIH_REPLACE_CONTENT );
end;

{*******************************************************************************
* cleanHtml
*******************************************************************************}
class function THtmlHElement.cleanHtml( const aHtml : string ) : string;
var
    i, j : integer;
    ch   : integer;

begin
    Result := aHtml;

    j := 1;
    for i := 1 to Length( aHtml ) do
    begin
        ch := Ord( aHtml[i] );
        if ( ch = $D ) or ( ch = $A ) or ( ch = $9 ) then
            continue;

        Result[j] := aHtml[i];
        inc(j);
    end;

    SetLength( Result, j - 1 );
end;

{*******************************************************************************
* getChildHandler
*******************************************************************************}
function THtmlHElement.getChildHandler( const aHandler : HELEMENT; const aIndex : integer ) : HELEMENT;
begin
    assert( is_valid() );
    FlastError := HTMLayoutGetNthChild( aHandler, aIndex, Result );
    assert( FlastError = HLDOM_OK );
end;

{*******************************************************************************
* getParentHandler
*******************************************************************************}
function THtmlHElement.getParentHandler() : HELEMENT;
begin
    assert( is_valid() );
    FlastError := HTMLayoutGetParentElement( Fhandler, Result );
    assert( FlastError = HLDOM_OK );
end;

{*******************************************************************************
* getAttributeByName
*******************************************************************************}
function THtmlHElement.getAttributeByName( const aAttrName : string ) : widestring;
begin
    Result := get_attribute( aAttrName );
end;

{*******************************************************************************
* getAttributeByIndex
*******************************************************************************}
function THtmlHElement.getAttributeByIndex( const aAttrIndex : cardinal ) : widestring;
begin
    Result := get_attribute( aAttrIndex );
end;

{*******************************************************************************
* setAttributeByIndex
*******************************************************************************}
procedure THtmlHElement.setAttributeByIndex( const aAttrIndex : cardinal; const aValue : widestring );
var
    name : string;
begin
    name := attributeName[ aAttrIndex ];
    attribute[ name ] := aValue;
end;

{*******************************************************************************
* getIndex
*******************************************************************************}
function THtmlHElement.getIndex() : cardinal;
begin
    assert( is_valid() );
    FlastError := HTMLayoutGetElementIndex( Fhandler, Result );
    assert( FlastError = HLDOM_OK );
end;

{*******************************************************************************
* get_attribute_count
*******************************************************************************}
function THtmlHElement.get_attribute_count() : cardinal;
begin
    assert( is_valid() );
    FlastError := HTMLayoutGetAttributeCount( Fhandler, Result );
    assert( FlastError = HLDOM_OK );
end;

{*******************************************************************************
* get_attribute
*******************************************************************************}
function THtmlHElement.get_attribute( const aAttrIndex : cardinal ) : widestring;
var
    pName  : LPCSTR;
    pValue : LPCWSTR;

begin
    Result := '';
    assert( is_valid() );
    FlastError := HTMLayoutGetNthAttribute( Fhandler, aAttrIndex, pName, pValue );
    assert( FlastError = HLDOM_OK );
    if ( FlastError <> HLDOM_OK ) then
        exit;

    Result := pValue;
end;

{*******************************************************************************
* get_attribute
*******************************************************************************}
function THtmlHElement.get_attribute( const aAttrName : string ) : widestring;
var
    pValue : LPCWSTR;

begin
    Result := '';
    assert( is_valid() );
    FlastError := HTMLayoutGetAttributeByName( Fhandler, LPCSTR( aAttrName ), pValue );
    assert( FlastError = HLDOM_OK );
    if ( FlastError <> HLDOM_OK ) then
        exit;

    Result := pValue;
end;

{*******************************************************************************
* get_attribute_name
*******************************************************************************}
function THtmlHElement.get_attribute_name( const aAttrIndex : cardinal ) : widestring;
var
    pName  : LPCSTR;
    pValue : LPCWSTR;

begin
    Result := '';
    assert( is_valid() );
    FlastError := HTMLayoutGetNthAttribute( Fhandler, aAttrIndex, pName, pValue );
    assert( FlastError = HLDOM_OK );
    if ( FlastError <> HLDOM_OK ) then
        exit;

    Result := pName;
end;

{*******************************************************************************
* set_attribute
*******************************************************************************}
procedure THtmlHElement.set_attribute( const aAttrName : string; const aValue : widestring );
begin
    assert( is_valid() );
    FlastError := HTMLayoutSetAttributeByName( Fhandler, LPCSTR( aAttrName ), LPCWSTR( aValue ) );
    assert( FlastError = HLDOM_OK );
end;

{*******************************************************************************
* getId
*******************************************************************************}
function THtmlHElement.getId() : widestring;
begin
    Result := attribute[ 'id' ];
end;

{*******************************************************************************
* setId
*******************************************************************************}
procedure THtmlHElement.setId( const aId : widestring );
begin
    attribute[ 'id' ] := aId;
end;

{*******************************************************************************
* StyleStrToInt
*******************************************************************************}
function StyleStrToInt( const aValue : string ) : integer;
var
    i  : integer;
    ch : integer;
    s  : string;

begin
    s := aValue;

    for i := 1 to Length( aValue ) do
    begin
        ch := Ord( aValue[i] );
        if ( not( ch in [ 48..57 ] ) ) then
        begin
            SetLength( s, i - 1 );
            break;
        end;
    end;

    Result := StrToIntDef( s, 0 );
end;

{*******************************************************************************
* getWidth
*******************************************************************************}
function THtmlHElement.getWidth() : integer;
begin
    Result := StyleStrToInt( style[ 'width' ] );
end;

{*******************************************************************************
* setWidth
*******************************************************************************}
procedure THtmlHElement.setWidth( const aPxValue : integer );
begin
     style[ 'width' ] := IntToStr( aPxValue );
end;

{*******************************************************************************
* getHeight
*******************************************************************************}
function THtmlHElement.getHeight() : integer;
begin
    Result := StyleStrToInt( style[ 'height' ] );
end;

{*******************************************************************************
* setHeight
*******************************************************************************}
procedure THtmlHElement.setHeight( const aPxValue : integer );
begin
     style[ 'height' ] := IntToStr( aPxValue );
end;

{*******************************************************************************
* getTop
*******************************************************************************}
function THtmlHElement.getTop() : integer;
begin
    Result := StyleStrToInt( style[ 'top' ] );
end;

{*******************************************************************************
* setTop
*******************************************************************************}
procedure THtmlHElement.setTop( const aPxValue : integer );
begin
     style[ 'top' ] := IntToStr( aPxValue );
end;

{*******************************************************************************
* getLeft
*******************************************************************************}
function THtmlHElement.getLeft() : integer;
begin
    Result := StyleStrToInt( style[ 'left' ] );
end;

{*******************************************************************************
* setLeft
*******************************************************************************}
procedure THtmlHElement.setLeft( const aPxValue : integer );
begin
     style[ 'left' ] := IntToStr( aPxValue );
end;

{*******************************************************************************
* setAttributeInt
*******************************************************************************}
procedure THtmlHElement.setAttributeInt( const aAttrName : string; const aValue : integer );
begin
    attribute[ aAttrName ] := IntToStr( aValue );
end;

{*******************************************************************************
* getAttributeInt
*******************************************************************************}
function THtmlHElement.getAttributeInt( const aAttrName : string ) : integer;
begin
    Result := StrToIntDef( attribute[ aAttrName ], 0 );
end;

{*******************************************************************************
* get_attribute_int
*******************************************************************************}
function THtmlHElement.get_attribute_int( const aAttrName : string; aDefaultValue : integer = 0 ) : integer;
begin
    Result := StrToIntDef( attribute[ aAttrName ], aDefaultValue );
end;

{*******************************************************************************
* remove_attribute
*******************************************************************************}
procedure THtmlHElement.remove_attribute( const aAttrName : string );
begin
    assert( is_valid() );
    FlastError := HTMLayoutSetAttributeByName( Fhandler, LPCSTR( aAttrName ), LPCWSTR( nil ) );
    assert( FlastError = HLDOM_OK );
end;

{*******************************************************************************
* getAttributeIndex
*******************************************************************************}
function THtmlHElement.getAttributeIndex( const aAttrName : string ) : integer;
var
    i : integer;
begin
    Result := -1;
    for i := 0 to attributeCount - 1 do
    begin
        if ( attributeName[i] = aAttrName ) then
        begin
            Result := i;
            exit;
        end;
    end;
end;

{*******************************************************************************
* getAttrExists
*******************************************************************************}
function THtmlHElement.getAttrExists( const aAttrName : string ) : boolean;
begin
    Result := ( attributeIndex[ aAttrName ] >= 0 );
end;

{*******************************************************************************
* get_style_attribute
*******************************************************************************}
function THtmlHElement.get_style_attribute( const aAttrName : string ) : widestring;
var
    pValue : LPCWSTR;

begin
    Result := '';
    assert( is_valid() );
    FlastError := HTMLayoutGetStyleAttribute( Fhandler, LPCSTR( aAttrName ), pValue );
    assert( FlastError = HLDOM_OK );
    if ( FlastError <> HLDOM_OK ) then
        exit;

    Result := pValue;
end;

{*******************************************************************************
* set_style_attribute
*******************************************************************************}
procedure THtmlHElement.set_style_attribute( const aAttrName : string; const aValue : widestring );
begin
    assert( is_valid() );
    FlastError := HTMLayoutSetStyleAttribute( Fhandler, LPCSTR( aAttrName ), LPCWSTR( aValue ) );
    assert( FlastError = HLDOM_OK );
end;

{*******************************************************************************
* set_capture
*******************************************************************************}
procedure THtmlHElement.set_capture();
begin
    assert( is_valid() );
    FlastError := HTMLayoutSetCapture( Fhandler );
    assert( FlastError = HLDOM_OK );
end;

{*******************************************************************************
* release_capture
*******************************************************************************}
class procedure THtmlHElement.release_capture();
begin
    ReleaseCapture(); // WinAPI call
end;

{*******************************************************************************
* select
*******************************************************************************}
procedure THtmlHElement.select( aCallback : HTMLayoutElementCallback; const aParams : POINTER = nil; const aTag : string = ''; const aAttrName : string = ''; const aAttrValue : widestring = ''; aDepth : integer = 0 );
var
    tag   : LPCSTR;
    name  : LPCSTR;
    value : LPCWSTR;

begin
    if ( aTag <> '' ) then
        tag := LPCSTR( aTag )
    else
        tag := nil;

    if ( aAttrName <> '' ) then
        name := LPCSTR( aAttrName )
    else
        name  := nil;

    if ( aAttrValue <> '' ) then
        value := LPCWSTR( aAttrValue )
    else
        value  := nil;

    assert( is_valid() );
    FlastError := HTMLayoutVisitElements( Fhandler, tag, name, value, aCallback, aParams, aDepth );
    assert( FlastError = HLDOM_OK );
end;

{*******************************************************************************
* redraw
*******************************************************************************}
procedure THtmlHElement.redraw();
begin
    update( false );
end;

{*******************************************************************************
* update
*******************************************************************************}
procedure THtmlHElement.update( const render_now : boolean = false );
begin
    assert( is_valid() );
    FlastError := HTMLayoutUpdateElement( Fhandler, render_now );
    assert( FlastError = HLDOM_OK );
end;

{*******************************************************************************
* update
*******************************************************************************}
procedure THtmlHElement.update( const aMode : integer );
begin
    assert( is_valid() );
    FlastError := HTMLayoutUpdateElementEx( Fhandler, aMode );
    assert( FlastError = HLDOM_OK );
end;

{*******************************************************************************
* getInnerText
*******************************************************************************}
function THtmlHElement.getInnerText() : string;
var
    pValue : PCHAR;

begin
    Result := '';
    assert( is_valid() );
    FlastError := HTMLayoutGetElementInnerText( Fhandler, pValue );
    assert( FlastError = HLDOM_OK );
    if ( FlastError <> HLDOM_OK ) then
        exit;

    Result := pValue;
end;

{*******************************************************************************
* setInnerText
*******************************************************************************}
procedure THtmlHElement.setInnerText( const aUtf8bytes: string );
begin
    assert( is_valid() );
    FlastError := HTMLayoutSetElementInnerText( Fhandler, LPCSTR( aUtf8bytes ), Length( aUtf8bytes ) );
    assert( FlastError = HLDOM_OK );
end;

{*******************************************************************************
* getInnerText16
*******************************************************************************}
function THtmlHElement.getInnerText16() : widestring;
var
    pValue : PCHAR;

begin
    Result := '';
    assert( is_valid() );
    FlastError := HTMLayoutGetElementInnerText( Fhandler, pValue );
    assert( FlastError = HLDOM_OK );
    if ( FlastError <> HLDOM_OK ) then
        exit;

    Result := pValue;
end;

{*******************************************************************************
* setInnerText16
*******************************************************************************}
procedure THtmlHElement.setInnerText16( const aUtf16words: widestring );
begin
    assert( is_valid() );
    FlastError := HTMLayoutSetElementInnerText16( Fhandler, LPCWSTR( aUtf16words ), Length( aUtf16words ) );
    assert( FlastError = HLDOM_OK );
end;

function SelectByIdCallback( aElementHandler : HELEMENT; aParam : Pointer ) : BOOL stdcall;
begin
    PHELEMENT( aParam )^ := aElementHandler;
    Result := true;
end;

{*******************************************************************************
* getHandlerById
*******************************************************************************}
function THtmlHElement.getHandlerById( const aId : string ) : HELEMENT;
var
    selector : string;

begin
    Result := nil;
    assert( is_valid() );
    selector := '#' + aId;
    FlastError := HTMLayoutSelectElements( Fhandler, LPCSTR( selector ), SelectByIdCallback, @Result );
    assert( FlastError = HLDOM_OK );
end;

{*******************************************************************************
* getChild
*******************************************************************************}
function THtmlHElement.getChild( const aIndex : integer ) : HELEMENT;
begin
    Result := getChildHandler( Fhandler, aIndex );
end;

{*******************************************************************************
* getParentInfo
*******************************************************************************}
function THtmlHElement.getParentInfo() : RParentInfo;
begin
    Result.index  := index;
    Result.parent := getParentHandler();
    Result.children_count := getChildrenCount( Result.parent );
end;

{*******************************************************************************
* getNextSiblingHandler
*******************************************************************************}
function THtmlHElement.getNextSiblingHandler() : HELEMENT;
var
    info : RParentInfo;

begin
    Result := nil;
    assert( is_valid() );

    info := getParentInfo();
    if ( info.children_count <= info.index + 1 ) then
        exit;

    Result := getChildHandler( info.parent, info.index + 1 );
end;

{*******************************************************************************
* getPrevSiblingHandler
*******************************************************************************}
function THtmlHElement.getPrevSiblingHandler() : HELEMENT;
var
    info : RParentInfo;

begin
    Result := nil;
    assert( is_valid() );

    info := getParentInfo();
    if ( info.index = 0 ) then
        exit;

    Result := getChildHandler( info.parent, info.index - 1 );
end;

{*******************************************************************************
* getFirstSiblingHandler
*******************************************************************************}
function THtmlHElement.getFirstSiblingHandler() : HELEMENT;
var
    info : RParentInfo;

begin
    assert( is_valid() );

    info := getParentInfo();
    Result := getChildHandler( info.parent, 0 );
end;

{*******************************************************************************
* getLastSiblingHandler
*******************************************************************************}
function THtmlHElement.getLastSiblingHandler() : HELEMENT;
var
    info : RParentInfo;

begin
    assert( is_valid() );

    info := getParentInfo();
    Result := getChildHandler( info.parent, info.children_count - 1 );
end;

{*******************************************************************************
* getRootHandler
*******************************************************************************}
function THtmlHElement.getRootHandler() : HELEMENT;
var
    wnd : HWND;

begin
    Result := nil;
    wnd := get_element_hwnd( true );

    FlastError := HTMLayoutGetRootElement( wnd, Result );
    assert( FlastError = HLDOM_OK );
end;

{*******************************************************************************
* getLocation
*******************************************************************************}
function THtmlHElement.getLocation() : TRect;
begin
    Result := get_location( CONTENT_BOX );
end;

{*******************************************************************************
* get_location
*******************************************************************************}
function THtmlHElement.get_location( const aArea : HTMLayoutElementAreas = ROOT_RELATIVE ) : TRect;
begin
    assert( is_valid() );
    FlastError := HTMLayoutGetElementLocation( Fhandler, Result, integer( aArea ) );
    assert( FlastError = HLDOM_OK );
end;

{*******************************************************************************
* is_inside
*******************************************************************************}
function THtmlHElement.is_inside( const client_pt : TPOINT ) : boolean;
var
    rect : TRect;
begin
    Result := false;
    rect := get_location( CONTENT_BOX );
    if ( FlastError <> HLDOM_OK ) then
        exit;

    Result := ( client_pt.x >= rect.left ) and ( client_pt.x <= rect.right ) and ( client_pt.y >= rect.top ) and ( client_pt.y <= rect.bottom );
end;

{*******************************************************************************
* scroll_to_view
*******************************************************************************}
procedure THtmlHElement.scroll_to_view( toTopOfView : boolean = false; smooth : boolean = false );
var
    flags : UINT;
begin
    assert( is_valid() );

    flags := 0;
    if ( toTopOfView ) then
    begin
        flags := flags or UINT( SCROLL_TO_TOP );
    end;

    if ( smooth ) then
    begin
        flags := flags or UINT( SCROLL_SMOOTH );
    end;

    FlastError := HTMLayoutScrollToView( Fhandler, flags );
    assert( FlastError = HLDOM_OK );
end;

{*******************************************************************************
* get_element_type
*******************************************************************************}
function THtmlHElement.get_element_type() : string;
var
    pValue : LPCSTR;
begin
    Result := '';
    assert( is_valid() );
    FlastError := HTMLayoutGetElementType( Fhandler, pValue );
    assert( FlastError = HLDOM_OK );
    if ( FlastError <> HLDOM_OK ) then
        exit;

    Result := pValue;
end;

{*******************************************************************************
* get_element_hwnd
*******************************************************************************}
function THtmlHElement.get_element_hwnd( const root_window : boolean ) : HWND;
begin
    assert( is_valid() );
    FlastError := HTMLayoutGetElementHwnd( Fhandler, Result, root_window );
    assert( FlastError = HLDOM_OK );
end;

{*******************************************************************************
* combine_url
*******************************************************************************}
function THtmlHElement.combine_url( const inURL : widestring ) : widestring;
begin
    assert( false, 'Untested! Use at your own risk.' );

    assert( is_valid() );
    Result := inURL;
    SetLength( Result, 2048 );
    FlastError := HTMLayoutCombineURL( Fhandler, @Result[1], Length( Result ) );
    assert( FlastError = HLDOM_OK );
end;

{*******************************************************************************
* set_html
*******************************************************************************}
procedure THtmlHElement.set_html( const html : string; where : HTMLayoutSetHTMLWhere = SIH_REPLACE_CONTENT );
begin
    assert( is_valid() );
    FlastError := HTMLayoutSetElementHtml( Fhandler, PBYTE( @html[1] ), Length( html ), UINT( where ) );
    assert( FlastError = HLDOM_OK );
end;

{*******************************************************************************
* getState
*******************************************************************************}
function THtmlHElement.getStates() : cardinal;
begin
    assert( is_valid() );
    FlastError := HTMLayoutGetElementState( Fhandler, Result );
    assert( FlastError = HLDOM_OK );
end;

{*******************************************************************************
* setState
*******************************************************************************}
procedure THtmlHElement.setStates( const aBits : cardinal );
begin
    assert( is_valid() );
    FlastError := HTMLayoutSetElementState( Fhandler, aBits, not aBits, true );
    assert( FlastError = HLDOM_OK );
end;

{*******************************************************************************
* get_state
*******************************************************************************}
function THtmlHElement.get_state( const bits : cardinal ) : boolean;
begin
    Result := ( states and bits = bits ) and ( FlastError = HLDOM_OK );
end;

{*******************************************************************************
* set_state
*******************************************************************************}
procedure THtmlHElement.set_state( const bitsToSet : cardinal; const bitsToClear : cardinal = 0; update : boolean = true );
begin
    assert( is_valid() );
    FlastError := HTMLayoutSetElementState( Fhandler, bitsToSet, bitsToClear, update );
    assert( FlastError = HLDOM_OK );
end;

{*******************************************************************************
* getState
*******************************************************************************}
function THtmlHElement.getState( const aBit : cardinal ) : boolean;
begin
    Result := ( states and aBit = aBit ) and ( FlastError = HLDOM_OK );
end;

{*******************************************************************************
* setState
*******************************************************************************}
procedure THtmlHElement.setState( const aBit : cardinal; const aState : boolean );
begin
    if ( aState ) then
        set_state( aBit, 0, true )
    else
        set_state( 0, aBit, true );
end;

{*******************************************************************************
* enabled
*******************************************************************************}
function THtmlHElement.enabled() : boolean;
var
    pValue : BOOL;

begin
    assert( is_valid() );
    FlastError := HTMLayoutIsElementEnabled( Fhandler, pValue );
    assert( FlastError = HLDOM_OK );
    Result := pValue;
end;

{*******************************************************************************
* visible
*******************************************************************************}
function THtmlHElement.visible() : boolean;
var
    pValue : BOOL;

begin
    assert( is_valid() );
    FlastError := HTMLayoutIsElementVisible( Fhandler, pValue );
    assert( FlastError = HLDOM_OK );
    Result := pValue;
end;

{*******************************************************************************
* cloneHandler
*******************************************************************************}
function THtmlHElement.cloneHandler() : HELEMENT;
begin
    Result := nil;
    FlastError := HTMLayoutCloneElement( Fhandler, Result );
    assert( FlastError = HLDOM_OK );
    assert( Result <> nil );
end;

{*******************************************************************************
* insert
*******************************************************************************}
procedure THtmlHElement.insert( const aHandler : HELEMENT; const index : cardinal );
begin
    assert( is_valid() );
    assert( is_valid( aHandler ) );

    FlastError := HTMLayoutInsertElement( aHandler, Fhandler, index );
    assert( FlastError = HLDOM_OK );
end;


{*******************************************************************************
* append
*******************************************************************************}
procedure THtmlHElement.append( const aHandler : HELEMENT );
begin
    assert( is_valid() );
    assert( is_valid( aHandler ) );

    FlastError := HTMLayoutInsertElement( aHandler, Fhandler, childrenCount );
    assert( FlastError = HLDOM_OK );
end;

{*******************************************************************************
* detach
*******************************************************************************}
procedure THtmlHElement.detach();
begin
    assert( is_valid() );
    FlastError := HTMLayoutDetachElement( Fhandler );
    assert( FlastError = HLDOM_OK );
end;

{*******************************************************************************
* send_event
*******************************************************************************}
function THtmlHElement.send_event( const event_code : cardinal; reason : cardinal = 0; heSource : HELEMENT = nil ) : boolean;
var
    handled : BOOL;

begin
    assert( is_valid() );
    if ( not assigned( heSource ) ) then
    begin
        heSource := Fhandler;
    end;

    FlastError := HTMLayoutSendEvent( Fhandler, cardinal( event_code ), heSource, reason, handled );
    assert( FlastError = HLDOM_OK );
    Result := ( FlastError = HLDOM_OK ) and handled;
end;

{*******************************************************************************
* post_event
*******************************************************************************}
procedure THtmlHElement.post_event( const event_code : cardinal; reason : cardinal = 0; heSource : HELEMENT = nil );
begin
    assert( is_valid() );
    if ( not assigned( heSource ) ) then
    begin
        heSource := Fhandler;
    end;

    FlastError := HTMLayoutPostEvent( Fhandler, cardinal( event_code ), heSource, reason );
    assert( FlastError = HLDOM_OK );
end;

{*******************************************************************************
* attach
*******************************************************************************}
procedure THtmlHElement.attach( pevth : HTMLayoutHElementEvent; tag : Pointer = nil; subscription : UINT = HANDLE_ALL );
begin
    assert( is_valid() );
    FlastError := HTMLayoutAttachEventHandlerEx( Fhandler, pevth, tag, subscription );
    assert( FlastError = HLDOM_OK );
end;

{*******************************************************************************
* detach
*******************************************************************************}
procedure THtmlHElement.detach( pevth : HTMLayoutHElementEvent; tag : Pointer = nil; subscription : UINT = HANDLE_ALL );
begin
    assert( is_valid() );
    FlastError := HTMLayoutDetachEventHandler( Fhandler, pevth, tag ); //HTMLayoutDetachEventHandlerEx( Fhandler, pevth, tag, subscription );
    assert( FlastError = HLDOM_OK );
end;

{*******************************************************************************
* move
*******************************************************************************}
procedure THtmlHElement.move( x_view_rel, y_view_rel : integer );
begin
    assert( is_valid() );
    FlastError := HTMLayoutMoveElementEx( Fhandler, x_view_rel, y_view_rel, width, height );
    assert( FlastError = HLDOM_OK );
end;

{*******************************************************************************
* move
*******************************************************************************}
procedure THtmlHElement.move( x_view_rel, y_view_rel, aWidth, aHeight : integer );
begin
    assert( is_valid() );
    FlastError := HTMLayoutMoveElementEx( Fhandler, x_view_rel, y_view_rel, aWidth, aHeight );
    assert( FlastError = HLDOM_OK );
end;

{-------------------------------- THtmlElement --------------------------------}

{*******************************************************************************
* Create
*******************************************************************************}
constructor THtmlElement.Create();
begin
    inherited;

    FeventHandlers  := nil;
    FelementClass   := THtmlElement;
end;

{*******************************************************************************
* Destroy
*******************************************************************************}
destructor THtmlElement.Destroy();
begin
    //dettachElementProcEventHandler();

    FreeAndNil( FeventHandlers );

    inherited;
end;

{*******************************************************************************
* getRoot
*******************************************************************************}
function THtmlElement.getRoot() : THtmlElement;
begin
    Result := FelementClass.Create( getRootHandler() );
end;

{*******************************************************************************
* getParent
*******************************************************************************}
function THtmlElement.getParent() : THtmlElement;
begin
    Result := FelementClass.Create( getParentHandler() );
end;

{*******************************************************************************
* getChild
*******************************************************************************}
function THtmlElement.getChild( const aIndex : integer ) : THtmlElement;
var
    he : HELEMENT;

begin
    //Result := createElement( getChildHandler( aIndex ) );
    he := getChildHandler( Fhandler, aIndex );
    Result := FelementClass.Create( he );
end;

{*******************************************************************************
* update
*******************************************************************************}
function THtmlElement.update( const render_now : boolean = false ) : THtmlElement;
begin
    inherited update( render_now );
    Result := self;
end;

{*******************************************************************************
* update
*******************************************************************************}
function THtmlElement.update( const aMode : integer ) : THtmlElement;
begin
    inherited update( aMode );
    Result := self;
end;

{*******************************************************************************
* redraw
*******************************************************************************}
function THtmlElement.redraw() : THtmlElement;
begin
    inherited redraw();
    Result := self;
end;

{*******************************************************************************
* clone
*******************************************************************************}
function THtmlElement.clone() : THtmlElement;
begin
    Result := FelementClass.Create( cloneHandler() );
end;

{*******************************************************************************
* get_element_by_id
*******************************************************************************}
function THtmlElement.get_element_by_id( const aId : string ) : THtmlElement;
begin
    Result := FelementClass.Create( getHandlerById( aId ) );
end;

{*******************************************************************************
* next_sibling
*******************************************************************************}
function THtmlElement.next_sibling() : THtmlElement;
begin
    Result := FelementClass.Create( getNextSiblingHandler() );
end;

{*******************************************************************************
* prev_sibling
*******************************************************************************}
function THtmlElement.prev_sibling() : THtmlElement;
begin
    Result := FelementClass.Create( getPrevSiblingHandler() );
end;

{*******************************************************************************
* first_sibling
*******************************************************************************}
function THtmlElement.first_sibling() : THtmlElement;
begin
    Result := FelementClass.Create( getFirstSiblingHandler() );
end;

{*******************************************************************************
* last_sibling
*******************************************************************************}
function THtmlElement.last_sibling() : THtmlElement;
begin
    Result := FelementClass.Create( getLastSiblingHandler() );
end;

{*******************************************************************************
* scroll_to_view
*******************************************************************************}
function THtmlElement.scroll_to_view( toTopOfView : boolean = false; smooth : boolean = false ) : THtmlElement;
begin
    inherited scroll_to_view( toTopOfView, smooth );
    Result := self;
end;

{*******************************************************************************
* set_state
*******************************************************************************}
function THtmlElement.set_state( const bitsToSet : cardinal; const bitsToClear : cardinal = 0; update : boolean = true ) : THtmlElement;
begin
    inherited set_state( bitsToSet, bitsToClear, update );
    Result := self;
end;

{*******************************************************************************
* insert
*******************************************************************************}
function THtmlElement.insert( const element : THtmlHElement; const index : cardinal ) : THtmlElement;
begin
    inherited insert( element.handler, index );
    Result := self;
end;

{*******************************************************************************
* append
*******************************************************************************}
function THtmlElement.append( const element : THtmlHElement ) : THtmlElement;
begin
    inherited append( element.handler );
    Result := self;
end;

{*******************************************************************************
* detach
*******************************************************************************}
function THtmlElement.detach() : THtmlElement;
begin
    inherited detach();
    Result := self;
end;

{*******************************************************************************
* getMethodHandlers
*******************************************************************************}
function THtmlElement.getEventHandlers() : TEventHandlers;
begin
    if ( FeventHandlers = nil ) then
    begin
        FeventHandlers := TEventHandlers.Create( true );
    end;

    Result := FeventHandlers;
end;

{*******************************************************************************
* attach
*******************************************************************************}
procedure THtmlElement.attach( aEventParams : TEventHandlerParams; aEventHandler : HTMLayoutHElementEvent );
begin
    assert( is_valid() );
    FlastError := HTMLayoutAttachEventHandlerEx( Fhandler, aEventHandler, aEventParams, aEventParams.Fsubscription );
    assert( FlastError = HLDOM_OK );
end;

{*******************************************************************************
* detach
*******************************************************************************}
procedure THtmlElement.detach( aEventParams : TEventHandlerParams; aEventHandler : HTMLayoutHElementEvent );
begin
    assert( is_valid() );
    FlastError := HTMLayoutDetachEventHandler( Fhandler, aEventHandler, aEventParams ); //HTMLayoutDetachEventHandlerEx( Fhandler, aEventHandler, aEventParams, aEventParams.Fsubscription );
    assert( FlastError = HLDOM_OK );
end;

{-------------- ProcEventHandler }

{*******************************************************************************
* ProcEventHandler
*******************************************************************************}
function ProcEventHandler( aTag : Pointer; aHandler: HELEMENT; aEventGroup : UINT; aParams : Pointer ) : BOOL stdcall;
var
    h : TEventHandlerParams; //TProcHandlerParams;

begin
    h := TEventHandlerParams{TProcHandlerParams}( aTag );
    Result := h.call( aEventGroup, aParams );
end;

{*******************************************************************************
* attach
*******************************************************************************}
procedure THtmlElement.attach( aEventParams : TEventHandlerParams );
begin
    attach( aEventParams, ProcEventHandler );
end;

{*******************************************************************************
* detach
*******************************************************************************}
procedure THtmlElement.detach( aEventParams : TEventHandlerParams );
begin
    detach( aEventParams, ProcEventHandler );
end;

{*******************************************************************************
* attach  TProcHandlerParams
*******************************************************************************}
function THtmlElement.attach( aEventHandler : HTMLElementProcEventHandler; aTag : Pointer = nil; aSubscription : UINT = HANDLE_ALL or DISABLE_INITIALIZATION ) : TProcHandlerParams;
begin
    Result := TProcHandlerParams.Create( self, aEventHandler, aTag, aSubscription );
    eventHandlers.Add( Result );

    attach( Result );
end;

{*******************************************************************************
* detach TProcHandlerParams
*******************************************************************************}
procedure THtmlElement.detach( aEventHandler : HTMLElementProcEventHandler; aTag : Pointer = nil; aSubscription : UINT = HANDLE_ALL or DISABLE_INITIALIZATION );
var
    h : TProcHandlerParams;

begin
    h := eventHandlers.getHandler( aEventHandler, aTag, aSubscription );
    assert( handler <> nil );

    detach( h );
end;

{-------------- MethodEventHandler }

{*******************************************************************************
* attach TMethodHandlerParams
*******************************************************************************}
function THtmlElement.attach( aEventHandler : HTMLElementMethodEventHandler; aTag : Pointer = nil; aSubscription : UINT = HANDLE_ALL or DISABLE_INITIALIZATION ) : TMethodHandlerParams;
begin
    Result := TMethodHandlerParams.Create( self, TMethod( aEventHandler ), aTag, aSubscription );
    eventHandlers.Add( Result );

    attach( Result );
end;

{*******************************************************************************
* detach TMethodHandlerParams
*******************************************************************************}
procedure THtmlElement.detach( aEventHandler : HTMLElementMethodEventHandler; aTag : Pointer = nil; aSubscription : UINT = HANDLE_ALL or DISABLE_INITIALIZATION );
var
    h : TMethodHandlerParams;

begin
    if ( not is_valid() ) then
        exit;

    h := eventHandlers.getHandler( TMethod( aEventHandler ), aTag, aSubscription );
    detach( h );
end;

{*******************************************************************************
* attach
*******************************************************************************}
procedure THtmlElement.attach( aEventParams : THtmlCmdEventParams );
begin
    eventHandlers.Add( aEventParams );
    attach( TMethodHandlerParams( aEventParams ) );
end;

{*******************************************************************************
* detach
*******************************************************************************}
procedure THtmlElement.detach( const aEventHandler : TMethod; const aCmd : integer = ALL_CMD; aTag : Pointer = nil; aSubscription : UINT = HANDLE_ALL or DISABLE_INITIALIZATION );
var
    h : THtmlCmdEventParams;

begin
    if ( not is_valid() ) then
        exit;

    h := eventHandlers.getHandler( aCmd, TMethod( aEventHandler ), aTag, aSubscription );
    detach( h );
end;

{----------------------------- HANDLE_INITIALIZATION --------------------------}

procedure THtmlElement.attachInitialization( const aCmd : integer; const aEventHandler : HTMLElementInitializationEventHandler );
begin
    attach( aEventHandler, aCmd, nil );
end;

function THtmlElement.attach( const aEventHandler : HTMLElementInitializationEventHandler; const aCmd : integer = INITIALIZATION_ALL; aTag : Pointer = nil ) : THtmlCmdEventParams;
begin
    if ( aCmd = INITIALIZATION_ALL ) then
        Result := THtmlInitializationEvent.Create( self, TMethod( aEventHandler ), aTag, HANDLE_INITIALIZATION )
    else
        Result := THtmlInitializationCmd.Create( self, aCmd, TMethod( aEventHandler ), aTag, HANDLE_INITIALIZATION );

    attach( Result );
end;

procedure THtmlElement.detach( const aEventHandler : HTMLElementInitializationEventHandler; const aCmd : integer = INITIALIZATION_ALL; aTag : Pointer = nil );
begin
    detach( TMethod( aEventHandler ), aCmd, aTag, HANDLE_INITIALIZATION );
end;

{--------------------------------- HANDLE_MOUSE -------------------------------}

procedure THtmlElement.attachMouse( const aCmd : integer; const aEventHandler : HTMLElementMouseEventHandler );
begin
    attach( aEventHandler, aCmd, nil );
end;

function THtmlElement.attach( const aEventHandler : HTMLElementMouseEventHandler; const aCmd : integer = MOUSE_ALL; aTag : Pointer = nil; aSubscription : UINT = HANDLE_MOUSE or DISABLE_INITIALIZATION ) : THtmlCmdEventParams;
begin
    if ( aCmd = MOUSE_ALL ) then
        Result := THtmlMouseEvent.Create( self, TMethod( aEventHandler ), aTag, aSubscription )
    else
        Result := THtmlMouseCmd.Create( self, aCmd, TMethod( aEventHandler ), aTag, aSubscription );

    attach( Result );
end;

procedure THtmlElement.detach( const aEventHandler : HTMLElementMouseEventHandler; const aCmd : integer = MOUSE_ALL; aTag : Pointer = nil; aSubscription : UINT = HANDLE_MOUSE or DISABLE_INITIALIZATION );
begin
    detach( TMethod( aEventHandler ), aCmd, aTag, aSubscription );
end;

{-------------------------------- HANDLE_KEY ----------------------------------}

procedure THtmlElement.attachKey( const aCmd : integer; const aEventHandler : HTMLElementKeyEventHandler );
begin
    attach( aEventHandler, aCmd, nil );
end;

function THtmlElement.attach( const aEventHandler : HTMLElementKeyEventHandler; const aCmd : integer = KEY_ALL; aTag : Pointer = nil; aSubscription : UINT = HANDLE_KEY or DISABLE_INITIALIZATION ) : THtmlCmdEventParams;
begin
    if ( aCmd = KEY_ALL ) then
        Result := THtmlKeyEvent.Create( self, TMethod( aEventHandler ), aTag, aSubscription )
    else
        Result := THtmlKeyCmd.Create( self, aCmd, TMethod( aEventHandler ), aTag, aSubscription );

    attach( Result );
end;

procedure THtmlElement.detach( const aEventHandler : HTMLElementKeyEventHandler; const aCmd : integer = KEY_ALL; aTag : Pointer = nil; aSubscription : UINT = HANDLE_KEY or DISABLE_INITIALIZATION );
begin
    detach( TMethod( aEventHandler ), aCmd, aTag, aSubscription );
end;

{------------------------------- HANDLE_FOCUS ---------------------------------}

procedure THtmlElement.attachFocus( const aCmd : integer; const aEventHandler : HTMLElementFocusEventHandler );
begin
    attach( aEventHandler, aCmd, nil );
end;

function THtmlElement.attach( const aEventHandler : HTMLElementFocusEventHandler; const aCmd : integer = FOCUS_ALL; aTag : Pointer = nil; aSubscription : UINT = HANDLE_KEY or DISABLE_INITIALIZATION ) : THtmlCmdEventParams;
begin
    if ( aCmd = FOCUS_ALL ) then
        Result := THtmlFocusEvent.Create( self, TMethod( aEventHandler ), aTag, aSubscription )
    else
        Result := THtmlFocusCmd.Create( self, aCmd, TMethod( aEventHandler ), aTag, aSubscription );

    attach( Result );
end;

procedure THtmlElement.detach( const aEventHandler : HTMLElementFocusEventHandler; const aCmd : integer = FOCUS_ALL; aTag : Pointer = nil; aSubscription : UINT = HANDLE_KEY or DISABLE_INITIALIZATION );
begin
    detach( TMethod( aEventHandler ), aCmd, aTag, aSubscription );
end;

{------------------------------- HANDLE_SCROLL --------------------------------}

procedure THtmlElement.attachScroll( const aCmd : integer; const aEventHandler : HTMLElementScrollEventHandler );
begin
    attach( aEventHandler, aCmd, nil );
end;

function THtmlElement.attach( const aEventHandler : HTMLElementScrollEventHandler; const aCmd : integer = SCROLL_ALL; aTag : Pointer = nil; aSubscription : UINT = HANDLE_SCROLL or DISABLE_INITIALIZATION ) : THtmlCmdEventParams;
begin
    if ( aCmd = SCROLL_ALL ) then
        Result := THtmlScrollEvent.Create( self, TMethod( aEventHandler ), aTag, aSubscription )
    else
        Result := THtmlScrollCmd.Create( self, aCmd, TMethod( aEventHandler ), aTag, aSubscription );

    attach( Result );
end;

procedure THtmlElement.detach( const aEventHandler : HTMLElementScrollEventHandler; const aCmd : integer = SCROLL_ALL; aTag : Pointer = nil; aSubscription : UINT = HANDLE_SCROLL or DISABLE_INITIALIZATION );
begin
    detach( TMethod( aEventHandler ), aCmd, aTag, aSubscription );
end;

{--------------------------------- HANDLE_DRAW --------------------------------}

procedure THtmlElement.attachDraw( const aCmd : integer; const aEventHandler : HTMLElementDrawEventHandler );
begin
    attach( aEventHandler, aCmd, nil );
end;

function THtmlElement.attach( const aEventHandler : HTMLElementDrawEventHandler; const aCmd : integer = DRAW_ALL; aTag : Pointer = nil; aSubscription : UINT = HANDLE_DRAW or DISABLE_INITIALIZATION ) : THtmlCmdEventParams;
begin
    if ( aCmd = DRAW_ALL ) then
        Result := THtmlDrawEvent.Create( self, TMethod( aEventHandler ), aTag, aSubscription )
    else
        Result := THtmlDrawCmd.Create( self, aCmd, TMethod( aEventHandler ), aTag, aSubscription );

    attach( Result );
end;

procedure THtmlElement.detach( const aEventHandler : HTMLElementDrawEventHandler; const aCmd : integer = DRAW_ALL; aTag : Pointer = nil; aSubscription : UINT = HANDLE_DRAW or DISABLE_INITIALIZATION );
begin
    detach( TMethod( aEventHandler ), aCmd, aTag, aSubscription );
end;

{--------------------------------- HANDLE_TIMER --------------------------------}

procedure THtmlElement.attachTimer( const aEventHandler : HTMLElementTimerEventHandler );
begin
    attach( aEventHandler, nil );
end;

function THtmlElement.attach( const aEventHandler : HTMLElementTimerEventHandler; aTag : Pointer = nil; aSubscription : UINT = HANDLE_TIMER or DISABLE_INITIALIZATION ) : THtmlCmdEventParams;
begin
    Result := THtmlTimerEvent.Create( self, TMethod( aEventHandler ), aTag, aSubscription );
    attach( Result );
end;

procedure THtmlElement.detach( const aEventHandler : HTMLElementTimerEventHandler; aTag : Pointer = nil; aSubscription : UINT = HANDLE_TIMER or DISABLE_INITIALIZATION );
begin
    detach( TMethod( aEventHandler ), ALL_CMD, aTag, aSubscription );
end;

{--------------------------------- HANDLE_SIZE --------------------------------}

procedure THtmlElement.attachSize( const aEventHandler : HTMLElementSizeEventHandler );
begin
    attach( aEventHandler, nil );
end;

function THtmlElement.attach( const aEventHandler : HTMLElementSizeEventHandler; aTag : Pointer = nil; aSubscription : UINT = HANDLE_SIZE or DISABLE_INITIALIZATION ) : THtmlCmdEventParams;
begin
    Result := THtmlSizeEvent.Create( self, TMethod( aEventHandler ), aTag, aSubscription );
    attach( Result );
end;

procedure THtmlElement.detach( const aEventHandler : HTMLElementSizeEventHandler; aTag : Pointer = nil; aSubscription : UINT = HANDLE_SIZE or DISABLE_INITIALIZATION );
begin
    detach( TMethod( aEventHandler ), ALL_CMD, aTag, aSubscription );
end;

{----------------------------- HANDLE_DATA_ARRIVED ----------------------------}

procedure THtmlElement.attachDataArrived( const aEventHandler : HTMLElementDataArrivedEventHandler );
begin
    attach( aEventHandler, nil );
end;

function THtmlElement.attach( const aEventHandler : HTMLElementDataArrivedEventHandler; aTag : Pointer = nil; aSubscription : UINT = HANDLE_DATA_ARRIVED or DISABLE_INITIALIZATION ) : THtmlCmdEventParams;
begin
    Result := THtmlDataArrivedEvent.Create( self, TMethod( aEventHandler ), aTag, aSubscription );
    attach( Result );
end;

procedure THtmlElement.detach( const aEventHandler : HTMLElementDataArrivedEventHandler; aTag : Pointer = nil; aSubscription : UINT = HANDLE_DATA_ARRIVED or DISABLE_INITIALIZATION );
begin
    detach( TMethod( aEventHandler ), ALL_CMD, aTag, aSubscription );
end;

{------------------------------- HANDLE_EXCHANGE ------------------------------}

procedure THtmlElement.attachExchange( const aCmd : integer; const aEventHandler : HTMLElementExchangeEventHandler );
begin
    attach( aEventHandler, aCmd, nil );
end;

function THtmlElement.attach( const aEventHandler : HTMLElementExchangeEventHandler; const aCmd : integer = EXC_ALL; aTag : Pointer = nil; aSubscription : UINT = HANDLE_EXCHANGE or DISABLE_INITIALIZATION ) : THtmlCmdEventParams;
begin
    if ( aCmd = DRAW_ALL ) then
        Result := THtmlExchangeEvent.Create( self, TMethod( aEventHandler ), aTag, aSubscription )
    else
        Result := THtmlExchangeCmd.Create( self, aCmd, TMethod( aEventHandler ), aTag, aSubscription );

    attach( Result );
end;

procedure THtmlElement.detach( const aEventHandler : HTMLElementExchangeEventHandler; const aCmd : integer = EXC_ALL; aTag : Pointer = nil; aSubscription : UINT = HANDLE_EXCHANGE or DISABLE_INITIALIZATION );
begin
    detach( TMethod( aEventHandler ), aCmd, aTag, aSubscription );
end;

{------------------------------- HANDLE_GESTURE -------------------------------}

procedure THtmlElement.attachGesture( const aCmd : integer; const aEventHandler : HTMLElementGestureEventHandler );
begin
    attach( aEventHandler, aCmd, nil );
end;

function THtmlElement.attach( const aEventHandler : HTMLElementGestureEventHandler; const aCmd : integer = GESTURE_ALL; aTag : Pointer = nil; aSubscription : UINT = HANDLE_GESTURE or DISABLE_INITIALIZATION ) : THtmlCmdEventParams;
begin
    if ( aCmd = GESTURE_ALL ) then
        Result := THtmlGestureEvent.Create( self, TMethod( aEventHandler ), aTag, aSubscription )
    else
        Result := THtmlGestureCmd.Create( self, aCmd, TMethod( aEventHandler ), aTag, aSubscription );

    attach( Result );
end;

procedure THtmlElement.detach( const aEventHandler : HTMLElementGestureEventHandler; const aCmd : integer = GESTURE_ALL; aTag : Pointer = nil; aSubscription : UINT = HANDLE_GESTURE or DISABLE_INITIALIZATION );
begin
    detach( TMethod( aEventHandler ), aCmd, aTag, aSubscription );
end;

{------------------------------- THtmlShim ------------------------------------}

{*******************************************************************************
* get
*******************************************************************************}
class function THtmlShim.get( const aHandler : HELEMENT ) : THtmlShim;
begin
    assert( GlobalShim <> nil );

    GlobalShim.Fhandler := aHandler;
    Result := GlobalShim;
end;

{*******************************************************************************
* get
*******************************************************************************}
class function THtmlShim.get( aElement : THtmlElement ) : THtmlShim;
begin
    Result := get( aElement.Fhandler );
end;

{*******************************************************************************
* getRoot
*******************************************************************************}
function THtmlShim.getRoot() : THtmlShim;
begin
    Result := get( getRootHandler() );
end;

{*******************************************************************************
* getChild
*******************************************************************************}
function THtmlShim.getChild( const aIndex : integer ) : THtmlShim;
begin
    Result := get( getChildHandler( Fhandler, aIndex ) );
end;

{*******************************************************************************
* getParent
*******************************************************************************}
function THtmlShim.getParent() : THtmlShim;
begin
    Result := get( getParentHandler() );
end;

{*******************************************************************************
* getNextSibling
*******************************************************************************}
function THtmlShim.getNextSibling() : THtmlShim;
begin
    Result := get( getNextSiblingHandler() );
end;

{*******************************************************************************
* getPrevSibling
*******************************************************************************}
function THtmlShim.getPrevSibling() : THtmlShim;
begin
    Result := get( getPrevSiblingHandler() );
end;

{*******************************************************************************
* getFirstSibling
*******************************************************************************}
function THtmlShim.getFirstSibling() : THtmlShim;
begin
    Result := get( getFirstSiblingHandler() );
end;

{*******************************************************************************
* getLastSibling
*******************************************************************************}
function THtmlShim.getLastSibling() : THtmlShim;
begin
    Result := get( getLastSiblingHandler() );
end;

{*******************************************************************************
* clone
*******************************************************************************}
function THtmlShim.clone() : THtmlShim;
begin
    Result := get( cloneHandler() );
end;

{*******************************************************************************
* get_element_by_id
*******************************************************************************}
function THtmlShim.get_element_by_id( const aId : string ) : THtmlShim;
begin
    Result := get( getHandlerById( aId ) );
end;

{*******************************************************************************
* update
*******************************************************************************}
function THtmlShim.update( const render_now : boolean = false ) : THtmlShim;
begin
    inherited update( render_now );
    Result := self;
end;

{*******************************************************************************
* update
*******************************************************************************}
function THtmlShim.update( const aMode : integer ) : THtmlShim;
begin
    inherited update( aMode );
    Result := self;
end;

{*******************************************************************************
* redraw
*******************************************************************************}
function THtmlShim.redraw() : THtmlShim;
begin
    inherited redraw();
    Result := self;
end;

{*******************************************************************************
* next_sibling
*******************************************************************************}
function THtmlShim.next_sibling() : THtmlShim;
begin
    Result := getNextSibling();
end;

{*******************************************************************************
* prev_sibling
*******************************************************************************}
function THtmlShim.prev_sibling() : THtmlShim;
begin
    Result := getPrevSibling();
end;

{*******************************************************************************
* first_sibling
*******************************************************************************}
function THtmlShim.first_sibling() : THtmlShim;
begin
    Result := getFirstSibling();
end;

{*******************************************************************************
* last_sibling
*******************************************************************************}
function THtmlShim.last_sibling() : THtmlShim;
begin
    Result := getLastSibling();
end;

{*******************************************************************************
* scroll_to_view
*******************************************************************************}
function THtmlShim.scroll_to_view( toTopOfView : boolean = false; smooth : boolean = false ) : THtmlShim;
begin
    inherited scroll_to_view( toTopOfView, smooth );
    Result := self;
end;

{*******************************************************************************
* set_state
*******************************************************************************}
function THtmlShim.set_state( const bitsToSet : cardinal; const bitsToClear : cardinal = 0; update : boolean = true ) : THtmlShim;
begin
    inherited set_state( bitsToSet, bitsToClear, update );
    Result := self;
end;

{*******************************************************************************
* insert
*******************************************************************************}
function THtmlShim.insert( const element : THtmlHElement; const index : cardinal ) : THtmlShim;
begin
    inherited insert( element.handler, index );
    Result := self;
end;

{*******************************************************************************
* append
*******************************************************************************}
function THtmlShim.append( const element : THtmlHElement ) : THtmlShim;
begin
    inherited append( element.handler );
    Result := self;
end;

{*******************************************************************************
* detach
*******************************************************************************}
function THtmlShim.detach() : THtmlShim;
begin
    inherited detach();
    Result := self;
end;

INITIALIZATION
    GlobalShim := THtmlShim.Create();

FINALIZATION
    FreeAndNil( GlobalShim );

end.

