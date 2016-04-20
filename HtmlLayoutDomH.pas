unit HtmlLayoutDomH;

(*
  HTMLayout SDK http://www.terrainformatica.com/htmlayout/HTMLayoutSDK.zip

  HTMLayout License terms could be found here http://www.terrainformatica.com/htmlayout/prices.whtm
  Delphi binding of HTMLayout is free for commercial and non-commercial use, visit https://github.com/Keksov/HtmlayoutDelphi

  This file contains function and types declarations translated from include\htmlayout_dom.h of
  Most accurate documentation could be found in include\htmlayout_dom.h itself
*)

// htmlayout_dom.h

interface

{$IFDEF USER_DEFINES_INC}{$I user_defines.inc}{$ENDIF}

uses Windows
    , HtmlTypes
    , HtmlBehaviorH
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
        ROOT_RELATIVE           = $01, // - "or" this flag if you want to get HTMLayout window relative coordinates,
                                       //   otherwise it will use nearest windowed container e.g. popup window.
        SELF_RELATIVE           = $02, // - "or" this flag if you want to get coordinates relative to the origin
                                       //   of element itself.
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

    // Callback function used with HTMLayoutGetElementHtmlCB()    
    HTMLayoutWriterCallbackB = procedure( utf8 : LPCSTR; utf8_length : UINT; param : Pointer ); stdcall;
    // Callback function used with #HTMLayoutGetElementInnerTextCB().
    HTMLayoutWriterCallbackW = procedure( text : LPCWSTR; text_length : UINT; param : Pointer ); stdcall;

    // Callback comparator function used with #HTMLayoutSortElements().
    // Shall return -1,0,+1 values to indicate result of comparison of two elements
    HTMLayoutElementComparator = function( he1 : HELEMENT; he2 : HELEMENT; param : Pointer ) : integer; stdcall;

    {* Callback function used with #HTMLayoutEnumearate().
     * param[in] he HELEMENT, element.
     * param[in] pos int, position in the element.
     * param[in] postype int, position type :
            0 - he element head position.
            1 - he element tail position.
            2 - character position.
     * param[in] code int, UTF16 code unit value if postype == 3
    *}
    HTMLayoutEnumerationCallback = function( p : Pointer; he : HELEMENT; pos : integer; postype : integer; code : WCHAR ) : BOOL stdcall;
    HTMLayoutStyleRuleCallback = procedure( pdef : PHTMLayoutCSSRuleDef; callback_prm : Pointer ); stdcall;

    {* Element animator function used with #HTMLayoutAnimateElement().
      * Returns number of milliseconds for the next animation step or zero to stop animation.
      * param[in] step UINT, is a number of times this function was invoked for the element.
      *                          Starts from 0. When animation is stoped step will be equal to UINT(-1) and
      *                          this will be the last call of this function by the engine for this animation
      *                          session.
      * param[in] animatorParam LPVOID, parameter passed "as is" from the HTMLayoutAnimateElement call.
    *}
    HTMLayoutElementAnimator = function( he : HELEMENT; step : UINT; animatorParam : Pointer ) : UINT; stdcall;

(* Marks DOM object as used (a.k.a. AddRef).
 * param[in] he #HELEMENT
 * return #HLDOM_RESULT
 * Application should call this function before using element handle. If the 
 * application fails to do that calls to other DOM functions for this handle 
 * may result in an error.
 * 
 * sa #HTMLayout_UnuseElement()
*)
function  HTMLayout_UseElement( he : HELEMENT ) : HLDOM_RESULT; stdcall;

(* Marks DOM object as unused (a.k.a. Release).
 * Get handle of every element's child element.
 * param[in] he #HELEMENT
 * return #HLDOM_RESULT
 *
 * Application should call this function when it does not need element's
 * handle anymore.
 * sa #HTMLayout_UseElement()
*)
function  HTMLayout_UnuseElement( he : HELEMENT ) : HLDOM_RESULT; stdcall;

(* Get root DOM element of HTML document.
 * param[in] hwnd HWND, HTMLayout window for which you need to get root 
 * element
 * param[out ] phe #HELEMENT*, variable to receive root element
 * return #HLDOM_RESULT
 * 
 * Root DOM object is always a 'HTML' element of the document.
*)
function  HTMLayoutGetRootElement( hwnd : HWND; var phe : HELEMENT ) : HLDOM_RESULT; stdcall;

(* Get focused DOM element of HTML document.
 * param[in] hwnd HWND, HTMLayout window for which you need to get focus element
 * param[out ] phe #HELEMENT*, variable to receive focus element
 * return #HLDOM_RESULT
 * 
 * phe can have null value (0).
 *
 * COMMENT: To set focus on element use HTMLayoutSetElementState(STATE_FOCUS,0)
*)
function  HTMLayoutGetFocusElement( hwnd : HWND; var phe : HELEMENT ) : HLDOM_RESULT; stdcall;

(* Find DOM element by coordinate.
 * param[in] hwnd HWND, HTMLayout window for which you need to find elementz
 * param[in] pt POINT, coordinates, window client area relative.  
 * param[out ] phe #HELEMENT*, variable to receive found element handle.
 * return #HLDOM_RESULT
 * 
 * If element was not found then *phe will be set to zero.
*)
function  HTMLayoutFindElement( hwnd : HWND; pt : TPOINT; var phe : HELEMENT ) : HLDOM_RESULT; stdcall;

(* Get number of child elements.
 * param[in] he #HELEMENT, element which child elements you need to count
 * param[out] count UINT*, variable to receive number of child elements 
 * return #HLDOM_RESULT
 *
 * par Example:
 * for paragraph defined as
 * verbatim <p>Hello <b>wonderfull</b> world!</p> \endverbatim
 * count will be set to 1 as the paragraph has only one sub element: 
 * verbatim <b>wonderfull</b> \endverbatim
*)
function  HTMLayoutGetChildrenCount( he : HELEMENT; var count : UINT ) : HLDOM_RESULT; stdcall;

