unit HtmlBehaviorSVG;

(*
  HTMLayout License terms could be found here http://www.terrainformatica.com/htmlayout/prices.whtm
  SDK - http://www.terrainformatica.com/htmlayout/HTMLayoutSDK.zip

  Delphi binding of HTMLayout published under LGPL. Visit https://github.com/Keksov/HtmlayoutDelphi
*)

interface

{$IFDEF USER_DEFINES_INC}{$I user_defines.inc}{$ENDIF}

uses Windows, classes, sysutils
    , HtmlCtrl
    , HtmlLayoutH
    , HtmlElement
    , HtmlTypes
    , HtmlLayoutDomH
    , HtmlBehaviorH
    , unisSVG
    , unisGDIPAPI
    , unisSVGTypes
;

type
    {***************************************************************************
    * THtmlBehaviorSVG
    ***************************************************************************}
    THtmlBehaviorSVG = class

protected
    function    onBehaviorAttach( aSender : THtmlControl; aEventParams : PNMHL_ATTACH_BEHAVIOR ) : LRESULT;

protected
    procedure   internalAttach( aHtmlControl : THtmlControl );

public
    //constructor Create();

class procedure attach( aHtmlControl : THtmlControl );

    end;

implementation

var
    GlobalSVG : THtmlBehaviorSVG;

{*******************************************************************************
* attach
*******************************************************************************}
class procedure THtmlBehaviorSVG.attach( aHtmlControl : THtmlControl );
begin
    GlobalSVG.internalAttach( aHtmlControl );
end;

{*******************************************************************************
* internalAttach
*******************************************************************************}
procedure THtmlBehaviorSVG.internalAttach( aHtmlControl : THtmlControl );
begin
    assert( aHtmlControl <> nil );

    aHtmlControl.OnAttachBehavior := onBehaviorAttach;
end;

{*******************************************************************************
* OnDraw
*******************************************************************************}
function OnDraw( aTag : Pointer; he : HELEMENT; aEventGroup: UINT; aEventParams : Pointer ) : BOOL stdcall;
var
    el : THtmlShim;
    drawParams  : PHTMLayoutDrawParams;
    svg : TSVG;
    dataId : string;
    dataBody : WideString;

begin
    Result := ( PHTMLayoutDrawParams( aEventParams ).cmd = DRAW_CONTENT );
    if ( not Result ) then
        exit;

    drawParams := PHTMLayoutDrawParams( aEventParams );
    el := THtmlShim.get( he );

    try
        svg := TSVG.Create();
        try
            dataId := el.attribute[ 'data' ];
            el := el.root.get_element_by_id( dataId );
            assert( el <> nil );
            if ( not el.is_valid() ) then
                exit;


            if ( el = nil ) then
                exit;

            //svg.LoadFromFile( 'c:\projects\traffic_build\trafficrun\tsetc.chelyabinsk\Знаки индивидуального проектирования\1.svg' );
            dataBody := el.innerText16;

            svg.LoadFromText( dataBody );
            svg.PaintTo( drawParams.hdc, drawParams.area );
{            svg.LoadFromText( el.innerText );
            svg.LoadFromText( el.innerText16 );

            svg.LoadFromText( el.outerHtml );

            svg.LoadFromText( el.innerText );
            svg.LoadFromText( el.innerText16 );
            svg.LoadFromText( el.innerHtml );
            svg.LoadFromText( el.outerHtml );

            if ( el.childrenCount <> 0 ) then
                if ( el.childrenCount <> 0 ) then;

            if ( el.tag <> '' ) then
                if ( el.tag <> '' ) then;}
        except
            on e : Exception do
                if ( e.message <> '' ) then;
        end;
    finally
        FreeAndNil( svg );
    end;

{    HTMLayoutDrawParams = record
        cmd                     : UINT; // DRAW_EVENTS
        hdc                     : HDC; // hdc to paint on
        area                    : TRECT; // element area to paint,
        reserved                : UINT; //   for DRAW_BACKGROUND/DRAW_FOREGROUND - it is a border box, for DRAW_CONTENT - it is a content box
}
end;

{*******************************************************************************
* onBehaviorAttach
*******************************************************************************}
function THtmlBehaviorSVG.onBehaviorAttach( aSender : THtmlControl; aEventParams : PNMHL_ATTACH_BEHAVIOR ) : LRESULT;
begin
    Result := 0;
    if ( aEventParams.behaviorName <> 'svg' ) then
        exit;

    Result := 1;
    THtmlShim.get( aEventParams.helement ).attach( OnDraw, nil, HANDLE_DRAW or DISABLE_INITIALIZATION );
{
hdr                     : NMHDR; // Default WM_NOTIFY header
helement                : HELEMENT; // [in] DOM element.
behaviorName            : LPCSTR; // [in] zero terminated string, string appears as value of CSS behavior:"???" attribute.

elementProc             : HTMLayoutElementEventProc; // [out] pointer to ElementEventProc function.
elementTag              : Pointer; // [out] tag value, passed as is into pointer ElementEventProc function.
elementEvents           : UINT; // [out] EVENT_GROUPS bit flags, event groups elementProc subscribed to.
}

end;

INITIALIZATION
    GlobalSVG := THtmlBehaviorSVG.Create();
//    THtmlControl.DeclareElementType( 'svg', BLOCK_BLOCK_ELEMENT );
end.