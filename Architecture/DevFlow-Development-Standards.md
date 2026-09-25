# DevFlow Development Standards

Versão: 1.0

Objetivo:

Estabelecer padrões obrigatórios de arquitetura, modelagem, desenvolvimento,
banco de dados, integrações, APIs e inteligência artificial para o projeto DevFlow.

---

# 1. Arquitetura

## 1.1 Princípios

- Clean Architecture
- Domain Driven Design (DDD)
- SOLID
- CQRS onde aplicável
- Event Driven Architecture
- API First
- Database as Code

---

# 2. Tecnologias Oficiais

## Backend

- Python 3.13+
- FastAPI
- SQLAlchemy
- Pydantic

## Frontend

- Vue 3
- TypeScript
- Pinia
- Vuetify

## Banco

- SQL Server 2025

## Observabilidade

- OpenTelemetry
- Grafana
- Prometheus

## Mensageria

- RabbitMQ

## Cache

- Redis

## IA

- Azure OpenAI
- Azure AI Search

---

# 3. Convenções de Banco

## Schemas

ref
cfg

sec
gov
sys

portfolio
workflow

req
agile
ucp

qa
release

file

ai

audit

bi

---

# 4. Convenção de Tabelas

Formato:

PascalCase

Exemplos:

Demand
Requirement
UseCase
UserStory

---

# 5. Convenção de Colunas

PK

<TableName>Id

Exemplo:

DemandId

RequirementId

UserStoryId

---

# 6. Convenção de Constraints

PK_<Schema>_<Tabela>

FK_<Origem>_<Destino>

UK_<Tabela>_<Campo>

CK_<Tabela>_<Regra>

DF_<Tabela>_<Campo>

---

# 7. Auditoria Obrigatória

Todas as tabelas transacionais deverão possuir:

CreatedAt
CreatedBy

UpdatedAt
UpdatedBy

DeletedAt
DeletedBy

IsDeleted

RowVersion

---

# 8. Exclusão

## Regra

Exclusão física proibida.

Utilizar:

IsDeleted

DeletedAt

DeletedBy

---

# 9. Versionamento

Obrigatório para:

BusinessCase

Demand

Requirement

UseCase

UserStory

Estimate

Document

GMUD

Release

PromptTemplate

---

# 10. Identificadores

Business Case

BC-YYYY-NNNNN

Demanda

DEM-YYYY-NNNNN

Requisito

RF-YYYY-NNNNN

RN-YYYY-NNNNN

RNF-YYYY-NNNNN

Caso de Uso

UC-YYYY-NNNNN

User Story

US-YYYY-NNNNN

Estimativa

EST-YYYY-NNNNN

Release

REL-YYYY-NNNNN

GMUD

GMUD-YYYY-NNNNN

---

# 11. Sistemas

Todo sistema deverá possuir:

Nome

Sigla

Empresa

Gestor

Criticidade

Arquitetura

Integrações

LGPD

Perfil Técnico

---

# 12. Squads

Toda squad deverá possuir:

Capacity

Velocity

BusinessKnowledge

SystemKnowledge

TechnicalKnowledge

ScrumMaturity

Availability

---

# 13. Estimativas

Modelo oficial:

UCP

Fórmula:

UCP = (UAW + UUCW) × TCF × EF

---

# 14. Regras UCP

Sistema influencia:

TCF

Squad influencia:

EF

Demanda influencia:

Performance

Usabilidade

Complexidade

Estabilidade

---

# 15. Workflow

Business Case

↓

Demanda

↓

Requisitos

↓

Caso de Uso

↓

User Stories

↓

UCP

↓

Sprint

↓

Teste

↓

Release

↓

GMUD

↓

Produção

---

# 16. Rastreabilidade

Obrigatória entre:

BusinessCase

↓

Demand

↓

Requirement

↓

UseCase

↓

UserStory

↓

Task

↓

TestCase

↓

Release

↓

GMUD

---

# 17. Requisitos de Segurança

Autenticação:

Microsoft Entra ID

Autorização:

RBAC

MFA:

Obrigatório

Não permitir usuários locais.

---

# 18. APIs

Padrão REST.

Convenções:

GET

POST

PUT

PATCH

DELETE

Paginação obrigatória.

Versionamento:

/api/v1

/api/v2

---

# 19. Eventos

Padrão:

<Entity><Action>

Exemplos:

DemandCreated

DemandApproved

RequirementCreated

EstimateCalculated

ReleaseApproved

GMUDExecuted

---

# 20. Qualidade

Cobertura mínima:

80%

Testes obrigatórios:

Unitário

Integração

API

---

# 21. IA

Agentes oficiais:

AI Demand Analyst

AI Business Analyst

AI Requirement Engineer

AI Scrum Specialist

AI UCP Specialist

AI Architect

AI Quality Reviewer

---

# 22. Code Review

Nenhum Pull Request poderá ser aprovado sem verificar:

Arquitetura

Segurança

Performance

Logging

Auditoria

Versionamento

Rastreabilidade

Cobertura de Testes

Compliance com este documento

---

# 23. Architecture Decision Records

Toda decisão arquitetural deverá ser registrada.

Exemplos:

ADR-001
Uso do Entra ID

ADR-002
Separação por Schema

ADR-003
FastAPI

ADR-004
Vue 3

ADR-005
SQL Server 2025

ADR-006
UCP baseado em Sistema + Squad + Demanda

ADR-007
Arquitetura Multiagente

---

# 24. Definition of Done

Uma funcionalidade somente será considerada concluída quando possuir:

✅ Demanda aprovada

✅ Requisitos aprovados

✅ Casos de Uso revisados

✅ User Stories aprovadas

✅ Estimativa registrada

✅ Desenvolvimento concluído

✅ Testes aprovados

✅ Release registrada

✅ GMUD aprovada

✅ Auditoria registrada

✅ Documentação atualizada

✅ Rastreabilidade completa
