
-- ------------------------------------------------------------
-- 1. Nomes de todos os usuários que são desenvolvedores
--    OU recrutadores (UNION)
-- ------------------------------------------------------------
SELECT u.nome FROM usuario u JOIN desenvolvedor d ON u.id = d.id
UNION
SELECT u.nome FROM usuario u JOIN recrutador r ON u.id = r.id;

-- ------------------------------------------------------------
-- 2. Usuários que são simultaneamente desenvolvedores
--    E recrutadores (INTERSECT)
-- ------------------------------------------------------------
SELECT u.nome FROM usuario u JOIN desenvolvedor d ON u.id = d.id
INTERSECT
SELECT u.nome FROM usuario u JOIN recrutador r ON u.id = r.id;

-- ------------------------------------------------------------
-- 3. Desenvolvedores com nível acima da média
--    (subconsulta com agregação)
-- ------------------------------------------------------------
SELECT u.nome, d.level
FROM desenvolvedor d
JOIN usuario u ON u.id = d.id
WHERE d.level > (SELECT AVG(level) FROM desenvolvedor);

-- ------------------------------------------------------------
-- 4. Recrutadores que criaram mais de um desafio
-- ------------------------------------------------------------
SELECT u.nome, COUNT(*) AS qtd_desafios
FROM desafio de
JOIN usuario u ON u.id = de.id_recrutador
GROUP BY u.nome
HAVING COUNT(*) > 1;

-- ------------------------------------------------------------
-- 5. Desenvolvedores que resolveram algum desafio (IN)
-- ------------------------------------------------------------
SELECT u.nome
FROM usuario u
WHERE u.id IN (SELECT id_desenvolvedor FROM desenvolvedor_resolvidos);

-- ------------------------------------------------------------
-- 6. Empresas que possuem recrutadores (IN)
-- ------------------------------------------------------------
SELECT e.nome
FROM empresa e
WHERE e.id IN (SELECT id_empresa FROM recrutador_trabalha);

-- ------------------------------------------------------------
-- 7. Desenvolvedores com experiência maior que ALGUM outro
--    desenvolvedor (> ANY)
-- ------------------------------------------------------------
SELECT u.nome, d.pontos_exp
FROM desenvolvedor d
JOIN usuario u ON u.id = d.id
WHERE d.pontos_exp > ANY (SELECT pontos_exp FROM desenvolvedor);

-- ------------------------------------------------------------
-- 8. Desenvolvedor com maior experiência (>= ALL)
-- ------------------------------------------------------------
SELECT u.nome, d.pontos_exp
FROM desenvolvedor d
JOIN usuario u ON u.id = d.id
WHERE d.pontos_exp >= ALL (SELECT pontos_exp FROM desenvolvedor);

-- ------------------------------------------------------------
-- 9. Desenvolvedores que possuem comentários (EXISTS)
-- ------------------------------------------------------------
SELECT u.nome
FROM desenvolvedor d
JOIN usuario u ON u.id = d.id
WHERE EXISTS (SELECT 1 FROM comentario c
              WHERE c.id_desenvolvedor = d.id);

-- ------------------------------------------------------------
-- 10. Desafios sem repositórios vinculados
--     (aninhada correlacionada — NOT EXISTS)
-- ------------------------------------------------------------
SELECT de.titulo
FROM desafio de
WHERE NOT EXISTS (SELECT 1 FROM repositorio_vinculado rv
                  WHERE rv.id_desafio = de.id);

-- ------------------------------------------------------------
-- 11. Quantidade total de desafios
-- ------------------------------------------------------------
SELECT COUNT(*) AS total_desafios FROM desafio;

-- ------------------------------------------------------------
-- 12. Desafios juntamente com o recrutador responsável (JOIN)
-- ------------------------------------------------------------
SELECT de.titulo AS desafio, u.nome AS recrutador
FROM desafio de
JOIN recrutador r ON r.id = de.id_recrutador
JOIN usuario u ON u.id = r.id;

