unit HtmlElement;

(*
  HTMLayout License terms could be found here http://www.terrainformatica.com/htmlayout/prices.whtm
  SDK - http://www.terrainformatica.com/htmlayout/HTMLayoutSDK.zip

  Delphi binding of HTMLayout published under LGPL. Visit https://github.com/Keksov/HtmlayoutDelphi

  This file contains classes for manipulating DOM and handling events.
*)

interface

{$IFDEF USER_DEFINES_INC}{$I user_defines.inc}{$ENDIF}

uses Windows, sysutils, Contnrs, graphics
    , HtmlTypes
    , HtmlBehaviorH
    , HtmlLayoutH
    , HtmlLayoutDomH
    , HtmlValueH
    , HtmlValue
    , unisSVG
    , htmlConst
;

const
    INSERT_AT_END = $7FFFFFF;

type
    THtmlHElement = class;

{---------------------------- THtmlHElement -----------------------------------}

    RParentInfo = record
        index                   : cardinal;
        parent                  : HELEMENT;
        children_count          : cardinal;
    end;

    HTMLayoutHElementCallback = function( he : HELEMENT; sParams : POINTER ) : boolean of object;

    RSelectHandler = record
        callback                : HTMLayoutHElementCallback;
        params                  : Pointer;
    end;
    PRSelectHandler = ^RSelectHandler;

    {***************************************************************************
    * THtmlHElement
    ***************************************************************************}
    THtmlHElement = class( TInterfacedObject )
private
    Fhandler                    : HELEMENT;
    FlastError                  : HLDOM_RESULT;
    Funused                     : boolean;
    Fvalue                      : THtmlValue;

private
    procedure   setHandler( const aHandler : HELEMENT );
    function    getParentInfo() : RParentInfo;

    procedure   setStyleAsInt( const aAttrIndex : integer; const aValue : integer );
    function    getStyleAsInt( const aAttrIndex : integer ) : integer;
    procedure   setStyleAsString( const aAttrIndex : integer; const aValue : string );
    function    getStyleAsString( const aAttrIndex : integer ) : string;

    function    getId() : widestring;
    procedure   setId( const aId : widestring );

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
    procedure   setStates( aBits : cardinal );
    function    getState( aBit : cardinal ) : boolean;
    procedure   setState( aBit : cardinal; aState : boolean );
    function    getNamedState( aBit : integer ) : boolean;
    procedure   setNamedState( aBit : integer; aState : boolean );

    function    getValue() : THtmlValue;

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

    function    internalUse() : boolean;
    function    internalUnuse() : boolean;
    procedure   freeResources(); virtual;
    procedure   internalSetHandler( const aHandler : HELEMENT ); virtual;

public
    constructor Create(); overload; virtual;
    constructor Create( const aHandler : HELEMENT ); overload;
    constructor Create( const aHElement : THtmlHElement ); overload;
    constructor Create( const aTag : string; const aText : widestring = '' ); overload;
    destructor  Destroy(); override;

    function    use() : boolean;
    function    unuse() : boolean;

    function    clone() : HELEMENT;
    function    get_element_by_id( const aId : string ) : HELEMENT;
    function    next_sibling() : HELEMENT;
    function    prev_sibling() : HELEMENT;
    function    first_sibling() : HELEMENT;
    function    last_sibling() : HELEMENT;
    procedure   insert( const aHandler : HELEMENT; const index : cardinal );
    procedure   append( const aHandler : HELEMENT );

    procedure   delete(); // delete DOM element given by Fhandler from html
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

    procedure   select( aCallback : HTMLayoutElementCallback; const aSelector : string; const aParams : POINTER = nil ); overload;
    procedure   select( aCallback : HTMLayoutHElementCallback; const aSelector : string; const aParams : POINTER = nil ); overload;
    procedure   select( aCallback : HTMLayoutElementCallback; const aParams : POINTER = nil; const aTag : string = ''; const aAttrName : string = ''; const aAttrValue : widestring = ''; aDepth : integer = 0 ); overload;
    procedure   select( aCallback : HTMLayoutHElementCallback; const aParams : POINTER = nil; const aTag : string = ''; const aAttrName : string = ''; const aAttrValue : widestring = ''; aDepth : integer = 0 ); overload;
    procedure   select( const aSelector : string; var aResult : HELEMENT ); overload; virtual;

    procedure   update( const render_now : boolean = false ); overload;
    // aMode - bitwise combination of UPDATE_ELEMENT_FLAGS
    procedure   update( const aMode : integer ); overload;
    procedure   redraw();
    function    get_location( const aArea : HTMLAYOUT_ELEMENT_AREAS = ROOT_RELATIVE ) : TRect; virtual;
    function    is_inside( const client_pt : TPOINT ) : boolean;
    procedure   scroll_to_view( toTopOfView : boolean = false; smooth : boolean = false );
    function    get_element_type() : string;

    function    get_value() : RHtmlValue; // this is low level API call of HTMLayoutControlGetValue, use 'value' property instead ( see. THtmlValue )
    procedure   set_value( var aValue : RHtmlValue ); // this is low level API call of HTMLayoutControlSetValue, use 'value' property instead ( see. THtmlValue )

    function    get_element_hwnd( const root_window : boolean ) : HWND;
    function    get_element_uid() : UINT;
    function    combine_url( const inURL : widestring ) : widestring;
    procedure   set_html( const html : string; where : HTMLayoutSetHTMLWhere = SIH_REPLACE_CONTENT );
    procedure   clear();
    function    get_state( bits : cardinal ) : boolean;
    procedure   set_state( bitsToSet : cardinal; bitsToClear : cardinal = 0; update : boolean = true );
    function    enabled() : boolean;
    function    visible() : boolean;
    procedure   detach(); overload;
    function    send_event( event_code : cardinal; reason : cardinal = 0; heSource : HELEMENT = nil ) : boolean;
    procedure   post_event( event_code : cardinal; reason : cardinal = 0; heSource : HELEMENT = nil );
    {** move element to new location given by x_view_rel, y_view_rel - view relative coordinates.
     *  Method defines local styles, so to "stick" it back to the original location you
     *  should call element::clear_all_style_attributes().
     **}
    procedure   move( x_view_rel, y_view_rel : integer ); overload;
    procedure   move( x_view_rel, y_view_rel, aWidth, aHeight : integer ); overload;

    procedure   attach( pevth : HTMLayoutElementEventProc; tag : Pointer = nil; subscription : UINT = HANDLE_ALL );
    procedure   detach( pevth : HTMLayoutElementEventProc; tag : Pointer = nil; subscription : UINT = HANDLE_ALL ); overload;

    function    render( aHBmp : HBITMAP; aDstRect : TRect ) : boolean; overload;
    function    render( aBitmap : TBitmap ) : boolean; overload;

class procedure release_capture();
class function  cleanHtml( const aHtml : string ) : string; // remove 0xD, 0xA, 0x9 from string

public // property
    property id : widestring read getId write setId;

    property tag : string read get_element_type; // div, span, p, etc.
    property uid : UINT read get_element_uid;
    property states : cardinal read getStates write setStates;
    property state[ aState : cardinal ] : boolean read getState write setState;
    property lastError : HLDOM_RESULT read FlastError;
    property handler : HELEMENT read Fhandler write setHandler;
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

