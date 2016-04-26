unit HtmlCtrl;

(*
  HTMLayout License terms could be found here http://www.terrainformatica.com/htmlayout/prices.whtm
  SDK - http://www.terrainformatica.com/htmlayout/HTMLayoutSDK.zip

  Delphi binding of HTMLayout published under LGPL. Visit https://github.com/Keksov/HtmlayoutDelphi

  This file contains object wrapper for functions from include\htmlayout.h
  Most accurate documentation could be found in include\htmlayout.h by itself
*)

interface

{$IFDEF USER_DEFINES_INC}{$I user_defines.inc}{$ENDIF}

uses Windows, Messages, SysUtils, Classes, Controls
    , HtmlTypes
    , HtmlLayoutH
    , HtmlLayoutDomH
    , HtmlBehaviorH
    , HtmlValueH
    , HtmlElement
    , htmlNode
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
    FdomEvents                     : THTMLayoutEvent;

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

    FshowSelection              : boolean; // default false, see HTMLayoutModes (HtmlLayoutH.pas)

private
    function    HtmlCallback( uMsg : UINT; wParam : WPARAM; lParam : LPARAM ) : LRESULT;

    function    getWideHtml() : widestring;
    procedure   setWideHtml( const aHtml : widestring );
    function    getAnsiHtml() : string;
    procedure   setAnsiHtml( const aHtml : string );

protected
    procedure   CreateParams( var Params : TCreateParams ); override;
    procedure   WndProc( var Message : TMessage ); override;

    function    doOnCreateControl( lParam : PNMHL_CREATE_CONTROL ) : LRESULT; virtual;
    function    doOnLoadData( lParam : PNMHL_LOAD_DATA ) : LRESULT; virtual;
    procedure   doOnControlCreated(); virtual;
    function    doOnDataLoaded( lParam : PNMHL_DATA_LOADED ) : LRESULT; virtual;
    procedure   doOnDocumentComplete(); virtual;
    procedure   doOnUpdateUI(); virtual;
    function    doOnDestroyControl( lParam : PNMHL_DESTROY_CONTROL ) : LRESULT; virtual;
    function    doOnAttachBehavior( lParam : PNMHL_ATTACH_BEHAVIOR ) : LRESULT; virtual;
    function    doOnBehaviorChanged( lParam : PNMHL_BEHAVIOR_CHANGED ) : LRESULT; virtual;
    function    doOnDialogCreated() : LRESULT; virtual;
    function    doOnDialogCloseRequest( lParam : PNMHL_DIALOG_CLOSE_RQ ) : LRESULT; virtual;
    function    doOnDocumentLoaded() : LRESULT; virtual;

public
    constructor Create( AOwner : TComponent ); override;
    destructor  Destroy(); override;

    function    LoadHtml( const aHtml : string ) : boolean; overload;
    function    LoadHtml( const aHtml : widestring ) : boolean; overload;
    function    LoadHtmlEx( aHtml : string; aBaseUrl : widestring ) : boolean; overload;
    function    LoadHtmlEx( aHtml : widestring; aBaseUrl : widestring ) : boolean; overload;
class function  SetMasterCSS( aUtf8CSS : string ) : boolean; overload;
class function  AppendMasterCSS( aUtf8CSS : string ) : boolean; overload;
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
class function  SetMasterCSS( aUtf8CSS : PCHAR; aCSSLength : cardinal ) : boolean; overload;
class function  AppendMasterCSS( aUtf8CSS : PCHAR; aCSSLength : cardinal ) : boolean; overload;
class function  SetDataLoader( aDataLoader : HTMLAYOUT_DATA_LOADER ) : boolean;
class function  DeclareElementType( aName : PCHAR; aElementModel : HTMLayoutElementModel ) : boolean;
    function    SetCSS( aUtf8CSS : PCHAR; aCSSLength : cardinal; aBaseUrl : PWideChar; aMediaType : PWideChar ) : boolean; overload;
    function    SetMediaType( aMediaType : PWideChar ) : boolean;
    function    SetMediaVars( const aMediaVars : PRHtmlValue ) : boolean;
    function    SetHttpHeaders( aHttpHeaders : PCHAR; aHttpHeadersLength : cardinal ) : boolean; overload;
    function    SetOption( aOption : HTMLayoutOptions; aValue : cardinal ) : boolean;
    function    Render( aHBmp : HBITMAP; aDstRect : TRECT ) : boolean;
    function    UpdateWindow() : boolean;
    function    CommitUpdates() : boolean;
