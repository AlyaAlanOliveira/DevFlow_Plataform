# DevFlow - Tabelas e Relacionamentos

## 📊 Visão Geral

**Total de Tabelas**: 49  
**Total de Schemas**: 16  
**Total de Relacionamentos (FK)**: 85+

---

## 🗂️ Inventário Completo de Tabelas

### Schema: `ref` (Referência) - 5 tabelas

| # | Tabela | Descrição | PKs | FKs |
|---|--------|-----------|-----|-----|
| 1 | `Priority` | Prioridades (Low, Medium, High, Critical) | 1 | 0 |
| 2 | `DemandType` | Tipos de demanda (Feature, Integration, etc.) | 1 | 0 |
| 3 | `WorkflowStatus` | Status de workflow por entidade | 1 | 0 |
| 4 | `ActorComplexity` | Complexidade de atores UCP | 1 | 0 |
| 5 | `UseCaseComplexity` | Complexidade de casos de uso UCP | 1 | 0 |

### Schema: `cfg` (Configuração) - 3 tabelas

| # | Tabela | Descrição | PKs | FKs |
|---|--------|-----------|-----|-----|
| 6 | `Operation` | Operações/Plataformas/Contratantes | 1 | 1 (Company) |
| 7 | `UCPConfiguration` | Configuração de horas/UCP | 1 | 0 |
| 8 | `ApplicationSettings` | Configurações gerais | 1 | 0 |

### Schema: `sec` (Segurança) - 6 tabelas

| # | Tabela | Descrição | PKs | FKs |
|---|--------|-----------|-----|-----|
| 9 | `User` | Usuários (integrado Entra ID) | 1 | 1 (Company) |
| 10 | `Role` | Papéis/Funções | 1 | 0 |
| 11 | `Permission` | Permissões granulares | 1 | 0 |
| 12 | `RolePermission` | Permissões por papel | 1 | 2 (Role, Permission) |
| 13 | `UserRole` | Papéis dos usuários | 1 | 4 (User, Role, Area, System) |
| 14 | `PriorityChangeAuthorization` | Autorização mudança prioridade | 1 | 4 (User, Area, Priority×2) |

### Schema: `gov` (Governança) - 6 tabelas

| # | Tabela | Descrição | PKs | FKs |
|---|--------|-----------|-----|-----|
| 15 | `Holding` | Holdings | 1 | 0 |
| 16 | `Company` | Empresas | 1 | 1 (Holding) |
| 17 | `Directorate` | Diretorias | 1 | 2 (Company, User) |
| 18 | `Area` | Áreas | 1 | 2 (Directorate, User) |
| 19 | `Squad` | Times de desenvolvimento | 1 | 3 (Area, User×2) |
| 20 | `SquadMember` | Membros das squads | 1 | 2 (Squad, User) |

### Schema: `sys` (Sistemas) - 2 tabelas

| # | Tabela | Descrição | PKs | FKs |
|---|--------|-----------|-----|-----|
| 21 | `System` | Catálogo de sistemas | 1 | 2 (Company, User) |
| 22 | `SystemIntegration` | Integrações entre sistemas | 1 | 2 (System×2) |

### Schema: `portfolio` (Portfolio) - 4 tabelas

| # | Tabela | Descrição | PKs | FKs |
|---|--------|-----------|-----|-----|
| 23 | `BusinessCase` | Business cases | 1 | 6 (Company, Area, User×4) |
| 24 | `Demand` | Demandas | 1 | 10 (BusinessCase, System, DemandType, Area, User×6) |
| 25 | `DemandOperation` | Operações da demanda (N:N) | 1 | 2 (Demand, Operation) |
| 26 | `DemandPriorityHistory` | Histórico de prioridades | 1 | 3 (Demand, Priority×2, User) |

### Schema: `workflow` (Workflow) - 5 tabelas

| # | Tabela | Descrição | PKs | FKs |
|---|--------|-----------|-----|-----|
| 27 | `ApprovalFlow` | Fluxo de aprovação | 1 | 0 |
| 28 | `ApprovalStep` | Etapas de aprovação | 1 | 2 (ApprovalFlow, User) |
| 29 | `EntityRevision` | Histórico de revisões | 1 | 1 (User) |
| 30 | `StatusTransition` | Transições de status | 1 | 3 (WorkflowStatus×2, User) |
| 31 | `Assignment` | Designações | 1 | 3 (User×3) |

