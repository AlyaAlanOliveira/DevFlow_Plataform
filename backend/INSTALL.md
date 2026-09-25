# 📦 Instalação de Dependências - DevFlow Backend

## 🐍 Verificar Versão do Python

```bash
python --version
```

**Versões suportadas:** Python 3.11, 3.12, 3.13, 3.14

---

## 📋 Método de Instalação

### **Opção 1: Python 3.11 - 3.13 (Recomendado)**

Este é o método mais simples e direto:

```bash
# 1. Criar ambiente virtual
python -m venv venv

# 2. Ativar ambiente virtual
# Windows (PowerShell):
venv\Scripts\Activate.ps1
# Windows (CMD):
venv\Scripts\activate
# Linux/Mac:
source venv/bin/activate

# 3. Atualizar pip
pip install --upgrade pip

# 4. Instalar todas as dependências
pip install -r requirements.txt
```

---

### **Opção 2: Python 3.14+ (Requer passos extras)**

O Python 3.14 é muito recente e algumas bibliotecas (como `pydantic-core`) precisam de versões pré-compiladas:

```bash
# 1. Criar ambiente virtual
python -m venv venv

# 2. Ativar ambiente virtual
# Windows (PowerShell):
venv\Scripts\Activate.ps1
# Windows (CMD):
venv\Scripts\activate
# Linux/Mac:
source venv/bin/activate

# 3. Atualizar pip
pip install --upgrade pip

# 4. IMPORTANTE: Instalar pydantic primeiro (versões pré-compiladas)
pip install --upgrade pydantic pydantic-core --no-build-isolation

# 5. Instalar dependências principais manualmente
pip install fastapi uvicorn sqlalchemy python-multipart alembic pyodbc
pip install python-dotenv pydantic-settings email-validator
pip install python-jose passlib fastapi-cors

# 6. Instalar dependências de desenvolvimento (opcional)
pip install pytest pytest-asyncio pytest-cov httpx
pip install black flake8 mypy isort python-json-logger python-dateutil
```

---

## ✅ Verificar Instalação

Após instalar, verifique se tudo está funcionando:

```bash
# Verificar se uvicorn foi instalado
python -c "import uvicorn; print('✅ uvicorn instalado')"

# Verificar se fastapi foi instalado
python -c "import fastapi; print('✅ fastapi instalado')"

# Verificar se pydantic foi instalado
python -c "import pydantic; print('✅ pydantic instalado')"

# Verificar se sqlalchemy foi instalado
python -c "import sqlalchemy; print('✅ sqlalchemy instalado')"
```

**Resultado esperado:**
```
✅ uvicorn instalado
✅ fastapi instalado
✅ pydantic instalado
✅ sqlalchemy instalado
```

---

## 🐛 Problemas Comuns

### **Erro: `ModuleNotFoundError: No module named 'uvicorn'`**

**Solução:**
```bash
pip install uvicorn fastapi
```

### **Erro: `pydantic-core build failed` (Python 3.14)**

**Causa:** O `pydantic-core` precisa compilar código Rust, mas a versão no requirements.txt não suporta Python 3.14.

**Solução:**
```bash
# Instalar versões pré-compiladas mais recentes
pip install --upgrade pydantic pydantic-core --no-build-isolation
```

### **Erro: `error: the configured Python interpreter version (3.14) is newer than PyO3's maximum supported version (3.13)`**

**Solução:** Mesma do erro anterior - use `--no-build-isolation`:
```bash
pip install --upgrade pydantic pydantic-core --no-build-isolation
```

### **Erro: `Defaulting to user installation because normal site-packages is not writeable`**

**Causa:** Você está instalando no Python global em vez do ambiente virtual.

**Solução:**
```bash
# Certifique-se de que o ambiente virtual está ativado
# Você deve ver (venv) no início da linha de comando

# Se não estiver ativado:
venv\Scripts\activate  # Windows
source venv/bin/activate  # Linux/Mac
```

---

## 📊 Lista Completa de Dependências

### **Produção (obrigatórias):**
- `fastapi` - Framework web
- `uvicorn` - Servidor ASGI
- `sqlalchemy` - ORM
- `pyodbc` - Driver SQL Server
- `alembic` - Migrations
- `pydantic` - Validação de dados
- `pydantic-settings` - Configurações
- `python-dotenv` - Variáveis de ambiente
- `python-jose` - JWT
- `passlib` - Hash de senhas

### **Desenvolvimento (opcionais):**
- `pytest` - Testes
- `black` - Formatação de código
- `flake8` - Linting
- `mypy` - Type checking
- `isort` - Organização de imports

---

## 🚀 Próximo Passo

Após instalar as dependências, configure o arquivo `.env`:

```bash
cp .env.example .env
# Edite o .env com suas configurações
```

Depois execute o backend:

```bash
python run.py
```

---

**Última atualização:** 2026-09-25