class function  UrlEscape( aText : PWideChar; aSpaceToPlus : boolean; aBuffer : PCHAR; aBufferLength : cardinal ) : cardinal;
class function  UrlUnescape( aUrl : PChar; aBuffer : PWideChar; aBufferLength : cardinal ) : cardinal;
    function    Dialog( aPosition : TPoint; aAlignment : integer; aStyle : cardinal; aStyleEx : cardinal; aDialogCallback : HTMLayoutNotify;
                        aElCallback : HTMLayoutElementEventProc; aCallbackParam : Pointer; aHtml : PCHAR; aHtmlLength : cardinal ) : INT_PTR;
    procedure   SetupDebugOutput( aParam : Pointer; aPFOutput : HTMLAYOUT_DEBUG_OUTPUT_PROC );

public // property
    property ansiHtml : string read getAnsiHtml write setAnsiHtml;
    property wideHtml : widestring read getWideHtml write setWideHtml;

    property html : string read getAnsiHtml write setAnsiHtml;
    property hroot : HELEMENT read GetRootElement;
    property showSelection : boolean read FshowSelection write FshowSelection;
    property domEvents : THTMLayoutEvent read FdomEvents;

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

    {***************************************************************************
    * THtmlDOMControl
    ***************************************************************************}
    THtmlDOMControl = class( THtmlControl )
protected
    Fdom                        : THtmlElement;

protected
    procedure   doOnDocumentComplete(); override;

public
    destructor  Destroy(); override;
    procedure   AfterConstruction(); override;

public // property
    property dom  : THtmlElement read Fdom;

    end;

    {***************************************************************************
    * THtmlDocumentControl
    ***************************************************************************}
    THtmlDocumentControl = class( THtmlDOMControl )
protected
    Fdoc                        : THTMLDocView;

protected
    procedure   doOnDocumentComplete(); override;

public
    destructor  Destroy(); override;
    procedure   AfterConstruction(); override;

    // apply html content from Fdoc to the control
    procedure   applyHtml(); virtual;

public // property
    property doc : THTMLDocView read Fdoc;

    end;

implementation

uses HtmlBehaviorSVG;

//uses HtmlTest; // Just for testing
//uses HtmlTestEvents2;

{----------------------------- THtmlDOMControl --------------------------------}

{*******************************************************************************
* AfterConstruction
*******************************************************************************}
procedure THtmlDOMControl.AfterConstruction();
begin
    Fdom := THtmlElement.Create();
end;

{*******************************************************************************
* Destroy
*******************************************************************************}
destructor THtmlDOMControl.Destroy();
begin
    Fdom.unuse();
    inherited;
end;

{*******************************************************************************
* doOnDocumentComplete
*******************************************************************************}
procedure THtmlDOMControl.doOnDocumentComplete();
begin
    Fdom.handler := hroot;
    inherited;
end;

{----------------------------- THtmlControl -----------------------------------}

{*******************************************************************************
* Create
*******************************************************************************}
constructor THtmlControl.Create( AOwner : TComponent );
begin
    inherited Create( AOwner );

    FdomEvents := THTMLayoutEvent.Create();
    FshowSelection := false;
end;

{*******************************************************************************
* Destroy
*******************************************************************************}
destructor THtmlControl.Destroy();
begin
    FreeAndNil( FdomEvents );
    inherited;
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
    //try
        res := HTMLayoutProcND( Handle, Message.Msg, Message.WParam, Message.LParam, Handled );
        if Handled then
        begin
            Message.Result := res;
            exit;
        end;

        case Message.Msg of
        WM_CREATE:
            SetCallback( HtmlCallbackProxy, self );

        end;

        inherited WndProc( Message );
    {except
        on e : Exception do
        begin
            if ( e <> nil ) then if ( e <> nil ) then;
            if ( Message.Msg <> 0 ) then if ( Message.Msg <> 0 ) then;
        end;
    end;}
end;

{*******************************************************************************
* doOnCreateControl
*******************************************************************************}
function THtmlControl.doOnCreateControl( lParam : PNMHL_CREATE_CONTROL ) : LRESULT;
begin
    Result := 0;
    if Assigned( FOnCreateControl ) then
    begin
        Result := FOnCreateControl( self, lParam );
    end;
end;

{*******************************************************************************
* doOnLoadData
*******************************************************************************}
function THtmlControl.doOnLoadData( lParam : PNMHL_LOAD_DATA ) : LRESULT;
begin
    Result := 0;
    if Assigned( FOnLoadData ) then
    begin
        Result := FOnLoadData( self, lParam );
    end;
