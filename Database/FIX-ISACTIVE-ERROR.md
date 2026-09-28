# ⚠️ SOLUÇÃO - Erro "Nome de coluna 'IsActive' inválido"

## Problema

```
Mensagem 207, Nível 16, Estado 1, Linha 24
Nome de coluna 'IsActive' inválido.
```

---

## 🔍 Causa

A tabela `gov.Holding` foi criada com a coluna `Status` (VARCHAR), mas o script de inserção está tentando usar `IsActive` (BIT) que ainda não existe.

---

## ✅ Solução em 3 Passos

### **Passo 1: Diagnosticar o Banco**

Execute o script de diagnóstico para ver o estado atual:

```bash
sqlcmd -S ALYA-TI-001\SQLSERVERLOCAL -d DevFlow_ALYA -i Database/DIAGNOSE_DATABASE.sql
```

**O que ele mostra:**
- ✅ Quais colunas existem (Status ou IsActive)
- ✅ Se DEFAULT NEWID() está configurado
- ✅ Dados existentes nas tabelas
- ✅ Recomendações de ação

---

### **Passo 2: Executar Migration de Correção**

Execute o script corrigido:

```bash
sqlcmd -S ALYA-TI-001\SQLSERVERLOCAL -d DevFlow_ALYA -i Database/V3_2_1__Fix_Status_Fields_Corrected.sql
```

**O que ele faz:**
- ✅ Remove constraint CHECK de Status
- ✅ Cria coluna IsActive (BIT)
- ✅ Migra dados de Status → IsActive
- ✅ Remove coluna Status antiga
- ✅ Adiciona DEFAULT NEWID() nos campos ID

**Saída esperada:**

```
========================================
MIGRATION V3.2.1 - Correção de Status
========================================

1. Adicionando DEFAULT NEWID() em campos ID...
   ✓ DEFAULT adicionado em gov.Holding.HoldingId
   ✓ DEFAULT adicionado em gov.Company.CompanyId

2. Corrigindo gov.Holding...
   ℹ Coluna Status encontrada, iniciando conversão...
   ✓ Constraint CHECK removida
   ✓ Coluna IsActive criada
   ✓ Dados migrados de Status para IsActive
   ✓ Coluna Status removida

3. Corrigindo gov.Company...
   ℹ Coluna Status encontrada, iniciando conversão...
   ✓ Constraint CHECK removida
   ✓ Coluna IsActive criada
   ✓ Dados migrados de Status para IsActive
   ✓ Coluna Status removida

✓ Migration V3.2.1 concluída com sucesso!
```

---

### **Passo 3: Inserir Dados**

Agora você pode usar o INSERT corrigido:

```sql
-- ✅ FORMA SIMPLES (recomendada)
INSERT INTO gov.Holding (Nome, Sigla, IsActive)
VALUES ('Transire Logistica e Serviço', 'TLogServ', 1);

-- ✅ AINDA MAIS SIMPLES (IsActive = 1 por padrão)
INSERT INTO gov.Holding (Nome, Sigla)
VALUES ('Transire Logistica e Serviço', 'TLogServ');
```

---

## 📋 Checklist Rápido

Execute na ordem:

- [ ] **1. Diagnosticar:** `DIAGNOSE_DATABASE.sql`
- [ ] **2. Corrigir:** `V3_2_1__Fix_Status_Fields_Corrected.sql`
- [ ] **3. Inserir:** Usar `IsActive` em vez de `Status`

---

## 🎯 Comandos Completos

```bash
# 1. Diagnosticar
sqlcmd -S ALYA-TI-001\SQLSERVERLOCAL -d DevFlow_ALYA -i Database/DIAGNOSE_DATABASE.sql

# 2. Corrigir
sqlcmd -S ALYA-TI-001\SQLSERVERLOCAL -d DevFlow_ALYA -i Database/V3_2_1__Fix_Status_Fields_Corrected.sql

# 3. Inserir (via SQL)
sqlcmd -S ALYA-TI-001\SQLSERVERLOCAL -d DevFlow_ALYA -Q "INSERT INTO gov.Holding (Nome, Sigla, IsActive) VALUES ('Transire Logistica e Serviço', 'TLogServ', 1)"
```

