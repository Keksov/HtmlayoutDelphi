unit htmlHead;

interface

uses classes, sysutils
    , htmlNode
    , htmlUtils
    , htmlStyle
;

type

{-- THTMLHeadView -------------------------------------------------------------}

    {***************************************************************************
    * THTMLHeadView
    ***************************************************************************}
    THTMLHeadView = class( THTMLTagNode )
protected
    Fstyle                      : THTMLStyleView;
    
public
    constructor Create( aInitialContent : string = '' ); override;

public // property
    property style : THTMLStyleView read Fstyle;

    end;

implementation

{-- THTMLHeadView -------------------------------------------------------------}

{*******************************************************************************
* Create
*******************************************************************************}
constructor THTMLHeadView.Create( aInitialContent : string = '' );
begin
    inherited;
    Ftag := 'head';

    Fstyle := THTMLStyleView( children.addNode( THTMLStyleView, aInitialContent ) );
end;


end.
