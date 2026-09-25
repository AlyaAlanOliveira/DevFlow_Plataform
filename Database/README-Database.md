# DevFlow - Database Documentation

## 📋 Visão Geral

Este diretório contém todos os scripts SQL para criação e manutenção do banco de dados DevFlow.

## 🗂️ Estrutura de Schemas

O banco de dados está organizado em **16 schemas** seguindo princípios de **Domain-Driven Design (DDD)**:

| Schema | Descrição | Tabelas |
|--------|-----------|---------|
| `ref` | Dados de Referência | Priority, DemandType, WorkflowStatus, ActorComplexity, UseCaseComplexity |
| `cfg` | Configurações | Operation, UCPConfiguration, ApplicationSettings |
| `sec` | Segurança e Autenticação | User, Role, Permission, RolePermission, UserRole, PriorityChangeAuthorization |
| `gov` | Governança Organizacional | Holding, Company, Directorate, Area, Squad, SquadMember |
| `sys` | Catálogo de Sistemas | System, SystemIntegration |
| `portfolio` | Gestão de Portfolio | BusinessCase, Demand, DemandOperation, DemandPriorityHistory |
| `workflow` | Controle de Fluxo | ApprovalFlow, ApprovalStep, EntityRevision, StatusTransition, Assignment |
| `req` | Requisitos | Requirement, UseCase, Actor, UseCaseActor, RequirementDependency |
| `agile` | Gestão Ágil | UserStory, BusinessRule, AcceptanceCriteria, Sprint, SprintUserStory, Task |
| `ucp` | Estimativas UCP | Estimate, TechnicalFactor, EnvironmentalFactor, EstimateActorWeight, EstimateUseCaseWeight, EstimateHistory |
| `qa` | Qualidade e Testes | (futuro) |
| `release` | Release e GMUD | (futuro) |
| `file` | Gestão de Arquivos | (futuro) |
| `ai` | IA Multiagente | (futuro) |
| `audit` | Auditoria | (futuro) |
| `bi` | Analytics e BI | (futuro) |

## 📦 Scripts de Migração (Flyway)

Os scripts seguem o padrão **Flyway** de versionamento:

```
V{versão}__{descrição}.sql
```

### Ordem de Execução

1. **V1_0_0__Schemas.sql** - Criação dos schemas
2. **V1_1_0__Governance.sql** - Holding e Company
3. **V1_2_0__Security.sql** - User
4. **V1_3_0__Portfolio.sql** - BusinessCase e Demand (básico)
5. **V1_4_0__Requirements.sql** - Requirement (básico)
6. **V1_5_0__Reference_Tables.sql** - Tabelas de domínio
7. **V1_6_0__Governance_Expanded.sql** - Directorate, Area, Squad
8. **V1_7_0__System_Catalog.sql** - System e SystemIntegration
9. **V1_8_0__Configuration.sql** - Operation, UCPConfiguration
10. **V1_9_0__Security_Expanded.sql** - RBAC completo
11. **V2_0_0__Portfolio_Expanded.sql** - Expansão de BusinessCase e Demand
12. **V2_1_0__Workflow.sql** - Fluxo de aprovações
13. **V2_2_0__Requirements_Expanded.sql** - UseCase, Actor
14. **V2_3_0__Agile.sql** - UserStory, Sprint, Task
15. **V2_4_0__UCP.sql** - Sistema completo de estimativas
16. **V3_0_0__Seed_Data.sql** - Dados iniciais

## 🔗 Cadeia de Rastreabilidade

```
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
TestCase (futuro)
    ↓
Release (futuro)
    ↓
GMUD (futuro)
```

## 🏗️ Estrutura Organizacional

```
Holding (ALYA)
    ↓
Company (ALYA, Mobyan, TaNaPorta)
    ↓
Directorate (Diretoria de TI, Operações, etc.)
    ↓
Area (Desenvolvimento, Infraestrutura, etc.)
    ↓
Squad (Squad Backend, Squad Frontend, etc.)
    ↓
SquadMember (Desenvolvedores, Analistas, QAs)
```

## 📊 Modelo UCP (Use Case Points)

### Fórmula

```
UCP = (UAW + UUCW) × TCF × EF
```

Onde:
- **UAW** = Unadjusted Actor Weight (peso dos atores)
- **UUCW** = Unadjusted Use Case Weight (peso dos casos de uso)
- **TCF** = Technical Complexity Factor (fatores técnicos do sistema)
- **EF** = Environmental Factor (fatores ambientais da squad)

### Fatores Técnicos (TCF) - 13 fatores

Armazenados na tabela `sys.System`:

| Código | Descrição | Peso |
|--------|-----------|------|
| TF1 | Sistema distribuído | 2.0 |
| TF2 | Tempo de resposta/throughput | 1.0 |
| TF3 | Eficiência do usuário final | 1.0 |
| TF4 | Processamento complexo | 1.0 |
| TF5 | Reusabilidade | 1.0 |
| TF6 | Facilidade de instalação | 0.5 |
| TF7 | Facilidade de uso | 0.5 |
| TF8 | Portabilidade | 2.0 |
| TF9 | Facilidade de mudança | 1.0 |
| TF10 | Concorrência | 1.0 |
| TF11 | Segurança | 1.0 |
| TF12 | Acesso de terceiros | 1.0 |
| TF13 | Treinamento especial | 1.0 |

### Fatores Ambientais (EF) - 8 fatores

Armazenados na tabela `gov.Squad`:

| Código | Descrição | Peso |
|--------|-----------|------|
| FA1 | Familiaridade com RUP | 1.5 |
| FA2 | Experiência na aplicação | 0.5 |
| FA3 | Experiência OO | 1.0 |
| FA4 | Capacidade do analista líder | 0.5 |
| FA5 | Motivação | 1.0 |
| FA6 | Requisitos estáveis | 2.0 |
| FA7 | Pessoal part-time | -1.0 |
| FA8 | Dificuldade linguagem | -1.0 |

