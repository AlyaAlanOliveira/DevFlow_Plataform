/*
 * DevFlow ALYA - Migration V3.2.1
 * Correção de Campos Status para BIT (Boolean) - VERSÃO CORRIGIDA
 * 
 * Descrição:
 * - Altera campos Status de VARCHAR/NVARCHAR para BIT (true/false)
 * - Adiciona DEFAULT NEWID() em campos UNIQUEIDENTIFIER
 * - Migra dados existentes
 * - Versão corrigida com verificações mais robustas
 * 
 * Data: 2026-09-28
 */

SET NOCOUNT ON;
GO

PRINT '========================================';
PRINT 'MIGRATION V3.2.1 - Correção de Status';
PRINT '========================================';
PRINT '';

-- =====================================================
-- 1. ADICIONAR DEFAULT NEWID() EM UNIQUEIDENTIFIER
-- =====================================================

PRINT '1. Adicionando DEFAULT NEWID() em campos ID...';
PRINT '';

-- Holding
IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE name = 'DF_Holding_HoldingId')
BEGIN
    ALTER TABLE gov.Holding
    ADD CONSTRAINT DF_Holding_HoldingId DEFAULT NEWID() FOR HoldingId;
    PRINT '   ✓ DEFAULT adicionado em gov.Holding.HoldingId';
END
ELSE
BEGIN
    PRINT '   ℹ DEFAULT já existe em gov.Holding.HoldingId';
END

-- Company
IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE name = 'DF_Company_CompanyId')
BEGIN
    ALTER TABLE gov.Company
    ADD CONSTRAINT DF_Company_CompanyId DEFAULT NEWID() FOR CompanyId;
    PRINT '   ✓ DEFAULT adicionado em gov.Company.CompanyId';
END
ELSE
BEGIN
    PRINT '   ℹ DEFAULT já existe em gov.Company.CompanyId';
END

PRINT '';

-- =====================================================
-- 2. CORRIGIR gov.Holding
-- =====================================================

PRINT '2. Corrigindo gov.Holding...';
PRINT '';

-- Verificar se Status existe
IF EXISTS (
    SELECT 1 FROM sys.columns 
    WHERE object_id = OBJECT_ID('gov.Holding') 
    AND name = 'Status'
)
BEGIN
    PRINT '   ℹ Coluna Status encontrada, iniciando conversão...';
    
    -- Remover constraint CHECK se existir
    DECLARE @ConstraintName NVARCHAR(200);
    SELECT @ConstraintName = name
    FROM sys.check_constraints
    WHERE parent_object_id = OBJECT_ID('gov.Holding')
    AND definition LIKE '%Status%';
    
    IF @ConstraintName IS NOT NULL
    BEGIN
        EXEC('ALTER TABLE gov.Holding DROP CONSTRAINT ' + @ConstraintName);
        PRINT '   ✓ Constraint CHECK removida: ' + @ConstraintName;
    END
    
    -- Adicionar nova coluna IsActive
    ALTER TABLE gov.Holding
    ADD IsActive BIT NOT NULL DEFAULT 1;
    PRINT '   ✓ Coluna IsActive criada';
    
    -- Migrar dados
    UPDATE gov.Holding
    SET IsActive = CASE 
        WHEN Status IN ('Active', 'ATIVA', 'Ativo', 'Ativa', '1', 'true', 'TRUE') THEN 1
        ELSE 0
    END;
    PRINT '   ✓ Dados migrados de Status para IsActive';
    
    -- Remover coluna antiga
    ALTER TABLE gov.Holding
    DROP COLUMN Status;
    PRINT '   ✓ Coluna Status removida';
END
ELSE IF NOT EXISTS (
    SELECT 1 FROM sys.columns 
    WHERE object_id = OBJECT_ID('gov.Holding') 
    AND name = 'IsActive'
)
BEGIN
    -- Se não existe nem Status nem IsActive, criar IsActive
    ALTER TABLE gov.Holding
    ADD IsActive BIT NOT NULL DEFAULT 1;
    PRINT '   ✓ Coluna IsActive criada (Status não existia)';
END
ELSE
BEGIN
    PRINT '   ℹ Coluna IsActive já existe';
END

PRINT '';

-- =====================================================
-- 3. CORRIGIR gov.Company
-- =====================================================

PRINT '3. Corrigindo gov.Company...';
PRINT '';

