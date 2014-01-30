unit HtmlCtrl;

(*
  This file contains object wrapper for function from include\htmlayout.h of
  HTMLayout SDK http://www.terrainformatica.com/htmlayout/HTMLayoutSDK.zip

  HTMLayout License terms could be found here http://www.terrainformatica.com/htmlayout/prices.whtm
  Delphi binding of HTMLayout is free for commercial and non-commercial use, visit https://github.com/Keksov/HtmlayoutDelphi

  Most accurate documentation could be found in include\htmlayout.h itself
*)

interface

uses Windows, Messages, SysUtils, Classes, Controls
    , HtmlTypes
    , HtmlLayoutH
    , HtmlLayoutDomH
    , HtmlValueH
    , HtmlElement
;

type
    THtmlControl = class;

    THtmlCtrlCreateControl      = function( aSender : THtmlControl; aEventParams : PNMHL_CREATE_CONTROL ): LRESULT of object;
    THtmlCtrlDestroyControl     = function( aSender : THtmlControl; aEventParams : PNMHL_DESTROY_CONTROL ): LRESULT of object;
    THtmlCtrlLoadData           = function( aSender : THtmlControl; aEventParams : PNMHL_LOAD_DATA ): LRESULT of object;
    THtmlCtrlDataLoaded         = function( aSender : THtmlControl; aEventParams : PNMHL_DATA_LOADED ): LRESULT of object;
    THtmlCtrlAttachBehavior     = function( aSender : THtmlControl; aEventParams : PNMHL_ATTACH_BEHAVIOR ): LRESULT of object;
    THtmlCtrlBehaviorChanged    = function( aSender : THtmlControl; aEventParams : PNMHL_BEHAVIOR_CHANGED ): LRESULT of object;
    THtmlCtrlDialogCloseRequest = function( aSender : THtmlControl; aEventParams : PNMHL_DIALOG_CLOSE_RQ ): LRESULT of object;
    THtmlCtrlNotifyEvent        = procedure( aSender : THtmlControl ) of object;

    {***************************************************************************
    * THtmlControl
    ***************************************************************************}
    THtmlControl = class( TWinControl )
private
    FOnCreateControl            : THtmlCtrlCreateControl; // HLN_CREATE_CONTROL
    FOnLoadData                 : THtmlCtrlLoadData; // HLN_LOAD_DATA
    FOnControlCreated           : THtmlCtrlNotifyEvent; // HLN_CONTROL_CREATED
    FOnDataLoaded               : THtmlCtrlDataLoaded; // HLN_DATA_LOADED
    FOnDocumentComplete         : THtmlCtrlNotifyEvent; // HLN_DOCUMENT_COMPLETE
    FOnUpdateUI                 : THtmlCtrlNotifyEvent; // HLN_UPDATE_UI
    FOnDestroyControl           : THtmlCtrlDestroyControl; // HLN_DESTROY_CONTROL
    FOnAttachBehavior           : THtmlCtrlAttachBehavior; // HLN_ATTACH_BEHAVIOR
    FOnBehaviorChanged          : THtmlCtrlBehaviorChanged; // HLN_BEHAVIOR_CHANGED
    FOnDialogCreated            : THtmlCtrlNotifyEvent; // HLN_DIALOG_CREATED
    FOnDialogCloseRequest       : THtmlCtrlDialogCloseRequest; // HLN_DIALOG_CLOSE_RQ
    FOnDocumentLoaded           : THtmlCtrlNotifyEvent; // HLN_DOCUMENT_LOADED

private
    function    HtmlCallback(uMsg: UINT; wParam: WPARAM; lParam: LPARAM): LRESULT;

    function    getWideHtml() : widestring;
    procedure   setWideHtml( const aHtml : widestring );
    function    getAnsiHtml() : string;
    procedure   setAnsiHtml( const aHtml : string );

protected
    procedure   CreateParams(var Params: TCreateParams); override;
    procedure   WndProc(var Message: TMessage); override;

