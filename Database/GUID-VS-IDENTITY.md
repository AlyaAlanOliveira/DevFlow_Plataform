# 🔑 GUID (UNIQUEIDENTIFIER) vs IDENTITY (Auto-Increment)

## Entendendo os Tipos de ID no DevFlow ALYA

---

## 📊 Comparação

| Característica | UNIQUEIDENTIFIER (GUID) | INT IDENTITY |
|----------------|-------------------------|--------------|
| **Tipo** | UUID/GUID | Inteiro |
| **Formato** | `xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx` | `1, 2, 3, 4...` |
| **Auto-incremento** | ❌ NÃO | ✅ SIM |
| **Como gerar** | `NEWID()` ou aplicação | Automático pelo SQL |
| **Tamanho** | 16 bytes | 4 bytes |
| **Exemplo** | `1dc3daaa-af0e-4f74-81a6-2ce523fd88ed` | `1` |

---

## 🎯 Por Que Usamos UNIQUEIDENTIFIER no DevFlow?

### **Vantagens:**

1. ✅ **Globalmente Único**
   - Pode gerar IDs na aplicação sem consultar o banco
   - Útil para sistemas distribuídos
   - Evita conflitos em merges de dados

2. ✅ **Segurança**
   - IDs não são sequenciais (dificulta enumeração)
   - Não expõe quantidade de registros

3. ✅ **Integração com Entra ID**
   - Azure AD usa UUIDs nativamente
   - Facilita sincronização

4. ✅ **Replicação**
   - Facilita replicação entre bancos
   - Não há conflito de IDs

### **Desvantagens:**

1. ❌ **Tamanho maior** (16 bytes vs 4 bytes)
2. ❌ **Performance** (índices maiores)
3. ❌ **Não é auto-incremental** (precisa gerar manualmente)

---

## 🔧 Como Inserir Registros com UNIQUEIDENTIFIER

### **Opção 1: Usar NEWID() no SQL** ⭐ Recomendado

```sql
-- Gerar ID automaticamente
INSERT INTO gov.Holding (
    HoldingId,  -- UNIQUEIDENTIFIER
    Nome,
    Sigla
)
VALUES (
    NEWID(),  -- ✓ Gera UUID automaticamente
    'ALYA Holding',
    'ALYA'
);
```

### **Opção 2: Usar Variável**

```sql
-- Gerar ID em variável (útil para usar depois)
DECLARE @HoldingId UNIQUEIDENTIFIER = NEWID();

INSERT INTO gov.Holding (
    HoldingId,
    Nome,
    Sigla
)
VALUES (
    @HoldingId,  -- ✓ Usa a variável
    'ALYA Holding',
    'ALYA'
);

-- Agora pode usar @HoldingId em outros INSERTs
INSERT INTO gov.Company (
    CompanyId,
    HoldingId,  -- ✓ Referencia a holding criada
    Nome
)
VALUES (
    NEWID(),
    @HoldingId,  -- ✓ Usa o ID da holding
    'ALYA Serviços'
);
```

### **Opção 3: Usar DEFAULT NEWID()** (Configuração da Tabela)

```sql
-- Alterar tabela para gerar automaticamente
ALTER TABLE gov.Holding
ADD CONSTRAINT DF_Holding_HoldingId 
DEFAULT NEWID() FOR HoldingId;

-- Agora pode omitir o HoldingId no INSERT
INSERT INTO gov.Holding (Nome, Sigla)
VALUES ('ALYA Holding', 'ALYA');
-- ✓ HoldingId será gerado automaticamente
```

---

## 📋 Estrutura Atual do DevFlow

### **Tabelas com UNIQUEIDENTIFIER:**

Todas as tabelas principais usam UNIQUEIDENTIFIER:

```sql
-- Governança
gov.Holding → HoldingId (UNIQUEIDENTIFIER)
gov.Company → CompanyId (UNIQUEIDENTIFIER)
gov.Directorate → DirectorateId (UNIQUEIDENTIFIER)
gov.Area → AreaId (UNIQUEIDENTIFIER)
gov.Squad → SquadId (UNIQUEIDENTIFIER)

-- Segurança
sec.User → UserId (UNIQUEIDENTIFIER)
sec.Role → RoleId (UNIQUEIDENTIFIER)
sec.Permission → PermissionId (UNIQUEIDENTIFIER)

-- Referência
ref.Priority → PriorityId (UNIQUEIDENTIFIER)
ref.DemandType → DemandTypeId (UNIQUEIDENTIFIER)
ref.WorkflowStatus → WorkflowStatusId (UNIQUEIDENTIFIER)

-- Autenticação
auth.EntraIDTenant → EntraIDTenantId (UNIQUEIDENTIFIER)
auth.AuthenticationLog → AuthenticationLogId (UNIQUEIDENTIFIER)
```

**Nenhuma tabela usa INT IDENTITY!**

---

## 🚀 Script Pronto para Usar

