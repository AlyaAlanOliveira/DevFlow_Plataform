/*
 * DevFlow ALYA - Migration V3.2.0
 * Correção de Campos Status para BIT (Boolean)
 * 
 * Descrição:
 * - Altera campos Status de NVARCHAR para BIT (true/false)
 * - Adiciona DEFAULT NEWID() em campos UNIQUEIDENTIFIER
 * - Migra dados existentes
 * 
 * Data: 2026-09-28
 */

SET NOCOUNT ON;
GO

PRINT '========================================';
PRINT 'MIGRATION V3.2.0 - Correção de Status';
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

-- Company
IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE name = 'DF_Company_CompanyId')
BEGIN
    ALTER TABLE gov.Company
    ADD CONSTRAINT DF_Company_CompanyId DEFAULT NEWID() FOR CompanyId;
    PRINT '   ✓ DEFAULT adicionado em gov.Company.CompanyId';
END

-- Directorate
IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE name = 'DF_Directorate_DirectorateId')
BEGIN
    ALTER TABLE gov.Directorate
    ADD CONSTRAINT DF_Directorate_DirectorateId DEFAULT NEWID() FOR DirectorateId;
    PRINT '   ✓ DEFAULT adicionado em gov.Directorate.DirectorateId';
END

-- Area
IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE name = 'DF_Area_AreaId')
BEGIN
    ALTER TABLE gov.Area
    ADD CONSTRAINT DF_Area_AreaId DEFAULT NEWID() FOR AreaId;
    PRINT '   ✓ DEFAULT adicionado em gov.Area.AreaId';
END

-- Squad
IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE name = 'DF_Squad_SquadId')
BEGIN
    ALTER TABLE gov.Squad
    ADD CONSTRAINT DF_Squad_SquadId DEFAULT NEWID() FOR SquadId;
    PRINT '   ✓ DEFAULT adicionado em gov.Squad.SquadId';
END

PRINT '';

-- =====================================================
-- 2. ALTERAR CAMPO STATUS EM HOLDING
-- =====================================================

PRINT '2. Alterando campo Status em gov.Holding...';
PRINT '';

-- Verificar se a coluna existe e é NVARCHAR
IF EXISTS (
    SELECT 1 
    FROM sys.columns c
    INNER JOIN sys.types t ON c.user_type_id = t.user_type_id
    WHERE c.object_id = OBJECT_ID('gov.Holding')
    AND c.name = 'Status'
    AND t.name IN ('nvarchar', 'varchar', 'char')
)
BEGIN
    -- Criar nova coluna temporária
    ALTER TABLE gov.Holding
    ADD IsActive BIT NOT NULL DEFAULT 1;
    
    -- Migrar dados (Status = 'Active' ou 'ATIVA' → IsActive = 1)
    UPDATE gov.Holding
    SET IsActive = CASE 
        WHEN Status IN ('Active', 'ATIVA', 'Ativo', 'Ativa', '1', 'true', 'TRUE') THEN 1
        ELSE 0
    END;
    
    -- Remover coluna antiga
    ALTER TABLE gov.Holding
    DROP COLUMN Status;
    
    PRINT '   ✓ Campo Status substituído por IsActive (BIT)';
    PRINT '   ✓ Dados migrados com sucesso';
END
ELSE IF NOT EXISTS (
    SELECT 1 FROM sys.columns 
    WHERE object_id = OBJECT_ID('gov.Holding') 
    AND name = 'IsActive'
)
BEGIN
    -- Se não existe Status nem IsActive, criar IsActive
    ALTER TABLE gov.Holding
    ADD IsActive BIT NOT NULL DEFAULT 1;
    
    PRINT '   ✓ Campo IsActive (BIT) criado';
END
ELSE
BEGIN
    PRINT '   ℹ Campo IsActive já existe';
END

PRINT '';

-- =====================================================
-- 3. ALTERAR CAMPO STATUS EM COMPANY
-- =====================================================

PRINT '3. Alterando campo Status em gov.Company...';
PRINT '';

