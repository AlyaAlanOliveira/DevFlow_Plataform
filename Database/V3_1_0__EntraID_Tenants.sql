/*
 * DevFlow ALYA - Migration V3.1.0
 * Entra ID Multi-Tenant Configuration
 * 
 * Descrição:
 * - Adiciona tabela para configuração de Tenants Entra ID
 * - Adiciona flag AdminDevFlow na tabela User
 * - Suporta múltiplos tenants (ALYA, Mobyan, TaNaPorta, futuros)
 * - Configuração centralizada e auditada
 * 
 * Data: 2026-09-28
 */

-- =====================================================
-- 1. ADICIONAR FLAG ADMIN NA TABELA USER
-- =====================================================

IF NOT EXISTS (
    SELECT 1 FROM sys.columns 
    WHERE object_id = OBJECT_ID('sec.[User]') 
    AND name = 'IsAdminDevFlow'
)
BEGIN
    ALTER TABLE sec.[User]
    ADD IsAdminDevFlow BIT NOT NULL DEFAULT 0;
    
    PRINT 'Coluna IsAdminDevFlow adicionada à tabela sec.User';
END
GO

-- Criar índice para performance
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_User_IsAdminDevFlow')
BEGIN
    CREATE INDEX IX_User_IsAdminDevFlow 
    ON sec.[User](IsAdminDevFlow)
    WHERE IsAdminDevFlow = 1;
    
    PRINT 'Índice IX_User_IsAdminDevFlow criado';
END
GO

-- =====================================================
-- 2. CRIAR SCHEMA PARA AUTENTICAÇÃO
-- =====================================================

IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'auth')
BEGIN
    EXEC('CREATE SCHEMA auth');
    PRINT 'Schema auth criado';
END
GO

-- =====================================================
-- 3. CRIAR TABELA DE TENANTS ENTRA ID
-- =====================================================

IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'EntraIDTenant' AND schema_id = SCHEMA_ID('auth'))
BEGIN
    CREATE TABLE auth.EntraIDTenant (
        -- Identificação
        EntraIDTenantId         UNIQUEIDENTIFIER    NOT NULL DEFAULT NEWID(),
        CompanyId               UNIQUEIDENTIFIER    NOT NULL,
        
        -- Configuração Entra ID
        TenantId                UNIQUEIDENTIFIER    NOT NULL,
        TenantName              NVARCHAR(255)       NOT NULL,
        TenantDomain            NVARCHAR(255)       NOT NULL,
        
        -- App Registration
        ClientId                UNIQUEIDENTIFIER    NOT NULL,
        ClientSecretEncrypted   NVARCHAR(MAX)       NULL,      -- Encrypted
        CertificateThumbprint   NVARCHAR(100)       NULL,      -- Alternative to secret
        
        -- Endpoints
        Authority               NVARCHAR(500)       NOT NULL,  -- https://login.microsoftonline.com/{tenant-id}
        RedirectUri             NVARCHAR(500)       NOT NULL,
        PostLogoutRedirectUri   NVARCHAR(500)       NULL,
        
        -- Configurações
        IsActive                BIT                 NOT NULL DEFAULT 1,
        AllowAutoUserCreation   BIT                 NOT NULL DEFAULT 1,
        RequireGroupMembership  BIT                 NOT NULL DEFAULT 0,
        AllowedGroupIds         NVARCHAR(MAX)       NULL,      -- JSON array of group IDs
        
        -- Mapeamento de Roles
        RoleMappingConfig       NVARCHAR(MAX)       NULL,      -- JSON config
        
        -- Metadados
        Description             NVARCHAR(500)       NULL,
        ConfigurationNotes      NVARCHAR(MAX)       NULL,
        
        -- Estatísticas
        LastSyncDate            DATETIME2           NULL,
        TotalUsersSync          INT                 NOT NULL DEFAULT 0,
        LastLoginDate           DATETIME2           NULL,
        
        -- Auditoria
        CreatedAt               DATETIME2           NOT NULL DEFAULT GETUTCDATE(),
        CreatedBy               UNIQUEIDENTIFIER    NOT NULL,
        UpdatedAt               DATETIME2           NULL,
        UpdatedBy               UNIQUEIDENTIFIER    NULL,
        DeletedAt               DATETIME2           NULL,
        DeletedBy               UNIQUEIDENTIFIER    NULL,
        IsDeleted               BIT                 NOT NULL DEFAULT 0,
        RowVersion              ROWVERSION          NOT NULL,
        
        -- Constraints
        CONSTRAINT PK_EntraIDTenant PRIMARY KEY (EntraIDTenantId),
        CONSTRAINT FK_EntraIDTenant_Company FOREIGN KEY (CompanyId) 
            REFERENCES gov.Company(CompanyId),
        CONSTRAINT FK_EntraIDTenant_CreatedBy FOREIGN KEY (CreatedBy) 
            REFERENCES sec.[User](UserId),
        CONSTRAINT FK_EntraIDTenant_UpdatedBy FOREIGN KEY (UpdatedBy) 
            REFERENCES sec.[User](UserId),
        CONSTRAINT FK_EntraIDTenant_DeletedBy FOREIGN KEY (DeletedBy) 
            REFERENCES sec.[User](UserId),
        CONSTRAINT UQ_EntraIDTenant_TenantId UNIQUE (TenantId),
        CONSTRAINT UQ_EntraIDTenant_ClientId UNIQUE (ClientId),
        CONSTRAINT UQ_EntraIDTenant_Company UNIQUE (CompanyId),
        CONSTRAINT CK_EntraIDTenant_TenantDomain CHECK (TenantDomain LIKE '%.%')
    );
    
    PRINT 'Tabela auth.EntraIDTenant criada';
