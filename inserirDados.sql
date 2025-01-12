-- Inserir 100 eventos
DO $$
BEGIN
  FOR i IN 1..100 LOOP
    INSERT INTO tbl_evento (nome, local, data, tema, qtd_avaliacoes_limite)
    VALUES (
      'Evento ' || i,
      'Local ' || i,
      CURRENT_DATE + (i * 10),
      'Tema ' || i,
      2
    );
  END LOOP;
END $$;

-- Inserir 10 instituições
DO $$
BEGIN
  FOR i IN 1..10 LOOP
    INSERT INTO tbl_instituicao (nome)
    VALUES ('Instituição ' || i);
  END LOOP;
END $$;

-- Inserir 100 membros
DO $$
BEGIN
  FOR i IN 1..100 LOOP
    INSERT INTO tbl_membro (nome, email, ce_id_instituicao)
    VALUES (
      'Membro ' || i,
      'membro' || i || '@exemplo.com',
      (i % 10) + 1  -- Referência a uma instituição (1 a 10)
    );
  END LOOP;
END $$;

-- Inserir 100 submissões
DO $$
BEGIN
  FOR i IN 1..100 LOOP
    INSERT INTO tbl_submissao (titulo, resumo, conteudo, status, data_submissao, ce_id_evento, ce_id_artigo)
    VALUES (
      'Submissão ' || i,
      'Resumo da submissão ' || i,
      'Conteúdo completo da submissão ' || i,
      'pendente',
      CURRENT_DATE - (i * 5),
      (i % 100) + 1,
      NULL
    );
  END LOOP;
END $$;

-- Inserir 100 palavras-chave
DO $$
BEGIN
  FOR i IN 1..100 LOOP
    INSERT INTO tbl_palavras_chaves (titulo)
    VALUES ('Palavra-chave ' || i);
  END LOOP;
END $$;

-- Relações entre submissões e palavras-chave
DO $$
BEGIN
  FOR i IN 1..100 LOOP
    INSERT INTO tbl_submissao_palavra_chave (ce_id_submissao, ce_id_palavra_chave)
    VALUES (
      (i % 100) + 1,
      (i % 100) + 1
    );
  END LOOP;
END $$;

-- Relações entre membros e eventos
DO $$
BEGIN
  FOR i IN 1..100 LOOP
    INSERT INTO tbl_membro_evento (ce_id_membro, ce_id_evento)
    VALUES (
      (i % 100) + 1,
      (i % 100) + 1
    );
  END LOOP;
END $$;

-- Relações entre autores e submissões
DO $$
BEGIN
  FOR i IN 1..100 LOOP
    INSERT INTO tbl_autor_submissao (ce_id_membro, ce_id_submissao)
    VALUES (
      (i % 100) + 1,
      (i % 100) + 1
    );
  END LOOP;
END $$;

-- Insere avaliações e artigos
DO $$
DECLARE
  v_submissao_id INT;
  v_membro_id INT;
  v_status_avaliacao TEXT;
  v_aprovacoes INT;
  v_artigo_id INT;
BEGIN
  -- Para 50 submissões diferentes
  FOR v_submissao_id IN
    SELECT cp_id_submissao FROM tbl_submissao WHERE status = 'pendente' LIMIT 50
  LOOP
    v_aprovacoes := 0;
    
    -- Para cada submissão, criar 3 avaliações
    FOR i IN 1..3 LOOP
      -- Escolher um membro que não seja autor da submissão
      FOR v_membro_id IN
        SELECT m.cp_id_membro
        FROM tbl_membro m
        WHERE m.cp_id_membro NOT IN (
          SELECT asu.ce_id_membro
          FROM tbl_autor_submissao asu
          WHERE asu.ce_id_submissao = v_submissao_id
        )
        LIMIT 1
      LOOP
        -- Gerar status aleatório para a avaliação (aprovado, rejeitado ou resubmissão requerida)
        v_status_avaliacao := CASE
          WHEN RANDOM() < 0.33 THEN 'aprovado'
          WHEN RANDOM() < 0.66 THEN 'rejeitado'
          ELSE 'resubmissao_requerida'
        END;
        
        -- Inserir avaliação
        INSERT INTO tbl_avaliacao (ce_id_submissao, ce_id_membro, status, feedback)
        VALUES (v_submissao_id, v_membro_id, v_status_avaliacao, 'Feedback da avaliação');
        
        -- Contar quantas avaliações foram aprovadas
        IF v_status_avaliacao = 'aprovado' THEN
          v_aprovacoes := v_aprovacoes + 1;
        END IF;
        
        EXIT;  -- Garantir que somente 1 membro seja selecionado por vez
      END LOOP;
    END LOOP;

    -- Se houver 2 avaliações aprovadas, criar artigo e atualizar ce_id_artigo na submissão
    IF v_aprovacoes >= 2 THEN
      -- Criar o artigo
      INSERT INTO tbl_artigo (data_publicado, ce_id_submissao, ce_id_evento)
      VALUES (CURRENT_DATE, v_submissao_id, (SELECT ce_id_evento FROM tbl_submissao WHERE cp_id_submissao = v_submissao_id LIMIT 1))
      RETURNING cp_id_artigo INTO v_artigo_id;

      -- Atualizar ce_id_artigo na submissão
      UPDATE tbl_submissao
      SET ce_id_artigo = v_artigo_id
      WHERE cp_id_submissao = v_submissao_id;
    END IF;
  END LOOP;
END $$;
