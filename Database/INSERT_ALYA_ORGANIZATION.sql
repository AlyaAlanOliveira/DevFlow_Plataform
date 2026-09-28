/*
 * DevFlow ALYA - Inserção da Estrutura Organizacional
 * 
 * Descrição:
 * - Insere Holding ALYA
 * - Insere 3 empresas (ALYA, Mobyan, TaNaPorta)
 * - Cria usuário Admin inicial
 * - Marca usuário como AdminDevFlow
 * 
 * Data: 2026-09-28
 */

SET NOCOUNT ON;
GO

-- =====================================================
-- VARIÁVEIS
-- =====================================================

DECLARE @HoldingId UNIQUEIDENTIFIER = NEWID();
DECLARE @CompanyALYAId UNIQUEIDENTIFIER = NEWID();
DECLARE @CompanyMobyanId UNIQUEIDENTIFIER = NEWID();
DECLARE @CompanyTaNaPortaId UNIQUEIDENTIFIER = NEWID();
DECLARE @SystemUserId UNIQUEIDENTIFIER = '00000000-0000-0000-0000-000000000001';
DECLARE @AdminUserId UNIQUEIDENTIFIER = NEWID();

PRINT '========================================';
PRINT 'INSERINDO ESTRUTURA ORGANIZACIONAL ALYA';
PRINT '========================================';
PRINT '';

-- =====================================================
-- 1. INSERIR HOLDING
-- =====================================================

PRINT '1. Inserindo Holding...';

IF NOT EXISTS (SELECT 1 FROM gov.Holding WHERE Sigla = 'ALYA')
BEGIN
    INSERT INTO gov.Holding (
        HoldingId,
        Nome,
        Sigla,
        CNPJ,
        Status,  -- ✓ BIT (1 = Ativo, 0 = Inativo)
        CreatedAt,
        CreatedBy,
        IsDeleted
    )
    VALUES (
        @HoldingId,
        'ALYA Holding',
        'ALYA',
        NULL,  -- CNPJ da holding (se tiver)
        1,  -- ✓ 1 = Ativo, 0 = Inativo
        GETUTCDATE(),
        @SystemUserId,
        0
    );
    
    PRINT '   ✓ Holding ALYA criada: ' + CAST(@HoldingId AS NVARCHAR(50));
END
ELSE
BEGIN
    SELECT @HoldingId = HoldingId FROM gov.Holding WHERE Sigla = 'ALYA';
    PRINT '   ℹ Holding ALYA já existe: ' + CAST(@HoldingId AS NVARCHAR(50));
END

PRINT '';

-- =====================================================
-- 2. INSERIR EMPRESAS
-- =====================================================

PRINT '2. Inserindo Empresas...';

-- 2.1 ALYA Serviços e Logística
IF NOT EXISTS (SELECT 1 FROM gov.Company WHERE Sigla = 'ALYA')
BEGIN
    INSERT INTO gov.Company (
        CompanyId,
        HoldingId,
        Nome,
        Sigla,
        CNPJ,
        Status,  -- ✓ BIT (1 = Ativo, 0 = Inativo)
        CreatedAt,
        CreatedBy,
        IsDeleted
    )
    VALUES (
        @CompanyALYAId,
        @HoldingId,
        'ALYA Serviços e Logística LTDA',
        'ALYA',
        '12.345.678/0001-90',  -- Substituir pelo CNPJ real
        1,  -- ✓ 1 = Ativo, 0 = Inativo
        GETUTCDATE(),
        @SystemUserId,
        0
    );
    
    PRINT '   ✓ ALYA Serviços criada: ' + CAST(@CompanyALYAId AS NVARCHAR(50));
END
ELSE
BEGIN
    SELECT @CompanyALYAId = CompanyId FROM gov.Company WHERE Sigla = 'ALYA';
    PRINT '   ℹ ALYA Serviços já existe: ' + CAST(@CompanyALYAId AS NVARCHAR(50));
END

-- 2.2 Mobyan
IF NOT EXISTS (SELECT 1 FROM gov.Company WHERE Sigla = 'MOBYAN')
BEGIN
    INSERT INTO gov.Company (
        CompanyId,
        HoldingId,
        Nome,
        Sigla,
        CNPJ,
        Status,  -- ✓ BIT (1 = Ativo, 0 = Inativo)
        CreatedAt,
        CreatedBy,
        IsDeleted
    )
    VALUES (
        @CompanyMobyanId,
        @HoldingId,
        'Mobyan Tecnologia LTDA',
        'MOBYAN',
        '12.345.678/0002-71',  -- Substituir pelo CNPJ real
        1,  -- ✓ 1 = Ativo, 0 = Inativo
        GETUTCDATE(),
        @SystemUserId,
        0
    );
    
    PRINT '   ✓ Mobyan criada: ' + CAST(@CompanyMobyanId AS NVARCHAR(50));
END
ELSE
BEGIN
    SELECT @CompanyMobyanId = CompanyId FROM gov.Company WHERE Sigla = 'MOBYAN';
    PRINT '   ℹ Mobyan já existe: ' + CAST(@CompanyMobyanId AS NVARCHAR(50));
END

