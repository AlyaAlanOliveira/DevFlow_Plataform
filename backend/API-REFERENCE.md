# DevFlow Backend - API Reference

## 📚 Documentação Completa das APIs

Todas as APIs seguem o padrão REST e estão disponíveis em `/api/v1`.

---

## 🔗 Base URL

```
http://localhost:8000/api/v1
```

---

## 📋 Endpoints Disponíveis

### **1. Priority (Prioridades)**

Gerenciamento de prioridades de demandas.

| Método | Endpoint | Descrição |
|--------|----------|-----------|
| `GET` | `/priorities` | Lista todas as prioridades |
| `GET` | `/priorities/{id}` | Busca prioridade por ID |
| `POST` | `/priorities` | Cria nova prioridade |
| `PUT` | `/priorities/{id}` | Atualiza prioridade |
| `DELETE` | `/priorities/{id}` | Deleta prioridade (soft delete) |

**Query Parameters (GET /priorities):**
- `skip` (int, default=0): Registros para pular
- `limit` (int, default=100): Limite de registros
- `active_only` (bool, default=true): Apenas ativos

**Exemplo de Request (POST):**
```json
{
  "Code": "HIGH",
  "Name": "Alta",
  "Description": "Prioridade alta",
  "SLADays": 7,
  "ColorHex": "#FF5722",
  "DisplayOrder": 2,
  "IsActive": true
}
```

---

### **2. DemandType (Tipos de Demanda)**

Gerenciamento de tipos de demanda.

| Método | Endpoint | Descrição |
|--------|----------|-----------|
| `GET` | `/demand-types` | Lista todos os tipos |
| `GET` | `/demand-types/{id}` | Busca tipo por ID |
| `POST` | `/demand-types` | Cria novo tipo |
| `PUT` | `/demand-types/{id}` | Atualiza tipo |
| `DELETE` | `/demand-types/{id}` | Deleta tipo |

**Exemplo de Request (POST):**
```json
{
  "Code": "FEATURE",
  "Name": "Nova Funcionalidade",
  "Description": "Desenvolvimento de nova feature",
  "RequiresImpactAnalysis": true,
  "RequiresSecurityReview": false,
  "IsActive": true
}
```

---

### **3. WorkflowStatus (Status de Workflow)**

Gerenciamento de status de workflow por tipo de entidade.

| Método | Endpoint | Descrição |
|--------|----------|-----------|
| `GET` | `/workflow-status` | Lista todos os status |
| `GET` | `/workflow-status/{id}` | Busca status por ID |
| `POST` | `/workflow-status` | Cria novo status |
| `PUT` | `/workflow-status/{id}` | Atualiza status |
| `DELETE` | `/workflow-status/{id}` | Deleta status |

**Query Parameters (GET /workflow-status):**
- `entity_type` (string, optional): Filtrar por tipo de entidade
  - Valores: `BusinessCase`, `Demand`, `Requirement`, `UseCase`, `UserStory`, `Estimate`, `Sprint`, `TestCase`, `Release`, `GMUD`

**Exemplo de Request (POST):**
```json
{
  "EntityType": "Demand",
  "Code": "APPROVED",
  "Name": "Aprovado",
  "Description": "Demanda aprovada",
  "IsFinal": true,
  "IsRejection": false,
  "DisplayOrder": 3,
  "ColorHex": "#4CAF50",
  "IsActive": true
}
```

---

### **4. ActorComplexity (Complexidade de Atores UCP)**

Gerenciamento de complexidades de atores para cálculo UCP.

| Método | Endpoint | Descrição |
|--------|----------|-----------|
| `GET` | `/actor-complexities` | Lista todas as complexidades |
| `GET` | `/actor-complexities/{id}` | Busca complexidade por ID |
| `POST` | `/actor-complexities` | Cria nova complexidade |
| `PUT` | `/actor-complexities/{id}` | Atualiza complexidade |
| `DELETE` | `/actor-complexities/{id}` | Deleta complexidade |

