unit HtmlLayoutH;

(*
  HTMLayout License terms could be found here http://www.terrainformatica.com/htmlayout/prices.whtm
  SDK - http://www.terrainformatica.com/htmlayout/HTMLayoutSDK.zip

  Delphi binding of HTMLayout published under LGPL. Visit https://github.com/Keksov/HtmlayoutDelphi

  This file contains function and types declarations translated from include\htmlayout_dom.h of
  Most accurate documentation could be found in include\htmlayout.h itself
*)

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
 * \param lParam #LPNMHL_CREATE_CONTROL.
 * \return HWND of the control or #HWND_TRY_DEFAULT or #HWND_DISCARD_CREATION.
 *
 * This notification is sent when HtmLayout is about to create a child control.
 * The application can override the creation of "standard HTML controls" or
 * implement the creation of other application specific controls. To do this assign
 * HWND of newly created control to #NMHL_CREATE_CONTROL::outControlHwnd member of
 * #NMHL_CREATE_CONTROL.
 **}
    HLN_CREATE_CONTROL          = $AFF + $01;

{**Notifies that HtmLayout is about to download a referred resource.
 *
 * \param lParam #LPNMHL_LOAD_DATA.
 * \return #LOAD_OK or #LOAD_DISCARD
 *
 * This notification gives application a chance to override built-in loader and
 * implement loading of resources in its own way (for example images may be loaded from
 * database or other resource). To do this set #NMHL_LOAD_DATA::outData and
 * #NMHL_LOAD_DATA::outDataSize members of NMHL_LOAD_DATA. HTMLayout does not
 * store pointer to this data. You can call #HTMLayoutDataReady() function instead
 * of filling these fields. This allows you to free your outData buffer
 * immediately.
**}
    HLN_LOAD_DATA               = $AFF + $02;

{**This notification is sent when control creation process has completed.
 *
 * \param lParam #LPNMHL_CREATE_CONTROL.
 *
 * While processing this notification application can modify control settings
 * or store information about the created control.
 * For example it can use SetWindowLong() function, to set control's id:
 * \code
 * SetWindowLong(((LPNMHL_CREATECONTROL)lParam)->outControlHwnd, GWL_ID, controlId)
 * \endcode
 **}
    HLN_CONTROL_CREATED         = $AFF + $03;

{**This notification indicates that external data (for example image) download process
 * completed.
 *
 * \param lParam #LPNMHL_DATA_LOADED
 *
 * This notifiaction is sent for each external resource used by document when
 * this resource has been completely downloaded. HTMLayout will send this
 * notification asynchronously.
 **}
    HLN_DATA_LOADED             = $AFF + $04;

{**This notification is sent when all external data (for example image) has been downloaded.
 *
 * This notification is sent when all external resources required by document
 * have been completely downloaded. HTMLayout will send this notification
 * asynchronously.
 **}
    HLN_DOCUMENT_COMPLETE       = $AFF + $05;

{**This notification instructs host application to update its UI.
 *
 * This notification is sent on changes in HTMLayout formatting registers.
 * If application indicates their state on toolbars or using other controls it
 * should update them.
 **}
    HLN_UPDATE_UI               = $AFF + $06;


{**This notification is sent when HTMLayout destroys its controls.
 *
 * \param lParam #LPNMHL_DESTROY_CONTROL
 * Before loading new document HTMLayout destroys all controls belonging to
 * previous document. Host application can reject deletion of the control by
 * setting NMHL_DESTROY_CONTROL::inoutControlHwnd to zero.
 *
 * Handling of this notification makes sence when you need for example reload
 * HTML without destroying set of controls on HTML form.
 * But you still need to handle NMHL_CREATE_CONTROL notification to bind
 * existing controls with their HTML "places"
 *
 * \attention HTMLayouts sends this notifiation only while loading new or
 * empty document.
 **}
    HLN_DESTROY_CONTROL         = $AFF + $07;