---

## 📊 Antes vs Depois

### **ANTES (com erro):**

```sql
-- ❌ ERRO: IsActive não existe
INSERT INTO gov.Holding (Nome, Sigla, IsActive)
VALUES ('Transire', 'TLogServ', 1);

-- Mensagem 207: Nome de coluna 'IsActive' inválido
```

**Estrutura:**
```
gov.Holding
├── HoldingId (UNIQUEIDENTIFIER) - sem DEFAULT
├── Nome (NVARCHAR)
├── Sigla (NVARCHAR)
└── Status (VARCHAR) ← problema!
```

### **DEPOIS (corrigido):**

```sql
-- ✅ FUNCIONA
INSERT INTO gov.Holding (Nome, Sigla, IsActive)
VALUES ('Transire Logistica e Serviço', 'TLogServ', 1);

-- OU ainda mais simples:
INSERT INTO gov.Holding (Nome, Sigla)
VALUES ('Transire Logistica e Serviço', 'TLogServ');
```

**Estrutura:**
```
gov.Holding
├── HoldingId (UNIQUEIDENTIFIER) - DEFAULT NEWID() ✓
├── Nome (NVARCHAR)
├── Sigla (NVARCHAR)
└── IsActive (BIT) - DEFAULT 1 ✓
```

---

## 🔍 Verificar se Funcionou

Após executar a migration:

```sql
-- Ver estrutura
SELECT 
    c.name AS Coluna,
    t.name AS Tipo,
    CASE WHEN dc.definition IS NOT NULL THEN dc.definition ELSE '' END AS [Default]
FROM sys.columns c
INNER JOIN sys.types t ON c.user_type_id = t.user_type_id
LEFT JOIN sys.default_constraints dc ON c.default_object_id = dc.object_id
WHERE c.object_id = OBJECT_ID('gov.Holding')
ORDER BY c.column_id;

-- Resultado esperado:
-- HoldingId | uniqueidentifier | (newid())
-- Nome      | nvarchar         | 
-- Sigla     | nvarchar         | 
-- IsActive  | bit              | ((1))
```

---

## ⚠️ Se Ainda Não Funcionar

### **Erro: "Constraint CHECK impede a alteração"**

```sql
-- Remover manualmente a constraint
ALTER TABLE gov.Holding DROP CONSTRAINT CK_Holding_Status;
-- Depois executar a migration novamente
```

### **Erro: "Coluna Status não pode ser removida"**

```sql
-- Ver dependências
sp_help 'gov.Holding';
-- Remover constraints/índices que dependem de Status
```

### **Erro: "DEFAULT já existe"**

```
Isso é OK! Significa que já foi aplicado.
Pule para o Passo 3 (inserir dados).
```

---

## 📚 Arquivos Relacionados

1. **Diagnóstico:** `DIAGNOSE_DATABASE.sql`
   - Mostra estado atual do banco

2. **Correção:** `V3_2_1__Fix_Status_Fields_Corrected.sql`
   - Aplica as correções

3. **Inserção:** `INSERT_ALYA_ORGANIZATION.sql`
   - Script pronto para criar estrutura ALYA

4. **Guia:** `QUICK-INSERT-GUIDE.md`
   - Exemplos de INSERT

---

## 🎉 Resumo

**Problema:** Coluna `IsActive` não existe (ainda é `Status`)  
**Solução:** Executar migration `V3_2_1__Fix_Status_Fields_Corrected.sql`  
**Resultado:** Pode usar `IsActive` (BIT) e omitir `HoldingId` (DEFAULT NEWID())

---

**Execute o diagnóstico primeiro para ver o estado atual!** 🚀

```bash
sqlcmd -S ALYA-TI-001\SQLSERVERLOCAL -d DevFlow_ALYA -i Database/DIAGNOSE_DATABASE.sql
```