END
GO

-- =====================================================
-- 4. CRIAR ÍNDICES
-- =====================================================

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_EntraIDTenant_CompanyId')
BEGIN
    CREATE INDEX IX_EntraIDTenant_CompanyId 
    ON auth.EntraIDTenant(CompanyId)
    WHERE IsDeleted = 0;
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_EntraIDTenant_TenantId')
BEGIN
    CREATE INDEX IX_EntraIDTenant_TenantId 
    ON auth.EntraIDTenant(TenantId)
    WHERE IsDeleted = 0;
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_EntraIDTenant_TenantDomain')
BEGIN
    CREATE INDEX IX_EntraIDTenant_TenantDomain 
    ON auth.EntraIDTenant(TenantDomain)
    WHERE IsDeleted = 0;
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_EntraIDTenant_IsActive')
BEGIN
    CREATE INDEX IX_EntraIDTenant_IsActive 
    ON auth.EntraIDTenant(IsActive)
    WHERE IsDeleted = 0 AND IsActive = 1;
END
GO

-- =====================================================
-- 5. CRIAR TABELA DE LOG DE AUTENTICAÇÃO
-- =====================================================

IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'AuthenticationLog' AND schema_id = SCHEMA_ID('auth'))
BEGIN
    CREATE TABLE auth.AuthenticationLog (
        AuthenticationLogId     UNIQUEIDENTIFIER    NOT NULL DEFAULT NEWID(),
        UserId                  UNIQUEIDENTIFIER    NULL,
        EntraIDTenantId         UNIQUEIDENTIFIER    NULL,
        
        -- Dados do Login
        Email                   NVARCHAR(255)       NOT NULL,
        LoginTimestamp          DATETIME2           NOT NULL DEFAULT GETUTCDATE(),
        LoginStatus             NVARCHAR(50)        NOT NULL, -- Success, Failed, Blocked
        FailureReason           NVARCHAR(500)       NULL,
        
        -- Dados Técnicos
        IPAddress               NVARCHAR(50)        NULL,
        UserAgent               NVARCHAR(500)       NULL,
        TokenClaims             NVARCHAR(MAX)       NULL,     -- JSON
        
        -- Constraints
        CONSTRAINT PK_AuthenticationLog PRIMARY KEY (AuthenticationLogId),
        CONSTRAINT FK_AuthenticationLog_User FOREIGN KEY (UserId) 
            REFERENCES sec.[User](UserId),
        CONSTRAINT FK_AuthenticationLog_Tenant FOREIGN KEY (EntraIDTenantId) 
            REFERENCES auth.EntraIDTenant(EntraIDTenantId)
    );
    
    PRINT 'Tabela auth.AuthenticationLog criada';
