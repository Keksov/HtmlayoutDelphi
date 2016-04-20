unit HtmlLayoutH;

(*
  HTMLayout License terms could be found here http://www.terrainformatica.com/htmlayout/prices.whtm
  SDK - http://www.terrainformatica.com/htmlayout/HTMLayoutSDK.zip

  Delphi binding of HTMLayout published under LGPL. Visit https://github.com/Keksov/HtmlayoutDelphi

  This file contains function and types declarations translated from include\htmlayout_dom.h of
  Most accurate documentation could be found in include\htmlayout.h itself
*)

// htmlayout.h

interface

{$IFDEF USER_DEFINES_INC}{$I user_defines.inc}{$ENDIF}

uses Windows
    , HtmlTypes
    , HtmlBehaviorH
    , HtmlValueH
;

const
{**This notification is sent on parsing the document and while handling
 * &lt;INPUT&gt;, &lt;TEXTAREA&gt;, &lt;SELECT&gt; and &lt;WIDGET&gt; tags.
 *
 * param lParam #LPNMHL_CREATE_CONTROL.
 * return HWND of the control or #HWND_TRY_DEFAULT or #HWND_DISCARD_CREATION.
 *
 * This notification is sent when HtmLayout is about to create a child control.
 * The application can override the creation of "standard HTML controls" or
 * implement the creation of other application specific controls. To do this assign
 * HWND of newly created control to #NMHL_CREATE_CONTROL::outControlHwnd member of
 * #NMHL_CREATE_CONTROL.
 **}
    HLN_CREATE_CONTROL = $AFF + $01;

{**Notifies that HtmLayout is about to download a referred resource.
 *
 * param lParam #LPNMHL_LOAD_DATA.
 * return #LOAD_OK or #LOAD_DISCARD
 *
 * This notification gives application a chance to override built-in loader and
 * implement loading of resources in its own way (for example images may be loaded from
 * database or other resource). To do this set #NMHL_LOAD_DATA::outData and
 * #NMHL_LOAD_DATA::outDataSize members of NMHL_LOAD_DATA. HTMLayout does not
 * store pointer to this data. You can call #HTMLayoutDataReady() function instead
 * of filling these fields. This allows you to free your outData buffer
 * immediately.
**}
    HLN_LOAD_DATA = $AFF + $02;

{**This notification is sent when control creation process has completed.
 *
 * param lParam #LPNMHL_CREATE_CONTROL.
 *
 * While processing this notification application can modify control settings
 * or store information about the created control.
 * For example it can use SetWindowLong() function, to set control's id:
 * code
 * SetWindowLong(((LPNMHL_CREATECONTROL)lParam)->outControlHwnd, GWL_ID, controlId)
 * endcode
 **}
    HLN_CONTROL_CREATED = $AFF + $03;

{**This notification indicates that external data (for example image) download process
 * completed.
 *
 * param lParam #LPNMHL_DATA_LOADED
 *
 * This notifiaction is sent for each external resource used by document when
 * this resource has been completely downloaded. HTMLayout will send this
 * notification asynchronously.
 **}
    HLN_DATA_LOADED = $AFF + $04;

{**This notification is sent when all external data (for example image) has been downloaded.
 *
 * This notification is sent when all external resources required by document
 * have been completely downloaded. HTMLayout will send this notification
 * asynchronously.
 **}
    HLN_DOCUMENT_COMPLETE = $AFF + $05;

{**This notification instructs host application to update its UI.
 *
 * This notification is sent on changes in HTMLayout formatting registers.
 * If application indicates their state on toolbars or using other controls it
 * should update them.
 **}
    HLN_UPDATE_UI = $AFF + $06;


{**This notification is sent when HTMLayout destroys its controls.
 *
 * param lParam #LPNMHL_DESTROY_CONTROL
 * Before loading new document HTMLayout destroys all controls belonging to
 * previous document. Host application can reject deletion of the control by
 * setting NMHL_DESTROY_CONTROL::inoutControlHwnd to zero.
 *
 * Handling of this notification makes sence when you need for example reload
 * HTML without destroying set of controls on HTML form.
 * But you still need to handle NMHL_CREATE_CONTROL notification to bind
 * existing controls with their HTML "places"
 *
 * attention HTMLayouts sends this notifiation only while loading new or
 * empty document.
 **}
    HLN_DESTROY_CONTROL = $AFF + $07;

{**This notification is sent on parsing the document and while processing
 * elements having non empty style.behavior attribute value.
 *
 * param lParam #LPNMHL_ATTACH_BEHAVIOR
 *
 * Application has to provide implementation of #htmlayout::behavior interface.
 * Set #NMHL_ATTACH_BEHAVIOR::impl to address of this implementation.
 **}
    HLN_ATTACH_BEHAVIOR = $AFF + $08;

{**This notification is sent after DOM element has changed its behavior(s)
 *
 * param lParam #LPNMHL_BEHAVIOR_CHANGED
 *
 **}
    HLN_BEHAVIOR_CHANGED = $AFF + $09;