**Exemplo de Request (POST):**
```json
{
  "Code": "SIMPLE",
  "Name": "Simples",
  "Description": "Ator simples - API",
  "WeightFactor": 1.0,
  "DisplayOrder": 1,
  "IsActive": true
}
```

---

### **5. UseCaseComplexity (Complexidade de Casos de Uso UCP)**

Gerenciamento de complexidades de casos de uso para cálculo UCP.

| Método | Endpoint | Descrição |
|--------|----------|-----------|
| `GET` | `/usecase-complexities` | Lista todas as complexidades |
| `GET` | `/usecase-complexities/{id}` | Busca complexidade por ID |
| `POST` | `/usecase-complexities` | Cria nova complexidade |
| `PUT` | `/usecase-complexities/{id}` | Atualiza complexidade |
| `DELETE` | `/usecase-complexities/{id}` | Deleta complexidade |

**Exemplo de Request (POST):**
```json
{
  "Code": "AVERAGE",
  "Name": "Médio",
  "Description": "Caso de uso médio",
  "TransactionMin": 4,
  "TransactionMax": 7,
  "WeightFactor": 10.0,
  "DisplayOrder": 2,
  "IsActive": true
}
```

---

### **6. Operation (Operações/Clientes)**

Gerenciamento de operações, plataformas e contratantes.

| Método | Endpoint | Descrição |
|--------|----------|-----------|
| `GET` | `/operations` | Lista todas as operações |
| `GET` | `/operations/{id}` | Busca operação por ID |
| `POST` | `/operations` | Cria nova operação |
| `PUT` | `/operations/{id}` | Atualiza operação |
| `DELETE` | `/operations/{id}` | Deleta operação |

**Exemplo de Request (POST):**
```json
{
  "Code": "GETNET",
  "Name": "GetNet",
  "Description": "Plataforma de pagamentos GetNet",
  "CompanyId": "uuid-da-empresa",
  "ClientType": "External",
  "IsActive": true
}
```

**ClientType valores permitidos:**
- `Internal` - Cliente interno
- `External` - Cliente externo
- `Partner` - Parceiro

---

### **7. UCPConfiguration (Configuração UCP)**

Gerenciamento de configurações de cálculo UCP.

| Método | Endpoint | Descrição |
|--------|----------|-----------|
| `GET` | `/ucp-configurations` | Lista todas as configurações |
| `GET` | `/ucp-configurations/current` | Busca configuração vigente |
| `GET` | `/ucp-configurations/{id}` | Busca configuração por ID |
| `POST` | `/ucp-configurations` | Cria nova configuração |
| `PUT` | `/ucp-configurations/{id}` | Atualiza configuração |
| `DELETE` | `/ucp-configurations/{id}` | Deleta configuração |

**Exemplo de Request (POST):**
```json
{
  "Name": "Configuração UCP 2026",
  "Description": "Configuração padrão para 2026",
  "HoursPerUCP": 20.0,
  "DevelopmentPercentage": 60.0,
  "TestPercentage": 20.0,
  "HomologationPercentage": 20.0,
  "HourlyRate": 150.0,
  "EffectiveFrom": "2026-01-01",
  "EffectiveTo": null,
  "IsActive": true
}
```

**Validações:**
- A soma dos percentuais deve ser 100%
- `EffectiveTo` deve ser >= `EffectiveFrom`

---

## 📊 Formato de Resposta Padrão

### **Resposta Paginada (GET /...)**

```json
{
  "total": 100,
  "skip": 0,
  "limit": 10,
  "items": [
    {
      "PriorityId": "uuid",
      "Code": "HIGH",
      "Name": "Alta",
      "Description": "Prioridade alta",
      "SLADays": 7,
      "ColorHex": "#FF5722",
      "DisplayOrder": 2,
      "IsActive": true,
      "CreatedAt": "2026-09-25T10:00:00Z",
      "CreatedBy": "uuid",
      "UpdatedAt": null,
      "UpdatedBy": null,
      "DeletedAt": null,
      "DeletedBy": null,
      "IsDeleted": false
    }
  ]
}
```

### **Resposta de Item Único (GET /{id}, POST, PUT)**