{**This notification is sent on parsing the document and while processing
 * elements having non empty style.behavior attribute value.
 *
 * \param lParam #LPNMHL_ATTACH_BEHAVIOR
 *
 * Application has to provide implementation of #htmlayout::behavior interface.
 * Set #NMHL_ATTACH_BEHAVIOR::impl to address of this implementation.
 **}
    HLN_ATTACH_BEHAVIOR         = $AFF + $08;

{**This notification is sent after DOM element has changed its behavior(s)
 *
 * \param lParam #LPNMHL_BEHAVIOR_CHANGED
 *
 **}
    HLN_BEHAVIOR_CHANGED        = $AFF + $09;

{**This notification is sent when dialog window created but document is not loaded
 *
 *
 * \param lParam is a pointer to statndard NMHDR
 *
 * ATTN: Will be sent ONLY by HTMLayoutDialog API function.
 **}
    HLN_DIALOG_CREATED          = $AFF + $10;

{**This notification is sent when dialog window is about to be closed
 * - happens while handling WM_CLOSE in dialog
 *
 * \param lParam #LPNMHL_DIALOG_CLOSE_RQ
 *
 * ATTN: Will be sent ONLY by HTMLayoutDialog API function.
 **}
    HLN_DIALOG_CLOSE_RQ         = $AFF + $0A;

{**This notification is sent when document is loaded and parsed in full.
 *
 * This notification is sent before HLN_DOCUMENT_COMPLETE
 *
 **}
    HLN_DOCUMENT_LOADED         = $AFF + $0B;

{**Create "default HTML control", used by #HLN_CREATE_CONTROL notification as
 * value for #NMHL_CREATE_CONTROL::outControlHwnd.
 **}
    HWND_TRY_DEFAULT            = HWND(0);

{**Do not create any controls, used by #HLN_CREATE_CONTROL notification as
 * value for #NMHL_CREATE_CONTROL::outControlHwnd.
 **}
    HWND_DISCARD_CREATION       = HWND(1);

{**Use default loader or outData/outDataSize if they are set,
 * used as a return value for #HLN_CREATE_CONTROL notification.
 **}
    LOAD_OK                     = 0;

{**Do not load resource at all,
 * Used as a return value for #HLN_CREATE_CONTROL notification.
 **}
    LOAD_DISCARD                = 1;

// pass this value in wParam of WM_CREATE or WM_INITDIALOG to disable builtin IDropSource/IDropTatget (Drag-n-drop)
    WPARAM_DISCARD_BUILTIN_DD_SUPP0RT = $8000;

type
    // typedef LRESULT CALLBACK HTMLAYOUT_NOTIFY(UINT uMsg, WPARAM wParam, LPARAM lParam, LPVOID vParam);
    HTMLayoutNotify             = function( uMsg : UINT; wParam : WPARAM; lParam : LPARAM; vParam : Pointer ) : LRESULT stdcall;
    HTMLayoutElementEventProc   = function( tag : Pointer; he : HELEMENT; evtg: UINT; prms : Pointer ) : BOOL stdcall;
    HTMLAYOUT_CALLBACK_RES      = function( resourceUri : LPCWSTR; resourceType : LPCSTR; imageData : LPCBYTE; imageDataSize : DWORD ) : BOOL stdcall;
    HTMLAYOUT_CALLBACK_RES_EX   = function( resourceUri : LPCWSTR; resourceType : LPCSTR; imageData : LPCBYTE; imageDataSize : DWORD; prm : Pointer ) : BOOL stdcall;
    HTMLAYOUT_DATA_WRITER       = procedure( uri : LPCWSTR; dataType : UINT {HTMLayoutResourceType}; data : LPCBYTE; dataLength : UINT ); stdcall;
    HTMLAYOUT_DATA_LOADER       = function( uri : LPCWSTR; dataType : UINT {HTMLayoutResourceType}; pDataWriter : HTMLAYOUT_DATA_WRITER ) : BOOL stdcall;
    HTMLAYOUT_DEBUG_OUTPUT_PROC = procedure( param : Pointer; character : integer ); stdcall;

