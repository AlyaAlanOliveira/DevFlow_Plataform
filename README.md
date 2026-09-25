# DevFlow ALYA - Plataforma de Governança de Engenharia de Software

## 📋 Visão Geral

**DevFlow** é uma plataforma corporativa enterprise para governança completa do ciclo de desenvolvimento de software do Grupo ALYA (ALYA, Mobyan e TaNaPorta).

**Status Atual**: ✅ **Modelagem de Banco de Dados Completa**

---

## 🗂️ Estrutura do Projeto

```
DevFlow_ALYA/
├── README.md (este arquivo)
├── RESUMO-EXECUTIVO.md
├── Architecture/
│   ├── DevFlow-README-Architecture.md
│   ├── DevFlow-SAD.md
│   ├── DevFlow-DER.md
│   ├── DevFlow-Development-Standards.md
│   ├── DevFlow-API-Standards.md
│   ├── DevFlow-AI-Architecture.md
│   └── DevFlow-ADR-Template.md
├── Database/
│   ├── README-Database.md
│   ├── IMPLEMENTACAO-COMPLETA.md
│   ├── TABELAS-RELACIONAMENTOS.md
│   ├── Database_Users.sql
│   ├── V1_0_0__Schemas.sql
│   ├── V1_1_0__Governance.sql
│   ├── V1_2_0__Security.sql
│   ├── V1_3_0__Portfolio.sql
│   ├── V1_4_0__Requirements.sql
│   ├── V1_5_0__Reference_Tables.sql
│   ├── V1_6_0__Governance_Expanded.sql
│   ├── V1_7_0__System_Catalog.sql
│   ├── V1_8_0__Configuration.sql
│   ├── V1_9_0__Security_Expanded.sql
│   ├── V2_0_0__Portfolio_Expanded.sql
│   ├── V2_1_0__Workflow.sql
│   ├── V2_2_0__Requirements_Expanded.sql
│   ├── V2_3_0__Agile.sql
│   ├── V2_4_0__UCP.sql
│   └── V3_0_0__Seed_Data.sql
├── Prompt/
│   ├── SystemPrompt.txt
│   ├── DevFlow-PRD-v2.0.md
│   ├── DevFlow-PRD-v3.0.md
│   └── DevFlow-PRD-v4.1.md
├── Modelos/
│   ├── 1 - Template - Demanda de desenvolvimento.pptx
│   ├── 2 - RNUC - Requisitos de Negócios - Users Cases Macro.docx
│   ├── 3 - User Stories Detalhada.docx
│   └── 4 - metrica-UCP-Modelo.xlsx
├── Image/
│   └── (logos e wallpapers)
└── Adr/
    └── (Architecture Decision Records - futuro)
```

---

## 📚 Documentação Principal

### 🎯 Para Começar

1. **[RESUMO-EXECUTIVO.md](./RESUMO-EXECUTIVO.md)** - Visão geral do projeto, conquistas e próximos passos
2. **[Database/README-Database.md](./Database/README-Database.md)** - Documentação completa do banco de dados
3. **[Architecture/DevFlow-README-Architecture.md](./Architecture/DevFlow-README-Architecture.md)** - Ordem de leitura da arquitetura

### 📖 Documentação de Arquitetura

| Documento | Descrição |
|-----------|-----------|
| [DevFlow-SAD.md](./Architecture/DevFlow-SAD.md) | Software Architecture Document |
| [DevFlow-DER.md](./Architecture/DevFlow-DER.md) | Diagrama Entidade-Relacionamento |
| [DevFlow-Development-Standards.md](./Architecture/DevFlow-Development-Standards.md) | Padrões de desenvolvimento obrigatórios |
| [DevFlow-API-Standards.md](./Architecture/DevFlow-API-Standards.md) | Padrões de APIs REST |
| [DevFlow-AI-Architecture.md](./Architecture/DevFlow-AI-Architecture.md) | Arquitetura de IA Multiagente |
| [DevFlow-ADR-Template.md](./Architecture/DevFlow-ADR-Template.md) | Template para ADRs |