(* Get handle of every element's child element.
 * param[in] he #HELEMENT
 * param[in] n UINT, number of the child element
 * param[out] phe #HELEMENT*, variable to receive handle of the child  element
 * return #HLDOM_RESULT
 *
 * par Example:
 * for paragraph defined as
 * verbatim <p>Hello <b>wonderfull</b> world!</p> \endverbatim
 * *phe will be equal to handle of &lt;b&gt; element:
 * verbatim <b>wonderfull</b> \endverbatim
*)
function  HTMLayoutGetNthChild( he : HELEMENT; n : UINT; var phe : HELEMENT ) : HLDOM_RESULT; stdcall;

(* Get parent element.
 * param[in] he #HELEMENT, element which parent you need
 * param[out] p_parent_he #HELEMENT*, variable to recieve handle of the 
 * parent element
 * return #HLDOM_RESULT
*)
function  HTMLayoutGetParentElement( he : HELEMENT; var p_parent_he : HELEMENT ) : HLDOM_RESULT; stdcall;

(* Get text of the element and information where child elements are placed.
 * param[in] he #HELEMENT
 * param[out] characters LPWSTR, buffer to receive text. Zero characters 
 * '\\0' will be inserted at places where subelements should be.
 * param[in,out] length LPUINT, at input it is length of the characters
 * array, after function call it is actual amount of characters written.
 * return #HLDOM_RESULT
 *
 * parameter characters can be NULL. In this case HTMEngine will just set length 
 * equal to number of characters in this element.
 *
 * par Example:
 * for paragraph defined as
 * verbatim <p>Hello <b>wonderfull</b> <i>world</i>!</p> \endverbatim
 * text will be "Hello \\0 \\0" ('\\0' is character with code zero)
*)
function  HTMLayoutGetElementText( he : HELEMENT; characters: LPWSTR; var length : UINT) : HLDOM_RESULT; stdcall;

(*G et text of the element and information where child elements are placed.
 * param[in] he #HELEMENT
 * param[out] utf8bytes pointer to byte address receiving UTF8 encoded HTML 
 * param[in] outer BOOL, if TRUE will retunr outer HTML otherwise inner.  
 * return #HLDOM_RESULT
*)
function  HTMLayoutGetElementHtml( he : HELEMENT; var utf8bytes : PCHAR; outer : BOOL ) : HLDOM_RESULT; stdcall;
function  HTMLayoutGetElementHtmlCB( he : HELEMENT; outer : BOOL; cb : HTMLayoutWriterCallbackB; cb_param : Pointer ) : HLDOM_RESULT; stdcall;

(* Get inner text of the element.
 * param[in] he #HELEMENT
 * param[out] utf8bytes pointer to byte address receiving UTF8 encoded plain text
 * return #HLDOM_RESULT
*)
function  HTMLayoutGetElementInnerText( he : HELEMENT; var utf8bytes : PCHAR ) : HLDOM_RESULT; stdcall;

(* Set inner text of the element.
 * param[in] he #HELEMENT
 * param[in] utf8bytes pointer, UTF8 encoded plain text 
 * param[in] length UINT, number of bytes in utf8bytes sequence
 * return #HLDOM_RESULT
*)
function  HTMLayoutSetElementInnerText( he : HELEMENT; utf8bytes : LPCSTR; length : UINT ) : HLDOM_RESULT; stdcall;

(* Get inner text of the element as LPWSTR (utf16 words).
 * param[in] he #HELEMENT
 * param[out] utf16words pointer to byte address receiving UTF16 encoded plain text
 * return #HLDOM_RESULT
*)
function  HTMLayoutGetElementInnerText16( he : HELEMENT; var utf16words : LPWSTR ) : HLDOM_RESULT; stdcall;
function  HTMLayoutGetElementInnerTextCB( he : HELEMENT; cd : HTMLayoutWriterCallbackW; cb_param : Pointer ) : HLDOM_RESULT; stdcall;

(* Set inner text of the element from LPCWSTR buffer (utf16 words).
 * param[in] he #HELEMENT
 * param[in] utf16words pointer, UTF16 encoded plain text
 * param[in] length UINT, number of words in utf16words sequence
 * return #HLDOM_RESULT
*)
function  HTMLayoutSetElementInnerText16( he : HELEMENT; utf16words : LPCWSTR; length : UINT ) : HLDOM_RESULT; stdcall;

(* Get number of element's attributes.
 * param[in] he #HELEMENT
 * param[out] p_count LPUINT, variable to receive number of element attributes.
 * return #HLDOM_RESULT
*)
function  HTMLayoutGetAttributeCount( he : HELEMENT; var p_count : UINT ) : HLDOM_RESULT; stdcall;

(* Get value of any element's attribute by attribute's number.
 * param[in] he #HELEMENT
 * param[in] n UINT, number of desired attribute
 * param[out] p_name LPCSTR*, will be set to address of the string containing attribute name
 * param[out] p_value LPCWSTR*, will be set to address of the string containing attribute value
 * return #HLDOM_RESULT
*)
function  HTMLayoutGetNthAttribute( he : HELEMENT; n : UINT; var p_name : LPCSTR; var p_value : LPCWSTR ) : HLDOM_RESULT; stdcall;

(* Get value of any element's attribute by name.
 * param[in] he #HELEMENT
 * param[in] name LPCSTR, attribute name
 * param[out] p_value LPCWSTR*, will be set to address of the string containing attribute value
 * return #HLDOM_RESULT
*)
function  HTMLayoutGetAttributeByName( he : HELEMENT; name : LPCSTR; var p_value : LPCWSTR ) : HLDOM_RESULT; stdcall;

(* Set attribute's value.
 * param[in] he #HELEMENT
 * param[in] name LPCSTR, attribute name
 * param[in] value LPCWSTR, new attribute value or 0 if you want to remove attribute.
 * return #HLDOM_RESULT
*)
function  HTMLayoutSetAttributeByName( he : HELEMENT; name : LPCSTR; value : LPCWSTR ) : HLDOM_RESULT; stdcall;

(* Remove all attributes from the element.
 * param[in] he #HELEMENT
 * return #HLDOM_RESULT
*)
function  HTMLayoutClearAttributes( he : HELEMENT ) : HLDOM_RESULT; stdcall;

