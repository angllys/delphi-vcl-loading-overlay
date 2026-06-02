# Delphi VCL Loading Overlay

Helper reutilizável de **Loading Overlay** para aplicações **Delphi VCL**.

Este projeto fornece um overlay visual leve, moderno e reutilizável para operações demoradas em sistemas Delphi VCL, especialmente em processos síncronos, `TTask`, `TThread`, chamadas de API, consultas ao banco de dados, sincronizações, exportações, importações, geração de arquivos e carregamento de dados.

O objetivo é melhorar a experiência do usuário e evitar que a aplicação pareça travada durante processos demorados.

> Versão atual: **1.1.0 — Async Support**

---

## Visão geral

Em sistemas desktop VCL, é comum uma rotina estar funcionando corretamente, mas o usuário ter a sensação de que a tela travou por falta de feedback visual.

Este helper resolve esse problema exibindo um overlay semelhante ao comportamento de sistemas web:

- bloqueia visualmente a área principal da tela;
- exibe uma mensagem de processamento;
- mostra uma barra de progresso indeterminada;
- permite atualizar a mensagem durante o processo;
- pode ser reutilizado em qualquer tela VCL;
- agora também pode executar processos assíncronos via `ExecuteAsync`.

---

## Novidade da versão 1.1.0

A versão **1.1.0** adiciona suporte assíncrono ao helper através do método:

```delphi
ExecuteAsync
```

Essa evolução permite executar processos demorados em segundo plano usando `TTask`, mantendo a interface VCL responsiva.

O helper passa a centralizar:

- exibição do overlay;
- execução do processo em background;
- ocultação automática do overlay;
- callback de sucesso;
- callback de erro;
- tratamento visual padronizado para operações demoradas.

---

## Importante: por que a VCL trava?

O overlay melhora a experiência visual, mas ele não impede travamento se o processo pesado for executado diretamente na thread principal.

Em Delphi VCL, qualquer rotina pesada executada na thread principal pode congelar a interface, por exemplo:

- query demorada;
- `FetchAll`;
- importação de arquivo;
- exportação de arquivo;
- geração de relatório;
- processamento em lote;
- cálculo pesado;
- sincronização longa.

Evite este padrão para operações pesadas:

```delphi
FLoading.Mostrar(
  'Carregando...',
  'Aguarde enquanto os dados são carregados.'
);

FDQuery.Open;
FDQuery.FetchAll;

FLoading.Ocultar;
```

O ideal é executar a rotina pesada fora da thread principal, usando `TTask` ou `TThread`.

A versão 1.1.0 facilita isso com `ExecuteAsync`.

---

## Recursos

- Loading overlay reutilizável para formulários Delphi VCL
- Feedback visual moderno, estilo sistemas web
- Classe helper centralizada
- Funciona com processos síncronos
- Funciona com `TTask.Run`
- Funciona com `TThread`
- Suporte a `TThread.Synchronize` e `TThread.Queue`
- Suporte a execução assíncrona via `ExecuteAsync`
- Callback de sucesso
- Callback de erro
- Ideal para APIs, banco de dados, sincronizações e operações demoradas
- Sem dependências externas
- Criado dinamicamente por código
- Pode ser usado em qualquer tela VCL com um container visual, como `TPanel`

---

## Units do projeto

O projeto possui duas units principais:

```text
src/uFrameLoadingOverlay.pas
src/uLoadingOverlayHelper.pas
```

### `uFrameLoadingOverlay.pas`

Componente visual responsável por renderizar o overlay.

Ele contém:

- painel de fundo;
- card central;
- título;
- mensagem principal;
- barra de progresso indeterminada;
- mensagem secundária.

### `uLoadingOverlayHelper.pas`

Classe helper reutilizável responsável por:

- criar o overlay;
- exibir o overlay;
- atualizar mensagens;
- ocultar o overlay;
- controlar posicionamento;
- executar processos assíncronos com `ExecuteAsync`;
- reduzir repetição de código nas telas.

---

## Modos de posicionamento

A classe `TLoadingOverlayHelper` suporta dois modos de posicionamento:

```delphi
TLoadingOverlayPositionMode = (
  lopAlignClient,
  lopAbsolute
);
```

### `lopAlignClient`

Modo padrão.

