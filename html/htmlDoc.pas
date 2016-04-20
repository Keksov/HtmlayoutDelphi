unit htmlDoc;

interface

uses classes, sysutils
    , htmlNode
    , htmlUtils
    , htmlHead
    , htmlBody
;

type

{-- THTMLDocView ---------------------------------------------------------}

    {***************************************************************************
    * THTMLDocView
    ***************************************************************************}
    THTMLDocView = class( THTMLTagNode )
protected
    Fhead                       : THTMLHeadView;
    Fbody                       : THTMLBodyView;

public
    constructor Create( aInitialContent : string = '' ); override;

public // property
    property head : THTMLHeadView read Fhead;
    property body : THTMLBodyView read Fbody;
    
    end;

implementation

{-- THTMLDocView ----------------------------------------------------------}

{*******************************************************************************
* Create
*******************************************************************************}
constructor THTMLDocView.Create( aInitialContent : string = '' );
begin
    inherited;
    Ftag := 'html';

    Fhead := THTMLHeadView( children.addNode( THTMLHeadView, '' ) );
    Fbody := THTMLBodyView( children.addNode( THTMLBodyView, '' ) );
    //assert( Fbody.html <> '' );
end;

end.