(* Get element index.
 * param[in] he #HELEMENT
 * param[out] p_index LPUINT, variable to receive number of the element
 * among parent element's subelements.
 * return #HLDOM_RESULT
*)
function  HTMLayoutGetElementIndex( he : HELEMENT; var p_index : UINT ) : HLDOM_RESULT; stdcall;

(* Get element's type.
 * param[in] he #HELEMENT 
 * param[out] p_type LPCSTR*, receives name of the element type.
 * return #HLDOM_RESULT
 * 
 * par Example:
 * For <div> tag p_type will be set to "div".
*)
function  HTMLayoutGetElementType( he : HELEMENT; var p_type : LPCSTR ) : HLDOM_RESULT; stdcall;

(* Get element's style attribute.
 * param[in] he #HELEMENT 
 * param[in] name LPCSTR, name of the style attribute
 * param[out] p_value LPCWSTR*, variable to receive value of the style attribute.
 *
 * Style attributes are those that are set using css. E.g. "font-face: arial" or "display: block".
 *
 * sa #HTMLayoutSetStyleAttribute()
*)
function  HTMLayoutGetStyleAttribute( he : HELEMENT; name : LPCSTR; var p_value : LPCWSTR ) : HLDOM_RESULT; stdcall;

(* Get element's style attribute.
 * param[in] he #HELEMENT 
 * param[in] name LPCSTR, name of the style attribute
 * param[out] value LPCWSTR, value of the style attribute or NULL for clearing the attribute
 *
 * Style attributes are those that are set using css. E.g. "font-face: arial" or "display: block".
 *
 * sa #HTMLayoutGetStyleAttribute()
*)
function  HTMLayoutSetStyleAttribute( he : HELEMENT; name : LPCSTR; value : LPCWSTR ) : HLDOM_RESULT; stdcall;

(* Get bounding rectangle of the element.
 * param[in] he #HELEMENT
 * param[out] p_location LPRECT, receives bounding rectangle of the element
 * param[in] rootRelative BOOL, if TRUE function returns location of the
 * element relative to HTMLayout window, otherwise the location is given
 * relative to first scrollable container.
 *
 * Use HTMLayoutSetStyleAttribute(he, name, NULL) to remove value that was set previously
 * by this function.
 *
 * return #HLDOM_RESULT
*)
function  HTMLayoutGetElementLocation( he : HELEMENT; var p_location : TRect; areas : UINT {HTMLAYOUT_ELEMENT_AREAS} ) : HLDOM_RESULT; stdcall;

(* Scroll to view.
 * param[in] he #HELEMENT 
 * param[in] toTopOfView #BOOL, if TRUE positions element to top of the view 
 * return #HLDOM_RESULT
*)
function  HTMLayoutScrollToView( he : HELEMENT; flags : UINT {HTMLAYOUT_SCROLL_FLAGS} ) : HLDOM_RESULT; stdcall;

(* Apply changes and refresh element area in its window.
 * param[in] he #HELEMENT 
 * param[in] remeasure BOOL, TRUE if element's dimensions need to be recalculated.
 * return #HLDOM_RESULT
 *
 * This is optional method since v 3.3.0.4   
 * Engine will call update internaly when handling DOM mutating methods.  
 *
*)
function  HTMLayoutUpdateElement( he : HELEMENT; renderNow : BOOL ) : HLDOM_RESULT; stdcall;

(* Apply changes and refresh element area in its window.
 * param[in] he #HELEMENT 
 * param[in] flags UINT, combination of UPDATE_ELEMENT_FLAGS.
 * return #HLDOM_RESULT
 *
 *  Note HTMLayoutUpdateElement is an equivalent of HTMLayoutUpdateElementEx(,RESET_STYLE_DEEP | REMEASURE [| REDRAW_NOW ])
 *
*)
function  HTMLayoutUpdateElementEx( he : HELEMENT; flags : UINT {UPDATE_ELEMENT_FLAGS} ) : HLDOM_RESULT; stdcall;

(* Set the mouse capture to the specified element.
 * param[in] he #HELEMENT 
 * return #HLDOM_RESULT
 *
 * After call to this function all mouse events will be targeted to the element.
 * To remove mouse capture call ::ReleaseCapture() function. It is declared somewhere in <windows.h>.
*)
function  HTMLayoutSetCapture( he : HELEMENT ) : HLDOM_RESULT; stdcall;

(* Set event root the specified element.
 * param[in] he #HELEMENT 
 * param[out] phePrevRoot #HELEMENT* - previous event root element
 * return #HLDOM_RESULT
 *
 * After call to this function all events will be targeted to the element and its sub elements.
 * All elements outside of the EventRoot will behave as if they are disabled
*)
function  HTMLayoutSetEventRoot( he : HELEMENT; var phePrevRoot : HELEMENT ) : HLDOM_RESULT; stdcall;

(* Get HWND of containing window.
 * param[in] he #HELEMENT 
 * param[out] p_hwnd HWND*, variable to receive window handle
 * param[in] rootWindow BOOL, handle of which window to get:
 * - TRUE - HTMLayout window
 * - FALSE - nearest parent element having overflow:auto or :scroll
 * return #HLDOM_RESULT
*)
function  HTMLayoutGetElementHwnd( he : HELEMENT; var p_hwnd : HWND; rootWindow : BOOL ) : HLDOM_RESULT; stdcall;

(* Combine given URL with URL of the document element belongs to.
 * param[in] he #HELEMENT
 * param[in, out] szUrlBuffer LPWSTR, at input this buffer contains
 * zero-terminated URL to be combined, after function call it contains
 * zero-terminated combined URL
 * param[in] UrlBufferSize DWORD, size of the buffer pointed by c szUrlBuffer
 * return #HLDOM_RESULT
 *
 * This function is used for resolving relative references.
*)
function  HTMLayoutCombineURL( he : HELEMENT; szUrlBuffer : LPWSTR; UrlBufferSize : DWORD ) : HLDOM_RESULT; stdcall;

