# DevFlow Backend - Quick Start

## 🚀 Início Rápido (5 minutos)

### 1. Instalar Python 3.13+

Verifique se o Python está instalado:
```bash
python --version
```

### 2. Criar ambiente virtual

```bash
cd backend
python -m venv venv
```

### 3. Ativar ambiente virtual

**Windows:**
```bash
venv\Scripts\activate
```

**Linux/Mac:**
```bash
source venv/bin/activate
```

### 4. Instalar dependências

```bash
pip install --upgrade pip
pip install -r requirements.txt
```

### 5. Configurar variáveis de ambiente

```bash
# Copiar exemplo
copy .env.example .env

# Editar .env com suas configurações
# Especialmente:
# - DB_SERVER
# - DB_NAME
# - DB_USER
# - DB_PASSWORD
```

### 6. Executar aplicação

```bash
python run.py
```

Ou:

```bash
uvicorn app.main:app --reload
```

### 7. Testar API

Abra no navegador:
- **Swagger UI**: http://localhost:8000/docs
- **Health Check**: http://localhost:8000/health

### 8. Testar endpoint de Priority

**Listar prioridades:**
```bash
curl http://localhost:8000/api/v1/priorities
```

**Criar prioridade:**
```bash
curl -X POST http://localhost:8000/api/v1/priorities \
  -H "Content-Type: application/json" \
  -d '{
    "Code": "TEST",
    "Name": "Teste",
    "Description": "Prioridade de teste",
    "SLADays": 30,
    "ColorHex": "#FF0000",
    "DisplayOrder": 99,
    "IsActive": true
  }'
```

## 🐛 Troubleshooting

### Erro de conexão com banco

```
sqlalchemy.exc.OperationalError: (pyodbc.OperationalError)
```

**Solução:**
1. Verifique se o SQL Server está rodando
2. Verifique as credenciais no `.env`
3. Verifique se o driver ODBC está instalado

### Erro de módulo não encontrado

```
ModuleNotFoundError: No module named 'fastapi'
```

**Solução:**
```bash
pip install -r requirements.txt
```

### Porta 8000 já em uso

```
ERROR: [Errno 10048] error while attempting to bind on address
```

**Solução:**
Altere a porta no `run.py` ou:
```bash
uvicorn app.main:app --reload --port 8001
```

## 📚 Próximos Passos

1. ✅ Testar todos os endpoints no Swagger
2. ✅ Implementar autenticação (Entra ID)
3. ✅ Adicionar mais endpoints (DemandType, WorkflowStatus, etc.)
4. ✅ Criar testes unitários
5. ✅ Configurar CI/CD

## 🔗 Links Úteis

- [FastAPI Docs](https://fastapi.tiangolo.com/)
- [SQLAlchemy Docs](https://docs.sqlalchemy.org/)
- [Pydantic Docs](https://docs.pydantic.dev/)

---

**Dúvidas?** Consulte o [README.md](./README.md) completo.