public
    constructor Create(AOwner: TComponent); override;

    function    LoadHtml( const aHtml : string ) : boolean; overload;
    function    LoadHtml( const aHtml : widestring ) : boolean; overload;
    function    LoadHtmlEx( aHtml : string; aBaseUrl : widestring ) : boolean; overload;
    function    LoadHtmlEx( aHtml : widestring; aBaseUrl : widestring ) : boolean; overload;
    function    SetMasterCSS( aUtf8CSS : string ) : boolean; overload;
    function    AppendMasterCSS( aUtf8CSS : string ) : boolean; overload;
    function    SetHttpHeaders( aHttpHeaders : string ) : boolean; overload;
    function    SetCSS( aUtf8CSS : string; aBaseUrl : PWideChar; aMediaType : PWideChar ) : boolean; overload;

    // consult include\htmlayout.h from HTMLayout SDK for description of the following functions
    function    GetRootElement() : HELEMENT;
    function    DataReady( aUri : PWideChar; aData : Pointer; aDataLength : cardinal ) : boolean;
    function    DataReadyAsync( aUri : PWideChar; aData : Pointer; aDataLength : cardinal; aDataType : HTMLayoutResourceType ) : boolean;
    function    GetMinWidth() : cardinal;
    function    GetMinHeight( aWidth : cardinal ) : cardinal;
    function    LoadFile( const aFileName : widestring ) : boolean; overload;
    function    LoadHtml( aHtml : PCHAR; aHtmlSize : cardinal ) : boolean; overload;
    function    LoadHtmlEx( aHtml : PCHAR; aHtmlSize : cardinal; aBaseUrl : widestring ) : boolean; overload;
    procedure   SetMode( aHTMLayoutMode : HTMLayoutModes );
    procedure   SetCallback( aCallback : HTMLayoutNotify; aCallbackParam : Pointer );
    function    SelectionExist() : boolean;
    function    GetSelectedHTML( var aSize : cardinal ) : PCHAR;
    function    ClipboardCopy() : boolean;
    function    EnumResources( aCallback : HTMLAYOUT_CALLBACK_RES ) : cardinal;
    function    EnumResourcesEx( aCallback : HTMLAYOUT_CALLBACK_RES_EX; aCallbackParam : Pointer ) : cardinal;
    function    SetMasterCSS( aUtf8CSS : PCHAR; aCSSLength : cardinal ) : boolean; overload;
    function    AppendMasterCSS( aUtf8CSS : PCHAR; aCSSLength : cardinal ) : boolean; overload;
    function    SetDataLoader( aDataLoader : HTMLAYOUT_DATA_LOADER ) : boolean;
    function    DeclareElementType( aName : PCHAR; aElementModel : HTMLayoutElementModel ) : boolean;
    function    SetCSS( aUtf8CSS : PCHAR; aCSSLength : cardinal; aBaseUrl : PWideChar; aMediaType : PWideChar ) : boolean; overload;
    function    SetMediaType( aMediaType : PWideChar ) : boolean;
    function    SetMediaVars( const aMediaVars : PHtmlVALUE ) : boolean;
    function    SetHttpHeaders( aHttpHeaders : PCHAR; aHttpHeadersLength : cardinal ) : boolean; overload;
    function    SetOption( aOption : HTMLayoutOptions; aValue : cardinal ) : boolean;
    function    Render( aHBmp : HBITMAP; aArea : TRECT ) : boolean;
    function    UpdateWindow() : boolean;
    function    CommitUpdates() : boolean;
    function    UrlEscape( aText : PWideChar; aSpaceToPlus : boolean; aBuffer : PCHAR; aBufferLength : cardinal ) : cardinal;
    function    UrlUnescape( aUrl : PChar; aBuffer : PWideChar; aBufferLength : cardinal ) : cardinal;
    function    Dialog( aPosition : TPoint; aAlignment : integer; aStyle : cardinal; aStyleEx : cardinal; aDialogCallback : HTMLayoutNotify;
                        aElCallback : HTMLayoutElementEventProc; aCallbackParam : Pointer; aHtml : PCHAR; aHtmlLength : cardinal ) : integer;
    procedure   SetupDebugOutput( aParam : Pointer; aPFOutput : HTMLAYOUT_DEBUG_OUTPUT_PROC );