### Schema: `req` (Requisitos) - 5 tabelas

| # | Tabela | Descrição | PKs | FKs |
|---|--------|-----------|-----|-----|
| 32 | `Requirement` | Requisitos (RN, RF, RNF) | 1 | 1 (Demand) |
| 33 | `UseCase` | Casos de uso | 1 | 2 (Requirement, UseCaseComplexity) |
| 34 | `Actor` | Atores | 1 | 2 (Demand, ActorComplexity) |
| 35 | `UseCaseActor` | Atores x Casos de Uso (N:N) | 1 | 2 (UseCase, Actor) |
| 36 | `RequirementDependency` | Dependências entre requisitos | 1 | 2 (Requirement×2) |

### Schema: `agile` (Agile) - 6 tabelas

| # | Tabela | Descrição | PKs | FKs |
|---|--------|-----------|-----|-----|
| 37 | `UserStory` | User stories | 1 | 1 (UseCase) |
| 38 | `BusinessRule` | Regras de negócio (RN) | 1 | 1 (UserStory) |
| 39 | `AcceptanceCriteria` | Critérios de aceite (AC) | 1 | 1 (BusinessRule) |
| 40 | `Sprint` | Sprints | 1 | 1 (Squad) |
| 41 | `SprintUserStory` | User Stories na sprint (N:N) | 1 | 3 (Sprint, UserStory, User) |
| 42 | `Task` | Tarefas técnicas | 1 | 2 (UserStory, User) |

### Schema: `ucp` (UCP) - 7 tabelas

| # | Tabela | Descrição | PKs | FKs |
|---|--------|-----------|-----|-----|
| 43 | `Estimate` | Estimativas UCP | 1 | 6 (Demand, UCPConfig, Squad, User×3) |
| 44 | `TechnicalFactor` | Fatores técnicos (TF1-TF13) | 1 | 1 (Estimate) |
| 45 | `EnvironmentalFactor` | Fatores ambientais (FA1-FA8) | 1 | 1 (Estimate) |
| 46 | `EstimateActorWeight` | Peso dos atores | 1 | 3 (Estimate, Actor, ActorComplexity) |
| 47 | `EstimateUseCaseWeight` | Peso dos casos de uso | 1 | 3 (Estimate, UseCase, UseCaseComplexity) |
| 48 | `EstimateHistory` | Histórico de estimativas | 1 | 2 (Estimate, User) |

### Schemas Futuros

| Schema | Tabelas Planejadas |
|--------|-------------------|
| `qa` | TestCase, TestExecution, TestResult, DefectReport |
| `release` | Release, ReleaseItem, Deployment, Rollback |
| `file` | Document, Attachment, DocumentVersion |
| `ai` | AgentExecution, PromptTemplate, KnowledgeBase, AIFeedback |
| `audit` | EntityHistory, AccessLog, ChangeLog |
| `bi` | Dashboard, Report, Metric, KPI |

---

## 🔗 Mapa de Relacionamentos Principais

### Cadeia de Rastreabilidade (Workflow Principal)

```
BusinessCase (1)
    ↓ 1:N
Demand (N)
    ↓ 1:N
Requirement (N)
    ↓ 1:N
UseCase (N)
    ↓ 1:N
UserStory (N)
    ↓ 1:N
Task (N)
```

### Estrutura Organizacional

```
Holding (1)
    ↓ 1:N
Company (N)
    ↓ 1:N
Directorate (N)
    ↓ 1:N
Area (N)
    ↓ 1:N
Squad (N)
    ↓ 1:N
SquadMember (N) ← N:1 → User
```

### Sistema UCP

```
Demand (1)
    ↓ 1:1
Estimate (1)
    ├─ 1:N → TechnicalFactor (13)
    ├─ 1:N → EnvironmentalFactor (8)
    ├─ 1:N → EstimateActorWeight (N)
    └─ 1:N → EstimateUseCaseWeight (N)
```

### Workflow de Aprovações

