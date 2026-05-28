unit ufrmLoadingOverlayDemo;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Classes,
  System.Threading,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.StdCtrls,
  Vcl.ExtCtrls,
  Vcl.ComCtrls,
  uLoadingOverlayHelper;

type
  TProgressoDemoProc = reference to procedure(const AMensagem: string);
  TErroDemoProc = reference to procedure(const AMensagem: string);
  TFinalizarDemoProc = reference to procedure;

  TProcessoDemoThread = class(TThread)
  private
    FOnProgresso: TProgressoDemoProc;
    FOnFinalizar: TFinalizarDemoProc;
    FOnErro: TErroDemoProc;

    procedure NotificarProgresso(const AMensagem: string);
    procedure NotificarFinalizacao;
    procedure NotificarErro(const AMensagem: string);
  protected
    procedure Execute; override;
  public
    property OnProgresso: TProgressoDemoProc read FOnProgresso write FOnProgresso;
    property OnFinalizar: TFinalizarDemoProc read FOnFinalizar write FOnFinalizar;
    property OnErro: TErroDemoProc read FOnErro write FOnErro;
  end;

  TfrmLoadingOverlayDemo = class(TForm)
    pnPrincipal: TPanel;
    pnTopo: TPanel;
    lblTitulo: TLabel;
    lblSubTitulo: TLabel;
    pnConteudo: TPanel;
    pnBotoes: TPanel;
    btnProcessoSync: TButton;
    btnProcessoTTask: TButton;
    btnProcessoTThread: TButton;
    mmLog: TMemo;
    pnStatus: TPanel;
    lblStatus: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnProcessoSyncClick(Sender: TObject);
    procedure btnProcessoTTaskClick(Sender: TObject);
    procedure btnProcessoTThreadClick(Sender: TObject);
  private
    FLoading: TLoadingOverlayHelper;

    procedure AdicionarLog(const AMensagem: string);
    procedure DefinirStatus(const AMensagem: string);
    procedure HabilitarBotoes(const AHabilitar: Boolean);

    procedure SimularEtapa(
      const ADescricao: string;
      const ATempoMs: Integer);
  public
  end;

var
  frmLoadingOverlayDemo: TfrmLoadingOverlayDemo;

implementation

{$R *.dfm}

{ TProcessoDemoThread }

procedure TProcessoDemoThread.Execute;
begin
  try
    NotificarProgresso('Preparando processamento com TThread...');
    Sleep(1000);

    NotificarProgresso('Executando etapa 1 de 3...');
    Sleep(1200);

    NotificarProgresso('Executando etapa 2 de 3...');
    Sleep(1200);

    NotificarProgresso('Executando etapa 3 de 3...');
    Sleep(1200);

    NotificarProgresso('Finalizando thread...');
    Sleep(800);

    NotificarFinalizacao;
  except
    on E: Exception do
      NotificarErro(E.Message);
  end;
end;

procedure TProcessoDemoThread.NotificarProgresso(const AMensagem: string);
begin
  TThread.Synchronize(
    nil,
    procedure
    begin
      if Assigned(FOnProgresso) then
        FOnProgresso(AMensagem);
    end
  );
end;

procedure TProcessoDemoThread.NotificarFinalizacao;
begin
  TThread.Synchronize(
    nil,
    procedure
    begin
      if Assigned(FOnFinalizar) then
        FOnFinalizar;
    end
  );
end;

procedure TProcessoDemoThread.NotificarErro(const AMensagem: string);
begin
  TThread.Synchronize(
    nil,
    procedure
    begin
      if Assigned(FOnErro) then
        FOnErro(AMensagem);
    end
  );
end;

{ TfrmLoadingOverlayDemo }

procedure TfrmLoadingOverlayDemo.FormCreate(Sender: TObject);
begin
  FLoading := TLoadingOverlayHelper.Create(Self, pnPrincipal);

  mmLog.Clear;

  DefinirStatus('Pronto para executar os exemplos.');

  AdicionarLog('Demo iniciado.');
  AdicionarLog('Escolha um dos três cenários: síncrono, TTask ou TThread.');
end;

procedure TfrmLoadingOverlayDemo.FormDestroy(Sender: TObject);
begin
  FreeAndNil(FLoading);
end;

procedure TfrmLoadingOverlayDemo.AdicionarLog(const AMensagem: string);
begin
  mmLog.Lines.Add(
    FormatDateTime('hh:nn:ss', Now) + ' - ' + AMensagem
  );
end;

procedure TfrmLoadingOverlayDemo.DefinirStatus(const AMensagem: string);
begin
  lblStatus.Caption := 'Status: ' + AMensagem;
end;

procedure TfrmLoadingOverlayDemo.HabilitarBotoes(const AHabilitar: Boolean);
begin
  btnProcessoSync.Enabled := AHabilitar;
  btnProcessoTTask.Enabled := AHabilitar;
  btnProcessoTThread.Enabled := AHabilitar;
end;