Criei um script que **gera os UUIDs automaticamente** para você:

**Arquivo:** `Database/INSERT_ALYA_ORGANIZATION.sql`

### **O Que o Script Faz:**

```sql
DECLARE @HoldingId UNIQUEIDENTIFIER = NEWID();  -- ✓ Gera UUID
DECLARE @CompanyALYAId UNIQUEIDENTIFIER = NEWID();  -- ✓ Gera UUID
DECLARE @CompanyMobyanId UNIQUEIDENTIFIER = NEWID();  -- ✓ Gera UUID

-- Insere Holding
INSERT INTO gov.Holding (HoldingId, Nome, Sigla)
VALUES (@HoldingId, 'ALYA Holding', 'ALYA');

-- Insere Empresas (usa @HoldingId gerado acima)
INSERT INTO gov.Company (CompanyId, HoldingId, Nome, Sigla)
VALUES (@CompanyALYAId, @HoldingId, 'ALYA Serviços', 'ALYA');

-- Cria Usuário Admin
INSERT INTO sec.[User] (UserId, CompanyId, Email, IsAdminDevFlow)
VALUES (NEWID(), @CompanyALYAId, 'seu.email@alya.com.br', 1);
```

### **Como Executar:**

```bash
# 1. Edite o script e altere o email do admin
# 2. Execute:
sqlcmd -S ALYA-TI-001\SQLSERVERLOCAL -d DevFlow_ALYA -i Database/INSERT_ALYA_ORGANIZATION.sql
```

---

## 💡 Dicas Práticas

### **1. Gerar UUID no SQL Server Management Studio**

```sql
-- Gerar um UUID
SELECT NEWID() AS NovoUUID;

-- Resultado:
-- 1dc3daaa-af0e-4f74-81a6-2ce523fd88ed
```

### **2. Gerar UUID no PowerShell**

```powershell
[guid]::NewGuid()
```

### **3. Gerar UUID no Python**

```python
import uuid
print(uuid.uuid4())
```

### **4. Gerar UUID Online**

https://www.uuidgenerator.net/

---

## 🔍 Como Verificar IDs Gerados

```sql
-- Ver IDs da estrutura organizacional
SELECT 
    'Holding' AS Tipo,
    Nome,
    CAST(HoldingId AS NVARCHAR(50)) AS Id
FROM gov.Holding;

SELECT 
    'Empresa' AS Tipo,
    Nome,
    CAST(CompanyId AS NVARCHAR(50)) AS Id
FROM gov.Company;

SELECT 
    'Usuário' AS Tipo,
    FullName AS Nome,
    CAST(UserId AS NVARCHAR(50)) AS Id,
    CASE WHEN IsAdminDevFlow = 1 THEN 'SIM' ELSE 'NÃO' END AS Admin
FROM sec.[User];
```

---

## ⚠️ Erros Comuns

### **Erro 1: "Cannot insert the value NULL into column 'HoldingId'"**

```sql
-- ❌ ERRADO (falta o HoldingId)
INSERT INTO gov.Holding (Nome, Sigla)
VALUES ('ALYA', 'ALYA');

-- ✅ CORRETO
INSERT INTO gov.Holding (HoldingId, Nome, Sigla)
VALUES (NEWID(), 'ALYA', 'ALYA');
```

### **Erro 2: "Violation of UNIQUE KEY constraint"**

```sql
-- ❌ ERRADO (tentando inserir o mesmo UUID duas vezes)
DECLARE @Id UNIQUEIDENTIFIER = NEWID();
INSERT INTO gov.Holding (HoldingId, Nome) VALUES (@Id, 'ALYA');
INSERT INTO gov.Holding (HoldingId, Nome) VALUES (@Id, 'Mobyan');  -- Erro!

-- ✅ CORRETO (gerar novo UUID para cada registro)
INSERT INTO gov.Holding (HoldingId, Nome) VALUES (NEWID(), 'ALYA');
INSERT INTO gov.Holding (HoldingId, Nome) VALUES (NEWID(), 'Mobyan');
```

---

## 📚 Resumo

### **Para Inserir Registros:**

1. ✅ **Use `NEWID()`** para gerar UUIDs automaticamente
2. ✅ **Use variáveis** quando precisar referenciar o ID depois
3. ✅ **Execute o script pronto** `INSERT_ALYA_ORGANIZATION.sql`

### **NÃO Faça:**

1. ❌ Não tente usar valores sequenciais (1, 2, 3...)
2. ❌ Não omita o campo ID (não é auto-incremental)
3. ❌ Não reutilize o mesmo UUID

---

## 🎯 Próximos Passos

1. ✅ Execute `INSERT_ALYA_ORGANIZATION.sql`
2. ✅ Verifique os IDs gerados
3. ✅ Execute `V3_1_0__EntraID_Tenants.sql`
4. ✅ Cadastre o tenant Entra ID

---

**Agora você sabe como trabalhar com UUIDs no DevFlow!** 🚀
