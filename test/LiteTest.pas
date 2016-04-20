unit LiteTest;

interface

uses Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs, StdCtrls, Math, Printers, ExtCtrls
    , HtmLiteH
    , HtmLite
    , HtmlLayoutH
;

type
    {***************************************************************************
    * THtmLiteTest
    ***************************************************************************}
    THtmLiteTest = class(TForm)
    pan660: TPanel;
    pan330: TPanel;
    pan495: TPanel;
    pan825: TPanel;
    butPrint: TButton;
    dlgPrint: TPrintDialog;
    procedure FormPaint(Sender: TObject);
    procedure butPrintClick(Sender: TObject);

public
    procedure renderTable( aDc : HDC );
    procedure renderHello( aDc : HDC );

    end;

var
  HtmLiteTest: THtmLiteTest;

implementation

{$R *.dfm}

{*******************************************************************************
* HtmlHello
*******************************************************************************}
function HtmlHello() : string;
begin
    Result := '<html>'
        + '<body style="white-space: nowrap; border:1px solid black;margin:0px;background-color:yellow;padding:10px;">'
        + '<h1 style="background-color:red;">Hello, World!</h1>'
        + '</body></html>'
    ;
end;

{*******************************************************************************
* HtmlTable
*******************************************************************************}
function HtmlTable() : string;
begin
    Result := '<html><head>'
        + '<style>'
        + 'html { overflow: none; }'
        + 'body { margin:0px; padding:0px; background-color:red; }'
        + 'table { background-color:white; margin:0px; padding:0px; border:1px solid black; border-spacing: -1px; width:100%; height:100%;}'
        + 'td { white-space: nowrap; padding: 2px; border:1px solid grey; }'
        + '</style>'
        + '</head>'
        + '<body>'
        + '<table>'
        //+ '<tr><td>Column 1</td><td>Column 2</td><td>Column 3</td><td>Column 4</td><td>Column 5</td><td>Column 6</td><td>Column 7</td><td>Column 8</td><td>Column 9</td></tr>'
        + '<tr><td>Column 10</td><td>Column 20</td><td>Column 30</td><td>Column 40</td><td>Column 50</td><td>Column 60</td><td>Column 70</td><td>Column 80</td><td>Column 90</td></tr>'
        + '<tr><td>Column 10</td><td>Column 20</td><td>Column 30</td><td>Column 40</td><td>Column 50</td><td>Column 60</td><td>Column 70</td><td>Column 80</td><td>Column 90</td></tr>'
        + '</table>'
        + '</body></html>'
    ;
end;

{*******************************************************************************
* FormPaint
*******************************************************************************}
procedure THtmLiteTest.FormPaint(Sender: TObject);
begin
    HTMLayoutSetOption( Handle, cardinal( HTMLAYOUT_FONT_SMOOTHING ), 3 );

    renderHello( Canvas.Handle );
    renderTable( Canvas.Handle );
end;

{*******************************************************************************
*
*******************************************************************************}
procedure DrawRect( aDc : HDC; aRect : TRect );
begin
    MoveToEx( aDc, aRect.Left, aRect.Top, nil );
    LineTo( aDc, aRect.Right, aRect.Top );
    LineTo( aDc, aRect.Right, aRect.Bottom );
    LineTo( aDc, aRect.Left, aRect.Bottom );
    LineTo( aDc, aRect.Left, aRect.Top );
end;

{*******************************************************************************
* renderHello
*******************************************************************************}
procedure THtmLiteTest.renderHello( aDc : HDC );
var
    renderer : THTMLRenderer;
begin
    renderer := THTMLRenderer.Create( aDc );
    renderer.useDeviceDPI := true;

    try
        renderer.html := HtmlHello;
        renderer.render( 10, 0 );
        renderer.renderScaled( 10, 100, 0.5 );
        renderer.renderScaled( 250, 10, renderer.width * 1.5, renderer.height );
    finally
        FreeAndNil( renderer );
    end;
end;

{*******************************************************************************
* renderTable
*******************************************************************************}
procedure THtmLiteTest.renderTable( aDc : HDC );
var
    renderer : THTMLRenderer;
    rect : TRect;

begin
    renderer := THTMLRenderer.Create( aDc );
    renderer.useDeviceDPI := true;

    try
        renderer.renderScaled( HtmlTable, pan330.Left, pan330.Top + pan330.Height + 1, 0.5 );
        renderer.renderScaled( HtmlTable, pan495.Left, pan495.Top + pan495.Height + 1, 0.75 );
        //liteEx.renderScaled( HtmlTable, pan660.Left, pan660.Top + pan660.Height + 1, 1 );
        renderer.render( HtmlTable, pan660.Left, pan660.Top + pan660.Height + 1 );
        renderer.renderScaled( HtmlTable, pan825.Left, pan825.Top + pan825.Height + 1, 1.25 );

        rect.Left := pan660.Left - 2;
        rect.Top := pan660.Top - 3;
        rect.Right := pan660.Left + pan660.Width + 2;
        rect.Bottom := pan660.Top + pan660.Height + renderer.Height + 3;

        if ( not renderer.isScreen ) then
        begin
            rect.Left := renderer.deviceX( rect.Left );
            rect.Top := renderer.deviceY( rect.Top );
            rect.Right := renderer.deviceX( rect.Right );
            rect.Bottom := renderer.deviceX( rect.Bottom );
        end;

        DrawRect( aDc, rect );
    finally
        FreeAndNil( renderer );
    end;
end;

{*******************************************************************************
* butPrintClick
*******************************************************************************}
procedure THtmLiteTest.butPrintClick(Sender: TObject);
var
    printer : TPrinter;
begin
    if ( not dlgPrint.Execute() ) then
        exit;

    printer := Printers.Printer();
    SetPrinter( printer );

    printer.BeginDoc();
    renderHello( printer.Canvas.Handle );
    renderTable( printer.Canvas.Handle );
    printer.EndDoc();

end;


end.