procedure TfrmLoadingOverlayDemo.SimularEtapa(
  const ADescricao: string;
  const ATempoMs: Integer);
begin
  AdicionarLog(ADescricao);
  DefinirStatus(ADescricao);

  FLoading.Atualizar(
    'Processando...',
    ADescricao
  );

  Application.ProcessMessages;
  Sleep(ATempoMs);
end;

procedure TfrmLoadingOverlayDemo.btnProcessoSyncClick(Sender: TObject);
begin
  HabilitarBotoes(False);

  FLoading.Mostrar(
    'Processo síncrono',
    'Executando uma rotina curta na thread principal.'
  );

  try
    AdicionarLog('Iniciando processo síncrono.');

    SimularEtapa('Etapa 1 de 3: preparando dados...', 900);
    SimularEtapa('Etapa 2 de 3: processando informações...', 900);
    SimularEtapa('Etapa 3 de 3: atualizando tela...', 900);

    AdicionarLog('Processo síncrono finalizado.');
    DefinirStatus('Processo síncrono concluído.');
  finally
    FLoading.Ocultar;
    HabilitarBotoes(True);
  end;
end;

procedure TfrmLoadingOverlayDemo.btnProcessoTTaskClick(Sender: TObject);
begin
  HabilitarBotoes(False);

  FLoading.Mostrar(
    'Processo com TTask',
    'Executando operação em segundo plano.'
  );

  AdicionarLog('Iniciando processo com TTask.');
  DefinirStatus('Executando TTask...');

  TTask.Run(
    TProc(
      procedure
      begin
        try
          Sleep(1000);

          TThread.Synchronize(
            nil,
            TThreadProcedure(
              procedure
              begin
                FLoading.Atualizar(
                  'Processo com TTask',
                  'Etapa 1 de 3: consultando dados...'
                );

                AdicionarLog('TTask: etapa 1 de 3.');
                DefinirStatus('TTask: etapa 1 de 3.');
              end
            )
          );

          Sleep(1200);

          TThread.Synchronize(
            nil,
            TThreadProcedure(
              procedure
              begin
                FLoading.Atualizar(
                  'Processo com TTask',
                  'Etapa 2 de 3: processando retorno...'
                );

                AdicionarLog('TTask: etapa 2 de 3.');
                DefinirStatus('TTask: etapa 2 de 3.');
              end
            )
          );

          Sleep(1200);

          TThread.Synchronize(
            nil,
            TThreadProcedure(
              procedure
              begin
                FLoading.Atualizar(
                  'Processo com TTask',
                  'Etapa 3 de 3: atualizando interface...'
                );

                AdicionarLog('TTask: etapa 3 de 3.');
                DefinirStatus('TTask: etapa 3 de 3.');
              end
            )
          );

          Sleep(900);

          TThread.Synchronize(
            nil,
            TThreadProcedure(
              procedure
              begin
                try
                  AdicionarLog('Processo com TTask finalizado.');
                  DefinirStatus('Processo com TTask concluído.');
                finally
                  FLoading.Ocultar;
                  HabilitarBotoes(True);
                end;
              end
            )
          );

        except
          on E: Exception do
          begin
            TThread.Synchronize(
              nil,
              TThreadProcedure(
                procedure
                begin
                  FLoading.Ocultar;
                  HabilitarBotoes(True);

                  AdicionarLog('Erro no processo com TTask: ' + E.Message);
                  DefinirStatus('Erro no processo com TTask.');

                  ShowMessage(E.Message);
                end
              )
            );
          end;
        end;
      end
    )
  );
end;

procedure TfrmLoadingOverlayDemo.btnProcessoTThreadClick(Sender: TObject);
var
  lThread: TProcessoDemoThread;
begin
  HabilitarBotoes(False);

  FLoading.Mostrar(
    'Processo com TThread',
    'Executando operação em thread própria.'
  );

  AdicionarLog('Iniciando processo com TThread.');
  DefinirStatus('Executando TThread...');

  lThread := TProcessoDemoThread.Create(True);
  lThread.FreeOnTerminate := True;

  lThread.OnProgresso :=
    procedure(const AMensagem: string)
    begin
      FLoading.Atualizar(
        'Processo com TThread',
        AMensagem
      );

      AdicionarLog('TThread: ' + AMensagem);
      DefinirStatus(AMensagem);
    end;

  lThread.OnFinalizar :=
    procedure
    begin
      try
        AdicionarLog('Processo com TThread finalizado.');
        DefinirStatus('Processo com TThread concluído.');
      finally
        FLoading.Ocultar;
        HabilitarBotoes(True);
      end;
    end;

  lThread.OnErro :=
    procedure(const AMensagem: string)
    begin
      FLoading.Ocultar;
      HabilitarBotoes(True);

      AdicionarLog('Erro no processo com TThread: ' + AMensagem);
      DefinirStatus('Erro no processo com TThread.');

      ShowMessage(AMensagem);
    end;

  lThread.Start;
end;

end.