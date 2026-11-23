-- =====================================================================
-- 02_ddl_refatorado.sql  |  NOVA ESTRUTURA NORMALIZADA (3FN)
-- Regra aplicada: o catálogo (filme, categoria) e os usuários são
-- guardados UMA vez; a tabela de plays guarda só IDs + fatos do play.
-- SGBD: MySQL 8 (InnoDB)
-- =====================================================================

USE streaming;

DROP TABLE IF EXISTS visualizacao;
DROP TABLE IF EXISTS filme_categoria;
DROP TABLE IF EXISTS filme;
DROP TABLE IF EXISTS categoria;
DROP TABLE IF EXISTS dispositivo;
DROP TABLE IF EXISTS usuario;

-- Usuários: dados pessoais saem da tabela de plays
CREATE TABLE usuario (
    id_usuario     INT AUTO_INCREMENT PRIMARY KEY,
    nome           VARCHAR(100) NOT NULL,
    email          VARCHAR(150) NOT NULL,
    data_cadastro  DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uq_usuario_email UNIQUE (email)
);

-- Categorias padronizadas (fim do texto livre "Ação"/"acao")
CREATE TABLE categoria (
    id_categoria   SMALLINT AUTO_INCREMENT PRIMARY KEY,
    nome           VARCHAR(60) NOT NULL,
    CONSTRAINT uq_categoria_nome UNIQUE (nome)
);

-- Catálogo: título e sinopse guardados uma única vez por filme
CREATE TABLE filme (
    id_filme        INT AUTO_INCREMENT PRIMARY KEY,
    titulo          VARCHAR(200) NOT NULL,
    sinopse         TEXT,
    ano_lancamento  SMALLINT,
    duracao_min     SMALLINT,
    CONSTRAINT uq_filme_titulo UNIQUE (titulo)
);

-- N:N — um filme pode ter várias categorias (Ação + Aventura)
CREATE TABLE filme_categoria (
    id_filme       INT NOT NULL,
    id_categoria   SMALLINT NOT NULL,
    PRIMARY KEY (id_filme, id_categoria),
    CONSTRAINT fk_fc_filme     FOREIGN KEY (id_filme)     REFERENCES filme (id_filme)         ON DELETE CASCADE,
    CONSTRAINT fk_fc_categoria FOREIGN KEY (id_categoria) REFERENCES categoria (id_categoria) ON DELETE RESTRICT
);

-- Tipos de dispositivo padronizados
CREATE TABLE dispositivo (
    id_dispositivo SMALLINT AUTO_INCREMENT PRIMARY KEY,
    tipo           VARCHAR(30) NOT NULL,
    CONSTRAINT uq_dispositivo_tipo UNIQUE (tipo)
);

-- Tabela de fatos (a que cresce milhões/dia): só IDs e dados do play.
-- BIGINT na PK evita estouro; linha fica pequena e de tamanho fixo.
CREATE TABLE visualizacao (
    id_visualizacao     BIGINT AUTO_INCREMENT PRIMARY KEY,
    id_usuario          INT NOT NULL,
    id_filme            INT NOT NULL,
    id_dispositivo      SMALLINT NOT NULL,
    data_hora_inicio    DATETIME NOT NULL,
    segundos_assistidos INT NOT NULL DEFAULT 0,
    CONSTRAINT fk_vis_usuario     FOREIGN KEY (id_usuario)     REFERENCES usuario (id_usuario),
    CONSTRAINT fk_vis_filme       FOREIGN KEY (id_filme)       REFERENCES filme (id_filme),
    CONSTRAINT fk_vis_dispositivo FOREIGN KEY (id_dispositivo) REFERENCES dispositivo (id_dispositivo),
    CONSTRAINT ck_vis_segundos    CHECK (segundos_assistidos >= 0)
);
