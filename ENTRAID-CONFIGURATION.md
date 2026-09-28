# 🔐 DevFlow ALYA - Configuração Entra ID (Azure AD)

## Autenticação Multi-Tenant com Arquitetura Escalável

**Versão:** 1.0.0  
**Data:** 2026-09-28  
**Estratégia:** 3 Single-Tenants com Expansão Futura

---

## 📋 Visão Geral

O DevFlow ALYA implementa autenticação via **Microsoft Entra ID (Azure AD)** com suporte a **múltiplos tenants** (um para cada empresa do Grupo ALYA).

### **Arquitetura Implementada:**

- ✅ **3 Single-Tenant Apps** (ALYA, Mobyan, TaNaPorta)
- ✅ **Configuração centralizada** via interface administrativa
- ✅ **Escalável** para novos tenants futuros
- ✅ **Isolamento** total entre empresas
- ✅ **Auditoria** completa de autenticações
- ✅ **Proteção** por flag AdminDevFlow

---

## 🏗️ Estrutura Implementada

### **1. Banco de Dados**

#### **Tabela: `auth.EntraIDTenant`**

Armazena configurações de cada tenant Entra ID:

```sql
- EntraIDTenantId (PK)
- CompanyId (FK → gov.Company)
- TenantId (Azure AD Tenant ID)
- TenantName (ex: alya.onmicrosoft.com)
- TenantDomain (ex: alya.com.br)
- ClientId (App Registration ID)
- ClientSecretEncrypted (criptografado)
- CertificateThumbprint (alternativa ao secret)
- Authority (URL do Azure AD)
- RedirectUri
- PostLogoutRedirectUri
- IsActive
- AllowAutoUserCreation
- RequireGroupMembership
- AllowedGroupIds (JSON)
- RoleMappingConfig (JSON)
- LastSyncDate
- TotalUsersSync
- LastLoginDate
```

#### **Tabela: `auth.AuthenticationLog`**

Registra todas as tentativas de autenticação:

```sql
- AuthenticationLogId (PK)
- UserId (FK → sec.User)
- EntraIDTenantId (FK → auth.EntraIDTenant)
- Email
- LoginTimestamp
- LoginStatus (Success, Failed, Blocked)
- FailureReason
- IPAddress
- UserAgent
- TokenClaims (JSON)
```

#### **Campo Adicional: `sec.User.IsAdminDevFlow`**

Flag booleana que identifica administradores do DevFlow com acesso total.

---

### **2. Backend API**

#### **Endpoints Protegidos** (Requerem `AdminDevFlow`)

| Método | Endpoint | Descrição |
|--------|----------|-----------|
| `GET` | `/api/v1/entraid-tenants` | Listar todos os tenants |
| `GET` | `/api/v1/entraid-tenants/{id}` | Buscar tenant por ID |
| `GET` | `/api/v1/entraid-tenants/company/{companyId}` | Buscar por empresa |
| `POST` | `/api/v1/entraid-tenants` | Criar novo tenant |
| `PUT` | `/api/v1/entraid-tenants/{id}` | Atualizar tenant |
| `DELETE` | `/api/v1/entraid-tenants/{id}` | Excluir tenant (soft delete) |
| `POST` | `/api/v1/entraid-tenants/{id}/test` | Testar configuração |

#### **Segurança Implementada:**

- ✅ Middleware `require_admin_devflow`
- ✅ Client Secret criptografado (Fernet)
- ✅ Validação de UUIDs
- ✅ Validação de domínios
- ✅ Validação de URLs
- ✅ Soft delete obrigatório
- ✅ Auditoria completa

---

### **3. Frontend**

#### **Tela Administrativa**

**Rota:** `/admin/entraid-tenants`  
**Acesso:** Apenas usuários com `IsAdminDevFlow = true`

**Funcionalidades:**

- ✅ Listagem de tenants configurados
- ✅ Criar novo tenant
- ✅ Editar tenant existente
- ✅ Excluir tenant (com confirmação)
- ✅ Testar configuração
- ✅ Visualizar estatísticas (usuários sync, último login)
- ✅ Botão de retorno ao Dashboard

**Campos do Formulário:**

1. **Empresa** (select)
2. **Tenant ID** (UUID do Azure AD)
3. **Tenant Name** (ex: alya.onmicrosoft.com)
4. **Domínio** (ex: alya.com.br)
5. **Client ID** (UUID do App Registration)
6. **Client Secret** (password, criptografado)
7. **Certificate Thumbprint** (alternativa)
8. **Authority URL**
9. **Redirect URI**
10. **Post Logout Redirect URI**
11. **Configurações** (switches):
    - Ativo
    - Criar usuários automaticamente
    - Requer grupo específico
12. **Descrição**
13. **Notas de Configuração**