public // property: CSS shorcuts, fill free to extend it.
    property pxWidth : integer index STYLE_ATTR_WIDTH read getStyleAsInt write setStyleAsInt;
    property pxHeight : integer index STYLE_ATTR_HEIGHT read getStyleAsInt write setStyleAsInt;
    property pxLeft : integer index STYLE_ATTR_LEFT read getStyleAsInt write setStyleAsInt;
    property pxTop : integer index STYLE_ATTR_TOP read getStyleAsInt write setStyleAsInt;
    property backgroundColor : string index STYLE_ATTR_BACKGROUND_COLOR read getStyleAsString write setStyleAsString;
    property color : string index STYLE_ATTR_COLOR read getStyleAsString write setStyleAsString;
    property visibility : string index STYLE_ATTR_VISIBILITY read getStyleAsString write setStyleAsString;
    property value : THtmlValue read getValue;

public // property|: predefined states, same as state[ aState : cardinal ] but with more readable names
    // more info on states could be found here http://www.terrainformatica.com/htmlayout/csss!-dom-object.htm
    property link : boolean index STATE_LINK read getNamedState write setNamedState; // any element having href attribute
    property hover : boolean index STATE_HOVER read getNamedState write setNamedState; // element is under the cursor, mouse hover
    property active : boolean index STATE_ACTIVE read getNamedState write setNamedState; // element is activated, e.g. pressed
    property focus : boolean index STATE_FOCUS read getNamedState write setNamedState; // element is in focus
    property visited : boolean index STATE_VISITED read getNamedState write setNamedState; // aux flag - not used internally now
    property current : boolean index STATE_CURRENT read getNamedState write setNamedState; // current (hot) item in collection, e.g. current <option> in <select>
    property checked : boolean index STATE_CHECKED read getNamedState write setNamedState; // element is checked (or selected), e.g. check box or itme in multiselect
    property disabled : boolean index STATE_DISABLED read getNamedState write setNamedState; // element is disabled, behavior related flag.
    property readonly : boolean index STATE_READONLY read getNamedState write setNamedState; // readonly input element, behavior related flag
    property expanded : boolean index STATE_EXPANDED read getNamedState write setNamedState; // expanded state - nodes in tree view e.g. <options> in <select>
    property collapsed : boolean index STATE_COLLAPSED read getNamedState write setNamedState; // collapsed state - nodes in tree view - mutually exclusive with EXPANDED
    property incomplete : boolean index STATE_INCOMPLETE read getNamedState write setNamedState; // element has (back/fore/bullet) images requested but not delivered
    property animating : boolean index STATE_ANIMATING read getNamedState write setNamedState; // is animating currently
    property focusable : boolean index STATE_FOCUSABLE read getNamedState write setNamedState; // shall accept focus
    property anchor : boolean index STATE_ANCHOR read getNamedState write setNamedState; //  first element in selection (<select miltiple>), :CURRENT is the current
    property synthetic : boolean index STATE_SYNTHETIC read getNamedState write setNamedState; // synthesized DOM elements - don't emit it's head/tail, e.g. all missed cells in tables (<td>) are getting this flag
    property owns_popup : boolean index STATE_OWNS_POPUP read getNamedState write setNamedState; // anchor(owner) element of visible popup.
    property tab_focus : boolean index STATE_TABFOCUS read getNamedState write setNamedState; // element got focus by tab traversal. engine set it together with :focus.
    property empty : boolean index STATE_EMPTY read getNamedState write setNamedState; // element is empty.
    property busy : boolean index STATE_BUSY read getNamedState write setNamedState; // element is busy; loading. HTMLayoutRequestElementData will set this flag if external data was requested for the element. When data will be delivered engine will reset this flag on the element.
    property drag_over : boolean index STATE_DRAG_OVER read getNamedState write setNamedState; // drag over the block that can accept it (so is current drop target). Flag is set for the drop target block. At any given moment of time it can be only one such block.
    property drop_target : boolean index STATE_DROP_TARGET read getNamedState write setNamedState; // active drop target. Multiple elements can have this flag when D&D is active.
    property moving : boolean index STATE_MOVING read getNamedState write setNamedState; // dragging/moving - the flag is set for the moving element (copy of the drag-source).
    property copying : boolean index STATE_COPYING read getNamedState write setNamedState; // dragging/copying - the flag is set for the copying element (copy of the drag-source).
    property drag_source : boolean index STATE_DRAG_SOURCE read getNamedState write setNamedState; // is set in element that is being dragged (element that is a drag source)
    property drop_marker : boolean index STATE_DROP_MARKER read getNamedState write setNamedState; // element is drop marker
    property pressed : boolean index STATE_PRESSED read getNamedState write setNamedState; // pressed - close to active but has wider life span - e.g. in MOUSE_UP it is still on, so behavior can check it in MOUSE_UP to discover CLICK condition.
    property popup : boolean index STATE_POPUP read getNamedState write setNamedState; // this element is in popup state and presented to the user - out of flow now
    property ltr : boolean index STATE_IS_LTR read getNamedState write setNamedState; // the element or one of its nearest container has @dir and that dir has "ltr" value
    property rtl : boolean index STATE_IS_RTL read getNamedState write setNamedState; // the element or one of its nearest container has @dir and that dir has "rtl" value.

    end;

{------------------------------- THtmlElement ---------------------------------}

    THtmlElement = class;
    CHtmlElement = class of THtmlElement;

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
    * TElementHolder
    ***************************************************************************}
    TElementHolder = class
protected
    FhitCount                   : integer;
    Fhandler                    : HELEMENT;
    Felement                    : THtmlElement;
    FelementClass               : CHtmlElement;
    
protected
    function    getElement() : THtmlElement;

public
    constructor Create( aElementClass : CHtmlElement; aHandler : HELEMENT );
    destructor  Destroy(); override;

    end;

    {***************************************************************************
    * TElementHolders
    ***************************************************************************}
    TElementHolders = class( TObjectList )
protected
    FelementClass               : CHtmlElement;

public
    destructor  Destroy(); override;

    procedure   AfterConstruction(); override;

protected
    function    addElement( aHandler : HELEMENT ) : THtmlElement;
    function    getIndex( aHandler : HELEMENT ) : integer;

    end;

    {***************************************************************************
    * THtmlElementList
    ***************************************************************************}
    THtmlElementList = class( TObjectList )
protected
    Fowner                      : THtmlElement;
    FautoFreeMemory             : boolean;

private
    function    getElementByIndex( aIndex : integer ) : THtmlElement;
    function    addElement( he : HELEMENT ) : integer;

protected // events setters and handlers
    procedure   attachInitialization( aCmd : integer; aEventHandler : HTMLElementInitializationEventHandler );
    procedure   attachMouse( aCmd : integer; aEventHandler : HTMLElementMouseEventHandler );
    procedure   attachKey( aCmd : integer; aEventHandler : HTMLElementKeyEventHandler );
    procedure   attachFocus( aCmd : integer; aEventHandler : HTMLElementFocusEventHandler );
    procedure   attachScroll( aCmd : integer; aEventHandler : HTMLElementScrollEventHandler );
    procedure   attachTimer( aEventHandler : HTMLElementTimerEventHandler );
    procedure   attachSize( aEventHandler : HTMLElementSizeEventHandler );
    procedure   attachDraw( aCmd : integer; aEventHandler : HTMLElementDrawEventHandler );
    procedure   attachDataArrived( aEventHandler : HTMLElementDataArrivedEventHandler );
    procedure   attachExchange( aCmd : integer; aEventHandler : HTMLElementExchangeEventHandler );
    procedure   attachGesture( aCmd : integer; aEventHandler : HTMLElementGestureEventHandler );
    procedure   attachBehavior( aCmd : integer; aEventHandler : HTMLElementBehaviorEventHandler );

