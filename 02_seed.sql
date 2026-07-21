-- ============================================================
-- CommitClub — Povoamento (Seed Data)
-- Pré-requisito: 01_schema.sql executado
-- Execução: psql -d commitclub -f 02_seed.sql
-- ============================================================

BEGIN;

-- ------------------------------------------------------------
-- USUARIO (ids 1–5: desenvolvedores | ids 6–8: recrutadores)
-- ------------------------------------------------------------
INSERT INTO usuario (nome, email, senha, foto_perfil) VALUES
('Ana Beatriz Souza',   'ana.souza@email.com',     'hash$2b$ana',    'https://cdn.commitclub.dev/fotos/ana.png'),
('Carlos Eduardo Lima', 'carlos.lima@email.com',   'hash$2b$carlos', 'https://cdn.commitclub.dev/fotos/carlos.png'),
('Mariana Ferreira',    'mariana.f@email.com',     'hash$2b$mari',   NULL),
('João Pedro Alves',    'joao.alves@email.com',    'hash$2b$joao',   'https://cdn.commitclub.dev/fotos/joao.png'),
('Rafael Nogueira',     'rafael.n@email.com',      'hash$2b$rafa',   NULL),
('Fernanda Castro',     'fernanda.castro@tc.com',  'hash$2b$fer',    'https://cdn.commitclub.dev/fotos/fernanda.png'),
('Gustavo Martins',     'gustavo.m@innova.com',    'hash$2b$gus',    NULL),
('Patrícia Rocha',      'patricia.rocha@dbx.com',  'hash$2b$pat',    'https://cdn.commitclub.dev/fotos/patricia.png');

-- ------------------------------------------------------------
-- DESENVOLVEDOR (especialização)
-- ------------------------------------------------------------
INSERT INTO desenvolvedor (id, biografia, github, pontos_exp, level) VALUES
(1, 'Backend dev apaixonada por sistemas distribuídos.',  'anabsouza',   1250, 5),
(2, 'Fullstack, foco em PHP/Laravel e PostgreSQL.',       'carloselima', 3400, 9),
(3, 'Estudante de CC, iniciando em segurança web.',       'marifdev',     480, 2),
(4, 'Mobile dev migrando para engenharia de dados.',      'jpalves',      920, 4),
(5, 'Entusiasta de Rust e sistemas embarcados.',          'rafanog',     2100, 7);

-- ------------------------------------------------------------
-- RECRUTADOR (especialização)
-- ------------------------------------------------------------
INSERT INTO recrutador (id, cargo, linkedin) VALUES
(6, 'Tech Recruiter Sênior', 'linkedin.com/in/fernandacastro'),
(7, 'Head de Talentos',      'linkedin.com/in/gustavomartins'),
(8, 'Recrutadora Técnica',   'linkedin.com/in/patriciarocha');

-- ------------------------------------------------------------
-- CLA
-- ------------------------------------------------------------
INSERT INTO cla (data_criacao, lema, nome) VALUES
('2025-03-10', 'Commit cedo, commit sempre.',        'Null Pointers'),
('2025-06-22', 'Refatorar é um ato de amor.',        'Clean Coders'),
('2026-01-15', 'Em caso de dúvida, escreva testes.', 'Segfault Squad');

-- ------------------------------------------------------------
-- DESENVOLVEDOR_CLA
-- ------------------------------------------------------------
INSERT INTO desenvolvedor_cla (id_desenvolvedor, id_cla) VALUES
(1, 1), (2, 1), (3, 2), (4, 2), (5, 3), (2, 3);

-- ------------------------------------------------------------
-- DESENVOLVEDOR_TECNOLOGIA
-- ------------------------------------------------------------
INSERT INTO desenvolvedor_tecnologia (nome, id_desenvolvedor) VALUES
('Python',     1), ('Docker',     1), ('PostgreSQL', 1),
('PHP',        2), ('Laravel',    2), ('PostgreSQL', 2),
('JavaScript', 3), ('Python',     3),
('Kotlin',     4), ('Spark',      4),
('Rust',       5), ('C',          5);

