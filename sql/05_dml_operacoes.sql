-- =====================================================================
-- 05_dml_operacoes.sql  |  INSERÇÃO / ATUALIZAÇÃO NO NOVO MODELO
-- Mostra como o dia a dia fica depois da refatoração.
-- SGBD: MySQL 8
-- =====================================================================

USE streaming;

-- Cadastrar um filme novo (1 vez no catálogo) com duas categorias
INSERT INTO categoria (nome) VALUES ('Aventura');
INSERT INTO filme (titulo, sinopse, ano_lancamento, duracao_min)
VALUES ('Trilha Perdida', 'Um grupo de amigos se perde na Serra da Mantiqueira.', 2026, 105);

INSERT INTO filme_categoria (id_filme, id_categoria)
SELECT f.id_filme, c.id_categoria
FROM filme f, categoria c
WHERE f.titulo = 'Trilha Perdida' AND c.nome IN ('Aventura', 'Suspense');

-- Registrar um play: agora a linha leva só IDs (poucos bytes)
INSERT INTO visualizacao (id_usuario, id_filme, id_dispositivo, data_hora_inicio, segundos_assistidos)
SELECT u.id_usuario, f.id_filme, d.id_dispositivo, '2026-11-23 19:00:00', 2400
FROM usuario u, filme f, dispositivo d
WHERE u.email = 'ana@email.com' AND f.titulo = 'Trilha Perdida' AND d.tipo = 'Smart TV';

-- Corrigir a sinopse: 1 linha atualizada (antes eram milhões)
UPDATE filme
SET sinopse = 'Um detetive aposentado volta à ativa para resolver o caso que encerrou sua carreira.'
WHERE titulo = 'A Caçada';

-- Atualizar o progresso de um play (usuário continuou assistindo)
UPDATE visualizacao
SET segundos_assistidos = 3600
WHERE id_visualizacao = 1;

-- Consulta de validação: reconstrói a visão "antiga" com JOINs
SELECT v.id_visualizacao, u.nome, f.titulo, c.nome AS categoria,
       d.tipo AS dispositivo, v.data_hora_inicio, v.segundos_assistidos
FROM visualizacao v
JOIN usuario u          ON u.id_usuario = v.id_usuario
JOIN filme f            ON f.id_filme = v.id_filme
JOIN filme_categoria fc ON fc.id_filme = f.id_filme
JOIN categoria c        ON c.id_categoria = fc.id_categoria
JOIN dispositivo d      ON d.id_dispositivo = v.id_dispositivo
ORDER BY v.data_hora_inicio;

-- Top filmes do período (usa idx_vis_filme_data / idx_vis_data)
SELECT f.titulo, COUNT(*) AS plays, SUM(v.segundos_assistidos) / 3600 AS horas
FROM visualizacao v
JOIN filme f ON f.id_filme = v.id_filme
WHERE v.data_hora_inicio >= '2026-11-20' AND v.data_hora_inicio < '2026-11-24'
GROUP BY f.titulo
ORDER BY plays DESC;