{**This structure is used by #HLN_CREATE_CONTROL and #HLN_CONTROL_CREATED
 * notifications.
 *
 * - #HLN_CREATE_CONTROL
 * \copydoc HLN_CREATE_CONTROL
 *
 * - #HLN_CONTROL_CREATED
 *   \copydoc HLN_CONTROL_CREATED
 *
 **}
    NMHL_CREATE_CONTROL = record
        hdr                     : NMHDR; // Default WM_NOTIFY header
        helement                : HELEMENT; // [in] DOM element.
        inHwndParent            : HWND; // [in] HWND of the HTMLayout window.
        outControlHwnd          : HWND; // [out] HWND of control created or #HWND_TRY_DEFAULT or HWND_DISCARD_CREATION.
        reserved1               : DWORD;
        reserved2               : DWORD;
    end;
    PNMHL_CREATE_CONTROL = ^NMHL_CREATE_CONTROL;

{**This structure is used by #HLN_DESTROY_CONTROL notification.
 * \copydoc HLN_DESTROY_CONTROL
 **}
    NMHL_DESTROY_CONTROL = record
        hdr                     : NMHDR; // Default WM_NOTIFY header
        helement                : HELEMENT; // [in] DOM element.
        inoutControlHwnd        : HWND; // HWND of child to be destroyed.
        reserved1               : DWORD;
    end;
    PNMHL_DESTROY_CONTROL = ^NMHL_DESTROY_CONTROL;

{**This structure is used by #HLN_LOAD_DATA notification.
 *\copydoc HLN_LOAD_DATA **}
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

{**This structure is used by #HLN_DATA_LOADED notification.
 *\copydoc HLN_DATA_LOADED
 **}
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

{**This structure is used by #HLN_ATTACH_BEHAVIOR notification.
 *\copydoc HLN_ATTACH_BEHAVIOR **}
    NMHL_ATTACH_BEHAVIOR = record
        hdr                     : NMHDR; // Default WM_NOTIFY header
        helement                : HELEMENT; // [in] DOM element.
        behaviorName            : LPCSTR; // [in] zero terminated string, string appears as value of CSS behavior:"???" attribute.

        elementProc             : HTMLayoutElementEventProc; // [out] pointer to ElementEventProc function.
        elementTag              : Pointer; // [out] tag value, passed as is into pointer ElementEventProc function.
        elementEvents           : UINT; // [out] EVENT_GROUPS bit flags, event groups elementProc subscribed to.
    end;
    PNMHL_ATTACH_BEHAVIOR = ^NMHL_ATTACH_BEHAVIOR;

{**This structure is used by #HLN_BEHAVIOR_CHANGED notification.
 *\copydoc HLN_BEHAVIOR_CHANGED **}
    NMHL_BEHAVIOR_CHANGED = record
        hdr                     : NMHDR; // Default WM_NOTIFY header.
        helement                : HELEMENT; // [in] DOM element.
        oldNames                : LPCSTR; // [in] zero terminated string, whitespace separated list of old behaviors.
        newNames                : LPCSTR; // [in] zero terminated string, whitespace separated list of new behaviors that the element just got.
    end;
    PNMHL_BEHAVIOR_CHANGED = ^NMHL_BEHAVIOR_CHANGED;

{**This structure is used by #HLN_DIALOG_CLOSE_RQ notification.
 *\copydoc HLN_LOAD_DATA **}
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


