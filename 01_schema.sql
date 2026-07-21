-- ============================================================
-- CommitClub — Esquema Físico (PostgreSQL)
-- Gerado a partir do Modelo Lógico (Modelo_Logico.png)
-- 18 tabelas | Execução: psql -d commitclub -f 01_schema.sql
-- ============================================================

BEGIN;

-- ------------------------------------------------------------
-- 1. USUARIO — superclasse de Desenvolvedor e Recrutador
-- ------------------------------------------------------------
CREATE TABLE usuario (
    id           SERIAL        PRIMARY KEY,
    nome         VARCHAR(100)  NOT NULL,
    email        VARCHAR(150)  NOT NULL UNIQUE,
    senha        VARCHAR(255)  NOT NULL,
    foto_perfil  TEXT
);

-- ------------------------------------------------------------
-- 2. DESENVOLVEDOR — especialização de Usuario (PK = FK)
-- ------------------------------------------------------------
CREATE TABLE desenvolvedor (
    id          INTEGER       PRIMARY KEY
                              REFERENCES usuario (id)
                              ON UPDATE CASCADE ON DELETE CASCADE,
    biografia   TEXT,
    github      VARCHAR(100),
    pontos_exp  INTEGER       NOT NULL DEFAULT 0 CHECK (pontos_exp >= 0),
    level       INTEGER       NOT NULL DEFAULT 1 CHECK (level >= 1)
);

-- ------------------------------------------------------------
-- 3. RECRUTADOR — especialização de Usuario (PK = FK)
-- ------------------------------------------------------------
CREATE TABLE recrutador (
    id        INTEGER       PRIMARY KEY
                            REFERENCES usuario (id)
                            ON UPDATE CASCADE ON DELETE CASCADE,
    cargo     VARCHAR(80),
    linkedin  VARCHAR(150)
);

-- ------------------------------------------------------------
-- 4. CLA
-- ------------------------------------------------------------
CREATE TABLE cla (
    id            SERIAL        PRIMARY KEY,
    data_criacao  DATE          NOT NULL DEFAULT CURRENT_DATE,
    lema          VARCHAR(200),
    nome          VARCHAR(100)  NOT NULL
);

-- ------------------------------------------------------------
-- 5. DESENVOLVEDOR_CLA — associação N:N Desenvolvedor x Cla
-- ------------------------------------------------------------
CREATE TABLE desenvolvedor_cla (
    id_desenvolvedor  INTEGER NOT NULL
                      REFERENCES desenvolvedor (id)
                      ON UPDATE CASCADE ON DELETE CASCADE,
    id_cla            INTEGER NOT NULL
                      REFERENCES cla (id)
                      ON UPDATE CASCADE ON DELETE CASCADE,
    PRIMARY KEY (id_desenvolvedor, id_cla)
);

-- ------------------------------------------------------------
-- 6. DESENVOLVEDOR_TECNOLOGIA — atributo multivalorado
-- ------------------------------------------------------------
CREATE TABLE desenvolvedor_tecnologia (
    nome              VARCHAR(60) NOT NULL,
    id_desenvolvedor  INTEGER     NOT NULL
                      REFERENCES desenvolvedor (id)
                      ON UPDATE CASCADE ON DELETE CASCADE,
    PRIMARY KEY (nome, id_desenvolvedor)
);

-- ------------------------------------------------------------
-- 7. EMPRESA
-- ------------------------------------------------------------
CREATE TABLE empresa (
    id    SERIAL        PRIMARY KEY,
    cnpj  VARCHAR(18)   NOT NULL UNIQUE,
    nome  VARCHAR(120)  NOT NULL,
    site  VARCHAR(150)
);

-- ------------------------------------------------------------
-- 8. RECRUTADOR_TRABALHA — associação N:N Recrutador x Empresa
-- ------------------------------------------------------------
CREATE TABLE recrutador_trabalha (
    id_recrutador  INTEGER NOT NULL
                   REFERENCES recrutador (id)
                   ON UPDATE CASCADE ON DELETE CASCADE,
    id_empresa     INTEGER NOT NULL
                   REFERENCES empresa (id)
                   ON UPDATE CASCADE ON DELETE CASCADE,
    PRIMARY KEY (id_recrutador, id_empresa)
);

-- ------------------------------------------------------------
-- 9. SETOR
-- ------------------------------------------------------------
CREATE TABLE setor (
    id    SERIAL       PRIMARY KEY,
    nome  VARCHAR(80)  NOT NULL UNIQUE
);

-- ------------------------------------------------------------
-- 10. EMPRESA_ATUA — associação N:N Empresa x Setor
-- ------------------------------------------------------------
CREATE TABLE empresa_atua (
    id_empresa  INTEGER NOT NULL
                REFERENCES empresa (id)
                ON UPDATE CASCADE ON DELETE CASCADE,
    id_setor    INTEGER NOT NULL
                REFERENCES setor (id)
                ON UPDATE CASCADE ON DELETE CASCADE,
    PRIMARY KEY (id_empresa, id_setor)
);

-- ------------------------------------------------------------
-- 11. OFERTA_EMPREGO — associação N:N com atributos
--     PK composta: (data, id_desenvolvedor, id_recrutador)
-- ------------------------------------------------------------
CREATE TABLE oferta_emprego (
    data              TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    id_desenvolvedor  INTEGER      NOT NULL
                      REFERENCES desenvolvedor (id)
                      ON UPDATE CASCADE ON DELETE CASCADE,
    id_recrutador     INTEGER      NOT NULL
                      REFERENCES recrutador (id)
                      ON UPDATE CASCADE ON DELETE CASCADE,
    titulo            VARCHAR(120) NOT NULL,
    descricao         TEXT,
    status            VARCHAR(20)  NOT NULL DEFAULT 'Pendente'
                      CHECK (status IN ('Pendente', 'Aceita', 'Recusada', 'Expirada')),
    PRIMARY KEY (data, id_desenvolvedor, id_recrutador)
);

