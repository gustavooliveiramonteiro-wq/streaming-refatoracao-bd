-- =====================================================================
-- 01_legado.sql  |  ESTADO ORIGINAL (ANTES DA REFATORAÇÃO)
-- Cenário: Plataforma de Streaming
-- Problema: a tabela Visualizacoes cresce milhões de linhas/dia e repete
-- título, sinopse e categoria do filme (texto puro) a cada play.
-- SGBD: MySQL 8
-- =====================================================================

CREATE DATABASE IF NOT EXISTS streaming;
USE streaming;

DROP TABLE IF EXISTS Visualizacoes;

CREATE TABLE Visualizacoes (
    id              INT AUTO_INCREMENT PRIMARY KEY,  -- INT estoura em ~2,1 bilhões
    usuario_nome    VARCHAR(100),                    -- dado do usuário repetido
    usuario_email   VARCHAR(150),                    -- dado do usuário repetido
    titulo_filme    VARCHAR(200),                    -- repetido a cada play
    sinopse         TEXT,                            -- TEXT repetido = muito espaço
    categoria       VARCHAR(100),                    -- texto livre: "Ação", "acao", "Ação, Aventura"
    dispositivo     VARCHAR(50),                     -- texto livre: "TV", "smart tv", "SmartTV"
    data_play       VARCHAR(20),                     -- data guardada como texto
    tempo_assistido INT                              -- sem unidade definida
);

-- Amostra de dados com os problemas típicos (duplicação e inconsistência)
INSERT INTO Visualizacoes (usuario_nome, usuario_email, titulo_filme, sinopse, categoria, dispositivo, data_play, tempo_assistido) VALUES
('Ana Souza',  'ana@email.com',   'O Último Horizonte', 'Uma astronauta precisa escolher entre voltar para casa ou salvar a tripulação.', 'Ficção Científica', 'Smart TV', '2026-11-20 20:15:00', 5400),
('Ana Souza',  'ana@email.com',   'O Último Horizonte', 'Uma astronauta precisa escolher entre voltar para casa ou salvar a tripulação.', 'Ficção Científica', 'smart tv', '2026-11-21 21:00:00', 1200),
('Carlos Lima','carlos@email.com','O Último Horizonte', 'Uma astronauta precisa escolher entre voltar para casa ou salvar a tripulação.', 'ficcao cientifica', 'Celular',  '2026-11-21 08:30:00', 600),
('Carlos Lima','carlos@email.com','Risos no Metrô',     'Três amigos ficam presos no metrô de SP durante uma madrugada.',                 'Comédia',           'Celular',  '2026-11-21 09:10:00', 3600),
('Beatriz Reis','bia@email.com',  'Risos no Metrô',     'Três amigos ficam presos no metrô de SP durante uma madrugada.',                 'Comedia',           'Notebook', '2026-11-22 22:45:00', 3000),
('Beatriz Reis','bia@email.com',  'A Caçada',           'Um detetive aposentado volta à ativa para resolver um último caso.',             'Suspense',          'SmartTV',  '2026-11-22 23:50:00', 6300),
('Ana Souza',  'ana@email.com',   'A Caçada',           'Um detetive aposentado volta à ativa para resolver um último caso.',             'suspense',          'Celular',  '2026-11-23 07:05:00', 900);

-- Exemplo do custo de manutenção: corrigir a sinopse de UM filme
-- exige atualizar TODAS as linhas de play daquele filme (milhões).
-- UPDATE Visualizacoes SET sinopse = 'nova sinopse' WHERE titulo_filme = 'A Caçada';
