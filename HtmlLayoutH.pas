unit HtmlLayoutH;

(*
  HTMLayout License terms could be found here http://www.terrainformatica.com/htmlayout/prices.whtm
  SDK - http://www.terrainformatica.com/htmlayout/HTMLayoutSDK.zip

  Delphi binding of HTMLayout published under LGPL. Visit https://github.com/Keksov/HtmlayoutDelphi

  This file contains function and types declarations translated from include\htmlayout_dom.h of
  Most accurate documentation could be found in include\htmlayout.h itself
*)

interface

uses Windows
    , HtmlTypes
    , HtmlBehaviorH
    , HtmlValueH
;

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

    HWND_TRY_DEFAULT            = HWND(0);
    HWND_DISCARD_CREATION       = HWND(1);

    LOAD_OK                     = 0;
    LOAD_DISCARD                = 1;

    WPARAM_DISCARD_BUILTIN_DD_SUPP0RT = $8000; // pass this value in wParam of WM_CREATE or WM_INITDIALOG to disable builtin IDropSource/IDropTatget (Drag-n-drop)

type
    // typedef LRESULT CALLBACK HTMLAYOUT_NOTIFY(UINT uMsg, WPARAM wParam, LPARAM lParam, LPVOID vParam);
    HTMLayoutNotify             = function( uMsg : UINT; wParam : WPARAM; lParam : LPARAM; vParam : Pointer ) : LRESULT stdcall;
    HTMLayoutElementEventProc   = function( tag : Pointer; he : HELEMENT; evtg: UINT; prms : Pointer ) : BOOL stdcall;
    HTMLAYOUT_CALLBACK_RES      = function( resourceUri : LPCWSTR; resourceType : LPCSTR; imageData : LPCBYTE; imageDataSize : DWORD ) : BOOL stdcall;
    HTMLAYOUT_CALLBACK_RES_EX   = function( resourceUri : LPCWSTR; resourceType : LPCSTR; imageData : LPCBYTE; imageDataSize : DWORD; prm : Pointer ) : BOOL stdcall;
    HTMLAYOUT_DATA_WRITER       = procedure( uri : LPCWSTR; dataType : UINT {HTMLayoutResourceType}; data : LPCBYTE; dataLength : UINT ); stdcall;
    HTMLAYOUT_DATA_LOADER       = function( uri : LPCWSTR; dataType : UINT {HTMLayoutResourceType}; pDataWriter : HTMLAYOUT_DATA_WRITER ) : BOOL stdcall;
    HTMLAYOUT_DEBUG_OUTPUT_PROC = procedure( param : Pointer; character : integer ); stdcall;

    NMHL_CREATE_CONTROL = record
        hdr                     : NMHDR; // Default WM_NOTIFY header
        helement                : HELEMENT; // [in] DOM element.
        inHwndParent            : HWND; // [in] HWND of the HTMLayout window.
        outControlHwnd          : HWND; // [out] HWND of control created or #HWND_TRY_DEFAULT or HWND_DISCARD_CREATION.
        reserved1               : DWORD;
        reserved2               : DWORD;
    end;
    PNMHL_CREATE_CONTROL = ^NMHL_CREATE_CONTROL;

    NMHL_DESTROY_CONTROL = record
        hdr                     : NMHDR; // Default WM_NOTIFY header
        helement                : HELEMENT; // [in] DOM element.
        inoutControlHwnd        : HWND; // HWND of child to be destroyed.
        reserved1               : DWORD;
    end;
    PNMHL_DESTROY_CONTROL = ^NMHL_DESTROY_CONTROL;

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

    NMHL_ATTACH_BEHAVIOR = record
        hdr                     : NMHDR; // Default WM_NOTIFY header
        helement                : HELEMENT; // [in] DOM element.
        behaviorName            : LPCSTR; // [in] zero terminated string, string appears as value of CSS behavior:"???" attribute.

        elementProc             : HTMLayoutElementEventProc; // [out] pointer to ElementEventProc function.
        elementTag              : Pointer; // [out] tag value, passed as is into pointer ElementEventProc function.
        elementEvents           : UINT; // [out] EVENT_GROUPS bit flags, event groups elementProc subscribed to.
    end;
    PNMHL_ATTACH_BEHAVIOR = ^NMHL_ATTACH_BEHAVIOR;

    NMHL_BEHAVIOR_CHANGED = record
        hdr                     : NMHDR; // Default WM_NOTIFY header.
        helement                : HELEMENT; // [in] DOM element.
        oldNames                : LPCSTR; // [in] zero terminated string, whitespace separated list of old behaviors.
        newNames                : LPCSTR; // [in] zero terminated string, whitespace separated list of new behaviors that the element just got.
    end;
    PNMHL_BEHAVIOR_CHANGED = ^NMHL_BEHAVIOR_CHANGED;

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
procedure HTMLayoutSetCallback(hwnd: HWND; cb: HTMLayoutNotify; cbParam: Pointer); stdcall;
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
function  HTMLayoutSetMediaVars(  hwnd : HWND; const mediaVars : PHtmlVALUE ) : BOOL; stdcall;
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
function  HTMLayoutSetMediaVars(  hwnd : HWND; const mediaVars : PHtmlVALUE ) : BOOL; external HTMLayoutDLL; stdcall;
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

