program pEvents;

uses
  Forms,
  HtmlEventsTest in '..\HtmlEventsTest.pas' {THtmlEventsTest};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TTHtmlEventsTest, THtmlEventsTest);
  Application.Run;
end.