public
    procedure   AfterConstruction(); override;

public // property
    property elements[ aIndex : integer ] : THtmlElement read getElementByIndex; default;

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
    property onClick : HTMLElementMouseEventHandler index MOUSE_CLICK write attachMouse;
    property onMouseDClick : HTMLElementMouseEventHandler index MOUSE_DCLICK write attachMouse;
    property onDblClick : HTMLElementMouseEventHandler index MOUSE_DCLICK write attachMouse;
    property onMouseWheel : HTMLElementMouseEventHandler index MOUSE_WHEEL write attachMouse;
    property onWheel : HTMLElementMouseEventHandler index MOUSE_WHEEL write attachMouse;
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
    property onGestureRequest : HTMLElementGestureEventHandler index GESTURE_REQUEST write attachGesture;
    property onGestureZoom : HTMLElementGestureEventHandler index GESTURE_ZOOM write attachGesture;
    property onGesturePan : HTMLElementGestureEventHandler index GESTURE_PAN write attachGesture;
    property onGestureRotate : HTMLElementGestureEventHandler index GESTURE_ROTATE write attachGesture;
    property onGestureTap1 : HTMLElementGestureEventHandler index GESTURE_TAP1 write attachGesture;
    property onGestureTap2 : HTMLElementGestureEventHandler index GESTURE_TAP2 write attachGesture;

    // BEHAVIOR_EVENT
    property onButtonClick : HTMLElementBehaviorEventHandler index BUTTON_CLICK write attachBehavior;
    property onButtonPress : HTMLElementBehaviorEventHandler index BUTTON_PRESS write attachBehavior;
    property onButtonStateChanged : HTMLElementBehaviorEventHandler index BUTTON_STATE_CHANGED write attachBehavior;
    property onEditValueChanging : HTMLElementBehaviorEventHandler index EDIT_VALUE_CHANGING write attachBehavior;
    property onEditValueChanged : HTMLElementBehaviorEventHandler index EDIT_VALUE_CHANGED write attachBehavior;
    property onSelectSelectionChanged : HTMLElementBehaviorEventHandler index SELECT_SELECTION_CHANGED write attachBehavior;
    property onSelectStateChanged : HTMLElementBehaviorEventHandler index SELECT_STATE_CHANGED write attachBehavior;
    property onPopupRequest : HTMLElementBehaviorEventHandler index POPUP_REQUEST write attachBehavior;
    property onPopupReady : HTMLElementBehaviorEventHandler index POPUP_READY write attachBehavior;
    property onPopupDismissed : HTMLElementBehaviorEventHandler index POPUP_DISMISSED write attachBehavior;
    property onMenuItemActive : HTMLElementBehaviorEventHandler index MENU_ITEM_ACTIVE write attachBehavior;
    property onMenuItemClick : HTMLElementBehaviorEventHandler index MENU_ITEM_CLICK write attachBehavior;
    property onContextMenuSetup : HTMLElementBehaviorEventHandler index CONTEXT_MENU_SETUP write attachBehavior;
    property onContextMenuRequest : HTMLElementBehaviorEventHandler index CONTEXT_MENU_REQUEST write attachBehavior;
    property onVisiualStatusChanged : HTMLElementBehaviorEventHandler index VISIUAL_STATUS_CHANGED write attachBehavior;
    property onDisabledStatusChanged : HTMLElementBehaviorEventHandler index DISABLED_STATUS_CHANGED write attachBehavior;
    property onPopupDismissing : HTMLElementBehaviorEventHandler index POPUP_DISMISSING write attachBehavior;
    // "grey" event codes  - notfications from behaviors from this SDK
    property onHyperLinkClick : HTMLElementBehaviorEventHandler index HYPERLINK_CLICK write attachBehavior;
    property onTableHeaderClick : HTMLElementBehaviorEventHandler index TABLE_HEADER_CLICK write attachBehavior;
    property onTableRowClick : HTMLElementBehaviorEventHandler index TABLE_ROW_CLICK write attachBehavior;
    property onTableRowDblClick : HTMLElementBehaviorEventHandler index TABLE_ROW_DBL_CLICK write attachBehavior;
    property onElementCollapsed : HTMLElementBehaviorEventHandler index ELEMENT_COLLAPSED write attachBehavior;
    property onElementExpanded : HTMLElementBehaviorEventHandler index ELEMENT_EXPANDED write attachBehavior;
    property onActivateChild : HTMLElementBehaviorEventHandler index ACTIVATE_CHILD write attachBehavior;
    property onDoSwitchTab : HTMLElementBehaviorEventHandler index DO_SWITCH_TAB write attachBehavior;
    property onInitDataView : HTMLElementBehaviorEventHandler index INIT_DATA_VIEW write attachBehavior;
    property onRowsDataRequest : HTMLElementBehaviorEventHandler index ROWS_DATA_REQUEST write attachBehavior;
    property onUiStateChanged : HTMLElementBehaviorEventHandler index UI_STATE_CHANGED write attachBehavior;
    property onFormSubmit : HTMLElementBehaviorEventHandler index FORM_SUBMIT write attachBehavior;
    property onFormReset : HTMLElementBehaviorEventHandler index FORM_RESET write attachBehavior;
    property onDocumentComplete : HTMLElementBehaviorEventHandler index DOCUMENT_COMPLETE write attachBehavior;
    property onHistoryPush : HTMLElementBehaviorEventHandler index HISTORY_PUSH write attachBehavior;
    property onHistoryDrop : HTMLElementBehaviorEventHandler index HISTORY_DROP write attachBehavior;
    property onHistoryPrior : HTMLElementBehaviorEventHandler index HISTORY_PRIOR write attachBehavior;
    property onHistoryNext : HTMLElementBehaviorEventHandler index HISTORY_NEXT write attachBehavior;
    property onHistoryStateChanged : HTMLElementBehaviorEventHandler index HISTORY_STATE_CHANGED write attachBehavior;
    property onClosePopup : HTMLElementBehaviorEventHandler index CLOSE_POPUP write attachBehavior;
    property onRequestTooltip : HTMLElementBehaviorEventHandler index REQUEST_TOOLTIP write attachBehavior;
    property onAnimation : HTMLElementBehaviorEventHandler index ANIMATION write attachBehavior;

    end;

    {***************************************************************************
    * THtmlElement
    ***************************************************************************}
    THtmlElement = class( THtmlHElement )
private
    Froot                       : TElementHolder;
    Fparent                     : TElementHolder;
    FeventHandlers              : TEventHandlers;
    FownElements                : TElementHolders;

protected
    FelementClass               : CHtmlElement;

private
    function    getRoot() : THtmlElement;
    function    getParent() : THtmlElement;
    function    getChild( const aIndex : integer ) : THtmlElement;
    function    getEventHandlers() : TEventHandlers;
    function    getOwnElements() : TElementHolders;
    function    getElementsBySelector( const aSelector : string ) : THtmlElementList;

