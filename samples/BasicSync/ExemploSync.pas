unit ExemploSync;

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
  TfrmExemploSync = class(TForm)
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

procedure TfrmExemploSync.FormCreate(Sender: TObject);
begin
  FLoading := TLoadingOverlayHelper.Create(Self, pnPrincipal);
end;

procedure TfrmExemploSync.FormDestroy(Sender: TObject);
begin
  FreeAndNil(FLoading);
end;

procedure TfrmExemploSync.btnExecutarClick(Sender: TObject);
begin
  btnExecutar.Enabled := False;

  FLoading.Mostrar(
    'Processando...',
    'Executando processo síncrono.'
  );

  try
    Application.ProcessMessages;

    // Simula um processo curto executado na thread principal.
    Sleep(1500);

    FLoading.Atualizar(
      'Finalizando...',
      'Atualizando a interface.'
    );

    Application.ProcessMessages;

    ShowMessage('Processo síncrono concluído com sucesso.');
  finally
    FLoading.Ocultar;
    btnExecutar.Enabled := True;
  end;
end;

end.