(* Call specified function for every element in a DOM that meets specifiedcriteria.
 * param[in] he #HELEMENT
 * param[in] tagName LPCSTR, comma separated list of tag names to search, e.g. "div", "p", "div,p" etc. Can be NULL.
 * param[in] attributeName LPCSTR, name of attribute, can contain wildcard characters, see below. Can be NULL.
 * param[in] attributeValue LPCWSTR, value of attribute, can contain wildcard characters, see below. Can be NULL.
 * param[in] callback #HTMLayoutElementCallback*, address of callback function being called on each element found.
 * param[in] param LPVOID, additional parameter to be passed to callback function.
 * param[in] depth DWORD, depth - depth of search. 0 means all descendants, 1 - direct children only,
 * 2 - children and their children and so on.
 * return #HLDOM_RESULT
 *
 * Wildcard characters in attributeName and attributeValue:
 * - '*' - any substring
 * - '?' - any one char
 * - '['char set']' = any one char in set
 *
 * par Example:
 * - [a-z] - all lowercase letters
 * - [a-zA-Z] - all letters
 * - [abd-z] - all lowercase letters except of 'c'
 * - [-a-z] - all lowercase letters and '-'
*)
function  HTMLayoutVisitElements( he : HELEMENT; tagName : LPCSTR; attributeName : LPCSTR; attributeValue : LPCWSTR; callback : HTMLayoutElementCallback; param : POINTER; depth : DWORD ) : HLDOM_RESULT; stdcall;

(* Call specified function for every element in a DOM that meets specified CSS selectors.
 * See list of supported selectors: http://terrainformatica.com/htmlayout/selectors.whtm
 * param[in] he #HELEMENT
 * param[in] selector LPCSTR, comma separated list of CSS selectors, e.g.: div, #id, div[align="right"].
 * param[in] callback #HTMLayoutElementCallback*, address of callback function being called on each element found.
 * param[in] param LPVOID, additional parameter to be passed to callback function.
 * return #HLDOM_RESULT
 *
 * Note that :root pseudo-element matches element 'he' here.
*)
function  HTMLayoutSelectElements( he : HELEMENT; CSS_selectors : LPCSTR; cb : HTMLayoutElementCallback; param : Pointer) : HLDOM_RESULT; stdcall;
function  HTMLayoutSelectElementsW( he : HELEMENT; CSS_selectors : LPCWSTR; cb : HTMLayoutElementCallback; param : Pointer) : HLDOM_RESULT; stdcall;

(* Find parent of the element by CSS selector.
 * ATTN: function will test first element itself.
 * See list of supported selectors: http://terrainformatica.com/htmlayout/selectors.whtm
 * param[in] he #HELEMENT
 * param[in] selector LPCSTR, comma separated list of CSS selectors, e.g.: div, #id, div[align="right"].
 * param[out] heFound #HELEMENT*, address of result HELEMENT
 * param[in] depth LPVOID, depth of search, if depth == 1 then it will test only element itself.
 *                     Use depth = 1 if you just want to test he element for matching given CSS selector(s).
 *                     depth = 0 will scan the whole child parent chain up to the root.
 * return #HLDOM_RESULT
 *
*)
function  HTMLayoutSelectParent( he : HELEMENT; selector : LPCSTR; depth : UINT; var heFound : HELEMENT ) : HLDOM_RESULT; stdcall;
function  HTMLayoutSelectParentW( he : HELEMENT; selector : LPCWSTR; depth : UINT; var heFound : HELEMENT ) : HLDOM_RESULT; stdcall;

(* Set inner or outer html of the element.
 * param[in] he #HELEMENT
 * param[in] html LPCBYTE, UTF-8 encoded string containing html text
 * param[in] htmlLength DWORD, length in bytes of html.
 * param[in] where UINT, possible values are:
 * - SIH_REPLACE_CONTENT - replace content of the element
 * - SIH_INSERT_AT_START - insert html before first child of the element
 * - SIH_APPEND_AFTER_LAST - insert html after last child of the element
 *
 * - SOH_REPLACE - replace element by html, a.k.a. element.outerHtml = "something"
 * - SOH_INSERT_BEFORE - insert html before the element
 * - SOH_INSERT_AFTER - insert html after the element
 *   ATTN: SOH_*** operations do not work for inline elements like <SPAN>
 *
 * return /b #HLDOM_RESULT
*)
function  HTMLayoutSetElementHtml( he : HELEMENT; html : PBYTE; htmlLength : DWORD; where : UINT ) : HLDOM_RESULT; stdcall;

(* Delete element.
 * param[in] he #HELEMENT
 * return #HLDOM_RESULT
 *
 * This function removes element from the DOM tree and then deletes it.
 *
 * warning After call to this function he will become invalid.
*)
function  HTMLayoutDeleteElement( he : HELEMENT ) : HLDOM_RESULT; stdcall;

(* Element UID support functions.
 *  
 *  Element UID is unique identifier of the DOM element. 
 *  UID is suitable for storing it in structures associated with the view/document.
 *  Access to the element using HELEMENT is more effective but table space of handles is limited.
 *  It is not recommended to store HELEMENT handles between function calls.
*)

(* Get Element UID.
 * param[in] he #HELEMENT
 * param[out] puid UINT*, variable to receive UID of the element.
 * return #HLDOM_RESULT
 *
 * This function retrieves element UID by its handle.
 *
*)
function  HTMLayoutGetElementUID( he : HELEMENT; var puid : UINT ) : HLDOM_RESULT; stdcall;

(* Get Element handle by its UID.
 * param[in] hwnd HWND, HWND of HTMLayout window
 * param[in] uid UINT
 * param[out] phe #HELEMENT*, variable to receive HELEMENT handle 
 * return #HLDOM_RESULT
 *
 * This function retrieves element UID by its handle.
 *
*)
function  HTMLayoutGetElementByUID( hwnd : HWND; uid : UINT; var phe : HELEMENT ) : HLDOM_RESULT; stdcall;

(* Shows block element (DIV) in popup window.
 * param[in] hePopup HELEMENT, element to show as popup
 * param[in] heAnchor HELEMENT, anchor element - hePopup will be shown near this element
 * param[in] placement UINT, values: 
 *     2 - popup element below of anchor
 *     8 - popup element above of anchor
 *     4 - popup element on left side of anchor
 *     6 - popup element on right side of anchor
 *     ( see numpad on keyboard to get an idea of the numbers)
 * return #HLDOM_RESULT
 *
*)
function  HTMLayoutShowPopup( hePopup : HELEMENT; heAnchor : HELEMENT; placement : UINT ) : HLDOM_RESULT; stdcall;

