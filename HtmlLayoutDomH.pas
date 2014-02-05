unit HtmlLayoutDomH;

(*
  This file contains function declarations translated from include\htmlayout_dom.h of
  HTMLayout SDK http://www.terrainformatica.com/htmlayout/HTMLayoutSDK.zip

  HTMLayout License terms could be found here http://www.terrainformatica.com/htmlayout/prices.whtm
  Delphi binding of HTMLayout is free for commercial and non-commercial use, visit https://github.com/Keksov/HtmlayoutDelphi

  Most accurate documentation could be found in include\htmlayout_dom.h itself
*)

interface

uses Windows
    , HtmlTypes
    , HtmlBehaviour
    , HtmlValueH
    , HtmlLayoutH
;

const
    // enum UPDATE_ELEMENT_FLAGS
    RESET_STYLE_THIS            = $20;    // reset styles - this may require if you have styles dependent from attributes,
    RESET_STYLE_DEEP            = $10;    // use these flags after SetAttribute then. RESET_STYLE_THIS is faster than RESET_STYLE_DEEP.
    MEASURE_INPLACE             = $0001;  // use this flag if you do not expect any dimensional changes - this is faster than REMEASURE
    MEASURE_DEEP                = $0002;  // use this flag if changes of some attributes/content may cause change of dimensions of the element
    REDRAW_NOW                  = $8000;  // invoke ::UpdateWindow function after applying changes

    // ELEMENT_STATE_BITS
    STATE_LINK                  = $00000001;
    STATE_HOVER                 = $00000002;
    STATE_ACTIVE                = $00000004;
    STATE_FOCUS                 = $00000008;
    STATE_VISITED               = $00000010;
    STATE_CURRENT               = $00000020;  // current (hot) item
    STATE_CHECKED               = $00000040;  // element is checked (or selected)
    STATE_DISABLED              = $00000080;  // element is disabled
    STATE_READONLY              = $00000100;  // readonly input element
    STATE_EXPANDED              = $00000200;  // expanded state - nodes in tree view
    STATE_COLLAPSED             = $00000400;  // collapsed state - nodes in tree view - mutually exclusive with
    STATE_INCOMPLETE            = $00000800;  // one of fore/back images requested but not delivered
    STATE_ANIMATING             = $00001000;  // is animating currently
    STATE_FOCUSABLE             = $00002000;  // will accept focus
    STATE_ANCHOR                = $00004000;  // anchor in selection (used with current in selects)
    STATE_SYNTHETIC             = $00008000;  // this is a synthetic element - don't emit it's head/tail
    STATE_OWNS_POPUP            = $00010000;  // this is a synthetic element - don't emit it's head/tail
    STATE_TABFOCUS              = $00020000;  // focus gained by tab traversal
    STATE_EMPTY                 = $00040000;  // empty - element is empty (text.size() == 0 && subs.size() == 0)
                                              // if element has behavior attached then the behavior is responsible for the value of this flag.
    STATE_BUSY                  = $00080000;  // busy; loading

    STATE_DRAG_OVER             = $00100000;  // drag over the block that can accept it (so is current drop target). Flag is set for the drop target block
    STATE_DROP_TARGET           = $00200000;  // active drop target.
    STATE_MOVING                = $00400000;  // dragging/moving - the flag is set for the moving block.
    STATE_COPYING               = $00800000;  // dragging/copying - the flag is set for the copying block.
    STATE_DRAG_SOURCE           = $01000000;  // element that is a drag source.
    STATE_DROP_MARKER           = $02000000;  // element is drop marker

    STATE_PRESSED               = $04000000;  // pressed - close to active but has wider life span - e.g. in MOUSE_UP it
                                              // is still on; so behavior can check it in MOUSE_UP to discover CLICK condition.
    STATE_POPUP                 = $08000000;  // this element is out of flow - popup
    STATE_IS_LTR                = $10000000;  // the element or one of its containers has dir=ltr declared
    STATE_IS_RTL                = $20000000;  // the element or one of its containers has dir=rtl declared

