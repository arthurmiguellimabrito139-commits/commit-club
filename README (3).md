# 🚀 CommitClub

Plataforma social de produtividade e gamificação voltada para o ecossistema de desenvolvimento de software. O sistema conecta desenvolvedores e recrutadores: devs gamificam sua rotina de estudos resolvendo desafios, participando de clãs e registrando commits em seus repositórios; recrutadores usam essas métricas de engajamento e consistência técnica para prospectar talentos e emitir ofertas de emprego.

Projeto desenvolvido como atividade avaliativa da disciplina de **Banco de Dados** do curso de Ciência da Computação da **Universidade Federal de Goiás (UFG)**, sob orientação do professor Leonardo Andrade Ribeiro.

## 👥 Integrantes

- Arthur Miguel L. Brito
- Carlos Alberto R. Da S. Junior
- Luis Felipe B. Da Silva
- Marco Antonio M. Fernandes

## 📋 Sobre o Projeto

O CommitClub modela um universo onde todo usuário se especializa obrigatoriamente em **Desenvolvedor** ou **Recrutador**:

- **Desenvolvedores** ingressam em **Clãs** (grupos de estudo), propõem e resolvem **Desafios**, vinculam **Repositórios** de código e registram **Commits** como prova de progresso, ganhando níveis e experiência.
- **Recrutadores** estão vinculados a uma **Empresa**, criam desafios e enviam **Ofertas de Emprego** com base no histórico e desempenho dos desenvolvedores.
- **Comentários** viabilizam a interação social dentro das páginas dos desafios.

## 🧠 Modelagem

O projeto percorre todo o ciclo de vida de um banco de dados relacional:

1. **Descrição do minimundo** — regras de negócio do domínio
2. **Modelagem conceitual** — Diagrama Entidade-Relacionamento Estendido, com especialização disjunta de `Usuário` em `Desenvolvedor`/`Recrutador`
3. **Modelagem lógica** — mapeamento do modelo ER para esquemas de relação, com definição de chaves primárias, estrangeiras e candidatas
4. **Normalização** — validação nas formas 2FN, 3FN e BCNF (incluindo a correção de uma dependência transitiva identificada no esquema `Repositório`)
5. **Construção física** — scripts DDL/DML em PostgreSQL, com restrições de domínio, integridade referencial (`ON DELETE CASCADE` / `ON DELETE SET NULL`) e índices auxiliares
6. **Operações** — 18+ consultas cobrindo `UNION`/`INTERSECT`, subconsultas aninhadas e correlacionadas, `IN`/`EXISTS`/`ANY`/`ALL`, `JOIN`/`LEFT JOIN`/`RIGHT JOIN`, agregações com `GROUP BY`/`HAVING`, `INSERT`/`UPDATE`/`DELETE` e `VIEW`s

## 🗂️ Principais Entidades

| Entidade | Descrição |
|---|---|
| `usuario` | Superclasse com dados de acesso comuns |
| `desenvolvedor` | Especialização técnica (level, pontos_exp, github, tecnologias) |
| `recrutador` | Especialização de prospecção (cargo, linkedin, empresa) |
| `empresa` / `setor` | Empresas parceiras e seus setores de atuação |
| `cla` | Grupos/comunidades de estudo |
| `desafio` | Missões práticas gamificadas |
| `solucao` | Casos de teste/gabaritos de um desafio |
| `repositorio` | Repositórios de código vinculados a um desenvolvedor |
| `commit` | Submissões de código, associadas a um repositório e opcionalmente a um desafio |
| `comentario` | Interações sociais dentro dos desafios |
| `oferta_emprego` | Propostas de trabalho enviadas por recrutadores a desenvolvedores |

## 🛠️ Tecnologias e Ferramentas

- **SGBD:** PostgreSQL 16
- **Cliente de banco:** DBeaver
- **Modelagem:** ERDPlus (diagramas ER e lógico)
- **Colaboração:** Miro (whiteboard), Google Docs, WhatsApp, Google Meet
- **Edição de imagem:** Photopea
- **Apoio de IA generativa:** Google Gemini e OpenAI ChatGPT, usados para refinamento textual e geração de massa de dados fictícia para popular o banco

## 📁 Estrutura do Projeto

```
📦 commitclub
 ┣ 📄 schema.sql     → Apêndice A: script de criação (DDL)
 ┣ 📄 seed.sql       → Apêndice B: script de população (DML)
 ┣ 📄 queries.sql    → Apêndice C: consultas, views e operações
 ┗ 📄 relatorio.pdf  → Relatório técnico completo do projeto
```

## 🚀 Como usar

1. Crie um banco de dados PostgreSQL:
```bash
createdb commitclub
```

2. Execute o script de criação das tabelas:
```bash
psql -d commitclub -f schema.sql
```

3. Popule o banco com os dados de exemplo:
```bash
psql -d commitclub -f seed.sql
```

4. Execute as consultas e views:
```bash
psql -d commitclub -f queries.sql
```

## ✅ Requisitos Atendidos

- [x] Modelo Entidade-Relacionamento Estendido com especialização disjunta
- [x] Mapeamento completo para o modelo relacional
- [x] Validação nas formas normais 2FN, 3FN e BCNF
- [x] Restrições de domínio (`CHECK`), unicidade (`UNIQUE`) e integridade referencial
- [x] Consultas com operadores de conjunto, subconsultas, junções, agregações e views

## 📬 Referências

- ELMASRI, Ramez; NAVATHE, Shamkant B. *Sistemas de Banco de Dados*. 7. ed. São Paulo: Pearson Addison Wesley, 2018.
- PostgreSQL 16 Documentation — https://www.postgresql.org/docs/
- ERDPlus — https://erdplus.com/
- DBeaver — https://dbeaver.io/