IF EXISTS (
    SELECT 1 
    FROM sys.columns c
    INNER JOIN sys.types t ON c.user_type_id = t.user_type_id
    WHERE c.object_id = OBJECT_ID('gov.Company')
    AND c.name = 'Status'
    AND t.name IN ('nvarchar', 'varchar', 'char')
)
BEGIN
    ALTER TABLE gov.Company
    ADD IsActive BIT NOT NULL DEFAULT 1;
    
    UPDATE gov.Company
    SET IsActive = CASE 
        WHEN Status IN ('Active', 'ATIVA', 'Ativo', 'Ativa', '1', 'true', 'TRUE') THEN 1
        ELSE 0
    END;
    
    ALTER TABLE gov.Company
    DROP COLUMN Status;
    
    PRINT '   ✓ Campo Status substituído por IsActive (BIT)';
    PRINT '   ✓ Dados migrados com sucesso';
END
ELSE IF NOT EXISTS (
    SELECT 1 FROM sys.columns 
    WHERE object_id = OBJECT_ID('gov.Company') 
    AND name = 'IsActive'
)
BEGIN
    ALTER TABLE gov.Company
    ADD IsActive BIT NOT NULL DEFAULT 1;
    
    PRINT '   ✓ Campo IsActive (BIT) criado';
END
ELSE
BEGIN
    PRINT '   ℹ Campo IsActive já existe';
END

PRINT '';

-- =====================================================
-- 4. ALTERAR CAMPO STATUS EM DIRECTORATE
-- =====================================================

PRINT '4. Alterando campo Status em gov.Directorate...';
PRINT '';

IF EXISTS (
    SELECT 1 
    FROM sys.columns c
    INNER JOIN sys.types t ON c.user_type_id = t.user_type_id
    WHERE c.object_id = OBJECT_ID('gov.Directorate')
    AND c.name = 'Status'
    AND t.name IN ('nvarchar', 'varchar', 'char')
)
BEGIN
    ALTER TABLE gov.Directorate
    ADD IsActive BIT NOT NULL DEFAULT 1;
    
    UPDATE gov.Directorate
    SET IsActive = CASE 
        WHEN Status IN ('Active', 'ATIVA', 'Ativo', 'Ativa', '1', 'true', 'TRUE') THEN 1
        ELSE 0
    END;
    
    ALTER TABLE gov.Directorate
    DROP COLUMN Status;
    
    PRINT '   ✓ Campo Status substituído por IsActive (BIT)';
END
ELSE IF NOT EXISTS (
    SELECT 1 FROM sys.columns 
    WHERE object_id = OBJECT_ID('gov.Directorate') 
    AND name = 'IsActive'
)
BEGIN
    ALTER TABLE gov.Directorate
    ADD IsActive BIT NOT NULL DEFAULT 1;
    
    PRINT '   ✓ Campo IsActive (BIT) criado';
END
ELSE
BEGIN
    PRINT '   ℹ Campo IsActive já existe';
END

PRINT '';

-- =====================================================
-- 5. ALTERAR CAMPO STATUS EM AREA
-- =====================================================

PRINT '5. Alterando campo Status em gov.Area...';
PRINT '';

IF EXISTS (
    SELECT 1 
    FROM sys.columns c
    INNER JOIN sys.types t ON c.user_type_id = t.user_type_id
    WHERE c.object_id = OBJECT_ID('gov.Area')
    AND c.name = 'Status'
    AND t.name IN ('nvarchar', 'varchar', 'char')
)
BEGIN
    ALTER TABLE gov.Area
    ADD IsActive BIT NOT NULL DEFAULT 1;
    
    UPDATE gov.Area
    SET IsActive = CASE 
        WHEN Status IN ('Active', 'ATIVA', 'Ativo', 'Ativa', '1', 'true', 'TRUE') THEN 1
        ELSE 0
    END;
    
    ALTER TABLE gov.Area
    DROP COLUMN Status;
    
    PRINT '   ✓ Campo Status substituído por IsActive (BIT)';
