CREATE TABLE tbl_membro (
  cp_id_membro SERIAL PRIMARY KEY,
  nome VARCHAR(100),
  email VARCHAR(100),
  ce_id_instituicao VARCHAR(150)
);

CREATE TABLE tbl_instituicao (
  cp_id_instituicao SERIAL PRIMARY KEY,
  nome VARCHAR(150)
);

CREATE TABLE tbl_evento (
  cp_id_evento SERIAL PRIMARY KEY,
  nome VARCHAR(150),
  local VARCHAR(200),
  data DATE,
  tema VARCHAR(200),
  qtd_avaliacoes_limite INT
);

CREATE TABLE tbl_submissao (
  cp_id_submissao SERIAL PRIMARY KEY,
  titulo VARCHAR(200),
  resumo TEXT,
  conteudo TEXT,
  status VARCHAR(50),
  data_submissao DATE,
  ce_id_evento INT REFERENCES tbl_evento(cp_id_evento),
  ce_id_artigo INT
);

CREATE TABLE tbl_artigo (
  cp_id_artigo SERIAL PRIMARY KEY,
  data_publicado DATE,
  ce_id_submissao INT REFERENCES tbl_submissao(cp_id_submissao),
  ce_id_evento INT REFERENCES tbl_evento(cp_id_evento)
);

CREATE TABLE tbl_avaliacao (
  cp_id_avaliacao SERIAL PRIMARY KEY,
  ce_id_submissao INT REFERENCES tbl_submissao(cp_id_submissao),
  ce_id_membro INT REFERENCES tbl_membro(cp_id_membro),
  status VARCHAR(50),
  feedback TEXT
);

CREATE TABLE tbl_palavras_chaves (
  cp_id_palavra_chave SERIAL PRIMARY KEY,
  titulo VARCHAR(100)
);

CREATE TABLE tbl_submissao_palavra_chave (
  cp_id_submissao_palavra_chave SERIAL PRIMARY KEY,
  ce_id_submissao INT REFERENCES tbl_submissao(cp_id_submissao),
  ce_id_palavra_chave INT REFERENCES tbl_palavras_chaves(cp_id_palavra_chave)
);

CREATE TABLE tbl_membro_evento (
  cp_id_membro_evento SERIAL PRIMARY KEY,
  ce_id_membro INT REFERENCES tbl_membro(cp_id_membro),
  ce_id_evento INT REFERENCES tbl_evento(cp_id_evento)
);

CREATE TABLE tbl_autor_submissao (
  cp_id_autor_submissao SERIAL PRIMARY KEY,
  ce_id_membro INT REFERENCES tbl_membro(cp_id_membro),
  ce_id_submissao INT REFERENCES tbl_submissao(cp_id_submissao)
);
