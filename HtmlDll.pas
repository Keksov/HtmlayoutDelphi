unit HtmlDll;

interface

uses Windows
    , HtmlCommon
    , HtmlTypes
    , HtmlBehaviour
;

// HTMLayout API documentation http://www.terrainformatica.com/htmlayout/doxydoc/index.html

// htmlayout.h
function  HTMLayoutClassNameA() : LPCSTR; stdcall;
function  HTMLayoutClassNameW() : LPCWSTR; stdcall;
function  HTMLayoutDataReady( hwnd : HWND; uri : LPCWSTR; data : Pointer; length: DWORD): BOOL; stdcall;
function  HTMLayoutDataReadyAsync( hwnd : HWND; uri : LPCWSTR; data : PBYTE; dataLength : DWORD; dataType : UINT ) : BOOL; stdcall;
function  HTMLayoutProc( hwnd : HWND; msg : UINT; wParam : WPARAM; lParam : LPARAM ): LRESULT; stdcall;
function  HTMLayoutProcND( hwnd : HWND; msg: UINT; wParam : WPARAM; lParam : LPARAM; var pbHandled: BOOL): LRESULT; stdcall;
function  HTMLayoutGetMinWidth( hwnd : HWND ) : UINT; stdcall;
function  HTMLayoutGetMinHeight( hwnd : HWND; width : UINT ) : UINT; stdcall;
function  HTMLayoutLoadFile( hwnd : HWND; filename : LPCWSTR) : BOOL; stdcall;
function  HTMLayoutLoadHtml( hwnd : HWND; html : PBYTE; htmlSize: UINT): BOOL; stdcall;
function  HTMLayoutLoadHtmlEx( hwnd : HWND; html : PBYTE; htmlSize : UINT; baseUrl : LPCWSTR) : BOOL; stdcall;
procedure HTMLayoutSetMode( hwnd : HWND; HTMLayoutMode : HTMLayoutModes); stdcall;
procedure HTMLayoutSetCallback(hwnd: HWND; cb: HTMLayoutCallback; cbParam: Pointer); stdcall;
function  HTMLayoutSelectionExist( hwnd : HWND ) : BOOL; stdcall;
function  HTMLayoutGetSelectedHTML( hwnd : HWND; var pSize : UINT ) : PBYTE; stdcall;
function  HTMLayoutClipboardCopy( hwnd : HWND ) : BOOL; stdcall;
function  HTMLayoutSetMasterCSS( utf8 : PBYTE; numBytes : UINT ) : BOOL; stdcall;
function  HTMLayoutSetCSS( hwnd : HWND; utf8 : PBYTE; numBytes : UINT; baseUrl : LPCWSTR; mediaType : LPCWSTR ) : BOOL; stdcall;
function  HTMLayoutSetMediaType( hwnd : HWND; mediaType : LPCWSTR ) : BOOL; stdcall;
function  HTMLayoutSetHttpHeaders( hwnd : HWND; httpHeaders : LPCSTR; httpHeadersLength : UINT ) : BOOL; stdcall;
function  HTMLayoutRender( hwnd : HWND; hBmp : HBITMAP; area : TRECT ) : BOOL; stdcall;

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
function  HTMLayoutGetElementInnerText( he : HELEMENT; var utf8bytes : PCHAR ) : HLDOM_RESULT; stdcall;
function  HTMLayoutSetElementInnerText( he : HELEMENT; utf8bytes : LPCSTR; length : UINT ) : HLDOM_RESULT; stdcall;
function  HTMLayoutGetElementInnerText16( he : HELEMENT; var utf16words : LPWSTR ) : HLDOM_RESULT; stdcall;
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
function  HTMLayoutUpdateElement( he : HELEMENT; renderNow : BOOL ) : HLDOM_RESULT; stdcall;
function  HTMLayoutUpdateElementEx( he : HELEMENT; flags : UINT ) : HLDOM_RESULT; stdcall;
function  HTMLayoutSetCapture( he : HELEMENT ) : HLDOM_RESULT; stdcall;
function  HTMLayoutGetElementHwnd( he : HELEMENT; var p_hwnd : HWND; rootWindow : BOOL ) : HLDOM_RESULT; stdcall;
function  HTMLayoutCombineURL( he : HELEMENT; szUrlBuffer : LPWSTR; UrlBufferSize : DWORD ) : HLDOM_RESULT; stdcall;
function  HTMLayoutVisitElements( he : HELEMENT; tagName : LPCSTR; attributeName : LPCSTR; attributeValue : LPCWSTR; callback : HTMLayoutElementCallback; param : POINTER; depth : DWORD ) : HLDOM_RESULT; stdcall;
function  HTMLayoutSelectElements( he: HELEMENT; CSS_selectors : LPCSTR; cb: HTMLayoutElementCallback; param : Pointer) : HLDOM_RESULT; stdcall;
function  HTMLayoutSelectParent( he : HELEMENT; selector : LPCSTR; depth : UINT; var heFound : HELEMENT ) : HLDOM_RESULT; stdcall;
function  HTMLayoutSetElementHtml( he : HELEMENT; html : PBYTE; htmlLength : DWORD; where : UINT ) : HLDOM_RESULT; stdcall;
function  HTMLayoutDeleteElement( he : HELEMENT ) : HLDOM_RESULT; stdcall;
function  HTMLayoutGetElementUID( he : HELEMENT; var puid : UINT ) : HLDOM_RESULT; stdcall;
function  HTMLayoutGetElementByUID( hwnd : HWND; uid : UINT; var phe : HELEMENT ) : HLDOM_RESULT; stdcall;
function  HTMLayoutShowPopup( hePopup : HELEMENT; heAnchor : HELEMENT; placement : UINT ) : HLDOM_RESULT; stdcall;
function  HTMLayoutShowPopupAt( hePopup : HELEMENT; pos : TPOINT; animate : BOOL ) : HLDOM_RESULT; stdcall;
function  HTMLayoutHidePopup( he : HELEMENT ) : HLDOM_RESULT; stdcall;
function  HTMLayoutGetElementState( he : HELEMENT; var pstateBits : UINT ) : HLDOM_RESULT; stdcall;
function  HTMLayoutSetElementState( he : HELEMENT; stateBitsToSet : UINT; stateBitsToClear : UINT; updateView : BOOL ) : HLDOM_RESULT; stdcall;
function  HTMLayoutCreateElement( tagname : LPCSTR; textOrNull : LPCWSTR; var phe : HELEMENT ) : HLDOM_RESULT; stdcall;
function  HTMLayoutCloneElement( he : HELEMENT; var phe : HELEMENT ) : HLDOM_RESULT; stdcall;
function  HTMLayoutInsertElement( he : HELEMENT; hparent: HELEMENT; index : UINT ) : HLDOM_RESULT; stdcall;
function  HTMLayoutDetachElement( he : HELEMENT ) : HLDOM_RESULT; stdcall;
function  HTMLayoutSetTimer( he : HELEMENT; milliseconds : UINT ) : HLDOM_RESULT; stdcall;
function  HTMLayoutAttachEventHandler( he : HELEMENT; pep: HTMLayoutHElementEvent; tag : Pointer ) : HLDOM_RESULT; stdcall;
function  HTMLayoutDetachEventHandler( he : HELEMENT; pep: HTMLayoutHElementEvent; tag : Pointer ) : HLDOM_RESULT; stdcall;
function  HTMLayoutAttachEventHandlerEx( he : HELEMENT; pep: HTMLayoutHElementEvent; tag : Pointer; subscription : UINT ) : HLDOM_RESULT; stdcall;
//function  HTMLayoutDetachEventHandlerEx( he : HELEMENT; pep: HTMLayoutHElementEvent; tag : Pointer; subscription : UINT ) : HLDOM_RESULT; stdcall;
function  HTMLayoutWindowAttachEventHandler( hwnd : HWND; pep: HTMLayoutHElementEvent; tag : Pointer; subscription : UINT ) : HLDOM_RESULT; stdcall;
function  HTMLayoutSendEvent( he : HELEMENT; appEventCode : UINT; heSource : HELEMENT; reason : UINT; var handled : BOOL ) : HLDOM_RESULT; stdcall;
function  HTMLayoutPostEvent( he : HELEMENT; appEventCode : UINT; heSource : HELEMENT; reason : UINT ) : HLDOM_RESULT; stdcall;
function  HTMLayoutCallBehaviorMethod( he : HELEMENT; params : POINTER) : HLDOM_RESULT; stdcall;
function  HTMLayoutRequestElementData( he : HELEMENT; url : LPCWSTR; dataType : UINT; initiator : HELEMENT ) : HLDOM_RESULT; stdcall;
function  HTMLayoutGetScrollInfo( he : HELEMENT; var scrollPos : TPOINT; var viewRect : TRECT; var contentSize : UINT ) : HLDOM_RESULT; stdcall;
function  HTMLayoutSetScrollPos( he : HELEMENT; scrollPos : TPOINT; smooth : BOOL ) : HLDOM_RESULT; stdcall;
function  HTMLayoutIsElementVisible( he : HELEMENT; var pVisible : BOOL ) : HLDOM_RESULT; stdcall;
function  HTMLayoutIsElementEnabled( he : HELEMENT; var pEnabled : BOOL ) : HLDOM_RESULT; stdcall;
//function  HTMLayoutSortElements( he : HELEMENT; firstIndex : UINT; lastIndex : UINT; cmpFunc : ELEMENT_COMPARATOR; cmpFuncParam : POINTER ) : HLDOM_RESULT; stdcall;
function  HTMLayoutSwapElements( he1 : HELEMENT; he2 : HELEMENT ) : HLDOM_RESULT; stdcall;
function  HTMLayoutTraverseUIEvent( evt : UINT; eventCtlStruct : POINTER; var bOutProcessed : BOOL ) : HLDOM_RESULT; stdcall;
function  HTMLayoutControlGetType( he : HELEMENT; var pType : UINT ) : HLDOM_RESULT; stdcall;
//function  HTMLayoutControlGetValue( he : HELEMENT; pVal : JSON_VALUE ) : HLDOM_RESULT; stdcall;
//function  HTMLayoutControlSetValue( he : HELEMENT; const pVal : JSON_VALUE ) : HLDOM_RESULT; stdcall;
//function  HTMLayoutEnumerate( he : HELEMENT; pcb : HTMLayoutEnumerationCallback; p : POINTER; forward : BOOL ) : HLDOM_RESULT; stdcall;
function  HTMLayoutGetCharacterRect( he : HELEMENT; pos : UINT; var outRect : TRECT ) : HLDOM_RESULT; stdcall;
function  HTMLayoutGetElementLocation( he : HELEMENT; var p_location : TRect; areas : UINT {HTMLayoutElementAreas} ) : HLDOM_RESULT; stdcall;
function  HTMLayoutScrollToView( he : HELEMENT; flags : UINT {HTMLayoutScrollFlags} ) : HLDOM_RESULT; stdcall;
function  HTMLayoutMoveElement( he : HELEMENT; xView, yView : integer ) : HLDOM_RESULT; stdcall;
function  HTMLayoutMoveElementEx( he : HELEMENT; xView, yView, width, height : integer ) : HLDOM_RESULT; stdcall;

