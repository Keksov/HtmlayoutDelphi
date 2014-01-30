unit HtmlBehaviour;

interface

uses Windows
    , HtmlTypes
;

// HTMLayout API documentation http://www.terrainformatica.com/htmlayout/doxydoc/index.html

const
    // enum EVENT_GROUPS
    HANDLE_INITIALIZATION       = $0000; (* attached/detached *)
    HANDLE_MOUSE                = $0001; (* mouse events *)
    HANDLE_KEY                  = $0002; (* key events *)
    HANDLE_FOCUS                = $0004; (* focus events, if this flag is set it also means that element it attached to is focusable *)
    HANDLE_SCROLL               = $0008; (* scroll events *)
    HANDLE_TIMER                = $0010; (* timer event *)
    HANDLE_SIZE                 = $0020; (* size changed event *)
    HANDLE_DRAW                 = $0040; (* drawing request (event) *)
    HANDLE_DATA_ARRIVED         = $0080; (* requested data () has been delivered *)
    HANDLE_BEHAVIOR_EVENT       = $0100; (* secondary, synthetic events: BUTTON_CLICK, HYPERLINK_CLICK, etc., a.k.a. notifications from intrinsic behaviors *)
    HANDLE_METHOD_CALL          = $0200; (* behavior specific methods *)
    HANDLE_EXCHANGE             = $1000; (* system drag-n-drop *)
    HANDLE_GESTURE              = $2000; (* touch input events *)
    HANDLE_ALL                  = $FFFF; (* all of them *)
    (* disable INITIALIZATION events to be sent. normally engine sends BEHAVIOR_DETACH / BEHAVIOR_ATTACH events unconditionally, this flag allows to disable this behavior *)
    DISABLE_INITIALIZATION      = $80000000;

    ALL_CMD                     = HANDLE_ALL;

    // enum PHASE_MASK, see: http://www.w3.org/TR/xml-events/Overview.html#s_intro
    BUBBLING                    = 0; // bubbling (emersion) phase
    SINKING                     = $08000; // capture (immersion) phase, this flag is or'ed with EVENTS codes below
    HANDLED                     = $10000; // event already processed.

    // enum MOUSE_BUTTONS
    MAIN_MOUSE_BUTTON           = $01; //aka left button
    PROP_MOUSE_BUTTON           = $02; //aka right button
    MIDDLE_MOUSE_BUTTON         = $04;
    X1_MOUSE_BUTTON             = $08;
    X2_MOUSE_BUTTON             = $10;

    // enum KEYBOARD_STATES
    CONTROL_KEY_PRESSED         = $1;
    SHIFT_KEY_PRESSED           = $2;
    ALT_KEY_PRESSED             = $4;

    // parameters of evtg == HANDLE_INITIALIZATION

    // enum INITIALIZATION_EVENTS
    INITIALIZATION_ALL          = ALL_CMD; // Delphi specific constant
    BEHAVIOR_DETACH             = 0;
    BEHAVIOR_ATTACH             = 1;

    //enum DRAGGING_TYPE
    NO_DRAGGING                 = 0;
    DRAGGING_MOVE               = 1;
    DRAGGING_COPY               = 2;

    // parameters of evtg == HANDLE_MOUSE

    //enum MOUSE_EVENTS
    MOUSE_ALL                   = ALL_CMD; // Delphi specific constant
    MOUSE_ENTER                 = 0;
    MOUSE_LEAVE                 = 1;
    MOUSE_MOVE                  = 2;
    MOUSE_UP                    = 3;
    MOUSE_DOWN                  = 4;
    MOUSE_CLICK                 = $FF; // mouse click event
    MOUSE_DCLICK                = 5;
    MOUSE_WHEEL                 = 6;
    MOUSE_TICK                  = 7; // mouse pressed ticks
    MOUSE_IDLE                  = 8; // mouse stay idle for some time
    DROP                        = 9;  // item dropped; target is that dropped item
    DRAG_ENTER                  = $A; // drag arrived to the target element that is one of current drop targets.
    DRAG_LEAVE                  = $B; // drag left one of current drop targets. target is the drop target element.
    DRAG_REQUEST                = $C; // drag src notification before drag start. To cancel - return true from handler.

    DRAGGING                    = $100; // This flag is 'ORed' with MOUSE_ENTER..MOUSE_DOWN codes if dragging operation is in effect.
                                       // E.g. event DRAGGING | MOUSE_MOVE is sent to underlying DOM elements while dragging.

    // enum CURSOR_TYPE
    CURSOR_ARROW                = 0;
    CURSOR_IBEAM                = 1;
    CURSOR_WAIT                 = 2;
    CURSOR_CROSS                = 3;
    CURSOR_UPARROW              = 4;
    CURSOR_SIZENWSE             = 5;
    CURSOR_SIZENESW             = 6;
    CURSOR_SIZEWE               = 7;
    CURSOR_SIZENS               = 8;
    CURSOR_SIZEALL              = 9;
    CURSOR_NO                   = 10;
    CURSOR_APPSTARTING          = 11;
    CURSOR_HELP                 = 12;
    CURSOR_HAND                 = 13;
    CURSOR_DRAG_MOVE            = 14;
    CURSOR_DRAG_COPY            = 15;

    // parameters of evtg == HANDLE_KEY

    // enum KEY_EVENTS
    KEY_ALL                     = ALL_CMD; // Delphi specific constant
    KEY_DOWN                    = 0;
    KEY_UP                      = 1;
    KEY_CHAR                    = 2;


    // parameters of evtg == HANDLE_FOCUS

    // focus event dispatch details:
    //   First: element that has focus before will get FOCUS_LOST (and its parents will get FOCUS_LOST | SINKING)
    //          FOCUS_PARAMS.target in this event points to the new focus candidate element.
    //          FOCUS_PARAMS.cancel at this point can be set to TRUE to canel focus assignment/
    //          In FOCUS_LOST HTMLayoutGetFocusElement(HWND hwnd, HELEMENT *phe) will return reference to old focus element.
    //
    //   Second: system will set internal variable "current_focus" to the new focus. After that
    //          HTMLayoutGetFocusElement(HWND hwnd, HELEMENT *phe) will return new focus element
    //
    //   Third: element that is getting focus gets FOCUS_GOT (and its parents will get FOCUS_GOT | SINKING)
    //          FOCUS_PARAMS.target in this event points to the old focus element.
    //          FOCUS_PARAMS.cancel has no effect.

    // enum FOCUS_EVENTS
    FOCUS_ALL                   = ALL_CMD; // Delphi specific constant
    FOCUS_LOST                  = 0;
    FOCUS_GOT                   = 1;

    // enum FOCUS_CAUSE
    BY_CODE                     = 0;
    BY_MOUSE                    = 1;
    BY_KEY_NEXT                 = 2;
    BY_KEY_PREV                 = 3;

    // parameters of evtg == HANDLE_SCROLL

    // enum SCROLL_EVENTS
    SCROLL_ALL                  = ALL_CMD; // Delphi specific constant
    SCROLL_HOME                 = 0;
    SCROLL_END                  = 1;
    SCROLL_STEP_PLUS            = 2;
    SCROLL_STEP_MINUS           = 3;
    SCROLL_PAGE_PLUS            = 4;
    SCROLL_PAGE_MINUS           = 5;
    SCROLL_POS                  = 6;
    SCROLL_SLIDER_RELEASED      = 7;

    // enum GESTURE_CMD
    GESTURE_ALL                 = ALL_CMD; // Delphi specific constant
    GESTURE_REQUEST             = 0; // return true and fill flags if it will handle gestures.
    GESTURE_ZOOM                = 1; // The zoom gesture.
    GESTURE_PAN                 = 2; // The pan gesture.
    GESTURE_ROTATE              = 3; // The rotation gesture.
    GESTURE_TAP1                = 4; // The tap gesture.
    GESTURE_TAP2                = 5;  // The two-finger tap gesture.

    // enum GESTURE_STATE
    GESTURE_STATE_BEGIN         = 1; // starts
    GESTURE_STATE_INERTIA       = 2; // events generated by inertia processor
    GESTURE_STATE_END           = 4;  // end, last event of the gesture sequence

    // enum GESTURE_TYPE_FLAGS // requested
    GESTURE_FLAG_ZOOM             = $0001;
    GESTURE_FLAG_ROTATE           = $0002;
    GESTURE_FLAG_PAN_VERTICAL     = $0004;
    GESTURE_FLAG_PAN_HORIZONTAL   = $0008;
    GESTURE_FLAG_TAP1             = $0010; // press & tap
    GESTURE_FLAG_TAP2             = $0020; // two fingers tap
    GESTURE_FLAG_PAN_WITH_GUTTER  = $4000; // PAN_VERTICAL and PAN_HORIZONTAL modifiers
    GESTURE_FLAG_PAN_WITH_INERTIA = $8000; //
    GESTURE_FLAGS_ALL             = $FFFF; //

    // Draw events
    DRAW_ALL                    = ALL_CMD; // Delphi specific constant
    DRAW_BACKGROUND             = 0;
    DRAW_CONTENT                = 1;
    DRAW_FOREGROUND             = 2;

    // Exchange events

    // enum EXCHANGE_EVENTS
    X_DRAG_ENTER                = 0;
    X_DRAG_LEAVE                = 1;
    X_DRAG                      = 2;
    X_DROP                      = 3;

    // enum EXCHANGE_DATA_TYPE
    EXF_UNDEFINED               = 0;
    EXF_TEXT                    = $01; // FETCH_EXCHANGE_DATA will receive UTF8 encoded string - plain text
    EXF_HTML                    = $02; // FETCH_EXCHANGE_DATA will receive UTF8 encoded string - html
    EXF_HYPERLINK               = $04; // FETCH_EXCHANGE_DATA will receive UTF8 encoded string with pair url\0caption (null separated)
    EXF_JSON                    = $08; // FETCH_EXCHANGE_DATA will receive UTF8 encoded string with JSON literal
    EXF_FILE                    = $10; // FETCH_EXCHANGE_DATA will receive UTF8 encoded list of file names separated by nulls

    // enum EXCHANGE_COMMANDS
    EXC_ALL                     = ALL_CMD; // Delphi specific constant
    EXC_NONE                    = 0;
    EXC_COPY                    = 1;
    EXC_MOVE                    = 2;
    EXC_LINK                    = 4;

    // enum EVENT_REASON
    BY_MOUSE_CLICK              = 0;
    BY_KEY_CLICK                = 1;
    SYNTHESIZED                 = 2; // synthesized, programmatically generated.

    // enum EDIT_CHANGED_REASON
    BY_INS_CHAR                 = 3; // single char insertion
    BY_INS_CHARS                = 4; // character range insertion, clipboard
    BY_DEL_CHAR                 = 5; // single char deletion
    BY_DEL_CHARS                = 6; // character range deletion (selection)

    // identifiers of methods currently supported by intrinsic behaviors,
    // see function HTMLayoutCallMethod

    BEHAVIOR_ALL                = ALL_CMD; // Delphi specific constant

    // enum BEHAVIOR_METHOD_IDENTIFIERS
    DO_CLICK                    = 0;
    GET_TEXT_VALUE              = 1;
    SET_TEXT_VALUE              = 2;

    // p - TEXT_VALUE_PARAMS
    TEXT_EDIT_GET_SELECTION     = 3;

    // p - TEXT_EDIT_SELECTION_PARAMS
    TEXT_EDIT_SET_SELECTION     = 4;

    // p - TEXT_EDIT_SELECTION_PARAMS
    // Replace selection content or insert text at current caret position.
    // Replaced text will be selected.
    TEXT_EDIT_REPLACE_SELECTION = 5;

    // p - TEXT_EDIT_REPLACE_SELECTION_PARAMS
    // Set value of type="vscrollbar"/"hscrollbar"
    SCROLL_BAR_GET_VALUE        = 6;
    SCROLL_BAR_SET_VALUE        = 7;

    // get current caret position, it returns rectangle that is relative to origin of the editing element.
    TEXT_EDIT_GET_CARET_POSITION= 8;

    // p - TEXT_CARET_POSITION_PARAMS

    TEXT_EDIT_GET_SELECTION_TEXT= 9; // p - TEXT_SELECTION_PARAMS, OutputStreamProc will receive stream of WCHARs
    TEXT_EDIT_GET_SELECTION_HTML= $A; // p - TEXT_SELECTION_PARAMS, OutputStreamProc will receive stream of BYTEs - utf8 encoded html fragment.
    TEXT_EDIT_CHAR_POS_AT_XY    = $B; // p - TEXT_EDIT_CHAR_POS_AT_XY_PARAMS

    IS_EMPTY                    = $FC; // p - IS_EMPTY_PARAMS // set VALUE_PARAMS::is_empty (false/true) reflects :empty state of the element.
    GET_VALUE                   = $FD; // p - VALUE_PARAMS
    SET_VALUE                   = $FE; // p - VALUE_PARAMS

    XCALL                       = $FF; // p - XCALL_PARAMS
    FIRST_APPLICATION_METHOD_ID = $100;