// htmlayout.h
function  HTMLayoutClassNameA() : LPCSTR; stdcall;
function  HTMLayoutClassNameW() : LPCWSTR; stdcall;
function  HTMLayoutDataReady( hwnd : HWND; uri : LPCWSTR; data : PBYTE; length: DWORD): BOOL; stdcall;
function  HTMLayoutDataReadyAsync( hwnd : HWND; uri : LPCWSTR; data : PBYTE; dataLength : DWORD; dataType : UINT {HTMLayoutResourceType} ) : BOOL; stdcall;
function  HTMLayoutProc( hwnd : HWND; msg : UINT; wParam : WPARAM; lParam : LPARAM ): LRESULT; stdcall;
function  HTMLayoutProcW( hwnd : HWND; msg : UINT; wParam : WPARAM; lParam : LPARAM ): LRESULT; stdcall;
function  HTMLayoutProcND( hwnd : HWND; msg: UINT; wParam : WPARAM; lParam : LPARAM; var pbHandled: BOOL): LRESULT; stdcall;
function  HTMLayoutGetMinWidth( hwnd : HWND ) : UINT; stdcall;
function  HTMLayoutGetMinHeight( hwnd : HWND; width : UINT ) : UINT; stdcall;
function  HTMLayoutLoadFile( hwnd : HWND; filename : LPCWSTR) : BOOL; stdcall;
function  HTMLayoutLoadHtml( hwnd : HWND; html : LPCBYTE; htmlSize: UINT): BOOL; stdcall;
function  HTMLayoutLoadHtmlEx( hwnd : HWND; html : LPCBYTE; htmlSize : UINT; baseUrl : LPCWSTR) : BOOL; stdcall;
procedure HTMLayoutSetMode( hwnd : HWND; HTMLayoutMode : integer {HTMLayoutModes} ); stdcall;
procedure HTMLayoutSetCallback( hwnd : HWND; cb : HTMLayoutNotify; cbParam : Pointer ); stdcall;
function  HTMLayoutSelectionExist( hwnd : HWND ) : BOOL; stdcall;
function  HTMLayoutGetSelectedHTML( hwnd : HWND; var pSize : UINT ) : LPCBYTE; stdcall;
function  HTMLayoutClipboardCopy( hwnd : HWND ) : BOOL; stdcall;
function  HTMLayoutEnumResources( hwnd : HWND; cb : HTMLAYOUT_CALLBACK_RES ) : UINT; stdcall;
function  HTMLayoutEnumResourcesEx( hwnd : HWND; cb : HTMLAYOUT_CALLBACK_RES_EX; cbPrm : Pointer ) : UINT; stdcall;
function  HTMLayoutSetMasterCSS( utf8 : LPCBYTE; numBytes : UINT ) : BOOL; stdcall;
function  HTMLayoutAppendMasterCSS( utf8 : LPCBYTE; numBytes : UINT ) : BOOL; stdcall;
function  HTMLayoutSetDataLoader( pDataLoader : HTMLAYOUT_DATA_LOADER ) : BOOL; stdcall;
function  HTMLayoutDeclareElementType( name : LPCSTR; elementModel : UINT {ELEMENT_MODEL} ) : BOOL; stdcall;
function  HTMLayoutSetCSS( hwnd : HWND; utf8 : LPCBYTE; numBytes : UINT; baseUrl : LPCWSTR; mediaType : LPCWSTR ) : BOOL; stdcall;
function  HTMLayoutSetMediaType( hwnd : HWND; mediaType : LPCWSTR ) : BOOL; stdcall;
function  HTMLayoutSetMediaVars(  hwnd : HWND; const mediaVars : PRHtmlValue ) : BOOL; stdcall;
function  HTMLayoutSetHttpHeaders( hwnd : HWND; httpHeaders : LPCSTR; httpHeadersLength : UINT ) : BOOL; stdcall;
function  HTMLayoutSetOption( hwnd : HWND; option : UINT {HTMLAYOUT_OPTIONS}; value : UINT ) : BOOL; stdcall;
function  HTMLayoutRender( hwnd : HWND; hBmp : HBITMAP; area : TRECT ) : BOOL; stdcall;
function  HTMLayoutUpdateWindow( hwnd : HWND ) : BOOL; stdcall;
function  HTMLayoutCommitUpdates( hwnd : HWND ) : BOOL; stdcall;
function  HTMLayoutUrlEscape( text : LPCWSTR; spaceToPlus : BOOL; buffer : LPSTR; bufferLength : UINT ) : UINT; stdcall;
function  HTMLayoutUrlUnescape( url : LPCSTR; buffer : LPWSTR; bufferLength : UINT ) : UINT; stdcall;
function  HTMLayoutDialog( hwnd : HWND; position : TPoint; alignment : integer; style : UINT; styleEx : UINT; ncb : HTMLayoutNotify; ecb : HTMLayoutElementEventProc; callbackParam : Pointer; html : LPCBYTE; htmlLength : UINT ) : INT_PTR; stdcall;
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

