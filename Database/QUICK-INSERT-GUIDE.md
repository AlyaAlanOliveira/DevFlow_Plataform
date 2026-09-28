# 🚀 Guia Rápido de INSERT - DevFlow ALYA

## Como Inserir Dados Corretamente

---

## ✅ **CORREÇÕES APLICADAS**

### **1. DEFAULT NEWID() Adicionado**

Agora você pode **omitir o campo ID** e ele será gerado automaticamente!

```sql
-- ✅ ANTES (tinha que especificar)
INSERT INTO gov.Holding (HoldingId, Nome, Sigla)
VALUES (NEWID(), 'ALYA', 'ALYA');

-- ✅ AGORA (pode omitir)
INSERT INTO gov.Holding (Nome, Sigla)
VALUES ('ALYA', 'ALYA');
-- HoldingId será gerado automaticamente!
```

### **2. Status → IsActive (BIT)**

Campo `Status` foi substituído por `IsActive` (booleano):

```sql
-- ❌ ANTES (NVARCHAR)
INSERT INTO gov.Holding (Nome, Sigla, Status)
VALUES ('ALYA', 'ALYA', 'ATIVA');

-- ✅ AGORA (BIT)
INSERT INTO gov.Holding (Nome, Sigla, IsActive)
VALUES ('ALYA', 'ALYA', 1);
-- 1 = Ativo, 0 = Inativo
```

---

## 📋 **EXECUTAR CORREÇÕES**

### **Passo 1: Executar Migration**

```bash
sqlcmd -S ALYA-TI-001\SQLSERVERLOCAL -d DevFlow_ALYA -i Database/V3_2_0__Fix_Status_Fields.sql
```

Este script:
- ✅ Adiciona `DEFAULT NEWID()` em todos os campos ID
- ✅ Converte `Status` (NVARCHAR) para `IsActive` (BIT)
- ✅ Migra dados existentes automaticamente

---

## 🎯 **FORMAS DE INSERIR**

### **Holding**

```sql
-- Opção 1: Omitindo tudo que tem DEFAULT
INSERT INTO gov.Holding (Nome, Sigla)
VALUES ('Transire Logistica e Serviço', 'TLogServ');
-- HoldingId = gerado automaticamente
-- IsActive = 1 (padrão)
-- CreatedAt = GETUTCDATE() (padrão)
-- IsDeleted = 0 (padrão)

-- Opção 2: Especificando IsActive
INSERT INTO gov.Holding (Nome, Sigla, IsActive)
VALUES ('Transire Logistica e Serviço', 'TLogServ', 1);

-- Opção 3: Especificando tudo
INSERT INTO gov.Holding (
    HoldingId,
    Nome,
    Sigla,
    CNPJ,
    IsActive,
    CreatedAt,
    CreatedBy,
    IsDeleted
)
VALUES (
    NEWID(),
    'Transire Logistica e Serviço',
    'TLogServ',
    '12.345.678/0001-90',
    1,  -- Ativo
    GETUTCDATE(),
    '00000000-0000-0000-0000-000000000001',
    0
);
```

### **Company**

```sql
-- Simples (recomendado)
DECLARE @HoldingId UNIQUEIDENTIFIER;
SELECT @HoldingId = HoldingId FROM gov.Holding WHERE Sigla = 'TLogServ';

INSERT INTO gov.Company (HoldingId, Nome, Sigla, CNPJ)
VALUES (@HoldingId, 'Transire Logistica LTDA', 'TLOG', '12.345.678/0001-90');
-- CompanyId = gerado automaticamente
-- IsActive = 1 (padrão)
```

### **User**

```sql
-- Criar usuário admin
DECLARE @CompanyId UNIQUEIDENTIFIER;
SELECT @CompanyId = CompanyId FROM gov.Company WHERE Sigla = 'ALYA';

INSERT INTO sec.[User] (
    CompanyId,
    Email,
    FullName,
    IsActive,
    IsAdminDevFlow
)
VALUES (
    @CompanyId,
    'alan.oliveira@alyaservicos.com.br',
    'Alan Oliveira',
    1,  -- Ativo
    1   -- Admin DevFlow
);
-- UserId = gerado automaticamente
```

---

## 📊 **VALORES BOOLEANOS**

### **IsActive, IsDeleted, IsAdminDevFlow, etc.**