-- ------------------------------------------------------------
-- EMPRESA
-- ------------------------------------------------------------
INSERT INTO empresa (cnpj, nome, site) VALUES
('12.345.678/0001-90', 'TechCerrado Ltda',   'https://techcerrado.com.br'),
('98.765.432/0001-10', 'Innova Digital S.A.', 'https://innovadigital.com'),
('11.222.333/0001-44', 'DataBrixx',           'https://databrixx.io');

-- ------------------------------------------------------------
-- RECRUTADOR_TRABALHA
-- ------------------------------------------------------------
INSERT INTO recrutador_trabalha (id_recrutador, id_empresa) VALUES
(6, 1), (7, 2), (8, 3), (6, 3);

-- ------------------------------------------------------------
-- SETOR
-- ------------------------------------------------------------
INSERT INTO setor (nome) VALUES
('Tecnologia da Informação'),
('Consultoria'),
('Análise de Dados'),
('Fintech');

-- ------------------------------------------------------------
-- EMPRESA_ATUA
-- ------------------------------------------------------------
INSERT INTO empresa_atua (id_empresa, id_setor) VALUES
(1, 1), (1, 4), (2, 1), (2, 2), (3, 1), (3, 3);

-- ------------------------------------------------------------
-- DESAFIO (criados por recrutadores)
-- ------------------------------------------------------------
INSERT INTO desafio (titulo, descricao, dificuldade, data_limite, id_recrutador) VALUES
('API de Encurtador de URL',
 'Implemente um encurtador de URLs com contagem de acessos e expiração.',
 'Medio',   '2026-08-15', 6),
('Fila de Mensagens Concorrente',
 'Implemente uma fila FIFO thread-safe com múltiplos produtores e consumidores.',
 'Dificil', '2026-09-01', 7),
('Validador de CPF',
 'Escreva uma função que valide CPFs conforme os dígitos verificadores.',
 'Facil',   '2026-07-30', 8),
('Sincronização de Relógios Lógicos',
 'Simule relógios de Lamport em três processos e ordene eventos concorrentes.',
 'Dificil', '2026-10-10', 6);

-- ------------------------------------------------------------
-- SOLUCAO (casos de teste dos desafios)
-- ------------------------------------------------------------
INSERT INTO solucao (output_esperado, id, input) VALUES
('https://cc.dev/abc123',           1, 'https://exemplo.com/pagina-muito-longa'),
('404',                             1, 'https://cc.dev/inexistente'),
('[1, 2, 3, 4, 5]',                 2, 'produtores=2 consumidores=1 itens=5'),
('true',                            3, '529.982.247-25'),
('false',                           3, '111.111.111-11'),
('P1:e1 < P2:e1 < P1:e2 < P3:e1',   4, 'eventos=4 processos=3');

-- ------------------------------------------------------------
-- COMENTARIO
-- ------------------------------------------------------------
INSERT INTO comentario (titulo, texto, id_desafio, id_desenvolvedor) VALUES
('Dúvida sobre expiração',
 'A expiração das URLs deve ser configurável ou fixa em 30 dias?', 1, 3),
('Dica de concorrência',
 'Vale a pena olhar Condition Variables antes de partir para locks manuais.', 2, 5),
('Edge case importante',
 'Não esqueçam de rejeitar CPFs com todos os dígitos iguais.', 3, 2),
('Referência bibliográfica',
 'O capítulo 5 do Tanenbaum cobre exatamente esse algoritmo.', 4, 1);

-- ------------------------------------------------------------
-- DESENVOLVEDOR_RESOLVIDOS
-- ------------------------------------------------------------
INSERT INTO desenvolvedor_resolvidos (id_desenvolvedor, id_desafio) VALUES
(1, 3), (1, 4), (2, 1), (2, 3), (4, 3), (5, 2);

