# Estrutura de Navegação - DevFlow ALYA

## Menu Principal

### 📊 Dashboard
- **Rota:** `/`
- **Ícone:** mdi-view-dashboard
- **Descrição:** Página inicial com visão geral do sistema

---

## 🏢 GOVERNANÇA (Schema: `gov`)

Cadastros relacionados à estrutura organizacional.

| Menu | Rota | Tabela | Status |
|------|------|--------|--------|
| Holdings | `/governance/holdings` | `gov.Holding` | ⏳ Pendente |
| Empresas | `/governance/companies` | `gov.Company` | ⏳ Pendente |
| Diretorias | `/governance/directorates` | `gov.Directorate` | ⏳ Pendente |
| Áreas | `/governance/areas` | `gov.Area` | ⏳ Pendente |
| Squads | `/governance/squads` | `gov.Squad` | ⏳ Pendente |
| Membros de Squad | `/governance/squad-members` | `gov.SquadMember` | ⏳ Pendente |

---

## 🔐 SEGURANÇA (Schema: `sec`)

Cadastros relacionados a usuários, perfis e permissões.

| Menu | Rota | Tabela | Status |
|------|------|--------|--------|
| Usuários | `/security/users` | `sec.User` | ⏳ Pendente |
| Perfis (Roles) | `/security/roles` | `sec.Role` | ⏳ Pendente |
| Permissões | `/security/permissions` | `sec.Permission` | ⏳ Pendente |
| Perfis de Usuário | `/security/user-roles` | `sec.UserRole` | ⏳ Pendente |
| Autorizações de Prioridade | `/security/priority-authorizations` | `sec.PriorityChangeAuthorization` | ⏳ Pendente |

---

## 📚 REFERÊNCIA (Schema: `ref`)

Tabelas de referência e domínio.

| Menu | Rota | Tabela | Status |
|------|------|--------|--------|
| Prioridades | `/priorities` | `ref.Priority` | ✅ Implementado |
| Tipos de Demanda | `/demand-types` | `ref.DemandType` | ✅ Implementado |
| Status de Workflow | `/workflow-status` | `ref.WorkflowStatus` | ✅ Implementado |
| Complexidade de Atores | `/actor-complexities` | `ref.ActorComplexity` | ✅ Implementado |
| Complexidade de Casos de Uso | `/usecase-complexities` | `ref.UseCaseComplexity` | ✅ Implementado |

---

## ⚙️ CONFIGURAÇÃO (Schema: `cfg`)

Configurações do sistema.

| Menu | Rota | Tabela | Status |
|------|------|--------|--------|
| Operações / Clientes | `/operations` | `cfg.Operation` | ✅ Implementado |
| Configurações UCP | `/ucp-configurations` | `cfg.UCPConfiguration` | ✅ Implementado |

---

## 👑 ADMINISTRAÇÃO (Schema: `auth`)

Apenas para Admin DevFlow.

| Menu | Rota | Tabela | Status |
|------|------|--------|--------|
| Configuração Entra ID | `/admin/entraid-tenants` | `auth.EntraIDTenant` | ✅ Implementado |

---

## Próximos Passos

### 1. Criar Views para Governança

```bash
frontend/src/views/governance/
├── HoldingView.vue
├── CompanyView.vue
├── DirectorateView.vue
├── AreaView.vue
├── SquadView.vue
└── SquadMemberView.vue
```

### 2. Criar Stores para Governança

```bash
frontend/src/stores/
├── holdingStore.js
├── companyStore.js
├── directorateStore.js
├── areaStore.js
├── squadStore.js
└── squadMemberStore.js
```

### 3. Criar Services para Governança

```bash
frontend/src/services/
├── holdingService.js
├── companyService.js
├── directorateService.js
├── areaService.js
├── squadService.js
└── squadMemberService.js
```

### 4. Criar Endpoints Backend

```bash
backend/app/api/v1/endpoints/
├── holding.py
├── company.py
├── directorate.py
├── area.py
├── squad.py
└── squad_member.py
```

### 5. Criar Schemas Backend

```bash
backend/app/schemas/
└── governance.py  # Todos os schemas de governança
```

### 6. Criar Domain Models Backend

```bash
backend/app/domain/
└── governance.py  # Já existe, verificar se tem todos os models
```

### 7. Criar Repositories Backend

```bash
backend/app/repositories/
└── governance.py  # Criar repositórios específicos
```

### 8. Criar Services Backend

```bash
backend/app/services/
└── governance.py  # Criar serviços específicos
```

---

## Padrão de Implementação

Para cada entidade, seguir o padrão:

### Backend
1. Domain Model (SQLAlchemy)
2. Schema (Pydantic - Create, Update, Response)
3. Repository (CRUD operations)
4. Service (Business logic)
5. Endpoint (FastAPI routes)
6. Registrar no `api.py`

### Frontend
1. Service (Axios - API calls)
2. Store (Pinia - State management)
3. View (Vue + Vuetify - UI)
4. Adicionar rota no `router/index.js`

---

## Estrutura de Pastas Completa

```
DevFlow_ALYA/
├── backend/
│   ├── app/
│   │   ├── api/v1/endpoints/
│   │   │   ├── governance/     # Novo
│   │   │   └── security/       # Novo
│   │   ├── domain/
│   │   │   ├── governance.py   # Expandir
│   │   │   └── security.py     # Criar
│   │   ├── repositories/
│   │   │   ├── governance.py   # Criar
│   │   │   └── security.py     # Criar
│   │   ├── schemas/
│   │   │   ├── governance.py   # Criar
│   │   │   └── security.py     # Criar
│   │   └── services/
│   │       ├── governance.py   # Criar
│   │       └── security.py     # Criar
│   └── ...
├── frontend/
│   ├── src/
│   │   ├── views/
│   │   │   ├── governance/     # Criar
│   │   │   └── security/       # Criar
│   │   ├── stores/
│   │   │   # Adicionar stores de gov e sec
│   │   └── services/
│   │       # Adicionar services de gov e sec
│   └── ...
└── ...
```

---

## Priorização

### Fase 1 - Governança (Mais Importante)
1. ✅ Holdings
2. ✅ Empresas
3. ✅ Diretorias
4. ✅ Áreas
5. ✅ Squads
6. ✅ Membros de Squad

### Fase 2 - Segurança
1. Usuários
2. Perfis (Roles)
3. Permissões
4. Perfis de Usuário
5. Autorizações de Prioridade

---

## Observações

- **Holdings e Empresas** são fundamentais pois são referenciadas por outras tabelas
- **Diretorias, Áreas e Squads** formam a hierarquia organizacional
- **Membros de Squad** vincula usuários a squads
- Todas as tabelas de **Segurança** são interdependentes
- Implementar validações de hierarquia (Holding → Company → Directorate → Area → Squad)

---

## Status Atual

- ✅ Menu atualizado com todas as seções
- ✅ Rotas definidas
- ⏳ Views pendentes (gov e sec)
- ⏳ Stores pendentes (gov e sec)
- ⏳ Services pendentes (gov e sec)
- ⏳ Backend endpoints pendentes (gov e sec)

---

**Última atualização:** 30/09/2026
