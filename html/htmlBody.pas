unit htmlBody;

interface

uses classes, sysutils
    , htmlNode
    , htmlUtils
;

type

{-- THTMLBodyView -------------------------------------------------------------}

    {***************************************************************************
    * THTMLBodyView
    ***************************************************************************}
    THTMLBodyView = class( THTMLTagNode )
public
    constructor Create( aInitialContent : string = '' ); override;

    end;

implementation

{-- THTMLBodyView -------------------------------------------------------------}

{*******************************************************************************
* Create
*******************************************************************************}
constructor THTMLBodyView.Create( aInitialContent : string = '' );
begin
    inherited;
    Ftag := 'body';
end;

end.