type
    HTMLayoutElementCallback = function( he : HELEMENT; param : Pointer ) : BOOL; stdcall;

    HTMLayoutPhase = record // see THTMLayoutEvent.phase
        code                    : UINT;
        bubbling                : boolean;
        sinking                 : boolean;
        handled                 : boolean;
    end;

    //struct INITIALIZATION_PARAMS
    HTMLayoutInitializationParams = record
        cmd                     : UINT; // INITIALIZATION_EVENTS
    end;
    PHTMLayoutInitializationParams = ^HTMLayoutInitializationParams;

    //struct MOUSE_PARAMS
    HTMLayoutMouseParams = record
        cmd                     : UINT; // MOUSE_EVENTS
        target                  : HELEMENT; // target element
        pos                     : TPOINT; // position of cursor, element relative
        pos_document            : TPOINT; // position of cursor, document root relative
        button_state            : UINT; // MOUSE_BUTTONS or MOUSE_WHEEL_DELTA
        alt_state               : UINT; // KEYBOARD_STATES
        cursor_type             : UINT; // CURSOR_TYPE to set, see CURSOR_TYPE
        is_on_icon              : BOOL; // mouse is over icon (foreground-image, foreground-repeat:no-repeat)
        dragging                : HELEMENT; // element that is being dragged over, this field is not NULL if (cmd & DRAGGING) != 0
        dragging_mode           : UINT; // see DRAGGING_TYPE.
    end;
    PHTMLayoutMouseParams = ^HTMLayoutMouseParams;

    HTMLayoutMouseCmd = record
        case t : byte of
        0 : (
            phase               : HTMLayoutPhase
        );
        1 : (
            code                : UINT;
            bubbling            : boolean;
            sinking             : boolean;
            handled             : boolean;
            dragging            : boolean;
        );
    end;

    // struct KEY_PARAMS
    HTMLayoutKeyParams = record
        cmd                     : UINT; // KEY_EVENTS
        target                  : HELEMENT; // target element
        key_code                : UINT; // key scan code, or character unicode for KEY_CHAR
        alt_state               : UINT; // KEYBOARD_STATES
    end;
    PHTMLayoutKeyParams = ^HTMLayoutKeyParams;

    // struct FOCUS_PARAMS
    HTMLayoutFocusParams = record
        cmd                     : UINT; // FOCUS_EVENTS
        target                  : HELEMENT; // target element, for FOCUS_LOST it is a handle of new focus element and for FOCUS_GOT it is a handle of old focus element, can be NULL
        by_mouse_click          : BOOL; // TRUE if focus is being set by mouse click
        cancel                  : BOOL; // in FOCUS_LOST phase setting this field to TRUE will cancel transfer focus from old element to the new one.
    end;
    PHTMLayoutFocusParams = ^HTMLayoutFocusParams;

    // struct SCROLL_PARAMS
    HTMLayoutScrollParams = record
        cmd                     : UINT; // SCROLL_EVENTS
        target                  : HELEMENT; // target element
        pos                     : integer; // scroll position if SCROLL_POS
        vertical                : BOOL; // TRUE if from vertical scrollbar
    end;
    PHTMLayoutScrollParams = ^HTMLayoutScrollParams;

    // struct GESTURE_PARAMS
    HTMLayoutGestureParams = record
        cmd                     : UINT; // GESTURE_CMD
        target                  : HELEMENT; // target element
        pos                     : TPOINT; // position of cursor, element relative
        pos_view                : TPOINT; // position of cursor, view relative
        flags                   : UINT; // for GESTURE_REQUEST combination of GESTURE_FLAGs. for others it is a combination of GESTURE_STATe's
        delta_time              : UINT; // period of time from previous event.
        delta_xy                : SIZE; // for GESTURE_PAN it is a direction vector
        delta_v                 : double; // for GESTURE_ROTATE - delta angle (radians) for GESTURE_ZOOM - zoom value, is less or greater than 1.0
    end;
    PHTMLayoutGestureParams = ^HTMLayoutGestureParams;

    // Use ::GetTextColor(hdc) to get current text color of the element while drawing
    HTMLayoutDrawParams = record
        cmd                     : UINT; // DRAW_EVENTS
        hdc                     : HDC; // hdc to paint on
        area                    : TRECT; // element area to paint,
        reserved                : UINT; //   for DRAW_BACKGROUND/DRAW_FOREGROUND - it is a border box, for DRAW_CONTENT - it is a content box
    end;
    PHTMLayoutDrawParams = ^HTMLayoutDrawParams;

    //struct EXCHANGE_PARAMS;
    PHTMLayoutExchangeParams = ^HTMLayoutExchangeParams;
    //typedef BOOL CALLBACK FETCH_EXCHANGE_DATA(EXCHANGE_PARAMS* params, UINT data_type, LPCBYTE* ppDataStart, UINT* pDataLength );
    HTMLayoutFetchExchangeDataCallback = function( params : PHTMLayoutExchangeParams; data_type : UINT; var ppDataStart : PByte; var pDataLength : UINT ) : BOOL; stdcall;

    // struct EXCHANGE_PARAMS
    HTMLayoutExchangeParams = record
        cmd                     : UINT; // EXCHANGE_EVENTS
        target                  : HELEMENT; // target element
        pos                     : TPOINT; // position of cursor, element relative
        pos_view                : TPOINT; // position of cursor, view (window) relative
        data_types              : UINT; // combination of EXCHANGE_DATA_TYPEs above
        drag_cmd                : UINT; // EXCHANGE_COMMANDS above
        fetch_data              : HTMLayoutFetchExchangeDataCallback; // function to fetch the data of desired type.
    end;

    // enum BEHAVIOR_EVENTS
    HTMLayoutBehaviorEvents = (
        BUTTON_CLICK            = 0, // click on button
        BUTTON_PRESS            = 1, // mouse down or key down in button
        BUTTON_STATE_CHANGED    = 2, // checkbox/radio/slider changed its state/value
        EDIT_VALUE_CHANGING     = 3, // before text change
        EDIT_VALUE_CHANGED      = 4, // after text change
        SELECT_SELECTION_CHANGED = 5,  // selection in <select> changed
        SELECT_STATE_CHANGED    = 6, // node in select expanded/collapsed, heTarget is the node

        POPUP_REQUEST           = 7, // request to show popup just received, here DOM of popup element can be modifed.
        POPUP_READY             = 8, // popup element has been measured and ready to be shown on screen, here you can use functions like ScrollToView.
        POPUP_DISMISSED         = 9, // popup element is closed, here DOM of popup element can be modifed again - e.g. some items can be removed to free memory.

        MENU_ITEM_ACTIVE        = $A, // menu item activated by mouse hover or by keyboard,
        MENU_ITEM_CLICK         = $B, // menu item click,
                                       //   BEHAVIOR_EVENT_PARAMS structure layout
                                       //   BEHAVIOR_EVENT_PARAMS.cmd - MENU_ITEM_CLICK/MENU_ITEM_ACTIVE
                                       //   BEHAVIOR_EVENT_PARAMS.heTarget - the menu item, presumably <li> element
                                       //   BEHAVIOR_EVENT_PARAMS.reason - BY_MOUSE_CLICK | BY_KEY_CLICK

        CONTEXT_MENU_SETUP      = $F, // evt.he is a menu dom element that is about to be shown. You can disable/enable items in it.
        CONTEXT_MENU_REQUEST    = $10, // "right-click", BEHAVIOR_EVENT_PARAMS::he is current popup menu HELEMENT being processed or NULL.
                                       // application can provide its own HELEMENT here (if it is NULL) or modify current menu element.

        VISIUAL_STATUS_CHANGED  = $11, // broadcast notification, sent to all elements of some container being shown or hidden
        DISABLED_STATUS_CHANGED = $12, // broadcast notification, sent to all elements of some container that got new value of :disabled state

        POPUP_DISMISSING        = $13, // popup is about to be closed

        // "grey" event codes  - notfications from behaviors from this SDK
        HYPERLINK_CLICK         = $80, // hyperlink click
        TABLE_HEADER_CLICK      = $81, // click on some cell in table header,
                                       //     target = the cell,
                                       //     reason = index of the cell (column number, 0..n)
        TABLE_ROW_CLICK         = $82, // click on data row in the table, target is the row
                                       //     target = the row,
                                       //     reason = index of the row (fixed_rows..n)
        TABLE_ROW_DBL_CLICK     = $83, // mouse dbl click on data row in the table, target is the row
                                       //     target = the row,
                                       //     reason = index of the row (fixed_rows..n)

        ELEMENT_COLLAPSED       = $90, // element was collapsed, so far only behavior:tabs is sending these two to the panels
        ELEMENT_EXPANDED        = $91, // element was expanded,

        ACTIVATE_CHILD          = $92, // activate (select) child,
                                       // used for example by accesskeys behaviors to send activation request, e.g. tab on behavior:tabs.

        DO_SWITCH_TAB           = ACTIVATE_CHILD, // command to switch tab programmatically, handled by behavior:tabs
                                     // use it as HTMLayoutPostEvent(tabsElementOrItsChild, DO_SWITCH_TAB, tabElementToShow, 0);

        INIT_DATA_VIEW,                // request to virtual grid to initialize its view

        ROWS_DATA_REQUEST,             // request from virtual grid to data source behavior to fill data in the table
                                     // parameters passed throug DATA_ROWS_PARAMS structure.

        UI_STATE_CHANGED,              // ui state changed, observers shall update their visual states.
                                     // is sent for example by behavior:richtext when caret position/selection has changed.

        FORM_SUBMIT,                   // behavior:form detected submission event. BEHAVIOR_EVENT_PARAMS::data field contains data to be posted.
                                     // BEHAVIOR_EVENT_PARAMS::data is of type T_MAP in this case key/value pairs of data that is about
                                     // to be submitted. You can modify the data or discard submission by returning TRUE from the handler.
        FORM_RESET,                    // behavior:form detected reset event (from button type=reset). BEHAVIOR_EVENT_PARAMS::data field contains data to be reset.
                                     // BEHAVIOR_EVENT_PARAMS::data is of type T_MAP in this case key/value pairs of data that is about
                                     // to be rest. You can modify the data or discard reset by returning TRUE from the handler.

        DOCUMENT_COMPLETE,             // behavior:frame have complete document.

        HISTORY_PUSH,                  // behavior:history stuff
        HISTORY_DROP,
        HISTORY_PRIOR,
        HISTORY_NEXT,

        HISTORY_STATE_CHANGED,         // behavior:history notification - history stack has changed

        CLOSE_POPUP,                   // close popup request,
        REQUEST_TOOLTIP,               // request tooltip, BEHAVIOR_EVENT_PARAMS.he <- is the tooltip element.

        ANIMATION               = $A0, // animation started (reason=1) or ended(reason=0) on the element.


        FIRST_APPLICATION_EVENT_CODE = $100
        // all custom event codes shall be greater
        // than this number. All codes below this will be used
        // solely by application - HTMLayout will not intrepret it
        // and will do just dispatching.
        // To send event notifications with  these codes use
        // HTMLayoutSend/PostEvent API.
    );

    // struct BEHAVIOR_EVENT_PARAMS
    HTMLayoutBehaviorEventParams = record
        cmd                     : UINT; // HTMLayoutBehaviorEvents BEHAVIOR_EVENTS
        heTarget                : HELEMENT; // target element handler
        he                      : HELEMENT; // source element e.g. in SELECTION_CHANGED it is new selected <option>, in MENU_ITEM_CLICK it is menu item (LI) element
        reason                  : UINT; // EVENT_REASON or EDIT_CHANGED_REASON - UI action causing change. In case of custom event notifications this may be any application specific value.
        data                    : POINTER; // JSON_VALUE; // auxiliary data accompanied with the event. E.g. FORM_SUBMIT event is using this field to pass collection of values.
    end;
    PHTMLayoutBehaviorEventParams = ^HTMLayoutBehaviorEventParams;

    // struct TIMER_PARAMS
    HTMLayoutTimerParams = record
        timerId                 : cardinal; // timerId that was used to create timer by using HTMLayoutSetTimerEx
    end;
    PHTMLayoutTimerParams = ^HTMLayoutTimerParams;

    // struct _METHOD_PARAMS
    // struct METHOD_PARAMS
    HTMLayoutMethodParams = record
        methodID                : UINT; // see: #BEHAVIOR_METHOD_IDENTIFIERS
    end;
    PHTMLayoutMethodParams = ^HTMLayoutMethodParams;

    // see HTMLayoutRequestElementData

    // struct DATA_ARRIVED_PARAMS
    HTMLayoutDataArrivedParams = record
        initiator               : HELEMENT; // element intiator of HTMLayoutRequestElementData request,
        data                    : PByte; // data buffer
        dataSize                : UINT; // size of data
        dataType                : UINT; // data type passed "as is" from HTMLayoutRequestElementData
        status                  : UINT; // status = 0 (dataSize == 0) - unknown error.
                                        // status = 100..505 - http response status, Note: 200 - OK!
                                        // status > 12000 - wininet error code, see ERROR_INTERNET_*** in wininet.h
        uri                     : LPCWSTR; // requested url
    end;
    PHTMLayoutDataArrivedParams = ^HTMLayoutDataArrivedParams;

    // request to data source to fill the data.
    // used by virtual-grid and virtual list
    // struct DATA_ROWS_PARAMS
    HTMLayoutDataRowsParams = record
        totalRecords            : UINT;
        firstRecord             : UINT; // first visible record - 0..totalRecords

        firstRowIdx             : UINT; // idx of the first row in the table,
        lastRowIdx              : UINT; // idx of the last row in the table. content of these rows has to be updated.
    end;
    PHTMLayoutDataRowsParams = ^HTMLayoutDataRowsParams;