END
ELSE IF NOT EXISTS (
    SELECT 1 FROM sys.columns 
    WHERE object_id = OBJECT_ID('gov.Area') 
    AND name = 'IsActive'
)
BEGIN
    ALTER TABLE gov.Area
    ADD IsActive BIT NOT NULL DEFAULT 1;
    
    PRINT '   ✓ Campo IsActive (BIT) criado';
END
ELSE
BEGIN
    PRINT '   ℹ Campo IsActive já existe';
END

PRINT '';

-- =====================================================
-- 6. ALTERAR CAMPO STATUS EM SQUAD
-- =====================================================

PRINT '6. Alterando campo Status em gov.Squad...';
PRINT '';

IF EXISTS (
    SELECT 1 
    FROM sys.columns c
    INNER JOIN sys.types t ON c.user_type_id = t.user_type_id
    WHERE c.object_id = OBJECT_ID('gov.Squad')
    AND c.name = 'Status'
    AND t.name IN ('nvarchar', 'varchar', 'char')
)
BEGIN
    ALTER TABLE gov.Squad
    ADD IsActive BIT NOT NULL DEFAULT 1;
    
    UPDATE gov.Squad
    SET IsActive = CASE 
        WHEN Status IN ('Active', 'ATIVA', 'Ativo', 'Ativa', '1', 'true', 'TRUE') THEN 1
        ELSE 0
    END;
    
    ALTER TABLE gov.Squad
    DROP COLUMN Status;
    
    PRINT '   ✓ Campo Status substituído por IsActive (BIT)';
END
ELSE IF NOT EXISTS (
    SELECT 1 FROM sys.columns 
    WHERE object_id = OBJECT_ID('gov.Squad') 
    AND name = 'IsActive'
)
BEGIN
    ALTER TABLE gov.Squad
    ADD IsActive BIT NOT NULL DEFAULT 1;
    
    PRINT '   ✓ Campo IsActive (BIT) criado';
END
ELSE
BEGIN
    PRINT '   ℹ Campo IsActive já existe';
END

PRINT '';

-- =====================================================
-- 7. RESUMO
-- =====================================================

PRINT '========================================';
PRINT 'RESUMO DAS ALTERAÇÕES';
PRINT '========================================';
PRINT '';

SELECT 
    'gov.Holding' AS Tabela,
    c.name AS Coluna,
    t.name AS Tipo,
    c.max_length AS Tamanho,
    CASE WHEN c.is_nullable = 1 THEN 'SIM' ELSE 'NÃO' END AS Nullable
FROM sys.columns c
INNER JOIN sys.types t ON c.user_type_id = t.user_type_id
WHERE c.object_id = OBJECT_ID('gov.Holding')
AND c.name IN ('HoldingId', 'IsActive')
ORDER BY c.column_id;

PRINT '';
PRINT '========================================';
PRINT 'AGORA VOCÊ PODE INSERIR ASSIM:';
PRINT '========================================';
PRINT '';
PRINT '-- Opção 1: Sem especificar HoldingId (será gerado automaticamente)';
PRINT 'INSERT INTO gov.Holding (Nome, Sigla, IsActive)';
PRINT 'VALUES (''Transire Logistica e Serviço'', ''TLogServ'', 1);';
PRINT '';
PRINT '-- Opção 2: Especificando HoldingId';
PRINT 'INSERT INTO gov.Holding (HoldingId, Nome, Sigla, IsActive)';
PRINT 'VALUES (NEWID(), ''Transire Logistica e Serviço'', ''TLogServ'', 1);';
PRINT '';
PRINT '-- Opção 3: Omitindo IsActive (será 1 por padrão)';
PRINT 'INSERT INTO gov.Holding (Nome, Sigla)';
PRINT 'VALUES (''Transire Logistica e Serviço'', ''TLogServ'');';
PRINT '';

PRINT '✓ Migration V3.2.0 concluída com sucesso!';
PRINT '';

GO