END
GO

-- Índices para logs
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_AuthenticationLog_UserId')
BEGIN
    CREATE INDEX IX_AuthenticationLog_UserId 
    ON auth.AuthenticationLog(UserId, LoginTimestamp DESC);
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_AuthenticationLog_Email')
BEGIN
    CREATE INDEX IX_AuthenticationLog_Email 
    ON auth.AuthenticationLog(Email, LoginTimestamp DESC);
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_AuthenticationLog_Timestamp')
BEGIN
    CREATE INDEX IX_AuthenticationLog_Timestamp 
    ON auth.AuthenticationLog(LoginTimestamp DESC);
END
GO

-- =====================================================
-- 6. COMENTÁRIOS E DOCUMENTAÇÃO
-- =====================================================

EXEC sys.sp_addextendedproperty 
    @name = N'MS_Description',
    @value = N'Configuração de Tenants Entra ID (Azure AD) para autenticação multi-tenant',
    @level0type = N'SCHEMA', @level0name = 'auth',
    @level1type = N'TABLE', @level1name = 'EntraIDTenant';
GO

EXEC sys.sp_addextendedproperty 
    @name = N'MS_Description',
    @value = N'ID único do Tenant no Entra ID (Azure AD)',
    @level0type = N'SCHEMA', @level0name = 'auth',
    @level1type = N'TABLE', @level1name = 'EntraIDTenant',
    @level2type = N'COLUMN', @level2name = 'TenantId';
GO

EXEC sys.sp_addextendedproperty 
    @name = N'MS_Description',
    @value = N'Client ID do App Registration no Azure',
    @level0type = N'SCHEMA', @level0name = 'auth',
    @level1type = N'TABLE', @level1name = 'EntraIDTenant',
    @level2type = N'COLUMN', @level2name = 'ClientId';
GO

EXEC sys.sp_addextendedproperty 
    @name = N'MS_Description',
    @value = N'Client Secret criptografado (ou usar certificado)',
    @level0type = N'SCHEMA', @level0name = 'auth',
    @level1type = N'TABLE', @level1name = 'EntraIDTenant',
    @level2type = N'COLUMN', @level2name = 'ClientSecretEncrypted';
GO

EXEC sys.sp_addextendedproperty 
    @name = N'MS_Description',
    @value = N'Flag que identifica administradores do DevFlow com acesso total',
    @level0type = N'SCHEMA', @level0name = 'sec',
    @level1type = N'TABLE', @level1name = 'User',
    @level2type = N'COLUMN', @level2name = 'IsAdminDevFlow';
GO

-- =====================================================
-- 7. DADOS SEED (PLACEHOLDERS)
-- =====================================================

-- Nota: Os dados reais serão inseridos via interface administrativa
-- Aqui apenas estrutura de exemplo comentada

/*
-- Exemplo de configuração para ALYA
INSERT INTO auth.EntraIDTenant (
    EntraIDTenantId,
    CompanyId,
    TenantId,
    TenantName,
    TenantDomain,
    ClientId,
    Authority,
    RedirectUri,
    IsActive,
    AllowAutoUserCreation,
    Description,
    CreatedBy
)
SELECT
    NEWID(),
    c.CompanyId,
    '00000000-0000-0000-0000-000000000000', -- Substituir pelo Tenant ID real
    'alya.onmicrosoft.com',
    'alya.com.br',
    '00000000-0000-0000-0000-000000000000', -- Substituir pelo Client ID real
    'https://login.microsoftonline.com/00000000-0000-0000-0000-000000000000',
    'http://localhost:5173/auth/callback',
    1,
    1,
    'Tenant Entra ID da ALYA Serviços',
    '00000000-0000-0000-0000-000000000001'
FROM gov.Company c
WHERE c.Sigla = 'ALYA';
*/

PRINT 'Migration V3.1.0 - Entra ID Tenants concluída com sucesso!';
GO