{---------------------------------- THTMLayoutEvent ---------------------------}

    {***************************************************************************
    * THTMLayoutEvent
    ***************************************************************************}
    THTMLayoutEvent = class
class function controlPressed( const aParams : PHTMLayoutKeyParams ) : boolean;
class function altPressed( const aParams : PHTMLayoutKeyParams ) : boolean;
class function shiftPressed( const aParams : PHTMLayoutKeyParams ) : boolean;
class function phase( const aCmd : UINT ) : HTMLayoutPhase;
class function mouseCmd( const aParams : PHTMLayoutMouseParams ) : HTMLayoutMouseCmd;
class function leftPressed( const aParams : PHTMLayoutMouseParams ) : boolean;
class function middlePressed( const aParams : PHTMLayoutMouseParams ) : boolean;
class function rightPressed( const aParams : PHTMLayoutMouseParams ) : boolean;

    end;

implementation

uses HtmlElement;

var
    PhaseMask : UINT;

{----------------------------- THTMLayoutEvent --------------------------------}

{*******************************************************************************
* controlPressed
*******************************************************************************}
class function THTMLayoutEvent.controlPressed( const aParams : PHTMLayoutKeyParams ) : boolean;
begin
    Result := ( ( aParams.alt_state and UINT( CONTROL_KEY_PRESSED ) ) <> 0 );