(* Shows block element (DIV) in popup window at given position.
 * param[in] hePopup HELEMENT, element to show as popup
 * param[in] pos POINT, popup element position, relative to origin of HTMLayout window.
 * param[in] mode BOOL, LOWORD=1 if animation is needed. HIWORD 1..9 - point of the popup that corresponds to pos 
*)
function  HTMLayoutShowPopupAt( hePopup : HELEMENT; pos : TPOINT; animate : BOOL ) : HLDOM_RESULT; stdcall;

(* Shows block element (menu.popup) in popup window at given position and runs popup loop.
 *  function will return when the menu dismissed.
 * param[in] hePopup HELEMENT, element to show as popup
 * param[in] pos POINT, popup element position, relative to origin of HTMLayout window.
 * param[in] mode BOOL, LOWORD=1 if animation is needed. HIWORD 1..9 - point of the popup that corresponds to pos
 * param[out] pheItem HELEMENT*, menu item that was choosen (if any). 
*)
function  HTMLayoutTrackPopupAt( hePopup : HELEMENT; pos : TPOINT; mode : UINT; var pheItem : HELEMENT ) : HLDOM_RESULT; stdcall;

(* Removes popup window.
 * param[in] he HELEMENT, element which belongs to popup window or popup element itself
*)
function  HTMLayoutHidePopup( he : HELEMENT ) : HLDOM_RESULT; stdcall;

(* Get/set state bits, stateBits*** accept or'ed values above
*)
function  HTMLayoutGetElementState( he : HELEMENT; var pstateBits : UINT ) : HLDOM_RESULT; stdcall;
function  HTMLayoutSetElementState( he : HELEMENT; stateBitsToSet : UINT; stateBitsToClear : UINT; updateView : BOOL ) : HLDOM_RESULT; stdcall;

(* Create new element, the element is disconnected initially from the DOM.
    Element created with ref_count = 1 thus you must call HTMLayout_UnuseElement on returned handler.
 * param[in] tagname LPCSTR, html tag of the element e.g. "div", "option", etc.
 * param[in] textOrNull LPCWSTR, initial text of the element or NULL. text here is a plain text - method does no parsing.
 * param[out ] phe #HELEMENT*, variable to receive handle of the element
*)
function  HTMLayoutCreateElement( tagname : LPCSTR; textOrNull : LPCWSTR; var phe : HELEMENT ) : HLDOM_RESULT; stdcall;

(* Create new element as copy of existing element, new element is a full (deep) copy of the element and
    is disconnected initially from the DOM.
    Element created with ref_count = 1 thus you must call HTMLayout_UnuseElement on returned handler.
 * param[in] he #HELEMENT, source element.
 * param[out ] phe #HELEMENT*, variable to receive handle of the new element. 
*)
function  HTMLayoutCloneElement( he : HELEMENT; var phe : HELEMENT ) : HLDOM_RESULT; stdcall;

(* Insert element at \i index position of parent.
    It is not an error to insert element which already has parent - it will be disconnected first, but 
    you need to update elements parent in this case. 
 * param index UINT, position of the element in parent collection. 
   It is not an error to provide index greater than elements count in parent -
   it will be appended.
*)
function  HTMLayoutInsertElement( he : HELEMENT; hparent: HELEMENT; index : UINT ) : HLDOM_RESULT; stdcall;

(* Take element out of its container (and DOM tree). 
    Element will be destroyed when its reference counter will become zero
*)
function  HTMLayoutDetachElement( he : HELEMENT ) : HLDOM_RESULT; stdcall;

(* Start Timer for the element. 
    Element will receive on_timer event
    To stop timer call HTMLayoutSetTimer( he, 0 );
*)
function  HTMLayoutSetTimer( he : HELEMENT; milliseconds : UINT ) : HLDOM_RESULT; stdcall;

(* Start Extended Timer for the element. 
    Element will receive on_timer(, timerId) event
    To stop timer call HTMLayoutSetTimerEx( he, 0, timerId);
 * param timerId UINT_OTR, arbitrary value that will be deliverd to the behavior "as is". 
*)
function  HTMLayoutSetTimerEx( he : HELEMENT; milliseconds : UINT; timerId : cardinal ) : HLDOM_RESULT; stdcall;

(* Attach/Detach ElementEventProc to the element 
    See htmlayout::event_handler.
*)
function  HTMLayoutAttachEventHandler( he : HELEMENT; pep: HTMLayoutElementEventProc; tag : Pointer ) : HLDOM_RESULT; stdcall;
function  HTMLayoutDetachEventHandler( he : HELEMENT; pep: HTMLayoutElementEventProc; tag : Pointer ) : HLDOM_RESULT; stdcall;

(* Attach ElementEventProc to the element and subscribe it to events providede by subscription parameter
    See htmlayout::attach_event_handler.
*)
function  HTMLayoutAttachEventHandlerEx( he : HELEMENT; pep: HTMLayoutElementEventProc; tag : Pointer; subscription : UINT ) : HLDOM_RESULT; stdcall;

(* Attach/Detach ElementEventProc to the htmlayout window.
    All events will start first here (in SINKING phase) and if not consumed will end up here.
    You can install Window EventHandler only once - it will survive all document reloads.
*)
function  HTMLayoutWindowAttachEventHandler( hwnd : HWND; pep: HTMLayoutElementEventProc; tag : Pointer; subscription : UINT ) : HLDOM_RESULT; stdcall;
function  HTMLayoutWindowDetachEventHandler( hwnd : HWND; pep: HTMLayoutElementEventProc; tag : Pointer ) : HLDOM_RESULT; stdcall;