```json
{
  "PriorityId": "uuid",
  "Code": "HIGH",
  "Name": "Alta",
  "Description": "Prioridade alta",
  "SLADays": 7,
  "ColorHex": "#FF5722",
  "DisplayOrder": 2,
  "IsActive": true,
  "CreatedAt": "2026-09-25T10:00:00Z",
  "CreatedBy": "uuid",
  "UpdatedAt": null,
  "UpdatedBy": null,
  "DeletedAt": null,
  "DeletedBy": null,
  "IsDeleted": false
}
```

### **Resposta de Erro**

```json
{
  "detail": "Priority com ID {id} não encontrada"
}
```

---

## 🔐 Campos de Auditoria

Todos os endpoints retornam campos de auditoria:

| Campo | Tipo | Descrição |
|-------|------|-----------|
| `CreatedAt` | datetime | Data/hora de criação |
| `CreatedBy` | UUID | ID do usuário que criou |
| `UpdatedAt` | datetime | Data/hora da última atualização |
| `UpdatedBy` | UUID | ID do usuário que atualizou |
| `DeletedAt` | datetime | Data/hora da exclusão (soft delete) |
| `DeletedBy` | UUID | ID do usuário que deletou |
| `IsDeleted` | boolean | Flag de exclusão lógica |

---

## 🚫 Códigos de Status HTTP

| Código | Descrição |
|--------|-----------|
| `200` | OK - Sucesso |
| `201` | Created - Recurso criado |
| `204` | No Content - Sucesso sem conteúdo (DELETE) |
| `400` | Bad Request - Dados inválidos |
| `404` | Not Found - Recurso não encontrado |
| `422` | Unprocessable Entity - Validação falhou |
| `500` | Internal Server Error - Erro no servidor |

---

## 🧪 Testando a API

### **Usando cURL**

```bash
# Listar prioridades
curl http://localhost:8000/api/v1/priorities

# Criar prioridade
curl -X POST http://localhost:8000/api/v1/priorities \
  -H "Content-Type: application/json" \
  -d '{"Code":"TEST","Name":"Teste","SLADays":30,"DisplayOrder":99,"IsActive":true}'

# Buscar por ID
curl http://localhost:8000/api/v1/priorities/{id}

# Atualizar
curl -X PUT http://localhost:8000/api/v1/priorities/{id} \
  -H "Content-Type: application/json" \
  -d '{"Name":"Teste Atualizado"}'

# Deletar
curl -X DELETE http://localhost:8000/api/v1/priorities/{id}
```

### **Usando Python (requests)**

```python
import requests

BASE_URL = "http://localhost:8000/api/v1"

# Listar
response = requests.get(f"{BASE_URL}/priorities")
print(response.json())

# Criar
data = {
    "Code": "TEST",
    "Name": "Teste",
    "SLADays": 30,
    "DisplayOrder": 99,
    "IsActive": True
}
response = requests.post(f"{BASE_URL}/priorities", json=data)
print(response.json())
```

### **Usando Script de Teste**

```bash
cd backend
python test_api.py
```

---

## 📖 Documentação Interativa

Acesse a documentação interativa Swagger:

- **Swagger UI**: http://localhost:8000/docs
- **ReDoc**: http://localhost:8000/redoc

---

## 🔄 Soft Delete

Todas as operações DELETE são **soft delete**:
- O registro não é removido fisicamente
- Campo `IsDeleted` é marcado como `true`
- Campos `DeletedAt` e `DeletedBy` são preenchidos
- Registros deletados não aparecem nas listagens por padrão

---

## 📝 Notas Importantes

1. **Paginação**: Todas as listagens suportam paginação via `skip` e `limit`
2. **Filtros**: Parâmetro `active_only=true` filtra apenas registros ativos
3. **Validação**: Todos os campos são validados pelo Pydantic
4. **UUIDs**: Todos os IDs são UUIDs v4
5. **Timestamps**: Todas as datas estão em UTC
6. **Soft Delete**: Exclusão física é proibida

---

**Versão**: 1.0.0  
**Última Atualização**: 2026-09-25
