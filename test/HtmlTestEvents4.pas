unit HtmlTestEvents4;

interface

uses classes, sysutils, forms, Controls, types, windows
    , HtmlCtrl
    , HtmlElement
    , HtmlTypes
    , HtmlBehaviour
;

type

    {***************************************************************************
    * TEventsTester
    ***************************************************************************}
    TEventsTester = class

private
    function    onInitialization( const aSender : THtmlElement; const aParams : PHTMLayoutInitializationParams; aTag : Pointer ) : boolean;
    function    onMouseMove( const aSender : THtmlElement; const aParams : PHTMLayoutMouseParams; aTag : Pointer ) : boolean;
    function    onMouseClick( const aSender : THtmlElement; const aParams : PHTMLayoutMouseParams; aTag : Pointer ) : boolean;

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
    elTest   : THtmlElement;
    elDetach : THtmlElement;

    tester   : TEventsTester;

{*******************************************************************************
* onInitialization
*******************************************************************************}
function TEventsTester.onInitialization( const aSender : THtmlElement; const aParams : PHTMLayoutInitializationParams; aTag : Pointer ) : boolean;
var
    msg : string;
begin
    Result := false;
    
    case aParams.cmd of
    BEHAVIOR_ATTACH :
        msg := 'BEHAVIOR_ATTACH';
    BEHAVIOR_DETACH :
        msg := 'BEHAVIOR_DETACH';
    end;

    msg := msg + ' el:' + aSender.tag + '.' + aSender.id;

    elEvents.innerHtml := msg + '<br/>' + elEvents.innerHtml;
end;

{*******************************************************************************
* onMouseMove
*******************************************************************************}
function TEventsTester.onMouseMove( const aSender : THtmlElement; const aParams : PHTMLayoutMouseParams; aTag : Pointer ) : boolean;
var
    msg  : string;
    //id   : string;
    //h    : HELEMENT;
    p    : string;
    t    : string;

begin
    Result := false;

    msg := 'MOUSE_MOVE';
    p := 'pt:(' + IntToStr( aParams.pos.x ) + ',' + IntToStr( aParams.pos.y ) + ')';

    t := ' ' + IntToStr( UINT( aParams.target ) ) ;
    if ( THtmlShim.get( aParams.target ).is_valid() ) then
        t := t + '.' + THtmlShim.get( aParams.target ).id;

    if ( p <> '' ) then
        p := ' ' + p;

    elEvents.innerHtml := msg + ', tag: ' + IntToStr( UINT( aTag ) ) + t + p + '<br/>' + elEvents.innerHtml;
end;

{*******************************************************************************
* onMouseClick
*******************************************************************************}
function TEventsTester.onMouseClick( const aSender : THtmlElement; const aParams : PHTMLayoutMouseParams; aTag : Pointer ) : boolean;
begin
    Result := false;

    elEvents.innerHtml := 'Removing onMouseMove from ' + aSender.tag + ' element<br/>' + elEvents.innerHtml;
    elTest.detach( onMouseMove, MOUSE_MOVE, Pointer( 123 ), HANDLE_MOUSE );
    //elTest.attach( onMouseMove, MOUSE_MOVE, Pointer( 890 ), HANDLE_MOUSE );
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
    body := body + '<div id="test" style="height:50px;width:400px;border: 1px solid red;">MOUSE EVENTS TEST AREA';
    body := body + '</div>';
    body := body + '<div id="detach" style="width:400px;border: 1px solid blue;margin:10px;">Click to Detach onMouseMove 123</div>';
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

    elTest := elBody.get_element_by_id( 'test' );
    assert( elTest <> nil );

    elDetach := elBody.get_element_by_id( 'detach' );
    assert( elDetach <> nil );

//-------------------------- BEHAVIOUR TESTING ---------------------------------

    //elBody.onInitialization := tester.onInitialization;
    //elBody.attach( tester.onMouseMove, MOUSE_MOVE, Pointer( 123 ) );

    elTest.onInitialization := tester.onInitialization;
    elTest.attach( tester.onMouseMove, MOUSE_MOVE, Pointer( 1 ) );
    elTest.attach( tester.onMouseClick, MOUSE_CLICK, Pointer( 2 ) );

    elDetach.onMouseClick := tester.onMouseClick;

FINALIZATION
    elBody.unuse();
    elRoot.unuse();
    FreeAndNil( tester );

end.
