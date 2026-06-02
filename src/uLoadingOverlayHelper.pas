unit uLoadingOverlayHelper;

interface

uses
  System.SysUtils,
  System.Classes,
  System.Threading,
  Winapi.Windows,
  Vcl.Controls,
  Vcl.Forms,
  uFrameLoadingOverlay;

type
  TLoadingOverlayPositionMode = (
    lopAlignClient,
    lopAbsolute
  );

  TLoadingOverlayErrorProc = reference to procedure(const AErro: string);

  TLoadingOverlayHelper = class
  private
    FOwner: TComponent;
    FParent: TWinControl;
    FOverlay: TFrameLoadingOverlay;
    FPositionMode: TLoadingOverlayPositionMode;

    procedure CriarOverlaySeNecessario;
    procedure PosicionarOverlay;
    procedure PosicionarAlignClient;
    procedure PosicionarAbsolute;

    procedure FinalizarAsync(
      const AOnFinish: TProc);

    procedure TratarErroAsync(
      const AErro: string;
      const AOnError: TLoadingOverlayErrorProc);

  public
    constructor Create(
      const AOwner: TComponent;
      const AParent: TWinControl); overload;

    constructor Create(
      const AOwner: TComponent;
      const AParent: TWinControl;
      const APositionMode: TLoadingOverlayPositionMode); overload;

    destructor Destroy; override;

    procedure Mostrar(
      const AMensagem: string;
      const ASubMensagem: string = '');

    procedure Atualizar(
      const AMensagem: string;
      const ASubMensagem: string = '');

    procedure Ocultar;

    procedure ExecuteAsync(
      const AMensagem: string;
      const AProc: TProc); overload;

    procedure ExecuteAsync(
      const AMensagem: string;
      const ASubMensagem: string;
      const AProc: TProc); overload;

    procedure ExecuteAsync(
      const AMensagem: string;
      const ASubMensagem: string;
      const AProc: TProc;
      const AOnFinish: TProc;
      const AOnError: TLoadingOverlayErrorProc = nil); overload;

    property Overlay: TFrameLoadingOverlay read FOverlay;

    property PositionMode: TLoadingOverlayPositionMode
      read FPositionMode
      write FPositionMode;
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
  FPositionMode := lopAlignClient;
end;

constructor TLoadingOverlayHelper.Create(
  const AOwner: TComponent;
  const AParent: TWinControl;
  const APositionMode: TLoadingOverlayPositionMode);
begin
  Create(AOwner, AParent);

  FPositionMode := APositionMode;
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

  if not Assigned(FOwner) then
    raise Exception.Create('Owner do LoadingOverlay não foi informado.');

  if not Assigned(FParent) then
    raise Exception.Create('Parent do LoadingOverlay não foi informado.');

  FOverlay := TFrameLoadingOverlay.Create(FOwner);
  FOverlay.Parent := FParent;
  FOverlay.Visible := False;
end;

procedure TLoadingOverlayHelper.PosicionarOverlay;
begin
  if not Assigned(FOverlay) then
    Exit;

  if not Assigned(FParent) then
    Exit;

  case FPositionMode of
    lopAlignClient:
      PosicionarAlignClient;

    lopAbsolute:
      PosicionarAbsolute;
  end;
end;

procedure TLoadingOverlayHelper.PosicionarAlignClient;
begin
  if not Assigned(FOverlay) then
    Exit;

  if not Assigned(FParent) then
    Exit;

  FOverlay.Parent := FParent;
  FOverlay.Align := alClient;
  FOverlay.Visible := True;
  FOverlay.Enabled := True;
end;

procedure TLoadingOverlayHelper.PosicionarAbsolute;
begin
  if not Assigned(FOverlay) then
    Exit;

  if not Assigned(FParent) then
    Exit;

  FOverlay.Parent := FParent;

  FOverlay.Align := alNone;
  FOverlay.Anchors := [akLeft, akTop, akRight, akBottom];

  FOverlay.SetBounds(
    0,
    0,
    FParent.ClientWidth,
    FParent.ClientHeight
  );

  FOverlay.Visible := True;
  FOverlay.Enabled := True;
  FOverlay.BringToFront;

  if FOverlay.HandleAllocated then
  begin
    SetWindowPos(
      FOverlay.Handle,
      HWND_TOP,
      0,
      0,
      FParent.ClientWidth,
      FParent.ClientHeight,
      SWP_NOACTIVATE or SWP_SHOWWINDOW
    );
  end;

  FOverlay.BringToFront;
  FOverlay.Update;

  FParent.Update;

  Application.ProcessMessages;
end;

procedure TLoadingOverlayHelper.Mostrar(
  const AMensagem: string;
  const ASubMensagem: string);
begin
  CriarOverlaySeNecessario;

  FOverlay.Mostrar(
    AMensagem,
    ASubMensagem
  );

  PosicionarOverlay;
end;

procedure TLoadingOverlayHelper.Atualizar(
  const AMensagem: string;
  const ASubMensagem: string);
begin
  if not Assigned(FOverlay) then
    Exit;

  FOverlay.Atualizar(
    AMensagem,
    ASubMensagem
  );

  if FPositionMode = lopAbsolute then
    PosicionarAbsolute;
end;

procedure TLoadingOverlayHelper.Ocultar;
begin
  if not Assigned(FOverlay) then
    Exit;

  FOverlay.Ocultar;
  FOverlay.Visible := False;

  if FPositionMode = lopAbsolute then
    FOverlay.SendToBack;
end;

procedure TLoadingOverlayHelper.ExecuteAsync(
  const AMensagem: string;
  const AProc: TProc);
begin
  ExecuteAsync(
    AMensagem,
    'Aguarde enquanto o processo é executado.',
    AProc,
    nil,
    nil
  );
end;

procedure TLoadingOverlayHelper.ExecuteAsync(
  const AMensagem: string;
  const ASubMensagem: string;
  const AProc: TProc);
begin
  ExecuteAsync(
    AMensagem,
    ASubMensagem,
    AProc,
    nil,
    nil
  );
end;

procedure TLoadingOverlayHelper.ExecuteAsync(
  const AMensagem: string;
  const ASubMensagem: string;
  const AProc: TProc;
  const AOnFinish: TProc;
  const AOnError: TLoadingOverlayErrorProc);
begin
  if not Assigned(AProc) then
    raise Exception.Create('Processo assíncrono não informado.');

  Mostrar(
    AMensagem,
    ASubMensagem
  );

  TTask.Run(
    procedure
    var
      lErro: string;
    begin
      try
        AProc;

        TThread.Queue(
          nil,
          procedure
          begin
            FinalizarAsync(AOnFinish);
          end
        );
      except
        on E: Exception do
        begin
          lErro := E.Message;

          TThread.Queue(
            nil,
            procedure
            begin
              TratarErroAsync(
                lErro,
                AOnError
              );
            end
          );
        end;
      end;
    end
  );
end;

procedure TLoadingOverlayHelper.FinalizarAsync(
  const AOnFinish: TProc);
begin
  Ocultar;

  if Assigned(AOnFinish) then
    AOnFinish;
end;

procedure TLoadingOverlayHelper.TratarErroAsync(
  const AErro: string;
  const AOnError: TLoadingOverlayErrorProc);
begin
  Ocultar;

  if Assigned(AOnError) then
    AOnError(AErro)
  else
    raise Exception.Create(AErro);
end;

end.
