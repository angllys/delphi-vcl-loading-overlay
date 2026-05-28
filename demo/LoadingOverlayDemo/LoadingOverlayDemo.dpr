program LoadingOverlayDemo;

uses
  Vcl.Forms,
  ufrmLoadingOverlayDemo in 'ufrmLoadingOverlayDemo.pas' {frmLoadingOverlayDemo},
  uFrameLoadingOverlay in '..\..\src\uFrameLoadingOverlay.pas',
  uLoadingOverlayHelper in '..\..\src\uLoadingOverlayHelper.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'Delphi VCL Loading Overlay Demo';
  Application.CreateForm(TfrmLoadingOverlayDemo, frmLoadingOverlayDemo);
  Application.Run;
end.