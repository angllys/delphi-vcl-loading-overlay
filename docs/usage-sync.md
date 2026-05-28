# Uso com processo síncrono

O Loading Overlay pode ser usado em processos síncronos.

Esse modelo é recomendado para operações curtas.

```delphi
FLoading.Mostrar(
  'Processando...',
  'Aguarde enquanto a operação é executada.'
);

try
  Application.ProcessMessages;

  ExecutarProcessoCurto;

finally
  FLoading.Ocultar;
end;
```

Para operações pesadas, prefira `TTask` ou `TThread`.