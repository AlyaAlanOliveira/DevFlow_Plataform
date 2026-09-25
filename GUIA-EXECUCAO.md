# 🚀 DevFlow ALYA - Guia de Execução Completo

## ✅ Pré-requisitos

Antes de começar, verifique se você tem instalado:

- [ ] **Python 3.11-3.14** - `python --version` (recomendado: 3.11 ou 3.13)
- [ ] **Node.js 18+** - `node --version`
- [ ] **SQL Server 2025** - Rodando e acessível
- [ ] **Git Bash** (Windows) ou terminal bash

---

## 📋 PASSO A PASSO

### **ETAPA 1: Verificar Banco de Dados** ✅

O banco de dados já está criado e populado com os scripts SQL que foram executados anteriormente.

**Verificar conexão:**

```sql
-- Conectar ao SQL Server
Server: ALYA-TI-001\SQLSERVERLOCAL
Database: DevFlow_ALYA
User: DevFlowUser
Password: (conforme configurado)

-- Verificar schemas
SELECT name FROM sys.schemas 
WHERE name IN ('ref','cfg','sec','gov','sys','portfolio','workflow','req','agile','ucp')
ORDER BY name;

-- Verificar dados seed
SELECT 'Priority' AS Tabela, COUNT(*) AS Registros FROM ref.Priority WHERE IsDeleted = 0
UNION ALL
SELECT 'DemandType', COUNT(*) FROM ref.DemandType WHERE IsDeleted = 0
UNION ALL
SELECT 'WorkflowStatus', COUNT(*) FROM ref.WorkflowStatus WHERE IsDeleted = 0;
```

**Resultado esperado:**
- ✅ 10 schemas encontrados
- ✅ Prioridades: 5 registros
- ✅ DemandTypes: 8 registros
- ✅ WorkflowStatus: 40+ registros

---

### **ETAPA 2: Configurar e Executar Backend** 🔧

#### **2.1. Criar ambiente virtual**

```bash
cd C:\DevAlya\DevFlow_ALYA\backend
python -m venv venv
```

#### **2.2. Ativar ambiente virtual**

**Windows (Git Bash):**
```bash
source venv/Scripts/activate
```

**Windows (CMD):**
```cmd
venv\Scripts\activate
```

**Windows (PowerShell):**
```powershell
venv\Scripts\Activate.ps1
```

#### **2.3. Instalar dependências**

**⚠️ IMPORTANTE: Se você está usando Python 3.14+**

O `pydantic-core` no `requirements.txt` pode falhar ao compilar com Python 3.14. Use este método:

```bash
# Atualizar pip
pip install --upgrade pip

# Instalar versões compatíveis do pydantic primeiro
pip install --upgrade pydantic pydantic-core --no-build-isolation

# Instalar dependências principais
pip install fastapi uvicorn sqlalchemy python-multipart alembic pyodbc python-dotenv pydantic-settings
```

**Se você está usando Python 3.11-3.13:**

```bash
pip install --upgrade pip
pip install -r requirements.txt
```

**Tempo estimado:** 2-3 minutos

#### **2.4. Configurar variáveis de ambiente**

```bash
# Copiar exemplo
cp .env.example .env

# Editar .env (use seu editor preferido)
# Verificar principalmente:
# - DB_SERVER=ALYA-TI-001\SQLSERVERLOCAL
# - DB_NAME=DevFlow_ALYA
# - DB_USER=DevFlowUser
# - DB_PASSWORD=(sua senha)
```

#### **2.5. Executar backend**

```bash
python run.py
```

**Saída esperada:**
```
INFO:     Started server process
INFO:     Waiting for application startup.
INFO:     Application startup complete.
INFO:     Uvicorn running on http://0.0.0.0:8000
```

#### **2.6. Testar backend**

**Abra em outro terminal/navegador:**

1. **Health Check:**
   ```bash
   curl http://localhost:8000/health
   ```
   
   **Esperado:**
   ```json
   {
     "status": "healthy",
     "app": "DevFlow ALYA",
     "version": "1.0.0",
     "environment": "development"
   }
   ```