-- ------------------------------------------------------------
-- REPOSITORIO (entidade fraca: PK = id do dono + nome)
-- ------------------------------------------------------------
INSERT INTO repositorio (id, nome, conteudo) VALUES
(1, 'lamport-sim',    'Simulador de relógios de Lamport em Python.'),
(2, 'url-shortener',  'Encurtador de URL em Laravel + PostgreSQL.'),
(2, 'cpf-validator',  'Validador de CPF em PHP puro.'),
(4, 'cpf-validator',  'Validador de CPF em Kotlin.'),
(5, 'mpmc-queue',     'Fila concorrente multi-produtor em Rust.');

-- ------------------------------------------------------------
-- COMMIT
-- ------------------------------------------------------------
INSERT INTO "commit" (hash_commit, mensagem_commit, data_hora_commit, id_desafio, id, nome) VALUES
('a1b2c3d4e5f6a7b8c9d0e1f2a3b4c5d6e7f8a9b0',
 'feat: estrutura inicial dos processos',        '2026-06-01 10:15:00', 4, 1, 'lamport-sim'),
('b2c3d4e5f6a7b8c9d0e1f2a3b4c5d6e7f8a9b0c1',
 'fix: incremento do relógio no recebimento',    '2026-06-03 14:42:00', 4, 1, 'lamport-sim'),
('c3d4e5f6a7b8c9d0e1f2a3b4c5d6e7f8a9b0c1d2',
 'feat: rota de redirecionamento com contagem',  '2026-05-20 09:05:00', 1, 2, 'url-shortener'),
('d4e5f6a7b8c9d0e1f2a3b4c5d6e7f8a9b0c1d2e3',
 'feat: dígitos verificadores do CPF',           '2026-05-25 16:30:00', 3, 2, 'cpf-validator'),
('e5f6a7b8c9d0e1f2a3b4c5d6e7f8a9b0c1d2e3f4',
 'refactor: extrai função de normalização',      '2026-05-26 11:00:00', 3, 4, 'cpf-validator'),
('f6a7b8c9d0e1f2a3b4c5d6e7f8a9b0c1d2e3f4a5',
 'feat: fila lock-free com atomics',             '2026-06-10 20:18:00', 2, 5, 'mpmc-queue'),
('a7b8c9d0e1f2a3b4c5d6e7f8a9b0c1d2e3f4a5b6',
 'docs: README inicial',                         '2026-06-11 08:00:00', NULL, 5, 'mpmc-queue');

-- ------------------------------------------------------------
-- REPOSITORIO_VINCULADO
-- ------------------------------------------------------------
INSERT INTO repositorio_vinculado (id_repositorio, nome_repositorio, id_desafio) VALUES
(1, 'lamport-sim',   4),
(2, 'url-shortener', 1),
(2, 'cpf-validator', 3),
(4, 'cpf-validator', 3),
(5, 'mpmc-queue',    2);

-- ------------------------------------------------------------
-- OFERTA_EMPREGO
-- ------------------------------------------------------------
INSERT INTO oferta_emprego (data, id_desenvolvedor, id_recrutador, titulo, descricao, status) VALUES
('2026-06-15 09:00:00', 2, 6, 'Dev Backend Pleno',
 'Vaga para atuar com Laravel e PostgreSQL na TechCerrado.', 'Aceita'),
('2026-06-18 14:30:00', 5, 7, 'Engenheiro de Sistemas',
 'Posição para sistemas de alta performance em Rust.', 'Pendente'),
('2026-06-20 11:45:00', 1, 8, 'Dev Backend Júnior',
 'Time de dados da DataBrixx busca dev com Python.', 'Recusada'),
('2026-06-25 16:10:00', 2, 8, 'Tech Lead',
 'Liderança técnica do squad de plataformas.', 'Pendente');

COMMIT;