end;

{*******************************************************************************
* doOnControlCreated
*******************************************************************************}
procedure THtmlControl.doOnControlCreated();
begin
    if Assigned( FOnControlCreated ) then
    begin
        FOnControlCreated( self );
    end;
end;

{*******************************************************************************
* doOnDataLoaded
*******************************************************************************}
function THtmlControl.doOnDataLoaded( lParam : PNMHL_DATA_LOADED ) : LRESULT;
begin
    Result := 0;
    if Assigned( FOnDataLoaded ) then
    begin
        Result := FOnDataLoaded( self, lParam );
    end;
end;

{*******************************************************************************
* doOnDocumentComplete
*******************************************************************************}
procedure THtmlControl.doOnDocumentComplete();
begin
    if ( FshowSelection ) then
    begin
        SetMode( HLM_SHOW_SELECTION );
    end;

    if Assigned( FOnDocumentComplete ) then
    begin
        FOnDocumentComplete( self );
    end;

    FdomEvents.attach( hroot );
end;

{*******************************************************************************
* doOnUpdateUI
*******************************************************************************}
procedure THtmlControl.doOnUpdateUI();
begin
    if Assigned( FOnUpdateUI ) then
    begin
        FOnUpdateUI( self );
    end;
end;

{*******************************************************************************
* doOnDestroyControl
*******************************************************************************}
function THtmlControl.doOnDestroyControl( lParam : PNMHL_DESTROY_CONTROL ) : LRESULT;
begin
    Result := 0;
    if Assigned( FOnDestroyControl ) then
    begin
        FOnDestroyControl( self, lParam );
    end;
end;

{*******************************************************************************
* doOnAttachBehavior
*******************************************************************************}
function THtmlControl.doOnAttachBehavior( lParam : PNMHL_ATTACH_BEHAVIOR ) : LRESULT;
begin
    THtmlBehaviorSVG.behaviorAttach( lParam );

    Result := 0;
    if Assigned( FOnAttachBehavior ) then
    begin
        Result := FOnAttachBehavior( self, lParam );
    end;
end;

{*******************************************************************************
* doOnBehaviorChanged
*******************************************************************************}
function THtmlControl.doOnBehaviorChanged( lParam : PNMHL_BEHAVIOR_CHANGED ) : LRESULT;
begin
    Result := 0;
    if Assigned( FOnBehaviorChanged ) then
    begin
        Result := FOnBehaviorChanged( self, lParam );
    end;
end;

{*******************************************************************************
* doOnDialogCreated
*******************************************************************************}
function THtmlControl.doOnDialogCreated() : LRESULT;
begin
    Result := 0;
    if Assigned( FOnDialogCreated ) then
    begin
        FOnDialogCreated( self );
    end;
end;

{*******************************************************************************
* doOnDialogCloseRequest
*******************************************************************************}
function THtmlControl.doOnDialogCloseRequest( lParam : PNMHL_DIALOG_CLOSE_RQ ) : LRESULT;
begin
    Result := 0;
    if Assigned( FOnDialogCloseRequest ) then
    begin
        FOnDialogCloseRequest( self, lParam );
    end;
end;

{*******************************************************************************
* doOnDocumentLoaded
*******************************************************************************}
function THtmlControl.doOnDocumentLoaded() : LRESULT;
begin
    Result := 0;
    if Assigned( FOnDocumentLoaded ) then
    begin
        FOnDocumentLoaded( self );
    end;
end;

{*******************************************************************************
* HtmlCallback
*******************************************************************************}
function THtmlControl.HtmlCallback( uMsg: UINT; wParam : WPARAM; lParam : LPARAM ) : LRESULT;
begin
    Result := 0;

    case PNMHDR( lParam ).code of
    HLN_CREATE_CONTROL :
        Result := doOnCreateControl( PNMHL_CREATE_CONTROL( lParam ) );
    HLN_LOAD_DATA:
        Result := doOnLoadData( PNMHL_LOAD_DATA( lParam ) );
    HLN_CONTROL_CREATED :
        doOnControlCreated();
    HLN_DATA_LOADED :
        Result := doOnDataLoaded( PNMHL_DATA_LOADED( lParam ) );
    HLN_DOCUMENT_COMPLETE :
        doOnDocumentComplete();
    HLN_UPDATE_UI :
        doOnUpdateUI();
    HLN_DESTROY_CONTROL :
        Result := doOnDestroyControl( PNMHL_DESTROY_CONTROL( lParam ) );
    HLN_ATTACH_BEHAVIOR :
        Result := doOnAttachBehavior( PNMHL_ATTACH_BEHAVIOR( lParam ) );
    HLN_BEHAVIOR_CHANGED :
        Result := doOnBehaviorChanged( PNMHL_BEHAVIOR_CHANGED( lParam ) );
    HLN_DIALOG_CREATED :
        Result := doOnDialogCreated();
    HLN_DIALOG_CLOSE_RQ :
        Result := doOnDialogCloseRequest( PNMHL_DIALOG_CLOSE_RQ( lParam ) );
    HLN_DOCUMENT_LOADED :
        Result := doOnDocumentLoaded();
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
    res := HTMLayoutGetElementHtml( hroot, bytes, false );
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
* SetMasterCSS
*******************************************************************************}
class function THtmlControl.SetMasterCSS( aUtf8CSS : string ) : boolean;
begin
    Result := SetMasterCSS( PCHAR( aUtf8CSS ), Length( aUtf8CSS ) );