private // events setters and handlers
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
    procedure   attachBehavior( const aCmd : integer; const aEventHandler : HTMLElementBehaviorEventHandler );

protected
    procedure   freeResources(); override;

private // property
    property    eventHandlers : TEventHandlers read getEventHandlers;
    property    ownElements : TElementHolders read getOwnElements;

public
    constructor Create(); override;
    destructor  Destroy(); override;

    function    use() : THtmlElement;
    function    clone() : THtmlElement;
    function    get_element_by_id( const aId : string ) : THtmlElement;
    function    get_element_by_handler( const aHandler : HELEMENT ) : THtmlElement;
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

    procedure   attach( aEventParams : TEventHandlerParams; aEventHandler : HTMLayoutElementEventProc ); overload;
    procedure   detach( aEventParams : TEventHandlerParams; aEventHandler : HTMLayoutElementEventProc ); overload;

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
    // BEHAVIOR_EVENT
    function    attach( const aEventHandler : HTMLElementBehaviorEventHandler; const aCmd : integer = BEHAVIOR_ALL; aTag : Pointer = nil; aSubscription : UINT = HANDLE_BEHAVIOR_EVENT or DISABLE_INITIALIZATION ) : THtmlCmdEventParams; overload;
    procedure   detach( const aEventHandler : HTMLElementBehaviorEventHandler; const aCmd : integer = BEHAVIOR_ALL; aTag : Pointer = nil; aSubscription : UINT = HANDLE_BEHAVIOR_EVENT or DISABLE_INITIALIZATION ); overload;


public // property
    property root : THtmlElement read getRoot;
    property parent : THtmlElement read getParent;
    property child[ const aIndex : integer ] : THtmlElement read getChild;
    property nextSibling : THtmlElement read next_sibling;
    property prevSibling : THtmlElement read prev_sibling;
    property firstSibling : THtmlElement read first_sibling;
    property lastSibling : THtmlElement read last_sibling;
    property elements[ const aSelector : string ] : THtmlElementList read getElementsBySelector;

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
    property onClick : HTMLElementMouseEventHandler index MOUSE_CLICK write attachMouse;
    property onMouseDClick : HTMLElementMouseEventHandler index MOUSE_DCLICK write attachMouse;
    property onDblClick : HTMLElementMouseEventHandler index MOUSE_DCLICK write attachMouse;
    property onMouseWheel : HTMLElementMouseEventHandler index MOUSE_WHEEL write attachMouse;
    property onWheel : HTMLElementMouseEventHandler index MOUSE_WHEEL write attachMouse;
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

    // BEHAVIOR_EVENT
    property onButtonClick : HTMLElementBehaviorEventHandler index BUTTON_CLICK write attachBehavior;
    property onButtonPress : HTMLElementBehaviorEventHandler index BUTTON_PRESS write attachBehavior;
    property onButtonStateChanged : HTMLElementBehaviorEventHandler index BUTTON_STATE_CHANGED write attachBehavior;
    property onEditValueChanging : HTMLElementBehaviorEventHandler index EDIT_VALUE_CHANGING write attachBehavior;
    property onEditValueChanged : HTMLElementBehaviorEventHandler index EDIT_VALUE_CHANGED write attachBehavior;
    property onSelectSelectionChanged : HTMLElementBehaviorEventHandler index SELECT_SELECTION_CHANGED write attachBehavior;
    property onSelectStateChanged : HTMLElementBehaviorEventHandler index SELECT_STATE_CHANGED write attachBehavior;
    property onPopupRequest : HTMLElementBehaviorEventHandler index POPUP_REQUEST write attachBehavior;
    property onPopupReady : HTMLElementBehaviorEventHandler index POPUP_READY write attachBehavior;
    property onPopupDismissed : HTMLElementBehaviorEventHandler index POPUP_DISMISSED write attachBehavior;
    property onMenuItemActive : HTMLElementBehaviorEventHandler index MENU_ITEM_ACTIVE write attachBehavior;
    property onMenuItemClick : HTMLElementBehaviorEventHandler index MENU_ITEM_CLICK write attachBehavior;
    property onContextMenuSetup : HTMLElementBehaviorEventHandler index CONTEXT_MENU_SETUP write attachBehavior;
    property onContextMenuRequest : HTMLElementBehaviorEventHandler index CONTEXT_MENU_REQUEST write attachBehavior;
    property onVisiualStatusChanged : HTMLElementBehaviorEventHandler index VISIUAL_STATUS_CHANGED write attachBehavior;
    property onDisabledStatusChanged : HTMLElementBehaviorEventHandler index DISABLED_STATUS_CHANGED write attachBehavior;
    property onPopupDismissing : HTMLElementBehaviorEventHandler index POPUP_DISMISSING write attachBehavior;
    // "grey" event codes  - notfications from behaviors from this SDK
    property onHyperLinkClick : HTMLElementBehaviorEventHandler index HYPERLINK_CLICK write attachBehavior;
    property onTableHeaderClick : HTMLElementBehaviorEventHandler index TABLE_HEADER_CLICK write attachBehavior;
    property onTableRowClick : HTMLElementBehaviorEventHandler index TABLE_ROW_CLICK write attachBehavior;
    property onTableRowDblClick : HTMLElementBehaviorEventHandler index TABLE_ROW_DBL_CLICK write attachBehavior;
    property onElementCollapsed : HTMLElementBehaviorEventHandler index ELEMENT_COLLAPSED write attachBehavior;
    property onElementExpanded : HTMLElementBehaviorEventHandler index ELEMENT_EXPANDED write attachBehavior;
    property onActivateChild : HTMLElementBehaviorEventHandler index ACTIVATE_CHILD write attachBehavior;
    property onDoSwitchTab : HTMLElementBehaviorEventHandler index DO_SWITCH_TAB write attachBehavior;
    property onInitDataView : HTMLElementBehaviorEventHandler index INIT_DATA_VIEW write attachBehavior;
    property onRowsDataRequest : HTMLElementBehaviorEventHandler index ROWS_DATA_REQUEST write attachBehavior;
    property onUiStateChanged : HTMLElementBehaviorEventHandler index UI_STATE_CHANGED write attachBehavior;
    property onFormSubmit : HTMLElementBehaviorEventHandler index FORM_SUBMIT write attachBehavior;
    property onFormReset : HTMLElementBehaviorEventHandler index FORM_RESET write attachBehavior;
    property onDocumentComplete : HTMLElementBehaviorEventHandler index DOCUMENT_COMPLETE write attachBehavior;
    property onHistoryPush : HTMLElementBehaviorEventHandler index HISTORY_PUSH write attachBehavior;
    property onHistoryDrop : HTMLElementBehaviorEventHandler index HISTORY_DROP write attachBehavior;
    property onHistoryPrior : HTMLElementBehaviorEventHandler index HISTORY_PRIOR write attachBehavior;
    property onHistoryNext : HTMLElementBehaviorEventHandler index HISTORY_NEXT write attachBehavior;
    property onHistoryStateChanged : HTMLElementBehaviorEventHandler index HISTORY_STATE_CHANGED write attachBehavior;
    property onClosePopup : HTMLElementBehaviorEventHandler index CLOSE_POPUP write attachBehavior;
    property onRequestTooltip : HTMLElementBehaviorEventHandler index REQUEST_TOOLTIP write attachBehavior;
    property onAnimation : HTMLElementBehaviorEventHandler index ANIMATION write attachBehavior;

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