end;

{*******************************************************************************
* altPressed
*******************************************************************************}
class function THTMLayoutEvent.altPressed( const aParams : PHTMLayoutKeyParams ) : boolean;
begin
    Result := ( ( aParams.alt_state and UINT( ALT_KEY_PRESSED ) ) <> 0 );
end;

{*******************************************************************************
* shiftPressed
*******************************************************************************}
class function THTMLayoutEvent.shiftPressed( const aParams : PHTMLayoutKeyParams ) : boolean;
begin
    Result := ( ( aParams.alt_state and UINT( SHIFT_KEY_PRESSED ) ) <> 0 );
end;

{*******************************************************************************
* phase
*******************************************************************************}
class function THTMLayoutEvent.phase( const aCmd : UINT ) : HTMLayoutPhase;
begin
    Result.sinking  := ( aCmd and UINT( SINKING ) ) <> 0;
    Result.handled  := ( aCmd and UINT( HANDLED ) ) <> 0;
    Result.bubbling := ( not Result.sinking ) and ( not Result.handled );
    Result.code := aCmd and PhaseMask;
end;

{*******************************************************************************
* mouseCmd
*******************************************************************************}
class function THTMLayoutEvent.mouseCmd( const aParams : PHTMLayoutMouseParams ) : HTMLayoutMouseCmd;
begin
    Result.phase := phase( aParams.cmd );
    Result.dragging := ( aParams.cmd or UINT( DRAGGING ) ) <> 0;
    Result.code := Result.code and ( not UINT( DRAGGING ) );
end;

class function THTMLayoutEvent.leftPressed( const aParams : PHTMLayoutMouseParams ) : boolean;
begin
    Result := ( aParams.button_state and MAIN_MOUSE_BUTTON ) = MAIN_MOUSE_BUTTON;
end;

class function THTMLayoutEvent.middlePressed( const aParams : PHTMLayoutMouseParams ) : boolean;
begin
    Result := ( aParams.button_state and MIDDLE_MOUSE_BUTTON ) = MIDDLE_MOUSE_BUTTON;
end;

class function THTMLayoutEvent.rightPressed( const aParams : PHTMLayoutMouseParams ) : boolean;
begin
    Result := ( aParams.button_state and PROP_MOUSE_BUTTON ) = PROP_MOUSE_BUTTON;
end;

INITIALIZATION
    PhaseMask := UINT( not ( UINT( SINKING ) or UINT( HANDLED ) ) );
end.
