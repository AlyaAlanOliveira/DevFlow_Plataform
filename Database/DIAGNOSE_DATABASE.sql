/*
 * DevFlow ALYA - Script de Diagnóstico
 * Verifica o estado atual das tabelas e colunas
 */

SET NOCOUNT ON;
GO

PRINT '========================================';
PRINT 'DIAGNÓSTICO DO BANCO DE DADOS';
PRINT '========================================';
PRINT '';

-- =====================================================
-- 1. VERIFICAR SCHEMAS
-- =====================================================

PRINT '1. SCHEMAS EXISTENTES:';
PRINT '';

SELECT 
    name AS Schema_Name,
    schema_id AS Schema_ID
FROM sys.schemas
WHERE name IN ('gov', 'sec', 'ref', 'cfg', 'prt', 'req', 'agl', 'ucp', 'auth', 'wfl', 'sys_cat')
ORDER BY name;

PRINT '';

-- =====================================================
-- 2. VERIFICAR TABELAS gov
-- =====================================================

PRINT '2. TABELAS DO SCHEMA gov:';
PRINT '';

SELECT 
    t.name AS Tabela,
    SUM(CASE WHEN c.name = 'Status' THEN 1 ELSE 0 END) AS Tem_Status,
    SUM(CASE WHEN c.name = 'IsActive' THEN 1 ELSE 0 END) AS Tem_IsActive,
    COUNT(c.column_id) AS Total_Colunas
FROM sys.tables t
INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
LEFT JOIN sys.columns c ON t.object_id = c.object_id
WHERE s.name = 'gov'
GROUP BY t.name
ORDER BY t.name;

PRINT '';

-- =====================================================
-- 3. ESTRUTURA DETALHADA - gov.Holding
-- =====================================================

PRINT '3. ESTRUTURA DETALHADA - gov.Holding:';
PRINT '';

IF OBJECT_ID('gov.Holding') IS NOT NULL
BEGIN
    SELECT 
        c.column_id AS Ordem,
        c.name AS Coluna,
        t.name AS Tipo,
        c.max_length AS Tamanho,
        c.precision AS Precisao,
        c.scale AS Escala,
        CASE WHEN c.is_nullable = 1 THEN 'SIM' ELSE 'NÃO' END AS Nullable,
        CASE WHEN dc.definition IS NOT NULL THEN dc.definition ELSE '' END AS [Default]
    FROM sys.columns c
    INNER JOIN sys.types t ON c.user_type_id = t.user_type_id
    LEFT JOIN sys.default_constraints dc ON c.default_object_id = dc.object_id
    WHERE c.object_id = OBJECT_ID('gov.Holding')
    ORDER BY c.column_id;
END
ELSE
BEGIN
    PRINT '   ⚠️ Tabela gov.Holding NÃO EXISTE!';
END

PRINT '';

-- =====================================================
-- 4. ESTRUTURA DETALHADA - gov.Company
-- =====================================================

PRINT '4. ESTRUTURA DETALHADA - gov.Company:';
PRINT '';

IF OBJECT_ID('gov.Company') IS NOT NULL
BEGIN
    SELECT 
        c.column_id AS Ordem,
        c.name AS Coluna,
        t.name AS Tipo,
        c.max_length AS Tamanho,
        c.precision AS Precisao,
        c.scale AS Escala,
        CASE WHEN c.is_nullable = 1 THEN 'SIM' ELSE 'NÃO' END AS Nullable,
        CASE WHEN dc.definition IS NOT NULL THEN dc.definition ELSE '' END AS [Default]
    FROM sys.columns c
    INNER JOIN sys.types t ON c.user_type_id = t.user_type_id
    LEFT JOIN sys.default_constraints dc ON c.default_object_id = dc.object_id
    WHERE c.object_id = OBJECT_ID('gov.Company')
    ORDER BY c.column_id;
END
ELSE
BEGIN
    PRINT '   ⚠️ Tabela gov.Company NÃO EXISTE!';
END

PRINT '';

-- =====================================================
-- 5. VERIFICAR CONSTRAINTS
-- =====================================================

PRINT '5. CONSTRAINTS (CHECK e DEFAULT):';
PRINT '';

-- CHECK Constraints
PRINT 'CHECK Constraints:';
SELECT 
    OBJECT_SCHEMA_NAME(parent_object_id) AS Schema_Name,
    OBJECT_NAME(parent_object_id) AS Tabela,
    name AS Constraint_Name,
    definition AS Definicao
FROM sys.check_constraints
WHERE OBJECT_SCHEMA_NAME(parent_object_id) = 'gov'
ORDER BY Tabela, name;

PRINT '';

-- DEFAULT Constraints
PRINT 'DEFAULT Constraints:';
SELECT 
    OBJECT_SCHEMA_NAME(parent_object_id) AS Schema_Name,
    OBJECT_NAME(parent_object_id) AS Tabela,
    name AS Constraint_Name,
    COL_NAME(parent_object_id, parent_column_id) AS Coluna,
    definition AS Definicao
FROM sys.default_constraints
WHERE OBJECT_SCHEMA_NAME(parent_object_id) = 'gov'
ORDER BY Tabela, Coluna;

PRINT '';

-- =====================================================
-- 6. VERIFICAR DADOS EXISTENTES
-- =====================================================

PRINT '6. DADOS EXISTENTES:';
PRINT '';