type

    HLDOM_RESULT = (
        HLDOM_OK                = 0, // function completed successfully
        HLDOM_INVALID_HWND      = 1, // invalid HWND
        HLDOM_INVALID_HANDLE    = 2, // invalid HELEMENT
        HLDOM_PASSIVE_HANDLE    = 3, // attempt to use HELEMENT which is not marked by HTMLayout_UseElement()
        HLDOM_INVALID_PARAMETER = 4, // parameter is invalid, e.g. pointer is null
        HLDOM_OPERATION_FAILED  = 5, // operation failed, e.g. invalid html in HTMLayoutSetElementHtml()
        HLDOM_OK_NOT_HANDLED    = -1 // e.g. delayed
    );

    HTML_HPOSITION = record
        he                      : HELEMENT;
        pos                     : integer;
    end;
    PHTML_HPOSITION = ^HTML_HPOSITION;

    // enum ELEMENT_AREAS
    HTMLAYOUT_ELEMENT_AREAS = (
        CONTENT_BOX             = $00, // content (inner)  box
        ROOT_RELATIVE           = $01, // - or this flag if you want to get HTMLayout window relative coordinates,
                                       //   otherwise it will use nearest windowed container e.g. popup window.
        SELF_RELATIVE           = $02, // - "or" this flag if you want to get coordinates relative to the origin
                                       //   of element iself.
        CONTAINER_RELATIVE      = $03, // - position inside immediate container.
        VIEW_RELATIVE           = $04, // - position relative to view - HTMLayout window

        PADDING_BOX             = $10, // content + paddings
        BORDER_BOX              = $20, // content + paddings + border
        MARGIN_BOX              = $30, // content + paddings + border + margins

        BACK_IMAGE_AREA         = $40, // relative to content origin - location of background image (if it set no-repeat)
        FORE_IMAGE_AREA         = $50, // relative to content origin - location of foreground image (if it set no-repeat)

        SCROLLABLE_AREA         = $60  // scroll_area - scrollable area in content box
    );

    // enum HTMLAYOUT_SCROLL_FLAGS
    HTMLAYOUT_SCROLL_FLAGS = (
        SCROLL_TO_TOP           = $01,
        SCROLL_SMOOTH           = $10
    );


    HTMLayoutSetHTMLWhere = (
        SIH_REPLACE_CONTENT     = 0,
        SIH_INSERT_AT_START     = 1,
        SIH_APPEND_AFTER_LAST   = 2,
        SOH_REPLACE             = 3,
        SOH_INSERT_BEFORE       = 4,
        SOH_INSERT_AFTER        = 5
    );

    //enum REQUEST_TYPE
    REQUEST_TYPE = (
        GET_ASYNC                   = 0, // async GET
        POST_ASYNC                  = 1 // async POST
    );

    REQUEST_PARAM = record
        name                    : LPCWSTR;
        value                   : LPCWSTR;
    end;
    PREQUEST_PARAM = ^REQUEST_PARAM;

    // enum CTL_TYPE
    HTMLAYOUT_CTL_TYPE = (
        CTL_NO                  = 0, ///< This dom element has no behavior at all.
        CTL_UNKNOWN             = 1, ///< This dom element has behavior but its type is unknown.
        CTL_EDIT                = 2, ///< Single line edit box.
        CTL_NUMERIC             = 3, ///< Numeric input with optional spin buttons.
        CTL_BUTTON              = 4, ///< Command button.
        CTL_CHECKBOX            = 5, ///< CheckBox (button).
        CTL_RADIO               = 6, ///< OptionBox (button).
        CTL_SELECT_SINGLE       = 7, ///< Single select, ListBox or TreeView.
        CTL_SELECT_MULTIPLE     = 8, ///< Multiselectable select, ListBox or TreeView.
        CTL_DD_SELECT           = 9, ///< Dropdown single select.
        CTL_TEXTAREA            = 10, ///< Multiline TextBox.
        CTL_HTMLAREA            = 11, ///< WYSIWYG HTML editor.
        CTL_PASSWORD            = 12, ///< Password input element.
        CTL_PROGRESS            = 13, ///< Progress element.
        CTL_SLIDER              = 14, ///< Slider input element.
        CTL_DECIMAL             = 15, ///< Decimal number input element.
        CTL_CURRENCY            = 16, ///< Currency input element.
        CTL_SCROLLBAR           = 17,

        CTL_HYPERLINK           = 18,

        CTL_MENUBAR             = 19,
        CTL_MENU                = 20,
        CTL_MENUBUTTON          = 21,

        CTL_CALENDAR            = 22,
        CTL_DATE                = 23,
        CTL_TIME                = 24,

        CTL_FRAME               = 25,
        CTL_FRAMESET            = 26,

        CTL_GRAPHICS            = 27,
        CTL_SPRITE              = 28,

        CTL_LIST                = 29,
        CTL_RICHTEXT            = 30,
        CTL_TOOLTIP             = 31,

        CTL_HIDDEN              = 32,
        CTL_URL                 = 33, ///< URL input element.
        CTL_TOOLBAR             = 34,

        CTL_FORM                = 35
    );

    HTMLayoutCSSRuleDef = record
        rule_type               : integer; {**< 0 - css rule,
                                                1 - inline style attribute (selector is text of @style),
                                                2 - element has styles defined by HTMLayoutSetStyleAttribute *}
        file_url                : LPCSTR; // url of the file where this rule is defined
        file_line_no            : integer; // line number in the file of rule's selector, -1 if unknown
        selector                : LPCWSTR; // text of selector
    end;
    PHTMLayoutCSSRuleDef = ^HTMLayoutCSSRuleDef;

    PHTMLayoutElementExpando = ^HTMLayoutElementExpando;
    HTMLayoutExpandoRelease = procedure( pexp : PHTMLayoutElementExpando; he : HELEMENT );

    HTMLayoutElementExpando = record
        finalizer               : HTMLayoutExpandoRelease; // can be either NULL or valid pointer to function
    end;

    HTMLayoutWriterCallbackB     = procedure( utf8 : LPCSTR; utf8_length : UINT; param : Pointer ); stdcall;
    HTMLayoutWriterCallbackW     = procedure( text : LPCWSTR; text_length : UINT; param : Pointer ); stdcall;
    HTMLayoutElementComparator   = function( he1 : HELEMENT; he2 : HELEMENT; param : Pointer ) : integer; stdcall;
    HTMLayoutEnumerationCallback = function( p : Pointer; he : HELEMENT; pos : integer; postype : integer; code : WCHAR ) : BOOL stdcall;
    HTMLayoutStyleRuleCallback   = procedure( pdef : PHTMLayoutCSSRuleDef; callback_prm : Pointer ); stdcall;
    HTMLayoutElementAnimator     = function( he : HELEMENT; step : UINT; animatorParam : Pointer ) : UINT; stdcall;