public // property
    property ansiHtml : string read getAnsiHtml write setAnsiHtml;
    property wideHtml : widestring read getWideHtml write setWideHtml;

    property html : string read getAnsiHtml write setAnsiHtml;
    property root : HELEMENT read GetRootElement;


published
    property Action;
    property Align;
    property Anchors;
    property BiDiMode;
    property Caption;
    property Constraints;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property Font;
    property ParentBiDiMode;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property TabOrder;
    property TabStop default True;
    property Visible;
    property OnClick;
    property OnContextPopup;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnStartDock;
    property OnStartDrag;

    // HtmlLayout events
    property OnCreateControl      : THtmlCtrlCreateControl read FOnCreateControl write FOnCreateControl; // HLN_CREATE_CONTROL
    property OnLoadData           : THtmlCtrlLoadData read FOnLoadData write FOnLoadData; // HLN_LOAD_DATA
    property OnControlCreated     : THtmlCtrlNotifyEvent read FOnControlCreated write FOnControlCreated; // HLN_CONTROL_CREATED
    property OnDataLoaded         : THtmlCtrlDataLoaded read FOnDataLoaded write FOnDataLoaded; // HLN_DATA_LOADED
    property OnDocumentComplete   : THtmlCtrlNotifyEvent read FOnDocumentComplete write FOnDocumentComplete; // HLN_DOCUMENT_COMPLETE
    property OnUpdateUI           : THtmlCtrlNotifyEvent read FOnUpdateUI write FOnUpdateUI; // HLN_UPDATE_UI
    property OnDestroyControl     : THtmlCtrlDestroyControl read FOnDestroyControl write FOnDestroyControl; // HLN_DESTROY_CONTROL
    property OnAttachBehavior     : THtmlCtrlAttachBehavior read FOnAttachBehavior write FOnAttachBehavior; // HLN_ATTACH_BEHAVIOR
    property OnBehaviorChanged    : THtmlCtrlBehaviorChanged read FOnBehaviorChanged write FOnBehaviorChanged; // HLN_BEHAVIOR_CHANGED
    property OnDialogCreated      : THtmlCtrlNotifyEvent read FOnDialogCreated write FOnDialogCreated; // HLN_DIALOG_CREATED
    property OnDialogCloseRequest : THtmlCtrlDialogCloseRequest read FOnDialogCloseRequest write FOnDialogCloseRequest; // HLN_DIALOG_CLOSE_RQ
    property OnDocumentLoaded     : THtmlCtrlNotifyEvent read FOnDocumentLoaded write FOnDocumentLoaded; // HLN_DOCUMENT_LOADED

    end;

implementation

uses HtmlTest; // just for testing

{----------------------------- THtmlControl -----------------------------------}

{*******************************************************************************
* Create
*******************************************************************************}
constructor THtmlControl.Create(AOwner: TComponent);
begin
    inherited Create( AOwner );
end;

{*******************************************************************************
* CreateParams
*******************************************************************************}
procedure THtmlControl.CreateParams( var Params : TCreateParams );
begin
    inherited CreateParams( Params );
end;

{*******************************************************************************
* HtmlCallbackProxy
*******************************************************************************}
function HtmlCallbackProxy( uMsg: UINT; wParam: WPARAM; lParam: LPARAM; vParam: Pointer ): LRESULT; stdcall;
begin
    if vParam <> nil then
        Result := THtmlControl( vParam ).HtmlCallback( uMsg, wParam, lParam )
    else
        Result := 0;
end;

