unit HtmlTypes;

interface

uses Windows
    , HtmlCommon
;

// HTMLayout API documentation http://www.terrainformatica.com/htmlayout/doxydoc/index.html

const
    HLN_CREATE_CONTROL          = $AFF + $01;
    HLN_LOAD_DATA               = $AFF + $02;
    HLN_CONTROL_CREATED         = $AFF + $03;
    HLN_DATA_LOADED             = $AFF + $04;
    HLN_DOCUMENT_COMPLETE       = $AFF + $05;
    HLN_UPDATE_UI               = $AFF + $06;
    HLN_DESTROY_CONTROL         = $AFF + $07;
    HLN_ATTACH_BEHAVIOR         = $AFF + $08;
    HLN_BEHAVIOR_CHANGED        = $AFF + $09;
    HLN_DIALOG_CREATED          = $AFF + $10;
    HLN_DIALOG_CLOSE_RQ         = $AFF + $0A;
    HLN_DOCUMENT_LOADED         = $AFF + $0B;

    LOAD_OK                     = 0;
    LOAD_DISCARD                = 1;

    HLDOM_OK_NOT_HANDLED        = -1;

    INSERT_AT_END               = $7FFFFFF;


    // HTMLUpdateElementFlags
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

    NMHL_LOAD_DATA = record
        hdr                     : NMHDR; // Default WM_NOTIFY header
        uri                     : LPCWSTR; // [in] Zero terminated string, fully qualified uri, for example "http://server/folder/file.ext"
        outData                 : PBYTE; // [out] pointer to loaded data
        outDataSize             : UINT; // [out] loaded data size
        dataType                : UINT; // [in] HTMLayoutResourceType
        principal               : HELEMENT; // [in] element requested download, in case of context_menu:url( menu-url ) it is an element for which context menu was requested
        initiator               : HELEMENT;
    end;
    PNMHL_LOAD_DATA = ^NMHL_LOAD_DATA;

{
  NMHL_DATA_LOADED = record
    Hdr: NMHDR;
    Uri: LPCWSTR;
    Data: LPCBYTE;
    DataSize: DWORD;
    DataType: UINT;
    Status: UINT;
  end;
  PNMHL_DATA_LOADED = ^NMHL_DATA_LOADED;
}


    HTMLayoutCallback        = function( uMsg : UINT; wParam : WPARAM; lParam : LPARAM; vParam : Pointer ) : LRESULT stdcall;
    HTMLayoutHElementEvent   = function( tag : Pointer; he : HELEMENT; evtg: UINT; prms : Pointer ) : BOOL stdcall;

    HLDOM_RESULT = (
        HLDOM_OK                = 0, // function completed successfully
        HLDOM_INVALID_HWND      = 1, // invalid HWND
        HLDOM_INVALID_HANDLE    = 2, // invalid HELEMENT
        HLDOM_PASSIVE_HANDLE    = 3, // attempt to use HELEMENT which is not marked by HTMLayout_UseElement()
        HLDOM_INVALID_PARAMETER = 4, // parameter is invalid, e.g. pointer is null
        HLDOM_OPERATION_FAILED  = 5  // operation failed, e.g. invalid html in HTMLayoutSetElementHtml()
    );

    HTMLayoutModes = (
        HLM_LAYOUT_ONLY         = 0, // layout manager and renderer.
        HLM_SHOW_SELECTION      = 1  // layout manager and renderer + text selection and WM_COPY.
    );

    HTMLayoutElementAreas = (
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

    HTMLayoutScrollFlags = (
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

implementation

end.