### 🗄️ Documentação de Banco de Dados

| Documento | Descrição |
|-----------|-----------|
| [README-Database.md](./Database/README-Database.md) | Documentação completa do banco |
| [IMPLEMENTACAO-COMPLETA.md](./Database/IMPLEMENTACAO-COMPLETA.md) | Guia de implementação e próximos passos |
| [TABELAS-RELACIONAMENTOS.md](./Database/TABELAS-RELACIONAMENTOS.md) | Inventário de tabelas e relacionamentos |

### 📝 PRDs (Product Requirements Documents)

| Versão | Arquivo | Status |
|--------|---------|--------|
| v2.0 | [DevFlow-PRD-v2.0.md](./Prompt/DevFlow-PRD-v2.0.md) | Histórico |
| v3.0 | [DevFlow-PRD-v3.0.md](./Prompt/DevFlow-PRD-v3.0.md) | Histórico |
| v4.1 | [DevFlow-PRD-v4.1.md](./Prompt/DevFlow-PRD-v4.1.md) | ✅ Atual |

---

## 🎯 O Que Foi Entregue

### ✅ Modelagem Completa do Banco de Dados

- **16 Scripts SQL** versionados (padrão Flyway)
- **49 Tabelas** organizadas em 16 schemas (DDD)
- **85+ Relacionamentos** (Foreign Keys)
- **150+ Índices** otimizados
- **Dados Seed** completos
- **Documentação técnica** detalhada

### ✅ Dados Voláteis → Tabelas Configuráveis

Todos os dados "voláteis" foram transformados em **tabelas CRUD**:

| Dado | Tabela | Schema |
|------|--------|--------|
| Prioridades | `Priority` | `ref` |
| Tipos de Demanda | `DemandType` | `ref` |
| Status de Workflow | `WorkflowStatus` | `ref` |
| Operações/Clientes | `Operation` | `cfg` |
| Fatores UCP | `UCPConfiguration` | `cfg` |
| Estrutura Organizacional | `Directorate`, `Area`, `Squad` | `gov` |
| Sistemas | `System` | `sys` |
| Papéis e Permissões | `Role`, `Permission` | `sec` |

---

## 🏗️ Arquitetura

### Schemas (Domain-Driven Design)

```
ref       → Dados de Referência
cfg       → Configurações
sec       → Segurança (RBAC)
gov       → Governança Organizacional
sys       → Catálogo de Sistemas
portfolio → Business Cases e Demandas
workflow  → Fluxo de Aprovações
req       → Requisitos e Casos de Uso
agile     → User Stories, Sprints, Tasks
ucp       → Estimativas Use Case Points
qa        → Qualidade e Testes (futuro)
release   → Release e GMUD (futuro)
file      → Gestão de Arquivos (futuro)
ai        → IA Multiagente (futuro)
audit     → Auditoria (futuro)
bi        → Analytics e BI (futuro)
```

### Cadeia de Rastreabilidade

```
BusinessCase → Demand → Requirement → UseCase → UserStory → Task → TestCase → Release → GMUD → Production
```

### Stack Tecnológico

| Camada | Tecnologia |
|--------|------------|
| **Frontend** | Vue 3 + TypeScript + Pinia + Vuetify |
| **Backend** | Python + FastAPI + SQLAlchemy |
| **Banco** | SQL Server 2025 |
| **Cache** | Redis |
| **Mensageria** | RabbitMQ |
| **IA** | Azure OpenAI + Azure AI Search |
| **Observabilidade** | OpenTelemetry + Grafana + Prometheus |
| **Autenticação** | Microsoft Entra ID |

---

## 🚀 Próximos Passos

### Fase 1: Validação (1 semana)
- [ ] Executar scripts SQL em ambiente de teste
- [ ] Validar integridade referencial
- [ ] Carregar dados seed

### Fase 2: Dados Iniciais (1 semana)
- [ ] Cadastrar Holding ALYA
- [ ] Cadastrar empresas (ALYA, Mobyan, TaNaPorta)
- [ ] Criar estrutura organizacional
- [ ] Cadastrar sistemas existentes
- [ ] Sincronizar usuários do Entra ID

