# 🔍 Guia de Campos do Azure AD (Português)

## Entendendo os Campos do Portal Azure em Português

---

## 📋 Visão Geral - Tenant ALYA

Seus dados do Azure AD:

```
Tenant ID: 1dc3daaa-af0e-4f74-81a6-2ce523fd88ed
Tenant Name: ALYA SERVICOS E LOGISTICA LTDA
Domain: alyaservicos.com.br
```

---

## 🔑 App Registration - Campos Importantes

### **1. IDs do Aplicativo**

Quando você abre o **App Registration** no Azure Portal, vê dois IDs:

#### **✅ ID do Aplicativo (Application ID)**
```
Português: ID do Aplicativo
Inglês: Application (client) ID
Valor: 90a62aa9-ba5b-4ecb-8545-72ee0bf64b09

✅ USAR ESTE COMO CLIENT ID!
```

**Onde usar:**
- Campo `ClientId` no DevFlow
- Parâmetro `client_id` em requisições OAuth
- Configuração de aplicativos

**Por quê:**
- É o identificador público do seu aplicativo
- Usado para autenticação OAuth/OpenID
- Aparece nos tokens JWT

---

#### **❌ ID do Objeto (Object ID)**
```
Português: ID do Objeto
Inglês: Object ID
Valor: 8654115c-bf40-4411-9224-fc7bc0a77f79

❌ NÃO USAR PARA AUTENTICAÇÃO!
```

**Onde usar:**
- Apenas para gerenciamento via Microsoft Graph API
- Operações administrativas no Azure AD
- Scripts de automação

**Por quê:**
- É um identificador interno do Azure AD
- Não é usado em fluxos de autenticação
- Não aparece em tokens

---

### **2. Client Secret (Segredo do Cliente)**

Quando você cria um **Client Secret**, o Azure mostra:

#### **✅ Valor (Value)**
```
Português: Valor
Inglês: Value
Valor: YOUR_CLIENT_SECRET_VALUE_HERE

✅ USAR ESTE COMO CLIENT SECRET!
```

**Importante:**
- ⚠️ **Copie IMEDIATAMENTE!** Não será mostrado novamente
- Este é o "password" do seu aplicativo
- Será criptografado antes de salvar no DevFlow

---

#### **❌ ID do Segredo (Secret ID)**
```
Português: ID do Segredo
Inglês: Secret ID
Valor: 1946ac28-d7b3-47b9-88f9-ba103f3a5464

❌ NÃO USAR PARA AUTENTICAÇÃO!
```

**Onde usar:**
- Apenas para identificar qual secret você está usando
- Útil quando você tem múltiplos secrets
- Para revogar um secret específico

**Por quê:**
- É apenas um identificador do secret no Azure
- Não tem valor de autenticação
- Não é enviado em requisições

---

### **3. Certificado (Alternativa ao Secret)**

Se você usar certificado em vez de secret:

#### **Valor do Certificado (Certificate Value)**
```
Português: Valor do Certificado
Inglês: Certificate Value

Este é o certificado público (X.509)
```

#### **Thumbprint do Certificado**
```
Português: Impressão Digital
Inglês: Thumbprint

✅ USAR ESTE NO CAMPO CertificateThumbprint
```

---

## 📊 Resumo Visual

```
┌─────────────────────────────────────────────────────┐
│         AZURE AD APP REGISTRATION (PT-BR)           │
├─────────────────────────────────────────────────────┤
│                                                     │
│  ID do Aplicativo: 90a62aa9-...                    │
│  ✅ USAR como ClientId                             │
│                                                     │
│  ID do Objeto: 8654115c-...                        │
│  ❌ NÃO USAR (apenas interno)                      │
│                                                     │
├─────────────────────────────────────────────────────┤
│  CERTIFICADOS E SEGREDOS                            │
├─────────────────────────────────────────────────────┤
│                                                     │
│  Valor: YOUR_CLIENT_SECRET_VALUE_HERE              │
│  ✅ USAR como ClientSecret                         │
│                                                     │
│  ID do Segredo: 1946ac28-...                       │
│  ❌ NÃO USAR (apenas identificador)                │
│                                                     │
└─────────────────────────────────────────────────────┘
```

---

## ✅ Dados Corretos para o Tenant ALYA

### **Para Cadastrar no DevFlow:**

```json
{
  "CompanyId": "[UUID da empresa ALYA no banco]",
  "TenantId": "1dc3daaa-af0e-4f74-81a6-2ce523fd88ed",
  "TenantName": "ALYA SERVICOS E LOGISTICA LTDA",
  "TenantDomain": "alyaservicos.com.br",
  "ClientId": "90a62aa9-ba5b-4ecb-8545-72ee0bf64b09",
  "ClientSecret": "YOUR_CLIENT_SECRET_VALUE_HERE",
  "Authority": "https://login.microsoftonline.com/1dc3daaa-af0e-4f74-81a6-2ce523fd88ed",
  "RedirectUri": "http://localhost:5173/auth/callback",
  "IsActive": true,
  "AllowAutoUserCreation": true
}
```

---

## 🧪 Como Validar

Execute o script de teste que criei:

```bash
cd backend
python test_alya_tenant.py
```

Este script vai:
1. ✅ Validar formato dos UUIDs
2. ✅ Validar domínio
3. ✅ Verificar OpenID Configuration
4. ✅ **Testar Client ID + Secret** (mais importante!)
5. ✅ Validar Redirect URI
6. ✅ Gerar SQL e JSON para cadastro

---

## 🎯 Campos no Formulário do DevFlow

Quando você for cadastrar na tela administrativa:

| Campo no DevFlow | Valor | Observação |
|------------------|-------|------------|
| **Empresa** | ALYA Serviços | Select |
| **Tenant ID** | `1dc3daaa-af0e-4f74-81a6-2ce523fd88ed` | UUID |
| **Tenant Name** | `ALYA SERVICOS E LOGISTICA LTDA` | Texto |
| **Domínio** | `alyaservicos.com.br` | Texto |
| **Client ID** | `90a62aa9-ba5b-4ecb-8545-72ee0bf64b09` | ✅ ID do Aplicativo |
| **Client Secret** | `YOUR_CLIENT_SECRET_VALUE_HERE` | ✅ Valor do Secret |
| **Certificate Thumbprint** | *(deixar vazio)* | Não está usando |
| **Authority URL** | `https://login.microsoftonline.com/1dc3daaa-af0e-4f74-81a6-2ce523fd88ed` | Auto-gerado |
| **Redirect URI** | `http://localhost:5173/auth/callback` | Dev |
| **Post Logout Redirect URI** | `http://localhost:5173` | Dev |
| **Ativo** | ✅ Sim | Switch |
| **Criar Usuários Automaticamente** | ✅ Sim | Switch |
| **Requer Grupo Específico** | ❌ Não | Switch |

---

## 🔍 Como Encontrar no Azure Portal (PT-BR)

### **Passo 1: Acessar App Registration**

1. Azure Portal → **Azure Active Directory**
2. Menu lateral → **Registros de aplicativo**
3. Clique no seu app: **DevFlow ALYA**

### **Passo 2: Copiar IDs**

Na página **Visão Geral**:

```
Exibição do aplicativo
├── Nome: DevFlow ALYA
├── ID do Aplicativo (cliente): 90a62aa9-...  ✅ COPIAR
├── ID do Objeto: 8654115c-...                ❌ IGNORAR
└── ID do Diretório (locatário): 1dc3daaa-... ✅ COPIAR
```

### **Passo 3: Copiar Client Secret**

1. Menu lateral → **Certificados e segredos**
2. Aba **Segredos do cliente**
3. Se já existe:
   - **Valor**: `YOUR_SECRET_HERE` ✅ COPIAR (só aparece uma vez!)
   - **ID do Segredo**: `1946ac28-...` ❌ IGNORAR
4. Se não existe:
   - Clique em **Novo segredo do cliente**
   - Descrição: `DevFlow Secret`
   - Expira em: `24 meses`
   - Clique em **Adicionar**
   - **COPIE O VALOR IMEDIATAMENTE!**

---

## ⚠️ Erros Comuns

### **Erro 1: "invalid_client"**

```
Causa: Client ID incorreto
Solução: Use o "ID do Aplicativo", NÃO o "ID do Objeto"
```

### **Erro 2: "invalid_request" ou "unauthorized_client"**

```
Causa: Client Secret incorreto ou expirado
Solução: 
1. Verifique se copiou o "Valor", NÃO o "ID do Segredo"
2. Verifique se o secret não expirou
3. Gere um novo secret se necessário
```

### **Erro 3: "redirect_uri_mismatch"**

```
Causa: Redirect URI não cadastrada no Azure
Solução:
1. Azure Portal → App Registration → Autenticação
2. Adicione: http://localhost:5173/auth/callback
3. Salve
```

---

## 🧪 Teste Rápido (cURL)

Para testar se Client ID + Secret estão corretos:

```bash
curl -X POST \
  https://login.microsoftonline.com/1dc3daaa-af0e-4f74-81a6-2ce523fd88ed/oauth2/v2.0/token \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -d "grant_type=client_credentials" \
  -d "client_id=90a62aa9-ba5b-4ecb-8545-72ee0bf64b09" \
  -d "client_secret=YOUR_CLIENT_SECRET_VALUE_HERE" \
  -d "scope=https://graph.microsoft.com/.default"
```

**Resposta esperada:**
```json
{
  "token_type": "Bearer",
  "expires_in": 3599,
  "access_token": "eyJ0eXAiOiJKV1QiLCJhbGc..."
}
```

Se retornar um token, está tudo correto! ✅

---

## 📚 Referências

- [Microsoft Identity Platform](https://docs.microsoft.com/azure/active-directory/develop/)
- [App Registration Overview](https://docs.microsoft.com/azure/active-directory/develop/quickstart-register-app)
- [Client Credentials Flow](https://docs.microsoft.com/azure/active-directory/develop/v2-oauth2-client-creds-grant-flow)

---

**Resumo:** Use sempre o **ID do Aplicativo** como Client ID e o **Valor** do secret como Client Secret! 🎯
