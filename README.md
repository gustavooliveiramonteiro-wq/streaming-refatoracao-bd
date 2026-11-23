# Sprint de Refatoração — Plataforma de Streaming

Exercício 6 · CDD1 · SENAC SP · Gustavo Oliveira Monteiro

**Problema:** a tabela `Visualizacoes` cresce milhões de linhas por dia e guarda título, sinopse e categoria do filme em texto puro a cada play.
**Solução:** normalização (3FN) em `usuario`, `filme`, `categoria`, `filme_categoria`, `dispositivo` e `visualizacao` (só IDs), com índices para as consultas mais usadas.

## Como rodar (MySQL 8 / Workbench)

Execute na ordem:

| Arquivo | O que faz |
|---|---|
| `sql/01_legado.sql` | Cria a tabela original com os problemas e dados de exemplo |
| `sql/02_ddl_refatorado.sql` | Cria o modelo normalizado (PKs, FKs, UNIQUE, CHECK) |
| `sql/03_indices.sql` | Cria os índices |
| `sql/04_dml_migracao.sql` | Migra e padroniza os dados do legado; confere as contagens |
| `sql/05_dml_operacoes.sql` | Inserções, atualizações e consultas no novo modelo |

## Modelo novo

```
usuario 1──N visualizacao N──1 filme N──N categoria (via filme_categoria)
                  │
                  N──1 dispositivo
```

## Participante

**Gustavo Oliveira Monteiro** — atuou como Product Owner / Revisor e Scrum Master / Desenvolvedor.

## Fluxo de branches

| Branch | Pull Request | Conteúdo |
|---|---|---|
| `main` | — | só recebe código via Pull Request revisado |
| `feature/legado` | #1 | `01_legado.sql` |
| `feature/ddl-normalizacao` | #2 | `02_ddl_refatorado.sql` |
| `feature/indices` | #3 | `03_indices.sql` |
| `feature/dml-migracao` | #4 | `04_dml_migracao.sql` + `05_dml_operacoes.sql` |
| `docs/relatorio-sprint` | #5 | README, backlog e relatório da sprint |
