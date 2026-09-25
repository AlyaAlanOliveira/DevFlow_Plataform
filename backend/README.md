# DevFlow Backend API

## 📋 Visão Geral

Backend API do DevFlow ALYA construído com **FastAPI** seguindo princípios de **Clean Architecture** e **Domain-Driven Design (DDD)**.

## 🏗️ Arquitetura

```
backend/
├── app/
│   ├── api/              # Camada de API (Controllers)
│   │   └── v1/
│   │       ├── endpoints/  # Endpoints REST
│   │       └── api.py      # Router principal
│   ├── core/             # Configurações centrais
│   │   ├── config.py       # Configurações da aplicação
│   │   └── database.py     # Configuração do banco
│   ├── domain/           # Camada de Domínio (Models)
│   │   ├── base.py         # Model base
│   │   ├── reference.py    # Models de referência
│   │   └── configuration.py # Models de configuração
│   ├── repositories/     # Camada de Dados (Data Access)
│   │   ├── base.py         # Repository base
│   │   └── reference.py    # Repositories de referência
│   ├── schemas/          # Schemas Pydantic (DTOs)
│   │   ├── base.py         # Schemas base
│   │   └── reference.py    # Schemas de referência
│   ├── services/         # Camada de Negócio (Business Logic)
│   │   └── reference.py    # Services de referência
│   ├── utils/            # Utilitários
│   └── main.py           # Aplicação principal
├── tests/                # Testes
├── .env.example          # Exemplo de variáveis de ambiente
├── requirements.txt      # Dependências Python
└── README.md            # Este arquivo
```

## 🚀 Setup

### 1. Criar ambiente virtual

```bash
cd backend
python -m venv venv

# Windows
venv\Scripts\activate

# Linux/Mac
source venv/bin/activate
```

### 2. Instalar dependências

```bash
pip install -r requirements.txt
```

### 3. Configurar variáveis de ambiente

```bash
cp .env.example .env
# Editar .env com suas configurações
```

### 4. Executar aplicação

```bash
# Desenvolvimento (com reload)
uvicorn app.main:app --reload --host 0.0.0.0 --port 8000

# Ou usando Python
python -m app.main
```

### 5. Acessar documentação

- **Swagger UI**: http://localhost:8000/docs
- **ReDoc**: http://localhost:8000/redoc
- **Health Check**: http://localhost:8000/health

## 📚 APIs Disponíveis

### Priorities (Prioridades)

- `GET /api/v1/priorities` - Listar prioridades
- `GET /api/v1/priorities/{id}` - Buscar prioridade por ID
- `POST /api/v1/priorities` - Criar prioridade
- `PUT /api/v1/priorities/{id}` - Atualizar prioridade
- `DELETE /api/v1/priorities/{id}` - Deletar prioridade (soft delete)

### Demand Types (Tipos de Demanda)

- `GET /api/v1/demand-types` - Listar tipos de demanda
- `GET /api/v1/demand-types/{id}` - Buscar tipo por ID
- `POST /api/v1/demand-types` - Criar tipo
- `PUT /api/v1/demand-types/{id}` - Atualizar tipo
- `DELETE /api/v1/demand-types/{id}` - Deletar tipo

### Workflow Status (Status de Workflow)

- `GET /api/v1/workflow-status` - Listar status
- `GET /api/v1/workflow-status/{id}` - Buscar status por ID
- `POST /api/v1/workflow-status` - Criar status
- `PUT /api/v1/workflow-status/{id}` - Atualizar status
- `DELETE /api/v1/workflow-status/{id}` - Deletar status

## 🧪 Testes

```bash
# Executar todos os testes
pytest

# Com cobertura
pytest --cov=app --cov-report=html

# Testes específicos
pytest tests/test_priority.py
```

## 📝 Padrões de Código

### Models (SQLAlchemy)

```python
from app.domain.base import BaseModel

class MyModel(BaseModel):
    __tablename__ = "MyTable"
    __table_args__ = {"schema": "my_schema"}
    
    MyModelId = Column(UNIQUEIDENTIFIER, primary_key=True)
    Name = Column(String(100), nullable=False)
```

### Schemas (Pydantic)

```python
from app.schemas.base import BaseCreateSchema, BaseResponseSchema

class MyModelCreate(BaseCreateSchema):
    Name: str = Field(..., max_length=100)

class MyModelResponse(BaseResponseSchema):
    MyModelId: UUID
    Name: str
```

### Repositories

```python
from app.repositories.base import BaseRepository

class MyModelRepository(BaseRepository[MyModel]):
    def __init__(self, db: Session):
        super().__init__(MyModel, db)
```

### Services

```python
class MyModelService:
    def __init__(self, db: Session):
        self.db = db
        self.repository = MyModelRepository(db)
    
    def get_by_id(self, id: UUID) -> MyModel:
        model = self.repository.get_by_id(id)
        if not model:
            raise HTTPException(status_code=404)
        return model
```

### Endpoints

```python
@router.get("/{id}", response_model=MyModelResponse)
def get_my_model(id: UUID, db: Session = Depends(get_db)):
    service = MyModelService(db)
    model = service.get_by_id(id)
    return MyModelResponse.model_validate(model)
```

## 🔐 Segurança

- **Autenticação**: Microsoft Entra ID (Azure AD) - TODO
- **Autorização**: RBAC com permissões granulares - TODO
- **Soft Delete**: Exclusão lógica obrigatória
- **Auditoria**: Campos de auditoria em todos os models

## 📊 Banco de Dados

- **SGBD**: SQL Server 2025
- **ORM**: SQLAlchemy 2.0
- **Migrações**: Alembic
- **Connection String**: Configurável via `.env`

## 🛠️ Desenvolvimento

### Adicionar novo endpoint

1. Criar model em `app/domain/`
2. Criar schemas em `app/schemas/`
3. Criar repository em `app/repositories/`
4. Criar service em `app/services/`
5. Criar endpoint em `app/api/v1/endpoints/`
6. Registrar router em `app/api/v1/api.py`

### Code Quality

```bash
# Formatação
black app/

# Linting
flake8 app/

# Type checking
mypy app/

# Import sorting
isort app/
```

## 📞 Suporte

Para dúvidas ou problemas:
- Consulte a documentação em `/docs`
- Verifique os logs da aplicação
- Entre em contato com a equipe de desenvolvimento

---

**Versão**: 1.0.0  
**Última Atualização**: 2026-09-25  
**Desenvolvido para**: Grupo ALYA
