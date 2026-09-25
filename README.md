# 🚀 DevFlow ALYA

## Plataforma de Governança de Engenharia de Software

**Versão:** 1.0.0  
**Status:** ✅ MVP Funcional  
**Data:** 2026-09-25

---

## 📋 Visão Geral

O **DevFlow ALYA** é uma plataforma corporativa enterprise para governança completa do ciclo de desenvolvimento de software do Grupo ALYA (ALYA, Mobyan e TaNaPorta).

### Workflow Completo

```
Business Case → Demand → Requirement → UseCase → UserStory 
    → Estimate (UCP) → Sprint → Test → Release → GMUD → Production
```

---

## ✅ O Que Está Pronto

| Componente | Status | Descrição |
|------------|--------|-----------|
| **Banco de Dados** | ✅ 100% | 49 tabelas, 16 schemas, seed data |
| **Backend API** | ✅ 100% | 35 endpoints REST, 7 entidades |
| **Frontend Web** | ✅ MVP | Dashboard + CRUD Priority |
| **Documentação** | ✅ Completa | 15 documentos de referência |

---

## 🚀 Início Rápido

### **Opção 1: Scripts Automáticos** ⭐ Recomendado

```bash
# Iniciar tudo de uma vez
start-all.bat
```

### **Opção 2: Manual**

**Backend:**
```bash
cd backend
python -m venv venv
source venv/Scripts/activate  # Git Bash
pip install -r requirements.txt
python run.py
```

**Frontend:**
```bash
cd frontend
npm install
npm run dev
```

### **Acessar:**
- **Backend API:** http://localhost:8000/docs
- **Frontend Web:** http://localhost:5173

---

## 📁 Estrutura do Projeto

```
DevFlow_ALYA/
├── Database/              # ✅ 16 Scripts SQL
│   ├── V1_*.sql          # Schemas e tabelas base
│   ├── V2_*.sql          # Expansões
│   ├── V3_*.sql          # Seed data
│   └── *.md              # Documentação
│
├── backend/               # ✅ Backend API (FastAPI)
│   ├── app/
│   │   ├── api/          # 7 endpoints REST
│   │   ├── core/         # Configurações
│   │   ├── domain/       # 8 models SQLAlchemy
│   │   ├── repositories/ # 8 repositories
│   │   ├── schemas/      # 21 schemas Pydantic
│   │   └── services/     # 7 services
│   ├── run.py            # Script de execução
│   ├── test_api.py       # Testes automáticos
│   └── *.md              # Documentação
│
└── frontend/              # ✅ Frontend Web (Vue 3)
    ├── src/
    │   ├── components/   # DataTable reutilizável
    │   ├── views/        # Dashboard, Priority
    │   ├── layouts/      # MainLayout
    │   ├── stores/       # Pinia stores
    │   ├── services/     # API services
    │   ├── router/       # Vue Router
    │   └── plugins/      # Vuetify
    └── *.md              # Documentação
```

---

## 🔌 APIs Disponíveis

### **Referência (ref schema)**
- ✅ `/api/v1/priorities` - Prioridades
- ✅ `/api/v1/demand-types` - Tipos de Demanda
- ✅ `/api/v1/workflow-status` - Status de Workflow
- ✅ `/api/v1/actor-complexities` - Complexidade de Atores
- ✅ `/api/v1/usecase-complexities` - Complexidade de Casos de Uso

### **Configuração (cfg schema)**
- ✅ `/api/v1/operations` - Operações/Clientes
- ✅ `/api/v1/ucp-configurations` - Configurações UCP

**Total:** 35 endpoints REST (7 entidades × 5 operações CRUD)

---

## 🖥️ Telas Disponíveis

| Tela | Rota | Status |
|------|------|--------|
| Dashboard | `/` | ✅ Completo |
| Prioridades | `/priorities` | ✅ CRUD Completo |
| Tipos de Demanda | `/demand-types` | 🔄 Rota criada |
| Status Workflow | `/workflow-status` | 🔄 Rota criada |
| Complexidade Atores | `/actor-complexities` | 🔄 Rota criada |
| Complexidade Casos de Uso | `/usecase-complexities` | 🔄 Rota criada |
| Operações | `/operations` | 🔄 Rota criada |
| Configurações UCP | `/ucp-configurations` | 🔄 Rota criada |

---

## 📚 Documentação

### **Guias de Início**
- 📖 [Guia de Execução](./GUIA-EXECUCAO.md) - Passo a passo completo
- ✅ [Checklist de Execução](./CHECKLIST-EXECUCAO.md) - Validação
- 🎯 [Projeto Completo](./PROJETO-COMPLETO.md) - Visão geral

### **Banco de Dados**
- 📊 [README Database](./Database/README-Database.md)
- 🔧 [Implementação](./Database/IMPLEMENTACAO-COMPLETA.md)
- 🗂️ [Tabelas e Relacionamentos](./Database/TABELAS-RELACIONAMENTOS.md)