class function  get( aHandler : HELEMENT ) : THtmlShim; overload;
class function  get( aElement : THtmlElement ) : THtmlShim; overload;
class function  get( aHwnd : HWND ) : THtmlShim; overload;
class function  getId( aHandler : HELEMENT ) : widestring;

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

//type
//    PROnSelectCallback = record
//    elemen
//    end;

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
    Funused  := false;
    Fhandler := nil;
    Fvalue   := nil;

    _AddRef();
end;

{*******************************************************************************
* Create
*******************************************************************************}
constructor THtmlHElement.Create( const aHandler : HELEMENT );
begin
    Create();
    Fhandler := aHandler;

    internalUse();
end;

{*******************************************************************************
* Create
*******************************************************************************}
constructor THtmlHElement.Create( const aHElement : THtmlHElement );
begin
    assert( aHElement.is_valid() );
    Create( aHElement.handler );
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
    assert( Funused, 'You have to call unuse to free the object! Do not call Free or FreeAndNil' );
    
    freeResources();
    internalUnuse();
    inherited;
end;

{*******************************************************************************
* internalUse
*******************************************************************************}
function THtmlHElement.internalUse() : boolean;
begin
    assert( Fhandler <> nil );
    FlastError := HTMLayout_UseElement( Fhandler );
    Result := ( FlastError = HLDOM_OK );
    assert( Result );
end;

{*******************************************************************************
* internalUnuse
*******************************************************************************}
function THtmlHElement.internalUnuse() : boolean;
begin
    Result := ( Fhandler = nil );
    if ( Result ) then
        exit;

    FlastError := HTMLayout_UnuseElement( Fhandler );
    Result := ( FlastError = HLDOM_OK );
    if ( not Result ) or ( not is_valid() ) then
    begin
        Fhandler := nil;
    end;
end;

{*******************************************************************************
* freeResources
*******************************************************************************}
procedure THtmlHElement.freeResources();
begin
    FreeAndNil( Fvalue );
end;

{*******************************************************************************
* unuse
*******************************************************************************}
function THtmlHElement.unuse() : boolean;
begin
    Result := internalUnuse();

    Funused := true;
    _Release();
end;

{*******************************************************************************
* use
*******************************************************************************}
function THtmlHElement.use() : boolean;
begin
    Result := internalUse();
    if ( not Result ) then
        exit;

    _AddRef();
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
    Result := ( Fhandler <> nil ) and is_valid( Fhandler );
end;

{*******************************************************************************
* is_valid
*******************************************************************************}
function THtmlHElement.is_valid( const aHandler : HELEMENT ) : boolean;
begin
    Result := false;
    try
        getElementUid( aHandler );
        Result := ( FlastError = HLDOM_OK );
    except
    end
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

    // filtering out non digits at the end of string value
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
* setStyleAsInt
*******************************************************************************}
procedure THtmlHElement.setStyleAsInt( const aAttrIndex : integer; const aValue : integer );
begin
    style[ HTMLStyleAttributes[ EHTMLStyleAttributes( aAttrIndex ) ] ] := IntToStr( aValue );
end;

{*******************************************************************************
* getStyleAsInt
*******************************************************************************}
function THtmlHElement.getStyleAsInt( const aAttrIndex : integer ) : integer;
begin
    Result := StyleStrToInt( style[ HTMLStyleAttributes[ EHTMLStyleAttributes( aAttrIndex ) ] ] );
end;

{*******************************************************************************
* setStyleAsString
*******************************************************************************}
procedure THtmlHElement.setStyleAsString( const aAttrIndex : integer; const aValue : string );
begin
    style[ HTMLStyleAttributes[ EHTMLStyleAttributes( aAttrIndex ) ] ] := aValue;
end;

{*******************************************************************************
* getStyleAsString
*******************************************************************************}
function THtmlHElement.getStyleAsString( const aAttrIndex : integer ) : string;
begin
    Result := style[ HTMLStyleAttributes[ EHTMLStyleAttributes( aAttrIndex ) ] ];
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
* select
*******************************************************************************}
function HtmlHElementSelect( he : HELEMENT; aParams : POINTER ) : BOOL; stdcall;
begin
    Result := PRSelectHandler( aParams ).callback( he, PRSelectHandler( aParams ).params );
end;

procedure THtmlHElement.select( aCallback : HTMLayoutHElementCallback; const aParams : POINTER = nil; const aTag : string = ''; const aAttrName : string = ''; const aAttrValue : widestring = ''; aDepth : integer = 0 );
var
    h : RSelectHandler;
begin
    h.callback := aCallback;
    h.params   := aParams;
    select( HtmlHElementSelect, @h, aTag, aAttrName, aAttrValue, aDepth );
end;

{*******************************************************************************
* select
*******************************************************************************}
procedure THtmlHElement.select( aCallback : HTMLayoutElementCallback; const aSelector : string; const aParams : POINTER = nil );
begin
    assert( is_valid() );
    FlastError := HTMLayoutSelectElements( Fhandler, LPCSTR( aSelector ), aCallback, aParams );
    assert( FlastError = HLDOM_OK );
end;

{*******************************************************************************
* HtmlHElementSelectFirst
*******************************************************************************}
function HtmlHElementSelectFirst( he : HELEMENT; aParams : POINTER ) : BOOL; stdcall;
begin
    Result  := true;
    PHELEMENT( aParams )^ := he;
end;

procedure THtmlHElement.select( const aSelector : string; var aResult : HELEMENT );
var
    el : HELEMENT;
begin
    el := nil;
    select( HtmlHElementSelectFirst, aSelector, @el );
    aResult := el;
end;

{*******************************************************************************
* select
*******************************************************************************}
procedure THtmlHElement.select( aCallback : HTMLayoutHElementCallback; const aSelector : string; const aParams : POINTER = nil );
var
    h : RSelectHandler;
begin
    h.callback := aCallback;
    h.params   := aParams;
    select( HtmlHElementSelect, aSelector, @h );
end;

{*******************************************************************************
* redraw
*******************************************************************************}
procedure THtmlHElement.redraw();
begin
    update( RESET_STYLE_DEEP or MEASURE_DEEP or REDRAW_NOW );
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
* setHandler
*******************************************************************************}
procedure THtmlHElement.setHandler( const aHandler : HELEMENT );
begin
    internalSetHandler( aHandler );
end;

{*******************************************************************************
* internalSetHandler
*******************************************************************************}
procedure THtmlHElement.internalSetHandler( const aHandler : HELEMENT );
begin
    freeResources();

    internalUnuse();
    Fhandler := aHandler;
    if ( Fhandler = nil ) then
        exit;
        
    internalUse();
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
    //Result := get_location( CONTENT_BOX );
    Result := get_location( BORDER_BOX );
end;

{*******************************************************************************
* get_location
*******************************************************************************}
function THtmlHElement.get_location( const aArea : HTMLAYOUT_ELEMENT_AREAS = ROOT_RELATIVE ) : TRect;
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
* get_value
*******************************************************************************}
function THtmlHElement.get_value() : RHtmlValue;
begin
    // ATTENTION:
    // ATTENTION:
    // ATTENTION: ValueClear(pVal); must be called at some point HTMLayoutControlGetValue use.
    // ATTENTION:
    // ATTENTION:

    assert( is_valid() );
    FlastError := HTMLayoutControlGetValue( Fhandler, @Result );
    assert( FlastError = HLDOM_OK );
    if ( FlastError <> HLDOM_OK ) then
        exit;