2. **Swagger UI:**
   - Abra: http://localhost:8000/docs
   - Você deve ver a documentação interativa com todos os endpoints

3. **Testar endpoint de Priority:**
   ```bash
   curl http://localhost:8000/api/v1/priorities
   ```
   
   **Esperado:** JSON com lista de prioridades

#### **2.7. Executar testes automáticos (opcional)**

```bash
# Em outro terminal (com venv ativado)
python test_api.py
```

**Resultado esperado:**
```
🚀 INICIANDO TESTES DA API DEVFLOW
✅ PASSOU - Health Check
✅ PASSOU - Priority CRUD
✅ PASSOU - DemandType CRUD
...
📈 Total: 8/8 testes passaram (100.0%)
🎉 TODOS OS TESTES PASSARAM!
```

---

### **ETAPA 3: Configurar e Executar Frontend** 🎨

**Abra um NOVO terminal** (mantenha o backend rodando no outro)

#### **3.1. Instalar dependências**

```bash
cd C:\DevAlya\DevFlow_ALYA\frontend
npm install
```

**Tempo estimado:** 3-5 minutos

**Possíveis avisos (pode ignorar):**
- Deprecated packages
- Peer dependencies

#### **3.2. Configurar variáveis de ambiente**

```bash
# Copiar exemplo
cp .env.example .env

# Verificar conteúdo (deve estar correto por padrão)
cat .env
```

**Conteúdo esperado:**
```
VITE_API_URL=http://localhost:8000/api/v1
VITE_APP_TITLE=DevFlow ALYA
VITE_APP_VERSION=1.0.0
```

#### **3.3. Executar frontend**

```bash
npm run dev
```

**Saída esperada:**
```
  VITE v5.0.11  ready in 1234 ms

  ➜  Local:   http://localhost:5173/
  ➜  Network: use --host to expose
  ➜  press h to show help
```

#### **3.4. Acessar aplicação**

**Abra no navegador:**
- http://localhost:5173

**Você deve ver:**
- ✅ Dashboard do DevFlow ALYA
- ✅ Menu lateral com opções
- ✅ Cartões de estatísticas
- ✅ Ações rápidas

---

### **ETAPA 4: Testar Funcionalidades** 🧪

#### **4.1. Testar Dashboard**

1. ✅ Verifique se os cartões de estatísticas mostram números
2. ✅ Clique em "Ações Rápidas" → "Prioridades"

#### **4.2. Testar CRUD de Priority**

**Criar:**
1. Clique em "Adicionar"
2. Preencha o formulário:
   - Código: `TEST`
   - Nome: `Teste`
   - Descrição: `Prioridade de teste`
   - SLA (dias): `15`
   - Cor: Escolha uma cor no color picker
   - Ordem: `99`
   - Ativo: ✅
3. Clique em "Salvar"
4. ✅ Deve aparecer mensagem de sucesso
5. ✅ Registro deve aparecer na tabela

**Pesquisar:**
1. Digite "Teste" na caixa de pesquisa
2. ✅ Deve filtrar e mostrar apenas o registro criado

**Editar:**
1. Clique no ícone de lápis (editar)
2. Altere o nome para "Teste Editado"
3. Clique em "Salvar"
4. ✅ Deve aparecer mensagem de sucesso
5. ✅ Nome deve estar atualizado na tabela

**Excluir:**
1. Clique no ícone de lixeira (excluir)
2. Confirme a exclusão
3. ✅ Deve aparecer mensagem de sucesso
4. ✅ Registro deve sumir da tabela

#### **4.3. Testar Navegação**

1. Clique no menu hambúrguer (☰)
2. Navegue entre as opções:
   - Dashboard
   - Prioridades
   - Tipos de Demanda
   - Status de Workflow
   - Etc.

**Nota:** As demais telas ainda não têm componentes implementados, mas as rotas estão criadas.

---

## 🐛 TROUBLESHOOTING

### **Backend não inicia**