{**This notification is sent when dialog window created but document is not loaded
 *
 *
 * param lParam is a pointer to statndard NMHDR
 *
 * ATTN: Will be sent ONLY by HTMLayoutDialog API function.
 **}
    HLN_DIALOG_CREATED = $AFF + $10;

{**This notification is sent when dialog window is about to be closed
 * - happens while handling WM_CLOSE in dialog
 *
 * param lParam #LPNMHL_DIALOG_CLOSE_RQ
 *
 * ATTN: Will be sent ONLY by HTMLayoutDialog API function.
 **}
    HLN_DIALOG_CLOSE_RQ = $AFF + $0A;

{**This notification is sent when document is loaded and parsed in full.
 *
 * This notification is sent before HLN_DOCUMENT_COMPLETE
 *
 **}
    HLN_DOCUMENT_LOADED = $AFF + $0B;

{**Create "default HTML control", used by #HLN_CREATE_CONTROL notification as
 * value for #NMHL_CREATE_CONTROL::outControlHwnd.
 **}
    HWND_TRY_DEFAULT = HWND(0);

{**Do not create any controls, used by #HLN_CREATE_CONTROL notification as
 * value for #NMHL_CREATE_CONTROL::outControlHwnd.
 **}
    HWND_DISCARD_CREATION = HWND(1);

{**Use default loader or outData/outDataSize if they are set,
 * used as a return value for #HLN_CREATE_CONTROL notification.
 **}
    LOAD_OK = 0;

{**Do not load resource at all,
 * Used as a return value for #HLN_CREATE_CONTROL notification.
 **}
    LOAD_DISCARD = 1;

// pass this value in wParam of WM_CREATE or WM_INITDIALOG to disable builtin IDropSource/IDropTatget (Drag-n-drop)
    WPARAM_DISCARD_BUILTIN_DD_SUPP0RT = $8000;