implementation

uses
  SysUtils;

const
  engineDLL = 'htmlayout.dll';

// htmlayout_dom.h
function  HTMLayout_UseElement( he : HELEMENT ) : HLDOM_RESULT; external engineDLL; stdcall;
function  HTMLayout_UnuseElement( he : HELEMENT ) : HLDOM_RESULT; external engineDLL; stdcall;
function  HTMLayoutGetRootElement( hwnd : HWND; var phe : HELEMENT ) : HLDOM_RESULT; external engineDLL; stdcall;
function  HTMLayoutGetFocusElement( hwnd : HWND; var phe : HELEMENT ) : HLDOM_RESULT; external engineDLL; stdcall;
function  HTMLayoutFindElement( hwnd : HWND; pt : TPOINT; var phe : HELEMENT ) : HLDOM_RESULT; external engineDLL; stdcall;
function  HTMLayoutGetChildrenCount( he : HELEMENT; var count : UINT ) : HLDOM_RESULT; external engineDLL; stdcall;
function  HTMLayoutGetNthChild( he : HELEMENT; n : UINT; var phe : HELEMENT ) : HLDOM_RESULT; external engineDLL; stdcall;
function  HTMLayoutGetParentElement( he : HELEMENT; var p_parent_he : HELEMENT ) : HLDOM_RESULT; external engineDLL; stdcall;
function  HTMLayoutGetElementText( he : HELEMENT; characters: LPWSTR; var length : UINT) : HLDOM_RESULT; external engineDLL; stdcall;
function  HTMLayoutGetElementHtml( he : HELEMENT; var utf8bytes : PCHAR; outer : BOOL ) : HLDOM_RESULT; external engineDLL; stdcall;
function  HTMLayoutGetElementInnerText( he : HELEMENT; var utf8bytes : PCHAR ) : HLDOM_RESULT; external engineDLL; stdcall;
function  HTMLayoutSetElementInnerText( he : HELEMENT; utf8bytes : LPCSTR; length : UINT  ) : HLDOM_RESULT; external engineDLL; stdcall;
function  HTMLayoutGetElementInnerText16( he : HELEMENT; var utf16words : LPWSTR ) : HLDOM_RESULT; external engineDLL; stdcall;
function  HTMLayoutSetElementInnerText16( he : HELEMENT; utf16words : LPCWSTR; length : UINT ) : HLDOM_RESULT; external engineDLL; stdcall;
function  HTMLayoutGetAttributeCount( he : HELEMENT; var p_count : UINT ) : HLDOM_RESULT; external engineDLL; stdcall;
function  HTMLayoutGetNthAttribute( he : HELEMENT; n : UINT; var p_name : LPCSTR; var p_value : LPCWSTR ) : HLDOM_RESULT; external engineDLL; stdcall;
function  HTMLayoutGetAttributeByName( he : HELEMENT; name : LPCSTR; var p_value : LPCWSTR ) : HLDOM_RESULT; external engineDLL; stdcall;
function  HTMLayoutSetAttributeByName( he : HELEMENT; name : LPCSTR; value : LPCWSTR ) : HLDOM_RESULT; external engineDLL; stdcall;
function  HTMLayoutClearAttributes( he : HELEMENT ) : HLDOM_RESULT; external engineDLL; stdcall;
function  HTMLayoutGetElementIndex( he : HELEMENT; var p_index : UINT ) : HLDOM_RESULT; external engineDLL; stdcall;
function  HTMLayoutGetElementType( he : HELEMENT; var p_type : LPCSTR ) : HLDOM_RESULT; external engineDLL; stdcall;
function  HTMLayoutGetStyleAttribute( he : HELEMENT; name : LPCSTR; var p_value : LPCWSTR ) : HLDOM_RESULT; external engineDLL; stdcall;
function  HTMLayoutSetStyleAttribute( he : HELEMENT; name : LPCSTR; value : LPCWSTR ) : HLDOM_RESULT; external engineDLL; stdcall;
function  HTMLayoutUpdateElement( he : HELEMENT; renderNow : BOOL ) : HLDOM_RESULT; external engineDLL; stdcall;
function  HTMLayoutUpdateElementEx( he : HELEMENT; flags : UINT ) : HLDOM_RESULT; external engineDLL; stdcall;
function  HTMLayoutSetCapture( he : HELEMENT ) : HLDOM_RESULT; external engineDLL; stdcall;
function  HTMLayoutGetElementHwnd( he : HELEMENT; var p_hwnd : HWND; rootWindow : BOOL ) : HLDOM_RESULT; external engineDLL; stdcall;
function  HTMLayoutCombineURL( he : HELEMENT; szUrlBuffer : LPWSTR; UrlBufferSize : DWORD ) : HLDOM_RESULT; external engineDLL; stdcall;
function  HTMLayoutVisitElements( he : HELEMENT; tagName : LPCSTR; attributeName : LPCSTR; attributeValue : LPCWSTR; callback : HTMLayoutElementCallback; param : POINTER; depth : DWORD ) : HLDOM_RESULT; external engineDLL; stdcall;
function  HTMLayoutSelectElements( he: HELEMENT; CSS_selectors : LPCSTR; cb: HTMLayoutElementCallback; param : Pointer) : HLDOM_RESULT; external engineDLL; stdcall;
function  HTMLayoutSelectParent( he : HELEMENT; selector : LPCSTR; depth : UINT; var heFound : HELEMENT ) : HLDOM_RESULT; external engineDLL; stdcall;
function  HTMLayoutSetElementHtml( he : HELEMENT; html : PBYTE; htmlLength : DWORD; where : UINT ) : HLDOM_RESULT; external engineDLL; stdcall;
function  HTMLayoutDeleteElement( he : HELEMENT ) : HLDOM_RESULT; external engineDLL; stdcall;
function  HTMLayoutGetElementUID( he : HELEMENT; var puid : UINT ) : HLDOM_RESULT; external engineDLL; stdcall;
function  HTMLayoutGetElementByUID( hwnd : HWND; uid : UINT; var phe : HELEMENT ) : HLDOM_RESULT; external engineDLL; stdcall;
function  HTMLayoutShowPopup( hePopup : HELEMENT; heAnchor : HELEMENT; placement : UINT ) : HLDOM_RESULT; external engineDLL; stdcall;
function  HTMLayoutShowPopupAt( hePopup : HELEMENT; pos : TPOINT; animate : BOOL ) : HLDOM_RESULT; external engineDLL; stdcall;
function  HTMLayoutHidePopup( he : HELEMENT ) : HLDOM_RESULT; external engineDLL; stdcall;
function  HTMLayoutGetElementState( he : HELEMENT; var pstateBits : UINT ) : HLDOM_RESULT; external engineDLL; stdcall;
function  HTMLayoutSetElementState( he : HELEMENT; stateBitsToSet : UINT; stateBitsToClear : UINT; updateView : BOOL ) : HLDOM_RESULT; external engineDLL; stdcall;
function  HTMLayoutCreateElement( tagname : LPCSTR; textOrNull : LPCWSTR; var phe : HELEMENT ) : HLDOM_RESULT; external engineDLL; stdcall;
function  HTMLayoutCloneElement( he : HELEMENT; var phe : HELEMENT ) : HLDOM_RESULT; external engineDLL; stdcall;
function  HTMLayoutInsertElement( he : HELEMENT; hparent: HELEMENT; index : UINT ) : HLDOM_RESULT; external engineDLL; stdcall;
function  HTMLayoutDetachElement( he : HELEMENT ) : HLDOM_RESULT; external engineDLL; stdcall;
function  HTMLayoutSetTimer( he : HELEMENT; milliseconds : UINT ) : HLDOM_RESULT; external engineDLL; stdcall;
function  HTMLayoutAttachEventHandler( he : HELEMENT; pep: HTMLayoutHElementEvent; tag : Pointer ) : HLDOM_RESULT; external engineDLL; stdcall;
function  HTMLayoutDetachEventHandler( he : HELEMENT; pep: HTMLayoutHElementEvent; tag : Pointer ) : HLDOM_RESULT; external engineDLL; stdcall;
function  HTMLayoutAttachEventHandlerEx( he : HELEMENT; pep: HTMLayoutHElementEvent; tag : Pointer; subscription : UINT ) : HLDOM_RESULT; external engineDLL; stdcall;
//function  HTMLayoutDetachEventHandlerEx( he : HELEMENT; pep: HTMLayoutHElementEvent; tag : Pointer; subscription : UINT ) : HLDOM_RESULT; external engineDLL; stdcall;
function  HTMLayoutWindowAttachEventHandler( hwnd : HWND; pep: HTMLayoutHElementEvent; tag : Pointer; subscription : UINT ) : HLDOM_RESULT; external engineDLL; stdcall;
function  HTMLayoutSendEvent( he : HELEMENT; appEventCode : UINT; heSource : HELEMENT; reason : UINT; var handled : BOOL ) : HLDOM_RESULT; external engineDLL; stdcall;
function  HTMLayoutPostEvent( he : HELEMENT; appEventCode : UINT; heSource : HELEMENT; reason : UINT ) : HLDOM_RESULT; external engineDLL; stdcall;
function  HTMLayoutCallBehaviorMethod( he : HELEMENT; params : POINTER) : HLDOM_RESULT; external engineDLL; stdcall;
function  HTMLayoutRequestElementData( he : HELEMENT; url : LPCWSTR; dataType : UINT; initiator : HELEMENT ) : HLDOM_RESULT; external engineDLL; stdcall;
function  HTMLayoutGetScrollInfo( he : HELEMENT; var scrollPos : TPOINT; var viewRect : TRECT; var contentSize : UINT ) : HLDOM_RESULT; external engineDLL; stdcall;
function  HTMLayoutSetScrollPos( he : HELEMENT; scrollPos : TPOINT; smooth : BOOL ) : HLDOM_RESULT; external engineDLL; stdcall;
function  HTMLayoutIsElementVisible( he : HELEMENT; var pVisible : BOOL ) : HLDOM_RESULT; external engineDLL; stdcall;
function  HTMLayoutIsElementEnabled( he : HELEMENT; var pEnabled : BOOL ) : HLDOM_RESULT; external engineDLL; stdcall;
//function  HTMLayoutSortElements( he : HELEMENT; firstIndex : UINT; lastIndex : UINT; cmpFunc : ELEMENT_COMPARATOR; cmpFuncParam : POINTER ) : HLDOM_RESULT; external engineDLL; stdcall;
function  HTMLayoutSwapElements( he1 : HELEMENT; he2 : HELEMENT ) : HLDOM_RESULT; external engineDLL; stdcall;
function  HTMLayoutTraverseUIEvent( evt : UINT; eventCtlStruct : POINTER; var bOutProcessed : BOOL ) : HLDOM_RESULT; external engineDLL; stdcall;
function  HTMLayoutControlGetType( he : HELEMENT; var pType : UINT ) : HLDOM_RESULT; external engineDLL; stdcall;
//function  HTMLayoutControlGetValue( he : HELEMENT; pVal : JSON_VALUE ) : HLDOM_RESULT; external engineDLL; stdcall;
//function  HTMLayoutControlSetValue( he : HELEMENT; const pVal : JSON_VALUE ) : HLDOM_RESULT; external engineDLL; stdcall;
//function  HTMLayoutEnumerate( he : HELEMENT; pcb : HTMLayoutEnumerationCallback; p : POINTER; forward : BOOL ) : HLDOM_RESULT; external engineDLL; stdcall;
function  HTMLayoutGetCharacterRect( he : HELEMENT; pos : UINT; var outRect : TRECT ) : HLDOM_RESULT; external engineDLL; stdcall;
function  HTMLayoutGetElementLocation(he : HELEMENT; var p_location : TRect; areas : UINT {ROOT_RELATIVE|CONTENT_BOX} ) : HLDOM_RESULT; external engineDLL; stdcall;
function  HTMLayoutScrollToView(he : HELEMENT; flags : UINT {HTMLayoutScrollFlags} ) : HLDOM_RESULT; external engineDLL; stdcall;
function  HTMLayoutMoveElement( he : HELEMENT; xView, yView : integer ) : HLDOM_RESULT; external engineDLL; stdcall;
function  HTMLayoutMoveElementEx( he : HELEMENT; xView, yView, width, height : integer ) : HLDOM_RESULT; external engineDLL; stdcall;

