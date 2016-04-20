program pHtmLite;

uses
  Forms,
  LiteTest in '..\LiteTest.pas' {HtmLiteTest};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(THtmLiteTest, HtmLiteTest);
  Application.Run;
end.
