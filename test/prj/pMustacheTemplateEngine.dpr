program pMustacheTemplateEngine;

uses
  Forms,
  MustacheTemplateEngine in '..\MustacheTemplateEngine.pas' {fmMustache};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfmMustache, fmMustache);
  Application.Run;
end.