type
    // typedef LRESULT CALLBACK HTMLAYOUT_NOTIFY(UINT uMsg, WPARAM wParam, LPARAM lParam, LPVOID vParam);
    HTMLayoutNotify = function( uMsg : UINT; wParam : WPARAM; lParam : LPARAM; vParam : Pointer ) : LRESULT stdcall;
    
    (* Element callback function for all types of events. Similar to WndProc
     * param tag LPVOID, tag assigned by HTMLayoutAttachElementProc function (like GWL_USERDATA)
     * param he HELEMENT, this element handle (like HWND)
     * param evtg UINT, group identifier of the event, value is one of EVENT_GROUPS
     * param prms LPVOID, pointer to group specific parameters structure.
     * return TRUE if event was handled, FALSE otherwise.
    *)
    HTMLayoutElementEventProc = function( tag : Pointer; he : HELEMENT; evtg: UINT; prms : Pointer ) : BOOL stdcall;

    (* Callback function used with HTMLayoutEnumResources().
     *
     * param[in] resourceUri LPCWSTR, uri used to download resource.
     * param[in] resourceType LPCSTR, type of the resources.
     * param[in] imageData LPCBYTE, address of resource data.
     * param[in] imageDataSize DWORD, resource data size.
     * return BOOL, TRUE - continue enumeration, FALSE - stop
     *
     * This function recieves information on all resources loaded with the currend document.
    *)
    HTMLAYOUT_CALLBACK_RES = function( resourceUri : LPCWSTR; resourceType : LPCSTR; imageData : LPCBYTE; imageDataSize : DWORD ) : BOOL stdcall;
    HTMLAYOUT_CALLBACK_RES_EX = function( resourceUri : LPCWSTR; resourceType : LPCSTR; imageData : LPCBYTE; imageDataSize : DWORD; prm : Pointer ) : BOOL stdcall;

    HTMLAYOUT_DATA_WRITER = procedure( uri : LPCWSTR; dataType : UINT {HTMLayoutResourceType}; data : LPCBYTE; dataLength : UINT ); stdcall;
    HTMLAYOUT_DATA_LOADER = function( uri : LPCWSTR; dataType : UINT {HTMLayoutResourceType}; pDataWriter : HTMLAYOUT_DATA_WRITER ) : BOOL stdcall;
    HTMLAYOUT_DEBUG_OUTPUT_PROC = procedure( param : Pointer; character : integer ); stdcall;

    (* This structure is used by #HLN_CREATE_CONTROL and #HLN_CONTROL_CREATED
     * notifications.
     *
     * - #HLN_CREATE_CONTROL
     * copydoc HLN_CREATE_CONTROL
     *
     * - #HLN_CONTROL_CREATED
     *   \copydoc HLN_CONTROL_CREATED
     *
    *)
    NMHL_CREATE_CONTROL = record
        hdr                     : NMHDR; // Default WM_NOTIFY header
        helement                : HELEMENT; // [in] DOM element.
        inHwndParent            : HWND; // [in] HWND of the HTMLayout window.
        outControlHwnd          : HWND; // [out] HWND of control created or #HWND_TRY_DEFAULT or HWND_DISCARD_CREATION.
        reserved1               : DWORD;
        reserved2               : DWORD;
    end;
    PNMHL_CREATE_CONTROL = ^NMHL_CREATE_CONTROL;

    // This structure is used by #HLN_DESTROY_CONTROL notification.
    NMHL_DESTROY_CONTROL = record
        hdr                     : NMHDR; // Default WM_NOTIFY header
        helement                : HELEMENT; // [in] DOM element.
        inoutControlHwnd        : HWND; // HWND of child to be destroyed.
        reserved1               : DWORD;
    end;
    PNMHL_DESTROY_CONTROL = ^NMHL_DESTROY_CONTROL;

    // This structure is used by #HLN_LOAD_DATA notification. HLN_LOAD_DATA
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
    LPNMHL_LOAD_DATA = PNMHL_LOAD_DATA;

    // This structure is used by #HLN_DATA_LOADED notification. HLN_DATA_LOADED
    NMHL_DATA_LOADED = record
        hdr                     : NMHDR; // Default WM_NOTIFY header
        uri                     : LPCWSTR; // [in] zero terminated string, fully qualified uri, for example "http://server/folder/file.ext".
        data                    : LPCBYTE; // [in] pointer to loaded data.
        dataSize                : DWORD; // [in] loaded data size (in bytes). dataSize == 0 - incompatible data type, e.g. requested image but HTML returned
        dataType                : UINT; // [in] HTMLayoutResourceType
        status                  : UINT; { [in]
                                         status = 0 (dataSize == 0) - unknown error.
                                         status = 100..505 - http response status, Note: 200 - OK!
                                         status > 12000 - wininet error code, see ERROR_INTERNET_*** in wininet.h }
    end;
    PNMHL_DATA_LOADED = ^NMHL_DATA_LOADED;
    LPNMHL_DATA_LOADED = PNMHL_DATA_LOADED;

    // This structure is used by #HLN_ATTACH_BEHAVIOR notification. HLN_ATTACH_BEHAVIOR
    NMHL_ATTACH_BEHAVIOR = record
        hdr                     : NMHDR; // Default WM_NOTIFY header
        helement                : HELEMENT; // [in] DOM element.
        behaviorName            : LPCSTR; // [in] zero terminated string, string appears as value of CSS behavior:"???" attribute.

        elementProc             : HTMLayoutElementEventProc; // [out] pointer to ElementEventProc function.
        elementTag              : Pointer; // [out] tag value, passed as is into pointer ElementEventProc function.
        elementEvents           : UINT; // [out] EVENT_GROUPS bit flags, event groups elementProc subscribed to.
    end;
    PNMHL_ATTACH_BEHAVIOR = ^NMHL_ATTACH_BEHAVIOR;
    LPNMHL_ATTACH_BEHAVIOR = PNMHL_ATTACH_BEHAVIOR;

    // This structure is used by #HLN_BEHAVIOR_CHANGED notification. HLN_BEHAVIOR_CHANGED
    NMHL_BEHAVIOR_CHANGED = record
        hdr                     : NMHDR; // Default WM_NOTIFY header.
        helement                : HELEMENT; // [in] DOM element.
        oldNames                : LPCSTR; // [in] zero terminated string, whitespace separated list of old behaviors.
        newNames                : LPCSTR; // [in] zero terminated string, whitespace separated list of new behaviors that the element just got.
    end;
    PNMHL_BEHAVIOR_CHANGED = ^NMHL_BEHAVIOR_CHANGED;

    // This structure is used by #HLN_DIALOG_CLOSE_RQ notification.
    NMHL_DIALOG_CLOSE_RQ = record
        hdr                     : NMHDR; // Default WM_NOTIFY header.
        outCancel               : BOOL; // [out] set it to non-zero for canceling close request.
    end;
    PNMHL_DIALOG_CLOSE_RQ = ^NMHL_DIALOG_CLOSE_RQ;

    HTMLayoutResourceType = (
        HLRT_DATA_HTML          = 0,
        HLRT_DATA_IMAGE         = 1,
        HLRT_DATA_STYLE         = 2,
        HLRT_DATA_CURSOR        = 3,
        HLRT_DATA_SCRIPT        = 4
    );

    HTMLayoutModes = (
        HLM_LAYOUT_ONLY         = 0, // layout manager and renderer.
        HLM_SHOW_SELECTION      = 1  // layout manager and renderer + text selection and WM_COPY.
    );

    //enum ELEMENT_MODEL
    HTMLayoutElementModel = (
        DATA_ELEMENT            = 0, // data element, invisible by default - display:none.
        INLINE_TEXT_ELEMENT     = 1, // inline text, can contain text, example: <em>. Will get style display:inline.
        INLINE_BLOCK_ELEMENT    = 2, // inline element, contains blocks inside, example: <select>. Will get style display:inline-block.
        BLOCK_TEXT_ELEMENT      = 3, // block of text, can contain text, example: <p>. Will get styles display:block; width:*.
        BLOCK_BLOCK_ELEMENT     = 4  // block of blocks, contains blocks inside, example: <div>. Will get style display:block.; width:*.
    );

    //enum HTMLAYOUT_OPTIONS
    HTMLayoutOptions = (
        HTMLAYOUT_SMOOTH_SCROLL         = 1, // value:TRUE - enable, value:FALSE - disable, enabled by default
        HTMLAYOUT_CONNECTION_TIMEOUT    = 2, // value: milliseconds, connection timeout of http client
        HTMLAYOUT_HTTPS_ERROR           = 3, // value: 0 - drop connection, 1 - use builtin dialog, 2 - accept connection silently
        HTMLAYOUT_FONT_SMOOTHING        = 4, // value: 0 - system default, 1 - no smoothing, 2 - std smoothing, 3 - clear type
        HTMLAYOUT_ANIMATION_THREAD      = 5, // value: 0 - multimedia timer thread, 1 - GUI thread (timing is not so accurate).
        HTMLAYOUT_TRANSPARENT_WINDOW    = 6  // Windows Aero support, value:
                                             //  0 - normal drawing,
                                             //  1 - window has transparent background after calls DwmExtendFrameIntoClientArea() or DwmEnableBlurBehindWindow().
    );


