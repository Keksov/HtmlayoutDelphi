program pSVG;

uses
  Forms,
  TestSVG in '..\TestSVG.pas' {fmTestSVG};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfmTestSVG, fmTestSVG);
  Application.Run;
end.
