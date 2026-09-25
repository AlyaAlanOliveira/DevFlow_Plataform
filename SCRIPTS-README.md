# 🚀 Scripts de Gerenciamento - DevFlow ALYA

Scripts `.bat` para facilitar o gerenciamento do backend e frontend.

---

## 📋 Scripts Disponíveis

### **Iniciar Serviços**

| Script | Descrição | Porta |
|--------|-----------|-------|
| `start-backend.bat` | Inicia apenas o backend (FastAPI) | 8000 |
| `start-frontend.bat` | Inicia apenas o frontend (Vue.js) | 5173 |
| `start-all.bat` | Inicia backend e frontend simultaneamente | 8000, 5173 |

### **Parar Serviços**

| Script | Descrição |
|--------|-----------|
| `stop-backend.bat` | Para o backend e libera porta 8000 |
| `stop-frontend.bat` | Para o frontend e libera porta 5173 |
| `stop-all.bat` | Para backend e frontend |

### **Reiniciar Serviços**

| Script | Descrição |
|--------|-----------|
| `restart-backend.bat` | Para e reinicia o backend |

---

## 🎯 Uso Rápido

### **Cenário 1: Primeira Execução**

```batch
REM 1. Iniciar tudo pela primeira vez
start-all.bat
```

### **Cenário 2: Desenvolvimento Normal**

```batch
REM 1. Iniciar backend em um terminal
start-backend.bat

REM 2. Iniciar frontend em outro terminal
start-frontend.bat
```

### **Cenário 3: Reiniciar Após Mudanças no Código**

```batch
REM Backend (após alterar código Python)
restart-backend.bat

REM Frontend (Vite faz hot-reload automático, não precisa reiniciar)
```

### **Cenário 4: Parar Tudo**

```batch
REM Parar todos os serviços
stop-all.bat
```

---

## 🔧 Detalhes Técnicos

### **start-backend.bat**
- Navega para `backend/`
- Ativa ambiente virtual Python (`venv`)
- Executa `python run.py`
- Backend roda em: http://localhost:8000

### **start-frontend.bat**
- Navega para `frontend/`
- Executa `npm run dev`
- Frontend roda em: http://localhost:5173

### **start-all.bat**
- Abre 2 janelas de terminal
- Inicia backend na primeira janela
- Inicia frontend na segunda janela
- Ambos rodam simultaneamente

### **stop-backend.bat**
1. Procura processos `python.exe`
2. Mata processos na porta 8000
3. Verifica se a porta foi liberada

### **stop-frontend.bat**
1. Procura processos `node.exe`
2. Mata processos na porta 5173
3. Verifica se a porta foi liberada

### **stop-all.bat**
- Executa stop-backend + stop-frontend
- Verifica ambas as portas

### **restart-backend.bat**
1. Para o backend atual
2. Aguarda 3 segundos
3. Inicia o backend novamente

---

## ⚠️ Troubleshooting

### **Erro: "Porta já em uso"**

**Solução:**
```batch
REM Parar todos os serviços
stop-all.bat

REM Ou manualmente:
netstat -aon | findstr :8000
taskkill /F /PID <PID>
```

### **Erro: "Ambiente virtual não encontrado"**

**Solução:**
```batch
cd backend
python -m venv venv
venv\Scripts\activate
pip install -r requirements.txt
```

### **Erro: "node_modules não encontrado"**

**Solução:**
```batch
cd frontend
npm install
```

### **Backend não para com stop-backend.bat**

**Solução manual:**
```batch
REM Ver processos Python
tasklist | findstr python

REM Matar todos os processos Python
taskkill /F /IM python.exe

REM Ou matar por porta
netstat -aon | findstr :8000
taskkill /F /PID <PID>
```

---

## 📊 Verificação de Status

### **Verificar se os serviços estão rodando:**

```batch
REM Backend (porta 8000)
netstat -aon | findstr :8000

REM Frontend (porta 5173)
netstat -aon | findstr :5173
```

### **Testar endpoints:**

```batch
REM Health check do backend
curl http://localhost:8000/health

REM Swagger UI
start http://localhost:8000/docs

REM Frontend
start http://localhost:5173
```

---

## 🎨 Customização

### **Alterar porta do backend:**

Edite `backend/run.py`:
```python
uvicorn.run(
    "app.main:app",
    host="0.0.0.0",
    port=8001,  # <-- Altere aqui
    reload=True
)
```

### **Alterar porta do frontend:**

Edite `frontend/vite.config.js`:
```javascript
export default defineConfig({
  server: {
    port: 5174  // <-- Altere aqui
  }
})
```

---

## 📝 Logs

### **Ver logs do backend:**
- Os logs aparecem no terminal onde o backend está rodando
- Erros são exibidos em vermelho

### **Ver logs do frontend:**
- Os logs aparecem no terminal onde o frontend está rodando
- Avisos de hot-reload aparecem quando você salva arquivos

---

## 🚨 Comandos de Emergência

### **Matar TODOS os processos Python:**
```batch
taskkill /F /IM python.exe
```

### **Matar TODOS os processos Node.js:**
```batch
taskkill /F /IM node.exe
```

### **Liberar porta específica:**
```batch
REM Ver o que está usando a porta
netstat -aon | findstr :8000

REM Matar o processo (substitua <PID>)
taskkill /F /PID <PID>
```

---

## ✅ Checklist de Uso Diário

**Ao iniciar o trabalho:**
- [ ] Executar `start-all.bat`
- [ ] Aguardar backend e frontend iniciarem
- [ ] Acessar http://localhost:5173
- [ ] Verificar http://localhost:8000/docs

**Durante o desenvolvimento:**
- [ ] Frontend: Apenas salve os arquivos (hot-reload automático)
- [ ] Backend: Execute `restart-backend.bat` após mudanças

**Ao finalizar o trabalho:**
- [ ] Executar `stop-all.bat`
- [ ] Verificar se as portas foram liberadas

---

**Última atualização:** 2026-09-25
