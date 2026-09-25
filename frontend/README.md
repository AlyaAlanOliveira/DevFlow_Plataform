# DevFlow Frontend

## 📋 Visão Geral

Frontend do DevFlow ALYA construído com **Vue 3**, **Vuetify 3** e **Pinia**.

## 🏗️ Arquitetura

```
frontend/
├── src/
│   ├── components/       # Componentes reutilizáveis
│   ├── views/            # Views/Pages
│   │   ├── reference/    # Telas de referência
│   │   └── configuration/# Telas de configuração
│   ├── layouts/          # Layouts da aplicação
│   ├── stores/           # Pinia stores
│   ├── services/         # Serviços de API
│   ├── router/           # Vue Router
│   ├── plugins/          # Plugins (Vuetify, etc)
│   ├── assets/           # Assets estáticos
│   └── utils/            # Utilitários
├── index.html
├── vite.config.js
└── package.json
```

## 🚀 Setup

### 1. Instalar dependências

```bash
cd frontend
npm install
```

### 2. Configurar variáveis de ambiente

```bash
copy .env.example .env
# Editar .env se necessário
```

### 3. Executar em desenvolvimento

```bash
npm run dev
```

Aplicação estará disponível em: http://localhost:5173

### 4. Build para produção

```bash
npm run build
```

## 📚 Telas Disponíveis

### **Dashboard**
- Visão geral do sistema
- Estatísticas
- Ações rápidas

### **Referência**
- ✅ Prioridades
- ✅ Tipos de Demanda
- ✅ Status de Workflow
- ✅ Complexidade de Atores
- ✅ Complexidade de Casos de Uso

### **Configuração**
- ✅ Operações
- ✅ Configurações UCP

## 🎨 Componentes

### **DataTable**
Componente genérico de tabela com:
- Pesquisa
- Ordenação
- Paginação
- Ações (Adicionar, Editar, Excluir)

**Uso:**
```vue
<DataTable
  title="Prioridades"
  icon="mdi-flag"
  :headers="headers"
  :items="items"
  :loading="loading"
  @add="openDialog()"
  @edit="openDialog($event)"
  @delete="confirmDelete($event)"
/>
```

## 🔌 Serviços de API

Todos os serviços herdam de `BaseService` com operações CRUD:

```javascript
import { priorityService } from '@/services/referenceService'

// Listar
const response = await priorityService.getAll({ active_only: true })

// Buscar por ID
const item = await priorityService.getById(id)

// Criar
const newItem = await priorityService.create(data)

// Atualizar
const updated = await priorityService.update(id, data)

// Deletar
await priorityService.delete(id)
```

## 📦 Stores (Pinia)

Exemplo de uso:

```javascript
import { usePriorityStore } from '@/stores/priorityStore'

const priorityStore = usePriorityStore()

// Carregar dados
await priorityStore.fetchAll()

// Acessar state
console.log(priorityStore.priorities)
console.log(priorityStore.loading)

// Criar
await priorityStore.create(data)

// Atualizar
await priorityStore.update(id, data)

// Deletar
await priorityStore.remove(id)
```

## 🎨 Tema

O tema Vuetify está configurado em `src/plugins/vuetify.js`:

```javascript
const devflowTheme = {
  dark: false,
  colors: {
    primary: '#1976D2',
    secondary: '#424242',
    accent: '#82B1FF',
    error: '#FF5252',
    info: '#2196F3',
    success: '#4CAF50',
    warning: '#FB8C00',
  }
}
```

## 🔐 Autenticação

TODO: Implementar autenticação com Microsoft Entra ID

## 🧪 Testes

```bash
npm run test
```

## 📝 Padrões de Código

### Componentes Vue
- Usar Composition API (`<script setup>`)
- Props tipadas
- Emits definidos
- Componentes reutilizáveis em `components/`

### Stores
- Um store por entidade
- State reativo com `ref()`
- Actions assíncronas
- Tratamento de erros

### Serviços
- Herdar de `BaseService`
- Métodos assíncronos
- Tratamento de erros no interceptor

## 📞 Suporte

Para dúvidas ou problemas:
- Consulte a documentação do Vue 3: https://vuejs.org/
- Consulte a documentação do Vuetify: https://vuetifyjs.com/

---

**Versão**: 1.0.0  
**Última Atualização**: 2026-09-25  
**Desenvolvido para**: Grupo ALYA