### Fase 3: Backend API (4-6 semanas)
- [ ] Setup FastAPI + SQLAlchemy
- [ ] Autenticação Entra ID
- [ ] APIs CRUD completas
- [ ] Cálculo automático de UCP
- [ ] Testes (80%+ cobertura)

### Fase 4: Frontend (4-6 semanas)
- [ ] Setup Vue 3 + Vuetify
- [ ] Telas de administração
- [ ] Workflow de demandas
- [ ] Estimativas UCP
- [ ] Kanban de sprints
- [ ] Dashboards

### Fase 5: IA Multiagente (4-8 semanas)
- [ ] AI Demand Analyst
- [ ] AI Business Analyst
- [ ] AI Requirement Engineer
- [ ] AI Scrum Specialist
- [ ] AI UCP Specialist
- [ ] AI Architect
- [ ] AI Quality Reviewer

---

## 📊 Principais Funcionalidades

### 1. Estrutura Organizacional
- Holding → Company → Directorate → Area → Squad → SquadMember
- Segregação de dados por empresa
- Fatores ambientais (EF) por squad para UCP

### 2. Sistema UCP (Use Case Points)
- Cálculo automático: `UCP = (UAW + UUCW) × TCF × EF`
- 13 Fatores Técnicos (herdados do Sistema)
- 8 Fatores Ambientais (herdados da Squad)
- Histórico de estimativas para análise

### 3. Workflow de Aprovações
- Configurável por entidade
- Múltiplos aprovadores
- Histórico completo
- Versionamento de artefatos

### 4. RBAC (Role-Based Access Control)
- 9 Roles padrão (Admin, PO, SM, BA, DEV, QA, etc.)
- Permissões granulares por recurso e ação
- Escopo por Área ou Sistema

### 5. Auditoria Total
- 8 campos de auditoria em todas as tabelas
- Soft delete obrigatório
- Versionamento de entidades
- Histórico de mudanças de status

---

## 📈 Estatísticas

| Métrica | Valor |
|---------|-------|
| Schemas | 16 |
| Tabelas | 49 |
| Relacionamentos | 85+ |
| Índices | 150+ |
| Scripts SQL | 16 |
| Linhas de SQL | ~3.000 |
| Dados Seed | 100+ registros |

---

## 🔐 Segurança

- **Autenticação**: Microsoft Entra ID (Azure AD)
- **Autorização**: RBAC com escopo granular
- **MFA**: Obrigatório
- **Soft Delete**: Exclusão física proibida
- **Auditoria**: Todos os campos obrigatórios
- **Criptografia**: TDE (Transparent Data Encryption)
- **Row-Level Security**: Multi-tenancy

---

## 📞 Suporte

### Documentação
- [Architecture/](./Architecture/) - Documentação de arquitetura
- [Database/](./Database/) - Documentação de banco de dados
- [Prompt/](./Prompt/) - PRDs e prompts

### Contatos
- **Projeto**: DevFlow ALYA
- **Versão**: 3.0.0
- **Data**: 2026-09-24
- **Status**: ✅ Modelagem Completa

---

## 📝 Licença

Propriedade do Grupo ALYA - Todos os direitos reservados.

---

## 🎯 Roadmap

### MVP (3 meses)
- ✅ Modelagem de dados
- 🔄 Backend API
- 🔄 Frontend básico
- Governança, Sistemas e Demandas

### V1 (6 meses)
- Requisitos, UML e User Stories
- Workflow de aprovações
- Estimativas UCP

### V2 (9 meses)
- Sprints e Kanban
- Dashboards executivos
- Relatórios

### V3 (12 meses)
- Release e GMUD
- Testes automatizados
- Integração CI/CD

### V4 (18 meses)
- IA Multiagente
- Analytics avançado
- Predições e ML

---

**Desenvolvido com ❤️ para o Grupo ALYA**

**ALYA** | **Mobyan** | **TaNaPorta**
