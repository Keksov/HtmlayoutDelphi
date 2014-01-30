unit HtmlTestMove;

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
    function    onMouseUp( const aSender : THtmlElement; const aParams : PHTMLayoutMouseParams; aTag : Pointer ) : boolean;
    function    onMouseMove( const aSender : THtmlElement; const aParams : PHTMLayoutMouseParams; aTag : Pointer ) : boolean;
    function    onMouseDown( const aSender : THtmlElement; const aParams : PHTMLayoutMouseParams; aTag : Pointer ) : boolean;
    function    onMouse( const aSender : THtmlElement; const aParams : PHTMLayoutMouseParams; aTag : Pointer ) : boolean;

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
    elContainer : THtmlElement;

    tester   : TEventsTester;

{*******************************************************************************
* onMouseDown
*******************************************************************************}
function TEventsTester.onMouseDown( const aSender : THtmlElement; const aParams : PHTMLayoutMouseParams; aTag : Pointer ) : boolean;
begin
    Result := false;
    aSender.attrAsInt[ 'move_x_start' ] := aParams.pos.x;
    aSender.attrAsInt[ 'move_y_start' ] := aParams.pos.y;
    //aSender.set_capture();
end;

{*******************************************************************************
* onMouseUp
*******************************************************************************}
function TEventsTester.onMouseUp( const aSender : THtmlElement; const aParams : PHTMLayoutMouseParams; aTag : Pointer ) : boolean;
begin
    Result := false;
    //aSender.release_capture();
end;

{*******************************************************************************
* onMouseMove
*******************************************************************************}
function TEventsTester.onMouseMove( const aSender : THtmlElement; const aParams : PHTMLayoutMouseParams; aTag : Pointer ) : boolean;
begin
    Result := false;
    if ( not THTMLayoutEvent.leftPressed( aParams ) ) then
        exit;

    aSender.left := aSender.left + aParams.pos.x - aSender.attrAsInt[ 'move_x_start' ];
    aSender.top  := aSender.top + aParams.pos.y - aSender.attrAsInt[ 'move_y_start' ];
end;

{*******************************************************************************
* onMouse
*******************************************************************************}
function TEventsTester.onMouse( const aSender : THtmlElement; const aParams : PHTMLayoutMouseParams; aTag : Pointer ) : boolean;
var
    cmd  : HTMLayoutMouseCmd;
    msg  : string;
    id   : string;
    h    : HELEMENT;
    p    : string;
    t    : string;

begin
    Result := false;

    cmd := THTMLayoutEvent.mouseCmd( aParams );
    p := '';
    h := nil;

    //if ( cmd.sinking ) then
    //    exit;

    case cmd.code of
    MOUSE_ENTER : // 0
        msg := 'MOUSE_ENTER';
    MOUSE_LEAVE : // 1
        msg := 'MOUSE_LEAVE';
    MOUSE_MOVE : // 2
        begin
            msg := 'MOUSE_MOVE';
            p := 'p: ' + IntToStr( aParams.pos.x ) + '.' + IntToStr( aParams.pos.y );
            exit;
        end;
    MOUSE_UP : // 3
        begin
            msg := 'MOUSE_UP';
            //Result := false;
            //THtmlShim.hl( aParams.target ).release_capture();
        end;
    MOUSE_DOWN : // 4
        begin
            msg := 'MOUSE_DOWN';
            //Result := false;
            //THtmlShim.hl( aParams.target ).set_capture();
        end;
    DRAGGING or MOUSE_ENTER : // 0
        msg := 'DRAGGING | MOUSE_ENTER';
    DRAGGING or MOUSE_LEAVE : // 1
        msg := 'DRAGGING |MOUSE_LEAVE';
    DRAGGING or MOUSE_MOVE : // 2
        begin
            msg := 'DRAGGING |MOUSE_MOVE';
            p := 'p: ' + IntToStr( aParams.pos.x ) + '.' + IntToStr( aParams.pos.y );
        end;
    DRAGGING or MOUSE_UP : // 3
        begin
            msg := 'DRAGGING |MOUSE_UP';
            //Result := false;
            //THtmlShim.hl( aParams.target ).release_capture();
        end;
    DRAGGING or MOUSE_DOWN : // 4
        begin
            msg := 'DRAGGING |MOUSE_DOWN';
            //Result := false;
            //THtmlShim.hl( aParams.target ).set_capture();
        end;

    MOUSE_DCLICK : // 5
        msg := 'MOUSE_DCLICK';
    MOUSE_WHEEL : // 6
        msg := 'MOUSE_WHEEL';
    MOUSE_TICK : // 7 mouse pressed ticks
        msg := 'MOUSE_TICK';
    MOUSE_IDLE : // 8 mouse stay idle for some time
        msg := 'MOUSE_IDLE';
    DROP : // 9 item dropped, target is that dropped item
        msg := 'DROP';
    DRAG_ENTER : // $A drag arrived to the target element that is one of current drop targets.
        msg := 'DRAG_ENTER';
    DRAG_LEAVE : // $B drag left one of current drop targets. target is the drop target element.
        msg := 'DRAG_LEAVE';
    DRAG_REQUEST : // $C drag src notification before drag start. To cancel - return true from handler.
        begin
            msg := 'DRAG_REQUEST';
            THtmlShim.get( aParams.target ).set_capture();
            //Result := false;
        end;
    MOUSE_CLICK : // $FF mouse click event
        msg := 'MOUSE_CLICK';
    else
        exit; //msg := 'MOUSE UNKNOWN: ' + IntToStr( cmd.code );
    end;

    t := ' ' + IntToStr( UINT( aParams.target ) ) ;
    if ( THtmlShim.get( aParams.target ).is_valid() ) then
        t := t + '.' + THtmlShim.get( aParams.target ).id;

    if ( cmd.sinking ) then
        msg := 's ' + msg;

    if ( cmd.handled ) then
        msg := 'h ' + msg;

    if ( cmd.bubbling ) then
        msg := 'b ' + msg;

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
    //body := body + '<div id="container" style="height:150px;width:500px;border: 1px solid green;accept-drag:selector(#test)">';
    //body := body + '<div id="test" style="height:50px;width:400px;border: 1px solid red;draggable:only-move;">Click me and drag around.';
    body := body + '<div id="container" style="height:150px;width:500px;border: 1px solid green;">';
    body := body + '<div id="test" style="position:absolute;height:50px;width:400px;border: 1px solid red;">Click me and drag around.';
    body := body + '</div>';
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

    elTest := elBody.get_element_by_id( 'test' );
    assert( elTest <> nil );

    elEvents := elBody.get_element_by_id( 'events' );
    assert( elEvents <> nil );

    elContainer := elBody.get_element_by_id( 'container' );
    assert( elContainer <> nil );

    tester := TEventsTester.Create();

//-------------------------- BEHAVIOUR TESTING ---------------------------------

    elTest.onMouseDown := tester.onMouseDown;
    elTest.onMouseMove := tester.onMouseMove;
//    elTest.attach( tester.onMouseMove, MOUSE_MOVE or );
    elTest.onMouseUp := tester.onMouseUp;

    elTest.onMouse := tester.onMouse;
    //elContainer.onMouse := tester.onMouse;

FINALIZATION
    elBody.unuse();
    elRoot.unuse();
    FreeAndNil( tester );

end.