IF EXISTS (
    SELECT 1 FROM sys.columns 
    WHERE object_id = OBJECT_ID('gov.Company') 
    AND name = 'Status'
)
BEGIN
    PRINT '   ℹ Coluna Status encontrada, iniciando conversão...';
    
    -- Remover constraint CHECK se existir
    SELECT @ConstraintName = name
    FROM sys.check_constraints
    WHERE parent_object_id = OBJECT_ID('gov.Company')
    AND definition LIKE '%Status%';
    
    IF @ConstraintName IS NOT NULL
    BEGIN
        EXEC('ALTER TABLE gov.Company DROP CONSTRAINT ' + @ConstraintName);
        PRINT '   ✓ Constraint CHECK removida: ' + @ConstraintName;
    END
    
    ALTER TABLE gov.Company
    ADD IsActive BIT NOT NULL DEFAULT 1;
    PRINT '   ✓ Coluna IsActive criada';
    
    UPDATE gov.Company
    SET IsActive = CASE 
        WHEN Status IN ('Active', 'ATIVA', 'Ativo', 'Ativa', '1', 'true', 'TRUE') THEN 1
        ELSE 0
    END;
    PRINT '   ✓ Dados migrados de Status para IsActive';
    
    ALTER TABLE gov.Company
    DROP COLUMN Status;
    PRINT '   ✓ Coluna Status removida';
END
ELSE IF NOT EXISTS (
    SELECT 1 FROM sys.columns 
    WHERE object_id = OBJECT_ID('gov.Company') 
    AND name = 'IsActive'
)
BEGIN
    ALTER TABLE gov.Company
    ADD IsActive BIT NOT NULL DEFAULT 1;
    PRINT '   ✓ Coluna IsActive criada (Status não existia)';
END
ELSE
BEGIN
    PRINT '   ℹ Coluna IsActive já existe';
END

PRINT '';

-- =====================================================
-- 4. VERIFICAR ESTRUTURA FINAL
-- =====================================================

PRINT '========================================';
PRINT 'ESTRUTURA FINAL';
PRINT '========================================';
PRINT '';

-- Holding
PRINT 'gov.Holding:';
SELECT 
    c.name AS Coluna,
    t.name AS Tipo,
    c.max_length AS Tamanho,
    CASE WHEN c.is_nullable = 1 THEN 'SIM' ELSE 'NÃO' END AS Nullable,
    CASE WHEN dc.definition IS NOT NULL THEN dc.definition ELSE '' END AS [Default]
FROM sys.columns c
INNER JOIN sys.types t ON c.user_type_id = t.user_type_id
LEFT JOIN sys.default_constraints dc ON c.default_object_id = dc.object_id
WHERE c.object_id = OBJECT_ID('gov.Holding')
AND c.name IN ('HoldingId', 'Nome', 'Sigla', 'Status', 'IsActive')
ORDER BY c.column_id;

PRINT '';

-- Company
PRINT 'gov.Company:';
SELECT 
    c.name AS Coluna,
    t.name AS Tipo,
    c.max_length AS Tamanho,
    CASE WHEN c.is_nullable = 1 THEN 'SIM' ELSE 'NÃO' END AS Nullable,
    CASE WHEN dc.definition IS NOT NULL THEN dc.definition ELSE '' END AS [Default]
FROM sys.columns c
INNER JOIN sys.types t ON c.user_type_id = t.user_type_id
LEFT JOIN sys.default_constraints dc ON c.default_object_id = dc.object_id
WHERE c.object_id = OBJECT_ID('gov.Company')
AND c.name IN ('CompanyId', 'Nome', 'Sigla', 'CNPJ', 'Status', 'IsActive')
ORDER BY c.column_id;

PRINT '';
PRINT '========================================';
PRINT 'EXEMPLOS DE USO';
PRINT '========================================';
PRINT '';
PRINT '-- Inserir Holding (forma simples)';
PRINT 'INSERT INTO gov.Holding (Nome, Sigla, IsActive)';
PRINT 'VALUES (''Transire Logistica e Serviço'', ''TLogServ'', 1);';
PRINT '';
PRINT '-- Inserir Holding (ainda mais simples - IsActive = 1 por padrão)';
PRINT 'INSERT INTO gov.Holding (Nome, Sigla)';
PRINT 'VALUES (''Transire Logistica e Serviço'', ''TLogServ'');';
PRINT '';
PRINT '-- Inserir Company';
PRINT 'DECLARE @HoldingId UNIQUEIDENTIFIER;';
PRINT 'SELECT @HoldingId = HoldingId FROM gov.Holding WHERE Sigla = ''TLogServ'';';
PRINT '';
PRINT 'INSERT INTO gov.Company (HoldingId, Nome, Sigla, CNPJ, IsActive)';
PRINT 'VALUES (@HoldingId, ''Transire LTDA'', ''TLOG'', ''12345678000190'', 1);';
PRINT '';

PRINT '✓ Migration V3.2.1 concluída com sucesso!';
PRINT '';

GO