-- ------------------------------------------------------------
-- 13. Todos os desenvolvedores, mesmo os que não pertencem
--     a um clã (LEFT JOIN)
-- ------------------------------------------------------------
SELECT u.nome AS desenvolvedor, c.nome AS cla
FROM desenvolvedor d
JOIN usuario u ON u.id = d.id
LEFT JOIN desenvolvedor_cla dc ON dc.id_desenvolvedor = d.id
LEFT JOIN cla c ON c.id = dc.id_cla;

-- ------------------------------------------------------------
-- 14. Quantidade de desafios por recrutador (GROUP BY)
-- ------------------------------------------------------------
SELECT u.nome AS recrutador, COUNT(de.id) AS qtd_desafios
FROM desafio de
JOIN usuario u ON u.id = de.id_recrutador
GROUP BY u.nome;

-- ------------------------------------------------------------
-- 15. Quantidade de desenvolvedores em cada clã (GROUP BY)
-- ------------------------------------------------------------
SELECT c.nome AS cla, COUNT(dc.id_desenvolvedor) AS qtd_devs
FROM cla c
JOIN desenvolvedor_cla dc ON dc.id_cla = c.id
GROUP BY c.nome;

-- ------------------------------------------------------------
-- 16. Clãs com mais de dois desenvolvedores (HAVING)
-- ------------------------------------------------------------
SELECT c.nome AS cla, COUNT(dc.id_desenvolvedor) AS qtd_devs
FROM cla c
JOIN desenvolvedor_cla dc ON dc.id_cla = c.id
GROUP BY c.nome
HAVING COUNT(dc.id_desenvolvedor) > 2;

-- ------------------------------------------------------------
-- 17. Insere uma nova empresa (INSERT)
-- ------------------------------------------------------------
INSERT INTO empresa (cnpj, nome, site)
VALUES ('55.666.777/0001-88', 'CloudGyn Tecnologia', 'https://cloudgyn.com.br');

-- ------------------------------------------------------------
-- 18. Insere um usuário e depois o desenvolvedor
--     correspondente (INSERT em duas etapas)
-- ------------------------------------------------------------
INSERT INTO usuario (nome, email, senha)
VALUES ('Bruno Tavares', 'bruno.tavares@email.com', 'hash$2b$bruno');

INSERT INTO desenvolvedor (id, biografia, github, pontos_exp, level)
VALUES ((SELECT id FROM usuario WHERE email = 'bruno.tavares@email.com'),
        'Dev iniciante em Go.', 'brunotav', 0, 1);

-- ------------------------------------------------------------
-- 19. Remove um comentário (DELETE)
-- ------------------------------------------------------------
DELETE FROM comentario WHERE id = 4;

-- ------------------------------------------------------------
-- 20. Remove um usuário — os registros relacionados são
--     removidos em cascata pela integridade referencial
-- ------------------------------------------------------------
DELETE FROM usuario WHERE id = 3;

-- ------------------------------------------------------------
-- 21. Adiciona experiência ao desenvolvedor (UPDATE)
-- ------------------------------------------------------------
UPDATE desenvolvedor
SET pontos_exp = pontos_exp + 150
WHERE id = 1;

-- ------------------------------------------------------------
-- 22. Atualiza o status de uma oferta de emprego (UPDATE)
-- ------------------------------------------------------------
UPDATE oferta_emprego
SET status = 'Aceita'
WHERE id_desenvolvedor = 5 AND id_recrutador = 7;

-- ------------------------------------------------------------
-- 23. View 1: Desenvolvedores com nível e experiência
-- ------------------------------------------------------------
CREATE VIEW vw_desenvolvedores AS
SELECT u.nome, d.level, d.pontos_exp
FROM desenvolvedor d
JOIN usuario u ON u.id = d.id;

-- ------------------------------------------------------------
-- 24. View 2: Desafios e seus recrutadores
-- ------------------------------------------------------------
CREATE VIEW vw_desafios_recrutadores AS
SELECT de.titulo AS desafio, de.dificuldade, u.nome AS recrutador
FROM desafio de
JOIN usuario u ON u.id = de.id_recrutador;

-- Exemplos de uso das views:
SELECT * FROM vw_desenvolvedores;
SELECT * FROM vw_desafios_recrutadores;
