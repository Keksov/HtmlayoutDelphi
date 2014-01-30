unit HtmlCtrl;

interface

uses Windows, Messages, SysUtils, Classes, Controls
    , HtmlCommon
    , HtmlTypes
    , HtmlDll
    , HtmlDOM
;

// HTMLayout API documentation http://www.terrainformatica.com/htmlayout/doxydoc/index.html

type
    THtmlControl = class;

    THtmlLoadData = function( Sender : THtmlControl; Uri : PWideChar; element : HELEMENT ): LRESULT of Object;
    THtmlDocumentComplete = procedure( Sender : THtmlControl ) of Object;

    {***************************************************************************
    * THtmlControl
    ***************************************************************************}
    THtmlControl = class( TWinControl )
private
    FOnLoadData                 : THtmlLoadData;
    FOnDocumentComplete         : THtmlDocumentComplete;

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

    function    LoadHtml( pHtml : PByte; cb: Cardinal ) : boolean; overload;
    function    LoadFile( const aFileName : widestring ) : boolean; overload;
    function    LoadHtml( const aHtml : string ) : boolean; overload;
    function    LoadHtml( const aHtml : widestring ) : boolean; overload;

    function    GetRootElement() : HELEMENT;

    function    OnDataReady(uri: PWideChar; data: Pointer; length: Cardinal): Boolean;

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
    property OnLoadData: THtmlLoadData read FOnLoadData write FOnLoadData;
    property OnDocumentComplete: THtmlDocumentComplete read FOnDocumentComplete write FOnDocumentComplete;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
//    property OnMouseActivate;
    property OnMouseDown;
//    property OnMouseEnter;
//    property OnMouseLeave;
    property OnMouseMove;
    property OnMouseUp;
    property OnStartDock;
    property OnStartDrag;
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
* AHtmlCallbackProxy
*******************************************************************************}
function AHtmlCallbackProxy( uMsg: UINT; wParam: WPARAM; lParam: LPARAM; vParam: Pointer ): LRESULT; stdcall;
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
            HTMLayoutSetCallback( Handle, @AHtmlCallbackProxy, Self );
        end;
    end;

    inherited WndProc( Message );
end;

{*******************************************************************************
* HtmlCallback
*******************************************************************************}
function THtmlControl.HtmlCallback( uMsg: UINT; wParam : WPARAM; lParam : LPARAM ) : LRESULT;
var
    nmhdr: pNMHDR;
begin
    Result := 0;

    nmhdr := pNMHDR( lParam );

    case nmhdr^.code of
    HLN_LOAD_DATA:
        begin
            if Assigned( FOnLoadData ) then
                Result := FOnLoadData( Self, pNMHL_LOAD_DATA( lParam )^.uri, pNMHL_LOAD_DATA( lParam )^.principal )
            else
                Result := LOAD_OK;

            exit;
        end;
    HLN_DOCUMENT_COMPLETE:
        begin
            if Assigned( FOnLoadData ) then
            begin
                FOnDocumentComplete( Self );
            end;
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
    Result := LoadHtml( PByte( aHtml ), Length( aHtml ) );
end;

{*******************************************************************************
* LoadHtml
*******************************************************************************}
function THtmlControl.LoadHtml( const aHtml : widestring ) : boolean;
begin
    Result := LoadHtml( PByte( aHtml ), Length( aHtml ) );
end;

{*******************************************************************************
* LoadHtml
*******************************************************************************}
function THtmlControl.LoadHtml( pHtml : PByte; cb : Cardinal ): boolean;
begin
    Result := HTMLayoutLoadHtml(Handle, pHtml, cb);
end;

{*******************************************************************************
* LoadFile
*******************************************************************************}
function THtmlControl.LoadFile( const aFileName : widestring ) : boolean;
begin
    Result := HTMLayoutLoadFile( Handle, PWideChar( aFileName ) );
end;

{*******************************************************************************
* OnDataReady
*******************************************************************************}
function THtmlControl.OnDataReady(uri: PWideChar; data: Pointer; length: Cardinal): Boolean;
begin
    Result := HTMLayoutDataReady(Handle, uri, data, length);
end;

end.
