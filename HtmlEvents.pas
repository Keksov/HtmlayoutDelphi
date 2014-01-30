unit HtmlEvents;

interface

uses Windows
    , HtmlTypes
    , HtmlBehaviour
    , HtmlElement
;

type

{---------------------------- HANDLE_INITIALIZATION ---------------------------}

    {***************************************************************************
    * THtmlInitializationEvent
    ***************************************************************************}
    THtmlInitializationEvent = class( THtmlCmdEventParams )
protected
    function    call( aEventGroup : UINT; aEventParams : Pointer ) : boolean; override;
    end;

    {***************************************************************************
    * THtmlInitializationCmd
    ***************************************************************************}
    THtmlInitializationCmd = class( THtmlInitializationEvent )
protected
    function    call( aEventGroup : UINT; aEventParams : Pointer ) : boolean; override;
    end;

{----------------------------- HANDLE_MOUSE -----------------------------------}

    {***************************************************************************
    * THtmlMouseEvent
    ***************************************************************************}
    THtmlMouseEvent = class( THtmlCmdEventParams )
protected
    function    call( aEventGroup : UINT; aEventParams : Pointer ) : boolean; override;
    end;

    {***************************************************************************
    * THtmlMouseCmd
    ***************************************************************************}
    THtmlMouseCmd = class( THtmlMouseEvent )
protected
    function    call( aEventGroup : UINT; aEventParams : Pointer ) : boolean; override;
    end;

{----------------------------- HANDLE_KEY -------------------------------------}

    {***************************************************************************
    * THtmlKeyEvent
    ***************************************************************************}
    THtmlKeyEvent = class( THtmlCmdEventParams )
protected
    function    call( aEventGroup : UINT; aEventParams : Pointer ) : boolean; override;
    end;

    {***************************************************************************
    * THtmlKeyCmd
    ***************************************************************************}
    THtmlKeyCmd = class( THtmlKeyEvent )
protected
    function    call( aEventGroup : UINT; aEventParams : Pointer ) : boolean; override;
    end;

{----------------------------- HANDLE_FOCUS -----------------------------------}

    {***************************************************************************
    * THtmlFocusEvent
    ***************************************************************************}
    THtmlFocusEvent = class( THtmlCmdEventParams )
protected
    function    call( aEventGroup : UINT; aEventParams : Pointer ) : boolean; override;
    end;

    {***************************************************************************
    * THtmlFocusCmd
    ***************************************************************************}
    THtmlFocusCmd = class( THtmlFocusEvent )
protected
    function    call( aEventGroup : UINT; aEventParams : Pointer ) : boolean; override;
    end;

{----------------------------- HANDLE_SCROLL ----------------------------------}

    {***************************************************************************
    * THtmlScrollEvent
    ***************************************************************************}
    THtmlScrollEvent = class( THtmlCmdEventParams )
protected
    function    call( aEventGroup : UINT; aEventParams : Pointer ) : boolean; override;
    end;

    {***************************************************************************
    * THtmlScrollCmd
    ***************************************************************************}
    THtmlScrollCmd = class( THtmlScrollEvent )
protected
    function    call( aEventGroup : UINT; aEventParams : Pointer ) : boolean; override;
    end;

{------------------------------ HANDLE_TIMER ----------------------------------}

    {***************************************************************************
    * THtmlTimerEvent
    ***************************************************************************}
    THtmlTimerEvent = class( THtmlCmdEventParams )
protected
    function    call( aEventGroup : UINT; aEventParams : Pointer ) : boolean; override;
    end;

{------------------------------- HANDLE_DRAW ----------------------------------}

    {***************************************************************************
    * THtmlDrawEvent
    ***************************************************************************}
    THtmlDrawEvent = class( THtmlCmdEventParams )
protected
    function    call( aEventGroup : UINT; aEventParams : Pointer ) : boolean; override;
    end;

    {***************************************************************************
    * THtmlDrawCmd
    ***************************************************************************}
    THtmlDrawCmd = class( THtmlDrawEvent )
protected
    function    call( aEventGroup : UINT; aEventParams : Pointer ) : boolean; override;
    end;

{------------------------------- HANDLE_SIZE ----------------------------------}

    {***************************************************************************
    * THtmlSizeEvent
    ***************************************************************************}
    THtmlSizeEvent = class( THtmlCmdEventParams )