{*******************************************************************************
* WndProc
*******************************************************************************}
procedure THtmlControl.WndProc( var Message : TMessage );
var
    Handled : BOOL;
    res     : LRESULT;

begin
    res := HTMLayoutProcND( Handle, Message.Msg, Message.WParam, Message.LParam, Handled );
    if Handled then
    begin
        Message.Result := res;
        exit;
    end;

    case Message.Msg of
    WM_CREATE:
        begin
            SetCallback( HtmlCallbackProxy, self );
        end;
    end;

    inherited WndProc( Message );
end;

{*******************************************************************************
* HtmlCallback
*******************************************************************************}
function THtmlControl.HtmlCallback( uMsg: UINT; wParam : WPARAM; lParam : LPARAM ) : LRESULT;
begin
    Result := 0;

    case PNMHDR( lParam ).code of
    HLN_CREATE_CONTROL :
        if Assigned( FOnCreateControl ) then
        begin
            FOnCreateControl( self, PNMHL_CREATE_CONTROL( lParam ) );
        end;
    HLN_LOAD_DATA:
        if Assigned( FOnLoadData ) then
        begin
            Result := FOnLoadData( self, PNMHL_LOAD_DATA( lParam ) );
        end;
    HLN_CONTROL_CREATED :
        if Assigned( FOnControlCreated ) then
        begin
            FOnControlCreated( self );
        end;
    HLN_DATA_LOADED :
        if Assigned( FOnDataLoaded ) then
        begin
            FOnDataLoaded( self, PNMHL_DATA_LOADED( lParam ) );
        end;
    HLN_DOCUMENT_COMPLETE :
        if Assigned( FOnDocumentComplete ) then
        begin
            FOnDocumentComplete( self );
        end;
    HLN_UPDATE_UI :
        if Assigned( FOnUpdateUI ) then
        begin
            FOnUpdateUI( self );
        end;
    HLN_DESTROY_CONTROL :
        if Assigned( FOnDestroyControl ) then
        begin
            FOnDestroyControl( self, PNMHL_DESTROY_CONTROL( lParam ) );
        end;
    HLN_ATTACH_BEHAVIOR :
        if Assigned( FOnAttachBehavior ) then
        begin
            FOnAttachBehavior( self, PNMHL_ATTACH_BEHAVIOR( lParam ) );
        end;
    HLN_BEHAVIOR_CHANGED :
        if Assigned( FOnBehaviorChanged ) then
        begin
            FOnBehaviorChanged( self, PNMHL_BEHAVIOR_CHANGED( lParam ) );
        end;
    HLN_DIALOG_CREATED :
        if Assigned( FOnDialogCreated ) then
        begin
            FOnDialogCreated( self );
        end;
    HLN_DIALOG_CLOSE_RQ :
        if Assigned( FOnDialogCloseRequest ) then
        begin
            FOnDialogCloseRequest( self, PNMHL_DIALOG_CLOSE_RQ( lParam ) );
        end;
    HLN_DOCUMENT_LOADED :
        if Assigned( FOnDocumentLoaded ) then
        begin
            FOnDocumentLoaded( self );
        end;
    end;
end;

{*******************************************************************************
* GetRootElement
*******************************************************************************}
function THtmlControl.GetRootElement() : HELEMENT;
begin
    HTMLayoutGetRootElement( Handle, Result );
end;

{*******************************************************************************
* getWideHtml
*******************************************************************************}
function THtmlControl.getWideHtml() : widestring;
begin
    Result := 'THtmlControl.getWideHtml: Implement me, please!';
end;

{*******************************************************************************
* setWideHtml
*******************************************************************************}
procedure THtmlControl.setWideHtml( const aHtml : widestring );
begin
    LoadHtml( 'THtmlControl.setWideHtml: Implement me, please!' );
end;

{*******************************************************************************
* getUtf8Html
*******************************************************************************}
function THtmlControl.getAnsiHtml() : string;
var
    bytes : PCHAR;
    res   : HLDOM_RESULT;