-- ------------------------------------------------------------
-- 12. DESAFIO
-- ------------------------------------------------------------
CREATE TABLE desafio (
    id             SERIAL        PRIMARY KEY,
    titulo         VARCHAR(120)  NOT NULL,
    descricao      TEXT,
    dificuldade    VARCHAR(20)   NOT NULL
                   CHECK (dificuldade IN ('Facil', 'Medio', 'Dificil')),
    data_limite    DATE,
    id_recrutador  INTEGER       NOT NULL
                   REFERENCES recrutador (id)
                   ON UPDATE CASCADE ON DELETE RESTRICT
);

-- ------------------------------------------------------------
-- 13. SOLUCAO — atributo composto/multivalorado de Desafio
--     PK composta: (output_esperado, id) conforme o modelo
-- ------------------------------------------------------------
CREATE TABLE solucao (
    output_esperado  TEXT    NOT NULL,
    id               INTEGER NOT NULL
                     REFERENCES desafio (id)
                     ON UPDATE CASCADE ON DELETE CASCADE,
    input            TEXT,
    PRIMARY KEY (output_esperado, id)
);

-- ------------------------------------------------------------
-- 14. COMENTARIO
-- ------------------------------------------------------------
CREATE TABLE comentario (
    id                SERIAL        PRIMARY KEY,
    titulo            VARCHAR(120),
    texto             TEXT          NOT NULL,
    id_desafio        INTEGER       NOT NULL
                      REFERENCES desafio (id)
                      ON UPDATE CASCADE ON DELETE CASCADE,
    id_desenvolvedor  INTEGER       NOT NULL
                      REFERENCES desenvolvedor (id)
                      ON UPDATE CASCADE ON DELETE CASCADE
);

-- ------------------------------------------------------------
-- 15. DESENVOLVEDOR_RESOLVIDOS — N:N Desenvolvedor x Desafio
-- ------------------------------------------------------------
CREATE TABLE desenvolvedor_resolvidos (
    id_desenvolvedor  INTEGER NOT NULL
                      REFERENCES desenvolvedor (id)
                      ON UPDATE CASCADE ON DELETE CASCADE,
    id_desafio        INTEGER NOT NULL
                      REFERENCES desafio (id)
                      ON UPDATE CASCADE ON DELETE CASCADE,
    PRIMARY KEY (id_desenvolvedor, id_desafio)
);

-- ------------------------------------------------------------
-- 16. REPOSITORIO — entidade fraca de Desenvolvedor
--     PK composta: (id, nome), onde id é FK do dono
-- ------------------------------------------------------------
CREATE TABLE repositorio (
    id        INTEGER       NOT NULL
              REFERENCES desenvolvedor (id)
              ON UPDATE CASCADE ON DELETE CASCADE,
    nome      VARCHAR(100)  NOT NULL,
    conteudo  TEXT,
    PRIMARY KEY (id, nome)
);

-- ------------------------------------------------------------
-- 17. COMMIT — pertence a um Repositorio, opcionalmente a um Desafio
--     ("commit" é palavra reservada em alguns SGBDs; no PostgreSQL
--      funciona como identificador, mas mantemos aspas por clareza)
-- ------------------------------------------------------------
CREATE TABLE "commit" (
    hash_commit       VARCHAR(40)  PRIMARY KEY,
    mensagem_commit   TEXT         NOT NULL,
    data_hora_commit  TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    id_desafio        INTEGER
                      REFERENCES desafio (id)
                      ON UPDATE CASCADE ON DELETE SET NULL,
    id                INTEGER      NOT NULL,
    nome              VARCHAR(100) NOT NULL,
    FOREIGN KEY (id, nome)
        REFERENCES repositorio (id, nome)
        ON UPDATE CASCADE ON DELETE CASCADE
);

-- ------------------------------------------------------------
-- 18. REPOSITORIO_VINCULADO — N:N Repositorio x Desafio
-- ------------------------------------------------------------
CREATE TABLE repositorio_vinculado (
    id_repositorio    INTEGER      NOT NULL,
    nome_repositorio  VARCHAR(100) NOT NULL,
    id_desafio        INTEGER      NOT NULL
                      REFERENCES desafio (id)
                      ON UPDATE CASCADE ON DELETE CASCADE,
    PRIMARY KEY (id_repositorio, nome_repositorio, id_desafio),
    FOREIGN KEY (id_repositorio, nome_repositorio)
        REFERENCES repositorio (id, nome)
        ON UPDATE CASCADE ON DELETE CASCADE
);

-- ------------------------------------------------------------
-- Índices auxiliares para as FKs mais consultadas
-- ------------------------------------------------------------
CREATE INDEX idx_comentario_desafio        ON comentario (id_desafio);
CREATE INDEX idx_comentario_desenvolvedor  ON comentario (id_desenvolvedor);
CREATE INDEX idx_desafio_recrutador        ON desafio (id_recrutador);
CREATE INDEX idx_commit_repositorio        ON "commit" (id, nome);
CREATE INDEX idx_commit_desafio            ON "commit" (id_desafio);

COMMIT;