// htmlayout.h
function  HTMLayoutClassNameA() : LPCSTR; external engineDLL; stdcall;
function  HTMLayoutClassNameW() : LPCWSTR; external engineDLL; stdcall;
function  HTMLayoutDataReady( hwnd : HWND; uri : LPCWSTR; data : Pointer; length : DWORD) : BOOL; external engineDLL; stdcall;
function  HTMLayoutDataReadyAsync( hwnd : HWND; uri : LPCWSTR; data : PBYTE; dataLength : DWORD; dataType : UINT ) : BOOL; external engineDLL; stdcall;
function  HTMLayoutProc( hwnd : HWND; msg : UINT; wParam : WPARAM; lParam : LPARAM ): LRESULT; external engineDLL; stdcall;
function  HTMLayoutProcND(  hwnd : HWND; msg : UINT; wParam : WPARAM; lParam : LPARAM; var pbHandled : BOOL ): LRESULT; external engineDLL; stdcall;

function  HTMLayoutGetMinWidth( hwnd : HWND ) : UINT; external engineDLL; stdcall;
function  HTMLayoutGetMinHeight( hwnd : HWND; width : UINT ) : UINT; external engineDLL; stdcall;
function  HTMLayoutLoadFile( hwnd : HWND; filename : LPCWSTR): BOOL;  external engineDLL; stdcall;
function  HTMLayoutLoadHtml( hwnd : HWND; html : PBYTE; htmlSize : UINT): BOOL; external engineDLL; stdcall;
function  HTMLayoutLoadHtmlEx( hwnd : HWND; html : PBYTE; htmlSize : UINT; baseUrl : LPCWSTR ) : BOOL; external engineDLL; stdcall;
procedure HTMLayoutSetMode( hwnd : HWND; HTMLayoutMode : HTMLayoutModes ); external engineDLL; stdcall;
procedure HTMLayoutSetCallback( hwnd : HWND; cb : HTMLayoutCallback; cbParam : Pointer ); external engineDLL; stdcall;
function  HTMLayoutSelectionExist( hwnd : HWND ) : BOOL; external engineDLL; stdcall;
function  HTMLayoutGetSelectedHTML( hwnd : HWND; var pSize : UINT ) : PBYTE; external engineDLL; stdcall;
function  HTMLayoutClipboardCopy( hwnd : HWND ) : BOOL; external engineDLL; stdcall;
function  HTMLayoutSetMasterCSS( utf8 : PBYTE; numBytes : UINT) : BOOL; external engineDLL; stdcall;
function  HTMLayoutSetCSS( hwnd : HWND; utf8 : PBYTE; numBytes : UINT; baseUrl : LPCWSTR; mediaType : LPCWSTR ) : BOOL; external engineDLL; stdcall;
function  HTMLayoutSetMediaType( hwnd : HWND; mediaType : LPCWSTR ) : BOOL; external engineDLL; stdcall;
function  HTMLayoutSetHttpHeaders( hwnd : HWND; httpHeaders : LPCSTR; httpHeadersLength : UINT ) : BOOL; external engineDLL; stdcall;
function  HTMLayoutRender( hwnd : HWND; hBmp : HBITMAP; area : TRECT ) : BOOL; external engineDLL; stdcall;