begin
    res := HTMLayoutGetElementHtml( root, bytes, false );
    assert( res = HLDOM_OK );

    Result := THtmlElement.cleanHtml( bytes );
end;

{*******************************************************************************
* setUtf8Html
*******************************************************************************}
procedure THtmlControl.setAnsiHtml( const aHtml : string );
begin
    LoadHtml( aHtml );
end;

{*******************************************************************************
* LoadHtml
*******************************************************************************}
function THtmlControl.LoadHtml( const aHtml : string ) : boolean;
begin
    Result := LoadHtml( PCHAR( aHtml ), Length( aHtml ) );
end;

{*******************************************************************************
* LoadHtmlEx
*******************************************************************************}
function THtmlControl.LoadHtmlEx( aHtml : string; aBaseUrl : widestring ) : boolean;
begin
    Result := LoadHtmlEx( PCHAR( aHtml ), Length( aHtml ), aBaseUrl );
end;

{*******************************************************************************
* LoadHtmlEx
*******************************************************************************}
function THtmlControl.LoadHtmlEx( aHtml : widestring; aBaseUrl : widestring ) : boolean;
begin
    Result := LoadHtmlEx( PCHAR( Pointer( @aHtml[1] ) ), Length( aHtml ), aBaseUrl );
end;

{*******************************************************************************
*
*******************************************************************************}
function THtmlControl.SetMasterCSS( aUtf8CSS : string ) : boolean;
begin
    Result := SetMasterCSS( PCHAR( aUtf8CSS ), Length( aUtf8CSS ) );
end;

{*******************************************************************************
*
*******************************************************************************}
function THtmlControl.AppendMasterCSS( aUtf8CSS : string ) : boolean;
begin
    Result := AppendMasterCSS( PCHAR( aUtf8CSS ), Length( aUtf8CSS ) );
end;

{*******************************************************************************
* SetHttpHeaders
*******************************************************************************}
function THtmlControl.SetHttpHeaders( aHttpHeaders : string ) : boolean;
begin
    Result := SetHttpHeaders( PCHAR( aHttpHeaders ), Length( aHttpHeaders ) );
end;

{*******************************************************************************
* SetCSS
*******************************************************************************}
function THtmlControl.SetCSS( aUtf8CSS : string; aBaseUrl : PWideChar; aMediaType : PWideChar ) : boolean;
begin
    Result := SetCSS( PCHAR( aUtf8CSS ), Length( aUtf8CSS ), aBaseUrl, aMediaType );
end;

{*******************************************************************************
* LoadHtml
*******************************************************************************}
function THtmlControl.LoadHtml( const aHtml : widestring ) : boolean;
begin
    Result := LoadHtml( PCHAR( Pointer( @aHtml[1] ) ), Length( aHtml ) );
end;

{*******************************************************************************
* DataReady
*******************************************************************************}
function THtmlControl.DataReady( aUri : PWideChar; aData : Pointer; aDataLength : cardinal ) : boolean;
begin
    Result := HTMLayoutDataReady( Handle, aUri, aData, aDataLength );
end;

{*******************************************************************************
* DataReadyAsync
*******************************************************************************}
function THtmlControl.DataReadyAsync( aUri : PWideChar; aData : Pointer; aDataLength : cardinal; aDataType : HTMLayoutResourceType ) : boolean;
begin
    Result := HTMLayoutDataReadyAsync( Handle, aUri, aData, aDataLength, UINT( aDataType ) );
end;

{*******************************************************************************
* GetMinWidth
*******************************************************************************}
function THtmlControl.GetMinWidth() : cardinal;
begin
    Result := HTMLayoutGetMinWidth( Handle );
end;

{*******************************************************************************
* GetMinHeight
*******************************************************************************}
function THtmlControl.GetMinHeight( aWidth : cardinal ) : cardinal;
begin
    Result := HTMLayoutGetMinHeight( Handle, aWidth );