-- 2.3 TaNaPorta
IF NOT EXISTS (SELECT 1 FROM gov.Company WHERE Sigla = 'TNP')
BEGIN
    INSERT INTO gov.Company (
        CompanyId,
        HoldingId,
        Nome,
        Sigla,
        CNPJ,
        Status,  -- ✓ BIT (1 = Ativo, 0 = Inativo)
        CreatedAt,
        CreatedBy,
        IsDeleted
    )
    VALUES (
        @CompanyTaNaPortaId,
        @HoldingId,
        'TaNaPorta Delivery LTDA',
        'TNP',
        '12.345.678/0003-52',  -- Substituir pelo CNPJ real
        1,  -- ✓ 1 = Ativo, 0 = Inativo
        GETUTCDATE(),
        @SystemUserId,
        0
    );
    
    PRINT '   ✓ TaNaPorta criada: ' + CAST(@CompanyTaNaPortaId AS NVARCHAR(50));
END
ELSE
BEGIN
    SELECT @CompanyTaNaPortaId = CompanyId FROM gov.Company WHERE Sigla = 'TNP';
    PRINT '   ℹ TaNaPorta já existe: ' + CAST(@CompanyTaNaPortaId AS NVARCHAR(50));
END

PRINT '';

-- =====================================================
-- 3. CRIAR USUÁRIO ADMIN INICIAL
-- =====================================================

PRINT '3. Criando Usuário Admin...';

-- IMPORTANTE: Substitua pelo seu email real!
DECLARE @AdminEmail NVARCHAR(255) = 'alan.oliveira@alyaservicos.com.br';  -- <<<< ALTERE AQUI
DECLARE @AdminName NVARCHAR(255) = 'Alan Oliveira';  -- <<<< ALTERE AQUI

IF NOT EXISTS (SELECT 1 FROM sec.[User] WHERE Email = @AdminEmail)
BEGIN
    INSERT INTO sec.[User] (
        UserId,
        CompanyId,
        Email,
        FullName,
        IsActive,
        IsAdminDevFlow,  -- ✓ Marcado como Admin DevFlow
        CreatedAt,
        CreatedBy,
        IsDeleted
    )
    VALUES (
        @AdminUserId,
        @CompanyALYAId,  -- Vinculado à ALYA
        @AdminEmail,
        @AdminName,
        1,  -- IsActive
        1,  -- IsAdminDevFlow ✓
        GETUTCDATE(),
        @SystemUserId,
        0
    );
    
    PRINT '   ✓ Usuário Admin criado: ' + @AdminEmail;
    PRINT '   ✓ Marcado como AdminDevFlow: SIM';
    PRINT '   ✓ UserId: ' + CAST(@AdminUserId AS NVARCHAR(50));
END
ELSE
BEGIN
    -- Se já existe, apenas marcar como Admin
    UPDATE sec.[User]
    SET IsAdminDevFlow = 1,
        UpdatedAt = GETUTCDATE(),
        UpdatedBy = @SystemUserId
    WHERE Email = @AdminEmail;
    
    SELECT @AdminUserId = UserId FROM sec.[User] WHERE Email = @AdminEmail;
    
    PRINT '   ℹ Usuário já existe: ' + @AdminEmail;
    PRINT '   ✓ Marcado como AdminDevFlow: SIM';
    PRINT '   ✓ UserId: ' + CAST(@AdminUserId AS NVARCHAR(50));
END

PRINT '';

-- =====================================================
-- 4. RESUMO
-- =====================================================

PRINT '========================================';
PRINT 'RESUMO DA ESTRUTURA CRIADA';
PRINT '========================================';
PRINT '';

SELECT 
    'Holding' AS Tipo,
    Nome,
    Sigla,
    CAST(HoldingId AS NVARCHAR(50)) AS Id
FROM gov.Holding
WHERE Sigla = 'ALYA';

SELECT 
    'Empresa' AS Tipo,
    Nome,
    Sigla,
    CAST(CompanyId AS NVARCHAR(50)) AS Id
FROM gov.Company
WHERE HoldingId = @HoldingId
ORDER BY Nome;

SELECT 
    'Usuário Admin' AS Tipo,
    FullName AS Nome,
    Email,
    CASE WHEN IsAdminDevFlow = 1 THEN 'SIM' ELSE 'NÃO' END AS AdminDevFlow,
    CAST(UserId AS NVARCHAR(50)) AS Id
FROM sec.[User]
WHERE Email = @AdminEmail;

PRINT '';
PRINT '========================================';
PRINT 'IDs IMPORTANTES (COPIE PARA USAR)';
PRINT '========================================';
PRINT '';
PRINT 'Holding ALYA ID: ' + CAST(@HoldingId AS NVARCHAR(50));
PRINT 'Company ALYA ID: ' + CAST(@CompanyALYAId AS NVARCHAR(50));
PRINT 'Company Mobyan ID: ' + CAST(@CompanyMobyanId AS NVARCHAR(50));
PRINT 'Company TaNaPorta ID: ' + CAST(@CompanyTaNaPortaId AS NVARCHAR(50));
PRINT 'Admin User ID: ' + CAST(@AdminUserId AS NVARCHAR(50));
PRINT '';
PRINT '✓ Estrutura organizacional criada com sucesso!';
PRINT '✓ Usuário Admin DevFlow configurado!';
PRINT '';
PRINT 'PRÓXIMOS PASSOS:';
PRINT '1. Executar: Database\V3_1_0__EntraID_Tenants.sql';
PRINT '2. Acessar: http://localhost:5173/admin/entraid-tenants';
PRINT '3. Cadastrar configuração Entra ID da ALYA';
PRINT '';

GO