---

## 🚀 Como Configurar

### **Passo 1: Executar Migration SQL**

```bash
# Executar o script V3_1_0__EntraID_Tenants.sql no SQL Server
```

Este script cria:
- Schema `auth`
- Tabela `auth.EntraIDTenant`
- Tabela `auth.AuthenticationLog`
- Campo `sec.User.IsAdminDevFlow`
- Índices e constraints

---

### **Passo 2: Configurar Azure AD (Para Cada Empresa)**

#### **A) Criar App Registration**

1. Acesse o **Azure Portal** da empresa
2. Navegue para **Azure Active Directory** → **App registrations**
3. Clique em **New registration**
4. Preencha:
   - **Name:** DevFlow ALYA
   - **Supported account types:** Single tenant
   - **Redirect URI:** `http://localhost:5173/auth/callback` (dev)
5. Clique em **Register**

#### **B) Anotar Informações**

Após criar o App Registration, anote:

```
Tenant ID: xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
Tenant Name: alya.onmicrosoft.com
Client ID: xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
```

#### **C) Criar Client Secret**

1. No App Registration, vá em **Certificates & secrets**
2. Clique em **New client secret**
3. Preencha:
   - **Description:** DevFlow Secret
   - **Expires:** 24 months (recomendado)
4. Clique em **Add**
5. **COPIE O SECRET IMEDIATAMENTE** (não será mostrado novamente)

```
Client Secret: xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
```

#### **D) Configurar API Permissions**

1. No App Registration, vá em **API permissions**
2. Clique em **Add a permission**
3. Selecione **Microsoft Graph**
4. Selecione **Delegated permissions**
5. Adicione:
   - `User.Read`
   - `User.ReadBasic.All`
   - `email`
   - `openid`
   - `profile`
6. Clique em **Grant admin consent** (requer admin)

#### **E) Configurar Redirect URIs**

1. No App Registration, vá em **Authentication**
2. Em **Platform configurations**, adicione:
   - **Web** → `http://localhost:5173/auth/callback` (dev)
   - **Web** → `https://devflow.alya.com.br/auth/callback` (prod)
3. Em **Logout URL**, adicione:
   - `http://localhost:5173` (dev)
   - `https://devflow.alya.com.br` (prod)
4. Salve

---

### **Passo 3: Cadastrar Tenant no DevFlow**

#### **A) Marcar Usuário como Admin**

```sql
-- Marcar seu usuário como Admin DevFlow
UPDATE sec.[User]
SET IsAdminDevFlow = 1
WHERE Email = 'seu.email@alya.com.br';
```

#### **B) Acessar Tela Administrativa**

1. Faça login no DevFlow
2. No menu lateral, vá em **ADMINISTRAÇÃO** → **Configuração Entra ID**
3. Clique em **Adicionar**

#### **C) Preencher Formulário**

```
Empresa: ALYA Serviços

Tenant ID: [copiar do Azure]
Tenant Name: alya.onmicrosoft.com
Domínio: alya.com.br

Client ID: [copiar do Azure]
Client Secret: [copiar do Azure - será criptografado]

Authority URL: https://login.microsoftonline.com/[tenant-id]
Redirect URI: http://localhost:5173/auth/callback
Post Logout Redirect URI: http://localhost:5173

✓ Ativo
✓ Criar Usuários Automaticamente
☐ Requer Grupo Específico

Descrição: Tenant Entra ID da ALYA Serviços
Notas: Configurado em 2026-09-28
```

#### **D) Salvar e Testar**

1. Clique em **Salvar**
2. Na listagem, clique no ícone de **Teste** (tubo de ensaio)
3. Verifique se a configuração está válida

---

### **Passo 4: Repetir para Outras Empresas**

Repita os **Passos 2 e 3** para:
- **Mobyan**
- **TaNaPorta**
- Futuras empresas do Grupo

---

## 🔒 Segurança

### **Criptografia de Secrets**

O Client Secret é criptografado usando **Fernet** (symmetric encryption) antes de ser armazenado no banco.

**Configuração:**

```bash
# Gerar chave de criptografia (apenas uma vez)
python -c "from cryptography.fernet import Fernet; print(Fernet.generate_key().decode())"

# Adicionar ao .env do backend
ENCRYPTION_KEY=sua_chave_gerada_aqui
```

**⚠️ IMPORTANTE:**
- Guarde a `ENCRYPTION_KEY` em local seguro
- Use Azure Key Vault em produção
- Nunca commite a chave no Git

---

### **Proteção de Endpoints**

Todos os endpoints de gerenciamento de tenants são protegidos:

```python
@router.get("/entraid-tenants", dependencies=[Depends(require_admin_devflow)])
```

Apenas usuários com `IsAdminDevFlow = true` podem acessar.

