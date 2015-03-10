unit htmlTags;

interface

uses classes, sysutils
    , htmlNode
    , htmlConst
;

type

{-- THTMLAnchorView -----------------------------------------------------------}

    {***************************************************************************
    * THTMLAnchorView
    ***************************************************************************}
    THTMLAnchorView = class( THTMLTagNode )
public
    constructor Create( aInitialContent : string = '' ); override;

public // property
    property href : string index HTML_ATTR_HREF read getAttr write setAttr;

    end;

implementation

{-- THTMLAnchorView -----------------------------------------------------------}

{*******************************************************************************
* Create
*******************************************************************************}
constructor THTMLAnchorView.Create( aInitialContent : string = '' );
begin
    inherited;
    Ftag := 'a';
    href := '#';
end;

end.
