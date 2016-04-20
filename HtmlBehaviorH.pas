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
    Fevents                     : TObjectList; // lits of THTMLayoutEventHandler

public
    constructor Create();
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
    function    onInitialization( const aCssSelector : string; aUserEventHandler : HTMLInitializationEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;  
    function    onBehaviorDetach( const aCssSelector : string; aUserEventHandler : HTMLInitializationEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;  
    function    onBehaviorAttach( const aCssSelector : string; aUserEventHandler : HTMLInitializationEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
    
    // MOUSE
    function    onMouse( const aCssSelector : string; aUserEventHandler : HTMLMouseEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
    function    onMouseEnter( const aCssSelector : string; aUserEventHandler : HTMLMouseEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;  
    function    onMouseLeave( const aCssSelector : string; aUserEventHandler : HTMLMouseEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;  
    function    onMouseMove( const aCssSelector : string; aUserEventHandler : HTMLMouseEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;  
    function    onMouseUp( const aCssSelector : string; aUserEventHandler : HTMLMouseEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;  
    function    onMouseDown( const aCssSelector : string; aUserEventHandler : HTMLMouseEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;  
    function    onMouseClick( const aCssSelector : string; aUserEventHandler : HTMLMouseEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;  
    function    onClick( const aCssSelector : string; aUserEventHandler : HTMLMouseEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;  
    function    onMouseDClick( const aCssSelector : string; aUserEventHandler : HTMLMouseEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;  
    function    onDblClick( const aCssSelector : string; aUserEventHandler : HTMLMouseEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;  
    function    onMouseWheel( const aCssSelector : string; aUserEventHandler : HTMLMouseEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;  
    function    onWheel( const aCssSelector : string; aUserEventHandler : HTMLMouseEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;  
    function    onMouseTick( const aCssSelector : string; aUserEventHandler : HTMLMouseEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;  
    function    onMouseIdle( const aCssSelector : string; aUserEventHandler : HTMLMouseEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;  
    function    onDrop( const aCssSelector : string; aUserEventHandler : HTMLMouseEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;  
    function    onDragEnter( const aCssSelector : string; aUserEventHandler : HTMLMouseEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;  
    function    onDragLeave( const aCssSelector : string; aUserEventHandler : HTMLMouseEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;  
    function    onDragRequest( const aCssSelector : string; aUserEventHandler : HTMLMouseEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;  
    function    onMouseDraggingEnter( const aCssSelector : string; aUserEventHandler : HTMLMouseEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;  
    function    onMouseDraggingLeave( const aCssSelector : string; aUserEventHandler : HTMLMouseEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;  
    function    onMouseDraggingMove( const aCssSelector : string; aUserEventHandler : HTMLMouseEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;  
    function    onMouseDraggingUp( const aCssSelector : string; aUserEventHandler : HTMLMouseEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;  
    function    onMouseDraggingDown( const aCssSelector : string; aUserEventHandler : HTMLMouseEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;

    // KEY
    function    onKey( const aCssSelector : string; aUserEventHandler : HTMLKeyEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
    function    onKeyDown( const aCssSelector : string; aUserEventHandler : HTMLKeyEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;  
    function    onKeyUp( const aCssSelector : string; aUserEventHandler : HTMLKeyEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;  
    function    onKeyChar( const aCssSelector : string; aUserEventHandler : HTMLKeyEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;  

    // FOCUS
    function    onFocus( const aCssSelector : string; aUserEventHandler : HTMLFocusEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;  
    function    onFocusLost( const aCssSelector : string; aUserEventHandler : HTMLFocusEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;  
    function    onFocusGot( const aCssSelector : string; aUserEventHandler : HTMLFocusEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;  

    // SCROLL
    function    onScroll( const aCssSelector : string; aUserEventHandler : HTMLScrollEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
    function    onScrollHome( const aCssSelector : string; aUserEventHandler : HTMLScrollEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
    function    onScrollEnd( const aCssSelector : string; aUserEventHandler : HTMLScrollEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
    function    onScrollStepPlus( const aCssSelector : string; aUserEventHandler : HTMLScrollEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
    function    onScrollStepMinus( const aCssSelector : string; aUserEventHandler : HTMLScrollEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
    function    onScrollPagePlus( const aCssSelector : string; aUserEventHandler : HTMLScrollEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
    function    onScrollPageMinus( const aCssSelector : string; aUserEventHandler : HTMLScrollEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
    function    onScrollPos( const aCssSelector : string; aUserEventHandler : HTMLScrollEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
    function    onScrollSliderReleased( const aCssSelector : string; aUserEventHandler : HTMLScrollEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;

    // TIMER
    function    onTimer( const aCssSelector : string; aUserEventHandler : HTMLTimerEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;

    // SIZE
    function    onSize( const aCssSelector : string; aUserEventHandler : HTMLSizeEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;

    // DRAW
    function    onDraw( const aCssSelector : string; aUserEventHandler : HTMLDrawEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
    function    onDrawBackground( const aCssSelector : string; aUserEventHandler : HTMLDrawEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;  
    function    onDrawContent( const aCssSelector : string; aUserEventHandler : HTMLDrawEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;  
    function    onDrawForeground( const aCssSelector : string; aUserEventHandler : HTMLDrawEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;

    // HANDLE_DATA_ARRIVED
    function    onDataArrived( const aCssSelector : string; aUserEventHandler : HTMLDataArrivedEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;

    // EXCHANGE
    function    onExchange( const aCssSelector : string; aUserEventHandler : HTMLExchangeEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;  
    function    onExchangeNone( const aCssSelector : string; aUserEventHandler : HTMLExchangeEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;  
    function    onExchangeCopy( const aCssSelector : string; aUserEventHandler : HTMLExchangeEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;  
    function    onExchangeMove( const aCssSelector : string; aUserEventHandler : HTMLExchangeEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;  
    function    onExchangeLink( const aCssSelector : string; aUserEventHandler : HTMLExchangeEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;  

    // GESTURE
    function    onGesture( const aCssSelector : string; aUserEventHandler : HTMLGestureEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;  
    function    onGestureRequest( const aCssSelector : string; aUserEventHandler : HTMLGestureEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;  
    function    onGestureZoom( const aCssSelector : string; aUserEventHandler : HTMLGestureEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;  
    function    onGesturePan( const aCssSelector : string; aUserEventHandler : HTMLGestureEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;  
    function    onGestureRotate( const aCssSelector : string; aUserEventHandler : HTMLGestureEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;  
    function    onGestureTap1( const aCssSelector : string; aUserEventHandler : HTMLGestureEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;  
    function    onGestureTap2( const aCssSelector : string; aUserEventHandler : HTMLGestureEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;  

    // BEHAVIOR_EVENT
    function    onButtonClick( const aCssSelector : string; aUserEventHandler : HTMLBehaviorEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;  
    function    onButtonPress( const aCssSelector : string; aUserEventHandler : HTMLBehaviorEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;  
    function    onButtonStateChanged( const aCssSelector : string; aUserEventHandler : HTMLBehaviorEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;  
    function    onEditValueChanging( const aCssSelector : string; aUserEventHandler : HTMLBehaviorEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;  
    function    onEditValueChanged( const aCssSelector : string; aUserEventHandler : HTMLBehaviorEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;  
    function    onSelectSelectionChanged( const aCssSelector : string; aUserEventHandler : HTMLBehaviorEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;  
    function    onSelectStateChanged( const aCssSelector : string; aUserEventHandler : HTMLBehaviorEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;  
    function    onPopupRequest( const aCssSelector : string; aUserEventHandler : HTMLBehaviorEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;  
    function    onPopupReady( const aCssSelector : string; aUserEventHandler : HTMLBehaviorEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;  
    function    onPopupDismissed( const aCssSelector : string; aUserEventHandler : HTMLBehaviorEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;  
    function    onMenuItemActive( const aCssSelector : string; aUserEventHandler : HTMLBehaviorEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;  
    function    onMenuItemClick( const aCssSelector : string; aUserEventHandler : HTMLBehaviorEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;  
    function    onContextMenuSetup( const aCssSelector : string; aUserEventHandler : HTMLBehaviorEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;  
    function    onContextMenuRequest( const aCssSelector : string; aUserEventHandler : HTMLBehaviorEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;  
    function    onVisiualStatusChanged( const aCssSelector : string; aUserEventHandler : HTMLBehaviorEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;  
    function    onDisabledStatusChanged( const aCssSelector : string; aUserEventHandler : HTMLBehaviorEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;  
    function    onPopupDismissing( const aCssSelector : string; aUserEventHandler : HTMLBehaviorEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;  
    // "grey" event codes  - notfications from behaviors from this SDK
    function    onHyperLinkClick( const aCssSelector : string; aUserEventHandler : HTMLBehaviorEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;  
    function    onTableHeaderClick( const aCssSelector : string; aUserEventHandler : HTMLBehaviorEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;  
    function    onTableRowClick( const aCssSelector : string; aUserEventHandler : HTMLBehaviorEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;  
    function    onTableRowDblClick( const aCssSelector : string; aUserEventHandler : HTMLBehaviorEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;  
    function    onElementCollapsed( const aCssSelector : string; aUserEventHandler : HTMLBehaviorEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
    function    onElementExpanded( const aCssSelector : string; aUserEventHandler : HTMLBehaviorEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;  
    function    onActivateChild( const aCssSelector : string; aUserEventHandler : HTMLBehaviorEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;  
    function    onDoSwitchTab( const aCssSelector : string; aUserEventHandler : HTMLBehaviorEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;  
    function    onInitDataView( const aCssSelector : string; aUserEventHandler : HTMLBehaviorEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;  
    function    onRowsDataRequest( const aCssSelector : string; aUserEventHandler : HTMLBehaviorEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;  
    function    onUiStateChanged( const aCssSelector : string; aUserEventHandler : HTMLBehaviorEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;  
    function    onFormSubmit( const aCssSelector : string; aUserEventHandler : HTMLBehaviorEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;  
    function    onFormReset( const aCssSelector : string; aUserEventHandler : HTMLBehaviorEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;  
    function    onDocumentComplete( const aCssSelector : string; aUserEventHandler : HTMLBehaviorEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;  
    function    onHistoryPush( const aCssSelector : string; aUserEventHandler : HTMLBehaviorEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;  
    function    onHistoryDrop( const aCssSelector : string; aUserEventHandler : HTMLBehaviorEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;  
    function    onHistoryPrior( const aCssSelector : string; aUserEventHandler : HTMLBehaviorEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;  
    function    onHistoryNext( const aCssSelector : string; aUserEventHandler : HTMLBehaviorEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;  
    function    onHistoryStateChanged( const aCssSelector : string; aUserEventHandler : HTMLBehaviorEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;  
    function    onClosePopup( const aCssSelector : string; aUserEventHandler : HTMLBehaviorEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;  
    function    onRequestTooltip( const aCssSelector : string; aUserEventHandler : HTMLBehaviorEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;  
    function    onAnimation( const aCssSelector : string; aUserEventHandler : HTMLBehaviorEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;  

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
    e := THTMLayoutEventHandler( aEventHandler );
    Result := ( HLDOM_OK = HTMLayoutAttachEventHandlerEx( aDomElement, e.FhandlerProxy, aEventHandler, e.Fsubscription ) );
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
end;

{-- THTMLayoutEvent -----------------------------------------------------------}

{*******************************************************************************
* Create
*******************************************************************************}
constructor THTMLayoutEvent.Create();
begin
    Fevents := TObjectList.Create( true );
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

    for i := 0 to Fevents.Count - 1 do
    begin
        Result := THTMLayoutEventHandler( Fevents[i] ).attach( aDomElement );
        if ( not Result ) then
            break;
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
function THTMLayoutEvent.onInitialization( const aCssSelector : string; aUserEventHandler : HTMLInitializationEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
begin
    Result := THTMLayoutEventHandler.Create( INITIALIZATION_ALL, HANDLE_INITIALIZATION, InitializationHandler, aCssSelector, TMethod( aUserEventHandler ), aUserData );
    Result.FallEvents := true;

    Fevents.add( Result );
end;

// onBehaviorDetach
function THTMLayoutEvent.onBehaviorDetach( const aCssSelector : string; aUserEventHandler : HTMLInitializationEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
begin
    Result := THTMLayoutEventHandler.Create( BEHAVIOR_DETACH , HANDLE_INITIALIZATION, InitializationHandler, aCssSelector, TMethod( aUserEventHandler ), aUserData );
    Fevents.add( Result );
end;
    
// onBehaviorAttach
function THTMLayoutEvent.onBehaviorAttach( const aCssSelector : string; aUserEventHandler : HTMLInitializationEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
begin
    Result := THTMLayoutEventHandler.Create( BEHAVIOR_ATTACH , HANDLE_INITIALIZATION, InitializationHandler, aCssSelector, TMethod( aUserEventHandler ), aUserData );
    Fevents.add( Result );
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
function THTMLayoutEvent.onMouse( const aCssSelector : string; aUserEventHandler : HTMLMouseEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
begin
    Result := THTMLayoutEventHandler.Create( MOUSE_ALL, HANDLE_MOUSE or DISABLE_INITIALIZATION, MouseHandler, aCssSelector, TMethod( aUserEventHandler ), aUserData );
    Result.FallEvents := true;

    Fevents.add( Result );
end;

// onMouseEnter
function THTMLayoutEvent.onMouseEnter( const aCssSelector : string; aUserEventHandler : HTMLMouseEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
begin
    Result := THTMLayoutEventHandler.Create( MOUSE_ENTER , HANDLE_MOUSE or DISABLE_INITIALIZATION, MouseHandler, aCssSelector, TMethod( aUserEventHandler ), aUserData );
    Fevents.add( Result );
end;
    
// onMouseLeave
function THTMLayoutEvent.onMouseLeave( const aCssSelector : string; aUserEventHandler : HTMLMouseEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
begin
    Result := THTMLayoutEventHandler.Create( MOUSE_LEAVE , HANDLE_MOUSE or DISABLE_INITIALIZATION, MouseHandler, aCssSelector, TMethod( aUserEventHandler ), aUserData );
    Fevents.add( Result );
end;
    
// onMouseMove
function THTMLayoutEvent.onMouseMove( const aCssSelector : string; aUserEventHandler : HTMLMouseEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
begin
    Result := THTMLayoutEventHandler.Create( MOUSE_MOVE , HANDLE_MOUSE or DISABLE_INITIALIZATION, MouseHandler, aCssSelector, TMethod( aUserEventHandler ), aUserData );
    Fevents.add( Result );
end;
    
// onMouseUp
function THTMLayoutEvent.onMouseUp( const aCssSelector : string; aUserEventHandler : HTMLMouseEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
begin
    Result := THTMLayoutEventHandler.Create( MOUSE_UP , HANDLE_MOUSE or DISABLE_INITIALIZATION, MouseHandler, aCssSelector, TMethod( aUserEventHandler ), aUserData );
    Fevents.add( Result );
end;
    
// onMouseDown
function THTMLayoutEvent.onMouseDown( const aCssSelector : string; aUserEventHandler : HTMLMouseEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
begin
    Result := THTMLayoutEventHandler.Create( MOUSE_DOWN , HANDLE_MOUSE or DISABLE_INITIALIZATION, MouseHandler, aCssSelector, TMethod( aUserEventHandler ), aUserData );
    Fevents.add( Result );
end;
    
// onMouseClick
function THTMLayoutEvent.onMouseClick( const aCssSelector : string; aUserEventHandler : HTMLMouseEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
begin
    Result := THTMLayoutEventHandler.Create( MOUSE_CLICK , HANDLE_MOUSE or DISABLE_INITIALIZATION, MouseHandler, aCssSelector, TMethod( aUserEventHandler ), aUserData );
    Fevents.add( Result );
end;
    
// onClick
function THTMLayoutEvent.onClick( const aCssSelector : string; aUserEventHandler : HTMLMouseEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
begin
    Result := THTMLayoutEventHandler.Create( MOUSE_CLICK , HANDLE_MOUSE or DISABLE_INITIALIZATION, MouseHandler, aCssSelector, TMethod( aUserEventHandler ), aUserData );
    Fevents.add( Result );
end;
    
// onMouseDClick
function THTMLayoutEvent.onMouseDClick( const aCssSelector : string; aUserEventHandler : HTMLMouseEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
begin
    Result := THTMLayoutEventHandler.Create( MOUSE_DCLICK , HANDLE_MOUSE or DISABLE_INITIALIZATION, MouseHandler, aCssSelector, TMethod( aUserEventHandler ), aUserData );
    Fevents.add( Result );
end;
    
// onDblClick
function THTMLayoutEvent.onDblClick( const aCssSelector : string; aUserEventHandler : HTMLMouseEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
begin
    Result := THTMLayoutEventHandler.Create( MOUSE_DCLICK , HANDLE_MOUSE or DISABLE_INITIALIZATION, MouseHandler, aCssSelector, TMethod( aUserEventHandler ), aUserData );
    Fevents.add( Result );
end;
    
// onMouseWheel
function THTMLayoutEvent.onMouseWheel( const aCssSelector : string; aUserEventHandler : HTMLMouseEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
begin
    Result := THTMLayoutEventHandler.Create( MOUSE_WHEEL , HANDLE_MOUSE or DISABLE_INITIALIZATION, MouseHandler, aCssSelector, TMethod( aUserEventHandler ), aUserData );
    Fevents.add( Result );
end;
    
// onWheel
function THTMLayoutEvent.onWheel( const aCssSelector : string; aUserEventHandler : HTMLMouseEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
begin
    Result := THTMLayoutEventHandler.Create( MOUSE_WHEEL , HANDLE_MOUSE or DISABLE_INITIALIZATION, MouseHandler, aCssSelector, TMethod( aUserEventHandler ), aUserData );
    Fevents.add( Result );
end;
    
// onMouseTick
function THTMLayoutEvent.onMouseTick( const aCssSelector : string; aUserEventHandler : HTMLMouseEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
begin
    Result := THTMLayoutEventHandler.Create( MOUSE_TICK , HANDLE_MOUSE or DISABLE_INITIALIZATION, MouseHandler, aCssSelector, TMethod( aUserEventHandler ), aUserData );
    Fevents.add( Result );
end;
    
// onMouseIdle
function THTMLayoutEvent.onMouseIdle( const aCssSelector : string; aUserEventHandler : HTMLMouseEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
begin
    Result := THTMLayoutEventHandler.Create( MOUSE_IDLE , HANDLE_MOUSE or DISABLE_INITIALIZATION, MouseHandler, aCssSelector, TMethod( aUserEventHandler ), aUserData );
    Fevents.add( Result );
end;
    
// onDrop
function THTMLayoutEvent.onDrop( const aCssSelector : string; aUserEventHandler : HTMLMouseEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
begin
    Result := THTMLayoutEventHandler.Create( DROP , HANDLE_MOUSE or DISABLE_INITIALIZATION, MouseHandler, aCssSelector, TMethod( aUserEventHandler ), aUserData );
    Fevents.add( Result );
end;
    
// onDragEnter
function THTMLayoutEvent.onDragEnter( const aCssSelector : string; aUserEventHandler : HTMLMouseEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
begin
    Result := THTMLayoutEventHandler.Create( DRAG_ENTER , HANDLE_MOUSE or DISABLE_INITIALIZATION, MouseHandler, aCssSelector, TMethod( aUserEventHandler ), aUserData );
    Fevents.add( Result );
end;
    
// onDragLeave
function THTMLayoutEvent.onDragLeave( const aCssSelector : string; aUserEventHandler : HTMLMouseEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
begin
    Result := THTMLayoutEventHandler.Create( DRAG_LEAVE , HANDLE_MOUSE or DISABLE_INITIALIZATION, MouseHandler, aCssSelector, TMethod( aUserEventHandler ), aUserData );
    Fevents.add( Result );
end;
    
// onDragRequest
function THTMLayoutEvent.onDragRequest( const aCssSelector : string; aUserEventHandler : HTMLMouseEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
begin
    Result := THTMLayoutEventHandler.Create( DRAG_REQUEST , HANDLE_MOUSE or DISABLE_INITIALIZATION, MouseHandler, aCssSelector, TMethod( aUserEventHandler ), aUserData );
    Fevents.add( Result );
end;
    
// onMouseDraggingEnter
function THTMLayoutEvent.onMouseDraggingEnter( const aCssSelector : string; aUserEventHandler : HTMLMouseEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
begin
    Result := THTMLayoutEventHandler.Create( MOUSE_ENTER or DRAGGING, HANDLE_MOUSE or DISABLE_INITIALIZATION, MouseHandler, aCssSelector, TMethod( aUserEventHandler ), aUserData );
    Fevents.add( Result );
end;
    
// onMouseDraggingLeave
function THTMLayoutEvent.onMouseDraggingLeave( const aCssSelector : string; aUserEventHandler : HTMLMouseEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
begin
    Result := THTMLayoutEventHandler.Create( MOUSE_LEAVE or DRAGGING, HANDLE_MOUSE or DISABLE_INITIALIZATION, MouseHandler, aCssSelector, TMethod( aUserEventHandler ), aUserData );
    Fevents.add( Result );
end;
    
// onMouseDraggingMove
function THTMLayoutEvent.onMouseDraggingMove( const aCssSelector : string; aUserEventHandler : HTMLMouseEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
begin
    Result := THTMLayoutEventHandler.Create( MOUSE_MOVE or DRAGGING, HANDLE_MOUSE or DISABLE_INITIALIZATION, MouseHandler, aCssSelector, TMethod( aUserEventHandler ), aUserData );
    Fevents.add( Result );
end;
    
// onMouseDraggingUp
function THTMLayoutEvent.onMouseDraggingUp( const aCssSelector : string; aUserEventHandler : HTMLMouseEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
begin
    Result := THTMLayoutEventHandler.Create( MOUSE_UP or DRAGGING, HANDLE_MOUSE or DISABLE_INITIALIZATION, MouseHandler, aCssSelector, TMethod( aUserEventHandler ), aUserData );
    Fevents.add( Result );
end;
    
// onMouseDraggingDown
function THTMLayoutEvent.onMouseDraggingDown( const aCssSelector : string; aUserEventHandler : HTMLMouseEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
begin
    Result := THTMLayoutEventHandler.Create( MOUSE_DOWN or DRAGGING, HANDLE_MOUSE or DISABLE_INITIALIZATION, MouseHandler, aCssSelector, TMethod( aUserEventHandler ), aUserData );
    Fevents.add( Result );
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
function THTMLayoutEvent.onKey( const aCssSelector : string; aUserEventHandler : HTMLKeyEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
begin
    Result := THTMLayoutEventHandler.Create( KEY_ALL, HANDLE_KEY or DISABLE_INITIALIZATION, KeyHandler, aCssSelector, TMethod( aUserEventHandler ), aUserData );
    Result.FallEvents := true;

    Fevents.add( Result );
end;

// onKeyDown
function THTMLayoutEvent.onKeyDown( const aCssSelector : string; aUserEventHandler : HTMLKeyEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
begin
    Result := THTMLayoutEventHandler.Create( KEY_DOWN , HANDLE_KEY or DISABLE_INITIALIZATION, KeyHandler, aCssSelector, TMethod( aUserEventHandler ), aUserData );
    Fevents.add( Result );
end;
    
// onKeyUp
function THTMLayoutEvent.onKeyUp( const aCssSelector : string; aUserEventHandler : HTMLKeyEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
begin
    Result := THTMLayoutEventHandler.Create( KEY_UP , HANDLE_KEY or DISABLE_INITIALIZATION, KeyHandler, aCssSelector, TMethod( aUserEventHandler ), aUserData );
    Fevents.add( Result );
end;
    
// onKeyChar
function THTMLayoutEvent.onKeyChar( const aCssSelector : string; aUserEventHandler : HTMLKeyEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
begin
    Result := THTMLayoutEventHandler.Create( KEY_CHAR , HANDLE_KEY or DISABLE_INITIALIZATION, KeyHandler, aCssSelector, TMethod( aUserEventHandler ), aUserData );
    Fevents.add( Result );
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
function THTMLayoutEvent.onFocus( const aCssSelector : string; aUserEventHandler : HTMLFocusEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
begin
    Result := THTMLayoutEventHandler.Create( FOCUS_ALL , HANDLE_FOCUS or DISABLE_INITIALIZATION, FocusHandler, aCssSelector, TMethod( aUserEventHandler ), aUserData );
    Result.FallEvents := true;

    Fevents.add( Result );
end;
    
// onFocusLost
function THTMLayoutEvent.onFocusLost( const aCssSelector : string; aUserEventHandler : HTMLFocusEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
begin
    Result := THTMLayoutEventHandler.Create( FOCUS_LOST , HANDLE_FOCUS or DISABLE_INITIALIZATION, FocusHandler, aCssSelector, TMethod( aUserEventHandler ), aUserData );
    Fevents.add( Result );
end;
    
// onFocusGot
function THTMLayoutEvent.onFocusGot( const aCssSelector : string; aUserEventHandler : HTMLFocusEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
begin
    Result := THTMLayoutEventHandler.Create( FOCUS_GOT , HANDLE_FOCUS or DISABLE_INITIALIZATION, FocusHandler, aCssSelector, TMethod( aUserEventHandler ), aUserData );
    Fevents.add( Result );
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
function THTMLayoutEvent.onScroll( const aCssSelector : string; aUserEventHandler : HTMLScrollEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
begin
    Result := THTMLayoutEventHandler.Create( SCROLL_ALL , HANDLE_SCROLL or DISABLE_INITIALIZATION, ScrollHandler, aCssSelector, TMethod( aUserEventHandler ), aUserData );
    Result.FallEvents := true;
    
    Fevents.add( Result );
end;
    
// onScrollHome
function THTMLayoutEvent.onScrollHome( const aCssSelector : string; aUserEventHandler : HTMLScrollEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
begin
    Result := THTMLayoutEventHandler.Create( SCROLL_HOME , HANDLE_SCROLL or DISABLE_INITIALIZATION, ScrollHandler, aCssSelector, TMethod( aUserEventHandler ), aUserData );
    Fevents.add( Result );
end;
    
// onScrollEnd
function THTMLayoutEvent.onScrollEnd( const aCssSelector : string; aUserEventHandler : HTMLScrollEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
begin
    Result := THTMLayoutEventHandler.Create( SCROLL_END , HANDLE_SCROLL or DISABLE_INITIALIZATION, ScrollHandler, aCssSelector, TMethod( aUserEventHandler ), aUserData );
    Fevents.add( Result );
end;
    
// onScrollStepPlus
function THTMLayoutEvent.onScrollStepPlus( const aCssSelector : string; aUserEventHandler : HTMLScrollEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
begin
    Result := THTMLayoutEventHandler.Create( SCROLL_STEP_PLUS , HANDLE_SCROLL or DISABLE_INITIALIZATION, ScrollHandler, aCssSelector, TMethod( aUserEventHandler ), aUserData );
    Fevents.add( Result );
end;
    
// onScrollStepMinus
function THTMLayoutEvent.onScrollStepMinus( const aCssSelector : string; aUserEventHandler : HTMLScrollEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
begin
    Result := THTMLayoutEventHandler.Create( SCROLL_STEP_MINUS , HANDLE_SCROLL or DISABLE_INITIALIZATION, ScrollHandler, aCssSelector, TMethod( aUserEventHandler ), aUserData );
    Fevents.add( Result );
end;
    
// onScrollPagePlus
function THTMLayoutEvent.onScrollPagePlus( const aCssSelector : string; aUserEventHandler : HTMLScrollEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
begin
    Result := THTMLayoutEventHandler.Create( SCROLL_PAGE_PLUS , HANDLE_SCROLL or DISABLE_INITIALIZATION, ScrollHandler, aCssSelector, TMethod( aUserEventHandler ), aUserData );
    Fevents.add( Result );
end;
    
// onScrollPageMinus
function THTMLayoutEvent.onScrollPageMinus( const aCssSelector : string; aUserEventHandler : HTMLScrollEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
begin
    Result := THTMLayoutEventHandler.Create( SCROLL_PAGE_MINUS , HANDLE_SCROLL or DISABLE_INITIALIZATION, ScrollHandler, aCssSelector, TMethod( aUserEventHandler ), aUserData );
    Fevents.add( Result );
end;
    
// onScrollPos
function THTMLayoutEvent.onScrollPos( const aCssSelector : string; aUserEventHandler : HTMLScrollEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
begin
    Result := THTMLayoutEventHandler.Create( SCROLL_POS , HANDLE_SCROLL or DISABLE_INITIALIZATION, ScrollHandler, aCssSelector, TMethod( aUserEventHandler ), aUserData );
    Fevents.add( Result );
end;
    
// onScrollSliderReleased
function THTMLayoutEvent.onScrollSliderReleased( const aCssSelector : string; aUserEventHandler : HTMLScrollEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
begin
    Result := THTMLayoutEventHandler.Create( SCROLL_SLIDER_RELEASED , HANDLE_SCROLL or DISABLE_INITIALIZATION, ScrollHandler, aCssSelector, TMethod( aUserEventHandler ), aUserData );
    Fevents.add( Result );
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
function THTMLayoutEvent.onTimer( const aCssSelector : string; aUserEventHandler : HTMLTimerEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
begin
    Result := THTMLayoutEventHandler.Create( ALL_CMD, HANDLE_TIMER or DISABLE_INITIALIZATION, TimerHandler, aCssSelector, TMethod( aUserEventHandler ), aUserData );
    Fevents.add( Result );
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
function THTMLayoutEvent.onSize( const aCssSelector : string; aUserEventHandler : HTMLSizeEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
begin
    Result := THTMLayoutEventHandler.Create( ALL_CMD, HANDLE_SIZE or DISABLE_INITIALIZATION, SizeHandler, aCssSelector, TMethod( aUserEventHandler ), aUserData );
    Fevents.add( Result );
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
function THTMLayoutEvent.onDataArrived( const aCssSelector : string; aUserEventHandler : HTMLDataArrivedEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
begin
    Result := THTMLayoutEventHandler.Create( ALL_CMD, HANDLE_DATA_ARRIVED or DISABLE_INITIALIZATION, DataArrivedHandler, aCssSelector, TMethod( aUserEventHandler ), aUserData );
    Fevents.add( Result );
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
function THTMLayoutEvent.onDraw( const aCssSelector : string; aUserEventHandler : HTMLDrawEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
begin
    Result := THTMLayoutEventHandler.Create( DRAW_ALL, HANDLE_DRAW or DISABLE_INITIALIZATION, DrawHandler, aCssSelector, TMethod( aUserEventHandler ), aUserData );
    Result.FallEvents := true;

    Fevents.add( Result );
end;
    
// onDrawBackground
function THTMLayoutEvent.onDrawBackground( const aCssSelector : string; aUserEventHandler : HTMLDrawEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
begin
    Result := THTMLayoutEventHandler.Create( DRAW_BACKGROUND, HANDLE_DRAW or DISABLE_INITIALIZATION, DrawHandler, aCssSelector, TMethod( aUserEventHandler ), aUserData );
    Fevents.add( Result );
end;
    
// onDrawContent
function THTMLayoutEvent.onDrawContent( const aCssSelector : string; aUserEventHandler : HTMLDrawEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
begin
    Result := THTMLayoutEventHandler.Create( DRAW_CONTENT, HANDLE_DRAW or DISABLE_INITIALIZATION, DrawHandler, aCssSelector, TMethod( aUserEventHandler ), aUserData );
    Fevents.add( Result );
end;
    
// onDrawForeground
function THTMLayoutEvent.onDrawForeground( const aCssSelector : string; aUserEventHandler : HTMLDrawEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
begin
    Result := THTMLayoutEventHandler.Create( DRAW_FOREGROUND, HANDLE_DRAW or DISABLE_INITIALIZATION, DrawHandler, aCssSelector, TMethod( aUserEventHandler ), aUserData );
    Fevents.add( Result );
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
function THTMLayoutEvent.onExchange( const aCssSelector : string; aUserEventHandler : HTMLExchangeEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
begin
    Result := THTMLayoutEventHandler.Create( EXC_ALL , HANDLE_EXCHANGE or DISABLE_INITIALIZATION, ExchangeHandler, aCssSelector, TMethod( aUserEventHandler ), aUserData );
    Result.FallEvents := true;

    Fevents.add( Result );
end;
    
// onExchangeNone
function THTMLayoutEvent.onExchangeNone( const aCssSelector : string; aUserEventHandler : HTMLExchangeEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
begin
    Result := THTMLayoutEventHandler.Create( EXC_NONE , HANDLE_EXCHANGE or DISABLE_INITIALIZATION, ExchangeHandler, aCssSelector, TMethod( aUserEventHandler ), aUserData );
    Fevents.add( Result );
end;
    
// onExchangeCopy
function THTMLayoutEvent.onExchangeCopy( const aCssSelector : string; aUserEventHandler : HTMLExchangeEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
begin
    Result := THTMLayoutEventHandler.Create( EXC_COPY , HANDLE_EXCHANGE or DISABLE_INITIALIZATION, ExchangeHandler, aCssSelector, TMethod( aUserEventHandler ), aUserData );
    Fevents.add( Result );
end;
    
// onExchangeMove
function THTMLayoutEvent.onExchangeMove( const aCssSelector : string; aUserEventHandler : HTMLExchangeEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
begin
    Result := THTMLayoutEventHandler.Create( EXC_MOVE , HANDLE_EXCHANGE or DISABLE_INITIALIZATION, ExchangeHandler, aCssSelector, TMethod( aUserEventHandler ), aUserData );
    Fevents.add( Result );
end;
    
// onExchangeLink
function THTMLayoutEvent.onExchangeLink( const aCssSelector : string; aUserEventHandler : HTMLExchangeEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
begin
    Result := THTMLayoutEventHandler.Create( EXC_LINK , HANDLE_EXCHANGE or DISABLE_INITIALIZATION, ExchangeHandler, aCssSelector, TMethod( aUserEventHandler ), aUserData );
    Fevents.add( Result );
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
function THTMLayoutEvent.onGesture( const aCssSelector : string; aUserEventHandler : HTMLGestureEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
begin
    Result := THTMLayoutEventHandler.Create( GESTURE_ALL , HANDLE_GESTURE or DISABLE_INITIALIZATION, GestureHandler, aCssSelector, TMethod( aUserEventHandler ), aUserData );
    Result.FallEvents := true;
    
    Fevents.add( Result );
end;
    
// onGestureRequest
function THTMLayoutEvent.onGestureRequest( const aCssSelector : string; aUserEventHandler : HTMLGestureEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
begin
    Result := THTMLayoutEventHandler.Create( GESTURE_REQUEST , HANDLE_GESTURE or DISABLE_INITIALIZATION, GestureHandler, aCssSelector, TMethod( aUserEventHandler ), aUserData );
    Fevents.add( Result );
end;
    
// onGestureZoom
function THTMLayoutEvent.onGestureZoom( const aCssSelector : string; aUserEventHandler : HTMLGestureEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
begin
    Result := THTMLayoutEventHandler.Create( GESTURE_ZOOM , HANDLE_GESTURE or DISABLE_INITIALIZATION, GestureHandler, aCssSelector, TMethod( aUserEventHandler ), aUserData );
    Fevents.add( Result );
end;
    
// onGesturePan
function THTMLayoutEvent.onGesturePan( const aCssSelector : string; aUserEventHandler : HTMLGestureEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
begin
    Result := THTMLayoutEventHandler.Create( GESTURE_PAN , HANDLE_GESTURE or DISABLE_INITIALIZATION, GestureHandler, aCssSelector, TMethod( aUserEventHandler ), aUserData );
    Fevents.add( Result );
end;
    
// onGestureRotate
function THTMLayoutEvent.onGestureRotate( const aCssSelector : string; aUserEventHandler : HTMLGestureEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
begin
    Result := THTMLayoutEventHandler.Create( GESTURE_ROTATE , HANDLE_GESTURE or DISABLE_INITIALIZATION, GestureHandler, aCssSelector, TMethod( aUserEventHandler ), aUserData );
    Fevents.add( Result );
end;
    
// onGestureTap1
function THTMLayoutEvent.onGestureTap1( const aCssSelector : string; aUserEventHandler : HTMLGestureEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
begin
    Result := THTMLayoutEventHandler.Create( GESTURE_TAP1 , HANDLE_GESTURE or DISABLE_INITIALIZATION, GestureHandler, aCssSelector, TMethod( aUserEventHandler ), aUserData );
    Fevents.add( Result );
end;
    
// onGestureTap2
function THTMLayoutEvent.onGestureTap2( const aCssSelector : string; aUserEventHandler : HTMLGestureEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
begin
    Result := THTMLayoutEventHandler.Create( GESTURE_TAP2 , HANDLE_GESTURE or DISABLE_INITIALIZATION, GestureHandler, aCssSelector, TMethod( aUserEventHandler ), aUserData );
    Fevents.add( Result );
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
function THTMLayoutEvent.onButtonClick( const aCssSelector : string; aUserEventHandler : HTMLBehaviorEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
begin
    Result := THTMLayoutEventHandler.Create( BUTTON_CLICK , HANDLE_BEHAVIOR_EVENT or DISABLE_INITIALIZATION, BehaviorEventHandler, aCssSelector, TMethod( aUserEventHandler ), aUserData );
    Fevents.add( Result );
end;
    
// onButtonPress
function THTMLayoutEvent.onButtonPress( const aCssSelector : string; aUserEventHandler : HTMLBehaviorEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
begin
    Result := THTMLayoutEventHandler.Create( BUTTON_PRESS , HANDLE_BEHAVIOR_EVENT or DISABLE_INITIALIZATION, BehaviorEventHandler, aCssSelector, TMethod( aUserEventHandler ), aUserData );
    Fevents.add( Result );
end;
    
// onButtonStateChanged
function THTMLayoutEvent.onButtonStateChanged( const aCssSelector : string; aUserEventHandler : HTMLBehaviorEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
begin
    Result := THTMLayoutEventHandler.Create( BUTTON_STATE_CHANGED , HANDLE_BEHAVIOR_EVENT or DISABLE_INITIALIZATION, BehaviorEventHandler, aCssSelector, TMethod( aUserEventHandler ), aUserData );
    Fevents.add( Result );
end;
    
// onEditValueChanging
function THTMLayoutEvent.onEditValueChanging( const aCssSelector : string; aUserEventHandler : HTMLBehaviorEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
begin
    Result := THTMLayoutEventHandler.Create( EDIT_VALUE_CHANGING , HANDLE_BEHAVIOR_EVENT or DISABLE_INITIALIZATION, BehaviorEventHandler, aCssSelector, TMethod( aUserEventHandler ), aUserData );
    Fevents.add( Result );
end;
    
// onEditValueChanged
function THTMLayoutEvent.onEditValueChanged( const aCssSelector : string; aUserEventHandler : HTMLBehaviorEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
begin
    Result := THTMLayoutEventHandler.Create( EDIT_VALUE_CHANGED , HANDLE_BEHAVIOR_EVENT or DISABLE_INITIALIZATION, BehaviorEventHandler, aCssSelector, TMethod( aUserEventHandler ), aUserData );
    Fevents.add( Result );
end;
    
// onSelectSelectionChanged
function THTMLayoutEvent.onSelectSelectionChanged( const aCssSelector : string; aUserEventHandler : HTMLBehaviorEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
begin
    Result := THTMLayoutEventHandler.Create( SELECT_SELECTION_CHANGED , HANDLE_BEHAVIOR_EVENT or DISABLE_INITIALIZATION, BehaviorEventHandler, aCssSelector, TMethod( aUserEventHandler ), aUserData );
    Fevents.add( Result );
end;
    
// onSelectStateChanged
function THTMLayoutEvent.onSelectStateChanged( const aCssSelector : string; aUserEventHandler : HTMLBehaviorEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
begin
    Result := THTMLayoutEventHandler.Create( SELECT_STATE_CHANGED , HANDLE_BEHAVIOR_EVENT or DISABLE_INITIALIZATION, BehaviorEventHandler, aCssSelector, TMethod( aUserEventHandler ), aUserData );
    Fevents.add( Result );
end;
    
// onPopupRequest
function THTMLayoutEvent.onPopupRequest( const aCssSelector : string; aUserEventHandler : HTMLBehaviorEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
begin
    Result := THTMLayoutEventHandler.Create( POPUP_REQUEST , HANDLE_BEHAVIOR_EVENT or DISABLE_INITIALIZATION, BehaviorEventHandler, aCssSelector, TMethod( aUserEventHandler ), aUserData );
    Fevents.add( Result );
end;
    
// onPopupReady
function THTMLayoutEvent.onPopupReady( const aCssSelector : string; aUserEventHandler : HTMLBehaviorEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
begin
    Result := THTMLayoutEventHandler.Create( POPUP_READY , HANDLE_BEHAVIOR_EVENT or DISABLE_INITIALIZATION, BehaviorEventHandler, aCssSelector, TMethod( aUserEventHandler ), aUserData );
    Fevents.add( Result );
end;
    
// onPopupDismissed
function THTMLayoutEvent.onPopupDismissed( const aCssSelector : string; aUserEventHandler : HTMLBehaviorEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
begin
    Result := THTMLayoutEventHandler.Create( POPUP_DISMISSED , HANDLE_BEHAVIOR_EVENT or DISABLE_INITIALIZATION, BehaviorEventHandler, aCssSelector, TMethod( aUserEventHandler ), aUserData );
    Fevents.add( Result );
end;
    
// onMenuItemActive
function THTMLayoutEvent.onMenuItemActive( const aCssSelector : string; aUserEventHandler : HTMLBehaviorEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
begin
    Result := THTMLayoutEventHandler.Create( MENU_ITEM_ACTIVE , HANDLE_BEHAVIOR_EVENT or DISABLE_INITIALIZATION, BehaviorEventHandler, aCssSelector, TMethod( aUserEventHandler ), aUserData );
    Fevents.add( Result );
end;
    
// onMenuItemClick
function THTMLayoutEvent.onMenuItemClick( const aCssSelector : string; aUserEventHandler : HTMLBehaviorEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
begin
    Result := THTMLayoutEventHandler.Create( MENU_ITEM_CLICK , HANDLE_BEHAVIOR_EVENT or DISABLE_INITIALIZATION, BehaviorEventHandler, aCssSelector, TMethod( aUserEventHandler ), aUserData );
    Fevents.add( Result );
end;
    
// onContextMenuSetup
function THTMLayoutEvent.onContextMenuSetup( const aCssSelector : string; aUserEventHandler : HTMLBehaviorEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
begin
    Result := THTMLayoutEventHandler.Create( CONTEXT_MENU_SETUP , HANDLE_BEHAVIOR_EVENT or DISABLE_INITIALIZATION, BehaviorEventHandler, aCssSelector, TMethod( aUserEventHandler ), aUserData );
    Fevents.add( Result );
end;
    
// onContextMenuRequest
function THTMLayoutEvent.onContextMenuRequest( const aCssSelector : string; aUserEventHandler : HTMLBehaviorEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
begin
    Result := THTMLayoutEventHandler.Create( CONTEXT_MENU_REQUEST , HANDLE_BEHAVIOR_EVENT or DISABLE_INITIALIZATION, BehaviorEventHandler, aCssSelector, TMethod( aUserEventHandler ), aUserData );
    Fevents.add( Result );
end;
    
// onVisiualStatusChanged
function THTMLayoutEvent.onVisiualStatusChanged( const aCssSelector : string; aUserEventHandler : HTMLBehaviorEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
begin
    Result := THTMLayoutEventHandler.Create( VISIUAL_STATUS_CHANGED , HANDLE_BEHAVIOR_EVENT or DISABLE_INITIALIZATION, BehaviorEventHandler, aCssSelector, TMethod( aUserEventHandler ), aUserData );
    Fevents.add( Result );
end;
    
// onDisabledStatusChanged
function THTMLayoutEvent.onDisabledStatusChanged( const aCssSelector : string; aUserEventHandler : HTMLBehaviorEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
begin
    Result := THTMLayoutEventHandler.Create( DISABLED_STATUS_CHANGED , HANDLE_BEHAVIOR_EVENT or DISABLE_INITIALIZATION, BehaviorEventHandler, aCssSelector, TMethod( aUserEventHandler ), aUserData );
    Fevents.add( Result );
end;
    
// onPopupDismissing
function THTMLayoutEvent.onPopupDismissing( const aCssSelector : string; aUserEventHandler : HTMLBehaviorEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
begin
    Result := THTMLayoutEventHandler.Create( POPUP_DISMISSING , HANDLE_BEHAVIOR_EVENT or DISABLE_INITIALIZATION, BehaviorEventHandler, aCssSelector, TMethod( aUserEventHandler ), aUserData );
    Fevents.add( Result );
end;
    // "grey" event codes  - notfications from behaviors from this SDK
    
// onHyperLinkClick
function THTMLayoutEvent.onHyperLinkClick( const aCssSelector : string; aUserEventHandler : HTMLBehaviorEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
begin
    Result := THTMLayoutEventHandler.Create( HYPERLINK_CLICK , HANDLE_BEHAVIOR_EVENT or DISABLE_INITIALIZATION, BehaviorEventHandler, aCssSelector, TMethod( aUserEventHandler ), aUserData );
    Fevents.add( Result );
end;
    
// onTableHeaderClick
function THTMLayoutEvent.onTableHeaderClick( const aCssSelector : string; aUserEventHandler : HTMLBehaviorEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
begin
    Result := THTMLayoutEventHandler.Create( TABLE_HEADER_CLICK , HANDLE_BEHAVIOR_EVENT or DISABLE_INITIALIZATION, BehaviorEventHandler, aCssSelector, TMethod( aUserEventHandler ), aUserData );
    Fevents.add( Result );
end;
    
// onTableRowClick
function THTMLayoutEvent.onTableRowClick( const aCssSelector : string; aUserEventHandler : HTMLBehaviorEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
begin
    Result := THTMLayoutEventHandler.Create( TABLE_ROW_CLICK , HANDLE_BEHAVIOR_EVENT or DISABLE_INITIALIZATION, BehaviorEventHandler, aCssSelector, TMethod( aUserEventHandler ), aUserData );
    Fevents.add( Result );
end;
    
// onTableRowDblClick
function THTMLayoutEvent.onTableRowDblClick( const aCssSelector : string; aUserEventHandler : HTMLBehaviorEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
begin
    Result := THTMLayoutEventHandler.Create( TABLE_ROW_DBL_CLICK , HANDLE_BEHAVIOR_EVENT or DISABLE_INITIALIZATION, BehaviorEventHandler, aCssSelector, TMethod( aUserEventHandler ), aUserData );
    Fevents.add( Result );
end;
    
// onElementCollapsed
function THTMLayoutEvent.onElementCollapsed( const aCssSelector : string; aUserEventHandler : HTMLBehaviorEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
begin
    Result := THTMLayoutEventHandler.Create( ELEMENT_COLLAPSED , HANDLE_BEHAVIOR_EVENT or DISABLE_INITIALIZATION, BehaviorEventHandler, aCssSelector, TMethod( aUserEventHandler ), aUserData );
    Fevents.add( Result );
end;
    
// onElementExpanded
function THTMLayoutEvent.onElementExpanded( const aCssSelector : string; aUserEventHandler : HTMLBehaviorEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
begin
    Result := THTMLayoutEventHandler.Create( ELEMENT_EXPANDED , HANDLE_BEHAVIOR_EVENT or DISABLE_INITIALIZATION, BehaviorEventHandler, aCssSelector, TMethod( aUserEventHandler ), aUserData );
    Fevents.add( Result );
end;
    
// onActivateChild
function THTMLayoutEvent.onActivateChild( const aCssSelector : string; aUserEventHandler : HTMLBehaviorEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
begin
    Result := THTMLayoutEventHandler.Create( ACTIVATE_CHILD , HANDLE_BEHAVIOR_EVENT or DISABLE_INITIALIZATION, BehaviorEventHandler, aCssSelector, TMethod( aUserEventHandler ), aUserData );
    Fevents.add( Result );
end;
    
// onDoSwitchTab
function THTMLayoutEvent.onDoSwitchTab( const aCssSelector : string; aUserEventHandler : HTMLBehaviorEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
begin
    Result := THTMLayoutEventHandler.Create( DO_SWITCH_TAB , HANDLE_BEHAVIOR_EVENT or DISABLE_INITIALIZATION, BehaviorEventHandler, aCssSelector, TMethod( aUserEventHandler ), aUserData );
    Fevents.add( Result );
end;
    
// onInitDataView
function THTMLayoutEvent.onInitDataView( const aCssSelector : string; aUserEventHandler : HTMLBehaviorEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
begin
    Result := THTMLayoutEventHandler.Create( INIT_DATA_VIEW , HANDLE_BEHAVIOR_EVENT or DISABLE_INITIALIZATION, BehaviorEventHandler, aCssSelector, TMethod( aUserEventHandler ), aUserData );
    Fevents.add( Result );
end;
    
// onRowsDataRequest
function THTMLayoutEvent.onRowsDataRequest( const aCssSelector : string; aUserEventHandler : HTMLBehaviorEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
begin
    Result := THTMLayoutEventHandler.Create( ROWS_DATA_REQUEST , HANDLE_BEHAVIOR_EVENT or DISABLE_INITIALIZATION, BehaviorEventHandler, aCssSelector, TMethod( aUserEventHandler ), aUserData );
    Fevents.add( Result );
end;
    
// onUiStateChanged
function THTMLayoutEvent.onUiStateChanged( const aCssSelector : string; aUserEventHandler : HTMLBehaviorEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
begin
    Result := THTMLayoutEventHandler.Create( UI_STATE_CHANGED , HANDLE_BEHAVIOR_EVENT or DISABLE_INITIALIZATION, BehaviorEventHandler, aCssSelector, TMethod( aUserEventHandler ), aUserData );
    Fevents.add( Result );
end;
    
// onFormSubmit
function THTMLayoutEvent.onFormSubmit( const aCssSelector : string; aUserEventHandler : HTMLBehaviorEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
begin
    Result := THTMLayoutEventHandler.Create( FORM_SUBMIT , HANDLE_BEHAVIOR_EVENT or DISABLE_INITIALIZATION, BehaviorEventHandler, aCssSelector, TMethod( aUserEventHandler ), aUserData );
    Fevents.add( Result );
end;
    
// onFormReset
function THTMLayoutEvent.onFormReset( const aCssSelector : string; aUserEventHandler : HTMLBehaviorEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
begin
    Result := THTMLayoutEventHandler.Create( FORM_RESET , HANDLE_BEHAVIOR_EVENT or DISABLE_INITIALIZATION, BehaviorEventHandler, aCssSelector, TMethod( aUserEventHandler ), aUserData );
    Fevents.add( Result );
end;
    
// onDocumentComplete
function THTMLayoutEvent.onDocumentComplete( const aCssSelector : string; aUserEventHandler : HTMLBehaviorEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
begin
    Result := THTMLayoutEventHandler.Create( DOCUMENT_COMPLETE , HANDLE_BEHAVIOR_EVENT or DISABLE_INITIALIZATION, BehaviorEventHandler, aCssSelector, TMethod( aUserEventHandler ), aUserData );
    Fevents.add( Result );
end;
    
// onHistoryPush
function THTMLayoutEvent.onHistoryPush( const aCssSelector : string; aUserEventHandler : HTMLBehaviorEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
begin
    Result := THTMLayoutEventHandler.Create( HISTORY_PUSH , HANDLE_BEHAVIOR_EVENT or DISABLE_INITIALIZATION, BehaviorEventHandler, aCssSelector, TMethod( aUserEventHandler ), aUserData );
    Fevents.add( Result );
end;
    
// onHistoryDrop
function THTMLayoutEvent.onHistoryDrop( const aCssSelector : string; aUserEventHandler : HTMLBehaviorEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
begin
    Result := THTMLayoutEventHandler.Create( HISTORY_DROP , HANDLE_BEHAVIOR_EVENT or DISABLE_INITIALIZATION, BehaviorEventHandler, aCssSelector, TMethod( aUserEventHandler ), aUserData );
    Fevents.add( Result );
end;
    
// onHistoryPrior
function THTMLayoutEvent.onHistoryPrior( const aCssSelector : string; aUserEventHandler : HTMLBehaviorEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
begin
    Result := THTMLayoutEventHandler.Create( HISTORY_PRIOR , HANDLE_BEHAVIOR_EVENT or DISABLE_INITIALIZATION, BehaviorEventHandler, aCssSelector, TMethod( aUserEventHandler ), aUserData );
    Fevents.add( Result );
end;
    
// onHistoryNext
function THTMLayoutEvent.onHistoryNext( const aCssSelector : string; aUserEventHandler : HTMLBehaviorEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
begin
    Result := THTMLayoutEventHandler.Create( HISTORY_NEXT , HANDLE_BEHAVIOR_EVENT or DISABLE_INITIALIZATION, BehaviorEventHandler, aCssSelector, TMethod( aUserEventHandler ), aUserData );
    Fevents.add( Result );
end;
    
// onHistoryStateChanged
function THTMLayoutEvent.onHistoryStateChanged( const aCssSelector : string; aUserEventHandler : HTMLBehaviorEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
begin
    Result := THTMLayoutEventHandler.Create( HISTORY_STATE_CHANGED , HANDLE_BEHAVIOR_EVENT or DISABLE_INITIALIZATION, BehaviorEventHandler, aCssSelector, TMethod( aUserEventHandler ), aUserData );
    Fevents.add( Result );
end;
    
// onClosePopup
function THTMLayoutEvent.onClosePopup( const aCssSelector : string; aUserEventHandler : HTMLBehaviorEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
begin
    Result := THTMLayoutEventHandler.Create( CLOSE_POPUP , HANDLE_BEHAVIOR_EVENT or DISABLE_INITIALIZATION, BehaviorEventHandler, aCssSelector, TMethod( aUserEventHandler ), aUserData );
    Fevents.add( Result );
end;
    
// onRequestTooltip
function THTMLayoutEvent.onRequestTooltip( const aCssSelector : string; aUserEventHandler : HTMLBehaviorEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
begin
    Result := THTMLayoutEventHandler.Create( REQUEST_TOOLTIP , HANDLE_BEHAVIOR_EVENT or DISABLE_INITIALIZATION, BehaviorEventHandler, aCssSelector, TMethod( aUserEventHandler ), aUserData );
    Fevents.add( Result );
end;
    
// onAnimation
function THTMLayoutEvent.onAnimation( const aCssSelector : string; aUserEventHandler : HTMLBehaviorEventHandler; aUserData : Pointer = nil ) : THTMLayoutEventHandler;
begin
    Result := THTMLayoutEventHandler.Create( ANIMATION , HANDLE_BEHAVIOR_EVENT or DISABLE_INITIALIZATION, BehaviorEventHandler, aCssSelector, TMethod( aUserEventHandler ), aUserData );
    Fevents.add( Result );
end;

INITIALIZATION
    PhaseMask := UINT( not ( UINT( SINKING ) or UINT( HANDLED ) ) );
end.
