# Uso com TTask

`TTask` é uma abordagem moderna e prática para executar processos em segundo plano em aplicações Delphi VCL.

```delphi
FLoading.Mostrar(
  'Carregando...',
  'Aguarde enquanto a tarefa em segundo plano é executada.'
);

TTask.Run(
  TProc(
    procedure
    begin
      try
        ExecutarProcessoEmSegundoPlano;

        TThread.Synchronize(
          nil,
          TThreadProcedure(
            procedure
            begin
              try
                AtualizarInterface;
              finally
                FLoading.Ocultar;
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
                ShowMessage(E.Message);
              end
            )
          );
        end;
      end;
    end
  )
);
```