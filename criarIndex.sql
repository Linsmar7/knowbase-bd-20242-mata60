-- Índices nas chaves estrangeiras
CREATE INDEX idx_ce_id_submissao ON tbl_avaliacao(ce_id_submissao);
CREATE INDEX idx_ce_id_membro ON tbl_avaliacao(ce_id_membro);
CREATE INDEX idx_ce_id_evento ON tbl_submissao(ce_id_evento);
CREATE INDEX idx_ce_id_artigo ON tbl_submissao(ce_id_artigo);
CREATE INDEX idx_ce_id_instituicao ON tbl_membro(ce_id_instituicao);
CREATE INDEX idx_ce_id_palavra_chave ON tbl_submissao_palavra_chave(ce_id_palavra_chave);

-- Índices para campos frequentemente usados em filtros
CREATE INDEX idx_status_submissao ON tbl_submissao(status);
CREATE INDEX idx_data_submissao ON tbl_submissao(data_submissao);
CREATE INDEX idx_data_evento ON tbl_evento(data);
CREATE INDEX idx_status_avaliacao ON tbl_avaliacao(status);
CREATE INDEX idx_nome_instituicao ON tbl_instituicao(nome);
CREATE INDEX idx_nome_submissao ON tbl_submissao(titulo);

-- Índices para relatórios
CREATE INDEX idx_submissao_autor ON tbl_autor_submissao(ce_id_membro, ce_id_submissao);
CREATE INDEX idx_submissao_evento ON tbl_submissao(ce_id_evento);
CREATE INDEX idx_submissao_status ON tbl_submissao(status);
CREATE INDEX idx_artigo_evento ON tbl_artigo(ce_id_evento);
CREATE INDEX idx_avaliacao_avaliador ON tbl_avaliacao(ce_id_membro);

-- Índice para palavras-chave associadas às submissões
CREATE INDEX idx_palavra_chave_submissao ON tbl_submissao_palavra_chave(ce_id_submissao);

-- Índice para otimizar buscas por status e evento
CREATE INDEX idx_status_evento_submissao ON tbl_submissao(status, ce_id_evento);

-- Índices nas tabelas de relacionamento N:M
CREATE INDEX idx_submissao_palavra_chave ON tbl_submissao_palavra_chave(ce_id_submissao, ce_id_palavra_chave);
CREATE INDEX idx_membro_evento ON tbl_membro_evento(ce_id_membro, ce_id_evento);
CREATE INDEX idx_autor_submissao ON tbl_autor_submissao(ce_id_membro, ce_id_submissao);
