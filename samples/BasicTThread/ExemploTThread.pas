unit ExemploTThread;

interface

uses
  System.SysUtils,
  System.Classes,
  Vcl.Forms,
  Vcl.Controls,
  Vcl.ExtCtrls,
  Vcl.StdCtrls,
  uLoadingOverlayHelper;

type
  TExemploThread = class(TThread)
  private
    FOnFinalizar: TProc;
    FOnErro: TProc<string>;
  protected
    procedure Execute; override;
  public
    property OnFinalizar: TProc read FOnFinalizar write FOnFinalizar;
    property OnErro: TProc<string> read FOnErro write FOnErro;
  end;

  TfrmExemploTThread = class(TForm)
    pnPrincipal: TPanel;
    btnExecutar: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnExecutarClick(Sender: TObject);
  private
    FLoading: TLoadingOverlayHelper;
  end;

implementation

{$R *.dfm}

{ TExemploThread }

procedure TExemploThread.Execute;
begin
  try
    // Simula um processo demorado executado em thread própria.
    Sleep(3000);

    TThread.Synchronize(
      nil,
      procedure
      begin
        if Assigned(FOnFinalizar) then
          FOnFinalizar;
      end
    );

  except
    on E: Exception do
    begin
      TThread.Synchronize(
        nil,
        procedure
        begin
          if Assigned(FOnErro) then
            FOnErro(E.Message);
        end
      );
    end;
  end;
end;

{ TfrmExemploTThread }

procedure TfrmExemploTThread.FormCreate(Sender: TObject);
begin
  FLoading := TLoadingOverlayHelper.Create(Self, pnPrincipal);
end;

procedure TfrmExemploTThread.FormDestroy(Sender: TObject);
begin
  FreeAndNil(FLoading);
end;

procedure TfrmExemploTThread.btnExecutarClick(Sender: TObject);
var
  lThread: TExemploThread;
begin
  btnExecutar.Enabled := False;

  FLoading.Mostrar(
    'Processando...',
    'Executando processo em segundo plano com TThread.'
  );

  lThread := TExemploThread.Create(True);
  lThread.FreeOnTerminate := True;

  lThread.OnFinalizar :=
    procedure
    begin
      try
        FLoading.Atualizar(
          'Finalizando...',
          'Atualizando a interface.'
        );

        ShowMessage('Processo com TThread concluído com sucesso.');
      finally
        FLoading.Ocultar;
        btnExecutar.Enabled := True;
      end;
    end;

  lThread.OnErro :=
    procedure(const AMensagem: string)
    begin
      FLoading.Ocultar;
      btnExecutar.Enabled := True;

      ShowMessage(
        'Erro ao executar processo com TThread:' + sLineBreak +
        AMensagem
      );
    end;

  lThread.Start;
end;

end.