-- =====================================================================
-- 03_indices.sql  |  ÍNDICES PARA AS CONSULTAS MAIS FREQUENTES
-- SGBD: MySQL 8
-- =====================================================================

USE streaming;

-- "Continuar assistindo" / histórico do usuário (filtra usuário, ordena por data)
CREATE INDEX idx_vis_usuario_data ON visualizacao (id_usuario, data_hora_inicio);

-- Ranking / audiência de um filme num período
CREATE INDEX idx_vis_filme_data ON visualizacao (id_filme, data_hora_inicio);

-- Relatórios diários gerais (plays por dia, por dispositivo)
CREATE INDEX idx_vis_data ON visualizacao (data_hora_inicio);

-- Busca no catálogo por categoria (o PK de filme_categoria cobre o filme)
CREATE INDEX idx_fc_categoria ON filme_categoria (id_categoria);

-- Observação: as FKs de visualizacao já ficam cobertas pelos índices
-- compostos acima (coluna da FK na primeira posição), exceto dispositivo:
CREATE INDEX idx_vis_dispositivo ON visualizacao (id_dispositivo);
