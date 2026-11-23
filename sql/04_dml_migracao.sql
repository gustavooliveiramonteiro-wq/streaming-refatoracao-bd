-- =====================================================================
-- 04_dml_migracao.sql  |  MIGRA OS DADOS DA TABELA LEGADA PARA O NOVO MODELO
-- Rodar depois de 01, 02 e 03. Faz a limpeza (padronização) no caminho.
-- SGBD: MySQL 8
-- =====================================================================

USE streaming;

-- 1) Categorias: padroniza grafias diferentes para um nome único
INSERT INTO categoria (nome) VALUES ('Ficção Científica'), ('Comédia'), ('Suspense');

-- 2) Dispositivos: padroniza "smart tv", "SmartTV" etc.
INSERT INTO dispositivo (tipo) VALUES ('Smart TV'), ('Celular'), ('Notebook');

-- 3) Usuários: um registro por e-mail
INSERT INTO usuario (nome, email)
SELECT MIN(usuario_nome), LOWER(TRIM(usuario_email))
FROM Visualizacoes
GROUP BY LOWER(TRIM(usuario_email));

-- 4) Filmes: um registro por título (sinopse guardada uma vez)
INSERT INTO filme (titulo, sinopse)
SELECT titulo_filme, MAX(sinopse)
FROM Visualizacoes
GROUP BY titulo_filme;

-- 5) Filme x categoria (mapeia o texto livre para a categoria padrão)
INSERT INTO filme_categoria (id_filme, id_categoria)
SELECT DISTINCT f.id_filme, c.id_categoria
FROM Visualizacoes v
JOIN filme f ON f.titulo = v.titulo_filme
JOIN categoria c ON c.nome = CASE
        WHEN LOWER(v.categoria) LIKE 'fic%'     THEN 'Ficção Científica'
        WHEN LOWER(v.categoria) LIKE 'com%'     THEN 'Comédia'
        WHEN LOWER(v.categoria) LIKE 'suspense' THEN 'Suspense'
     END;

-- 6) Plays: só IDs + data convertida de texto para DATETIME
INSERT INTO visualizacao (id_usuario, id_filme, id_dispositivo, data_hora_inicio, segundos_assistidos)
SELECT u.id_usuario,
       f.id_filme,
       d.id_dispositivo,
       CAST(v.data_play AS DATETIME),
       COALESCE(v.tempo_assistido, 0)
FROM Visualizacoes v
JOIN usuario u ON u.email = LOWER(TRIM(v.usuario_email))
JOIN filme   f ON f.titulo = v.titulo_filme
JOIN dispositivo d ON d.tipo = CASE
        WHEN LOWER(REPLACE(v.dispositivo, ' ', '')) = 'smarttv' THEN 'Smart TV'
        ELSE v.dispositivo
     END;

-- 7) Conferência: as contagens precisam bater antes de apagar o legado
SELECT (SELECT COUNT(*) FROM Visualizacoes) AS plays_legado,
       (SELECT COUNT(*) FROM visualizacao)  AS plays_novo;

-- 8) Só depois de conferido e aprovado no PR:
-- DROP TABLE Visualizacoes;