end;

{*******************************************************************************
* set_value
*******************************************************************************}
procedure THtmlHElement.set_value( var aValue : RHtmlValue );
begin
    assert( is_valid() );
    FlastError := HTMLayoutControlSetValue( Fhandler, @aValue );
    assert( FlastError = HLDOM_OK );
    if ( FlastError <> HLDOM_OK ) then
        exit;

end;

{*******************************************************************************
* getValue
*******************************************************************************}
function THtmlHElement.getValue() : THtmlValue;
begin
    if ( Fvalue = nil ) then
    begin
        Fvalue := THtmlValue.create( Fhandler );
    end;
    
    Fvalue.handler := Fhandler;
    Result := Fvalue;
end;

//function  HTMLayoutControlGetValue( he : HELEMENT; var pVal : HtmlVALUE ) : HLDOM_RESULT; stdcall;
//function  HTMLayoutControlSetValue( he : HELEMENT; const pVal : PHtmlVALUE ) : HLDOM_RESULT; stdcall;


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
    FlastError := HTMLayoutCombineURL( Fhandler, LPWSTR( Result ), Length( Result ) );
    assert( FlastError = HLDOM_OK );
end;

{*******************************************************************************
* set_html
*******************************************************************************}
procedure THtmlHElement.set_html( const html : string; where : HTMLayoutSetHTMLWhere = SIH_REPLACE_CONTENT );
begin
    assert( is_valid() );
    if (  Length( html ) <> 0 ) then
        FlastError := HTMLayoutSetElementHtml( Fhandler, PBYTE( html ), Length( html ), UINT( where ) )
    else
        clear();

    assert( FlastError = HLDOM_OK );
end;

{*******************************************************************************
* clear
*******************************************************************************}
procedure THtmlHElement.clear();
begin
    innerText16 := '';
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
procedure THtmlHElement.setStates( aBits : cardinal );
begin
    assert( is_valid() );
    FlastError := HTMLayoutSetElementState( Fhandler, aBits, not aBits, true );
    assert( FlastError = HLDOM_OK );
end;

{*******************************************************************************
* get_state
*******************************************************************************}
function THtmlHElement.get_state( bits : cardinal ) : boolean;
begin
    Result := ( states and bits = bits ) and ( FlastError = HLDOM_OK );
end;

{*******************************************************************************
* set_state
*******************************************************************************}
procedure THtmlHElement.set_state( bitsToSet : cardinal; bitsToClear : cardinal = 0; update : boolean = true );
begin
    assert( is_valid() );
    FlastError := HTMLayoutSetElementState( Fhandler, bitsToSet, bitsToClear, update );
    assert( FlastError = HLDOM_OK );
end;

{*******************************************************************************
* getState
*******************************************************************************}
function THtmlHElement.getState( aBit : cardinal ) : boolean;
begin
    Result := ( states and aBit = aBit ) and ( FlastError = HLDOM_OK );
end;

{*******************************************************************************
* setState
*******************************************************************************}
procedure THtmlHElement.setState( aBit : cardinal; aState : boolean );
begin
    if ( aState ) then
        set_state( aBit, 0, true )
    else
        set_state( 0, aBit, true );
end;

{*******************************************************************************
* getNamedState
*******************************************************************************}
function THtmlHElement.getNamedState( aBit : integer ) : boolean;
begin
    Result := state[ cardinal( aBit ) ];
end;

{*******************************************************************************
* setState
*******************************************************************************}
procedure THtmlHElement.setNamedState( aBit : integer; aState : boolean );
begin
    state[ cardinal( aBit ) ] := aState;
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
function THtmlHElement.send_event( event_code : cardinal; reason : cardinal = 0; heSource : HELEMENT = nil ) : boolean;
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
procedure THtmlHElement.post_event( event_code : cardinal; reason : cardinal = 0; heSource : HELEMENT = nil );
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
procedure THtmlHElement.attach( pevth : HTMLayoutElementEventProc; tag : Pointer = nil; subscription : UINT = HANDLE_ALL );
begin
    assert( is_valid() );
    FlastError := HTMLayoutAttachEventHandlerEx( Fhandler, pevth, tag, subscription );
    assert( FlastError = HLDOM_OK );
end;

{*******************************************************************************
* detach
*******************************************************************************}
procedure THtmlHElement.detach( pevth : HTMLayoutElementEventProc; tag : Pointer = nil; subscription : UINT = HANDLE_ALL );
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
    FlastError := HTMLayoutMoveElementEx( Fhandler, x_view_rel, y_view_rel, pxWidth, pxHeight );
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

{*******************************************************************************
* render
*******************************************************************************}
function THtmlHElement.render( aBitmap : TBitmap ) : boolean;
var
    rectSelf : TRect;
begin
//    rectSelf := get_location( HTMLAYOUT_ELEMENT_AREAS( integer( MARGIN_BOX ) or integer( ROOT_RELATIVE ) ) );
    rectSelf := get_location( BORDER_BOX );
    aBitmap.Width  := rectSelf.Right - rectSelf.Left;
    aBitmap.Height := rectSelf.Bottom - rectSelf.Top;

    rectSelf.Left   := 0;
    rectSelf.Top    := 0;
    rectSelf.Right  := aBitmap.Width;
    rectSelf.Bottom := aBitmap.Height;

    Result := render( aBitmap.Canvas.Handle, rectSelf );
end;

{*******************************************************************************
* render
*******************************************************************************}
function THtmlHElement.render( aHBmp : HBITMAP; aDstRect : TRECT ) : boolean;
var
    bmpRoot  : TBitmap;
    rectRoot : TRect;
    rectSelf : TRect;
    hwndRoot : HWND;
    //s        : string;

begin
    hwndRoot := get_element_hwnd( true );
    Result := GetClientRect( hwndRoot, rectRoot );
    if ( not Result ) then
        exit;

    try
        // get the bitmap for the whole document
        bmpRoot := TBitmap.Create();
        bmpRoot.PixelFormat := pf24bit;
        bmpRoot.Width  := rectRoot.Right - rectRoot.Left;
        bmpRoot.Height := rectRoot.Bottom - rectRoot.Top;
        //rectSelf := get_location( HTMLAYOUT_ELEMENT_AREAS( integer( MARGIN_BOX ) or integer( ROOT_RELATIVE ) ) );
        rectSelf := get_location( BORDER_BOX );

        Result := HTMLayoutRender( hwndRoot, bmpRoot.Handle, rectRoot );
        //bmpRoot.SaveToFile( 'root.bmp' );

        // copy the bitmap area for the DOM element
        Result := BitBlt( aHBmp, aDstRect.Left, aDstRect.Top, aDstRect.Right - aDstRect.Left, aDstRect.Bottom - aDstRect.Top, bmpRoot.Canvas.Handle, rectSelf.Left, rectSelf.Top, SRCCOPY );
        {if ( not Result ) then
        begin
            s := GetLastOSErrorText();
            if ( s <> '' ) then if ( s <> '' ) then;
        end;}

        assert( Result );
    finally
        FreeAndNil( bmpRoot );
    end;
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

    Froot           := nil;
    Fparent         := nil;
    FownElements    := nil;
end;

