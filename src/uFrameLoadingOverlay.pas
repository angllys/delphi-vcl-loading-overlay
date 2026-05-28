unit uFrameLoadingOverlay;

interface

uses
  System.SysUtils,
  System.Classes,
  Vcl.Controls,
  Vcl.ExtCtrls,
  Vcl.StdCtrls,
  Vcl.ComCtrls,
  Vcl.Graphics;

type
  TFrameLoadingOverlay = class(TPanel)
  private
    FPainelCentral: TPanel;
    FTitulo: TLabel;
    FMensagem: TLabel;
    FProgresso: TProgressBar;
    FSubMensagem: TLabel;

    procedure ConstruirLayout;
    procedure CentralizarPainel;
  protected
    procedure Resize; override;
  public
    constructor Create(AOwner: TComponent); override;

    procedure AjustarLayout;
    procedure AtualizarMensagem(const AMensagem: string);
    procedure AtualizarSubMensagem(const AMensagem: string);
  end;

implementation

{ TFrameLoadingOverlay }

constructor TFrameLoadingOverlay.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ConstruirLayout;
end;

procedure TFrameLoadingOverlay.ConstruirLayout;
begin
  Align := alClient;
  BevelOuter := bvNone;
  ParentBackground := False;
  Color := $00F2F2F2;
  Visible := False;

  FPainelCentral := TPanel.Create(Self);
  FPainelCentral.Parent := Self;
  FPainelCentral.Width := 430;
  FPainelCentral.Height := 175;
  FPainelCentral.BevelOuter := bvNone;
  FPainelCentral.Color := clWhite;
  FPainelCentral.ParentBackground := False;

  FTitulo := TLabel.Create(Self);
  FTitulo.Parent := FPainelCentral;
  FTitulo.Caption := 'Processando';
  FTitulo.Font.Name := 'Segoe UI';
  FTitulo.Font.Size := 14;
  FTitulo.Font.Style := [fsBold];
  FTitulo.Font.Color := $00333333;
  FTitulo.Left := 24;
  FTitulo.Top := 22;
  FTitulo.AutoSize := True;

  FMensagem := TLabel.Create(Self);
  FMensagem.Parent := FPainelCentral;
  FMensagem.Caption := 'Aguarde enquanto os dados são carregados...';
  FMensagem.Font.Name := 'Segoe UI';
  FMensagem.Font.Size := 10;
  FMensagem.Font.Color := $00555555;
  FMensagem.Left := 24;
  FMensagem.Top := 58;
  FMensagem.Width := 380;
  FMensagem.Height := 25;
  FMensagem.AutoSize := False;

  FProgresso := TProgressBar.Create(Self);
  FProgresso.Parent := FPainelCentral;
  FProgresso.Left := 24;
  FProgresso.Top := 94;
  FProgresso.Width := 380;
  FProgresso.Height := 18;
  FProgresso.Style := pbstMarquee;
  FProgresso.MarqueeInterval := 25;

  FSubMensagem := TLabel.Create(Self);
  FSubMensagem.Parent := FPainelCentral;
  FSubMensagem.Caption := 'Esta operação pode levar alguns segundos.';
  FSubMensagem.Font.Name := 'Segoe UI';
  FSubMensagem.Font.Size := 9;
  FSubMensagem.Font.Color := $00808080;
  FSubMensagem.Left := 24;
  FSubMensagem.Top := 126;
  FSubMensagem.Width := 380;
  FSubMensagem.Height := 22;
  FSubMensagem.AutoSize := False;
end;

procedure TFrameLoadingOverlay.CentralizarPainel;
begin
  if not Assigned(FPainelCentral) then
    Exit;

  if not Assigned(Parent) then
    Exit;

  if ClientWidth <= 0 then
    Exit;

  if ClientHeight <= 0 then
    Exit;

  FPainelCentral.Left := (ClientWidth - FPainelCentral.Width) div 2;
  FPainelCentral.Top := (ClientHeight - FPainelCentral.Height) div 2;
end;

procedure TFrameLoadingOverlay.Resize;
begin
  inherited Resize;

  if Assigned(Parent) then
    CentralizarPainel;
end;

procedure TFrameLoadingOverlay.AjustarLayout;
begin
  CentralizarPainel;
  BringToFront;
  Update;
end;

procedure TFrameLoadingOverlay.AtualizarMensagem(const AMensagem: string);
begin
  if Assigned(FMensagem) then
  begin
    FMensagem.Caption := AMensagem;
    FMensagem.Update;
  end;
end;

procedure TFrameLoadingOverlay.AtualizarSubMensagem(const AMensagem: string);
begin
  if Assigned(FSubMensagem) then
  begin
    FSubMensagem.Caption := AMensagem;
    FSubMensagem.Update;
  end;
end;

end.