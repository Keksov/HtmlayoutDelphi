unit HtmLite;

interface

uses Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs, StdCtrls
    , HtmLiteH
;

type
  THtmLiteTest = class(TForm)
    Button1: TButton;
    procedure FormPaint(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  HtmLiteTest: THtmLiteTest;

implementation

{$R *.dfm}

{*******************************************************************************
* FormPaint
*******************************************************************************}
procedure THtmLiteTest.FormPaint(Sender: TObject);
var
    html : THTMLiteBase;
    w, h : integer;
    dc : HDC;

begin
    dc := Canvas.Handle;
    
    html := THTMLiteBase.Create( 'screen' );
    try
        html.load( '<html><body style="border:1px solid black;margin:0px;background-color:rgba(255,255,0,0.1);"><h1 style="background-color:rgba(255,0,0,0.1);">Hello, World!</h1></body></html>' );

        html.measure( 512, 512 );

        // Find out the minimum dimensions of the HTML canvas before scrollbars appear
        w := html.getDocumentMinWidth();
        h := html.getDocumentMinHeight();
        html.measure( w * 2, h + 40 );

        html.render( DC, 10, 100, w, h );
    finally
        FreeAndNil( html );
    end;
end;

end.