protected
    function    call( aEventGroup : UINT; aEventParams : Pointer ) : boolean; override;
    end;

{--------------------------- HANDLE_DATA_ARRIVED ------------------------------}

    {***************************************************************************
    * THtmlDataArrivedEvent
    ***************************************************************************}
    THtmlDataArrivedEvent = class( THtmlCmdEventParams )
protected
    function    call( aEventGroup : UINT; aEventParams : Pointer ) : boolean; override;
    end;

{----------------------------- HANDLE_EXCHANGE --------------------------------}

    {***************************************************************************
    * THtmlExchangeEvent
    ***************************************************************************}
    THtmlExchangeEvent = class( THtmlCmdEventParams )
protected
    function    call( aEventGroup : UINT; aEventParams : Pointer ) : boolean; override;
    end;

    {***************************************************************************
    * THtmlExchangeCmd
    ***************************************************************************}
    THtmlExchangeCmd = class( THtmlExchangeEvent )
protected
    function    call( aEventGroup : UINT; aEventParams : Pointer ) : boolean; override;
    end;

{----------------------------- HANDLE_GESTURE ---------------------------------}

    {***************************************************************************
    * THtmlGestureEvent
    ***************************************************************************}
    THtmlGestureEvent = class( THtmlCmdEventParams )
protected
    function    call( aEventGroup : UINT; aEventParams : Pointer ) : boolean; override;
    end;

    {***************************************************************************
    * THtmlGestureCmd
    ***************************************************************************}
    THtmlGestureCmd = class( THtmlGestureEvent )
protected
    function    call( aEventGroup : UINT; aEventParams : Pointer ) : boolean; override;
    end;

implementation

{---------------------------- HANDLE_INITIALIZATION ---------------------------}

function THtmlInitializationEvent.call( aEventGroup : UINT; aEventParams : Pointer ) : boolean;
begin
    Result := HTMLElementInitializationEventHandler( Fcallback )( Felement, PHTMLayoutInitializationParams( aEventParams ), Ftag );
end;

function THtmlInitializationCmd.call( aEventGroup : UINT; aEventParams : Pointer ) : boolean;
begin
    assert( aEventParams <> nil );
    Result := ( PHTMLayoutInitializationParams( aEventParams ).cmd = Fcmd );
    Result := Result and inherited call( aEventGroup, aEventParams );
end;

{-------------------------------- HANDLE_MOUSE --------------------------------}

function THtmlMouseEvent.call( aEventGroup : UINT; aEventParams : Pointer ) : boolean;
begin
    Result := HTMLElementMouseEventHandler( Fcallback )( Felement, PHTMLayoutMouseParams( aEventParams ), Ftag );
end;

function THtmlMouseCmd.call( aEventGroup : UINT; aEventParams : Pointer ) : boolean;
begin
    assert( aEventParams <> nil );
    Result := ( PHTMLayoutMouseParams( aEventParams ).cmd = Fcmd );
    Result := Result and inherited call( aEventGroup, aEventParams );
end;

{------------------------------ HANDLE_KEY ------------------------------------}

function THtmlKeyEvent.call( aEventGroup : UINT; aEventParams : Pointer ) : boolean;
begin
    assert( aEventGroup = HANDLE_KEY );
    Result := HTMLElementKeyEventHandler( Fcallback )( Felement, PHTMLayoutKeyParams( aEventParams ), Ftag );
end;

function THtmlKeyCmd.call( aEventGroup : UINT; aEventParams : Pointer ) : boolean;
begin
    assert( aEventParams <> nil );
    Result := ( PHTMLayoutKeyParams( aEventParams ).cmd = Fcmd );
    Result := Result and inherited call( aEventGroup, aEventParams );
end;

{------------------------------ HANDLE_FOCUS ----------------------------------}

function THtmlFocusEvent.call( aEventGroup : UINT; aEventParams : Pointer ) : boolean;
begin
    assert( aEventGroup = HANDLE_FOCUS );
    Result := HTMLElementFocusEventHandler( Fcallback )( Felement, PHTMLayoutFocusParams( aEventParams ), Ftag );
end;

