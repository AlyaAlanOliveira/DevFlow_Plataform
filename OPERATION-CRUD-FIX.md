# Correção do CRUD de Operações

## Problema Identificado

Ao criar uma operação, o frontend estava retornando erro **422 (Unprocessable Entity)**.

### Causa Raiz

O frontend estava enviando campos que **não existem** na tabela `cfg.Operation`:

**Campos enviados (incorretos):**
- `OperationType` ❌
- `CNPJ` ❌
- `ContactName` ❌
- `ContactEmail` ❌
- `ContactPhone` ❌

**Campos esperados (corretos):**
- `Code` ✅
- `Name` ✅
- `Description` ✅
- `CompanyId` ✅ (UUID da empresa em gov.Company)
- `ClientType` ✅ (Internal, External ou Partner)
- `IsActive` ✅

## Estrutura da Tabela

```sql
CREATE TABLE cfg.Operation (
    OperationId UNIQUEIDENTIFIER NOT NULL PRIMARY KEY,
    Code VARCHAR(20) NOT NULL UNIQUE,
    Name NVARCHAR(200) NOT NULL,
    Description NVARCHAR(1000),
    CompanyId UNIQUEIDENTIFIER NOT NULL,  -- FK para gov.Company
    ClientType VARCHAR(30) NOT NULL,      -- Internal, External, Partner
    IsActive BIT NOT NULL DEFAULT 1,
    -- Campos de auditoria...
    CONSTRAINT FK_Operation_Company FOREIGN KEY (CompanyId) REFERENCES gov.Company(CompanyId),
    CONSTRAINT CK_Operation_ClientType CHECK (ClientType IN ('Internal','External','Partner'))
);
```

## Solução Aplicada

### 1. Frontend Corrigido

**Arquivo:** `frontend/src/views/configuration/OperationView.vue`

**Alterações:**
- ✅ Removidos campos inexistentes (CNPJ, ContactName, etc.)
- ✅ Adicionado campo `CompanyId` (UUID da empresa)
- ✅ Alterado `OperationType` para `ClientType`
- ✅ Valores do `ClientType` alinhados com constraint do banco:
  - Internal (Interno)
  - External (Externo)
  - Partner (Parceiro)

### 2. Como Obter o CompanyId

Execute o script para obter o UUID da empresa ALYA:

```bash
# No SQL Server Management Studio ou Azure Data Studio
sqlcmd -S localhost -d DevFlow_ALYA -i Database\GET_ALYA_COMPANY_ID.sql
```

Ou execute diretamente:

```sql
SELECT CompanyId, Nome, Sigla 
FROM gov.Company 
WHERE Sigla = 'ALYA' AND IsDeleted = 0;
```

**Copie o CompanyId retornado** e use-o ao criar operações.

## Como Usar

### 1. Reiniciar o Frontend

```bash
cd frontend
npm run dev
```

### 2. Criar uma Operação

1. Acesse: http://localhost:5173/configuration/operations
2. Clique em **"+ Adicionar"**
3. Preencha os campos:
   - **Código**: Ex: `OP001`
   - **Nome**: Ex: `Operação Teste`
   - **Descrição**: (Opcional)
   - **ID da Empresa**: Cole o UUID da empresa ALYA
   - **Tipo de Cliente**: Selecione Internal, External ou Partner
   - **Ativo**: Marque se estiver ativo
4. Clique em **"Salvar"**

## Melhorias Futuras

### Opção 1: Criar Endpoint de Empresas

Criar endpoint `/api/v1/companies` para listar empresas disponíveis e permitir seleção no frontend.

### Opção 2: Configuração Global

Armazenar o CompanyId padrão em:
- `frontend/.env` ou
- `frontend/src/config.js`

### Opção 3: Select Dinâmico

Buscar empresas automaticamente ao abrir o formulário e exibir um select com as opções.

## Validação

Após a correção, o endpoint deve aceitar:

```json
{
  "Code": "OP001",
  "Name": "Operação Teste",
  "Description": "Descrição opcional",
  "CompanyId": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",
  "ClientType": "Internal",
  "IsActive": true
}
```

E retornar **201 Created** com sucesso! ✅

## Arquivos Modificados

- ✅ `frontend/src/views/configuration/OperationView.vue`
- ✅ `Database/GET_ALYA_COMPANY_ID.sql` (novo)
- ✅ `OPERATION-CRUD-FIX.md` (este arquivo)

## Status

- [x] Problema identificado
- [x] Frontend corrigido
- [x] Script de consulta criado
- [x] Documentação criada
- [ ] Testar criação de operação
- [ ] Commit e push das alterações