---

### **Auditoria**

Todas as ações são auditadas:

- **Criação/Edição/Exclusão** de tenants → campos `CreatedBy`, `UpdatedBy`, `DeletedBy`
- **Tentativas de login** → tabela `auth.AuthenticationLog`
- **Soft delete** → registros nunca são removidos fisicamente

---

## 📊 Monitoramento

### **Queries Úteis**

#### **Listar Tenants Ativos**

```sql
SELECT 
    t.TenantName,
    c.Nome AS Empresa,
    t.TenantDomain,
    t.TotalUsersSync,
    t.LastLoginDate,
    t.IsActive
FROM auth.EntraIDTenant t
INNER JOIN gov.Company c ON t.CompanyId = c.CompanyId
WHERE t.IsDeleted = 0
ORDER BY c.Nome;
```

#### **Últimos Logins**

```sql
SELECT TOP 100
    l.Email,
    t.TenantName,
    l.LoginTimestamp,
    l.LoginStatus,
    l.IPAddress
FROM auth.AuthenticationLog l
LEFT JOIN auth.EntraIDTenant t ON l.EntraIDTenantId = t.EntraIDTenantId
ORDER BY l.LoginTimestamp DESC;
```

#### **Tentativas de Login Falhadas**

```sql
SELECT 
    Email,
    COUNT(*) AS FailedAttempts,
    MAX(LoginTimestamp) AS LastAttempt,
    MAX(FailureReason) AS Reason
FROM auth.AuthenticationLog
WHERE LoginStatus = 'Failed'
  AND LoginTimestamp >= DATEADD(HOUR, -24, GETUTCDATE())
GROUP BY Email
HAVING COUNT(*) >= 3
ORDER BY FailedAttempts DESC;
```

---

## 🧪 Testes

### **Teste de Configuração**

Na tela administrativa, clique no botão **Testar** para validar:

- ✅ Tenant está ativo
- ✅ Método de autenticação configurado (secret ou certificado)
- ✅ Authority URL válida
- ✅ Redirect URI configurada

### **Teste de Autenticação (Manual)**

1. Acesse a tela de login
2. Digite um email da empresa (ex: `usuario@alya.com.br`)
3. Sistema identifica o tenant pelo domínio
4. Redireciona para Entra ID da ALYA
5. Usuário faz login no Azure
6. Retorna ao DevFlow com token
7. Sistema cria/atualiza usuário automaticamente

---

## 🔄 Sincronização de Usuários

### **Criação Automática**

Se `AllowAutoUserCreation = true`:

1. Usuário faz login via Entra ID
2. Sistema verifica se usuário existe no DevFlow
3. Se não existir, cria automaticamente com dados do token:
   - Nome completo
   - Email
   - Empresa (pelo tenant)
   - Roles padrão

### **Validação de Grupos**

Se `RequireGroupMembership = true`:

1. Sistema valida se usuário pertence a um dos grupos em `AllowedGroupIds`
2. Se não pertencer, bloqueia o login
3. Registra tentativa em `AuthenticationLog`

---

## 🚨 Troubleshooting

### **Erro: "Tenant configuration not found"**

**Causa:** Domínio do email não corresponde a nenhum tenant cadastrado.

**Solução:**
1. Verifique se o tenant está cadastrado
2. Verifique se `TenantDomain` está correto
3. Verifique se `IsActive = true`

---

### **Erro: "Client secret invalid"**

**Causa:** Secret expirou ou está incorreto.

**Solução:**
1. Gere novo secret no Azure Portal
2. Atualize no DevFlow (tela administrativa)
3. Teste novamente

---

### **Erro: "User not authorized"**

**Causa:** Usuário não pertence ao grupo permitido.

**Solução:**
1. Adicione usuário ao grupo no Azure AD
2. Ou desabilite `RequireGroupMembership`

---

## 📚 Próximos Passos

### **Implementação Futura**

1. ✅ Implementar fluxo OAuth completo
2. ✅ Validação de tokens JWT
3. ✅ Refresh tokens
4. ✅ Single Sign-On (SSO)
5. ✅ Mapeamento automático de roles
6. ✅ Sincronização periódica de usuários
7. ✅ Suporte a certificados (além de secrets)
8. ✅ Multi-factor authentication (MFA)

---

## 📞 Suporte

Para dúvidas ou problemas:

1. Consulte a documentação do Azure AD
2. Verifique logs em `auth.AuthenticationLog`
3. Entre em contato com o time de TI

---

**Desenvolvido para:** Grupo ALYA (ALYA, Mobyan, TaNaPorta)  
**Tecnologias:** Microsoft Entra ID, FastAPI, Vue 3, SQL Server  
**Data:** 2026-09-28  
**Status:** ✅ Pronto para Configuração
