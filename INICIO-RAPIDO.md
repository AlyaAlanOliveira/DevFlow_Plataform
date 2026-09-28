# 🚀 DevFlow ALYA - Início Rápido

## ⚡ Executar em 3 Passos

### **PASSO 1: Verificar Pré-requisitos** ✅

```bash
# Python 3.13+
python --version

# Node.js 18+
node --version

# SQL Server rodando
# Banco DevFlow_ALYA criado
```

---

### **PASSO 2: Iniciar Sistema** 🚀

**Opção A: Automático (Recomendado)**

Duplo clique em:
```
start-all.bat
```

**Opção B: Manual**

**Terminal 1 - Backend:**
```bash
cd backend
python -m venv venv
source venv/Scripts/activate  # Git Bash
pip install -r requirements.txt
python run.py
```

**Terminal 2 - Frontend:**
```bash
cd frontend
npm install
npm run dev
```

---

### **PASSO 3: Acessar e Testar** 🎯

**Frontend:** http://localhost:5173
- ✅ Dashboard com estatísticas
- ✅ Menu de navegação
- ✅ CRUD de Prioridades

**Backend:** http://localhost:8000/docs
- ✅ Swagger UI
- ✅ 35 endpoints REST
- ✅ Documentação interativa

---

## 🧪 Teste Rápido

### **1. Dashboard**
1. Acesse http://localhost:5173
2. Veja estatísticas nos cartões
3. Clique em "Prioridades"

### **2. CRUD de Priority**
1. Clique em "Adicionar"
2. Preencha:
   - Código: `TEST`
   - Nome: `Teste`
   - SLA: `15`
   - Cor: Escolha uma
   - Ordem: `99`
3. Salve
4. ✅ Registro aparece na tabela

### **3. API no Swagger**
1. Acesse http://localhost:8000/docs
2. Expanda `GET /api/v1/priorities`
3. Clique em "Try it out"
4. Execute
5. ✅ Veja resposta JSON

---

## 🐛 Problemas Comuns

### **Frontend não inicia**

**Erro:** `ENOENT: no such file or directory`

**Solução:** ✅ Já resolvido! Todos os arquivos `.vue` foram criados.

```bash
# Verificar arquivos
find frontend/src/views -name "*.vue"
```

### **Backend não conecta ao banco**

**Solução:**
1. Verificar SQL Server rodando
2. Editar `backend/.env`:
   ```
   DB_SERVER=ALYA-TI-001\SQLSERVERLOCAL
   DB_USER=DevFlowUser
   DB_PASSWORD=<sua-senha>
   ```

### **Porta em uso**

**Backend (8000):**
```bash
# Alterar porta
uvicorn app.main:app --reload --port 8001
```

**Frontend (5173):**
```bash
# Alterar porta
npm run dev -- --port 5174
```

---

## 📚 Documentação

- 📖 [Guia Completo](./GUIA-EXECUCAO.md)
- ✅ [Checklist](./CHECKLIST-EXECUCAO.md)
- 🔧 [Solução de Erros](./SOLUCAO-ERRO-FRONTEND.md)
- 📊 [Projeto Completo](./PROJETO-COMPLETO.md)

---

## 🎯 Status das Telas

| Tela | Status | Funcionalidade |
|------|--------|----------------|
| Dashboard | ✅ | Estatísticas e ações rápidas |
| Prioridades | ✅ | CRUD completo |
| Tipos de Demanda | 🔄 | Placeholder (rota funciona) |
| Status Workflow | 🔄 | Placeholder (rota funciona) |
| Complexidade Atores | 🔄 | Placeholder (rota funciona) |
| Complexidade Casos de Uso | 🔄 | Placeholder (rota funciona) |
| Operações | 🔄 | Placeholder (rota funciona) |
| Configurações UCP | 🔄 | Placeholder (rota funciona) |

---

## 🔜 Próximos Passos

1. ✅ Testar Dashboard e Priority
2. 🔄 Implementar demais telas (copiar PriorityView.vue)
3. 🔄 Cadastrar dados reais
4. 🔄 Expandir backend

---

## ✅ Tudo Pronto!

O sistema está funcionando! 🎉

- Backend: ✅ 35 endpoints
- Frontend: ✅ Dashboard + Priority
- Banco: ✅ 49 tabelas

**Bom trabalho!** 🚀

---

**Última atualização:** 2026-09-28