//function  HTMLayoutDialog ( hwnd : HWND; position : TPOINT; alignment : INTEGER; style : UINT; styleEx : UINT; notificationCallback : LPHTMLAYOUT_NOTIFY;
//  eventsCallback : LPELEMENT_EVENT_PROC; callbackParam : POINTER; html : LPCBYTE; htmlLength : UINT ) PINTEGER;
{

function HTMLayoutFindFirst(he: HELEMENT; sel: PWideChar): HELEMENT;
  function FirstCallback(he: HELEMENT; param: Pointer): BOOL stdcall;
  begin
    GetElementHtml(he);
    pHELEMENT(param)^ := he;
    Result := True; // stop enum
  end;
begin
  Result := nil;
  HTMLayoutSelectElements(he, sel, @FirstCallback, @Result);
end;

function HTMLayoutEventThunk(tag: Pointer; he: HELEMENT; event: UINT; params: Pointer): BOOL stdcall;
begin
  Result := False;
  if tag = nil then Exit;
  case event of
    HANDLE_BEHAVIOR_EVENT:
      Result := IHtmlBehaviorListener(tag).OnBehaviorEvent(he, pBehaviorEventParams(params));
    HANDLE_DRAW:
      Result := IHtmlBehaviorListener(tag).OnBehaviorDraw(he, pBehaviorDrawParams(params));
  end;
end;

function HTMLayoutElementSetHandler(he: HELEMENT; cb: IHtmlBehaviorListener): Boolean;
begin
  Result := HTMLayoutAttachEventHandler(he, HTMLayoutEventThunk, Pointer(cb)) = HLDOM_OK;
end;

function HTMLayoutElementRemoveHandler(he: HELEMENT; cb: IHtmlBehaviorListener): Boolean;
begin
  Result := HTMLayoutDetachEventHandler(he, HTMLayoutEventThunk, Pointer(cb)) = HLDOM_OK;
end;
}

end.