end;

{*******************************************************************************
* AppendMasterCSS
*******************************************************************************}
class function THtmlControl.AppendMasterCSS( aUtf8CSS : string ) : boolean;
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
class function THtmlControl.SetMasterCSS( aUtf8CSS : PCHAR; aCSSLength : cardinal ) : boolean;
begin
    Result := HTMLayoutSetMasterCSS( aUtf8CSS, aCSSLength );
end;

{*******************************************************************************
* AppendMasterCSS
*******************************************************************************}
class function THtmlControl.AppendMasterCSS( aUtf8CSS : PCHAR; aCSSLength : cardinal ) : boolean;
begin
    Result := HTMLayoutAppendMasterCSS( aUtf8CSS, aCSSLength );
end;

{*******************************************************************************
* SetDataLoader
*******************************************************************************}
class function THtmlControl.SetDataLoader( aDataLoader : HTMLAYOUT_DATA_LOADER ) : boolean;
begin
    Result := HTMLayoutSetDataLoader( aDataLoader );
end;

{*******************************************************************************
* DeclareElementType
*******************************************************************************}
class function THtmlControl.DeclareElementType( aName : PCHAR; aElementModel : HTMLayoutElementModel ) : boolean;
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
function THtmlControl.SetMediaVars( const aMediaVars : PRHtmlValue ) : boolean;
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
function THtmlControl.Render( aHBmp : HBITMAP; aDstRect : TRECT ) : boolean;
begin
    Result := HTMLayoutRender( Handle, aHBmp, aDstRect );
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
class function THtmlControl.UrlEscape( aText : PWideChar; aSpaceToPlus : boolean; aBuffer : PCHAR; aBufferLength : cardinal ) : cardinal;
begin
    Result := HTMLayoutUrlEscape( aText, aSpaceToPlus, aBuffer, aBufferLength );
end;

{*******************************************************************************
* UrlUnescape
*******************************************************************************}
class function THtmlControl.UrlUnescape( aUrl : PChar; aBuffer : PWideChar; aBufferLength : cardinal ) : cardinal;
begin
    Result := HTMLayoutUrlUnescape( aUrl, aBuffer, aBufferLength );
end;

{*******************************************************************************
* Dialog
*******************************************************************************}
function THtmlControl.Dialog( aPosition : TPoint; aAlignment : integer; aStyle : cardinal; aStyleEx : cardinal; aDialogCallback : HTMLayoutNotify;
                        aElCallback : HTMLayoutElementEventProc; aCallbackParam : Pointer; aHtml : PCHAR; aHtmlLength : cardinal ) : INT_PTR;
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

{-- THtmlDocumentControl ------------------------------------------------------}

{*******************************************************************************
* AfterConstruction
*******************************************************************************}
procedure THtmlDocumentControl.AfterConstruction();
begin
    inherited;

    Fdoc := THTMLDocView.Create();
end;

{*******************************************************************************
* Destroy
*******************************************************************************}
destructor THtmlDocumentControl.Destroy();
begin
    FreeAndNil( Fdoc );
    inherited;
end;

{*******************************************************************************
* doOnDocumentComplete
*******************************************************************************}
procedure THtmlDocumentControl.doOnDocumentComplete();
begin
    inherited;

    Fdoc.attachEvents( Fdom );
end;

{*******************************************************************************
* applyHtml
*******************************************************************************}
procedure THtmlDocumentControl.applyHtml();
begin
    //Fdoc.saveToFile( '1.html' );
    html := Fdoc.html;

    inherited;
end;

end.
