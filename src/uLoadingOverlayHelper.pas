unit uLoadingOverlayHelper;

interface

uses
  System.SysUtils,
  System.Classes,
  Vcl.Controls,
  Vcl.Forms,
  uFrameLoadingOverlay;

type
  TLoadingOverlayHelper = class
  private
    FOwner: TComponent;
    FParent: TWinControl;
    FOverlay: TFrameLoadingOverlay;
    FCursorAnterior: TCursor;

    procedure CriarOverlaySeNecessario;
  public
    constructor Create(
      const AOwner: TComponent;
      const AParent: TWinControl);

    destructor Destroy; override;

    procedure Mostrar(
      const AMensagem: string;
      const ASubMensagem: string = '');

    procedure Atualizar(
      const AMensagem: string;
      const ASubMensagem: string = '');

    procedure Ocultar;

    function Visivel: Boolean;

    property Overlay: TFrameLoadingOverlay read FOverlay;
  end;

implementation

{ TLoadingOverlayHelper }

constructor TLoadingOverlayHelper.Create(
  const AOwner: TComponent;
  const AParent: TWinControl);
begin
  inherited Create;

  FOwner := AOwner;
  FParent := AParent;
  FOverlay := nil;
  FCursorAnterior := crDefault;

  if not Assigned(FOwner) then
    raise Exception.Create('Owner do LoadingOverlay não informado.');

  if not Assigned(FParent) then
    raise Exception.Create('Parent do LoadingOverlay não informado.');
end;

destructor TLoadingOverlayHelper.Destroy;
begin
  FreeAndNil(FOverlay);
  inherited;
end;

procedure TLoadingOverlayHelper.CriarOverlaySeNecessario;
begin
  if Assigned(FOverlay) then
    Exit;

  FOverlay := TFrameLoadingOverlay.Create(FOwner);
  FOverlay.Parent := FParent;
  FOverlay.Align := alClient;
  FOverlay.Visible := False;
end;

procedure TLoadingOverlayHelper.Mostrar(
  const AMensagem: string;
  const ASubMensagem: string);
begin
  CriarOverlaySeNecessario;

  FCursorAnterior := Screen.Cursor;

  FOverlay.AtualizarMensagem(AMensagem);

  if ASubMensagem <> '' then
    FOverlay.AtualizarSubMensagem(ASubMensagem);

  FOverlay.Visible := True;
  FOverlay.BringToFront;
  FOverlay.AjustarLayout;

  Screen.Cursor := crHourGlass;
  Application.ProcessMessages;
end;

procedure TLoadingOverlayHelper.Atualizar(
  const AMensagem: string;
  const ASubMensagem: string);
begin
  if not Assigned(FOverlay) then
    Exit;

  FOverlay.AtualizarMensagem(AMensagem);

  if ASubMensagem <> '' then
    FOverlay.AtualizarSubMensagem(ASubMensagem);

  FOverlay.BringToFront;
  FOverlay.AjustarLayout;

  Application.ProcessMessages;
end;

procedure TLoadingOverlayHelper.Ocultar;
begin
  if Assigned(FOverlay) then
    FOverlay.Visible := False;

  Screen.Cursor := FCursorAnterior;
  Application.ProcessMessages;
end;

function TLoadingOverlayHelper.Visivel: Boolean;
begin
  Result := Assigned(FOverlay) and FOverlay.Visible;
end;

end.