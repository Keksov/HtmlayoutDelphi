unit HtmlTestEvents3;

interface

uses classes, sysutils, forms, Controls, types, windows
    , HtmlCtrl
    , HtmlDOM
    , HtmlTypes
    , HtmlCommon
    , HtmlBehaviour
;

type

    {***************************************************************************
    * TEventsTester
    ***************************************************************************}
    TEventsTester = class

private
    function    onMove( const aSender : THtmlElement; const aParams : PHTMLayoutMouseParams; aTag : Pointer ) : boolean;

//    function    OnKeyEvent( const aSender : THtmlElement; const aHandler : HELEMENT; const aParams : PHTMLayoutKeyParams ) : boolean;
//    function    OnFocusEvent( const aSender : THtmlElement; const aHandler : HELEMENT; const aParams : PHTMLayoutFocusParams ) : boolean;

    end;

implementation

var
    frm      : TForm;
    html     : THtmlControl;
    s        : string;
    head     : string;
    body     : string;

    elRoot   : THtmlElement;
    elBody   : THtmlElement;
    elEvents : THtmlElement;
    //elTest   : THtmlElement;

    tester   : TEventsTester;

{*******************************************************************************
* onMove
*******************************************************************************}
function TEventsTester.onMove( const aSender : THtmlElement; const aParams : PHTMLayoutMouseParams; aTag : Pointer ) : boolean;
var
    msg  : string;
    id   : string;
    h    : HELEMENT;
    p    : string;
    t    : string;

begin
    Result := false;

    msg := 'MOUSE_MOVE';
    p := 'pt:(' + IntToStr( aParams.pos.x ) + ',' + IntToStr( aParams.pos.y ) + ')';
    h := nil;

    t := ' ' + IntToStr( UINT( aParams.target ) ) ;
    if ( THtmlShim.get( aParams.target ).is_valid() ) then
        t := t + '.' + THtmlShim.get( aParams.target ).id;

    if ( p <> '' ) then
        p := ' ' + p;

    elEvents.innerHtml := msg + ', t: ' + IntToStr( UINT( h ) ) + '.' + id + t + p + '<br/>' + elEvents.innerHtml;
end;


INITIALIZATION

    frm := TForm.Create( nil );
    frm.Width    := 640;
    frm.Height   := 480;
    frm.Visible  := true;
    //frm.Position := poScreenCenter;

//    elTmp := nil;

    html := THtmlControl.Create( frm );
    html.Parent := frm;
    html.Align  := alClient;
    html.Visible := true;

    head := '<meta http-equiv="Content-Type" content="text/html; charset=utf-8">';
    body := '<div id="ok">OK</div>';
    body := body + '<div id="test" style="height:50px;width:400px;border: 1px solid red;">';
    body := body + '<form id="form"><input type="text" id="editText"></input></form>';
    body := body + '<div id="sub" style="width:400px;border: 1px solid blue;">sub item</div>';
    body := body + '</div>';
    body := body + '<div id="events" style="height:50px;width:600x;border: 1px dotted green;">Events tracker</div>';
    s := '<html><head id="head">' + head + '</head><body id="body">' + body + '</body></html>';

    html.html := s;

    elRoot := THtmlElement.Create( html.root );
    assert( elRoot.index = 0 );
    assert( elRoot.innerHtml <> '' );
    assert( elRoot.childrenCount = 2 );
    assert( elRoot.tag = 'html' );

    elBody := elRoot.child[1];
    assert( elBody <> nil );
    assert( elBody.tag = 'body' );

    elEvents := elBody.get_element_by_id( 'events' );

    tester := TEventsTester.Create();

    //elTest := elBody.get_element_by_id( 'test' );

//-------------------------- BEHAVIOUR TESTING ---------------------------------

    elBody.onMouseMove := tester.onMove;

FINALIZATION
    FreeAndNil( elBody );
    FreeAndNil( elRoot );
    FreeAndNil( tester );

end.