### **Backend**
- 📖 [README Backend](./backend/README.md)
- ⚡ [Quick Start](./backend/QUICK_START.md)
- 📚 [API Reference](./backend/API-REFERENCE.md)
- 🔧 [Implementação](./backend/IMPLEMENTACAO-BACKEND.md)
- 📊 [Resumo Final](./backend/RESUMO-FINAL.md)

### **Frontend**
- 📖 [README Frontend](./frontend/README.md)
- ⚡ [Quick Start](./frontend/QUICK_START.md)
- 🔧 [Implementação](./frontend/IMPLEMENTACAO-FRONTEND.md)

---

## 🏗️ Arquitetura

### **Backend: Clean Architecture + DDD**

```
┌─────────────────────────────────────────┐
│         API Layer (FastAPI)             │
│  - REST Controllers                     │
│  - Swagger/OpenAPI                      │
└─────────────────┬───────────────────────┘
                  │
┌─────────────────▼───────────────────────┐
│      Service Layer (Business Logic)     │
│  - Validações de negócio                │
│  - Orquestração                         │
└─────────────────┬───────────────────────┘
                  │
┌─────────────────▼───────────────────────┐
│    Repository Layer (Data Access)       │
│  - CRUD genérico                        │
│  - Queries especializadas               │
└─────────────────┬───────────────────────┘
                  │
┌─────────────────▼───────────────────────┐
│       Domain Layer (Models)             │
│  - SQLAlchemy ORM                       │
│  - Auditoria automática                 │
└─────────────────────────────────────────┘
```

### **Frontend: Vue 3 + Composition API**

```
┌─────────────────────────────────────────┐
│         Views (Pages)                   │
│  - Dashboard, Priority, etc.            │
└─────────────────┬───────────────────────┘
                  │
┌─────────────────▼───────────────────────┐
│      Components (Reusable)              │
│  - DataTable, Forms, etc.               │
└─────────────────┬───────────────────────┘
                  │
┌─────────────────▼───────────────────────┐
│       Stores (Pinia)                    │
│  - State Management                     │
└─────────────────┬───────────────────────┘
                  │
┌─────────────────▼───────────────────────┐
│       Services (API Client)             │
│  - Axios + Interceptors                 │
└─────────────────────────────────────────┘
```

---

## 🎨 Stack Tecnológico

### **Backend**
- Python 3.13+
- FastAPI
- SQLAlchemy
- Pydantic
- SQL Server 2025

### **Frontend**
- Vue 3 (Composition API)
- Vuetify 3
- Pinia
- Vue Router
- Axios
- Vite

### **Infraestrutura**
- Docker (futuro)
- Kubernetes (futuro)
- Azure (futuro)

---

## ✨ Funcionalidades Principais

### **✅ Implementadas**
- CRUD completo de entidades de domínio
- Soft delete obrigatório
- Auditoria completa (8 campos)
- Paginação em todas as listagens
- Validação robusta (Pydantic + Vue)
- Feedback visual (loading, success, error)
- Documentação Swagger automática
- Componentes reutilizáveis

### **🔄 Em Desenvolvimento**
- Demais telas de referência
- Autenticação (Entra ID)
- Workflow de aprovações
- Cálculo automático de UCP
- Dashboards avançados

---

## 📊 Estatísticas

| Métrica | Valor |
|---------|-------|
| **Arquivos Totais** | 84 |
| **Linhas de Código** | ~12.700 |
| **Tabelas no Banco** | 49 |
| **Endpoints REST** | 35 |
| **Componentes Vue** | 4 |
| **Documentos** | 15 |

---

## 🔜 Roadmap

### **Fase 1: Completar Frontend** (2-3 horas)
- [ ] Implementar demais telas de referência
- [ ] Testar todas as funcionalidades
- [ ] Ajustes de UX

### **Fase 2: Expandir Backend** (1-2 semanas)
- [ ] APIs de Governança
- [ ] APIs de Portfolio
- [ ] APIs de Requisitos
- [ ] APIs de Agile

### **Fase 3: Autenticação** (1 semana)
- [ ] Integração Entra ID
- [ ] RBAC
- [ ] Controle de acesso

### **Fase 4: Funcionalidades Avançadas** (2-3 semanas)
- [ ] Workflow de aprovações
- [ ] Cálculo UCP
- [ ] Relatórios
- [ ] Dashboards avançados

---

## 🤝 Contribuindo

Este é um projeto interno do Grupo ALYA.

---

## 📞 Suporte

Para dúvidas ou problemas:
1. Consulte a documentação
2. Verifique os logs (backend e frontend)
3. Teste endpoints no Swagger
4. Verifique o console do navegador (F12)

---

## 📄 Licença

Propriedade do Grupo ALYA - Todos os direitos reservados.

---

## 🎉 Agradecimentos

Desenvolvido para:
- **ALYA**
- **Mobyan**
- **TaNaPorta**

---

**Última Atualização:** 2026-09-25  
**Versão:** 1.0.0  
**Status:** ✅ MVP Funcional