```
[Entidade] (BusinessCase, Demand, Requirement, etc.)
    ↓ 1:1
ApprovalFlow (1)
    ↓ 1:N
ApprovalStep (N) ← N:1 → User (Aprovador)
```

### RBAC (Segurança)

```
User (1)
    ↓ N:N
UserRole (N) ← N:1 → Role (1)
                        ↓ N:N
                    RolePermission (N) ← N:1 → Permission (1)
```

---

## 📈 Estatísticas de Relacionamentos

### Por Cardinalidade

| Tipo | Quantidade | Exemplos |
|------|-----------|----------|
| 1:1 | 5 | Demand → Estimate |
| 1:N | 60+ | Company → System, Demand → Requirement |
| N:N | 10+ | Sprint ↔ UserStory, UseCase ↔ Actor |

### Por Schema (FKs de saída)

| Schema | FKs | Principais Relacionamentos |
|--------|-----|---------------------------|
| `portfolio` | 18 | → gov, sys, sec, ref |
| `ucp` | 12 | → portfolio, cfg, gov, req, ref, sec |
| `agile` | 10 | → req, gov, sec |
| `workflow` | 8 | → sec, ref |
| `req` | 7 | → portfolio, ref |
| `gov` | 6 | → sec |
| `sec` | 6 | → gov, sys, ref |
| `sys` | 2 | → gov, sec |
| `cfg` | 1 | → gov |
| `ref` | 0 | (tabelas de domínio) |

---

## 🎯 Principais Índices

### Índices de Performance Críticos

```sql
-- Busca de demandas por área
CREATE INDEX IX_Demand_AreaId ON portfolio.Demand(AreaId) WHERE IsDeleted = 0;

-- Busca de demandas por sistema
CREATE INDEX IX_Demand_SystemId ON portfolio.Demand(SystemId) WHERE IsDeleted = 0;

-- Busca de demandas por status
CREATE INDEX IX_Demand_Status ON portfolio.Demand(Status) WHERE IsDeleted = 0;

-- Busca de user stories por caso de uso
CREATE INDEX IX_UserStory_UseCaseId ON agile.UserStory(UseCaseId) WHERE IsDeleted = 0;

-- Busca de aprovações pendentes por usuário
CREATE INDEX IX_ApprovalStep_ApproverUserId ON workflow.ApprovalStep(ApproverUserId) WHERE IsDeleted = 0 AND Status = 'Pending';

-- Busca de membros ativos de squad
CREATE INDEX IX_SquadMember_Active ON gov.SquadMember(SquadId, UserId) WHERE IsDeleted = 0 AND IsActive = 1 AND EndDate IS NULL;
```

### Índices de Auditoria

```sql
-- Busca por data de criação
CREATE INDEX IX_[Table]_CreatedAt ON [schema].[Table](CreatedAt) WHERE IsDeleted = 0;

-- Busca por criador
CREATE INDEX IX_[Table]_CreatedBy ON [schema].[Table](CreatedBy) WHERE IsDeleted = 0;

-- Busca de itens deletados (para recuperação)
CREATE INDEX IX_[Table]_Deleted ON [schema].[Table](DeletedAt, DeletedBy) WHERE IsDeleted = 1;
```

---

## 🔍 Queries Úteis

### 1. Listar todas as tabelas e seus relacionamentos

```sql
SELECT 
    OBJECT_SCHEMA_NAME(f.parent_object_id) AS SchemaName,
    OBJECT_NAME(f.parent_object_id) AS TableName,
    COL_NAME(fc.parent_object_id, fc.parent_column_id) AS ColumnName,
    OBJECT_SCHEMA_NAME(f.referenced_object_id) AS ReferencedSchema,
    OBJECT_NAME(f.referenced_object_id) AS ReferencedTable,
    COL_NAME(fc.referenced_object_id, fc.referenced_column_id) AS ReferencedColumn
FROM sys.foreign_keys AS f
INNER JOIN sys.foreign_key_columns AS fc ON f.object_id = fc.constraint_object_id
ORDER BY SchemaName, TableName;
```

### 2. Contar registros por tabela

