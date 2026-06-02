# Changelog

Todas as alterações relevantes deste projeto serão documentadas neste arquivo.

O formato segue uma estrutura simples baseada em versões semânticas.

---

## [1.1.0] - 2026-06-02

### Added

- Adicionado suporte assíncrono ao helper através do método `ExecuteAsync`.
- Adicionada execução de processos em background usando `TTask`.
- Adicionado callback de sucesso para execução assíncrona.
- Adicionado callback de erro para execução assíncrona.
- Adicionado exemplo no demo para o novo botão `Async Helper`.
- Adicionado suporte a cenários onde o helper mostra o overlay, executa o processo e oculta automaticamente ao finalizar.
- Adicionada documentação explicando por que aplicações Delphi VCL travam quando processos pesados rodam na thread principal.
- Adicionado exemplo de uso do `ExecuteAsync` para processos demorados.
- Adicionado exemplo de tratamento de erro com `ExecuteAsync`.

### Changed

- Atualizada a `uLoadingOverlayHelper.pas` para incluir métodos de execução assíncrona.
- Atualizado o demo para apresentar quatro cenários:
  - processo síncrono;
  - processo com `TTask`;
  - processo com `TThread`;
  - processo com `ExecuteAsync`.
- Atualizado o README com explicações mais completas sobre uso síncrono e assíncrono.
- Atualizada a documentação para deixar claro que o overlay visual não impede travamento se o processo pesado rodar na thread principal.

### Improved

- Melhorada a orientação de uso do helper em cenários reais de sistemas Delphi VCL.
- Melhorada a separação conceitual entre feedback visual e execução em background.
- Melhorado o exemplo prático para demonstrar UI responsiva durante processos demorados.
- Melhorado o tratamento de erro em processos assíncronos.
- Melhorada a clareza sobre uso recomendado com APIs, queries, importações, exportações, geração de arquivos e processamento em lote.

### Notes

- O overlay continua podendo ser usado em processos síncronos curtos.
- Para processos demorados, o recomendado é usar `ExecuteAsync`, `TTask` ou `TThread`.
- O overlay por si só não impede travamento da VCL caso a rotina pesada seja executada diretamente na thread principal.
- Em processos com banco de dados dentro de threads, recomenda-se utilizar conexão própria para a thread.

---

## [1.0.0] - 2026-05-21

### Added

- Primeira versão do Delphi VCL Loading Overlay.
- Adicionado frame visual reutilizável `TFrameLoadingOverlay`.
- Adicionada classe helper `TLoadingOverlayHelper`.
- Adicionado suporte para exibir, atualizar e ocultar overlay.
- Adicionado exemplo de uso com processo síncrono.
- Adicionado exemplo de uso com `TTask`.
- Adicionado exemplo de uso com `TThread`.
- Adicionado demo inicial em Delphi VCL.
- Adicionada documentação inicial do projeto.
- Adicionada licença MIT.

### Features

- Overlay visual moderno para aplicações Delphi VCL.
- Mensagem principal de processamento.
- Mensagem secundária.
- Barra de progresso indeterminada.
- Criação dinâmica por código.
- Uso com container visual, como `TPanel`.
- Sem dependências externas.

### Notes

- A versão 1.0.0 teve foco principal no feedback visual e na reutilização do overlay entre telas VCL.