end;

{*******************************************************************************
* LoadHtml
*******************************************************************************}
function THtmlControl.LoadHtml( aHtml : PCHAR; aHtmlSize : cardinal ): boolean;
begin
    Result := HTMLayoutLoadHtml( Handle, aHtml, aHtmlSize );
end;

{*******************************************************************************
* LoadFile
*******************************************************************************}
function THtmlControl.LoadFile( const aFileName : widestring ) : boolean;
begin
    Result := HTMLayoutLoadFile( Handle, PWideChar( aFileName ) );
end;

{*******************************************************************************
* LoadHtmlEx
*******************************************************************************}
function THtmlControl.LoadHtmlEx( aHtml : PCHAR; aHtmlSize : cardinal; aBaseUrl : widestring ) : boolean;
begin
    Result := HTMLayoutLoadHtmlEx( Handle, aHtml, aHtmlSize, PWideChar( aBaseUrl ) );
end;

{*******************************************************************************
* SetMode
*******************************************************************************}
procedure THtmlControl.SetMode( aHTMLayoutMode : HTMLayoutModes );
begin
    HTMLayoutSetMode( Handle, integer( aHTMLayoutMode ) );
end;

{*******************************************************************************
* SetCallback
*******************************************************************************}
procedure THtmlControl.SetCallback( aCallback : HTMLayoutNotify; aCallbackParam : Pointer );
begin
    HTMLayoutSetCallback( Handle, aCallback, aCallbackParam );
end;

{*******************************************************************************
* SelectionExist
*******************************************************************************}
function THtmlControl.SelectionExist() : boolean;
begin
    Result := HTMLayoutSelectionExist( Handle );
end;

{*******************************************************************************
* GetSelectedHTML
*******************************************************************************}
function THtmlControl.GetSelectedHTML( var aSize : cardinal ) : PCHAR;
begin
    Result := HTMLayoutGetSelectedHTML( Handle, aSize );
end;

{*******************************************************************************
* ClipboardCopy
*******************************************************************************}
function THtmlControl.ClipboardCopy() : boolean;
begin
    Result := HTMLayoutClipboardCopy( Handle );
end;

{*******************************************************************************
* EnumResources
*******************************************************************************}
function THtmlControl.EnumResources( aCallback : HTMLAYOUT_CALLBACK_RES ) : cardinal;
begin
    Result := HTMLayoutEnumResources( Handle, aCallback );
end;

{*******************************************************************************
* EnumResourcesEx
*******************************************************************************}
function THtmlControl.EnumResourcesEx( aCallback : HTMLAYOUT_CALLBACK_RES_EX; aCallbackParam : Pointer ) : cardinal;
begin
    Result := HTMLayoutEnumResourcesEx( Handle, aCallback, aCallbackParam );
end;

{*******************************************************************************
* SetMasterCSS
*******************************************************************************}
function THtmlControl.SetMasterCSS( aUtf8CSS : PCHAR; aCSSLength : cardinal ) : boolean;
begin
    Result := HTMLayoutSetMasterCSS( aUtf8CSS, aCSSLength );
end;

{*******************************************************************************
* AppendMasterCSS
*******************************************************************************}
function THtmlControl.AppendMasterCSS( aUtf8CSS : PCHAR; aCSSLength : cardinal ) : boolean;
begin
    Result := HTMLayoutAppendMasterCSS( aUtf8CSS, aCSSLength );
end;

{*******************************************************************************
* SetDataLoader
*******************************************************************************}
function THtmlControl.SetDataLoader( aDataLoader : HTMLAYOUT_DATA_LOADER ) : boolean;
begin
    Result := HTMLayoutSetDataLoader( aDataLoader );
end;

{*******************************************************************************
* DeclareElementType
*******************************************************************************}
function THtmlControl.DeclareElementType( aName : PCHAR; aElementModel : HTMLayoutElementModel ) : boolean;
begin
    Result := HTMLayoutDeclareElementType( aName, UINT( aElementModel ) );