// htmlayout_dom.h
function  HTMLayout_UseElement( he : HELEMENT ) : HLDOM_RESULT; stdcall;
function  HTMLayout_UnuseElement( he : HELEMENT ) : HLDOM_RESULT; stdcall;
function  HTMLayoutGetRootElement( hwnd : HWND; var phe : HELEMENT ) : HLDOM_RESULT; stdcall;
function  HTMLayoutGetFocusElement( hwnd : HWND; var phe : HELEMENT ) : HLDOM_RESULT; stdcall;
function  HTMLayoutFindElement( hwnd : HWND; pt : TPOINT; var phe : HELEMENT ) : HLDOM_RESULT; stdcall;
function  HTMLayoutGetChildrenCount( he : HELEMENT; var count : UINT ) : HLDOM_RESULT; stdcall;
function  HTMLayoutGetNthChild( he : HELEMENT; n : UINT; var phe : HELEMENT ) : HLDOM_RESULT; stdcall;
function  HTMLayoutGetParentElement( he : HELEMENT; var p_parent_he : HELEMENT ) : HLDOM_RESULT; stdcall;
function  HTMLayoutGetElementText( he : HELEMENT; characters: LPWSTR; var length : UINT) : HLDOM_RESULT; stdcall;
function  HTMLayoutGetElementHtml( he : HELEMENT; var utf8bytes : PCHAR; outer : BOOL ) : HLDOM_RESULT; stdcall;
function  HTMLayoutGetElementHtmlCB( he : HELEMENT; outer : BOOL; cb : HTMLayoutWriterCallbackB; cb_param : Pointer ) : HLDOM_RESULT; stdcall;
function  HTMLayoutGetElementInnerText( he : HELEMENT; var utf8bytes : PCHAR ) : HLDOM_RESULT; stdcall;
function  HTMLayoutSetElementInnerText( he : HELEMENT; utf8bytes : LPCSTR; length : UINT ) : HLDOM_RESULT; stdcall;
function  HTMLayoutGetElementInnerText16( he : HELEMENT; var utf16words : LPWSTR ) : HLDOM_RESULT; stdcall;
function  HTMLayoutGetElementInnerTextCB( he : HELEMENT; cd : HTMLayoutWriterCallbackW; cb_param : Pointer ) : HLDOM_RESULT; stdcall;
function  HTMLayoutSetElementInnerText16( he : HELEMENT; utf16words : LPCWSTR; length : UINT ) : HLDOM_RESULT; stdcall;
function  HTMLayoutGetAttributeCount( he : HELEMENT; var p_count : UINT ) : HLDOM_RESULT; stdcall;
function  HTMLayoutGetNthAttribute( he : HELEMENT; n : UINT; var p_name : LPCSTR; var p_value : LPCWSTR ) : HLDOM_RESULT; stdcall;
function  HTMLayoutGetAttributeByName( he : HELEMENT; name : LPCSTR; var p_value : LPCWSTR ) : HLDOM_RESULT; stdcall;
function  HTMLayoutSetAttributeByName( he : HELEMENT; name : LPCSTR; value : LPCWSTR ) : HLDOM_RESULT; stdcall;
function  HTMLayoutClearAttributes( he : HELEMENT ) : HLDOM_RESULT; stdcall;
function  HTMLayoutGetElementIndex( he : HELEMENT; var p_index : UINT ) : HLDOM_RESULT; stdcall;
function  HTMLayoutGetElementType( he : HELEMENT; var p_type : LPCSTR ) : HLDOM_RESULT; stdcall;
function  HTMLayoutGetStyleAttribute( he : HELEMENT; name : LPCSTR; var p_value : LPCWSTR ) : HLDOM_RESULT; stdcall;
function  HTMLayoutSetStyleAttribute( he : HELEMENT; name : LPCSTR; value : LPCWSTR ) : HLDOM_RESULT; stdcall;
function  HTMLayoutGetElementLocation( he : HELEMENT; var p_location : TRect; areas : UINT {HTMLAYOUT_ELEMENT_AREAS} ) : HLDOM_RESULT; stdcall;
function  HTMLayoutScrollToView( he : HELEMENT; flags : UINT {HTMLAYOUT_SCROLL_FLAGS} ) : HLDOM_RESULT; stdcall;
function  HTMLayoutUpdateElement( he : HELEMENT; renderNow : BOOL ) : HLDOM_RESULT; stdcall;
function  HTMLayoutUpdateElementEx( he : HELEMENT; flags : UINT {UPDATE_ELEMENT_FLAGS} ) : HLDOM_RESULT; stdcall;
function  HTMLayoutSetCapture( he : HELEMENT ) : HLDOM_RESULT; stdcall;
function  HTMLayoutSetEventRoot( he : HELEMENT; var phePrevRoot : HELEMENT ) : HLDOM_RESULT; stdcall;
function  HTMLayoutGetElementHwnd( he : HELEMENT; var p_hwnd : HWND; rootWindow : BOOL ) : HLDOM_RESULT; stdcall;
function  HTMLayoutCombineURL( he : HELEMENT; szUrlBuffer : LPWSTR; UrlBufferSize : DWORD ) : HLDOM_RESULT; stdcall;
function  HTMLayoutVisitElements( he : HELEMENT; tagName : LPCSTR; attributeName : LPCSTR; attributeValue : LPCWSTR; callback : HTMLayoutElementCallback; param : POINTER; depth : DWORD ) : HLDOM_RESULT; stdcall;
function  HTMLayoutSelectElements( he: HELEMENT; CSS_selectors : LPCSTR; cb: HTMLayoutElementCallback; param : Pointer) : HLDOM_RESULT; stdcall;
function  HTMLayoutSelectElementsW( he: HELEMENT; CSS_selectors : LPCWSTR; cb: HTMLayoutElementCallback; param : Pointer) : HLDOM_RESULT; stdcall;
function  HTMLayoutSelectParent( he : HELEMENT; selector : LPCSTR; depth : UINT; var heFound : HELEMENT ) : HLDOM_RESULT; stdcall;
function  HTMLayoutSelectParentW( he : HELEMENT; selector : LPCWSTR; depth : UINT; var heFound : HELEMENT ) : HLDOM_RESULT; stdcall;
function  HTMLayoutSetElementHtml( he : HELEMENT; html : PBYTE; htmlLength : DWORD; where : UINT ) : HLDOM_RESULT; stdcall;
function  HTMLayoutDeleteElement( he : HELEMENT ) : HLDOM_RESULT; stdcall;
function  HTMLayoutGetElementUID( he : HELEMENT; var puid : UINT ) : HLDOM_RESULT; stdcall;
function  HTMLayoutGetElementByUID( hwnd : HWND; uid : UINT; var phe : HELEMENT ) : HLDOM_RESULT; stdcall;
function  HTMLayoutShowPopup( hePopup : HELEMENT; heAnchor : HELEMENT; placement : UINT ) : HLDOM_RESULT; stdcall;
function  HTMLayoutShowPopupAt( hePopup : HELEMENT; pos : TPOINT; animate : BOOL ) : HLDOM_RESULT; stdcall;
function  HTMLayoutTrackPopupAt( hePopup : HELEMENT; pos : TPOINT; mode : UINT; var pheItem : HELEMENT ) : HLDOM_RESULT; stdcall;
function  HTMLayoutHidePopup( he : HELEMENT ) : HLDOM_RESULT; stdcall;
function  HTMLayoutGetElementState( he : HELEMENT; var pstateBits : UINT ) : HLDOM_RESULT; stdcall;
function  HTMLayoutSetElementState( he : HELEMENT; stateBitsToSet : UINT; stateBitsToClear : UINT; updateView : BOOL ) : HLDOM_RESULT; stdcall;
function  HTMLayoutCreateElement( tagname : LPCSTR; textOrNull : LPCWSTR; var phe : HELEMENT ) : HLDOM_RESULT; stdcall;
function  HTMLayoutCloneElement( he : HELEMENT; var phe : HELEMENT ) : HLDOM_RESULT; stdcall;
function  HTMLayoutInsertElement( he : HELEMENT; hparent: HELEMENT; index : UINT ) : HLDOM_RESULT; stdcall;
function  HTMLayoutDetachElement( he : HELEMENT ) : HLDOM_RESULT; stdcall;
function  HTMLayoutSetTimer( he : HELEMENT; milliseconds : UINT ) : HLDOM_RESULT; stdcall;
function  HTMLayoutSetTimerEx( he : HELEMENT; milliseconds : UINT; timerId : cardinal ) : HLDOM_RESULT; stdcall;
function  HTMLayoutAttachEventHandler( he : HELEMENT; pep: HTMLayoutElementEventProc; tag : Pointer ) : HLDOM_RESULT; stdcall;
function  HTMLayoutDetachEventHandler( he : HELEMENT; pep: HTMLayoutElementEventProc; tag : Pointer ) : HLDOM_RESULT; stdcall;
function  HTMLayoutAttachEventHandlerEx( he : HELEMENT; pep: HTMLayoutElementEventProc; tag : Pointer; subscription : UINT ) : HLDOM_RESULT; stdcall;
//function  HTMLayoutDetachEventHandlerEx( he : HELEMENT; pep: HTMLayoutElementEventProc; tag : Pointer; subscription : UINT ) : HLDOM_RESULT; stdcall;
function  HTMLayoutWindowAttachEventHandler( hwnd : HWND; pep: HTMLayoutElementEventProc; tag : Pointer; subscription : UINT ) : HLDOM_RESULT; stdcall;
function  HTMLayoutWindowDetachEventHandler( hwnd : HWND; pep: HTMLayoutElementEventProc; tag : Pointer ) : HLDOM_RESULT; stdcall;
function  HTMLayoutSendEvent( he : HELEMENT; appEventCode : UINT; heSource : HELEMENT; reason : UINT; var handled : BOOL ) : HLDOM_RESULT; stdcall;
function  HTMLayoutPostEvent( he : HELEMENT; appEventCode : UINT; heSource : HELEMENT; reason : UINT ) : HLDOM_RESULT; stdcall;
function  HTMLayoutCallBehaviorMethod( he : HELEMENT; params : POINTER) : HLDOM_RESULT; stdcall;
function  HTMLayoutRequestElementData( he : HELEMENT; url : LPCWSTR; dataType : UINT {HTMLayoutResourceType}; initiator : HELEMENT ) : HLDOM_RESULT; stdcall;
function  HTMLayoutHttpRequest( he : HELEMENT; url : LPCWSTR; dataType : UINT {HTMLayoutResourceType}; requestType : UINT {HTMLayoutRequestType}; requestParams : PREQUEST_PARAM; nParams : UINT ) : HLDOM_RESULT; stdcall;
function  HTMLayoutGetScrollInfo( he : HELEMENT; var scrollPos : TPOINT; var viewRect : TRECT; var contentSize : UINT ) : HLDOM_RESULT; stdcall;
function  HTMLayoutSetScrollPos( he : HELEMENT; scrollPos : TPOINT; smooth : BOOL ) : HLDOM_RESULT; stdcall;
function  HTMLayoutGetElementIntrinsicWidths( he : HELEMENT; var pMinWidth : integer; var pMaxWidth : integer ) : HLDOM_RESULT; stdcall;
function  HTMLayoutGetElementIntrinsicHeight( he : HELEMENT; forWidth : integer; var pHeight : integer ) : HLDOM_RESULT; stdcall;
function  HTMLayoutIsElementVisible( he : HELEMENT; var pVisible : BOOL ) : HLDOM_RESULT; stdcall;
function  HTMLayoutIsElementEnabled( he : HELEMENT; var pEnabled : BOOL ) : HLDOM_RESULT; stdcall;
function  HTMLayoutSortElements( he : HELEMENT; firstIndex : UINT; lastIndex : UINT; cmpFunc : HTMLayoutElementComparator; cmpFuncParam : POINTER ) : HLDOM_RESULT; stdcall;
function  HTMLayoutSwapElements( he1 : HELEMENT; he2 : HELEMENT ) : HLDOM_RESULT; stdcall;
function  HTMLayoutTraverseUIEvent( evt : UINT; eventCtlStruct : POINTER; var bOutProcessed : BOOL ) : HLDOM_RESULT; stdcall;
function  HTMLayoutControlGetType( he : HELEMENT; var pType : UINT {HTMLayoutCtlType} ) : HLDOM_RESULT; stdcall;
function  HTMLayoutControlGetValue( he : HELEMENT; var pVal : HtmlVALUE ) : HLDOM_RESULT; stdcall;
function  HTMLayoutControlSetValue( he : HELEMENT; const pVal : PHtmlVALUE ) : HLDOM_RESULT; stdcall;
function  HTMLayoutEnumerate( he : HELEMENT; pcb : HTMLayoutEnumerationCallback; p : POINTER; forward : BOOL ) : HLDOM_RESULT; stdcall;
function  HTMLayoutGetCharacterRect( he : HELEMENT; pos : UINT; var outRect : TRECT ) : HLDOM_RESULT; stdcall;
function  HTMLayoutEnumElementStyles( he : HELEMENT; callback : HTMLayoutStyleRuleCallback; callback_prm : Pointer ) : HLDOM_RESULT; stdcall;
function  HTMLayoutElementSetExpando( he : HELEMENT; pExpando : HTMLayoutElementExpando ) : HLDOM_RESULT; stdcall;
function  HTMLayoutElementGetExpando( he : HELEMENT; var ppExpando : PHTMLayoutElementExpando ) : HLDOM_RESULT; stdcall;
function  HTMLayoutMoveElement( he : HELEMENT; xView, yView : integer ) : HLDOM_RESULT; stdcall;
function  HTMLayoutMoveElementEx( he : HELEMENT; xView, yView, width, height : integer ) : HLDOM_RESULT; stdcall;
function  HTMLayoutAnimateElement( he : HELEMENT; pAnimator : HTMLayoutElementAnimator; animatorParam : Pointer ) : HLDOM_RESULT; stdcall;
function  HTMLayoutEnqueueMeasure( he : HELEMENT ) : HLDOM_RESULT; stdcall;
function  HTMLayoutParseValue( text : LPCWSTR; textLength : UINT; mode : UINT; var pVal : HtmlVALUE ) : UINT; stdcall;