{*******************************************************************************
* Destroy
*******************************************************************************}
destructor THtmlElement.Destroy();
begin
    //dettachElementProcEventHandler();
    inherited;
end;

{*******************************************************************************
* freeResources
*******************************************************************************}
procedure THtmlElement.freeResources();
begin
    FreeAndNil( Froot );
    FreeAndNil( Fparent );
    FreeAndNil( FownElements );
    FreeAndNil( FeventHandlers );
end;

{*******************************************************************************
* getRoot
*******************************************************************************}
function THtmlElement.getRoot() : THtmlElement;
begin
    if ( Froot = nil ) then
    begin
        Froot := TElementHolder.Create( FelementClass, getRootHandler() );
    end;

    Result := Froot.getElement();
end;

{*******************************************************************************
* getParent
*******************************************************************************}
function THtmlElement.getParent() : THtmlElement;
begin
    if ( Fparent = nil ) then
    begin
        Fparent := TElementHolder.Create( FelementClass, getParentHandler() );
    end;

    Result := Fparent.getElement();
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
    Result := ownElements.addElement( he );
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
* use
*******************************************************************************}
function THtmlElement.use() : THtmlElement;
begin
    Result := nil;
    if ( not inherited use() ) then
        exit;

    Result := self;
end;

{*******************************************************************************
* clone
*******************************************************************************}
function THtmlElement.clone() : THtmlElement;
begin
    Result := ownElements.addElement( cloneHandler() );
end;

{*******************************************************************************
* get_element_by_id
*******************************************************************************}
function THtmlElement.get_element_by_id( const aId : string ) : THtmlElement;
begin
    Result := ownElements.addElement( getHandlerById( aId ) );
end;

{*******************************************************************************
* get_element_by_handler
*******************************************************************************}
function THtmlElement.get_element_by_handler( const aHandler : HELEMENT ) : THtmlElement;
begin
    Result := ownElements.addElement( aHandler );
end;

{*******************************************************************************
* THtmlElement_OnSelectCallback
*******************************************************************************}
function THtmlElement_OnSelectCallback( he : HELEMENT; param : Pointer ) : BOOL; stdcall;
begin
    Result := false;
    THtmlElementList( param ).addElement( he );
end;

{*******************************************************************************
* getElementsBySelector
*******************************************************************************}
function THtmlElement.getElementsBySelector( const aSelector : string ) : THtmlElementList;
begin
    Result := THtmlElementList.Create();
    Result.Fowner := self;
    Result.FautoFreeMemory := true;

    inherited select( THtmlElement_OnSelectCallback, aSelector, Pointer( Result ) );
end;

{*******************************************************************************
* next_sibling
*******************************************************************************}
function THtmlElement.next_sibling() : THtmlElement;
begin
    Result := ownElements.addElement( getNextSiblingHandler() );
end;

{*******************************************************************************
* prev_sibling
*******************************************************************************}
function THtmlElement.prev_sibling() : THtmlElement;
begin
    Result := ownElements.addElement( getPrevSiblingHandler() );
end;

{*******************************************************************************
* first_sibling
*******************************************************************************}
function THtmlElement.first_sibling() : THtmlElement;
begin
    Result := ownElements.addElement( getFirstSiblingHandler() );
end;

{*******************************************************************************
* last_sibling
*******************************************************************************}
function THtmlElement.last_sibling() : THtmlElement;
begin
    Result := ownElements.addElement( getLastSiblingHandler() );
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
* getOwnElements
*******************************************************************************}
function THtmlElement.getOwnElements() : TElementHolders;
begin
    if ( FownElements = nil ) then
    begin
        FownElements := TElementHolders.Create( true );
        FownElements.FelementClass := FelementClass;
    end;

    Result := FownElements;
end;

{*******************************************************************************
* attach
*******************************************************************************}
procedure THtmlElement.attach( aEventParams : TEventHandlerParams; aEventHandler : HTMLayoutElementEventProc );
begin
    assert( is_valid() );
    FlastError := HTMLayoutAttachEventHandlerEx( Fhandler, aEventHandler, aEventParams, aEventParams.Fsubscription );
    assert( FlastError = HLDOM_OK );
end;

{*******************************************************************************
* detach
*******************************************************************************}
procedure THtmlElement.detach( aEventParams : TEventHandlerParams; aEventHandler : HTMLayoutElementEventProc );
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

{------------------------------ HANDLE_BEHAVIOR -------------------------------}

procedure THtmlElement.attachBehavior( const aCmd : integer; const aEventHandler : HTMLElementBehaviorEventHandler );
begin
    attach( aEventHandler, aCmd, nil );
end;

function THtmlElement.attach( const aEventHandler : HTMLElementBehaviorEventHandler; const aCmd : integer = BEHAVIOR_ALL; aTag : Pointer = nil; aSubscription : UINT = HANDLE_BEHAVIOR_EVENT or DISABLE_INITIALIZATION ) : THtmlCmdEventParams;
begin
    if ( aCmd = BEHAVIOR_ALL ) then
        Result := THtmlBehaviorEvent.Create( self, TMethod( aEventHandler ), aTag, aSubscription )
    else
        Result := THtmlBehaviorCmd.Create( self, aCmd, TMethod( aEventHandler ), aTag, aSubscription );

    attach( Result );
end;

procedure THtmlElement.detach( const aEventHandler : HTMLElementBehaviorEventHandler; const aCmd : integer = BEHAVIOR_ALL; aTag : Pointer = nil; aSubscription : UINT = HANDLE_BEHAVIOR_EVENT or DISABLE_INITIALIZATION );
begin
    detach( TMethod( aEventHandler ), aCmd, aTag, aSubscription );
end;

{------------------------------- THtmlShim ------------------------------------}

{*******************************************************************************
* get
*******************************************************************************}
class function THtmlShim.get( aHandler : HELEMENT ) : THtmlShim;
begin
    assert( GlobalShim <> nil );

    GlobalShim.handler := aHandler;
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
class function THtmlShim.get( aHwnd : HWND ) : THtmlShim;
var
    root : HELEMENT;
    res : HLDOM_RESULT;
begin
    res := HTMLayoutGetRootElement( aHwnd, root );
    assert( res = HLDOM_OK );

    Result := THtmlShim.get( root );
end;

{*******************************************************************************
* getId
*******************************************************************************}
class function THtmlShim.getId( aHandler : HELEMENT ) : widestring;
var
    shim : THtmlShim;
begin
    shim := get( aHandler );
    Result := shim.id;
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

{--------------------------- TElementHolder- ----------------------------------}

{*******************************************************************************
* TElementHolder
*******************************************************************************}
constructor TElementHolder.Create(  aElementClass : CHtmlElement; aHandler : HELEMENT );
begin
    FelementClass := aElementClass;

    Fhandler   := aHandler;
    FhitCount  := 0;
    Felement   := nil;
end;

{*******************************************************************************
* Destroy
*******************************************************************************}
destructor TElementHolder.Destroy();
begin
    if ( Felement <> nil ) then
    begin
        Felement.unuse();
    end;

    inherited;
end;

{*******************************************************************************
* getElement
*******************************************************************************}
function TElementHolder.getElement() : THtmlElement;
begin
    if ( Felement = nil ) then
    begin
        Felement := FelementClass.Create( Fhandler );
    end;

    Result := Felement;
    inc( FhitCount );
end;

{--------------------------- TElementHolders ----------------------------------}