### Complexidade de Atores

| Tipo | Peso | Descrição |
|------|------|-----------|
| Simple | 1 | API definida |
| Average | 2 | Protocolo ou interface |
| Complex | 3 | Interface gráfica |

### Complexidade de Casos de Uso

| Tipo | Transações | Peso | Descrição |
|------|-----------|------|-----------|
| Simple | 1-3 | 5 | Caso de uso simples |
| Average | 4-7 | 10 | Caso de uso médio |
| Complex | 8+ | 15 | Caso de uso complexo |

## 🔐 Segurança e Auditoria

### Campos de Auditoria (Obrigatórios)

Todas as tabelas transacionais possuem:

```sql
CreatedAt DATETIME2 NOT NULL DEFAULT GETUTCDATE()
CreatedBy UNIQUEIDENTIFIER NOT NULL
UpdatedAt DATETIME2
UpdatedBy UNIQUEIDENTIFIER
DeletedAt DATETIME2
DeletedBy UNIQUEIDENTIFIER
IsDeleted BIT NOT NULL DEFAULT 0
RowVersion ROWVERSION
```

### Soft Delete

**Exclusão física é proibida**. Todas as exclusões são lógicas através de:
- `IsDeleted = 1`
- `DeletedAt = <timestamp>`
- `DeletedBy = <userId>`

### RBAC (Role-Based Access Control)

Sistema completo de permissões:

1. **Role** - Papéis (Admin, PO, SM, BA, DEV, QA, etc.)
2. **Permission** - Permissões granulares (Create, Read, Update, Delete, Approve, etc.)
3. **RolePermission** - Permissões por papel
4. **UserRole** - Papéis dos usuários (com escopo por Área ou Sistema)

## 📝 Convenções de Nomenclatura

### Tabelas
- **PascalCase**: `BusinessCase`, `UserStory`, `DemandOperation`

### Colunas
- **PK**: `<TableName>Id` (ex: `DemandId`, `RequirementId`)
- **FK**: `<Field>Id` (ex: `SystemId`, `UserId`)

### Constraints
- **PK**: `PK_<Schema>_<Table>`
- **FK**: `FK_<Source>_<Target>`
- **UK**: `UK_<Table>_<Field>`
- **CK**: `CK_<Table>_<Rule>`
- **DF**: `DF_<Table>_<Field>`

### Códigos de Entidades

| Entidade | Formato | Exemplo |
|----------|---------|---------|
| Business Case | BC-YYYY-NNNNN | BC-2026-00001 |
| Demanda | DEM-YYYY-NNNNN | DEM-2026-00045 |
| Requisito Funcional | RF-YYYY-NNNNN | RF-2026-00123 |
| Regra de Negócio | RN-YYYY-NNNNN | RN-2026-00456 |
| Requisito Não Funcional | RNF-YYYY-NNNNN | RNF-2026-00789 |
| Caso de Uso | UC-YYYY-NNNNN | UC-2026-00012 |
| User Story | US-YYYY-NNNNN | US-2026-00345 |
| Estimativa | EST-YYYY-NNNNN | EST-2026-00067 |
| Release | REL-YYYY-NNNNN | REL-2026-00008 |
| GMUD | GMUD-YYYY-NNNNN | GMUD-2026-00009 |

## 🚀 Como Executar

### 1. Criar o Banco de Dados

```sql
CREATE DATABASE DevFlow_ALYA;
GO
```

### 2. Criar Usuários

```bash
sqlcmd -S ALYA-TI-001\SQLSERVERLOCAL -d DevFlow_ALYA -i Database_Users.sql
```

### 3. Executar Migrações (Ordem)

```bash
# Schemas
sqlcmd -S ALYA-TI-001\SQLSERVERLOCAL -d DevFlow_ALYA -U DevFlowAdm -P "D3vFl0w#Aly@" -i V1_0_0__Schemas.sql

# Governança básica
sqlcmd -S ALYA-TI-001\SQLSERVERLOCAL -d DevFlow_ALYA -U DevFlowAdm -P "D3vFl0w#Aly@" -i V1_1_0__Governance.sql

# Segurança básica
sqlcmd -S ALYA-TI-001\SQLSERVERLOCAL -d DevFlow_ALYA -U DevFlowAdm -P "D3vFl0w#Aly@" -i V1_2_0__Security.sql

# ... e assim por diante
```

### 4. Ou usar Flyway (Recomendado)

```bash
flyway -url=jdbc:sqlserver://ALYA-TI-001\SQLSERVERLOCAL;databaseName=DevFlow_ALYA -user=DevFlowAdm -password=D3vFl0w#Aly@ migrate
```

## 📈 Estatísticas

- **Total de Schemas**: 16
- **Total de Tabelas**: 50+
- **Total de Relacionamentos**: 80+
- **Campos de Auditoria**: 8 por tabela
- **Índices**: 150+

## 🔄 Versionamento

As entidades abaixo possuem **versionamento obrigatório** (tabela `workflow.EntityRevision`):

- BusinessCase
- Demand
- Requirement
- UseCase
- UserStory
- Estimate
- Document
- PromptTemplate
- Release
- GMUD

## 📞 Suporte

Para dúvidas ou problemas:
1. Consulte a documentação em `Architecture/`
2. Verifique os ADRs (Architecture Decision Records)
3. Entre em contato com a equipe de arquitetura

---

**Versão**: 3.0.0  
**Última Atualização**: 2026-09-24  
**Responsável**: DevFlow Team
