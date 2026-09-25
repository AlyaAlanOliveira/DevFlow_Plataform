# DevFlow PRD v4.1 Enterprise

## Executive Summary
DevFlow e uma plataforma corporativa de governanca de engenharia de software para ALYA, Mobyan e TaNaPorta.

## Objetivos
- Governanca ponta a ponta
- Engenharia de requisitos
- Gestao Agile
- Estimativas UCP
- Release e GMUD
- IA Multiagente
- Analytics corporativo

## Estrutura Organizacional
Holding > Company > Directorate > Area > Squad > User

## Seguranca
- Microsoft Entra ID
- MFA obrigatorio
- RBAC
- Sem usuarios locais

## Dominios
### Governanca
Usuarios, Empresas, Areas, Squads, Sistemas

### Portfolio
Business Case, Demandas, Beneficios, Riscos

### Requisitos
RN, RF, RNF, Casos de Uso, UML

### Agile
Epic, Feature, User Story, Task, Sprint

### UCP
UAW, UUCW, TCF, EF, UCP, Forecast

### Release
Release, GMUD, Rollback, Validacao

### IA
AI Demand Analyst
AI Business Analyst
AI Scrum Specialist
AI UCP Specialist
AI Architect
AI Quality Reviewer

## Workflow Corporativo
Business Case -> Demand -> Requirement -> UseCase -> UserStory -> Estimate -> Sprint -> Test -> Release -> GMUD -> Production

## UCP
UCP=(UAW+UUCW)*TCF*EF

### TCF
Herdado parcialmente do Sistema.

### EF
Herdado parcialmente da Squad.

### Demanda
Complementa Performance, Usabilidade, Complexidade e Estabilidade.

## Arquitetura
### Frontend
Vue 3 + TypeScript + Pinia + Vuetify

### Backend
Python + FastAPI + SQLAlchemy

### Banco
SQL Server 2025

### Infraestrutura
Redis, RabbitMQ, OpenTelemetry, Grafana, Prometheus

### IA
Azure OpenAI + Azure AI Search

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

## Naming Convention
### PK
<TableName>Id

### FK
<Field>Id

### Constraints
PK_<Schema>_<Table>
FK_<Source>_<Target>
UK_<Table>_<Field>
CK_<Table>_<Rule>
DF_<Table>_<Field>

## Auditoria
Todas tabelas transacionais:
- CreatedAt
- CreatedBy
- UpdatedAt
- UpdatedBy
- DeletedAt
- DeletedBy
- IsDeleted
- RowVersion

## Exclusao
- Exclusao fisica proibida
- Soft Delete obrigatorio

## Versionamento
Entidades obrigatorias:
- BusinessCase
- Demand
- Requirement
- UseCase
- UserStory
- Estimate
- Release
- GMUD
- Document

## Rastreabilidade
BusinessCase -> Demand -> Requirement -> UseCase -> UserStory -> Task -> TestCase -> Release -> GMUD

## Definition of Done
- Demanda aprovada
- Requisitos aprovados
- Casos de uso aprovados
- User Stories aprovadas
- Estimativa registrada
- Testes aprovados
- Release aprovada
- GMUD aprovada
- Documentacao atualizada
- Auditoria registrada

## Code Review
Verificar:
- Arquitetura
- DDD
- SOLID
- Seguranca
- Auditoria
- Performance
- Testes
- Rastreabilidade
- Conformidade com PRD

## Roadmap
### MVP
Governanca, Sistemas e Demandas

### V1
Requisitos, UML e User Stories

### V2
UCP, Planejamento e Sprints

### V3
Release, GMUD e Dashboards

### V4
IA Multiagente, Analytics e Predicoes
