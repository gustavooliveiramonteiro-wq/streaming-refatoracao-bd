# Backlog da Sprint

Listas do quadro: **Backlog → Sprint Backlog → Em andamento → Em revisão (PR) → Concluído**
Estimativa em Story Points (Fibonacci).

| # | User Story | Critério de aceite | Prioridade | SP |
|---|---|---|---|---|
| US01 | Como **DBA**, quero documentar a tabela legada e seus problemas, para justificar a refatoração | `01_legado.sql` roda e os problemas estão comentados | Alta | 2 |
| US02 | Como **time de dados**, quero o catálogo (filme e categoria) separado dos plays, para não repetir título/sinopse a cada play | Tabelas `filme`, `categoria`, `filme_categoria` com PK/FK/UNIQUE | Alta | 5 |
| US03 | Como **time de dados**, quero usuários e dispositivos em tabelas próprias, para eliminar dados repetidos e grafias diferentes | `usuario` (e-mail único) e `dispositivo` (tipo único) | Alta | 3 |
| US04 | Como **plataforma**, quero que `visualizacao` guarde só IDs e use BIGINT, para suportar milhões de linhas/dia | PK BIGINT, FKs, data em DATETIME, CHECK de segundos | Alta | 3 |
| US05 | Como **usuário**, quero que meu histórico e "continuar assistindo" carreguem rápido | Índices `(id_usuario, data)`, `(id_filme, data)`, `(data)` | Média | 3 |
| US06 | Como **DBA**, quero migrar os dados legados padronizando categorias e dispositivos, sem perder plays | `04_dml_migracao.sql`: contagem legado = contagem novo | Alta | 5 |
| US07 | Como **equipe**, quero scripts de inserção/atualização no novo modelo | `05_dml_operacoes.sql` roda sem erro | Média | 2 |
| US08 | Como **equipe**, quero o repositório com branches e PRs revisados | 1 PR por feature, revisado antes do merge | Alta | 2 |
| US09 | Como **professora**, quero um relatório com problemas, soluções e retrospectiva | Relatório entregue | Média | 2 |

**Total da sprint:** 27 SP

## Ordem da sprint (dependências)
US01 → US02 + US03 → US04 → US05 → US06 → US07 → US08 (contínuo) → US09