**Erro: Cannot connect to database**
```bash
# Verificar:
1. SQL Server está rodando?
2. Credenciais corretas no .env?
3. Firewall bloqueando conexão?

# Testar conexão manualmente:
sqlcmd -S ALYA-TI-001\SQLSERVERLOCAL -U DevFlowUser -P <senha> -d DevFlow_ALYA
```

**Erro: Module not found (ex: uvicorn)**
```bash
# Se Python 3.14+, use:
pip install --upgrade pydantic pydantic-core --no-build-isolation
pip install fastapi uvicorn sqlalchemy python-multipart alembic pyodbc python-dotenv pydantic-settings

# Se Python 3.11-3.13, reinstale normalmente:
pip install -r requirements.txt
```

**Erro: pydantic-core build failed (Python 3.14)**
```bash
# Solução: Instalar versões pré-compiladas
pip install --upgrade pydantic pydantic-core --no-build-isolation
```

**Erro: Port 8000 already in use**
```bash
# Alterar porta no run.py ou:
uvicorn app.main:app --reload --port 8001
```

---

### **Frontend não inicia**

**Erro: Cannot find module**
```bash
# Deletar node_modules e reinstalar
rm -rf node_modules package-lock.json
npm install
```

**Erro: Port 5173 already in use**
```bash
# Alterar porta no vite.config.js ou:
npm run dev -- --port 5174
```

**Erro: Network error ao chamar API**
```bash
# Verificar:
1. Backend está rodando? http://localhost:8000/health
2. CORS configurado? (já está no backend)
3. Proxy configurado? (já está no vite.config.js)
```

---

### **Dados não aparecem no Frontend**

**Console do navegador (F12):**
```javascript
// Verificar erros de rede
// Network tab → Ver chamadas API
// Console tab → Ver erros JavaScript
```

**Verificar backend:**
```bash
# Logs do backend devem mostrar as requisições
# GET /api/v1/priorities
# Status: 200
```

**Verificar dados no banco:**
```sql
SELECT * FROM ref.Priority WHERE IsDeleted = 0;
```

---

## ✅ CHECKLIST DE VALIDAÇÃO

### **Backend**
- [ ] Backend iniciou sem erros
- [ ] Health check retorna 200
- [ ] Swagger acessível em /docs
- [ ] GET /api/v1/priorities retorna dados
- [ ] Testes automáticos passaram (opcional)

### **Frontend**
- [ ] Frontend iniciou sem erros
- [ ] Dashboard carrega
- [ ] Estatísticas aparecem
- [ ] Menu funciona
- [ ] Tabela de Priority carrega
- [ ] Pesquisa funciona
- [ ] Criar Priority funciona
- [ ] Editar Priority funciona
- [ ] Excluir Priority funciona

### **Integração**
- [ ] Frontend chama backend com sucesso
- [ ] Dados do banco aparecem no frontend
- [ ] CRUD completo funciona end-to-end
- [ ] Feedback visual funciona (snackbars)
- [ ] Validações funcionam

---

## 📊 RESULTADO ESPERADO

Após seguir todos os passos, você deve ter:

✅ **Backend rodando** em http://localhost:8000  
✅ **Frontend rodando** em http://localhost:5173  
✅ **Dashboard funcionando** com estatísticas  
✅ **CRUD de Priority** 100% funcional  
✅ **Integração Backend-Frontend** validada  

---

## 🎉 PRÓXIMOS PASSOS

Após validar que tudo funciona:

1. **Completar demais telas** (copiar PriorityView.vue)
2. **Cadastrar dados reais** (empresas, áreas, etc.)
3. **Expandir backend** (mais entidades)
4. **Implementar autenticação**
5. **Deploy em produção**

---

## 📞 SUPORTE

Se encontrar problemas:

1. Verifique os logs do backend e frontend
2. Consulte a documentação:
   - Backend: `backend/README.md`
   - Frontend: `frontend/README.md`
3. Verifique o console do navegador (F12)
4. Teste endpoints individualmente no Swagger

---

**Boa sorte! 🚀**

**Última atualização:** 2026-09-25