(* SendEvent - sends sinking/bubbling event to the child/parent chain of he element.
    First event will be send in SINKING mode (with SINKING flag) - from root to he element itself.
    Then from he element to its root on parents chain without SINKING flag (bubbling phase).

 * param[in] he HELEMENT, element to send this event to.
 * param[in] appEventCode UINT, event ID, see: #BEHAVIOR_EVENTS
 * param[in] heSource HELEMENT, optional handle of the source element, e.g. some list item
 * param[in] reason UINT, notification specific event reason code
 * param[out] handled BOOL*, variable to receive TRUE if any handler handled it, FALSE otherwise.

*)
function  HTMLayoutSendEvent( he : HELEMENT; appEventCode : UINT; heSource : HELEMENT; reason : UINT; var handled : BOOL ) : HLDOM_RESULT; stdcall;

(* PostEvent - post sinking/bubbling event to the child/parent chain of he element.
 *  Function will return immediately posting event into input queue of the application. 
 *
 * param[in] he HELEMENT, element to send this event to.
 * param[in] appEventCode UINT, event ID, see: #BEHAVIOR_EVENTS
 * param[in] heSource HELEMENT, optional handle of the source element, e.g. some list item
 * param[in] reason UINT, notification specific event reason code

*)
function  HTMLayoutPostEvent( he : HELEMENT; appEventCode : UINT; heSource : HELEMENT; reason : UINT ) : HLDOM_RESULT; stdcall;

(* HTMLayoutCallMethod - calls behavior specific method.
 * param[in] he HELEMENT, element - source of the event.
 * param[in] params METHOD_PARAMS, pointer to method param block
*)
function  HTMLayoutCallBehaviorMethod( he : HELEMENT; params : POINTER) : HLDOM_RESULT; stdcall;

(* HTMLayoutRequestElementData  - request data download for the element.
 * param[in] he HELEMENT, element to deleiver data to.
 * param[in] url LPCWSTR, url to download data from.
 * param[in] dataType UINT, data type, see HTMLayoutResourceType.
 * param[in] hInitiator HELEMENT, element - initiator, can be NULL.

  event handler on the he element (if any) will be notified 
  when data will be ready by receiving HANDLE_DATA_DELIVERY event.

*)
function  HTMLayoutRequestElementData( he : HELEMENT; url : LPCWSTR; dataType : UINT {HTMLayoutResourceType}; initiator : HELEMENT ) : HLDOM_RESULT; stdcall;

(*
 *  HTMLayoutSendRequest - send GET or POST request for the element
 *
 * event handler on the 'he' element (if any) will be notified 
 * when data will be ready by receiving HANDLE_DATA_DELIVERY event.
 *
*)
function  HTMLayoutHttpRequest( he : HELEMENT; url : LPCWSTR; dataType : UINT {HTMLayoutResourceType}; requestType : UINT {HTMLayoutRequestType}; requestParams : PREQUEST_PARAM; nParams : UINT ) : HLDOM_RESULT; stdcall;

(* HTMLayoutGetScrollInfo  - get scroll info of element with overflow:scroll or auto.
 * param[in] he HELEMENT, element.
 * param[out] scrollPos LPPOINT, scroll position.
 * param[out] viewRect LPRECT, position of element scrollable area, content box minus scrollbars.
 * param[out] contentSize LPSIZE, size of scrollable element content.
*)
function  HTMLayoutGetScrollInfo( he : HELEMENT; var scrollPos : TPOINT; var viewRect : TRECT; var contentSize : UINT ) : HLDOM_RESULT; stdcall;

(* HTMLayoutSetScrollPos  - set scroll position of element with overflow:scroll or auto.
 * param[in] he HELEMENT, element.
 * param[in] scrollPos POINT, new scroll position.
 * param[in] smooth BOOL, TRUE - do smooth scroll.
*)
function  HTMLayoutSetScrollPos( he : HELEMENT; scrollPos : TPOINT; smooth : BOOL ) : HLDOM_RESULT; stdcall;

(* HTMLayoutGetElementIntrinsicWidths  - get min-intrinsic and max-intrinsic widths of the element.
 * param[in] he HELEMENT, element.
 * param[out] pMinWidth INT*, calculated min-intrinsic width.
 * param[out] pMaxWidth INT*, calculated max-intrinsic width.
 **)
// Read http://rsdn.ru/forum/htmlayout/3579528.all
function  HTMLayoutGetElementIntrinsicWidths( he : HELEMENT; var pMinWidth : integer; var pMaxWidth : integer ) : HLDOM_RESULT; stdcall;

(* HTMLayoutGetElementIntrinsicHeight  - get min-intrinsic height of the element calculated for forWidth.
 * param[in] he HELEMENT, element.
 * param[in] forWidth INT*, width to calculate intrinsic height for.
 * param[out] pHeight INT*, calculated min-intrinsic height.
*)
function  HTMLayoutGetElementIntrinsicHeight( he : HELEMENT; forWidth : integer; var pHeight : integer ) : HLDOM_RESULT; stdcall;

(* HTMLayoutIsElementVisible - deep visibility, determines if element visible - has no visiblity:hidden and no display:none defined 
    for itself or for any its parents.
 * param[in] he HELEMENT, element.
 * param[out] pVisible LPBOOL, visibility state.
*)
function  HTMLayoutIsElementVisible( he : HELEMENT; var pVisible : BOOL ) : HLDOM_RESULT; stdcall;

(* HTMLayoutIsElementEnabled - deep enable state, determines if element enabled - is not disabled by itself or no one  
    of its parents is disabled.
 * param[in] he HELEMENT, element.
 * param[out] pEnabled LPBOOL, enabled state.
*)
function  HTMLayoutIsElementEnabled( he : HELEMENT; var pEnabled : BOOL ) : HLDOM_RESULT; stdcall;

(* HTMLayoutSortElements - sort children of the element.
 * param[in] he HELEMENT, element which children to be sorted.
 * param[in] firstIndex UINT, first child index to start sorting from.
 * param[in] lastIndex UINT, last index of the sorting range, element with this index will not be included in the sorting.
 * param[in] cmpFunc ELEMENT_COMPARATOR, comparator function.
 * param[in] cmpFuncParam LPVOID, parameter to be passed in comparator function.
*)
function  HTMLayoutSortElements( he : HELEMENT; firstIndex : UINT; lastIndex : UINT; cmpFunc : HTMLayoutElementComparator; cmpFuncParam : POINTER ) : HLDOM_RESULT; stdcall;