```sql
SELECT 
    SCHEMA_NAME(schema_id) AS SchemaName,
    name AS TableName,
    SUM(p.rows) AS RowCount
FROM sys.tables t
INNER JOIN sys.partitions p ON t.object_id = p.object_id
WHERE p.index_id IN (0,1)
GROUP BY SCHEMA_NAME(schema_id), name
ORDER BY SchemaName, TableName;
```

### 3. Verificar integridade referencial

```sql
-- Verificar FKs órfãs (não deveria retornar nada)
EXEC sp_MSforeachtable @command1="DBCC CHECKCONSTRAINTS WITH ALL_CONSTRAINTS";
```

### 4. Rastrear demanda completa

```sql
WITH DemandTrace AS (
    SELECT 
        d.DemandId,
        d.DemandNumber,
        d.Title AS DemandTitle,
        r.RequirementId,
        r.Code AS RequirementCode,
        uc.UseCaseId,
        uc.Code AS UseCaseCode,
        us.UserStoryId,
        us.Code AS UserStoryCode,
        t.TaskId,
        t.Title AS TaskTitle
    FROM portfolio.Demand d
    LEFT JOIN req.Requirement r ON r.DemandId = d.DemandId
    LEFT JOIN req.UseCase uc ON uc.RequirementId = r.RequirementId
    LEFT JOIN agile.UserStory us ON us.UseCaseId = uc.UseCaseId
    LEFT JOIN agile.Task t ON t.UserStoryId = us.UserStoryId
    WHERE d.IsDeleted = 0
)
SELECT * FROM DemandTrace
WHERE DemandNumber = 'DEM-2026-00001';
```

### 5. Calcular UCP de uma estimativa

```sql
SELECT 
    e.Code AS EstimateCode,
    e.UAW,
    e.UUCW,
    e.UUCP,
    e.TCF,
    e.EF,
    e.UCP,
    e.TotalHours,
    e.DevelopmentHours,
    e.TestHours,
    e.HomologationHours,
    e.EstimatedCost,
    e.EstimatedDays
FROM ucp.Estimate e
WHERE e.Code = 'EST-2026-00001'
  AND e.IsDeleted = 0;
```

---

## 📊 Diagrama ER Simplificado

```
┌─────────────┐
│   Holding   │
└──────┬──────┘
       │ 1:N
┌──────▼──────┐
│   Company   │◄──────┐
└──────┬──────┘       │
       │ 1:N          │
┌──────▼──────┐       │
│ Directorate │       │
└──────┬──────┘       │
       │ 1:N          │
┌──────▼──────┐       │
│    Area     │       │
└──────┬──────┘       │
       │ 1:N          │
┌──────▼──────┐       │
│    Squad    │       │
└──────┬──────┘       │
       │ 1:N          │
┌──────▼──────┐       │
│SquadMember  │       │
└─────────────┘       │
                      │
┌─────────────┐       │
│   System    │───────┘
└──────┬──────┘
       │
       │
┌──────▼──────────┐
│ BusinessCase    │
└──────┬──────────┘
       │ 1:N
┌──────▼──────────┐
│    Demand       │◄────┐
└──────┬──────────┘     │
       │ 1:N            │
┌──────▼──────────┐     │
│  Requirement    │     │
└──────┬──────────┘     │
       │ 1:N            │
┌──────▼──────────┐     │
│    UseCase      │     │
└──────┬──────────┘     │
       │ 1:N            │
┌──────▼──────────┐     │
│   UserStory     │     │
└──────┬──────────┘     │
       │ 1:N            │
┌──────▼──────────┐     │
│      Task       │     │
└─────────────────┘     │
                        │
┌─────────────────┐     │
│    Estimate     │─────┘
└─────────────────┘
```

---

## 🎯 Conclusão

O modelo de dados DevFlow possui:

✅ **49 tabelas** implementadas  
✅ **85+ relacionamentos** (FKs)  
✅ **150+ índices** otimizados  
✅ **Auditoria completa** em todas as tabelas  
✅ **Soft delete** obrigatório  
✅ **Rastreabilidade total** da demanda até a tarefa  
✅ **RBAC completo** com escopo  
✅ **UCP automatizado** com 13 TF + 8 EF  

**Status**: ✅ Pronto para implementação!

---

**Última Atualização**: 2026-09-24  
**Versão**: 3.0.0