end;

{*******************************************************************************
* SetCSS
*******************************************************************************}
function THtmlControl.SetCSS( aUtf8CSS : PCHAR; aCSSLength : cardinal; aBaseUrl : PWideChar; aMediaType : PWideChar ) : boolean;
begin
    Result := HTMLayoutSetCSS( Handle, aUtf8CSS, aCSSLength, aBaseUrl, aMediaType );
end;

{*******************************************************************************
* SetMediaType
*******************************************************************************}
function THtmlControl.SetMediaType( aMediaType : PWideChar ) : boolean;
begin
    Result := HTMLayoutSetMediaType( Handle, aMediaType );
end;

{*******************************************************************************
* SetMediaVars
*******************************************************************************}
function THtmlControl.SetMediaVars( const aMediaVars : PHtmlVALUE ) : boolean;
begin
    Result := HTMLayoutSetMediaVars( Handle, aMediaVars );
end;

{*******************************************************************************
* SetHttpHeaders
*******************************************************************************}
function THtmlControl.SetHttpHeaders( aHttpHeaders : PCHAR; aHttpHeadersLength : cardinal ) : boolean;
begin
    Result := HTMLayoutSetHttpHeaders( Handle, aHttpHeaders, aHttpHeadersLength );
end;

{*******************************************************************************
* SetOption
*******************************************************************************}
function THtmlControl.SetOption( aOption : HTMLayoutOptions; aValue : cardinal ) : boolean;
begin
    Result := HTMLayoutSetOption( Handle, UINT( aOption ), aValue );
end;

{*******************************************************************************
* Render
*******************************************************************************}
function THtmlControl.Render( aHBmp : HBITMAP; aArea : TRECT ) : boolean;
begin
    Result := HTMLayoutRender( Handle, aHBmp, aArea );
end;

{*******************************************************************************
* UpdateWindow
*******************************************************************************}
function THtmlControl.UpdateWindow() : boolean;
begin
    Result := HTMLayoutUpdateWindow( Handle );
end;

{*******************************************************************************
* CommitUpdates
*******************************************************************************}
function THtmlControl.CommitUpdates() : boolean;
begin
    Result := HTMLayoutCommitUpdates( Handle );
end;

{*******************************************************************************
* UrlEscape
*******************************************************************************}
function THtmlControl.UrlEscape( aText : PWideChar; aSpaceToPlus : boolean; aBuffer : PCHAR; aBufferLength : cardinal ) : cardinal;
begin
    Result := HTMLayoutUrlEscape( aText, aSpaceToPlus, aBuffer, aBufferLength );
end;

{*******************************************************************************
* UrlUnescape
*******************************************************************************}
function THtmlControl.UrlUnescape( aUrl : PChar; aBuffer : PWideChar; aBufferLength : cardinal ) : cardinal;
begin
    Result := HTMLayoutUrlUnescape( aUrl, aBuffer, aBufferLength );
end;

{*******************************************************************************
* Dialog
*******************************************************************************}
function THtmlControl.Dialog( aPosition : TPoint; aAlignment : integer; aStyle : cardinal; aStyleEx : cardinal; aDialogCallback : HTMLayoutNotify;
                        aElCallback : HTMLayoutElementEventProc; aCallbackParam : Pointer; aHtml : PCHAR; aHtmlLength : cardinal ) : integer;
begin
    Result := HTMLayoutDialog( Handle, aPosition, aAlignment, aStyle, aStyleEx, aDialogCallback, aElCallback, aCallbackParam, aHtml, aHtmlLength );
end;

{*******************************************************************************
* SetupDebugOutput
*******************************************************************************}
procedure THtmlControl.SetupDebugOutput( aParam : Pointer; aPFOutput : HTMLAYOUT_DEBUG_OUTPUT_PROC );
begin
    HTMLayoutSetupDebugOutput( aParam, aPFOutput );
end;

end.
