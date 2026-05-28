# Uso com TThread

`TThread` é útil quando você precisa de mais controle sobre a execução em segundo plano.

Esse modelo é recomendado para processos longos, controlados ou já existentes em sistemas legados.

```delphi
FLoading.Mostrar(
  'Processando...',
  'Aguarde enquanto a thread executa a operação.'
);

LThread := TExemploThread.Create(True);
LThread.FreeOnTerminate := True;

LThread.OnFinalizar :=
  procedure
  begin
    try
      AtualizarInterface;
    finally
      FLoading.Ocultar;
    end;
  end;

LThread.Start;
```