unit ExemploTTask;

interface

uses
  System.SysUtils,
  System.Classes,
  System.Threading,
  Vcl.Forms,
  Vcl.Controls,
  Vcl.ExtCtrls,
  Vcl.StdCtrls,
  uLoadingOverlayHelper;

type
  TfrmExemploTTask = class(TForm)
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

procedure TfrmExemploTTask.FormCreate(Sender: TObject);
begin
  FLoading := TLoadingOverlayHelper.Create(Self, pnPrincipal);
end;

procedure TfrmExemploTTask.FormDestroy(Sender: TObject);
begin
  FreeAndNil(FLoading);
end;

procedure TfrmExemploTTask.btnExecutarClick(Sender: TObject);
begin
  btnExecutar.Enabled := False;

  FLoading.Mostrar(
    'Processando...',
    'Executando processo em segundo plano com TTask.'
  );

  TTask.Run(
    TProc(
      procedure
      begin
        try
          // Simula um processo demorado fora da thread principal.
          Sleep(3000);

          TThread.Synchronize(
            nil,
            TThreadProcedure(
              procedure
              begin
                try
                  FLoading.Atualizar(
                    'Finalizando...',
                    'Atualizando a interface.'
                  );

                  ShowMessage('Processo com TTask concluído com sucesso.');
                finally
                  FLoading.Ocultar;
                  btnExecutar.Enabled := True;
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
                  btnExecutar.Enabled := True;

                  ShowMessage(
                    'Erro ao executar processo com TTask:' + sLineBreak +
                    E.Message
                  );
                end
              )
            );
          end;
        end;
      end
    )
  );
end;

end.