unit HtmlEventsTest;

interface

uses Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs
    , HtmLiteH
    , HtmlCtrl
    , HtmlTypes
    , HtmlBehaviorH
    , HtmlElement
;

type
    {***************************************************************************
    *
    ***************************************************************************}
    TTHtmlEventsTest = class(TForm)
    procedure FormCreate(Sender: TObject);

protected
    function onMyDivClick( aSender : HELEMENT; aParams : PHTMLayoutMouseParams; aUserData : Pointer ) : boolean;

    end;

var
  THtmlEventsTest: TTHtmlEventsTest;

implementation

{$R *.dfm}

{*******************************************************************************
* FormCreate
*******************************************************************************}
procedure TTHtmlEventsTest.FormCreate(Sender: TObject);
var
    c : THtmlControl;
    e : THTMLayoutEvent;

    style : string;
    body : string;
    table : string;

begin
    c := THtmlControl.Create( self );
    c.Align := alClient;
    c.Parent := self;

    style := 'body { margin:0px;padding:0px;} table {background-color:rgba( 255, 255, 255, 0.5 );margin:0px; padding:0px; border:1px solid black;border-spacing: -1px;} td {white-space: nowrap; padding: 2px; border:1px solid grey;}';
    body := '<div id="myDiv" style="width:200px;height:100px;background-color:yellow;color:blue">OK. Click me</div>';

    table := '';
    table := table + '<tr><td>01</td><td>02</td><td>03</td><td>04</td><td>05</td><td>06</td><td>07</td><td>08</td><td>09</td></tr>';
    table := table + '<tr><td>11</td><td>12</td><td>13</td><td>14</td><td>15</td><td>16</td><td>17</td><td>18</td><td>19</td></tr>';
    table := '<table>' + table + '</table>';

    body := body + table;
    c.html := '<html><head><style>' + style + '</style></head><body>' + body + '</body></html>';

//    e := THTMLayoutEvent.Create();
    c.domEvents.onMouseClick[ '#myDiv' ] := onMyDivClick;
//    e.attach( c.hroot );
end;

{*******************************************************************************
* onMyDivClick
*******************************************************************************}
function TTHtmlEventsTest.onMyDivClick( aSender : HELEMENT; aParams : PHTMLayoutMouseParams; aUserData : Pointer ) : boolean;
const
    ButtonStatus : array[ boolean ] of string = ( 'No', 'Yes' );

var
    el : THtmlShim;
begin
    Result := true;
    el := THtmlShim.get( aSender );
    el.innerHtml := 'x=' + IntToStr( aParams.pos.X ) + ', y=' + IntToStr( aParams.pos.Y )
        + '<br/>' + 'Left pressed: <b>' + ButtonStatus[ THTMLayoutEvent.leftPressed( aParams ) ] + '</b>'
        + '<br/>' + 'Middle pressed: <b>' + ButtonStatus[ THTMLayoutEvent.middlePressed( aParams ) ] + '</b>'
        + '<br/>' + 'Right pressed: <b>' + ButtonStatus[ THTMLayoutEvent.rightPressed( aParams ) ] + '</b>'
    ;
end;

end.
