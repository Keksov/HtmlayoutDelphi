unit HtmlBehaviorH;

(*
  HTMLayout License terms could be found here http://www.terrainformatica.com/htmlayout/prices.whtm
  SDK - http://www.terrainformatica.com/htmlayout/HTMLayoutSDK.zip

  Delphi binding of HTMLayout published under LGPL. Visit https://github.com/Keksov/HtmlayoutDelphi

  This file contains function and types declarations translated from include\htmlayout_behavior.h
  Most accurate documentation could be found in include\htmlayout_behavior.h itself
*)

interface

{$IFDEF USER_DEFINES_INC}{$I user_defines.inc}{$ENDIF}

uses SysUtils, Classes, Windows, Contnrs
    , HtmlTypes
;

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

{-- INITIALIZATION ------------------------------------------------------------}

    // parameters of evtg == HANDLE_INITIALIZATION

    // enum INITIALIZATION_EVENTS
    INITIALIZATION_ALL          = ALL_CMD; // Delphi specific constant
    BEHAVIOR_DETACH             = 0;
    BEHAVIOR_ATTACH             = 1;

{-- MOUSE ---------------------------------------------------------------------}

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

{-- KEY -----------------------------------------------------------------------}

    // parameters of evtg == HANDLE_KEY

    // enum KEY_EVENTS
    KEY_ALL                     = ALL_CMD; // Delphi specific constant
    KEY_DOWN                    = 0;
    KEY_UP                      = 1;
    KEY_CHAR                    = 2;

{-- FOCUS ---------------------------------------------------------------------}

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

{-- SCROLL --------------------------------------------------------------------}

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

{-- GESTURE -------------------------------------------------------------------}

    // Gesture events

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

{-- DRAW ----------------------------------------------------------------------}

    // Draw events

    DRAW_ALL                    = ALL_CMD; // Delphi specific constant
    DRAW_BACKGROUND             = 0;
    DRAW_CONTENT                = 1;
    DRAW_FOREGROUND             = 2;

{-- EXCHANGE ------------------------------------------------------------------}

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

{-- BEHAVIOR ------------------------------------------------------------------}

    // enum BEHAVIOR_EVENTS, HTMLayoutBehaviorEvents
    BEHAVIOR_ALL                = ALL_CMD; // Delphi specific constant

    BUTTON_CLICK                = 0; // click on button
    BUTTON_PRESS                = 1; // mouse down or key down in button
    BUTTON_STATE_CHANGED        = 2; // checkbox/radio/slider changed its state/value
    EDIT_VALUE_CHANGING         = 3; // before text change
    EDIT_VALUE_CHANGED          = 4; // after text change
    SELECT_SELECTION_CHANGED    = 5;  // selection in <select> changed
    SELECT_STATE_CHANGED        = 6; // node in select expanded/collapsed, heTarget is the node

    POPUP_REQUEST               = 7; // request to show popup just received, here DOM of popup element can be modifed.
    POPUP_READY                 = 8; // popup element has been measured and ready to be shown on screen, here you can use functions like ScrollToView.
    POPUP_DISMISSED             = 9; // popup element is closed, here DOM of popup element can be modifed again - e.g. some items can be removed to free memory.

    MENU_ITEM_ACTIVE            = $A; // menu item activated by mouse hover or by keyboard,
    MENU_ITEM_CLICK             = $B; // menu item click,
                                      //   BEHAVIOR_EVENT_PARAMS structure layout
                                      //   BEHAVIOR_EVENT_PARAMS.cmd - MENU_ITEM_CLICK/MENU_ITEM_ACTIVE
                                      //   BEHAVIOR_EVENT_PARAMS.heTarget - the menu item, presumably <li> element
                                      //   BEHAVIOR_EVENT_PARAMS.reason - BY_MOUSE_CLICK | BY_KEY_CLICK

    CONTEXT_MENU_SETUP          = $F;   // evt.he is a menu dom element that is about to be shown. You can disable/enable items in it.
    CONTEXT_MENU_REQUEST        = $10; // "right-click", BEHAVIOR_EVENT_PARAMS::he is current popup menu HELEMENT being processed or NULL.
                                       // application can provide its own HELEMENT here (if it is NULL) or modify current menu element.

    VISIUAL_STATUS_CHANGED      = $11; // broadcast notification, sent to all elements of some container being shown or hidden
    DISABLED_STATUS_CHANGED     = $12; // broadcast notification, sent to all elements of some container that got new value of :disabled state

    POPUP_DISMISSING            = $13; // popup is about to be closed

    // "grey" event codes  - notfications from behaviors from this SDK
    HYPERLINK_CLICK             = $80; // hyperlink click
    TABLE_HEADER_CLICK          = $81; // click on some cell in table header,
                                       //     target = the cell,
                                       //     reason = index of the cell (column number, 0..n)
    TABLE_ROW_CLICK             = $82; // click on data row in the table, target is the row
                                       //     target = the row,
                                       //     reason = index of the row (fixed_rows..n)
    TABLE_ROW_DBL_CLICK         = $83; // mouse dbl click on data row in the table, target is the row
                                       //     target = the row,
                                       //     reason = index of the row (fixed_rows..n)

    ELEMENT_COLLAPSED           = $90; // element was collapsed, so far only behavior:tabs is sending these two to the panels
    ELEMENT_EXPANDED            = $91; // element was expanded,

    ACTIVATE_CHILD              = $92; // activate (select) child,
                                       // used for example by accesskeys behaviors to send activation request, e.g. tab on behavior:tabs.

    DO_SWITCH_TAB               = ACTIVATE_CHILD; // command to switch tab programmatically, handled by behavior:tabs
                                                  // use it as HTMLayoutPostEvent(tabsElementOrItsChild, DO_SWITCH_TAB, tabElementToShow, 0);

    INIT_DATA_VIEW              = $93; // request to virtual grid to initialize its view

    ROWS_DATA_REQUEST           = $94; // request from virtual grid to data source behavior to fill data in the table
                                       // parameters passed throug DATA_ROWS_PARAMS structure.

    UI_STATE_CHANGED            = $95; // ui state changed, observers shall update their visual states.
                                       // is sent for example by behavior:richtext when caret position/selection has changed.

    FORM_SUBMIT                 = $96; // behavior:form detected submission event. BEHAVIOR_EVENT_PARAMS::data field contains data to be posted.
                                       // BEHAVIOR_EVENT_PARAMS::data is of type T_MAP in this case key/value pairs of data that is about
                                       // to be submitted. You can modify the data or discard submission by returning TRUE from the handler.

    FORM_RESET                  = $97; // behavior:form detected reset event (from button type=reset). BEHAVIOR_EVENT_PARAMS::data field contains data to be reset.
                                       // BEHAVIOR_EVENT_PARAMS::data is of type T_MAP in this case key/value pairs of data that is about
                                       // to be rest. You can modify the data or discard reset by returning TRUE from the handler.

    DOCUMENT_COMPLETE           = $98; // behavior:frame have complete document.

    HISTORY_PUSH                = $99; // behavior:history stuff
    HISTORY_DROP                = $9A;
    HISTORY_PRIOR               = $9B;
    HISTORY_NEXT                = $9C;

    HISTORY_STATE_CHANGED       = $9D; // behavior:history notification - history stack has changed

    CLOSE_POPUP                 = $9E; // close popup request,
    REQUEST_TOOLTIP             = $9F; // request tooltip, BEHAVIOR_EVENT_PARAMS.he <- is the tooltip element.

    ANIMATION                   = $A0; // animation started (reason=1) or ended(reason=0) on the element.

    FIRST_APPLICATION_EVENT_CODE = $100;
    // all custom event codes shall be greater
    // than this number. All codes below this will be used
    // solely by application - HTMLayout will not intrepret it
    // and will do just dispatching.
    // To send event notifications with  these codes use
    // HTMLayoutSend/PostEvent API.

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

{-- MOUSE ---------------------------------------------------------------------}

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

{-- KEY -----------------------------------------------------------------------}

    // struct KEY_PARAMS
    HTMLayoutKeyParams = record
        cmd                     : UINT; // KEY_EVENTS
        target                  : HELEMENT; // target element
        key_code                : UINT; // key scan code, or character unicode for KEY_CHAR
        alt_state               : UINT; // KEYBOARD_STATES
    end;
    PHTMLayoutKeyParams = ^HTMLayoutKeyParams;

{-- FOCUS ---------------------------------------------------------------------}

    // struct FOCUS_PARAMS
    HTMLayoutFocusParams = record
        cmd                     : UINT; // FOCUS_EVENTS
        target                  : HELEMENT; // target element, for FOCUS_LOST it is a handle of new focus element and for FOCUS_GOT it is a handle of old focus element, can be NULL
        by_mouse_click          : BOOL; // TRUE if focus is being set by mouse click
        cancel                  : BOOL; // in FOCUS_LOST phase setting this field to TRUE will cancel transfer focus from old element to the new one.
    end;
    PHTMLayoutFocusParams = ^HTMLayoutFocusParams;

{-- SCROLL --------------------------------------------------------------------}

    // struct SCROLL_PARAMS
    HTMLayoutScrollParams = record
        cmd                     : UINT; // SCROLL_EVENTS
        target                  : HELEMENT; // target element
        pos                     : integer; // scroll position if SCROLL_POS
        vertical                : BOOL; // TRUE if from vertical scrollbar
    end;
    PHTMLayoutScrollParams = ^HTMLayoutScrollParams;

{-- GESTURE -------------------------------------------------------------------}

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

{-- DRAW ----------------------------------------------------------------------}

    // Use ::GetTextColor(hdc) to get current text color of the element while drawing
    HTMLayoutDrawParams = record
        cmd                     : UINT; // DRAW_EVENTS
        hdc                     : HDC; // hdc to paint on
        area                    : TRECT; // element area to paint, for DRAW_BACKGROUND/DRAW_FOREGROUND - it is a border box, for DRAW_CONTENT - it is a content box
        reserved                : UINT; //
    end;
    PHTMLayoutDrawParams = ^HTMLayoutDrawParams;

{-- EXCHANGE ------------------------------------------------------------------}

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

{-- BEHAVIOR ------------------------------------------------------------------}

    // struct BEHAVIOR_EVENT_PARAMS
    HTMLayoutBehaviorEventParams = record
        cmd                     : UINT; // HTMLayoutBehaviorEvents BEHAVIOR_EVENTS
        heTarget                : HELEMENT; // target element handler
        he                      : HELEMENT; // source element e.g. in SELECTION_CHANGED it is new selected <option>, in MENU_ITEM_CLICK it is menu item (LI) element
        reason                  : UINT; // EVENT_REASON or EDIT_CHANGED_REASON - UI action causing change. In case of custom event notifications this may be any application specific value.
        data                    : POINTER; // JSON_VALUE; // auxiliary data accompanied with the event. E.g. FORM_SUBMIT event is using this field to pass collection of values.
    end;
    PHTMLayoutBehaviorEventParams = ^HTMLayoutBehaviorEventParams;

{-- TIMER ---------------------------------------------------------------------}

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

{-- DATA_ARRIVED --------------------------------------------------------------}

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

    HTMLInitializationEventHandler = function( aSender : HELEMENT;  aParams : PHTMLayoutInitializationParams; aTag : Pointer ) : boolean of object;
    HTMLMouseEventHandler = function( aSender : HELEMENT;  aParams : PHTMLayoutMouseParams; aTag : Pointer ) : boolean of object;
    HTMLKeyEventHandler   = function( aSender : HELEMENT;  aParams : PHTMLayoutKeyParams; aTag : Pointer ) : boolean of object;
    HTMLFocusEventHandler = function( aSender : HELEMENT;  aParams : PHTMLayoutFocusParams; aTag : Pointer ) : boolean of object;
    HTMLScrollEventHandler = function( aSender : HELEMENT;  aParams : PHTMLayoutScrollParams; aTag : Pointer ) : boolean of object;
    HTMLTimerEventHandler = function( aSender : HELEMENT;  aParams : PHTMLayoutTimerParams; aTag : Pointer ) : boolean of object;
    HTMLSizeEventHandler = function( aSender : HELEMENT; aTag : Pointer ) : boolean of object;
    HTMLDrawEventHandler = function( aSender : HELEMENT;  aParams : PHTMLayoutDrawParams; aTag : Pointer ) : boolean of object;
    HTMLDataArrivedEventHandler = function( aSender : HELEMENT;  aParams : PHTMLayoutDataArrivedParams; aTag : Pointer ) : boolean of object;
    HTMLBehaviorEventHandler = function( aSender : HELEMENT;  aParams : PHTMLayoutBehaviorEventParams; aTag : Pointer ) : boolean of object;
    HTMLExchangeEventHandler = function( aSender : HELEMENT;  aParams : PHTMLayoutExchangeParams; aTag : Pointer ) : boolean of object;
    HTMLGestureEventHandler = function( aSender : HELEMENT;  aParams : PHTMLayoutGestureParams; aTag : Pointer ) : boolean of object;

    HTMLEventSetProxy = function( aDomElement : HELEMENT; aEventHandler : Pointer ) : BOOL; stdcall;
    HTMLEventHandlerProxy = function( aUserData : Pointer; aSender : HELEMENT; aEventGroup : UINT; aEventHandler : Pointer ) : BOOL stdcall;


    {***************************************************************************
    * THTMLayoutEventHandler
    ***************************************************************************}
    THTMLayoutEventHandler = class
protected
    FcssSelector                : string;
    Fcallback                   : TMethod;
    FuserData                   : Pointer;
    Fcmd                        : cardinal;
    Fsubscription               : cardinal;
    FhandlerProxy               : HTMLEventHandlerProxy;
    FallEvents                  : boolean;

protected
    function    valid( aDomElement : HELEMENT ) : boolean;

public
    constructor Create( aCmd, aSubscription : cardinal; aHandlerProxy : HTMLEventHandlerProxy; const aCssSelector : string; aCallback : TMethod; aUserData : Pointer = nil );
    function    attach( aDomElement : HELEMENT ) : boolean;

    end;

    {***************************************************************************
    * THTMLayoutEvent
    * LightWeight event handling
    ***************************************************************************}
    THTMLayoutEvent = class
protected
    // top element in DOM
    FdomElement                 : HELEMENT;
    // lits of THTMLayoutEventHandler
    Fevents                     : TObjectList;

private

{-- INITIALIZATION ------------------------------------------------------------}

procedure   setOnInitialization( const aCssSelector : string; aUserEventHandler : HTMLInitializationEventHandler );
procedure   setOnBehaviorDetach( const aCssSelector : string; aUserEventHandler : HTMLInitializationEventHandler );
procedure   setOnBehaviorAttach( const aCssSelector : string; aUserEventHandler : HTMLInitializationEventHandler );

{-- MOUSE ---------------------------------------------------------------------}

procedure   setOnMouse( const aCssSelector : string; aUserEventHandler : HTMLMouseEventHandler );
procedure   setOnMouseEnter( const aCssSelector : string; aUserEventHandler : HTMLMouseEventHandler );
procedure   setOnMouseLeave( const aCssSelector : string; aUserEventHandler : HTMLMouseEventHandler );
procedure   setOnMouseMove( const aCssSelector : string; aUserEventHandler : HTMLMouseEventHandler );
procedure   setOnMouseUp( const aCssSelector : string; aUserEventHandler : HTMLMouseEventHandler );
procedure   setOnMouseDown( const aCssSelector : string; aUserEventHandler : HTMLMouseEventHandler );
procedure   setOnMouseClick( const aCssSelector : string; aUserEventHandler : HTMLMouseEventHandler );
procedure   setOnMouseDClick( const aCssSelector : string; aUserEventHandler : HTMLMouseEventHandler );
procedure   setOnMouseWheel( const aCssSelector : string; aUserEventHandler : HTMLMouseEventHandler );
procedure   setOnMouseTick( const aCssSelector : string; aUserEventHandler : HTMLMouseEventHandler );
procedure   setOnMouseIdle( const aCssSelector : string; aUserEventHandler : HTMLMouseEventHandler );
procedure   setOnDrop( const aCssSelector : string; aUserEventHandler : HTMLMouseEventHandler );
procedure   setOnDragEnter( const aCssSelector : string; aUserEventHandler : HTMLMouseEventHandler );
procedure   setOnDragLeave( const aCssSelector : string; aUserEventHandler : HTMLMouseEventHandler );
procedure   setOnDragRequest( const aCssSelector : string; aUserEventHandler : HTMLMouseEventHandler );
procedure   setOnMouseDraggingEnter( const aCssSelector : string; aUserEventHandler : HTMLMouseEventHandler );
procedure   setOnMouseDraggingLeave( const aCssSelector : string; aUserEventHandler : HTMLMouseEventHandler );
procedure   setOnMouseDraggingMove( const aCssSelector : string; aUserEventHandler : HTMLMouseEventHandler );
procedure   setOnMouseDraggingUp( const aCssSelector : string; aUserEventHandler : HTMLMouseEventHandler );
procedure   setOnMouseDraggingDown( const aCssSelector : string; aUserEventHandler : HTMLMouseEventHandler );
    
