unit HtmlTestEvents1;

interface

uses classes, sysutils, forms, Controls, types, windows
    , HtmlCtrl
    , HtmlDOM
    , HtmlTypes
    , HtmlCommon
    , HtmlBehaviour
;

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

{*******************************************************************************
* EventProxy
*******************************************************************************}
function EventProxy( aElement : THtmlElement; evtg : UINT; prms : Pointer; tag : Pointer ) : boolean;
var
    eventGroup  : string;
    msg         : string;
    cmd         : HTMLayoutPhase;

begin
    Result := false;
    msg := '';

    case evtg of
    HANDLE_INITIALIZATION :
        begin
            eventGroup := 'INITIALIZATION';
            cmd := THTMLayoutEvent.phase( PHTMLayoutInitializationParams( prms ).cmd );
        end;
    HANDLE_MOUSE :
        begin
            eventGroup := 'MOUSE';
            cmd := THTMLayoutEvent.phase( PHTMLayoutMouseParams( prms ).cmd );
        end;
    HANDLE_KEY :
        begin
            eventGroup := 'KEY';
            cmd := THTMLayoutEvent.phase( PHTMLayoutKeyParams( prms ).cmd );
        end;
    HANDLE_FOCUS :
        begin
            eventGroup := 'FOCUS';
            cmd := THTMLayoutEvent.phase( PHTMLayoutFocusParams( prms ).cmd );
        end;
    HANDLE_SCROLL :
        begin
            eventGroup := 'SCROLL';
            cmd := THTMLayoutEvent.phase( PHTMLayoutScrollParams( prms ).cmd );
        end;
    HANDLE_TIMER :
        begin
            eventGroup := 'TIMER';
            msg := ' timerId: ' + IntToStr( PHTMLayoutTimerParams( prms ).timerId );
        end;
    HANDLE_SIZE :
        begin
            eventGroup := 'SIZE';
        end;
    HANDLE_DRAW :
        begin
            eventGroup := 'DRAW';
            exit; //
        end;
    HANDLE_DATA_ARRIVED :
        begin
            eventGroup := 'DATA_ARRIVED';
        end;
    HANDLE_BEHAVIOR_EVENT :
        begin
            eventGroup := 'BEHAVIOR_EVENT';
            cmd := THTMLayoutEvent.phase( PHTMLayoutBehaviourEventParams( prms ).cmd );
        end;
    HANDLE_METHOD_CALL :
        begin
            eventGroup := 'METHOD_CALL';
            exit; //eventGroup := 'METHOD_CALL';
        end;
    HANDLE_EXCHANGE :
        begin
            eventGroup := 'EXCHANGE';
            cmd := THTMLayoutEvent.phase( PHTMLayoutExchangeParams( prms ).cmd );
        end;
    HANDLE_GESTURE :
        begin
            eventGroup := 'GESTURE';
            cmd := THTMLayoutEvent.phase( PHTMLayoutGestureParams( prms ).cmd );
        end;
    else
        exit;
    end;

    if ( not ( evtg in [ HANDLE_TIMER, HANDLE_SIZE, HANDLE_DATA_ARRIVED ] ) ) then
    begin
        if ( cmd.sinking ) then
            msg := ' sinking ' + msg;

        if ( cmd.handled ) then
            msg := ' handled ' + msg;

        if ( cmd.bubbling ) then
            msg := ' bubbling ' + msg;
    end;

    elEvents.innerHtml := eventGroup + msg + ' id:' + aElement.id + '<br/>' + elEvents.innerHtml;
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

    elTest := elBody.get_element_by_id( 'test' );

//-------------------------- BEHAVIOUR TESTING ---------------------------------

    elTest.attach( EventProxy );

FINALIZATION
    FreeAndNil( elBody );
    FreeAndNil( elRoot );

end.