-- Holdings
IF OBJECT_ID('gov.Holding') IS NOT NULL
BEGIN
    DECLARE @HoldingCount INT;
    SELECT @HoldingCount = COUNT(*) FROM gov.Holding;
    PRINT 'gov.Holding: ' + CAST(@HoldingCount AS VARCHAR(10)) + ' registro(s)';
    
    IF @HoldingCount > 0
    BEGIN
        PRINT '';
        PRINT 'Registros em gov.Holding:';
        
        -- Verificar se tem Status ou IsActive
        IF EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID('gov.Holding') AND name = 'Status')
        BEGIN
            SELECT 
                CAST(HoldingId AS NVARCHAR(50)) AS Id,
                Nome,
                Sigla,
                Status
            FROM gov.Holding;
        END
        ELSE IF EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID('gov.Holding') AND name = 'IsActive')
        BEGIN
            SELECT 
                CAST(HoldingId AS NVARCHAR(50)) AS Id,
                Nome,
                Sigla,
                CASE WHEN IsActive = 1 THEN 'Ativo' ELSE 'Inativo' END AS Status
            FROM gov.Holding;
        END
        ELSE
        BEGIN
            SELECT 
                CAST(HoldingId AS NVARCHAR(50)) AS Id,
                Nome,
                Sigla
            FROM gov.Holding;
        END
    END
END
ELSE
BEGIN
    PRINT 'gov.Holding: Tabela não existe';
END

PRINT '';

-- Companies
IF OBJECT_ID('gov.Company') IS NOT NULL
BEGIN
    DECLARE @CompanyCount INT;
    SELECT @CompanyCount = COUNT(*) FROM gov.Company;
    PRINT 'gov.Company: ' + CAST(@CompanyCount AS VARCHAR(10)) + ' registro(s)';
    
    IF @CompanyCount > 0
    BEGIN
        PRINT '';
        PRINT 'Registros em gov.Company:';
        
        IF EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID('gov.Company') AND name = 'Status')
        BEGIN
            SELECT 
                CAST(CompanyId AS NVARCHAR(50)) AS Id,
                Nome,
                Sigla,
                CNPJ,
                Status
            FROM gov.Company;
        END
        ELSE IF EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID('gov.Company') AND name = 'IsActive')
        BEGIN
            SELECT 
                CAST(CompanyId AS NVARCHAR(50)) AS Id,
                Nome,
                Sigla,
                CNPJ,
                CASE WHEN IsActive = 1 THEN 'Ativo' ELSE 'Inativo' END AS Status
            FROM gov.Company;
        END
        ELSE
        BEGIN
            SELECT 
                CAST(CompanyId AS NVARCHAR(50)) AS Id,
                Nome,
                Sigla,
                CNPJ
            FROM gov.Company;
        END
    END
END
ELSE
BEGIN
    PRINT 'gov.Company: Tabela não existe';
END

PRINT '';

-- =====================================================
-- 7. RECOMENDAÇÕES
-- =====================================================

PRINT '========================================';
PRINT 'RECOMENDAÇÕES';
PRINT '========================================';
PRINT '';

-- Verificar se precisa executar migration
IF EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID('gov.Holding') AND name = 'Status')
BEGIN
    PRINT '⚠️  AÇÃO NECESSÁRIA:';
    PRINT '   A coluna Status ainda existe em gov.Holding';
    PRINT '   Execute: Database\V3_2_1__Fix_Status_Fields_Corrected.sql';
    PRINT '';
END
ELSE IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID('gov.Holding') AND name = 'IsActive')
BEGIN
    PRINT '⚠️  AÇÃO NECESSÁRIA:';
    PRINT '   A coluna IsActive não existe em gov.Holding';
    PRINT '   Execute: Database\V3_2_1__Fix_Status_Fields_Corrected.sql';
    PRINT '';
END
ELSE
BEGIN
    PRINT '✓ gov.Holding está OK (tem IsActive)';
    PRINT '';
END

IF EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID('gov.Company') AND name = 'Status')
BEGIN
    PRINT '⚠️  AÇÃO NECESSÁRIA:';
    PRINT '   A coluna Status ainda existe em gov.Company';
    PRINT '   Execute: Database\V3_2_1__Fix_Status_Fields_Corrected.sql';
    PRINT '';
END
ELSE IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID('gov.Company') AND name = 'IsActive')
BEGIN
    PRINT '⚠️  AÇÃO NECESSÁRIA:';
    PRINT '   A coluna IsActive não existe em gov.Company';
    PRINT '   Execute: Database\V3_2_1__Fix_Status_Fields_Corrected.sql';
    PRINT '';
END
ELSE
BEGIN
    PRINT '✓ gov.Company está OK (tem IsActive)';
    PRINT '';
END

-- Verificar DEFAULT NEWID()
IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE name = 'DF_Holding_HoldingId')
BEGIN
    PRINT '⚠️  RECOMENDAÇÃO:';
    PRINT '   DEFAULT NEWID() não configurado em gov.Holding.HoldingId';
    PRINT '   Execute: Database\V3_2_1__Fix_Status_Fields_Corrected.sql';
    PRINT '';
END
ELSE
BEGIN
    PRINT '✓ DEFAULT NEWID() configurado em gov.Holding.HoldingId';
    PRINT '';
END

PRINT '========================================';
PRINT 'FIM DO DIAGNÓSTICO';
PRINT '========================================';
PRINT '';

GO