function THtmlFocusCmd.call( aEventGroup : UINT; aEventParams : Pointer ) : boolean;
begin
    assert( aEventParams <> nil );
    Result := ( PHTMLayoutFocusParams( aEventParams ).cmd = Fcmd );
    Result := Result and inherited call( aEventGroup, aEventParams );
end;

{------------------------------ HANDLE_SCROLL ---------------------------------}

function THtmlScrollEvent.call( aEventGroup : UINT; aEventParams : Pointer ) : boolean;
begin
    assert( aEventGroup = HANDLE_SCROLL );
    Result := HTMLElementScrollEventHandler( Fcallback )( Felement, PHTMLayoutScrollParams( aEventParams ), Ftag );
end;

function THtmlScrollCmd.call( aEventGroup : UINT; aEventParams : Pointer ) : boolean;
begin
    assert( aEventParams <> nil );
    Result := ( PHTMLayoutScrollParams( aEventParams ).cmd = Fcmd );
    Result := Result and inherited call( aEventGroup, aEventParams );
end;

{------------------------------ HANDLE_TIMER ----------------------------------}

function THtmlTimerEvent.call( aEventGroup : UINT; aEventParams : Pointer ) : boolean;
begin
    assert( aEventGroup = HANDLE_TIMER );
    Result := HTMLElementTimerEventHandler( Fcallback )( Felement, PHTMLayoutTimerParams( aEventParams ), Ftag );
end;

{-------------------------------- HANDLE_DRAW ---------------------------------}

function THtmlDrawEvent.call( aEventGroup : UINT; aEventParams : Pointer ) : boolean;
begin
    assert( aEventGroup = HANDLE_GESTURE );
    Result := HTMLElementDrawEventHandler( Fcallback )( Felement, PHTMLayoutDrawParams( aEventParams ), Ftag );
end;

function THtmlDrawCmd.call( aEventGroup : UINT; aEventParams : Pointer ) : boolean;
begin
    assert( aEventParams <> nil );
    Result := ( PHTMLayoutDrawParams( aEventParams ).cmd = Fcmd );
    Result := Result and inherited call( aEventGroup, aEventParams );
end;

{-------------------------------- HANDLE_SIZE ---------------------------------}

function THtmlSizeEvent.call( aEventGroup : UINT; aEventParams : Pointer ) : boolean;
begin
    assert( aEventGroup = HANDLE_SIZE );
    Result := HTMLElementSizeEventHandler( Fcallback )( Felement, Ftag );
end;

{---------------------------- HANDLE_DATA_ARRIVED -----------------------------}

function THtmlDataArrivedEvent.call( aEventGroup : UINT; aEventParams : Pointer ) : boolean;
begin
    assert( aEventGroup = HANDLE_DATA_ARRIVED );
    Result := HTMLElementDataArrivedEventHandler( Fcallback )( Felement, PHTMLayoutDataArrivedParams( aEventParams ), Ftag );
end;

{------------------------------ HANDLE_EXCHANGE -------------------------------}

function THtmlExchangeEvent.call( aEventGroup : UINT; aEventParams : Pointer ) : boolean;
begin
    assert( aEventGroup = HANDLE_EXCHANGE );
    Result := HTMLElementExchangeEventHandler( Fcallback )( Felement, PHTMLayoutExchangeParams( aEventParams ), Ftag );
end;

function THtmlExchangeCmd.call( aEventGroup : UINT; aEventParams : Pointer ) : boolean;
begin
    assert( aEventParams <> nil );
    Result := ( PHTMLayoutExchangeParams( aEventParams ).cmd = Fcmd );
    Result := Result and inherited call( aEventGroup, aEventParams );
end;

{------------------------------ HANDLE_GESTURE --------------------------------}

function THtmlGestureEvent.call( aEventGroup : UINT; aEventParams : Pointer ) : boolean;
begin
    assert( aEventGroup = HANDLE_GESTURE );
    Result := HTMLElementGestureEventHandler( Fcallback )( Felement, PHTMLayoutGestureParams( aEventParams ), Ftag );
end;

function THtmlGestureCmd.call( aEventGroup : UINT; aEventParams : Pointer ) : boolean;
begin
    assert( aEventParams <> nil );
    Result := ( PHTMLayoutGestureParams( aEventParams ).cmd = Fcmd );
    Result := Result and inherited call( aEventGroup, aEventParams );
end;

end.