O overlay é alinhado com `alClient` dentro do container informado.

Uso recomendado para telas simples:

```delphi
FLoading := TLoadingOverlayHelper.Create(Self, pnPrincipal);
```

### `lopAbsolute`

Modo alternativo para telas onde o overlay precisa ficar acima de painéis e componentes específicos.

Uso recomendado quando o overlay aparece atrás de outros componentes:

```delphi
FLoading := TLoadingOverlayHelper.Create(
  Self,
  pnPrincipal,
  lopAbsolute
);
```

---

## Cenários de uso suportados

O helper pode ser usado em quatro cenários principais:

1. Processo síncrono;
2. Processo com `TTask`;
3. Processo com `TThread`;
4. Processo com `ExecuteAsync`.

O overlay em si não depende de `TTask` nem de `TThread`. Ele é um helper visual.

Para operações demoradas, porém, é recomendado usar `ExecuteAsync`, `TTask` ou `TThread` para manter a interface VCL responsiva.

---

## Como usar

Adicione a unit do helper no formulário:

```delphi
uses
  uLoadingOverlayHelper;
```

Declare um campo privado:

```delphi
private
  FLoading: TLoadingOverlayHelper;
```

Crie o helper no `FormCreate`, informando o painel principal da tela:

```delphi
procedure TMinhaTela.FormCreate(Sender: TObject);
begin
  FLoading := TLoadingOverlayHelper.Create(Self, pnPrincipal);
end;
```

Libere o helper no `FormDestroy`:

```delphi
procedure TMinhaTela.FormDestroy(Sender: TObject);
begin
  FreeAndNil(FLoading);
end;
```

Para exibir o overlay:

```delphi
FLoading.Mostrar(
  'Carregando...',
  'Aguarde enquanto o sistema processa as informações.'
);
```

Para atualizar a mensagem:

```delphi
FLoading.Atualizar(
  'Atualizando grade...',
  'Finalizando operação.'
);
```

Para ocultar:

```delphi
FLoading.Ocultar;
```

---

## Exemplo 1 — Processo síncrono

Use este modelo apenas para processos curtos.

```delphi
procedure TMinhaTela.ExecutarProcessoSincrono;
begin
  FLoading.Mostrar(
    'Processando...',
    'Aguarde enquanto a operação é executada.'
  );

  try
    Application.ProcessMessages;

    // Processo curto executado na thread principal
    Sleep(1500);

    FLoading.Atualizar(
      'Finalizando...',
      'Atualizando a interface.'
    );

    Application.ProcessMessages;
  finally
    FLoading.Ocultar;
  end;
end;
```

Este cenário é indicado para rotinas pequenas.

Para processos pesados, prefira `ExecuteAsync`, `TTask` ou `TThread`.

---

## Exemplo 2 — Processo com TTask

Use este modelo para chamadas de API, consultas de banco, sincronizações, carregamento de `TFDMemTable` ou processos que não devem travar a interface.

```delphi
procedure TMinhaTela.ExecutarComTTask;
begin
  FLoading.Mostrar(
    'Carregando dados...',
    'Aguarde enquanto o sistema processa a solicitação.'
  );

  TTask.Run(
    procedure
    begin
      try
        // Processo demorado fora da thread principal
        Sleep(3000);

        TThread.Queue(
          nil,
          procedure
          begin
            try
              FLoading.Atualizar(
                'Atualizando interface...',
                'Carregando os dados na tela.'
              );

              // Atualização segura da interface
            finally
              FLoading.Ocultar;
            end;
          end
        );

      except
        on E: Exception do
        begin
          TThread.Queue(
            nil,
            procedure
            begin
              FLoading.Ocultar;
              ShowMessage(E.Message);
            end
          );
        end;
      end;
    end
  );
end;
```

---

## Exemplo 3 — Processo com TThread

Use este modelo quando precisar de mais controle sobre a execução em segundo plano.

```delphi
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

procedure TExemploThread.Execute;
begin
  try
    // Processo demorado
    Sleep(3000);

    TThread.Queue(
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
      TThread.Queue(
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
```

Uso na tela:

```delphi
procedure TMinhaTela.ExecutarComTThread;
var
  LThread: TExemploThread;
begin
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
        FLoading.Atualizar(
          'Finalizando...',
          'Atualizando a interface.'
        );

        // Atualização segura da interface
      finally
        FLoading.Ocultar;
      end;
    end;

  LThread.OnErro :=
    procedure(const AMensagem: string)
    begin
      FLoading.Ocultar;
      ShowMessage(AMensagem);
    end;

  LThread.Start;
end;
```

---

## Exemplo 4 — ExecuteAsync

A forma mais simples da versão 1.1.0 é usar `ExecuteAsync`.

```delphi
FLoading.ExecuteAsync(
  'Gerando relatório...',
  'Aguarde enquanto os dados são processados.',
  procedure
  begin
    // Processo pesado fora da thread principal
    GerarRelatorioPesado;
  end,
  procedure
  begin
    ShowMessage('Relatório gerado com sucesso!');
  end,
  procedure(const AErro: string)
  begin
    ShowMessage('Erro ao gerar relatório: ' + AErro);
  end
);
```

O helper faz automaticamente:

- mostra o overlay;
- executa o processo em `TTask`;
- oculta o overlay ao finalizar;
- chama o callback de sucesso;
- chama o callback de erro em caso de exceção.

---

## Exemplo 5 — ExecuteAsync com erro tratado

```delphi
FLoading.ExecuteAsync(
  'Processando...',
  'Simulando uma falha durante a execução.',
  procedure
  begin
    Sleep(2000);
    raise Exception.Create('Erro de teste.');
  end,
  procedure
  begin
    ShowMessage('Processo concluído.');
  end,
  procedure(const AErro: string)
  begin
    ShowMessage('Erro capturado: ' + AErro);
  end
);
```

---

## Parent recomendado

O overlay deve ser criado sobre um container visual real, preferencialmente o painel principal da tela.

Exemplo:

```delphi
FLoading := TLoadingOverlayHelper.Create(Self, pnPrincipal);
```

Containers recomendados:

- `TPanel`;
- `TScrollBox`;
- `TTabSheet`;
- painel principal de conteúdo da tela.

Evite usar diretamente o próprio formulário como parent quando a tela for aberta embutida dentro de outro formulário ou container, a menos que esteja usando um cenário simples e controlado.

---

## Boas práticas

Para processos pesados:

- não execute queries demoradas na thread principal;
- não acesse componentes visuais diretamente dentro de `TTask` ou `TThread`;
- use `TThread.Queue` ou callbacks para atualizar a interface;
- em processos com banco de dados, use conexão própria para a thread;
- sempre trate exceções;
- sempre oculte o overlay ao finalizar ou falhar.

---

## Casos de uso

Este helper é útil para:

- chamadas de API;
- consultas ao banco de dados;
- carga de `TFDMemTable`;
- sincronizações;
- importação de arquivos;
- exportação de arquivos;
- geração de relatórios;
- processamento de folha;
- atualização de banco;
- rotinas em lote;
- cálculos demorados;
- processos executados em segundo plano.

---

## Estrutura do projeto

```text
delphi-vcl-loading-overlay/
│
├── README.md
├── CHANGELOG.md
├── LICENSE
├── .gitignore
│
├── src/
│   ├── uFrameLoadingOverlay.pas
│   └── uLoadingOverlayHelper.pas
│
└── demo/
    └── LoadingOverlayDemo/
        ├── LoadingOverlayDemo.dpr
        ├── LoadingOverlayDemo.dproj
        ├── ufrmLoadingOverlayDemo.pas
        └── ufrmLoadingOverlayDemo.dfm
```

---

## Demo

O projeto acompanha um demo VCL com quatro cenários:

1. Processo síncrono;
2. Processo com `TTask`;
3. Processo com `TThread`;
4. Processo com `ExecuteAsync`.

O objetivo do demo é mostrar a diferença entre apenas exibir feedback visual e executar corretamente operações demoradas fora da thread principal.

---

## Requisitos

- Delphi VCL
- Windows
- Nenhum componente de terceiros

---

## Licença

Este projeto está licenciado sob a licença MIT.

---

## Autor

Desenvolvido por **Angllys Bandeira Soares**.

Desenvolvedor Delphi com foco em arquitetura backend, integração com banco de dados, Firebird, performance, sistemas corporativos e engines de processamento.