(* HTMLayoutSwapElements - swap element positions.
 * Function changes "insertion points" of two elements. So it swops indexes and parents of two elements.
 * param[in] he1 HELEMENT, first element.
 * param[in] he2 HELEMENT, second element.
*)
function  HTMLayoutSwapElements( he1 : HELEMENT; he2 : HELEMENT ) : HLDOM_RESULT; stdcall;

(* HTMLayoutTraverseUIEvent - traverse (sink-and-bubble) MOUSE or KEY event.
 * param[in] evt EVENT_GROUPS, either HANDLE_MOUSE or HANDLE_KEY code.
 * param[in] eventCtlStruct LPVOID, pointer on either MOUSE_PARAMS or KEY_PARAMS structure.
 * param[out] bOutProcessed LPBOOL, pointer to BOOL receiving TRUE if event was processed by some element and FALSE otherwise.
*)
function  HTMLayoutTraverseUIEvent( evt : UINT; eventCtlStruct : POINTER; var bOutProcessed : BOOL ) : HLDOM_RESULT; stdcall;

(* HTMLayoutProcessUIEvent - request to process MOUSE or KEY on single element without bubbling.
 * param[in] he HELEMENT, element to process event on.
 * param[in] evt EVENT_GROUPS, either HANDLE_MOUSE or HANDLE_KEY code.
 * param[in] eventCtlStruct LPVOID, pointer on either MOUSE_PARAMS or KEY_PARAMS structure.
 * param[out] bOutProcessed LPBOOL, pointer to BOOL receiving TRUE if event was processed by some element and FALSE otherwise.
*)
function  HTMLayoutProcessUIEvent( he : HELEMENT; evt : UINT; eventCtlStruct : LPVOID; bOutProcessed : LPBOOL ) : HLDOM_RESULT; stdcall;

(* HTMLayoutControlGetType - get type of control - type of behavior assigned to the element.
 * param[in] he HELEMENT, element.
 * param[out] pType UINT*, pointer to variable receiving control type,
 *             for list of values see CTL_TYPE.
*)
function  HTMLayoutControlGetType( he : HELEMENT; var pType : UINT {HTMLayoutCtlType} ) : HLDOM_RESULT; stdcall;

(* HTMLayoutControlGetValue - get value of the control.
 * param[in] he HELEMENT, element.
 * param[out] pVal VALUE*, pointer to variable receiving control value. After use of this value ValueClear MUST be 
 *                             called on it. Otherwise memory leak will happen!
 *
 * *pVal - variable shall be properly initialized before the call
 *
*)
// ATTENTION:
// ATTENTION:
// ATTENTION: ValueClear(pVal); must be called at some point HTMLayoutControlGetValue use.
// ATTENTION:
// ATTENTION:

function  HTMLayoutControlGetValue( he : HELEMENT; pVal : PRHtmlValue ) : HLDOM_RESULT; stdcall;

(* HTMLayoutControlSetValue - set value of the control and update UI.
 * param[in] he HELEMENT, element.
 * param[in] pVal const JSON_VALUE*, pointer to variable to set value from.
 *
 * *pVal - variable shall contain valid JSON_VALUE. 
 *
*)
function  HTMLayoutControlSetValue( he : HELEMENT; const pVal : PRHtmlValue ) : HLDOM_RESULT; stdcall;

(* HTMLayoutEnumerate - character by character enumeartion of the dom.
 * param[in] he HELEMENT, element.
 * param[in] pcb HTMLayoutEnumearationCallback, pointer to function that is called on each character position.
 * param[in] forward BOOL, direction of the enumeration, TRUE - forward.
 *
*)
function  HTMLayoutEnumerate( he : HELEMENT; pcb : HTMLayoutEnumerationCallback; p : POINTER; forward : BOOL ) : HLDOM_RESULT; stdcall;

(* HTMLayoutGetCharacterRect - position of single character on the screen.
 * param[in] he HELEMENT, element.
 * param[in] pos int, index of the character in the he element.
 * param[out] outRect RECT, rectangle that will receive view relative coordinates of the character placeholder.
*)
function  HTMLayoutGetCharacterRect( he : HELEMENT; pos : UINT; var outRect : TRECT ) : HLDOM_RESULT; stdcall;

(* HTMLayoutEnumElementStyles - enums CSS rules applied to the element in its currnet state.
 * param[in] he HELEMENT, element.
 * param[in] callback HTMLayoutStyleRuleCallback*, callback function.
 * param[in] callback_prm LPVOID, parameter of the callback function.
 *
 * HTMLayoutEnumElementStyles enumerates all styles applied to the element (including master CSS rules).
 * It also reports if the element has local style attribute declaration and style attributes set in runtime.
 *
*)
function  HTMLayoutEnumElementStyles( he : HELEMENT; callback : HTMLayoutStyleRuleCallback; callback_prm : Pointer ) : HLDOM_RESULT; stdcall;

(* HTMLayoutElementSetExpando - allows to associate user struct or class (Expando) with the DOM element.
 * param[in] he HELEMENT, element.
 * param[in] pExpando HTMLayoutElementExpando*, ptr to user object of class derived from HTMLayoutElementExpando.
 *
 * HTMLayoutElementSetExpando together with HTMLayoutElementGetExpando allows to associate user struct or class (Expando) with the DOM element.
 * see dom::expando in htmlayout_dom.hpp
 *
*)
function  HTMLayoutElementSetExpando( he : HELEMENT; pExpando : HTMLayoutElementExpando ) : HLDOM_RESULT; stdcall;

(* HTMLayoutElementGetExpando - retrives pointer to the Expando object set by HTMLayoutElementSetExpando.
 * param[in] he HELEMENT, element.
 * param[in] ppExpando HTMLayoutElementExpando**, ptr to location where to copy HTMLayoutElementExpando*.
 *
 * see dom::expando in htmlayout_dom.hpp
 *
*)
function  HTMLayoutElementGetExpando( he : HELEMENT; var ppExpando : PHTMLayoutElementExpando ) : HLDOM_RESULT; stdcall;