```sql
-- ✅ CORRETO
IsActive = 1  -- Ativo/Sim/True
IsActive = 0  -- Inativo/Não/False

-- ❌ ERRADO
IsActive = 'ATIVA'  -- Erro de tipo!
IsActive = 'true'   -- Erro de tipo!
IsActive = TRUE     -- Não existe TRUE em T-SQL
```

### **Conversão Automática**

O SQL Server aceita algumas conversões:

```sql
-- Todas estas formas funcionam:
IsActive = 1
IsActive = 0
IsActive = CAST(1 AS BIT)
IsActive = CASE WHEN condicao THEN 1 ELSE 0 END
```

---

## 🔍 **CONSULTAS ÚTEIS**

### **Verificar Holdings**

```sql
SELECT 
    CAST(HoldingId AS NVARCHAR(50)) AS Id,
    Nome,
    Sigla,
    CASE WHEN IsActive = 1 THEN 'Ativo' ELSE 'Inativo' END AS Status
FROM gov.Holding
WHERE IsDeleted = 0
ORDER BY Nome;
```

### **Verificar Empresas**

```sql
SELECT 
    c.Nome AS Empresa,
    c.Sigla,
    h.Nome AS Holding,
    CASE WHEN c.IsActive = 1 THEN 'Ativo' ELSE 'Inativo' END AS Status
FROM gov.Company c
INNER JOIN gov.Holding h ON c.HoldingId = h.HoldingId
WHERE c.IsDeleted = 0
ORDER BY c.Nome;
```

### **Verificar Usuários Admin**

```sql
SELECT 
    FullName AS Nome,
    Email,
    c.Nome AS Empresa,
    CASE WHEN IsActive = 1 THEN 'Ativo' ELSE 'Inativo' END AS Status,
    CASE WHEN IsAdminDevFlow = 1 THEN 'SIM' ELSE 'NÃO' END AS AdminDevFlow
FROM sec.[User] u
INNER JOIN gov.Company c ON u.CompanyId = c.CompanyId
WHERE u.IsDeleted = 0
ORDER BY IsAdminDevFlow DESC, FullName;
```

---

## 🎯 **SCRIPT PRONTO ATUALIZADO**

O script `INSERT_ALYA_ORGANIZATION.sql` foi atualizado para usar `IsActive`:

```bash
# Executar script atualizado
sqlcmd -S ALYA-TI-001\SQLSERVERLOCAL -d DevFlow_ALYA -i Database/INSERT_ALYA_ORGANIZATION.sql
```

---

## ⚠️ **ERROS COMUNS**

### **Erro 1: "Invalid column name 'Status'"**

```
Causa: Tentando usar campo Status que foi renomeado
Solução: Use IsActive em vez de Status
```

### **Erro 2: "Conversion failed when converting the nvarchar value 'ATIVA' to data type bit"**

```
Causa: Tentando inserir texto em campo booleano
Solução: Use 1 ou 0 em vez de 'ATIVA' ou 'INATIVA'
```

### **Erro 3: "Cannot insert the value NULL into column 'HoldingId'"**

```
Causa: Migration V3.2.0 não foi executada
Solução: Execute V3_2_0__Fix_Status_Fields.sql primeiro
```

---

## ✅ **CHECKLIST**

Antes de inserir dados:

- [ ] Executar `V3_2_0__Fix_Status_Fields.sql`
- [ ] Verificar que campos ID têm DEFAULT NEWID()
- [ ] Verificar que Status foi convertido para IsActive
- [ ] Usar 1/0 para campos booleanos
- [ ] Pode omitir campos com DEFAULT

---

## 📚 **RESUMO**

### **Campos que podem ser omitidos:**

- ✅ `HoldingId`, `CompanyId`, `UserId`, etc. (gerados automaticamente)
- ✅ `IsActive` (padrão = 1)
- ✅ `IsDeleted` (padrão = 0)
- ✅ `CreatedAt` (padrão = GETUTCDATE())
- ✅ `RowVersion` (gerado automaticamente)

### **Campos obrigatórios:**

- ❌ `Nome` (sempre obrigatório)
- ❌ `Sigla` (sempre obrigatório)
- ❌ `CreatedBy` (se não tiver DEFAULT)
- ❌ Foreign Keys (HoldingId em Company, CompanyId em User, etc.)

---

**Agora você pode inserir dados facilmente!** 🚀