(* Get name of HTMLayout window class.
 *
 * return LPCSTR, name of HTMLayout window class.
 *
 * Use this function if you wish to create ansi version of HTMLayout.
 * The returned name can be used in CreateWindow(Ex)A function.
 * You can use #HTMLayoutClassNameT macro.
*)
function  HTMLayoutClassNameA() : LPCSTR; stdcall;

(* Get name of HTMLayout window class.
 *
 * return LPCWSTR, name of HTMLayout window class.
 *
 * Use this function if you wish to create unicode version of HTMLayout.
 * The returned name can be used in CreateWindow(Ex)W function. 
 * You can use #HTMLayoutClassNameT macro.
*)
function  HTMLayoutClassNameW() : LPCWSTR; stdcall;

(* This function is used in response to HLN_LOAD_DATA request.
 *
 * param[in] hwnd HWND, HTMLayout window handle.
 * param[in] uri LPCWSTR, URI of the data requested by HTMLayout.
 * param[in] data LPBYTE, pointer to data buffer.
 * param[in] dataLength DWORD, length of the data in bytes.
 * return BOOL, TRUE if HTMLayout accepts the data or FALSE if error occured 
 * (for example this function was called outside of #HLN_LOAD_DATA request).
 *
 * warning If used, call of this function MUST be done ONLY while handling 
 * HLN_LOAD_DATA request and in the same thread. For asynchronous resource loading
 * use HTMLayoutDataReadyAsync
*)
function  HTMLayoutDataReady( hwnd : HWND; uri : LPCWSTR; data : PBYTE; length: DWORD): BOOL; stdcall;

(* Use this function outside of HLN_LOAD_DATA request. This function is needed when
 * you have your own http client implemented in your application.
 *
 * param[in] hwnd HWND, HTMLayout window handle.
 * param[in] uri LPCWSTR, URI of the data requested by HTMLayout.
 * param[in] data LPBYTE, pointer to data buffer.
 * param[in] dataLength DWORD, length of the data in bytes.
 * param[in] dataType UINT, type of resource to load. See HTMLayoutResourceType.
 * return BOOL, TRUE if HTMLayout accepts the data or FALSE if error occured 
*)
function  HTMLayoutDataReadyAsync( hwnd : HWND; uri : LPCWSTR; data : PBYTE; dataLength : DWORD; dataType : UINT {HTMLayoutResourceType} ) : BOOL; stdcall;

// HTMLayout Window Proc.
function  HTMLayoutProc( hwnd : HWND; msg : UINT; wParam : WPARAM; lParam : LPARAM ): LRESULT; stdcall;

// HTMLayout Unicode Window Proc.
function  HTMLayoutProcW( hwnd : HWND; msg : UINT; wParam : WPARAM; lParam : LPARAM ): LRESULT; stdcall;

// HTMLayout Window Proc without call of DefWindowProc.
function  HTMLayoutProcND( hwnd : HWND; msg: UINT; wParam : WPARAM; lParam : LPARAM; var pbHandled : BOOL ): LRESULT; stdcall;

(* Returns minimal width of the document.
 *
 * param[in] hWndHTMLayout HWND, HTMLayout window handle.
 * return UINT, Minimal width needed to render the document without scrollbar.
*)
function  HTMLayoutGetMinWidth( hwnd : HWND ) : UINT; stdcall;

(* Returns minimal height of the document.
 *
 * param[in] hWndHTMLayout HWND, HTMLayout window handle.
 * param[in] width UINT, desired width of the document.
 * return UINT, Minimal height needed to render the document without scrollbar.
*)
function  HTMLayoutGetMinHeight( hwnd : HWND; width : UINT ) : UINT; stdcall;

(* Load HTML file.
 *
 * param[in] hWndHTMLayout HWND, HTMLayout window handle. 
 * param[in] filename LPCWSTR, File name of an HTML file.
 * return BOOL, TRUE if the text was parsed and loaded successfully, FALSE otherwise.
*)
function  HTMLayoutLoadFile( hwnd : HWND; filename : LPCWSTR) : BOOL; stdcall;

(* Load HTML from in memory buffer.
 *
 * param[in] hWndHTMLayout HWND, HTMLayout window handle.
 * param[in] html LPCBYTE, Address of HTML to load.
 * param[in] htmlSize UINT, Length of the array pointed by html parameter.
 * return BOOL, TRUE if the text was parsed and loaded successfully, FALSE otherwise.
*)
function  HTMLayoutLoadHtml( hwnd : HWND; html : LPCBYTE; htmlSize: UINT): BOOL; stdcall;

(* Load HTML from in memory buffer with base.
 *
 * param[in] hWndHTMLayout HWND, HTMLayout window handle.
 * param[in] html LPCBYTE, Address of HTML to load.
 * param[in] htmlSize UINT, Length of the array pointed by html parameter.
 * param[in] baseUrl LPCWSTR, base URL. All relative links will be resolved against this URL.
 * return BOOL, TRUE if the text was parsed and loaded successfully, FALSE otherwise.
*)
function  HTMLayoutLoadHtmlEx( hwnd : HWND; html : LPCBYTE; htmlSize : UINT; baseUrl : LPCWSTR) : BOOL; stdcall;

(* Sets the HTMLayout link #HTMLayoutModes operational mode \endlink.
 *
 * param[in] hWndHTMLayout HWND, HTMLayout window handle.
 * param[in] HTMLayoutMode int, desired link #HTMLayoutModes operational mode \endlink.
*)
procedure HTMLayoutSetMode( hwnd : HWND; HTMLayoutMode : integer {HTMLayoutModes} ); stdcall;

(* Set link #HTMLAYOUT_NOTIFY() notification callback function \endlink.
 *
 * param[in] hWndHTMLayout HWND, HTMLayout window handle.
 * param[in] cb HTMLAYOUT_NOTIFY*, link #HTMLAYOUT_NOTIFY() callback function \endlink.
 * param[in] cbParam LPVOID, parameter that will be passed to link #HTMLAYOUT_NOTIFY() callback function \endlink as vParam paramter.
*)
procedure HTMLayoutSetCallback( hwnd : HWND; cb : HTMLayoutNotify; cbParam : Pointer ); stdcall;

(* Query whether user have selected some HTML text.
 *
 * param[in] hWndHTMLayout HWND, HTMLayout window handle.
*)
function  HTMLayoutSelectionExist( hwnd : HWND ) : BOOL; stdcall;

(* Get selected HTML
 *
 * param[in] hWndHTMLayout HWND, HTMLayout window handle.
 * param[out] pSize LPUINT*, variable to recieve size of the returned buffer.
 * return LPCBYTE, pointer to buffer containing selected HTML. It is HTMLayout's responsibility to free this buffer.
*)
function  HTMLayoutGetSelectedHTML( hwnd : HWND; var pSize : UINT ) : LPCBYTE; stdcall;

(* Copies selection to clipboard.
 *
 * param[in] hWndHTMLayout HWND, HTMLayout window handle.
 * return BOOL, TRUE if selected HTML text has been copied to clipboard, FALSE otherwise.
*)
function  HTMLayoutClipboardCopy( hwnd : HWND ) : BOOL; stdcall;

(* Enumerates resources loaded with current document.
 *
 * param[in] hWndHTMLayout HWND, HTMLayout window handle.
 * param[in] cb #HTMLAYOUT_CALLBACK_RES*, callback function.
*)
function  HTMLayoutEnumResources( hwnd : HWND; cb : HTMLAYOUT_CALLBACK_RES ) : UINT; stdcall;

(* Enumerates resources loaded with current document.
 *
 * param[in] hWndHTMLayout HWND, HTMLayout window handle.
 * param[in] cb    #HTMLAYOUT_CALLBACK_RES_EX*, callback function.
 * param[in] cbPrm LPVOID, value of 'prm' parameter of the callback function, passed to #HTMLAYOUT_CALLBACK_RES_EX "as is"
*)
function  HTMLayoutEnumResourcesEx( hwnd : HWND; cb : HTMLAYOUT_CALLBACK_RES_EX; cbPrm : Pointer ) : UINT; stdcall;

(* Set Master style sheet.
  This function will replace intrinsic style sheet by new content.
  See: http://www.terrainformatica.com/wiki/h-smile:built-in-behaviors:master_style_sheet
  Or resource section of the library for "master-css" HTML resource.
 *
 * param[in] utf8 LPCBYTE, start of CSS buffer.
 * param[in] numBytes UINT, number of bytes in utf8.
 *
 * If used, this function has to be invoked before any other HTMLayout function but after 
 *    HTMLayoutDeclareElement (if it is used)
*)
function  HTMLayoutSetMasterCSS( utf8 : LPCBYTE; numBytes : UINT ) : BOOL; stdcall;

(* Append Master style sheet.
  This function appends intrinsic style sheet by custom styles.
  See: http://www.terrainformatica.com/wiki/h-smile:built-in-behaviors:master_style_sheet
 *
 * param[in] utf8 LPCBYTE, start of CSS buffer.
 * param[in] numBytes UINT, number of bytes in utf8.
*)
function  HTMLayoutAppendMasterCSS( utf8 : LPCBYTE; numBytes : UINT ) : BOOL; stdcall;

(* HTMLayoutSetDataLoader.
 * This function registeres "primordial" data loader that can be used for loading custom resources defined in custom
 * master style sheets.
 *
 * param[in] pDataLoader HTMLAYOUT_DATA_LOADER*, address of application defined custom loader.
 *
 * dataType here is HTMLayoutResourceType.
*)
function  HTMLayoutSetDataLoader( pDataLoader : HTMLAYOUT_DATA_LOADER ) : BOOL; stdcall;

(* HTMLayoutDeclareElementType Declares new type of HTML element.
 *
 * param[in] name LPCSTR, name of the tag.
 * param[in] elementModel ELEMENT_MODEL, element model.
 * return BOOL, TRUE if element was deckared successfully, FALSE if element with such a name already exists.
 *
 * ATTN: call this function before any other HTMLayout function, even before HTMLayoutSetMasterCSS
*)
function  HTMLayoutDeclareElementType( name : LPCSTR; elementModel : UINT {ELEMENT_MODEL} ) : BOOL; stdcall;

(* Set (reset) style sheet of current document. Will reset styles for all elements according to given CSS (utf8)
 *
 * param[in] hWndHTMLayout HWND, HTMLayout window handle.
 * param[in] utf8 LPCBYTE, start of CSS buffer.
 * param[in] numBytes UINT, number of bytes in utf8.
*)
function  HTMLayoutSetCSS( hwnd : HWND; utf8 : LPCBYTE; numBytes : UINT; baseUrl : LPCWSTR; mediaType : LPCWSTR ) : BOOL; stdcall;

(* Set media type of this htmlayout instance.
 *
 * param[in] hWndHTMLayout HWND, HTMLayout window handle.
 * param[in] mediaType LPCWSTR, media type name.
 *
 * For example media type can be "handheld", "projection", "screen", "screen-hires", etc.
 * By default htmlayout window has "screen" media type.
 * 
 * Media type name is used while loading and parsing style sheets in the engine so
 * you should call this function *before* loading document in it.
*)
function  HTMLayoutSetMediaType( hwnd : HWND; mediaType : LPCWSTR ) : BOOL; stdcall;

(* Set media variables of this htmlayout instance.
 *
 * param[in] hWndSciter HWND, HTMLauout window handle.
 * param[in] mediaVars VALUE, map that contains name/value pairs - media variables to be set.
 *
 * For example media type can be "handheld:true", "projection:true", "screen:true", etc.
 * By default sciter window has "screen:true" and "desktop:true"/"handheld:true" media variables.
 *
 * Media variables can be changed in runtime. This will cause styles of the document to be reset.
*)
function  HTMLayoutSetMediaVars( hwnd : HWND; const mediaVars : PRHtmlValue ) : BOOL; stdcall;

(* Set additional http headers that will be sent with each http request by this instance of the engine.
 *
 * param[in] hWndHTMLayout HWND, HTMLayout window handle.
 * param[in] httpHeaders LPCSTR, headers.
 * return BOOL, TRUE if headers were set successfully, FALSE otherwise - e.g. if hWndHTMLayout is not valid htmlayout window.
 *
 * Example of header, you may wish to provide: 
 * code
 *   Accept-Language: en
 * endcode
 *     
 * Multiple headers must be separated by CRLF pairs. 
*)
function  HTMLayoutSetHttpHeaders( hwnd : HWND; httpHeaders : LPCSTR; httpHeadersLength : UINT ) : BOOL; stdcall;

(* Set various options.
 *
 * param[in] hWndHTMLayout HWND, HTMLayout window handle or NULL if the setting means to be global.
 * param[in] option UINT, id of the option, one of HTMLAYOUT_OPTIONS
 * param[in] option UINT, value of the option.
*)
function  HTMLayoutSetOption( hwnd : HWND; option : UINT {HTMLAYOUT_OPTIONS}; value : UINT ) : BOOL; stdcall;

(*Render document to 24bpp or 32bpp bitmap (with alpha).
 *
 * param[in] hWndHTMLayout HWND, HTMLayout window handle.
 * param[in] hBmp hBmp, handle of DIB where to render HTML. DIB expected to be 24bpp or 32bpp
 * param[in] area RECT, area on the bitmap to update.
 * return BOOL, TRUE if hBmp is 24bpp or 32bpp, FALSE otherwise.
 *
 * In case of 32bpp destination BMP will have color with premultiplied alpha.
*)
function  HTMLayoutRender( hwnd : HWND; hBmp : HBITMAP; area : TRECT ) : BOOL; stdcall;

(* Update HTMLayout window 
 *
 * Function applies all pending updates and calls ::UpdateWindow().
 *
 * This function is intended to be used in cases when htmlayout is not able
 * to process messages from input queue. 
*)
function  HTMLayoutUpdateWindow( hwnd : HWND ) : BOOL; stdcall;

(* Update HTMLayout window 
 *
 * Function applies all pending updates without calling UpdateWindow().
 *
 * After call of this function it is safe to call HTMLayoutGetElementLocation()
 * as at this moment all elements will get their position calculated.
 *
 * This function is intended to be used in cases when htmlayout is not able
 * to process messages from input queue. 
*)
function  HTMLayoutCommitUpdates( hwnd : HWND ) : BOOL; stdcall;

(* HTMLayoutUrlEscape
 *
 * Takes wide string and produces URL encoded ascii string. Wide chars out of ASCII range are getting UTF-8 
 * encoded and resulting bytes emited as %XX sequences.
 *
 * param[in] text LPCWSTR, input text [of the URL].
 * param[in] spaceToPlus BOOL, if TRUE all ' ' are replaced by '+'
 * param[out] buffer LPSTR, address of the buffer where to put result.
 * param[in] bufferLength UINT, size of the buffer.
 * return UINT, number of characters written to the buffer (without trailing zero).
 *
 * buffer is NULL this function returns needed number of characters that the buffer should contain (without trailing zero).
*)
function  HTMLayoutUrlEscape( text : LPCWSTR; spaceToPlus : BOOL; buffer : LPSTR; bufferLength : UINT ) : UINT; stdcall;

(* HTMLayoutUrlUnescape
 *
 * Takes URL encoded ascii string and restores unescaped wide string from it.
 *
 * param[in] url LPCSTR, input text [escaped URL].
 * param[out] buffer LPWSTR, address of the buffer where to put result.
 * param[in] bufferLength UINT, size of the buffer.
 * return UINT, number of characters written to the buffer (without trailing zero).
 *
 * buffer is NULL this function returns needed number of characters that the buffer should contain (without trailing zero).
*)
function  HTMLayoutUrlUnescape( url : LPCSTR; buffer : LPWSTR; bufferLength : UINT ) : UINT; stdcall;

(* Show HTML based dialog
 *
 * param[in] hWndParent HWND, parent window, can be NULL.
 * param[in] position POINT, anchor point.
 * param[in] alignment UINT, alignment of the window, defines corner of 
 *            the dialog window 'position' points to:
 *            Values: 0 - center of the dialog in the center of the screen
 *                    1-9 - see NUMPAD digits for what 'position' defines.  
 *                   -1..-9 correspondent corner of the dilaog will be placed to the correspondent corner of window rectangle
 *                          of hWndParent.
 *                          Example: -9 dialog will be aligned to top/right corner of the parent window. 
 * param[in] style UINT, style of the dialog window. WS_***. 
 * param[in] styleEx UINT, extended style of the dialog window, WS_EX_***. 
 * param[in] notificationCallback LPHTMLAYOUT_NOTIFY, notifaction callback function, see HTMLayoutSetCallback.
 * param[in] eventsCallback LPELEMENT_EVENT_PROC, event callback function, see HTMLayoutAttachEventHandler.
 * param[in] callbackParam LPVOID, notifaction callback function, see HTMLayoutSetCallback.
 * param[in] html either file name or pointer to buffer containing HTML
 * param[in] htmlLength UINT, number of bytes in 'html'.
    If it is zero then 'html' points to LPCWSTR string - URL of the document to load.
    If it is not zero than it shall contain number of bytes in 'html' buffer.
*)
function  HTMLayoutDialog( hwnd : HWND; position : TPoint; alignment : integer; style : UINT; styleEx : UINT; ncb : HTMLayoutNotify; ecb : HTMLayoutElementEventProc; callbackParam : Pointer; html : LPCBYTE; htmlLength : UINT ) : INT_PTR; stdcall;

(* HTMLayoutSetupDebugOutput - setup debug output function.
 *
 *  This output function will be used for reprting problems 
 *  found while loading html and css documents.
*)
procedure HTMLayoutSetupDebugOutput( param : Pointer; pfOutput : HTMLAYOUT_DEBUG_OUTPUT_PROC ); stdcall;

implementation

uses HtmlDll;

function  HTMLayoutClassNameA() : LPCSTR; external HTMLayoutDLL; stdcall;
function  HTMLayoutClassNameW() : LPCWSTR; external HTMLayoutDLL; stdcall;
function  HTMLayoutDataReady( hwnd : HWND; uri : LPCWSTR; data : PBYTE; length : DWORD) : BOOL; external HTMLayoutDLL; stdcall;
function  HTMLayoutDataReadyAsync( hwnd : HWND; uri : LPCWSTR; data : PBYTE; dataLength : DWORD; dataType : UINT ) : BOOL; external HTMLayoutDLL; stdcall;
function  HTMLayoutProc( hwnd : HWND; msg : UINT; wParam : WPARAM; lParam : LPARAM ): LRESULT; external HTMLayoutDLL; stdcall;
function  HTMLayoutProcW( hwnd : HWND; msg : UINT; wParam : WPARAM; lParam : LPARAM ): LRESULT; external HTMLayoutDLL; stdcall;
function  HTMLayoutProcND(  hwnd : HWND; msg : UINT; wParam : WPARAM; lParam : LPARAM; var pbHandled : BOOL ): LRESULT; external HTMLayoutDLL; stdcall;
function  HTMLayoutGetMinWidth( hwnd : HWND ) : UINT; external HTMLayoutDLL; stdcall;
function  HTMLayoutGetMinHeight( hwnd : HWND; width : UINT ) : UINT; external HTMLayoutDLL; stdcall;
function  HTMLayoutLoadFile( hwnd : HWND; filename : LPCWSTR): BOOL;  external HTMLayoutDLL; stdcall;
function  HTMLayoutLoadHtml( hwnd : HWND; html : LPCBYTE; htmlSize : UINT): BOOL; external HTMLayoutDLL; stdcall;
function  HTMLayoutLoadHtmlEx( hwnd : HWND; html : LPCBYTE; htmlSize : UINT; baseUrl : LPCWSTR ) : BOOL; external HTMLayoutDLL; stdcall;
procedure HTMLayoutSetMode( hwnd : HWND; HTMLayoutMode : integer {HTMLayoutModes} ); external HTMLayoutDLL; stdcall;
procedure HTMLayoutSetCallback( hwnd : HWND; cb : HTMLayoutNotify; cbParam : Pointer ); external HTMLayoutDLL; stdcall;
function  HTMLayoutSelectionExist( hwnd : HWND ) : BOOL; external HTMLayoutDLL; stdcall;
function  HTMLayoutGetSelectedHTML( hwnd : HWND; var pSize : UINT ) : LPCBYTE; external HTMLayoutDLL; stdcall;
function  HTMLayoutClipboardCopy( hwnd : HWND ) : BOOL; external HTMLayoutDLL; stdcall;
function  HTMLayoutEnumResources( hwnd : HWND; cb : HTMLAYOUT_CALLBACK_RES ) : UINT; external HTMLayoutDLL; stdcall;
function  HTMLayoutEnumResourcesEx( hwnd : HWND; cb : HTMLAYOUT_CALLBACK_RES_EX; cbPrm : Pointer ) : UINT; external HTMLayoutDLL; stdcall;
function  HTMLayoutSetMasterCSS( utf8 : LPCBYTE; numBytes : UINT) : BOOL; external HTMLayoutDLL; stdcall;
function  HTMLayoutAppendMasterCSS( utf8 : LPCBYTE; numBytes : UINT ) : BOOL; external HTMLayoutDLL; stdcall;
function  HTMLayoutSetDataLoader( pDataLoader : HTMLAYOUT_DATA_LOADER ) : BOOL; external HTMLayoutDLL; stdcall;
function  HTMLayoutDeclareElementType( name : LPCSTR; elementModel : UINT {ELEMENT_MODEL} ) : BOOL; external HTMLayoutDLL; stdcall;
function  HTMLayoutSetCSS( hwnd : HWND; utf8 : LPCBYTE; numBytes : UINT; baseUrl : LPCWSTR; mediaType : LPCWSTR ) : BOOL; external HTMLayoutDLL; stdcall;
function  HTMLayoutSetMediaType( hwnd : HWND; mediaType : LPCWSTR ) : BOOL; external HTMLayoutDLL; stdcall;
function  HTMLayoutSetMediaVars(  hwnd : HWND; const mediaVars : PRHtmlValue ) : BOOL; external HTMLayoutDLL; stdcall;
function  HTMLayoutSetHttpHeaders( hwnd : HWND; httpHeaders : LPCSTR; httpHeadersLength : UINT ) : BOOL; external HTMLayoutDLL; stdcall;
function  HTMLayoutSetOption( hwnd : HWND; option : UINT {HTMLAYOUT_OPTIONS}; value : UINT ) : BOOL; external HTMLayoutDLL; stdcall;
function  HTMLayoutRender( hwnd : HWND; hBmp : HBITMAP; area : TRECT ) : BOOL; external HTMLayoutDLL; stdcall;
function  HTMLayoutUpdateWindow( hwnd : HWND ) : BOOL; external HTMLayoutDLL; stdcall;
function  HTMLayoutCommitUpdates( hwnd : HWND ) : BOOL; external HTMLayoutDLL; stdcall;
function  HTMLayoutUrlEscape( text : LPCWSTR; spaceToPlus : BOOL; buffer : LPSTR; bufferLength : UINT ) : UINT; external HTMLayoutDLL; stdcall;
function  HTMLayoutUrlUnescape( url : LPCSTR; buffer : LPWSTR; bufferLength : UINT ) : UINT; external HTMLayoutDLL; stdcall;
function  HTMLayoutDialog( hwnd : HWND; position : TPoint; alignment : integer; style : UINT; styleEx : UINT; ncb : HTMLayoutNotify; ecb : HTMLayoutElementEventProc; callbackParam : Pointer; html : LPCBYTE; htmlLength : UINT ) : INT_PTR; external HTMLayoutDLL; stdcall;
procedure HTMLayoutSetupDebugOutput( param : Pointer; pfOutput : HTMLAYOUT_DEBUG_OUTPUT_PROC ); external HTMLayoutDLL; stdcall;

end.