{-- KEY ----------------------------------------------------------------------}

procedure   setOnKey( const aCssSelector : string; aUserEventHandler : HTMLKeyEventHandler );
procedure   setOnKeyDown( const aCssSelector : string; aUserEventHandler : HTMLKeyEventHandler );
procedure   setOnKeyUp( const aCssSelector : string; aUserEventHandler : HTMLKeyEventHandler );
procedure   setOnKeyChar( const aCssSelector : string; aUserEventHandler : HTMLKeyEventHandler );

{-- FOCUS ---------------------------------------------------------------------}

procedure   setOnFocus( const aCssSelector : string; aUserEventHandler : HTMLFocusEventHandler );
procedure   setOnFocusLost( const aCssSelector : string; aUserEventHandler : HTMLFocusEventHandler );
procedure   setOnFocusGot( const aCssSelector : string; aUserEventHandler : HTMLFocusEventHandler );

{-- SCROLL --------------------------------------------------------------------}

procedure   setOnScroll( const aCssSelector : string; aUserEventHandler : HTMLScrollEventHandler );
procedure   setOnScrollHome( const aCssSelector : string; aUserEventHandler : HTMLScrollEventHandler );
procedure   setOnScrollEnd( const aCssSelector : string; aUserEventHandler : HTMLScrollEventHandler );
procedure   setOnScrollStepPlus( const aCssSelector : string; aUserEventHandler : HTMLScrollEventHandler );
procedure   setOnScrollStepMinus( const aCssSelector : string; aUserEventHandler : HTMLScrollEventHandler );
procedure   setOnScrollPagePlus( const aCssSelector : string; aUserEventHandler : HTMLScrollEventHandler );
procedure   setOnScrollPageMinus( const aCssSelector : string; aUserEventHandler : HTMLScrollEventHandler );
procedure   setOnScrollPos( const aCssSelector : string; aUserEventHandler : HTMLScrollEventHandler );
procedure   setOnScrollSliderReleased( const aCssSelector : string; aUserEventHandler : HTMLScrollEventHandler );

{-- TIMER ---------------------------------------------------------------------}

procedure   setOnTimer( const aCssSelector : string; aUserEventHandler : HTMLTimerEventHandler );

{-- SIZE ---------------------------------------------------------------------}

procedure   setOnSize( const aCssSelector : string; aUserEventHandler : HTMLSizeEventHandler );

{-- HANDLE_DATA_ARRIVED -------------------------------------------------------}

procedure   setOnDataArrived( const aCssSelector : string; aUserEventHandler : HTMLDataArrivedEventHandler );

{-- DRAW ----------------------------------------------------------------------}

procedure   setOnDraw( const aCssSelector : string; aUserEventHandler : HTMLDrawEventHandler );
procedure   setOnDrawBackground( const aCssSelector : string; aUserEventHandler : HTMLDrawEventHandler );
procedure   setOnDrawContent( const aCssSelector : string; aUserEventHandler : HTMLDrawEventHandler );
procedure   setOnDrawForeground( const aCssSelector : string; aUserEventHandler : HTMLDrawEventHandler );


{-- EXCHANGE ------------------------------------------------------------------}

procedure   setOnExchange( const aCssSelector : string; aUserEventHandler : HTMLExchangeEventHandler );
procedure   setOnExchangeNone( const aCssSelector : string; aUserEventHandler : HTMLExchangeEventHandler );
procedure   setOnExchangeCopy( const aCssSelector : string; aUserEventHandler : HTMLExchangeEventHandler );
procedure   setOnExchangeMove( const aCssSelector : string; aUserEventHandler : HTMLExchangeEventHandler );
procedure   setOnExchangeLink( const aCssSelector : string; aUserEventHandler : HTMLExchangeEventHandler );

{-- GESTURE -------------------------------------------------------------------}

procedure   setOnGesture( const aCssSelector : string; aUserEventHandler : HTMLGestureEventHandler );
procedure   setOnGestureRequest( const aCssSelector : string; aUserEventHandler : HTMLGestureEventHandler );
procedure   setOnGestureZoom( const aCssSelector : string; aUserEventHandler : HTMLGestureEventHandler );
procedure   setOnGesturePan( const aCssSelector : string; aUserEventHandler : HTMLGestureEventHandler );
procedure   setOnGestureRotate( const aCssSelector : string; aUserEventHandler : HTMLGestureEventHandler );
procedure   setOnGestureTap1( const aCssSelector : string; aUserEventHandler : HTMLGestureEventHandler );
procedure   setOnGestureTap2( const aCssSelector : string; aUserEventHandler : HTMLGestureEventHandler );

{-- BEHAVIOR_EVENT ------------------------------------------------------------}

procedure   setOnButtonClick( const aCssSelector : string; aUserEventHandler : HTMLBehaviorEventHandler );
procedure   setOnButtonPress( const aCssSelector : string; aUserEventHandler : HTMLBehaviorEventHandler );
procedure   setOnButtonStateChanged( const aCssSelector : string; aUserEventHandler : HTMLBehaviorEventHandler );
procedure   setOnEditValueChanging( const aCssSelector : string; aUserEventHandler : HTMLBehaviorEventHandler );
procedure   setOnEditValueChanged( const aCssSelector : string; aUserEventHandler : HTMLBehaviorEventHandler );
procedure   setOnSelectSelectionChanged( const aCssSelector : string; aUserEventHandler : HTMLBehaviorEventHandler );
procedure   setOnSelectStateChanged( const aCssSelector : string; aUserEventHandler : HTMLBehaviorEventHandler );
procedure   setOnPopupRequest( const aCssSelector : string; aUserEventHandler : HTMLBehaviorEventHandler );
procedure   setOnPopupReady( const aCssSelector : string; aUserEventHandler : HTMLBehaviorEventHandler );
procedure   setOnPopupDismissed( const aCssSelector : string; aUserEventHandler : HTMLBehaviorEventHandler );
procedure   setOnMenuItemActive( const aCssSelector : string; aUserEventHandler : HTMLBehaviorEventHandler );
procedure   setOnMenuItemClick( const aCssSelector : string; aUserEventHandler : HTMLBehaviorEventHandler );
procedure   setOnContextMenuSetup( const aCssSelector : string; aUserEventHandler : HTMLBehaviorEventHandler );
procedure   setOnContextMenuRequest( const aCssSelector : string; aUserEventHandler : HTMLBehaviorEventHandler );
procedure   setOnVisiualStatusChanged( const aCssSelector : string; aUserEventHandler : HTMLBehaviorEventHandler );
procedure   setOnDisabledStatusChanged( const aCssSelector : string; aUserEventHandler : HTMLBehaviorEventHandler );
procedure   setOnPopupDismissing( const aCssSelector : string; aUserEventHandler : HTMLBehaviorEventHandler );
procedure   setOnHyperLinkClick( const aCssSelector : string; aUserEventHandler : HTMLBehaviorEventHandler );
procedure   setOnTableHeaderClick( const aCssSelector : string; aUserEventHandler : HTMLBehaviorEventHandler );
procedure   setOnTableRowClick( const aCssSelector : string; aUserEventHandler : HTMLBehaviorEventHandler );
procedure   setOnTableRowDblClick( const aCssSelector : string; aUserEventHandler : HTMLBehaviorEventHandler );
procedure   setOnElementCollapsed( const aCssSelector : string; aUserEventHandler : HTMLBehaviorEventHandler );
procedure   setOnElementExpanded( const aCssSelector : string; aUserEventHandler : HTMLBehaviorEventHandler );
procedure   setOnActivateChild( const aCssSelector : string; aUserEventHandler : HTMLBehaviorEventHandler );
procedure   setOnDoSwitchTab( const aCssSelector : string; aUserEventHandler : HTMLBehaviorEventHandler );
procedure   setOnInitDataView( const aCssSelector : string; aUserEventHandler : HTMLBehaviorEventHandler );
procedure   setOnRowsDataRequest( const aCssSelector : string; aUserEventHandler : HTMLBehaviorEventHandler );
procedure   setOnUiStateChanged( const aCssSelector : string; aUserEventHandler : HTMLBehaviorEventHandler );
procedure   setOnFormSubmit( const aCssSelector : string; aUserEventHandler : HTMLBehaviorEventHandler );
procedure   setOnFormReset( const aCssSelector : string; aUserEventHandler : HTMLBehaviorEventHandler );
procedure   setOnDocumentComplete( const aCssSelector : string; aUserEventHandler : HTMLBehaviorEventHandler );
procedure   setOnHistoryPush( const aCssSelector : string; aUserEventHandler : HTMLBehaviorEventHandler );
procedure   setOnHistoryDrop( const aCssSelector : string; aUserEventHandler : HTMLBehaviorEventHandler );
procedure   setOnHistoryPrior( const aCssSelector : string; aUserEventHandler : HTMLBehaviorEventHandler );
procedure   setOnHistoryNext( const aCssSelector : string; aUserEventHandler : HTMLBehaviorEventHandler );
procedure   setOnHistoryStateChanged( const aCssSelector : string; aUserEventHandler : HTMLBehaviorEventHandler );
procedure   setOnClosePopup( const aCssSelector : string; aUserEventHandler : HTMLBehaviorEventHandler );
procedure   setOnRequestTooltip( const aCssSelector : string; aUserEventHandler : HTMLBehaviorEventHandler );
procedure   setOnAnimation( const aCssSelector : string; aUserEventHandler : HTMLBehaviorEventHandler );

protected
    procedure   addEvent( aEventHandler : THTMLayoutEventHandler );

public
    constructor Create(); overload;
    constructor Create( aDomElement : HELEMENT );  overload;
    destructor  Destroy(); override;

class function controlPressed( const aParams : PHTMLayoutKeyParams ) : boolean;
class function altPressed( const aParams : PHTMLayoutKeyParams ) : boolean;
class function shiftPressed( const aParams : PHTMLayoutKeyParams ) : boolean;
class function phase( const aCmd : UINT ) : HTMLayoutPhase;
class function mouseCmd( const aParams : PHTMLayoutMouseParams ) : HTMLayoutMouseCmd;
class function leftPressed( const aParams : PHTMLayoutMouseParams ) : boolean;
class function middlePressed( const aParams : PHTMLayoutMouseParams ) : boolean;
class function rightPressed( const aParams : PHTMLayoutMouseParams ) : boolean;