{*******************************************************************************
* addElement
*******************************************************************************}
destructor TElementHolders.Destroy();
var
    i : integer;
begin
    for i := 0 to Count - 1 do
    begin
        assert( TElementHolder( Items[i] ).Felement <> nil );
        TElementHolder( Items[i] ).Felement.unuse();
    end;

    inherited;
end;

{*******************************************************************************
* AfterContruction
*******************************************************************************}
procedure TElementHolders.AfterConstruction();
begin
    inherited;

    OwnsObjects := false;
end;

{*******************************************************************************
* addElement
*******************************************************************************}
function TElementHolders.addElement( aHandler : HELEMENT ) : THtmlElement;
var
    i : integer;
    elHolder : TElementHolder;

begin
    i := getIndex( aHandler );
    if ( i >= 0 ) then
        elHolder := TElementHolder( Items[i] )
    else
    begin
        elHolder := TElementHolder.Create( FelementClass, aHandler );
        insert( 0, elHolder );
    end;

    Result := elHolder.getElement();

    if ( i > 0 ) and ( elHolder.FhitCount > TElementHolder( Items[0] ).FhitCount ) then
    begin
        Exchange( 0, i );
    end;
end;

{*******************************************************************************
* TElementHolders
*******************************************************************************}
function TElementHolders.getIndex( aHandler : HELEMENT ) : integer;
var
    i : integer;
begin
    Result := -1;

    for i := 0 to Count - 1 do
    begin
        if ( TElementHolder( Items[i] ).Fhandler <> aHandler ) then
            continue;

        Result := i;
        break;
    end;
end;

{-- THtmlElementList ----------------------------------------------------------}

{*******************************************************************************
* AfterContruction
*******************************************************************************}
procedure THtmlElementList.AfterConstruction();
begin
    inherited;
    OwnsObjects := false;
end;

{*******************************************************************************
* getElementByIndex
*******************************************************************************}
function THtmlElementList.getElementByIndex( aIndex : integer ) : THtmlElement;
begin
    Result := THtmlElement( inherited items[ aIndex ] );
end;

{*******************************************************************************
* addElement
*******************************************************************************}
function THtmlElementList.addElement( he : HELEMENT ) : integer;
begin
    assert( Fowner <> nil );
    Result := add( Fowner.get_element_by_handler( he ) );
end;

{*******************************************************************************
* attachInitialization
*******************************************************************************}
procedure THtmlElementList.attachInitialization( aCmd : integer; aEventHandler : HTMLElementInitializationEventHandler );
var
    i : integer;

begin
    for i := 0 to count - 1 do
    begin
        elements[i].attachInitialization( aCmd, aEventHandler );
    end;

    if ( not FautoFreeMemory ) then
        exit;

    Free();
end;

{*******************************************************************************
* attachMouse
*******************************************************************************}
procedure THtmlElementList.attachMouse( aCmd : integer; aEventHandler : HTMLElementMouseEventHandler );
var
    i : integer;

begin
    for i := 0 to count - 1 do
    begin
        elements[i].attachMouse( aCmd, aEventHandler );
    end;

    if ( not FautoFreeMemory ) then
        exit;

    Free();
end;

{*******************************************************************************
* attachKey
*******************************************************************************}
procedure THtmlElementList.attachKey( aCmd : integer; aEventHandler : HTMLElementKeyEventHandler );
var
    i : integer;

begin
    for i := 0 to count - 1 do
    begin
        elements[i].attachKey( aCmd, aEventHandler );
    end;

    if ( not FautoFreeMemory ) then
        exit;

    Free();
end;

{*******************************************************************************
* attachFocus
*******************************************************************************}
procedure THtmlElementList.attachFocus( aCmd : integer; aEventHandler : HTMLElementFocusEventHandler );
var
    i : integer;

begin
    for i := 0 to count - 1 do
    begin
        elements[i].attachFocus( aCmd, aEventHandler );
    end;

    if ( not FautoFreeMemory ) then
        exit;

    Free();
end;

{*******************************************************************************
* attachScroll
*******************************************************************************}
procedure THtmlElementList.attachScroll( aCmd : integer; aEventHandler : HTMLElementScrollEventHandler );
var
    i : integer;

begin
    for i := 0 to count - 1 do
    begin
        elements[i].attachScroll( aCmd, aEventHandler );
    end;

    if ( not FautoFreeMemory ) then
        exit;

    Free();
end;

{*******************************************************************************
* attachDraw
*******************************************************************************}
procedure THtmlElementList.attachDraw( aCmd : integer; aEventHandler : HTMLElementDrawEventHandler );
var
    i : integer;

begin
    for i := 0 to count - 1 do
    begin
        elements[i].attachDraw( aCmd, aEventHandler );
    end;

    if ( not FautoFreeMemory ) then
        exit;

    Free();
end;

{*******************************************************************************
* attachTimer
*******************************************************************************}
procedure THtmlElementList.attachTimer( aEventHandler : HTMLElementTimerEventHandler );
var
    i : integer;

begin
    for i := 0 to count - 1 do
    begin
        elements[i].attachTimer( aEventHandler );
    end;

    if ( not FautoFreeMemory ) then
        exit;

    Free();
end;

{*******************************************************************************
* attachSize
*******************************************************************************}
procedure THtmlElementList.attachSize( aEventHandler : HTMLElementSizeEventHandler );
var
    i : integer;

begin
    for i := 0 to count - 1 do
    begin
        elements[i].attachSize( aEventHandler );
    end;

    if ( not FautoFreeMemory ) then
        exit;

    Free();
end;

{*******************************************************************************
* attachDataArrived
*******************************************************************************}
procedure THtmlElementList.attachDataArrived( aEventHandler : HTMLElementDataArrivedEventHandler );
var
    i : integer;

begin
    for i := 0 to count - 1 do
    begin
        elements[i].attachDataArrived( aEventHandler );
    end;

    if ( not FautoFreeMemory ) then
        exit;

    Free();
end;

{*******************************************************************************
* attachExchange
*******************************************************************************}
procedure THtmlElementList.attachExchange( aCmd : integer; aEventHandler : HTMLElementExchangeEventHandler );
var
    i : integer;

begin
    for i := 0 to count - 1 do
    begin
        elements[i].attachExchange( aCmd, aEventHandler );
    end;

    if ( not FautoFreeMemory ) then
        exit;

    Free();
end;

{*******************************************************************************
* attachGesture
*******************************************************************************}
procedure THtmlElementList.attachGesture( aCmd : integer; aEventHandler : HTMLElementGestureEventHandler );
var
    i : integer;

begin
    for i := 0 to count - 1 do
    begin
        elements[i].attachGesture( aCmd, aEventHandler );
    end;

    if ( not FautoFreeMemory ) then
        exit;

    Free();
end;

{*******************************************************************************
* attachBehavior
*******************************************************************************}
procedure THtmlElementList.attachBehavior( aCmd : integer; aEventHandler : HTMLElementBehaviorEventHandler );
var
    i : integer;

begin
    for i := 0 to count - 1 do
    begin
        elements[i].attachBehavior( aCmd, aEventHandler );
    end;

    if ( not FautoFreeMemory ) then
        exit;

    Free();
end;

INITIALIZATION
    GlobalShim := THtmlShim.Create();

FINALIZATION
    GlobalShim.unuse();

end.