(* HTMLayoutMoveElement - moves element from its normal place to the position defined by xView, yView.
 *
 * param[in] he HELEMENT, element.
 * param[in] xView INT, new x coordinate of content box of the element relative to the view - htmlayout window.
 * param[in] yView INT, new y coordinate of content box of the element relative to the view - htmlayout window.
 *
 * If element is moved outside of the view then HTMLayoutMoveElement will create popup window for it.
 *
*)
function  HTMLayoutMoveElement( he : HELEMENT; xView, yView : integer ) : HLDOM_RESULT; stdcall;

(* HTMLayoutMoveElementEx - moves and resizes the element from its normal place to the position defined by xView, yView.
 *
 * param[in] he HELEMENT, element.
 * param[in] xView INT, new x coordinate of content box of the element relative to the view - htmlayout window.
 * param[in] yView INT, new y coordinate of content box of the element relative to the view - htmlayout window.
 * param[in] width INT, new width of content box of the element relative to the view - htmlayout window.
 * param[in] height INT, new height of content box of the element relative to the view - htmlayout window.
 *
 * If element is moved outside of the view then HTMLayoutMoveElement will create popup window for it.
 *
*)
function  HTMLayoutMoveElementEx( he : HELEMENT; xView, yView, width, height : integer ) : HLDOM_RESULT; stdcall;

(* HTMLayoutAnimateElement - starts animation of the element.
  * HTMLayoutElementAnimator function does the animation. It defines what and how to animate the element.
  * param[in] he HELEMENT, element that will be animated.
  * param[in] pAnimator HTMLayoutElementAnimator*, animator worker function.
  * param[in] animatorParam LPVOID, parameter passed "as is" to the HTMLayoutElementAnimator function.
*)
function  HTMLayoutAnimateElement( he : HELEMENT; pAnimator : HTMLayoutElementAnimator; animatorParam : Pointer ) : HLDOM_RESULT; stdcall;

// Allows to defer measuring of scrollable elements. See: /htmlayoutsdk/include/behaviors/behavior_splitter.cpp and /htmlayoutsdk/html_samples/behaviors/splitters.htm
function  HTMLayoutEnqueueMeasure( he : HELEMENT ) : HLDOM_RESULT; stdcall;

(* HTMLayoutParseValue - parses JSON forrmatted text (data).
 * param[in] text LPCWSTR, json text.
 * param[in] textLength UINT, length of json text.
 * param[in] mode UINT, parsing mode: 0 - closed json literal, 1 - open-map mode.
 * param[out] pVal JSON_VALUE *, ptr to location where to store parsed value.
 *
 * return UINT - number of characters that was not parsed due to some error,
 *                   so 0 means success - whole text was parsed.
 *
 * HTMLayoutParseValue uses relaxed JSON rules, e.g.
 *   { one:1 2:two }
 * is a valid input. In strict JSON that sample above must be written as:
 *   { "one":1, 2:"two" }
 * see http://json.org
*)
function  HTMLayoutParseValue( text : LPCWSTR; textLength : UINT; mode : UINT; pVal : PRHtmlValue ) : UINT; stdcall;

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
function  HTMLayoutGetElementLocation( he : HELEMENT; var p_location : TRect; areas : UINT {HTMLAYOUT_ELEMENT_AREAS} ) : HLDOM_RESULT; external HTMLayoutDLL; stdcall;
function  HTMLayoutScrollToView( he : HELEMENT; flags : UINT {HTMLAYOUT_SCROLL_FLAGS} ) : HLDOM_RESULT; external HTMLayoutDLL; stdcall;
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
function  HTMLayoutProcessUIEvent( he : HELEMENT; evt : UINT; eventCtlStruct : LPVOID; bOutProcessed : LPBOOL ) : HLDOM_RESULT; external HTMLayoutDLL; stdcall;
function  HTMLayoutControlGetType( he : HELEMENT; var pType : UINT ) : HLDOM_RESULT; external HTMLayoutDLL; stdcall;
function  HTMLayoutControlGetValue( he : HELEMENT; pVal : PRHtmlValue ) : HLDOM_RESULT; external HTMLayoutDLL; stdcall;
function  HTMLayoutControlSetValue( he : HELEMENT; const pVal : PRHtmlValue ) : HLDOM_RESULT; external HTMLayoutDLL; stdcall;
function  HTMLayoutEnumerate( he : HELEMENT; pcb : HTMLayoutEnumerationCallback; p : POINTER; forward : BOOL ) : HLDOM_RESULT; external HTMLayoutDLL; stdcall;
function  HTMLayoutGetCharacterRect( he : HELEMENT; pos : UINT; var outRect : TRECT ) : HLDOM_RESULT; external HTMLayoutDLL; stdcall;
function  HTMLayoutEnumElementStyles( he : HELEMENT; callback : HTMLayoutStyleRuleCallback; callback_prm : Pointer ) : HLDOM_RESULT; external HTMLayoutDLL; stdcall;
function  HTMLayoutElementSetExpando( he : HELEMENT; pExpando : HTMLayoutElementExpando ) : HLDOM_RESULT; external HTMLayoutDLL; stdcall;
function  HTMLayoutElementGetExpando( he : HELEMENT; var ppExpando : PHTMLayoutElementExpando ) : HLDOM_RESULT; external HTMLayoutDLL; stdcall;
function  HTMLayoutMoveElement( he : HELEMENT; xView, yView : integer ) : HLDOM_RESULT; external HTMLayoutDLL; stdcall;
function  HTMLayoutMoveElementEx( he : HELEMENT; xView, yView, width, height : integer ) : HLDOM_RESULT; external HTMLayoutDLL; stdcall;
function  HTMLayoutAnimateElement( he : HELEMENT; pAnimator : HTMLayoutElementAnimator; animatorParam : Pointer ) : HLDOM_RESULT; external HTMLayoutDLL; stdcall;
function  HTMLayoutEnqueueMeasure( he : HELEMENT ) : HLDOM_RESULT; external HTMLayoutDLL; stdcall;
function  HTMLayoutParseValue( text : LPCWSTR; textLength : UINT; mode : UINT; pVal : PRHtmlValue ) : UINT; external HTMLayoutDLL; stdcall;


end.