implementation

uses HtmlDll;

function  HTMLayout_UseElement( he : HELEMENT ) : HLDOM_RESULT; external HTMLayoutDLL; stdcall;
function  HTMLayout_UnuseElement( he : HELEMENT ) : HLDOM_RESULT; external HTMLayoutDLL; stdcall;
function  HTMLayoutGetRootElement( hwnd : HWND; var phe : HELEMENT ) : HLDOM_RESULT; external HTMLayoutDLL; stdcall;
function  HTMLayoutGetFocusElement( hwnd : HWND; var phe : HELEMENT ) : HLDOM_RESULT; external HTMLayoutDLL; stdcall;
function  HTMLayoutFindElement( hwnd : HWND; pt : TPOINT; var phe : HELEMENT ) : HLDOM_RESULT; external HTMLayoutDLL; stdcall;
function  HTMLayoutGetChildrenCount( he : HELEMENT; var count : UINT ) : HLDOM_RESULT; external HTMLayoutDLL; stdcall;
function  HTMLayoutGetNthChild( he : HELEMENT; n : UINT; var phe : HELEMENT ) : HLDOM_RESULT; external HTMLayoutDLL; stdcall;
function  HTMLayoutGetParentElement( he : HELEMENT; var p_parent_he : HELEMENT ) : HLDOM_RESULT; external HTMLayoutDLL; stdcall;
function  HTMLayoutGetElementText( he : HELEMENT; characters: LPWSTR; var length : UINT) : HLDOM_RESULT; external HTMLayoutDLL; stdcall;
function  HTMLayoutGetElementHtml( he : HELEMENT; var utf8bytes : PCHAR; outer : BOOL ) : HLDOM_RESULT; external HTMLayoutDLL; stdcall;
function  HTMLayoutGetElementHtmlCB( he : HELEMENT; outer : BOOL; cb : HTMLayoutWriterCallbackB; cb_param : Pointer ) : HLDOM_RESULT; external HTMLayoutDLL; stdcall;
function  HTMLayoutGetElementInnerText( he : HELEMENT; var utf8bytes : PCHAR ) : HLDOM_RESULT; external HTMLayoutDLL; stdcall;
function  HTMLayoutSetElementInnerText( he : HELEMENT; utf8bytes : LPCSTR; length : UINT  ) : HLDOM_RESULT; external HTMLayoutDLL; stdcall;
function  HTMLayoutGetElementInnerText16( he : HELEMENT; var utf16words : LPWSTR ) : HLDOM_RESULT; external HTMLayoutDLL; stdcall;
function  HTMLayoutGetElementInnerTextCB( he : HELEMENT; cd : HTMLayoutWriterCallbackW; cb_param : Pointer ) : HLDOM_RESULT; external HTMLayoutDLL; stdcall;
function  HTMLayoutSetElementInnerText16( he : HELEMENT; utf16words : LPCWSTR; length : UINT ) : HLDOM_RESULT; external HTMLayoutDLL; stdcall;
function  HTMLayoutGetAttributeCount( he : HELEMENT; var p_count : UINT ) : HLDOM_RESULT; external HTMLayoutDLL; stdcall;
function  HTMLayoutGetNthAttribute( he : HELEMENT; n : UINT; var p_name : LPCSTR; var p_value : LPCWSTR ) : HLDOM_RESULT; external HTMLayoutDLL; stdcall;
function  HTMLayoutGetAttributeByName( he : HELEMENT; name : LPCSTR; var p_value : LPCWSTR ) : HLDOM_RESULT; external HTMLayoutDLL; stdcall;
function  HTMLayoutSetAttributeByName( he : HELEMENT; name : LPCSTR; value : LPCWSTR ) : HLDOM_RESULT; external HTMLayoutDLL; stdcall;
function  HTMLayoutClearAttributes( he : HELEMENT ) : HLDOM_RESULT; external HTMLayoutDLL; stdcall;
function  HTMLayoutGetElementIndex( he : HELEMENT; var p_index : UINT ) : HLDOM_RESULT; external HTMLayoutDLL; stdcall;
function  HTMLayoutGetElementType( he : HELEMENT; var p_type : LPCSTR ) : HLDOM_RESULT; external HTMLayoutDLL; stdcall;
function  HTMLayoutGetStyleAttribute( he : HELEMENT; name : LPCSTR; var p_value : LPCWSTR ) : HLDOM_RESULT; external HTMLayoutDLL; stdcall;
function  HTMLayoutSetStyleAttribute( he : HELEMENT; name : LPCSTR; value : LPCWSTR ) : HLDOM_RESULT; external HTMLayoutDLL; stdcall;
function  HTMLayoutGetElementLocation(he : HELEMENT; var p_location : TRect; areas : UINT {HTMLAYOUT_ELEMENT_AREAS} ) : HLDOM_RESULT; external HTMLayoutDLL; stdcall;
function  HTMLayoutScrollToView(he : HELEMENT; flags : UINT {HTMLAYOUT_SCROLL_FLAGS} ) : HLDOM_RESULT; external HTMLayoutDLL; stdcall;
function  HTMLayoutUpdateElement( he : HELEMENT; renderNow : BOOL ) : HLDOM_RESULT; external HTMLayoutDLL; stdcall;
function  HTMLayoutUpdateElementEx( he : HELEMENT; flags : UINT {UPDATE_ELEMENT_FLAGS} ) : HLDOM_RESULT; external HTMLayoutDLL; stdcall;
function  HTMLayoutSetCapture( he : HELEMENT ) : HLDOM_RESULT; external HTMLayoutDLL; stdcall;
function  HTMLayoutSetEventRoot( he : HELEMENT; var phePrevRoot : HELEMENT ) : HLDOM_RESULT; external HTMLayoutDLL; stdcall;
function  HTMLayoutGetElementHwnd( he : HELEMENT; var p_hwnd : HWND; rootWindow : BOOL ) : HLDOM_RESULT; external HTMLayoutDLL; stdcall;
function  HTMLayoutCombineURL( he : HELEMENT; szUrlBuffer : LPWSTR; UrlBufferSize : DWORD ) : HLDOM_RESULT; external HTMLayoutDLL; stdcall;
function  HTMLayoutVisitElements( he : HELEMENT; tagName : LPCSTR; attributeName : LPCSTR; attributeValue : LPCWSTR; callback : HTMLayoutElementCallback; param : POINTER; depth : DWORD ) : HLDOM_RESULT; external HTMLayoutDLL; stdcall;
function  HTMLayoutSelectElements( he: HELEMENT; CSS_selectors : LPCSTR; cb: HTMLayoutElementCallback; param : Pointer) : HLDOM_RESULT; external HTMLayoutDLL; stdcall;
function  HTMLayoutSelectElementsW( he: HELEMENT; CSS_selectors : LPCWSTR; cb: HTMLayoutElementCallback; param : Pointer) : HLDOM_RESULT; external HTMLayoutDLL; stdcall;
function  HTMLayoutSelectParent( he : HELEMENT; selector : LPCSTR; depth : UINT; var heFound : HELEMENT ) : HLDOM_RESULT; external HTMLayoutDLL; stdcall;
function  HTMLayoutSelectParentW( he : HELEMENT; selector : LPCWSTR; depth : UINT; var heFound : HELEMENT ) : HLDOM_RESULT; external HTMLayoutDLL; stdcall;
function  HTMLayoutSetElementHtml( he : HELEMENT; html : PBYTE; htmlLength : DWORD; where : UINT ) : HLDOM_RESULT; external HTMLayoutDLL; stdcall;
function  HTMLayoutDeleteElement( he : HELEMENT ) : HLDOM_RESULT; external HTMLayoutDLL; stdcall;
function  HTMLayoutGetElementUID( he : HELEMENT; var puid : UINT ) : HLDOM_RESULT; external HTMLayoutDLL; stdcall;
function  HTMLayoutGetElementByUID( hwnd : HWND; uid : UINT; var phe : HELEMENT ) : HLDOM_RESULT; external HTMLayoutDLL; stdcall;
function  HTMLayoutShowPopup( hePopup : HELEMENT; heAnchor : HELEMENT; placement : UINT ) : HLDOM_RESULT; external HTMLayoutDLL; stdcall;
function  HTMLayoutShowPopupAt( hePopup : HELEMENT; pos : TPOINT; animate : BOOL ) : HLDOM_RESULT; external HTMLayoutDLL; stdcall;
function  HTMLayoutTrackPopupAt( hePopup : HELEMENT; pos : TPOINT; mode : UINT; var pheItem : HELEMENT ) : HLDOM_RESULT; external HTMLayoutDLL; stdcall;
function  HTMLayoutHidePopup( he : HELEMENT ) : HLDOM_RESULT; external HTMLayoutDLL; stdcall;
function  HTMLayoutGetElementState( he : HELEMENT; var pstateBits : UINT ) : HLDOM_RESULT; external HTMLayoutDLL; stdcall;
function  HTMLayoutSetElementState( he : HELEMENT; stateBitsToSet : UINT; stateBitsToClear : UINT; updateView : BOOL ) : HLDOM_RESULT; external HTMLayoutDLL; stdcall;
function  HTMLayoutCreateElement( tagname : LPCSTR; textOrNull : LPCWSTR; var phe : HELEMENT ) : HLDOM_RESULT; external HTMLayoutDLL; stdcall;
function  HTMLayoutCloneElement( he : HELEMENT; var phe : HELEMENT ) : HLDOM_RESULT; external HTMLayoutDLL; stdcall;
function  HTMLayoutInsertElement( he : HELEMENT; hparent: HELEMENT; index : UINT ) : HLDOM_RESULT; external HTMLayoutDLL; stdcall;
function  HTMLayoutDetachElement( he : HELEMENT ) : HLDOM_RESULT; external HTMLayoutDLL; stdcall;
function  HTMLayoutSetTimer( he : HELEMENT; milliseconds : UINT ) : HLDOM_RESULT; external HTMLayoutDLL; stdcall;
function  HTMLayoutSetTimerEx( he : HELEMENT; milliseconds : UINT; timerId : cardinal ) : HLDOM_RESULT; external HTMLayoutDLL; stdcall
function  HTMLayoutAttachEventHandler( he : HELEMENT; pep: HTMLayoutElementEventProc; tag : Pointer ) : HLDOM_RESULT; external HTMLayoutDLL; stdcall;
function  HTMLayoutDetachEventHandler( he : HELEMENT; pep: HTMLayoutElementEventProc; tag : Pointer ) : HLDOM_RESULT; external HTMLayoutDLL; stdcall;
function  HTMLayoutAttachEventHandlerEx( he : HELEMENT; pep: HTMLayoutElementEventProc; tag : Pointer; subscription : UINT ) : HLDOM_RESULT; external HTMLayoutDLL; stdcall;
//function  HTMLayoutDetachEventHandlerEx( he : HELEMENT; pep: HTMLayoutElementEventProc; tag : Pointer; subscription : UINT ) : HLDOM_RESULT; external HTMLayoutDLL; stdcall;
function  HTMLayoutWindowAttachEventHandler( hwnd : HWND; pep: HTMLayoutElementEventProc; tag : Pointer; subscription : UINT ) : HLDOM_RESULT; external HTMLayoutDLL; stdcall;
function  HTMLayoutWindowDetachEventHandler( hwnd : HWND; pep: HTMLayoutElementEventProc; tag : Pointer ) : HLDOM_RESULT; external HTMLayoutDLL; stdcall;
function  HTMLayoutSendEvent( he : HELEMENT; appEventCode : UINT; heSource : HELEMENT; reason : UINT; var handled : BOOL ) : HLDOM_RESULT; external HTMLayoutDLL; stdcall;
function  HTMLayoutPostEvent( he : HELEMENT; appEventCode : UINT; heSource : HELEMENT; reason : UINT ) : HLDOM_RESULT; external HTMLayoutDLL; stdcall;
function  HTMLayoutCallBehaviorMethod( he : HELEMENT; params : POINTER) : HLDOM_RESULT; external HTMLayoutDLL; stdcall;
function  HTMLayoutRequestElementData( he : HELEMENT; url : LPCWSTR; dataType : UINT {HTMLayoutResourceType}; initiator : HELEMENT ) : HLDOM_RESULT; external HTMLayoutDLL; stdcall;
function  HTMLayoutHttpRequest( he : HELEMENT; url : LPCWSTR; dataType : UINT {HTMLayoutResourceType}; requestType : UINT {HTMLayoutRequestType}; requestParams : PREQUEST_PARAM; nParams : UINT ) : HLDOM_RESULT; external HTMLayoutDLL; stdcall;
function  HTMLayoutGetScrollInfo( he : HELEMENT; var scrollPos : TPOINT; var viewRect : TRECT; var contentSize : UINT ) : HLDOM_RESULT; external HTMLayoutDLL; stdcall;
function  HTMLayoutSetScrollPos( he : HELEMENT; scrollPos : TPOINT; smooth : BOOL ) : HLDOM_RESULT; external HTMLayoutDLL; stdcall;
function  HTMLayoutGetElementIntrinsicWidths( he : HELEMENT; var pMinWidth : integer; var pMaxWidth : integer ) : HLDOM_RESULT; external HTMLayoutDLL; stdcall;
function  HTMLayoutGetElementIntrinsicHeight( he : HELEMENT; forWidth : integer; var pHeight : integer ) : HLDOM_RESULT; external HTMLayoutDLL; stdcall;
function  HTMLayoutIsElementVisible( he : HELEMENT; var pVisible : BOOL ) : HLDOM_RESULT; external HTMLayoutDLL; stdcall;
function  HTMLayoutIsElementEnabled( he : HELEMENT; var pEnabled : BOOL ) : HLDOM_RESULT; external HTMLayoutDLL; stdcall;
function  HTMLayoutSortElements( he : HELEMENT; firstIndex : UINT; lastIndex : UINT; cmpFunc : HTMLayoutElementComparator; cmpFuncParam : POINTER ) : HLDOM_RESULT; external HTMLayoutDLL; stdcall;
function  HTMLayoutSwapElements( he1 : HELEMENT; he2 : HELEMENT ) : HLDOM_RESULT; external HTMLayoutDLL; stdcall;
function  HTMLayoutTraverseUIEvent( evt : UINT; eventCtlStruct : POINTER; var bOutProcessed : BOOL ) : HLDOM_RESULT; external HTMLayoutDLL; stdcall;
function  HTMLayoutControlGetType( he : HELEMENT; var pType : UINT ) : HLDOM_RESULT; external HTMLayoutDLL; stdcall;
function  HTMLayoutControlGetValue( he : HELEMENT; var pVal : HtmlVALUE ) : HLDOM_RESULT; external HTMLayoutDLL; stdcall;
function  HTMLayoutControlSetValue( he : HELEMENT; const pVal : PHtmlVALUE ) : HLDOM_RESULT; external HTMLayoutDLL; stdcall;
function  HTMLayoutEnumerate( he : HELEMENT; pcb : HTMLayoutEnumerationCallback; p : POINTER; forward : BOOL ) : HLDOM_RESULT; external HTMLayoutDLL; stdcall;
function  HTMLayoutGetCharacterRect( he : HELEMENT; pos : UINT; var outRect : TRECT ) : HLDOM_RESULT; external HTMLayoutDLL; stdcall;
function  HTMLayoutEnumElementStyles( he : HELEMENT; callback : HTMLayoutStyleRuleCallback; callback_prm : Pointer ) : HLDOM_RESULT; external HTMLayoutDLL; stdcall;
function  HTMLayoutElementSetExpando( he : HELEMENT; pExpando : HTMLayoutElementExpando ) : HLDOM_RESULT; external HTMLayoutDLL; stdcall;
function  HTMLayoutElementGetExpando( he : HELEMENT; var ppExpando : PHTMLayoutElementExpando ) : HLDOM_RESULT; external HTMLayoutDLL; stdcall;
function  HTMLayoutMoveElement( he : HELEMENT; xView, yView : integer ) : HLDOM_RESULT; external HTMLayoutDLL; stdcall;
function  HTMLayoutMoveElementEx( he : HELEMENT; xView, yView, width, height : integer ) : HLDOM_RESULT; external HTMLayoutDLL; stdcall;
function  HTMLayoutAnimateElement( he : HELEMENT; pAnimator : HTMLayoutElementAnimator; animatorParam : Pointer ) : HLDOM_RESULT; external HTMLayoutDLL; stdcall;
function  HTMLayoutEnqueueMeasure( he : HELEMENT ) : HLDOM_RESULT; external HTMLayoutDLL; stdcall;
function  HTMLayoutParseValue( text : LPCWSTR; textLength : UINT; mode : UINT; var pVal : HtmlVALUE ) : UINT; external HTMLayoutDLL; stdcall;


end.