// List of CSS selectors supported by HTMLayout could be found here http://www.terrainformatica.com/htmlayout/selectors.whtm
// Note: E:last-child Matches element E when E is the last child of its parent.

    // aDomElement - could be any element in DOM. Usualy it's root (see. HTMLayoutGetRootElement)
    function    attach( aDomElement : HELEMENT ) : boolean;

    // INITIALIZATION
    function    addOnInitialization( const aCssSelector : string; aUserEventHandler : HTMLInitializationEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
    function    addOnBehaviorDetach( const aCssSelector : string; aUserEventHandler : HTMLInitializationEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
    function    addOnBehaviorAttach( const aCssSelector : string; aUserEventHandler : HTMLInitializationEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;

    // MOUSE
    function    addOnMouse( const aCssSelector : string; aUserEventHandler : HTMLMouseEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
    function    addOnMouseEnter( const aCssSelector : string; aUserEventHandler : HTMLMouseEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
    function    addOnMouseLeave( const aCssSelector : string; aUserEventHandler : HTMLMouseEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
    function    addOnMouseMove( const aCssSelector : string; aUserEventHandler : HTMLMouseEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
    function    addOnMouseUp( const aCssSelector : string; aUserEventHandler : HTMLMouseEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
    function    addOnMouseDown( const aCssSelector : string; aUserEventHandler : HTMLMouseEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
    function    addOnMouseClick( const aCssSelector : string; aUserEventHandler : HTMLMouseEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
    function    addOnClick( const aCssSelector : string; aUserEventHandler : HTMLMouseEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler; // same as onMouseClick
    function    addOnMouseDClick( const aCssSelector : string; aUserEventHandler : HTMLMouseEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
    function    addOnDblClick( const aCssSelector : string; aUserEventHandler : HTMLMouseEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler; // same as onMouseDClick
    function    addOnMouseDblClick( const aCssSelector : string; aUserEventHandler : HTMLMouseEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler; // same as onMouseDClick
    function    addOnMouseWheel( const aCssSelector : string; aUserEventHandler : HTMLMouseEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
    function    addOnWheel( const aCssSelector : string; aUserEventHandler : HTMLMouseEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler; // same as onMouseWheel
    function    addOnMouseTick( const aCssSelector : string; aUserEventHandler : HTMLMouseEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
    function    addOnMouseIdle( const aCssSelector : string; aUserEventHandler : HTMLMouseEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
    function    addOnDrop( const aCssSelector : string; aUserEventHandler : HTMLMouseEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
    function    addOnDragEnter( const aCssSelector : string; aUserEventHandler : HTMLMouseEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
    function    addOnDragLeave( const aCssSelector : string; aUserEventHandler : HTMLMouseEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
    function    addOnDragRequest( const aCssSelector : string; aUserEventHandler : HTMLMouseEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
    function    addOnMouseDraggingEnter( const aCssSelector : string; aUserEventHandler : HTMLMouseEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
    function    addOnMouseDraggingLeave( const aCssSelector : string; aUserEventHandler : HTMLMouseEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
    function    addOnMouseDraggingMove( const aCssSelector : string; aUserEventHandler : HTMLMouseEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
    function    addOnMouseDraggingUp( const aCssSelector : string; aUserEventHandler : HTMLMouseEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
    function    addOnMouseDraggingDown( const aCssSelector : string; aUserEventHandler : HTMLMouseEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;

    // KEY
    function    addOnKey( const aCssSelector : string; aUserEventHandler : HTMLKeyEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
    function    addOnKeyDown( const aCssSelector : string; aUserEventHandler : HTMLKeyEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
    function    addOnKeyUp( const aCssSelector : string; aUserEventHandler : HTMLKeyEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
    function    addOnKeyChar( const aCssSelector : string; aUserEventHandler : HTMLKeyEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;

    // FOCUS
    function    addOnFocus( const aCssSelector : string; aUserEventHandler : HTMLFocusEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
    function    addOnFocusLost( const aCssSelector : string; aUserEventHandler : HTMLFocusEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
    function    addOnFocusGot( const aCssSelector : string; aUserEventHandler : HTMLFocusEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;

    // SCROLL
    function    addOnScroll( const aCssSelector : string; aUserEventHandler : HTMLScrollEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
    function    addOnScrollHome( const aCssSelector : string; aUserEventHandler : HTMLScrollEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
    function    addOnScrollEnd( const aCssSelector : string; aUserEventHandler : HTMLScrollEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
    function    addOnScrollStepPlus( const aCssSelector : string; aUserEventHandler : HTMLScrollEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
    function    addOnScrollStepMinus( const aCssSelector : string; aUserEventHandler : HTMLScrollEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
    function    addOnScrollPagePlus( const aCssSelector : string; aUserEventHandler : HTMLScrollEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
    function    addOnScrollPageMinus( const aCssSelector : string; aUserEventHandler : HTMLScrollEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
    function    addOnScrollPos( const aCssSelector : string; aUserEventHandler : HTMLScrollEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
    function    addOnScrollSliderReleased( const aCssSelector : string; aUserEventHandler : HTMLScrollEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;

    // TIMER
    function    addOnTimer( const aCssSelector : string; aUserEventHandler : HTMLTimerEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;

    // SIZE
    function    addOnSize( const aCssSelector : string; aUserEventHandler : HTMLSizeEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;

    // DRAW
    function    addOnDraw( const aCssSelector : string; aUserEventHandler : HTMLDrawEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
    function    addOnDrawBackground( const aCssSelector : string; aUserEventHandler : HTMLDrawEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
    function    addOnDrawContent( const aCssSelector : string; aUserEventHandler : HTMLDrawEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
    function    addOnDrawForeground( const aCssSelector : string; aUserEventHandler : HTMLDrawEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;

    // HANDLE_DATA_ARRIVED
    function    addOnDataArrived( const aCssSelector : string; aUserEventHandler : HTMLDataArrivedEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;

    // EXCHANGE
    function    addOnExchange( const aCssSelector : string; aUserEventHandler : HTMLExchangeEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
    function    addOnExchangeNone( const aCssSelector : string; aUserEventHandler : HTMLExchangeEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
    function    addOnExchangeCopy( const aCssSelector : string; aUserEventHandler : HTMLExchangeEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
    function    addOnExchangeMove( const aCssSelector : string; aUserEventHandler : HTMLExchangeEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
    function    addOnExchangeLink( const aCssSelector : string; aUserEventHandler : HTMLExchangeEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;

    // GESTURE
    function    addOnGesture( const aCssSelector : string; aUserEventHandler : HTMLGestureEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
    function    addOnGestureRequest( const aCssSelector : string; aUserEventHandler : HTMLGestureEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
    function    addOnGestureZoom( const aCssSelector : string; aUserEventHandler : HTMLGestureEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
    function    addOnGesturePan( const aCssSelector : string; aUserEventHandler : HTMLGestureEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
    function    addOnGestureRotate( const aCssSelector : string; aUserEventHandler : HTMLGestureEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
    function    addOnGestureTap1( const aCssSelector : string; aUserEventHandler : HTMLGestureEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
    function    addOnGestureTap2( const aCssSelector : string; aUserEventHandler : HTMLGestureEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;

    // BEHAVIOR_EVENT
    function    addOnButtonClick( const aCssSelector : string; aUserEventHandler : HTMLBehaviorEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
    function    addOnButtonPress( const aCssSelector : string; aUserEventHandler : HTMLBehaviorEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
    function    addOnButtonStateChanged( const aCssSelector : string; aUserEventHandler : HTMLBehaviorEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
    function    addOnEditValueChanging( const aCssSelector : string; aUserEventHandler : HTMLBehaviorEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
    function    addOnEditValueChanged( const aCssSelector : string; aUserEventHandler : HTMLBehaviorEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
    function    addOnSelectSelectionChanged( const aCssSelector : string; aUserEventHandler : HTMLBehaviorEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
    function    addOnSelectStateChanged( const aCssSelector : string; aUserEventHandler : HTMLBehaviorEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
    function    addOnPopupRequest( const aCssSelector : string; aUserEventHandler : HTMLBehaviorEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
    function    addOnPopupReady( const aCssSelector : string; aUserEventHandler : HTMLBehaviorEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
    function    addOnPopupDismissed( const aCssSelector : string; aUserEventHandler : HTMLBehaviorEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
    function    addOnMenuItemActive( const aCssSelector : string; aUserEventHandler : HTMLBehaviorEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
    function    addOnMenuItemClick( const aCssSelector : string; aUserEventHandler : HTMLBehaviorEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
    function    addOnContextMenuSetup( const aCssSelector : string; aUserEventHandler : HTMLBehaviorEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
    function    addOnContextMenuRequest( const aCssSelector : string; aUserEventHandler : HTMLBehaviorEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
    function    addOnVisiualStatusChanged( const aCssSelector : string; aUserEventHandler : HTMLBehaviorEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
    function    addOnDisabledStatusChanged( const aCssSelector : string; aUserEventHandler : HTMLBehaviorEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
    function    addOnPopupDismissing( const aCssSelector : string; aUserEventHandler : HTMLBehaviorEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
    // "grey" event codes  - notfications from behaviors from this SDK
    function    addOnHyperLinkClick( const aCssSelector : string; aUserEventHandler : HTMLBehaviorEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
    function    addOnTableHeaderClick( const aCssSelector : string; aUserEventHandler : HTMLBehaviorEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
    function    addOnTableRowClick( const aCssSelector : string; aUserEventHandler : HTMLBehaviorEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
    function    addOnTableRowDblClick( const aCssSelector : string; aUserEventHandler : HTMLBehaviorEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
    function    addOnElementCollapsed( const aCssSelector : string; aUserEventHandler : HTMLBehaviorEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
    function    addOnElementExpanded( const aCssSelector : string; aUserEventHandler : HTMLBehaviorEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
    function    addOnActivateChild( const aCssSelector : string; aUserEventHandler : HTMLBehaviorEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
    function    addOnDoSwitchTab( const aCssSelector : string; aUserEventHandler : HTMLBehaviorEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
    function    addOnInitDataView( const aCssSelector : string; aUserEventHandler : HTMLBehaviorEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
    function    addOnRowsDataRequest( const aCssSelector : string; aUserEventHandler : HTMLBehaviorEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
    function    addOnUiStateChanged( const aCssSelector : string; aUserEventHandler : HTMLBehaviorEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
    function    addOnFormSubmit( const aCssSelector : string; aUserEventHandler : HTMLBehaviorEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
    function    addOnFormReset( const aCssSelector : string; aUserEventHandler : HTMLBehaviorEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
    function    addOnDocumentComplete( const aCssSelector : string; aUserEventHandler : HTMLBehaviorEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
    function    addOnHistoryPush( const aCssSelector : string; aUserEventHandler : HTMLBehaviorEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
    function    addOnHistoryDrop( const aCssSelector : string; aUserEventHandler : HTMLBehaviorEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
    function    addOnHistoryPrior( const aCssSelector : string; aUserEventHandler : HTMLBehaviorEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
    function    addOnHistoryNext( const aCssSelector : string; aUserEventHandler : HTMLBehaviorEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
    function    addOnHistoryStateChanged( const aCssSelector : string; aUserEventHandler : HTMLBehaviorEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
    function    addOnClosePopup( const aCssSelector : string; aUserEventHandler : HTMLBehaviorEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
    function    addOnRequestTooltip( const aCssSelector : string; aUserEventHandler : HTMLBehaviorEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
    function    addOnAnimation( const aCssSelector : string; aUserEventHandler : HTMLBehaviorEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;

public // property

{-- INITIALIZATION ------------------------------------------------------------}

    property onInitialization[ const aCssSelector : string ] : HTMLInitializationEventHandler write setOnInitialization;
    property onBehaviorDetach[ const aCssSelector : string ] : HTMLInitializationEventHandler write setOnBehaviorDetach;
    property onBehaviorAttach[ const aCssSelector : string ] : HTMLInitializationEventHandler write setOnBehaviorAttach;

{-- MOUSE ---------------------------------------------------------------------}

    property onMouse[ const aCssSelector : string ] : HTMLMouseEventHandler write setOnMouse;
    property onMouseEnter[ const aCssSelector : string ] : HTMLMouseEventHandler write setOnMouseEnter;
    property onMouseLeave[ const aCssSelector : string ] : HTMLMouseEventHandler write setOnMouseLeave;
    property onMouseMove[ const aCssSelector : string ] : HTMLMouseEventHandler write setOnMouseMove;
    property onMouseUp[ const aCssSelector : string ] : HTMLMouseEventHandler write setOnMouseUp;
    property onMouseDown[ const aCssSelector : string ] : HTMLMouseEventHandler write setOnMouseDown;
    property onMouseClick[ const aCssSelector : string ] : HTMLMouseEventHandler write setOnMouseClick;
    property onClick[ const aCssSelector : string ] : HTMLMouseEventHandler write setOnMouseClick;    
    property onMouseDClick[ const aCssSelector : string ] : HTMLMouseEventHandler write setOnMouseDClick;
    property onMouseDblClick[ const aCssSelector : string ] : HTMLMouseEventHandler write setOnMouseDClick;
    property onDblClick[ const aCssSelector : string ] : HTMLMouseEventHandler write setOnMouseDClick;
    property onMouseWheel[ const aCssSelector : string ] : HTMLMouseEventHandler write setOnMouseWheel;
    property onWheel[ const aCssSelector : string ] : HTMLMouseEventHandler write setOnMouseWheel;
    property onMouseTick[ const aCssSelector : string ] : HTMLMouseEventHandler write setOnMouseTick;
    property onMouseIdle[ const aCssSelector : string ] : HTMLMouseEventHandler write setOnMouseIdle;
    property onDrop[ const aCssSelector : string ] : HTMLMouseEventHandler write setOnDrop;
    property onDragEnter[ const aCssSelector : string ] : HTMLMouseEventHandler write setOnDragEnter;
    property onDragLeave[ const aCssSelector : string ] : HTMLMouseEventHandler write setOnDragLeave;
    property onDragRequest[ const aCssSelector : string ] : HTMLMouseEventHandler write setOnDragRequest;
    property onMouseDraggingEnter[ const aCssSelector : string ] : HTMLMouseEventHandler write setOnMouseDraggingEnter;
    property onMouseDraggingLeave[ const aCssSelector : string ] : HTMLMouseEventHandler write setOnMouseDraggingLeave;
    property onMouseDraggingMove[ const aCssSelector : string ] : HTMLMouseEventHandler write setOnMouseDraggingMove;
    property onMouseDraggingUp[ const aCssSelector : string ] : HTMLMouseEventHandler write setOnMouseDraggingUp;
    property onMouseDraggingDown[ const aCssSelector : string ] : HTMLMouseEventHandler write setOnMouseDraggingDown;
    
{-- KEY ----------------------------------------------------------------------}

    property onKey[ const aCssSelector : string ] : HTMLKeyEventHandler write setOnKey;
    property onKeyDown[ const aCssSelector : string ] : HTMLKeyEventHandler write setOnKeyDown;
    property onKeyUp[ const aCssSelector : string ] : HTMLKeyEventHandler write setOnKeyUp;
    property onKeyChar[ const aCssSelector : string ] : HTMLKeyEventHandler write setOnKeyChar;

{-- FOCUS ---------------------------------------------------------------------}

    property onFocus[ const aCssSelector : string ] : HTMLFocusEventHandler write setOnFocus;
    property onFocusLost[ const aCssSelector : string ] : HTMLFocusEventHandler write setOnFocusLost;
    property onFocusGot[ const aCssSelector : string ] : HTMLFocusEventHandler write setOnFocusGot;

{-- SCROLL --------------------------------------------------------------------}

    property onScroll[ const aCssSelector : string ] : HTMLScrollEventHandler write setOnScroll;
    property onScrollHome[ const aCssSelector : string ] : HTMLScrollEventHandler write setOnScrollHome;
    property onScrollEnd[ const aCssSelector : string ] : HTMLScrollEventHandler write setOnScrollEnd;
    property onScrollStepPlus[ const aCssSelector : string ] : HTMLScrollEventHandler write setOnScrollStepPlus;
    property onScrollStepMinus[ const aCssSelector : string ] : HTMLScrollEventHandler write setOnScrollStepMinus;
    property onScrollPagePlus[ const aCssSelector : string ] : HTMLScrollEventHandler write setOnScrollPagePlus;
    property onScrollPageMinus[ const aCssSelector : string ] : HTMLScrollEventHandler write setOnScrollPageMinus;
    property onScrollPos[ const aCssSelector : string ] : HTMLScrollEventHandler write setOnScrollPos;
    property onScrollSliderReleased[ const aCssSelector : string ] : HTMLScrollEventHandler write setOnScrollSliderReleased;

{-- TIMER ---------------------------------------------------------------------}

    property onTimer[ const aCssSelector : string ] : HTMLTimerEventHandler write setOnTimer;

{-- SIZE ---------------------------------------------------------------------}

    property onSize[ const aCssSelector : string ] : HTMLSizeEventHandler write setOnSize;

{-- HANDLE_DATA_ARRIVED -------------------------------------------------------}

    property onDataArrived[ const aCssSelector : string ] : HTMLDataArrivedEventHandler write setOnDataArrived;

{-- DRAW ----------------------------------------------------------------------}

    property onDraw[ const aCssSelector : string ] : HTMLDrawEventHandler write setOnDraw;
    property onDrawBackground[ const aCssSelector : string ] : HTMLDrawEventHandler write setOnDrawBackground;
    property onDrawContent[ const aCssSelector : string ] : HTMLDrawEventHandler write setOnDrawContent;
    property onDrawForeground[ const aCssSelector : string ] : HTMLDrawEventHandler write setOnDrawForeground;


{-- EXCHANGE ------------------------------------------------------------------}

    property onExchange[ const aCssSelector : string ] : HTMLExchangeEventHandler write setOnExchange;
    property onExchangeNone[ const aCssSelector : string ] : HTMLExchangeEventHandler write setOnExchangeNone;
    property onExchangeCopy[ const aCssSelector : string ] : HTMLExchangeEventHandler write setOnExchangeCopy;
    property onExchangeMove[ const aCssSelector : string ] : HTMLExchangeEventHandler write setOnExchangeMove;
    property onExchangeLink[ const aCssSelector : string ] : HTMLExchangeEventHandler write setOnExchangeLink;

{-- GESTURE -------------------------------------------------------------------}

    property onGesture[ const aCssSelector : string ] : HTMLGestureEventHandler write setOnGesture;
    property onGestureRequest[ const aCssSelector : string ] : HTMLGestureEventHandler write setOnGestureRequest;
    property onGestureZoom[ const aCssSelector : string ] : HTMLGestureEventHandler write setOnGestureZoom;
    property onGesturePan[ const aCssSelector : string ] : HTMLGestureEventHandler write setOnGesturePan;
    property onGestureRotate[ const aCssSelector : string ] : HTMLGestureEventHandler write setOnGestureRotate;
    property onGestureTap1[ const aCssSelector : string ] : HTMLGestureEventHandler write setOnGestureTap1;
    property onGestureTap2[ const aCssSelector : string ] : HTMLGestureEventHandler write setOnGestureTap2;

{-- BEHAVIOR_EVENT ------------------------------------------------------------}

    property onButtonClick[ const aCssSelector : string ] : HTMLBehaviorEventHandler write setOnButtonClick;
    property onButtonPress[ const aCssSelector : string ] : HTMLBehaviorEventHandler write setOnButtonPress;
    property onButtonStateChanged[ const aCssSelector : string ] : HTMLBehaviorEventHandler write setOnButtonStateChanged;
    property onEditValueChanging[ const aCssSelector : string ] : HTMLBehaviorEventHandler write setOnEditValueChanging;
    property onEditValueChanged[ const aCssSelector : string ] : HTMLBehaviorEventHandler write setOnEditValueChanged;
    property onSelectSelectionChanged[ const aCssSelector : string ] : HTMLBehaviorEventHandler write setOnSelectSelectionChanged;
    property onSelectStateChanged[ const aCssSelector : string ] : HTMLBehaviorEventHandler write setOnSelectStateChanged;
    property onPopupRequest[ const aCssSelector : string ] : HTMLBehaviorEventHandler write setOnPopupRequest;
    property onPopupReady[ const aCssSelector : string ] : HTMLBehaviorEventHandler write setOnPopupReady;
    property onPopupDismissed[ const aCssSelector : string ] : HTMLBehaviorEventHandler write setOnPopupDismissed;
    property onMenuItemActive[ const aCssSelector : string ] : HTMLBehaviorEventHandler write setOnMenuItemActive;
    property onMenuItemClick[ const aCssSelector : string ] : HTMLBehaviorEventHandler write setOnMenuItemClick;
    property onContextMenuSetup[ const aCssSelector : string ] : HTMLBehaviorEventHandler write setOnContextMenuSetup;
    property onContextMenuRequest[ const aCssSelector : string ] : HTMLBehaviorEventHandler write setOnContextMenuRequest;
    property onVisiualStatusChanged[ const aCssSelector : string ] : HTMLBehaviorEventHandler write setOnVisiualStatusChanged;
    property onDisabledStatusChanged[ const aCssSelector : string ] : HTMLBehaviorEventHandler write setOnDisabledStatusChanged;
    property onPopupDismissing[ const aCssSelector : string ] : HTMLBehaviorEventHandler write setOnPopupDismissing;
    property onHyperLinkClick[ const aCssSelector : string ] : HTMLBehaviorEventHandler write setOnHyperLinkClick;
    property onTableHeaderClick[ const aCssSelector : string ] : HTMLBehaviorEventHandler write setOnTableHeaderClick;
    property onTableRowClick[ const aCssSelector : string ] : HTMLBehaviorEventHandler write setOnTableRowClick;
    property onTableRowDblClick[ const aCssSelector : string ] : HTMLBehaviorEventHandler write setOnTableRowDblClick;
    property onElementCollapsed[ const aCssSelector : string ] : HTMLBehaviorEventHandler write setOnElementCollapsed;
    property onElementExpanded[ const aCssSelector : string ] : HTMLBehaviorEventHandler write setOnElementExpanded;
    property onActivateChild[ const aCssSelector : string ] : HTMLBehaviorEventHandler write setOnActivateChild;
    property onDoSwitchTab[ const aCssSelector : string ] : HTMLBehaviorEventHandler write setOnDoSwitchTab;
    property onInitDataView[ const aCssSelector : string ] : HTMLBehaviorEventHandler write setOnInitDataView;
    property onRowsDataRequest[ const aCssSelector : string ] : HTMLBehaviorEventHandler write setOnRowsDataRequest;
    property onUiStateChanged[ const aCssSelector : string ] : HTMLBehaviorEventHandler write setOnUiStateChanged;
    property onFormSubmit[ const aCssSelector : string ] : HTMLBehaviorEventHandler write setOnFormSubmit;
    property onFormReset[ const aCssSelector : string ] : HTMLBehaviorEventHandler write setOnFormReset;
    property onDocumentComplete[ const aCssSelector : string ] : HTMLBehaviorEventHandler write setOnDocumentComplete;
    property onHistoryPush[ const aCssSelector : string ] : HTMLBehaviorEventHandler write setOnHistoryPush;
    property onHistoryDrop[ const aCssSelector : string ] : HTMLBehaviorEventHandler write setOnHistoryDrop;
    property onHistoryPrior[ const aCssSelector : string ] : HTMLBehaviorEventHandler write setOnHistoryPrior;
    property onHistoryNext[ const aCssSelector : string ] : HTMLBehaviorEventHandler write setOnHistoryNext;
    property onHistoryStateChanged[ const aCssSelector : string ] : HTMLBehaviorEventHandler write setOnHistoryStateChanged;
    property onClosePopup[ const aCssSelector : string ] : HTMLBehaviorEventHandler write setOnClosePopup;
    property onRequestTooltip[ const aCssSelector : string ] : HTMLBehaviorEventHandler write setOnRequestTooltip;
    property onAnimation[ const aCssSelector : string ] : HTMLBehaviorEventHandler write setOnAnimation;

    end;

implementation

uses HtmlElement, HtmlLayoutDomH;

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

{*******************************************************************************
* leftPressed
*******************************************************************************}
class function THTMLayoutEvent.leftPressed( const aParams : PHTMLayoutMouseParams ) : boolean;
begin
    Result := ( aParams.button_state and MAIN_MOUSE_BUTTON ) = MAIN_MOUSE_BUTTON;
end;

{*******************************************************************************
* middlePressed
*******************************************************************************}
class function THTMLayoutEvent.middlePressed( const aParams : PHTMLayoutMouseParams ) : boolean;
begin
    Result := ( aParams.button_state and MIDDLE_MOUSE_BUTTON ) = MIDDLE_MOUSE_BUTTON;
end;

{*******************************************************************************
* rightPressed
*******************************************************************************}
class function THTMLayoutEvent.rightPressed( const aParams : PHTMLayoutMouseParams ) : boolean;
begin
    Result := ( aParams.button_state and PROP_MOUSE_BUTTON ) = PROP_MOUSE_BUTTON;
end;

//-------------------------- ATTACH/DETACH EVENTS ------------------------------

{*******************************************************************************
* SetElementEventHandler
*******************************************************************************}
function SetElementEventHandler( aDomElement : HELEMENT; aEventHandler : Pointer ) : BOOL; stdcall;
var
    e : THTMLayoutEventHandler;
begin
    Result := false; // this function will be called multiply times for every element found

    e := THTMLayoutEventHandler( aEventHandler );
    HTMLayoutAttachEventHandlerEx( aDomElement, e.FhandlerProxy, aEventHandler, e.Fsubscription );
end;

{*******************************************************************************
* Create
*******************************************************************************}
constructor THTMLayoutEventHandler.Create( aCmd, aSubscription : cardinal; aHandlerProxy : HTMLEventHandlerProxy; const aCssSelector : string; aCallback : TMethod; aUserData : Pointer = nil );
begin
    Fcmd := aCmd;
    Fsubscription := aSubscription;
    FhandlerProxy := aHandlerProxy;
    FcssSelector := aCssSelector;
    Fcallback := aCallback;
    FuserData := aUserData;
    FallEvents := false;
end;

{*******************************************************************************
* Destroy
*******************************************************************************}
{destructor THTMLayoutEventHandler.Destroy();
begin
    inherited;
end;}

{*******************************************************************************
* valid
*******************************************************************************}
function THTMLayoutEventHandler.valid( aDomElement : HELEMENT ) : boolean;
var
    uid : cardinal;
begin
    Result := false;
    try
        Result := Assigned( aDomElement ) and ( HLDOM_OK = HTMLayoutGetElementUID( aDomElement, uid ) );
    except
    end;
end;

{*******************************************************************************
* bind
*******************************************************************************}
function THTMLayoutEventHandler.attach( aDomElement : HELEMENT ) : boolean;
begin
    Result := valid( aDomElement );
    assert( Result );
    if ( not Result ) then
        exit;

    Result := ( HLDOM_OK = HTMLayoutSelectElements( aDomElement, LPCSTR( FcssSelector ), SetElementEventHandler, self ) );
    assert( Result );
end;

{-- THTMLayoutEvent -----------------------------------------------------------}

{*******************************************************************************
* Create
*******************************************************************************}
constructor THTMLayoutEvent.Create();
begin
    FdomElement := nil;
    Fevents := TObjectList.Create( true );
end;

{*******************************************************************************
*
*******************************************************************************}
constructor THTMLayoutEvent.Create( aDomElement : HELEMENT );
begin
    Create();
    FdomElement := aDomElement;
end;

{*******************************************************************************
* Destroy
*******************************************************************************}
destructor THTMLayoutEvent.Destroy();
begin
    FreeAndNil( Fevents );
    inherited;
end;

{*******************************************************************************
* attach
*******************************************************************************}
function THTMLayoutEvent.attach( aDomElement : HELEMENT ) : boolean;
var
    i : integer;
begin
    Result := false;
    FdomElement := aDomElement;

    for i := 0 to Fevents.Count - 1 do
    begin
        Result := THTMLayoutEventHandler( Fevents[i] ).attach( aDomElement );
        if ( not Result ) then
            break;
    end;
end;

{*******************************************************************************
* addEvent
*******************************************************************************}
procedure THTMLayoutEvent.addEvent( aEventHandler : THTMLayoutEventHandler );
begin
    Fevents.add( aEventHandler );
    if ( Assigned( FdomElement ) ) then
    begin
        aEventHandler.attach( FdomElement );
    end;
end;

{-- INITIALIZATION ------------------------------------------------------------}

function InitializationHandler( aUserEventHandler : Pointer; aSender : HELEMENT; aEventGroup : UINT; aEventParams : Pointer ) : BOOL stdcall;
var
    e : THTMLayoutEventHandler;
begin
    e := THTMLayoutEventHandler( aUserEventHandler );

    Result := e.FallEvents or ( PHTMLayoutInitializationParams( aEventParams ).cmd = e.Fcmd );
    if ( not Result ) then
        exit;

    try
        Result := HTMLInitializationEventHandler( e.Fcallback )( aSender, PHTMLayoutInitializationParams( aEventParams ), e.FuserData );
    except
    end;
end;

// onInitialization
function THTMLayoutEvent.addOnInitialization( const aCssSelector : string; aUserEventHandler : HTMLInitializationEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
begin
    Result := THTMLayoutEventHandler.Create( INITIALIZATION_ALL, HANDLE_INITIALIZATION, InitializationHandler, aCssSelector, TMethod( aUserEventHandler ), aUserData );
    Result.FallEvents := true;

    addEvent( Result );
end;

procedure THTMLayoutEvent.setOnInitialization( const aCssSelector : string; aUserEventHandler : HTMLInitializationEventHandler );
begin
    addOnInitialization( aCssSelector, aUserEventHandler, nil );
end;

// onBehaviorDetach
function THTMLayoutEvent.addOnBehaviorDetach( const aCssSelector : string; aUserEventHandler : HTMLInitializationEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
begin
    Result := THTMLayoutEventHandler.Create( BEHAVIOR_DETACH , HANDLE_INITIALIZATION, InitializationHandler, aCssSelector, TMethod( aUserEventHandler ), aUserData );
    addEvent( Result );
end;

procedure THTMLayoutEvent.setOnBehaviorDetach( const aCssSelector : string; aUserEventHandler : HTMLInitializationEventHandler );
begin
    addOnBehaviorDetach( aCssSelector, aUserEventHandler, nil );
end;

// onBehaviorAttach
function THTMLayoutEvent.addOnBehaviorAttach( const aCssSelector : string; aUserEventHandler : HTMLInitializationEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
begin
    Result := THTMLayoutEventHandler.Create( BEHAVIOR_ATTACH , HANDLE_INITIALIZATION, InitializationHandler, aCssSelector, TMethod( aUserEventHandler ), aUserData );
    addEvent( Result );
end;

procedure THTMLayoutEvent.setOnBehaviorAttach( const aCssSelector : string; aUserEventHandler : HTMLInitializationEventHandler );
begin
    addOnBehaviorAttach( aCssSelector, aUserEventHandler, nil );
end;

{-- MOUSE ---------------------------------------------------------------------}

function MouseHandler( aUserEventHandler : Pointer; aSender : HELEMENT; aEventGroup : UINT; aEventParams : Pointer ) : BOOL stdcall;
var
    e : THTMLayoutEventHandler;
begin
    e := THTMLayoutEventHandler( aUserEventHandler );

    Result := e.FallEvents or ( PHTMLayoutMouseParams( aEventParams ).cmd = e.Fcmd );
    if ( not Result ) then
        exit;

    try
        Result := HTMLMouseEventHandler( e.Fcallback )( aSender, PHTMLayoutMouseParams( aEventParams ), e.FuserData );
    except
    end;
end;

// onMouse
function THTMLayoutEvent.addOnMouse( const aCssSelector : string; aUserEventHandler : HTMLMouseEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
begin
    Result := THTMLayoutEventHandler.Create( MOUSE_ALL, HANDLE_MOUSE or DISABLE_INITIALIZATION, MouseHandler, aCssSelector, TMethod( aUserEventHandler ), aUserData );
    Result.FallEvents := true;

    addEvent( Result );
end;

procedure THTMLayoutEvent.setOnMouse( const aCssSelector : string; aUserEventHandler : HTMLMouseEventHandler );
begin
    addOnMouseEnter( aCssSelector, aUserEventHandler, nil );
end;

// onMouseEnter
function THTMLayoutEvent.addOnMouseEnter( const aCssSelector : string; aUserEventHandler : HTMLMouseEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
begin
    Result := THTMLayoutEventHandler.Create( MOUSE_ENTER , HANDLE_MOUSE or DISABLE_INITIALIZATION, MouseHandler, aCssSelector, TMethod( aUserEventHandler ), aUserData );
    addEvent( Result );
end;

procedure THTMLayoutEvent.setOnMouseEnter( const aCssSelector : string; aUserEventHandler : HTMLMouseEventHandler );
begin
    addOnMouseEnter( aCssSelector, aUserEventHandler, nil );
end;

// onMouseLeave
function THTMLayoutEvent.addOnMouseLeave( const aCssSelector : string; aUserEventHandler : HTMLMouseEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
begin
    Result := THTMLayoutEventHandler.Create( MOUSE_LEAVE , HANDLE_MOUSE or DISABLE_INITIALIZATION, MouseHandler, aCssSelector, TMethod( aUserEventHandler ), aUserData );
    addEvent( Result );
end;

procedure THTMLayoutEvent.setOnMouseLeave( const aCssSelector : string; aUserEventHandler : HTMLMouseEventHandler );
begin
    addOnMouseLeave( aCssSelector, aUserEventHandler, nil );
end;

// onMouseMove
function THTMLayoutEvent.addOnMouseMove( const aCssSelector : string; aUserEventHandler : HTMLMouseEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
begin
    Result := THTMLayoutEventHandler.Create( MOUSE_MOVE , HANDLE_MOUSE or DISABLE_INITIALIZATION, MouseHandler, aCssSelector, TMethod( aUserEventHandler ), aUserData );
    addEvent( Result );
end;

procedure THTMLayoutEvent.setOnMouseMove( const aCssSelector : string; aUserEventHandler : HTMLMouseEventHandler );
begin
    addOnMouseMove( aCssSelector, aUserEventHandler, nil );
end;

// onMouseUp
function THTMLayoutEvent.addOnMouseUp( const aCssSelector : string; aUserEventHandler : HTMLMouseEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
begin
    Result := THTMLayoutEventHandler.Create( MOUSE_UP , HANDLE_MOUSE or DISABLE_INITIALIZATION, MouseHandler, aCssSelector, TMethod( aUserEventHandler ), aUserData );
    addEvent( Result );
end;

procedure THTMLayoutEvent.setOnMouseUp( const aCssSelector : string; aUserEventHandler : HTMLMouseEventHandler );
begin
    addOnMouseUp( aCssSelector, aUserEventHandler, nil );
end;

// onMouseDown
function THTMLayoutEvent.addOnMouseDown( const aCssSelector : string; aUserEventHandler : HTMLMouseEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
begin
    Result := THTMLayoutEventHandler.Create( MOUSE_DOWN , HANDLE_MOUSE or DISABLE_INITIALIZATION, MouseHandler, aCssSelector, TMethod( aUserEventHandler ), aUserData );
    addEvent( Result );
end;

procedure THTMLayoutEvent.setOnMouseDown( const aCssSelector : string; aUserEventHandler : HTMLMouseEventHandler );
begin
    addOnMouseDown( aCssSelector, aUserEventHandler, nil );
end;

// onMouseClick
function THTMLayoutEvent.addOnMouseClick( const aCssSelector : string; aUserEventHandler : HTMLMouseEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
begin
    Result := THTMLayoutEventHandler.Create( MOUSE_CLICK , HANDLE_MOUSE or DISABLE_INITIALIZATION, MouseHandler, aCssSelector, TMethod( aUserEventHandler ), aUserData );
    addEvent( Result );
end;

procedure THTMLayoutEvent.setOnMouseClick( const aCssSelector : string; aUserEventHandler : HTMLMouseEventHandler );
begin
    addOnMouseClick( aCssSelector, aUserEventHandler, nil );
end;

function THTMLayoutEvent.addOnClick( const aCssSelector : string; aUserEventHandler : HTMLMouseEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
begin
    Result := addOnMouseClick( aCssSelector, aUserEventHandler, nil );
end;
    
// onMouseDClick
function THTMLayoutEvent.addOnMouseDClick( const aCssSelector : string; aUserEventHandler : HTMLMouseEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
begin
    Result := THTMLayoutEventHandler.Create( MOUSE_DCLICK , HANDLE_MOUSE or DISABLE_INITIALIZATION, MouseHandler, aCssSelector, TMethod( aUserEventHandler ), aUserData );
    addEvent( Result );
end;

function THTMLayoutEvent.addOnDblClick( const aCssSelector : string; aUserEventHandler : HTMLMouseEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
begin
    Result := addOnMouseDClick( aCssSelector, aUserEventHandler, aUserData );
end;

function THTMLayoutEvent.addOnMouseDblClick( const aCssSelector : string; aUserEventHandler : HTMLMouseEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
begin
    Result := addOnMouseDClick( aCssSelector, aUserEventHandler, aUserData );
end;

procedure THTMLayoutEvent.setOnMouseDClick( const aCssSelector : string; aUserEventHandler : HTMLMouseEventHandler );
begin
    addOnMouseDClick( aCssSelector, aUserEventHandler, nil );
end;

// onMouseWheel
function THTMLayoutEvent.addOnMouseWheel( const aCssSelector : string; aUserEventHandler : HTMLMouseEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
begin
    Result := THTMLayoutEventHandler.Create( MOUSE_WHEEL , HANDLE_MOUSE or DISABLE_INITIALIZATION, MouseHandler, aCssSelector, TMethod( aUserEventHandler ), aUserData );
    addEvent( Result );
end;

function THTMLayoutEvent.addOnWheel( const aCssSelector : string; aUserEventHandler : HTMLMouseEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
begin
    Result := THTMLayoutEventHandler.Create( MOUSE_WHEEL , HANDLE_MOUSE or DISABLE_INITIALIZATION, MouseHandler, aCssSelector, TMethod( aUserEventHandler ), aUserData );
    addEvent( Result );
end;

procedure THTMLayoutEvent.setOnMouseWheel( const aCssSelector : string; aUserEventHandler : HTMLMouseEventHandler );
begin
    addOnMouseWheel( aCssSelector, aUserEventHandler, nil );
end;

// onMouseTick
function THTMLayoutEvent.addOnMouseTick( const aCssSelector : string; aUserEventHandler : HTMLMouseEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
begin
    Result := THTMLayoutEventHandler.Create( MOUSE_TICK , HANDLE_MOUSE or DISABLE_INITIALIZATION, MouseHandler, aCssSelector, TMethod( aUserEventHandler ), aUserData );
    addEvent( Result );
end;

procedure THTMLayoutEvent.setOnMouseTick( const aCssSelector : string; aUserEventHandler : HTMLMouseEventHandler );
begin
    addOnMouseTick( aCssSelector, aUserEventHandler, nil );
end;

// onMouseIdle
function THTMLayoutEvent.addOnMouseIdle( const aCssSelector : string; aUserEventHandler : HTMLMouseEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
begin
    Result := THTMLayoutEventHandler.Create( MOUSE_IDLE , HANDLE_MOUSE or DISABLE_INITIALIZATION, MouseHandler, aCssSelector, TMethod( aUserEventHandler ), aUserData );
    addEvent( Result );
end;

procedure THTMLayoutEvent.setOnMouseIdle( const aCssSelector : string; aUserEventHandler : HTMLMouseEventHandler );
begin
    addOnMouseIdle( aCssSelector, aUserEventHandler, nil );
end;

// onDrop
function THTMLayoutEvent.addOnDrop( const aCssSelector : string; aUserEventHandler : HTMLMouseEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
begin
    Result := THTMLayoutEventHandler.Create( DROP , HANDLE_MOUSE or DISABLE_INITIALIZATION, MouseHandler, aCssSelector, TMethod( aUserEventHandler ), aUserData );
    addEvent( Result );
end;

procedure THTMLayoutEvent.setOnDrop( const aCssSelector : string; aUserEventHandler : HTMLMouseEventHandler );
begin
    addOnDrop( aCssSelector, aUserEventHandler, nil );
end;

// onDragEnter
function THTMLayoutEvent.addOnDragEnter( const aCssSelector : string; aUserEventHandler : HTMLMouseEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
begin
    Result := THTMLayoutEventHandler.Create( DRAG_ENTER , HANDLE_MOUSE or DISABLE_INITIALIZATION, MouseHandler, aCssSelector, TMethod( aUserEventHandler ), aUserData );
    addEvent( Result );
end;

procedure THTMLayoutEvent.setOnDragEnter( const aCssSelector : string; aUserEventHandler : HTMLMouseEventHandler );
begin
    addOnDragEnter( aCssSelector, aUserEventHandler, nil );
end;

// onDragLeave
function THTMLayoutEvent.addOnDragLeave( const aCssSelector : string; aUserEventHandler : HTMLMouseEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
begin
    Result := THTMLayoutEventHandler.Create( DRAG_LEAVE , HANDLE_MOUSE or DISABLE_INITIALIZATION, MouseHandler, aCssSelector, TMethod( aUserEventHandler ), aUserData );
    addEvent( Result );
end;

procedure THTMLayoutEvent.setOnDragLeave( const aCssSelector : string; aUserEventHandler : HTMLMouseEventHandler );
begin
    addOnDragLeave( aCssSelector, aUserEventHandler, nil );
end;

// onDragRequest
function THTMLayoutEvent.addOnDragRequest( const aCssSelector : string; aUserEventHandler : HTMLMouseEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
begin
    Result := THTMLayoutEventHandler.Create( DRAG_REQUEST , HANDLE_MOUSE or DISABLE_INITIALIZATION, MouseHandler, aCssSelector, TMethod( aUserEventHandler ), aUserData );
    addEvent( Result );
end;

procedure THTMLayoutEvent.setOnDragRequest( const aCssSelector : string; aUserEventHandler : HTMLMouseEventHandler );
begin
    addOnDragRequest( aCssSelector, aUserEventHandler, nil );
end;

// onMouseDraggingEnter
function THTMLayoutEvent.addOnMouseDraggingEnter( const aCssSelector : string; aUserEventHandler : HTMLMouseEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
begin
    Result := THTMLayoutEventHandler.Create( MOUSE_ENTER or DRAGGING, HANDLE_MOUSE or DISABLE_INITIALIZATION, MouseHandler, aCssSelector, TMethod( aUserEventHandler ), aUserData );
    addEvent( Result );
end;

procedure THTMLayoutEvent.setOnMouseDraggingEnter( const aCssSelector : string; aUserEventHandler : HTMLMouseEventHandler );
begin
    addOnMouseDraggingEnter( aCssSelector, aUserEventHandler, nil );
end;

// onMouseDraggingLeave
function THTMLayoutEvent.addOnMouseDraggingLeave( const aCssSelector : string; aUserEventHandler : HTMLMouseEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
begin
    Result := THTMLayoutEventHandler.Create( MOUSE_LEAVE or DRAGGING, HANDLE_MOUSE or DISABLE_INITIALIZATION, MouseHandler, aCssSelector, TMethod( aUserEventHandler ), aUserData );
    addEvent( Result );
end;

    procedure THTMLayoutEvent.setOnMouseDraggingLeave( const aCssSelector : string; aUserEventHandler : HTMLMouseEventHandler );
begin
    addOnMouseDraggingLeave( aCssSelector, aUserEventHandler, nil );
end;

// onMouseDraggingMove
function THTMLayoutEvent.addOnMouseDraggingMove( const aCssSelector : string; aUserEventHandler : HTMLMouseEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
begin
    Result := THTMLayoutEventHandler.Create( MOUSE_MOVE or DRAGGING, HANDLE_MOUSE or DISABLE_INITIALIZATION, MouseHandler, aCssSelector, TMethod( aUserEventHandler ), aUserData );
    addEvent( Result );
end;

procedure THTMLayoutEvent.setOnMouseDraggingMove( const aCssSelector : string; aUserEventHandler : HTMLMouseEventHandler );
begin
    addOnMouseDraggingMove( aCssSelector, aUserEventHandler, nil );
end;

// onMouseDraggingUp
function THTMLayoutEvent.addOnMouseDraggingUp( const aCssSelector : string; aUserEventHandler : HTMLMouseEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
begin
    Result := THTMLayoutEventHandler.Create( MOUSE_UP or DRAGGING, HANDLE_MOUSE or DISABLE_INITIALIZATION, MouseHandler, aCssSelector, TMethod( aUserEventHandler ), aUserData );
    addEvent( Result );
end;

procedure THTMLayoutEvent.setOnMouseDraggingUp( const aCssSelector : string; aUserEventHandler : HTMLMouseEventHandler );
begin
    addOnMouseDraggingUp( aCssSelector, aUserEventHandler, nil );
end;

// onMouseDraggingDown
function THTMLayoutEvent.addOnMouseDraggingDown( const aCssSelector : string; aUserEventHandler : HTMLMouseEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
begin
    Result := THTMLayoutEventHandler.Create( MOUSE_DOWN or DRAGGING, HANDLE_MOUSE or DISABLE_INITIALIZATION, MouseHandler, aCssSelector, TMethod( aUserEventHandler ), aUserData );
    addEvent( Result );
end;

procedure THTMLayoutEvent.setOnMouseDraggingDown( const aCssSelector : string; aUserEventHandler : HTMLMouseEventHandler );
begin
    addOnMouseDraggingDown( aCssSelector, aUserEventHandler, nil );
end;
    
{-- KEY ---------------------------------------------------------------------}

function KeyHandler( aUserEventHandler : Pointer; aSender : HELEMENT; aEventGroup : UINT; aEventParams : Pointer ) : BOOL stdcall;
var
    e : THTMLayoutEventHandler;
begin
    e := THTMLayoutEventHandler( aUserEventHandler );

    Result := e.FallEvents or ( PHTMLayoutKeyParams( aEventParams ).cmd = e.Fcmd );
    if ( not Result ) then
        exit;

    try
        Result := HTMLKeyEventHandler( e.Fcallback )( aSender, PHTMLayoutKeyParams( aEventParams ), e.FuserData );
    except
    end;
end;

// onKey
function THTMLayoutEvent.addOnKey( const aCssSelector : string; aUserEventHandler : HTMLKeyEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
begin
    Result := THTMLayoutEventHandler.Create( KEY_ALL, HANDLE_KEY or DISABLE_INITIALIZATION, KeyHandler, aCssSelector, TMethod( aUserEventHandler ), aUserData );
    Result.FallEvents := true;

    addEvent( Result );
end;

procedure THTMLayoutEvent.setOnKey( const aCssSelector : string; aUserEventHandler : HTMLKeyEventHandler );
begin
    addOnKey( aCssSelector, aUserEventHandler, nil );
end;

// onKeyDown
function THTMLayoutEvent.addOnKeyDown( const aCssSelector : string; aUserEventHandler : HTMLKeyEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
begin
    Result := THTMLayoutEventHandler.Create( KEY_DOWN , HANDLE_KEY or DISABLE_INITIALIZATION, KeyHandler, aCssSelector, TMethod( aUserEventHandler ), aUserData );
    addEvent( Result );
end;

procedure THTMLayoutEvent.setOnKeyDown( const aCssSelector : string; aUserEventHandler : HTMLKeyEventHandler );
begin
    addOnKeyDown( aCssSelector, aUserEventHandler, nil );
end;

// onKeyUp
function THTMLayoutEvent.addOnKeyUp( const aCssSelector : string; aUserEventHandler : HTMLKeyEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
begin
    Result := THTMLayoutEventHandler.Create( KEY_UP , HANDLE_KEY or DISABLE_INITIALIZATION, KeyHandler, aCssSelector, TMethod( aUserEventHandler ), aUserData );
    addEvent( Result );
end;

procedure THTMLayoutEvent.setOnKeyUp( const aCssSelector : string; aUserEventHandler : HTMLKeyEventHandler );
begin
    addOnKeyUp( aCssSelector, aUserEventHandler, nil );
end;

// onKeyChar
function THTMLayoutEvent.addOnKeyChar( const aCssSelector : string; aUserEventHandler : HTMLKeyEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
begin
    Result := THTMLayoutEventHandler.Create( KEY_CHAR , HANDLE_KEY or DISABLE_INITIALIZATION, KeyHandler, aCssSelector, TMethod( aUserEventHandler ), aUserData );
    addEvent( Result );
end;

procedure THTMLayoutEvent.setOnKeyChar( const aCssSelector : string; aUserEventHandler : HTMLKeyEventHandler );
begin
    addOnKeyChar( aCssSelector, aUserEventHandler, nil );
end;

{-- FOCUS ---------------------------------------------------------------------}

function FocusHandler( aUserEventHandler : Pointer; aSender : HELEMENT; aEventGroup : UINT; aEventParams : Pointer ) : BOOL stdcall;
var
    e : THTMLayoutEventHandler;
begin
    e := THTMLayoutEventHandler( aUserEventHandler );

    Result := e.FallEvents or ( PHTMLayoutFocusParams( aEventParams ).cmd = e.Fcmd );
    if ( not Result ) then
        exit;

    try
        Result := HTMLFocusEventHandler( e.Fcallback )( aSender, PHTMLayoutFocusParams( aEventParams ), e.FuserData );
    except
    end;
end;

// onFocus
function THTMLayoutEvent.addOnFocus( const aCssSelector : string; aUserEventHandler : HTMLFocusEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
begin
    Result := THTMLayoutEventHandler.Create( FOCUS_ALL , HANDLE_FOCUS or DISABLE_INITIALIZATION, FocusHandler, aCssSelector, TMethod( aUserEventHandler ), aUserData );
    Result.FallEvents := true;

    addEvent( Result );
end;

procedure THTMLayoutEvent.setOnFocus( const aCssSelector : string; aUserEventHandler : HTMLFocusEventHandler );
begin
    addOnFocus( aCssSelector, aUserEventHandler, nil );
end;

// onFocusLost
function THTMLayoutEvent.addOnFocusLost( const aCssSelector : string; aUserEventHandler : HTMLFocusEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
begin
    Result := THTMLayoutEventHandler.Create( FOCUS_LOST , HANDLE_FOCUS or DISABLE_INITIALIZATION, FocusHandler, aCssSelector, TMethod( aUserEventHandler ), aUserData );
    addEvent( Result );
end;

procedure THTMLayoutEvent.setOnFocusLost( const aCssSelector : string; aUserEventHandler : HTMLFocusEventHandler );
begin
    addOnFocusLost( aCssSelector, aUserEventHandler, nil );
end;

// onFocusGot
function THTMLayoutEvent.addOnFocusGot( const aCssSelector : string; aUserEventHandler : HTMLFocusEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
begin
    Result := THTMLayoutEventHandler.Create( FOCUS_GOT , HANDLE_FOCUS or DISABLE_INITIALIZATION, FocusHandler, aCssSelector, TMethod( aUserEventHandler ), aUserData );
    addEvent( Result );
end;

procedure THTMLayoutEvent.setOnFocusGot( const aCssSelector : string; aUserEventHandler : HTMLFocusEventHandler );
begin
    addOnFocusGot( aCssSelector, aUserEventHandler, nil );
end;

{-- SCROLL --------------------------------------------------------------------}

function ScrollHandler( aUserEventHandler : Pointer; aSender : HELEMENT; aEventGroup : UINT; aEventParams : Pointer ) : BOOL stdcall;
var
    e : THTMLayoutEventHandler;
begin
    e := THTMLayoutEventHandler( aUserEventHandler );

    Result := e.FallEvents or ( PHTMLayoutScrollParams( aEventParams ).cmd = e.Fcmd );
    if ( not Result ) then
        exit;

    try
        Result := HTMLScrollEventHandler( e.Fcallback )( aSender, PHTMLayoutScrollParams( aEventParams ), e.FuserData );
    except
    end;
end;

// onScroll
function THTMLayoutEvent.addOnScroll( const aCssSelector : string; aUserEventHandler : HTMLScrollEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
begin
    Result := THTMLayoutEventHandler.Create( SCROLL_ALL , HANDLE_SCROLL or DISABLE_INITIALIZATION, ScrollHandler, aCssSelector, TMethod( aUserEventHandler ), aUserData );
    Result.FallEvents := true;
    
    addEvent( Result );
end;

procedure THTMLayoutEvent.setOnScroll( const aCssSelector : string; aUserEventHandler : HTMLScrollEventHandler );
begin
    addOnScroll( aCssSelector, aUserEventHandler, nil );
end;

// onScrollHome
function THTMLayoutEvent.addOnScrollHome( const aCssSelector : string; aUserEventHandler : HTMLScrollEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
begin
    Result := THTMLayoutEventHandler.Create( SCROLL_HOME , HANDLE_SCROLL or DISABLE_INITIALIZATION, ScrollHandler, aCssSelector, TMethod( aUserEventHandler ), aUserData );
    addEvent( Result );
end;

procedure THTMLayoutEvent.setOnScrollHome( const aCssSelector : string; aUserEventHandler : HTMLScrollEventHandler );
begin
    addOnScrollHome( aCssSelector, aUserEventHandler, nil );
end;

// onScrollEnd
function THTMLayoutEvent.addOnScrollEnd( const aCssSelector : string; aUserEventHandler : HTMLScrollEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
begin
    Result := THTMLayoutEventHandler.Create( SCROLL_END , HANDLE_SCROLL or DISABLE_INITIALIZATION, ScrollHandler, aCssSelector, TMethod( aUserEventHandler ), aUserData );
    addEvent( Result );
end;

procedure THTMLayoutEvent.setOnScrollEnd( const aCssSelector : string; aUserEventHandler : HTMLScrollEventHandler );
begin
    addOnScrollEnd( aCssSelector, aUserEventHandler, nil );
end;

// onScrollStepPlus
function THTMLayoutEvent.addOnScrollStepPlus( const aCssSelector : string; aUserEventHandler : HTMLScrollEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
begin
    Result := THTMLayoutEventHandler.Create( SCROLL_STEP_PLUS , HANDLE_SCROLL or DISABLE_INITIALIZATION, ScrollHandler, aCssSelector, TMethod( aUserEventHandler ), aUserData );
    addEvent( Result );
end;

procedure THTMLayoutEvent.setOnScrollStepPlus( const aCssSelector : string; aUserEventHandler : HTMLScrollEventHandler );
begin
    addOnScrollStepPlus( aCssSelector, aUserEventHandler, nil );
end;

// onScrollStepMinus
function THTMLayoutEvent.addOnScrollStepMinus( const aCssSelector : string; aUserEventHandler : HTMLScrollEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
begin
    Result := THTMLayoutEventHandler.Create( SCROLL_STEP_MINUS , HANDLE_SCROLL or DISABLE_INITIALIZATION, ScrollHandler, aCssSelector, TMethod( aUserEventHandler ), aUserData );
    addEvent( Result );
end;

procedure THTMLayoutEvent.setOnScrollStepMinus( const aCssSelector : string; aUserEventHandler : HTMLScrollEventHandler );
begin
    addOnScrollStepMinus( aCssSelector, aUserEventHandler, nil );
end;

// onScrollPagePlus
function THTMLayoutEvent.addOnScrollPagePlus( const aCssSelector : string; aUserEventHandler : HTMLScrollEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
begin
    Result := THTMLayoutEventHandler.Create( SCROLL_PAGE_PLUS , HANDLE_SCROLL or DISABLE_INITIALIZATION, ScrollHandler, aCssSelector, TMethod( aUserEventHandler ), aUserData );
    addEvent( Result );
end;

procedure THTMLayoutEvent.setOnScrollPagePlus( const aCssSelector : string; aUserEventHandler : HTMLScrollEventHandler );
begin
    addOnScrollPagePlus( aCssSelector, aUserEventHandler, nil );
end;

// onScrollPageMinus
function THTMLayoutEvent.addOnScrollPageMinus( const aCssSelector : string; aUserEventHandler : HTMLScrollEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
begin
    Result := THTMLayoutEventHandler.Create( SCROLL_PAGE_MINUS , HANDLE_SCROLL or DISABLE_INITIALIZATION, ScrollHandler, aCssSelector, TMethod( aUserEventHandler ), aUserData );
    addEvent( Result );
end;

procedure THTMLayoutEvent.setOnScrollPageMinus( const aCssSelector : string; aUserEventHandler : HTMLScrollEventHandler );
begin
    addOnScrollPageMinus( aCssSelector, aUserEventHandler, nil );
end;

// onScrollPos
function THTMLayoutEvent.addOnScrollPos( const aCssSelector : string; aUserEventHandler : HTMLScrollEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
begin
    Result := THTMLayoutEventHandler.Create( SCROLL_POS , HANDLE_SCROLL or DISABLE_INITIALIZATION, ScrollHandler, aCssSelector, TMethod( aUserEventHandler ), aUserData );
    addEvent( Result );
end;

procedure THTMLayoutEvent.setOnScrollPos( const aCssSelector : string; aUserEventHandler : HTMLScrollEventHandler );
begin
    addOnScrollPos( aCssSelector, aUserEventHandler, nil );
end;

// onScrollSliderReleased
function THTMLayoutEvent.addOnScrollSliderReleased( const aCssSelector : string; aUserEventHandler : HTMLScrollEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
begin
    Result := THTMLayoutEventHandler.Create( SCROLL_SLIDER_RELEASED , HANDLE_SCROLL or DISABLE_INITIALIZATION, ScrollHandler, aCssSelector, TMethod( aUserEventHandler ), aUserData );
    addEvent( Result );
end;

procedure THTMLayoutEvent.setOnScrollSliderReleased( const aCssSelector : string; aUserEventHandler : HTMLScrollEventHandler );
begin
    addOnScrollSliderReleased( aCssSelector, aUserEventHandler, nil );
end;

{-- TIMER ---------------------------------------------------------------------}

function TimerHandler( aUserEventHandler : Pointer; aSender : HELEMENT; aEventGroup : UINT; aEventParams : Pointer ) : BOOL stdcall;
var
    e : THTMLayoutEventHandler;
begin
    Result := false;

    e := THTMLayoutEventHandler( aUserEventHandler );
    try
        Result := HTMLTimerEventHandler( e.Fcallback )( aSender, PHTMLayoutTimerParams( aEventParams ), e.FuserData );
    except
    end;
end;

// onTimer
function THTMLayoutEvent.addOnTimer( const aCssSelector : string; aUserEventHandler : HTMLTimerEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
begin    Result := THTMLayoutEventHandler.Create( ALL_CMD, HANDLE_TIMER or DISABLE_INITIALIZATION, TimerHandler, aCssSelector, TMethod( aUserEventHandler ), aUserData );
    addEvent( Result );
end;

procedure THTMLayoutEvent.setOnTimer( const aCssSelector : string; aUserEventHandler : HTMLTimerEventHandler );
begin
    addOnTimer( aCssSelector, aUserEventHandler, nil );
end;

{-- SIZE ---------------------------------------------------------------------}

function SizeHandler( aUserEventHandler : Pointer; aSender : HELEMENT; aEventGroup : UINT; aEventParams : Pointer ) : BOOL stdcall;
var
    e : THTMLayoutEventHandler;
begin
    Result := false;

    e := THTMLayoutEventHandler( aUserEventHandler );
    try
        Result := HTMLSizeEventHandler( e.Fcallback )( aSender, e.FuserData );
    except
    end;
end;

// onSize
function THTMLayoutEvent.addOnSize( const aCssSelector : string; aUserEventHandler : HTMLSizeEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
begin    Result := THTMLayoutEventHandler.Create( ALL_CMD, HANDLE_SIZE or DISABLE_INITIALIZATION, SizeHandler, aCssSelector, TMethod( aUserEventHandler ), aUserData );
    addEvent( Result );
end;

procedure THTMLayoutEvent.setOnSize( const aCssSelector : string; aUserEventHandler : HTMLSizeEventHandler );
begin
    addOnSize( aCssSelector, aUserEventHandler, nil );
end;

{-- HANDLE_DATA_ARRIVED -------------------------------------------------------}

function DataArrivedHandler( aUserEventHandler : Pointer; aSender : HELEMENT; aEventGroup : UINT; aEventParams : Pointer ) : BOOL stdcall;
var
    e : THTMLayoutEventHandler;
begin
    Result := false;

    e := THTMLayoutEventHandler( aUserEventHandler );
    try
        Result := HTMLDataArrivedEventHandler( e.Fcallback )( aSender, PHTMLayoutDataArrivedParams( aEventParams ), e.FuserData );
    except
    end;
end;

// onDataArrived
function THTMLayoutEvent.addOnDataArrived( const aCssSelector : string; aUserEventHandler : HTMLDataArrivedEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
begin    Result := THTMLayoutEventHandler.Create( ALL_CMD, HANDLE_DATA_ARRIVED or DISABLE_INITIALIZATION, DataArrivedHandler, aCssSelector, TMethod( aUserEventHandler ), aUserData );
    addEvent( Result );
end;

procedure THTMLayoutEvent.setOnDataArrived( const aCssSelector : string; aUserEventHandler : HTMLDataArrivedEventHandler );
begin
    addOnDataArrived( aCssSelector, aUserEventHandler, nil );
end;

{-- DRAW ----------------------------------------------------------------------}

function DrawHandler( aUserEventHandler : Pointer; aSender : HELEMENT; aEventGroup : UINT; aEventParams : Pointer ) : BOOL stdcall;
var
    e : THTMLayoutEventHandler;
begin
    e := THTMLayoutEventHandler( aUserEventHandler );

    Result := e.FallEvents or ( PHTMLayoutDrawParams( aEventParams ).cmd = e.Fcmd );
    if ( not Result ) then
        exit;

    try
        Result := HTMLDrawEventHandler( e.Fcallback )( aSender, PHTMLayoutDrawParams( aEventParams ), e.FuserData );
    except
    end;
end;

// onDraw
function THTMLayoutEvent.addOnDraw( const aCssSelector : string; aUserEventHandler : HTMLDrawEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
begin
    Result := THTMLayoutEventHandler.Create( DRAW_ALL, HANDLE_DRAW or DISABLE_INITIALIZATION, DrawHandler, aCssSelector, TMethod( aUserEventHandler ), aUserData );
    Result.FallEvents := true;

    addEvent( Result );
end;

procedure THTMLayoutEvent.setOnDraw( const aCssSelector : string; aUserEventHandler : HTMLDrawEventHandler );
begin
    addOnDraw( aCssSelector, aUserEventHandler, nil );
end;

// onDrawBackground
function THTMLayoutEvent.addOnDrawBackground( const aCssSelector : string; aUserEventHandler : HTMLDrawEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
begin
    Result := THTMLayoutEventHandler.Create( DRAW_BACKGROUND, HANDLE_DRAW or DISABLE_INITIALIZATION, DrawHandler, aCssSelector, TMethod( aUserEventHandler ), aUserData );
    addEvent( Result );
end;

procedure THTMLayoutEvent.setOnDrawBackground( const aCssSelector : string; aUserEventHandler : HTMLDrawEventHandler );
begin
    addOnDrawBackground( aCssSelector, aUserEventHandler, nil );
end;

// onDrawContent
function THTMLayoutEvent.addOnDrawContent( const aCssSelector : string; aUserEventHandler : HTMLDrawEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
begin
    Result := THTMLayoutEventHandler.Create( DRAW_CONTENT, HANDLE_DRAW or DISABLE_INITIALIZATION, DrawHandler, aCssSelector, TMethod( aUserEventHandler ), aUserData );
    addEvent( Result );
end;

procedure THTMLayoutEvent.setOnDrawContent( const aCssSelector : string; aUserEventHandler : HTMLDrawEventHandler );
begin
    addOnDrawContent( aCssSelector, aUserEventHandler, nil );
end;

// onDrawForeground
function THTMLayoutEvent.addOnDrawForeground( const aCssSelector : string; aUserEventHandler : HTMLDrawEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
begin
    Result := THTMLayoutEventHandler.Create( DRAW_FOREGROUND, HANDLE_DRAW or DISABLE_INITIALIZATION, DrawHandler, aCssSelector, TMethod( aUserEventHandler ), aUserData );
    addEvent( Result );
end;

procedure THTMLayoutEvent.setOnDrawForeground( const aCssSelector : string; aUserEventHandler : HTMLDrawEventHandler );
begin
    addOnDrawForeground( aCssSelector, aUserEventHandler, nil );
end;

{-- EXCHANGE ------------------------------------------------------------------}

function ExchangeHandler( aUserEventHandler : Pointer; aSender : HELEMENT; aEventGroup : UINT; aEventParams : Pointer ) : BOOL stdcall;
var
    e : THTMLayoutEventHandler;
begin
    e := THTMLayoutEventHandler( aUserEventHandler );

    Result := e.FallEvents or ( PHTMLayoutExchangeParams( aEventParams ).cmd = e.Fcmd );
    if ( not Result ) then
        exit;

    try
        Result := HTMLExchangeEventHandler( e.Fcallback )( aSender, PHTMLayoutExchangeParams( aEventParams ), e.FuserData );
    except
    end;
end;

// onExchange
function THTMLayoutEvent.addOnExchange( const aCssSelector : string; aUserEventHandler : HTMLExchangeEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
begin
    Result := THTMLayoutEventHandler.Create( EXC_ALL , HANDLE_EXCHANGE or DISABLE_INITIALIZATION, ExchangeHandler, aCssSelector, TMethod( aUserEventHandler ), aUserData );
    Result.FallEvents := true;

    addEvent( Result );
end;

procedure THTMLayoutEvent.setOnExchange( const aCssSelector : string; aUserEventHandler : HTMLExchangeEventHandler );
begin
    addOnExchange( aCssSelector, aUserEventHandler, nil );
end;

// onExchangeNone
function THTMLayoutEvent.addOnExchangeNone( const aCssSelector : string; aUserEventHandler : HTMLExchangeEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
begin
    Result := THTMLayoutEventHandler.Create( EXC_NONE , HANDLE_EXCHANGE or DISABLE_INITIALIZATION, ExchangeHandler, aCssSelector, TMethod( aUserEventHandler ), aUserData );
    addEvent( Result );
end;

procedure THTMLayoutEvent.setOnExchangeNone( const aCssSelector : string; aUserEventHandler : HTMLExchangeEventHandler );
begin
    addOnExchangeNone( aCssSelector, aUserEventHandler, nil );
end;

// onExchangeCopy
function THTMLayoutEvent.addOnExchangeCopy( const aCssSelector : string; aUserEventHandler : HTMLExchangeEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
begin
    Result := THTMLayoutEventHandler.Create( EXC_COPY , HANDLE_EXCHANGE or DISABLE_INITIALIZATION, ExchangeHandler, aCssSelector, TMethod( aUserEventHandler ), aUserData );
    addEvent( Result );
end;

procedure THTMLayoutEvent.setOnExchangeCopy( const aCssSelector : string; aUserEventHandler : HTMLExchangeEventHandler );
begin
    addOnExchangeCopy( aCssSelector, aUserEventHandler, nil );
end;

// onExchangeMove
function THTMLayoutEvent.addOnExchangeMove( const aCssSelector : string; aUserEventHandler : HTMLExchangeEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
begin
    Result := THTMLayoutEventHandler.Create( EXC_MOVE , HANDLE_EXCHANGE or DISABLE_INITIALIZATION, ExchangeHandler, aCssSelector, TMethod( aUserEventHandler ), aUserData );
    addEvent( Result );
end;

procedure THTMLayoutEvent.setOnExchangeMove( const aCssSelector : string; aUserEventHandler : HTMLExchangeEventHandler );
begin
    addOnExchangeMove( aCssSelector, aUserEventHandler, nil );
end;

// onExchangeLink
function THTMLayoutEvent.addOnExchangeLink( const aCssSelector : string; aUserEventHandler : HTMLExchangeEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
begin
    Result := THTMLayoutEventHandler.Create( EXC_LINK , HANDLE_EXCHANGE or DISABLE_INITIALIZATION, ExchangeHandler, aCssSelector, TMethod( aUserEventHandler ), aUserData );
    addEvent( Result );
end;

procedure THTMLayoutEvent.setOnExchangeLink( const aCssSelector : string; aUserEventHandler : HTMLExchangeEventHandler );
begin
    addOnExchangeLink( aCssSelector, aUserEventHandler, nil );
end;

{-- GESTURE -------------------------------------------------------------------}

function GestureHandler( aUserEventHandler : Pointer; aSender : HELEMENT; aEventGroup : UINT; aEventParams : Pointer ) : BOOL stdcall;
var
    e : THTMLayoutEventHandler;
begin
    e := THTMLayoutEventHandler( aUserEventHandler );

    Result := e.FallEvents or ( PHTMLayoutGestureParams( aEventParams ).cmd = e.Fcmd );
    if ( not Result ) then
        exit;

    try
        Result := HTMLGestureEventHandler( e.Fcallback )( aSender, PHTMLayoutGestureParams( aEventParams ), e.FuserData );
    except
    end;
end;

// onGesture
function THTMLayoutEvent.addOnGesture( const aCssSelector : string; aUserEventHandler : HTMLGestureEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
begin
    Result := THTMLayoutEventHandler.Create( GESTURE_ALL , HANDLE_GESTURE or DISABLE_INITIALIZATION, GestureHandler, aCssSelector, TMethod( aUserEventHandler ), aUserData );
    Result.FallEvents := true;
    
    addEvent( Result );
end;

procedure THTMLayoutEvent.setOnGesture( const aCssSelector : string; aUserEventHandler : HTMLGestureEventHandler );
begin
    addOnGesture( aCssSelector, aUserEventHandler, nil );
end;

// onGestureRequest
function THTMLayoutEvent.addOnGestureRequest( const aCssSelector : string; aUserEventHandler : HTMLGestureEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
begin
    Result := THTMLayoutEventHandler.Create( GESTURE_REQUEST , HANDLE_GESTURE or DISABLE_INITIALIZATION, GestureHandler, aCssSelector, TMethod( aUserEventHandler ), aUserData );
    addEvent( Result );
end;

procedure THTMLayoutEvent.setOnGestureRequest( const aCssSelector : string; aUserEventHandler : HTMLGestureEventHandler );
begin
    addOnGestureRequest( aCssSelector, aUserEventHandler, nil );
end;

// onGestureZoom
function THTMLayoutEvent.addOnGestureZoom( const aCssSelector : string; aUserEventHandler : HTMLGestureEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
begin
    Result := THTMLayoutEventHandler.Create( GESTURE_ZOOM , HANDLE_GESTURE or DISABLE_INITIALIZATION, GestureHandler, aCssSelector, TMethod( aUserEventHandler ), aUserData );
    addEvent( Result );
end;

procedure THTMLayoutEvent.setOnGestureZoom( const aCssSelector : string; aUserEventHandler : HTMLGestureEventHandler );
begin
    addOnGestureZoom( aCssSelector, aUserEventHandler, nil );
end;

// onGesturePan
function THTMLayoutEvent.addOnGesturePan( const aCssSelector : string; aUserEventHandler : HTMLGestureEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
begin
    Result := THTMLayoutEventHandler.Create( GESTURE_PAN , HANDLE_GESTURE or DISABLE_INITIALIZATION, GestureHandler, aCssSelector, TMethod( aUserEventHandler ), aUserData );
    addEvent( Result );
end;

procedure THTMLayoutEvent.setOnGesturePan( const aCssSelector : string; aUserEventHandler : HTMLGestureEventHandler );
begin
    addOnGesturePan( aCssSelector, aUserEventHandler, nil );
end;

// onGestureRotate
function THTMLayoutEvent.addOnGestureRotate( const aCssSelector : string; aUserEventHandler : HTMLGestureEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
begin
    Result := THTMLayoutEventHandler.Create( GESTURE_ROTATE , HANDLE_GESTURE or DISABLE_INITIALIZATION, GestureHandler, aCssSelector, TMethod( aUserEventHandler ), aUserData );
    addEvent( Result );
end;

procedure THTMLayoutEvent.setOnGestureRotate( const aCssSelector : string; aUserEventHandler : HTMLGestureEventHandler );
begin
    addOnGestureRotate( aCssSelector, aUserEventHandler, nil );
end;

// onGestureTap1
function THTMLayoutEvent.addOnGestureTap1( const aCssSelector : string; aUserEventHandler : HTMLGestureEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
begin
    Result := THTMLayoutEventHandler.Create( GESTURE_TAP1 , HANDLE_GESTURE or DISABLE_INITIALIZATION, GestureHandler, aCssSelector, TMethod( aUserEventHandler ), aUserData );
    addEvent( Result );
end;

procedure THTMLayoutEvent.setOnGestureTap1( const aCssSelector : string; aUserEventHandler : HTMLGestureEventHandler );
begin
    addOnGestureTap1( aCssSelector, aUserEventHandler, nil );
end;

// onGestureTap2
function THTMLayoutEvent.addOnGestureTap2( const aCssSelector : string; aUserEventHandler : HTMLGestureEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
begin
    Result := THTMLayoutEventHandler.Create( GESTURE_TAP2 , HANDLE_GESTURE or DISABLE_INITIALIZATION, GestureHandler, aCssSelector, TMethod( aUserEventHandler ), aUserData );
    addEvent( Result );
end;

procedure THTMLayoutEvent.setOnGestureTap2( const aCssSelector : string; aUserEventHandler : HTMLGestureEventHandler );
begin
    addOnGestureTap2( aCssSelector, aUserEventHandler, nil );
end;

{-- BEHAVIOR_EVENT ------------------------------------------------------------}

function BehaviorEventHandler( aUserEventHandler : Pointer; aSender : HELEMENT; aEventGroup : UINT; aEventParams : Pointer ) : BOOL stdcall;
var
    e : THTMLayoutEventHandler;
begin
    e := THTMLayoutEventHandler( aUserEventHandler );

    Result := e.FallEvents or ( PHTMLayoutBehaviorEventParams( aEventParams ).cmd = e.Fcmd );
    if ( not Result ) then
        exit;

    try
        Result := HTMLBehaviorEventHandler( e.Fcallback )( aSender, PHTMLayoutBehaviorEventParams( aEventParams ), e.FuserData );
    except
    end;
end;

// onButtonClick
function THTMLayoutEvent.addOnButtonClick( const aCssSelector : string; aUserEventHandler : HTMLBehaviorEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
begin
    Result := THTMLayoutEventHandler.Create( BUTTON_CLICK , HANDLE_BEHAVIOR_EVENT or DISABLE_INITIALIZATION, BehaviorEventHandler, aCssSelector, TMethod( aUserEventHandler ), aUserData );
    addEvent( Result );
end;

procedure THTMLayoutEvent.setOnButtonClick( const aCssSelector : string; aUserEventHandler : HTMLBehaviorEventHandler );
begin
    addOnButtonClick( aCssSelector, aUserEventHandler, nil );
end;

// onButtonPress
function THTMLayoutEvent.addOnButtonPress( const aCssSelector : string; aUserEventHandler : HTMLBehaviorEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
begin
    Result := THTMLayoutEventHandler.Create( BUTTON_PRESS , HANDLE_BEHAVIOR_EVENT or DISABLE_INITIALIZATION, BehaviorEventHandler, aCssSelector, TMethod( aUserEventHandler ), aUserData );
    addEvent( Result );
end;

procedure THTMLayoutEvent.setOnButtonPress( const aCssSelector : string; aUserEventHandler : HTMLBehaviorEventHandler );
begin
    addOnButtonPress( aCssSelector, aUserEventHandler, nil );
end;

// onButtonStateChanged
function THTMLayoutEvent.addOnButtonStateChanged( const aCssSelector : string; aUserEventHandler : HTMLBehaviorEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
begin
    Result := THTMLayoutEventHandler.Create( BUTTON_STATE_CHANGED , HANDLE_BEHAVIOR_EVENT or DISABLE_INITIALIZATION, BehaviorEventHandler, aCssSelector, TMethod( aUserEventHandler ), aUserData );
    addEvent( Result );
end;

procedure THTMLayoutEvent.setOnButtonStateChanged( const aCssSelector : string; aUserEventHandler : HTMLBehaviorEventHandler );
begin
    addOnButtonStateChanged( aCssSelector, aUserEventHandler, nil );
end;

// onEditValueChanging
function THTMLayoutEvent.addOnEditValueChanging( const aCssSelector : string; aUserEventHandler : HTMLBehaviorEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
begin
    Result := THTMLayoutEventHandler.Create( EDIT_VALUE_CHANGING , HANDLE_BEHAVIOR_EVENT or DISABLE_INITIALIZATION, BehaviorEventHandler, aCssSelector, TMethod( aUserEventHandler ), aUserData );
    addEvent( Result );
end;

procedure THTMLayoutEvent.setOnEditValueChanging( const aCssSelector : string; aUserEventHandler : HTMLBehaviorEventHandler );
begin
    addOnEditValueChanging( aCssSelector, aUserEventHandler, nil );
end;

// onEditValueChanged
function THTMLayoutEvent.addOnEditValueChanged( const aCssSelector : string; aUserEventHandler : HTMLBehaviorEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
begin
    Result := THTMLayoutEventHandler.Create( EDIT_VALUE_CHANGED , HANDLE_BEHAVIOR_EVENT or DISABLE_INITIALIZATION, BehaviorEventHandler, aCssSelector, TMethod( aUserEventHandler ), aUserData );
    addEvent( Result );
end;

procedure THTMLayoutEvent.setOnEditValueChanged( const aCssSelector : string; aUserEventHandler : HTMLBehaviorEventHandler );
begin
    addOnEditValueChanged( aCssSelector, aUserEventHandler, nil );
end;

// onSelectSelectionChanged
function THTMLayoutEvent.addOnSelectSelectionChanged( const aCssSelector : string; aUserEventHandler : HTMLBehaviorEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
begin
    Result := THTMLayoutEventHandler.Create( SELECT_SELECTION_CHANGED , HANDLE_BEHAVIOR_EVENT or DISABLE_INITIALIZATION, BehaviorEventHandler, aCssSelector, TMethod( aUserEventHandler ), aUserData );
    addEvent( Result );
end;

procedure THTMLayoutEvent.setOnSelectSelectionChanged( const aCssSelector : string; aUserEventHandler : HTMLBehaviorEventHandler );
begin
    addOnSelectSelectionChanged( aCssSelector, aUserEventHandler, nil );
end;

// onSelectStateChanged
function THTMLayoutEvent.addOnSelectStateChanged( const aCssSelector : string; aUserEventHandler : HTMLBehaviorEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
begin
    Result := THTMLayoutEventHandler.Create( SELECT_STATE_CHANGED , HANDLE_BEHAVIOR_EVENT or DISABLE_INITIALIZATION, BehaviorEventHandler, aCssSelector, TMethod( aUserEventHandler ), aUserData );
    addEvent( Result );
end;

procedure THTMLayoutEvent.setOnSelectStateChanged( const aCssSelector : string; aUserEventHandler : HTMLBehaviorEventHandler );
begin
    addOnSelectStateChanged( aCssSelector, aUserEventHandler, nil );
end;

// onPopupRequest
function THTMLayoutEvent.addOnPopupRequest( const aCssSelector : string; aUserEventHandler : HTMLBehaviorEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
begin
    Result := THTMLayoutEventHandler.Create( POPUP_REQUEST , HANDLE_BEHAVIOR_EVENT or DISABLE_INITIALIZATION, BehaviorEventHandler, aCssSelector, TMethod( aUserEventHandler ), aUserData );
    addEvent( Result );
end;

procedure THTMLayoutEvent.setOnPopupRequest( const aCssSelector : string; aUserEventHandler : HTMLBehaviorEventHandler );
begin
    addOnPopupRequest( aCssSelector, aUserEventHandler, nil );
end;

// onPopupReady
function THTMLayoutEvent.addOnPopupReady( const aCssSelector : string; aUserEventHandler : HTMLBehaviorEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
begin
    Result := THTMLayoutEventHandler.Create( POPUP_READY , HANDLE_BEHAVIOR_EVENT or DISABLE_INITIALIZATION, BehaviorEventHandler, aCssSelector, TMethod( aUserEventHandler ), aUserData );
    addEvent( Result );
end;

procedure THTMLayoutEvent.setOnPopupReady( const aCssSelector : string; aUserEventHandler : HTMLBehaviorEventHandler );
begin
    addOnPopupReady( aCssSelector, aUserEventHandler, nil );
end;

// onPopupDismissed
function THTMLayoutEvent.addOnPopupDismissed( const aCssSelector : string; aUserEventHandler : HTMLBehaviorEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
begin
    Result := THTMLayoutEventHandler.Create( POPUP_DISMISSED , HANDLE_BEHAVIOR_EVENT or DISABLE_INITIALIZATION, BehaviorEventHandler, aCssSelector, TMethod( aUserEventHandler ), aUserData );
    addEvent( Result );
end;

procedure THTMLayoutEvent.setOnPopupDismissed( const aCssSelector : string; aUserEventHandler : HTMLBehaviorEventHandler );
begin
    addOnPopupDismissed( aCssSelector, aUserEventHandler, nil );
end;

// onMenuItemActive
function THTMLayoutEvent.addOnMenuItemActive( const aCssSelector : string; aUserEventHandler : HTMLBehaviorEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
begin
    Result := THTMLayoutEventHandler.Create( MENU_ITEM_ACTIVE , HANDLE_BEHAVIOR_EVENT or DISABLE_INITIALIZATION, BehaviorEventHandler, aCssSelector, TMethod( aUserEventHandler ), aUserData );
    addEvent( Result );
end;

procedure THTMLayoutEvent.setOnMenuItemActive( const aCssSelector : string; aUserEventHandler : HTMLBehaviorEventHandler );
begin
    addOnMenuItemActive( aCssSelector, aUserEventHandler, nil );
end;

// onMenuItemClick
function THTMLayoutEvent.addOnMenuItemClick( const aCssSelector : string; aUserEventHandler : HTMLBehaviorEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
begin
    Result := THTMLayoutEventHandler.Create( MENU_ITEM_CLICK , HANDLE_BEHAVIOR_EVENT or DISABLE_INITIALIZATION, BehaviorEventHandler, aCssSelector, TMethod( aUserEventHandler ), aUserData );
    addEvent( Result );
end;

procedure THTMLayoutEvent.setOnMenuItemClick( const aCssSelector : string; aUserEventHandler : HTMLBehaviorEventHandler );
begin
    addOnMenuItemClick( aCssSelector, aUserEventHandler, nil );
end;

// onContextMenuSetup
function THTMLayoutEvent.addOnContextMenuSetup( const aCssSelector : string; aUserEventHandler : HTMLBehaviorEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
begin
    Result := THTMLayoutEventHandler.Create( CONTEXT_MENU_SETUP , HANDLE_BEHAVIOR_EVENT or DISABLE_INITIALIZATION, BehaviorEventHandler, aCssSelector, TMethod( aUserEventHandler ), aUserData );
    addEvent( Result );
end;

procedure THTMLayoutEvent.setOnContextMenuSetup( const aCssSelector : string; aUserEventHandler : HTMLBehaviorEventHandler );
begin
    addOnContextMenuSetup( aCssSelector, aUserEventHandler, nil );
end;

// onContextMenuRequest
function THTMLayoutEvent.addOnContextMenuRequest( const aCssSelector : string; aUserEventHandler : HTMLBehaviorEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
begin
    Result := THTMLayoutEventHandler.Create( CONTEXT_MENU_REQUEST , HANDLE_BEHAVIOR_EVENT or DISABLE_INITIALIZATION, BehaviorEventHandler, aCssSelector, TMethod( aUserEventHandler ), aUserData );
    addEvent( Result );
end;

procedure THTMLayoutEvent.setOnContextMenuRequest( const aCssSelector : string; aUserEventHandler : HTMLBehaviorEventHandler );
begin
    addOnContextMenuRequest( aCssSelector, aUserEventHandler, nil );
end;

// onVisiualStatusChanged
function THTMLayoutEvent.addOnVisiualStatusChanged( const aCssSelector : string; aUserEventHandler : HTMLBehaviorEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
begin
    Result := THTMLayoutEventHandler.Create( VISIUAL_STATUS_CHANGED , HANDLE_BEHAVIOR_EVENT or DISABLE_INITIALIZATION, BehaviorEventHandler, aCssSelector, TMethod( aUserEventHandler ), aUserData );
    addEvent( Result );
end;

procedure THTMLayoutEvent.setOnVisiualStatusChanged( const aCssSelector : string; aUserEventHandler : HTMLBehaviorEventHandler );
begin
    addOnVisiualStatusChanged( aCssSelector, aUserEventHandler, nil );
end;

// onDisabledStatusChanged
function THTMLayoutEvent.addOnDisabledStatusChanged( const aCssSelector : string; aUserEventHandler : HTMLBehaviorEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
begin
    Result := THTMLayoutEventHandler.Create( DISABLED_STATUS_CHANGED , HANDLE_BEHAVIOR_EVENT or DISABLE_INITIALIZATION, BehaviorEventHandler, aCssSelector, TMethod( aUserEventHandler ), aUserData );
    addEvent( Result );
end;

procedure THTMLayoutEvent.setOnDisabledStatusChanged( const aCssSelector : string; aUserEventHandler : HTMLBehaviorEventHandler );
begin
    addOnDisabledStatusChanged( aCssSelector, aUserEventHandler, nil );
end;

// onPopupDismissing
function THTMLayoutEvent.addOnPopupDismissing( const aCssSelector : string; aUserEventHandler : HTMLBehaviorEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
begin
    Result := THTMLayoutEventHandler.Create( POPUP_DISMISSING , HANDLE_BEHAVIOR_EVENT or DISABLE_INITIALIZATION, BehaviorEventHandler, aCssSelector, TMethod( aUserEventHandler ), aUserData );
    addEvent( Result );
end;

procedure THTMLayoutEvent.setOnPopupDismissing( const aCssSelector : string; aUserEventHandler : HTMLBehaviorEventHandler );
begin
    addOnPopupDismissing( aCssSelector, aUserEventHandler, nil );
end;

// "grey" event codes  - notfications from behaviors from this SDK
    
// onHyperLinkClick
function THTMLayoutEvent.addOnHyperLinkClick( const aCssSelector : string; aUserEventHandler : HTMLBehaviorEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
begin
    Result := THTMLayoutEventHandler.Create( HYPERLINK_CLICK , HANDLE_BEHAVIOR_EVENT or DISABLE_INITIALIZATION, BehaviorEventHandler, aCssSelector, TMethod( aUserEventHandler ), aUserData );
    addEvent( Result );
end;

procedure THTMLayoutEvent.setOnHyperLinkClick( const aCssSelector : string; aUserEventHandler : HTMLBehaviorEventHandler );
begin
    addOnHyperLinkClick( aCssSelector, aUserEventHandler, nil );
end;

// onTableHeaderClick
function THTMLayoutEvent.addOnTableHeaderClick( const aCssSelector : string; aUserEventHandler : HTMLBehaviorEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
begin
    Result := THTMLayoutEventHandler.Create( TABLE_HEADER_CLICK , HANDLE_BEHAVIOR_EVENT or DISABLE_INITIALIZATION, BehaviorEventHandler, aCssSelector, TMethod( aUserEventHandler ), aUserData );
    addEvent( Result );
end;

procedure THTMLayoutEvent.setOnTableHeaderClick( const aCssSelector : string; aUserEventHandler : HTMLBehaviorEventHandler );
begin
    addOnTableHeaderClick( aCssSelector, aUserEventHandler, nil );
end;

// onTableRowClick
function THTMLayoutEvent.addOnTableRowClick( const aCssSelector : string; aUserEventHandler : HTMLBehaviorEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
begin
    Result := THTMLayoutEventHandler.Create( TABLE_ROW_CLICK , HANDLE_BEHAVIOR_EVENT or DISABLE_INITIALIZATION, BehaviorEventHandler, aCssSelector, TMethod( aUserEventHandler ), aUserData );
    addEvent( Result );
end;

procedure THTMLayoutEvent.setOnTableRowClick( const aCssSelector : string; aUserEventHandler : HTMLBehaviorEventHandler );
begin
    addOnTableRowClick( aCssSelector, aUserEventHandler, nil );
end;

// onTableRowDblClick
function THTMLayoutEvent.addOnTableRowDblClick( const aCssSelector : string; aUserEventHandler : HTMLBehaviorEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
begin
    Result := THTMLayoutEventHandler.Create( TABLE_ROW_DBL_CLICK , HANDLE_BEHAVIOR_EVENT or DISABLE_INITIALIZATION, BehaviorEventHandler, aCssSelector, TMethod( aUserEventHandler ), aUserData );
    addEvent( Result );
end;

procedure THTMLayoutEvent.setOnTableRowDblClick( const aCssSelector : string; aUserEventHandler : HTMLBehaviorEventHandler );
begin
    addOnTableRowDblClick( aCssSelector, aUserEventHandler, nil );
end;

// onElementCollapsed
function THTMLayoutEvent.addOnElementCollapsed( const aCssSelector : string; aUserEventHandler : HTMLBehaviorEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
begin
    Result := THTMLayoutEventHandler.Create( ELEMENT_COLLAPSED , HANDLE_BEHAVIOR_EVENT or DISABLE_INITIALIZATION, BehaviorEventHandler, aCssSelector, TMethod( aUserEventHandler ), aUserData );
    addEvent( Result );
end;

procedure THTMLayoutEvent.setOnElementCollapsed( const aCssSelector : string; aUserEventHandler : HTMLBehaviorEventHandler );
begin
    addOnElementCollapsed( aCssSelector, aUserEventHandler, nil );
end;

// onElementExpanded
function THTMLayoutEvent.addOnElementExpanded( const aCssSelector : string; aUserEventHandler : HTMLBehaviorEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
begin
    Result := THTMLayoutEventHandler.Create( ELEMENT_EXPANDED , HANDLE_BEHAVIOR_EVENT or DISABLE_INITIALIZATION, BehaviorEventHandler, aCssSelector, TMethod( aUserEventHandler ), aUserData );
    addEvent( Result );
end;

procedure THTMLayoutEvent.setOnElementExpanded( const aCssSelector : string; aUserEventHandler : HTMLBehaviorEventHandler );
begin
    addOnElementExpanded( aCssSelector, aUserEventHandler, nil );
end;

// onActivateChild
function THTMLayoutEvent.addOnActivateChild( const aCssSelector : string; aUserEventHandler : HTMLBehaviorEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
begin
    Result := THTMLayoutEventHandler.Create( ACTIVATE_CHILD , HANDLE_BEHAVIOR_EVENT or DISABLE_INITIALIZATION, BehaviorEventHandler, aCssSelector, TMethod( aUserEventHandler ), aUserData );
    addEvent( Result );
end;

procedure THTMLayoutEvent.setOnActivateChild( const aCssSelector : string; aUserEventHandler : HTMLBehaviorEventHandler );
begin
    addOnActivateChild( aCssSelector, aUserEventHandler, nil );
end;

// onDoSwitchTab
function THTMLayoutEvent.addOnDoSwitchTab( const aCssSelector : string; aUserEventHandler : HTMLBehaviorEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
begin
    Result := THTMLayoutEventHandler.Create( DO_SWITCH_TAB , HANDLE_BEHAVIOR_EVENT or DISABLE_INITIALIZATION, BehaviorEventHandler, aCssSelector, TMethod( aUserEventHandler ), aUserData );
    addEvent( Result );
end;

procedure THTMLayoutEvent.setOnDoSwitchTab( const aCssSelector : string; aUserEventHandler : HTMLBehaviorEventHandler );
begin
    addOnDoSwitchTab( aCssSelector, aUserEventHandler, nil );
end;

// onInitDataView
function THTMLayoutEvent.addOnInitDataView( const aCssSelector : string; aUserEventHandler : HTMLBehaviorEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
begin
    Result := THTMLayoutEventHandler.Create( INIT_DATA_VIEW , HANDLE_BEHAVIOR_EVENT or DISABLE_INITIALIZATION, BehaviorEventHandler, aCssSelector, TMethod( aUserEventHandler ), aUserData );
    addEvent( Result );
end;

procedure THTMLayoutEvent.setOnInitDataView( const aCssSelector : string; aUserEventHandler : HTMLBehaviorEventHandler );
begin
    addOnInitDataView( aCssSelector, aUserEventHandler, nil );
end;

// onRowsDataRequest
function THTMLayoutEvent.addOnRowsDataRequest( const aCssSelector : string; aUserEventHandler : HTMLBehaviorEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
begin
    Result := THTMLayoutEventHandler.Create( ROWS_DATA_REQUEST , HANDLE_BEHAVIOR_EVENT or DISABLE_INITIALIZATION, BehaviorEventHandler, aCssSelector, TMethod( aUserEventHandler ), aUserData );
    addEvent( Result );
end;

procedure THTMLayoutEvent.setOnRowsDataRequest( const aCssSelector : string; aUserEventHandler : HTMLBehaviorEventHandler );
begin
    addOnRowsDataRequest( aCssSelector, aUserEventHandler, nil );
end;

// onUiStateChanged
function THTMLayoutEvent.addOnUiStateChanged( const aCssSelector : string; aUserEventHandler : HTMLBehaviorEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
begin
    Result := THTMLayoutEventHandler.Create( UI_STATE_CHANGED , HANDLE_BEHAVIOR_EVENT or DISABLE_INITIALIZATION, BehaviorEventHandler, aCssSelector, TMethod( aUserEventHandler ), aUserData );
    addEvent( Result );
end;

procedure THTMLayoutEvent.setOnUiStateChanged( const aCssSelector : string; aUserEventHandler : HTMLBehaviorEventHandler );
begin
    addOnUiStateChanged( aCssSelector, aUserEventHandler, nil );
end;

// onFormSubmit
function THTMLayoutEvent.addOnFormSubmit( const aCssSelector : string; aUserEventHandler : HTMLBehaviorEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
begin
    Result := THTMLayoutEventHandler.Create( FORM_SUBMIT , HANDLE_BEHAVIOR_EVENT or DISABLE_INITIALIZATION, BehaviorEventHandler, aCssSelector, TMethod( aUserEventHandler ), aUserData );
    addEvent( Result );
end;

procedure THTMLayoutEvent.setOnFormSubmit( const aCssSelector : string; aUserEventHandler : HTMLBehaviorEventHandler );
begin
    addOnFormSubmit( aCssSelector, aUserEventHandler, nil );
end;

// onFormReset
function THTMLayoutEvent.addOnFormReset( const aCssSelector : string; aUserEventHandler : HTMLBehaviorEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
begin
    Result := THTMLayoutEventHandler.Create( FORM_RESET , HANDLE_BEHAVIOR_EVENT or DISABLE_INITIALIZATION, BehaviorEventHandler, aCssSelector, TMethod( aUserEventHandler ), aUserData );
    addEvent( Result );
end;

procedure THTMLayoutEvent.setOnFormReset( const aCssSelector : string; aUserEventHandler : HTMLBehaviorEventHandler );
begin
    addOnFormReset( aCssSelector, aUserEventHandler, nil );
end;

// onDocumentComplete
function THTMLayoutEvent.addOnDocumentComplete( const aCssSelector : string; aUserEventHandler : HTMLBehaviorEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
begin
    Result := THTMLayoutEventHandler.Create( DOCUMENT_COMPLETE , HANDLE_BEHAVIOR_EVENT or DISABLE_INITIALIZATION, BehaviorEventHandler, aCssSelector, TMethod( aUserEventHandler ), aUserData );
    addEvent( Result );
end;

procedure THTMLayoutEvent.setOnDocumentComplete( const aCssSelector : string; aUserEventHandler : HTMLBehaviorEventHandler );
begin
    addOnDocumentComplete( aCssSelector, aUserEventHandler, nil );
end;

// onHistoryPush
function THTMLayoutEvent.addOnHistoryPush( const aCssSelector : string; aUserEventHandler : HTMLBehaviorEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
begin
    Result := THTMLayoutEventHandler.Create( HISTORY_PUSH , HANDLE_BEHAVIOR_EVENT or DISABLE_INITIALIZATION, BehaviorEventHandler, aCssSelector, TMethod( aUserEventHandler ), aUserData );
    addEvent( Result );
end;

procedure THTMLayoutEvent.setOnHistoryPush( const aCssSelector : string; aUserEventHandler : HTMLBehaviorEventHandler );
begin
    addOnHistoryPush( aCssSelector, aUserEventHandler, nil );
end;

// onHistoryDrop
function THTMLayoutEvent.addOnHistoryDrop( const aCssSelector : string; aUserEventHandler : HTMLBehaviorEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
begin
    Result := THTMLayoutEventHandler.Create( HISTORY_DROP , HANDLE_BEHAVIOR_EVENT or DISABLE_INITIALIZATION, BehaviorEventHandler, aCssSelector, TMethod( aUserEventHandler ), aUserData );
    addEvent( Result );
end;

procedure THTMLayoutEvent.setOnHistoryDrop( const aCssSelector : string; aUserEventHandler : HTMLBehaviorEventHandler );
begin
    addOnHistoryDrop( aCssSelector, aUserEventHandler, nil );
end;

// onHistoryPrior
function THTMLayoutEvent.addOnHistoryPrior( const aCssSelector : string; aUserEventHandler : HTMLBehaviorEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
begin
    Result := THTMLayoutEventHandler.Create( HISTORY_PRIOR , HANDLE_BEHAVIOR_EVENT or DISABLE_INITIALIZATION, BehaviorEventHandler, aCssSelector, TMethod( aUserEventHandler ), aUserData );
    addEvent( Result );
end;

procedure THTMLayoutEvent.setOnHistoryPrior( const aCssSelector : string; aUserEventHandler : HTMLBehaviorEventHandler );
begin
    addOnHistoryPrior( aCssSelector, aUserEventHandler, nil );
end;

// onHistoryNext
function THTMLayoutEvent.addOnHistoryNext( const aCssSelector : string; aUserEventHandler : HTMLBehaviorEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
begin
    Result := THTMLayoutEventHandler.Create( HISTORY_NEXT , HANDLE_BEHAVIOR_EVENT or DISABLE_INITIALIZATION, BehaviorEventHandler, aCssSelector, TMethod( aUserEventHandler ), aUserData );
    addEvent( Result );
end;

procedure THTMLayoutEvent.setOnHistoryNext( const aCssSelector : string; aUserEventHandler : HTMLBehaviorEventHandler );
begin
    addOnHistoryNext( aCssSelector, aUserEventHandler, nil );
end;

// onHistoryStateChanged
function THTMLayoutEvent.addOnHistoryStateChanged( const aCssSelector : string; aUserEventHandler : HTMLBehaviorEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
begin
    Result := THTMLayoutEventHandler.Create( HISTORY_STATE_CHANGED , HANDLE_BEHAVIOR_EVENT or DISABLE_INITIALIZATION, BehaviorEventHandler, aCssSelector, TMethod( aUserEventHandler ), aUserData );
    addEvent( Result );
end;

procedure THTMLayoutEvent.setOnHistoryStateChanged( const aCssSelector : string; aUserEventHandler : HTMLBehaviorEventHandler );
begin
    addOnHistoryStateChanged( aCssSelector, aUserEventHandler, nil );
end;

// onClosePopup
function THTMLayoutEvent.addOnClosePopup( const aCssSelector : string; aUserEventHandler : HTMLBehaviorEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
begin
    Result := THTMLayoutEventHandler.Create( CLOSE_POPUP , HANDLE_BEHAVIOR_EVENT or DISABLE_INITIALIZATION, BehaviorEventHandler, aCssSelector, TMethod( aUserEventHandler ), aUserData );
    addEvent( Result );
end;

procedure THTMLayoutEvent.setOnClosePopup( const aCssSelector : string; aUserEventHandler : HTMLBehaviorEventHandler );
begin
    addOnClosePopup( aCssSelector, aUserEventHandler, nil );
end;

// onRequestTooltip
function THTMLayoutEvent.addOnRequestTooltip( const aCssSelector : string; aUserEventHandler : HTMLBehaviorEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
begin
    Result := THTMLayoutEventHandler.Create( REQUEST_TOOLTIP , HANDLE_BEHAVIOR_EVENT or DISABLE_INITIALIZATION, BehaviorEventHandler, aCssSelector, TMethod( aUserEventHandler ), aUserData );
    addEvent( Result );
end;

procedure THTMLayoutEvent.setOnRequestTooltip( const aCssSelector : string; aUserEventHandler : HTMLBehaviorEventHandler );
begin
    addOnRequestTooltip( aCssSelector, aUserEventHandler, nil );
end;

// onAnimation
function THTMLayoutEvent.addOnAnimation( const aCssSelector : string; aUserEventHandler : HTMLBehaviorEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
begin
    Result := THTMLayoutEventHandler.Create( ANIMATION , HANDLE_BEHAVIOR_EVENT or DISABLE_INITIALIZATION, BehaviorEventHandler, aCssSelector, TMethod( aUserEventHandler ), aUserData );
    addEvent( Result );
end;

procedure THTMLayoutEvent.setOnAnimation( const aCssSelector : string; aUserEventHandler : HTMLBehaviorEventHandler );
begin
    addOnAnimation( aCssSelector, aUserEventHandler, nil );
end;

INITIALIZATION
    PhaseMask := UINT( not ( UINT( SINKING ) or UINT( HANDLED ) ) );
end.
