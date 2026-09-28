/*
 * DevFlow ALYA - Migration V3.2.2
 * Alterar Status de VARCHAR para BIT (Boolean)
 * 
 * Descrição:
 * - Mantém o nome da coluna "Status"
 * - Altera apenas o tipo: VARCHAR → BIT
 * - Define DEFAULT 1 (ativo por padrão)
 * - Adiciona DEFAULT NEWID() em campos UNIQUEIDENTIFIER
 * 
 * Data: 2026-09-28
 */

SET NOCOUNT ON;
GO

PRINT '========================================';
PRINT 'MIGRATION V3.2.2 - Status → BIT';
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
-- 2. ALTERAR Status EM gov.Holding
-- =====================================================

PRINT '2. Alterando Status em gov.Holding (VARCHAR → BIT)...';
PRINT '';

-- Verificar se Status existe e é VARCHAR
IF EXISTS (
    SELECT 1 
    FROM sys.columns c
    INNER JOIN sys.types t ON c.user_type_id = t.user_type_id
    WHERE c.object_id = OBJECT_ID('gov.Holding')
    AND c.name = 'Status'
    AND t.name IN ('varchar', 'nvarchar', 'char', 'nchar')
)
BEGIN
    PRINT '   ℹ Coluna Status (VARCHAR) encontrada, convertendo para BIT...';
    
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
    
    -- Criar coluna temporária
    ALTER TABLE gov.Holding
    ADD Status_New BIT NOT NULL DEFAULT 1;
    PRINT '   ✓ Coluna temporária Status_New criada';
    
    -- Migrar dados
    UPDATE gov.Holding
    SET Status_New = CASE 
        WHEN Status IN ('Active', 'ATIVA', 'Ativo', 'Ativa', '1', 'true', 'TRUE', 'Yes', 'Sim') THEN 1
        WHEN Status IN ('Inactive', 'INATIVA', 'Inativo', 'Inativa', '0', 'false', 'FALSE', 'No', 'Não') THEN 0
        ELSE 1  -- Default para ativo se não reconhecer
    END;
    PRINT '   ✓ Dados migrados (Active/ATIVA → 1, Inactive/INATIVA → 0)';
    
    -- Remover coluna antiga
    ALTER TABLE gov.Holding
    DROP COLUMN Status;
    PRINT '   ✓ Coluna Status (VARCHAR) removida';
    
    -- Renomear coluna nova
    EXEC sp_rename 'gov.Holding.Status_New', 'Status', 'COLUMN';
    PRINT '   ✓ Coluna Status_New renomeada para Status';
    
    PRINT '   ✅ Status agora é BIT com DEFAULT 1';
END
ELSE IF EXISTS (
    SELECT 1 
    FROM sys.columns c
    INNER JOIN sys.types t ON c.user_type_id = t.user_type_id
    WHERE c.object_id = OBJECT_ID('gov.Holding')
    AND c.name = 'Status'
    AND t.name = 'bit'
)
BEGIN
    PRINT '   ℹ Status já é BIT';
    
    -- Verificar se tem DEFAULT
    IF NOT EXISTS (
        SELECT 1 
        FROM sys.default_constraints dc
        INNER JOIN sys.columns c ON dc.parent_object_id = c.object_id AND dc.parent_column_id = c.column_id
        WHERE c.object_id = OBJECT_ID('gov.Holding')
        AND c.name = 'Status'
    )
    BEGIN
        ALTER TABLE gov.Holding
        ADD CONSTRAINT DF_Holding_Status DEFAULT 1 FOR Status;
        PRINT '   ✓ DEFAULT 1 adicionado em Status';
    END
    ELSE
    BEGIN
        PRINT '   ℹ DEFAULT já existe em Status';
    END
END
ELSE
BEGIN
    -- Status não existe, criar como BIT
    ALTER TABLE gov.Holding
    ADD Status BIT NOT NULL DEFAULT 1;
    PRINT '   ✓ Coluna Status (BIT) criada com DEFAULT 1';
END

PRINT '';

-- =====================================================
-- 3. ALTERAR Status EM gov.Company
-- =====================================================

PRINT '3. Alterando Status em gov.Company (VARCHAR → BIT)...';
PRINT '';

IF EXISTS (
    SELECT 1 
    FROM sys.columns c
    INNER JOIN sys.types t ON c.user_type_id = t.user_type_id
    WHERE c.object_id = OBJECT_ID('gov.Company')
    AND c.name = 'Status'
    AND t.name IN ('varchar', 'nvarchar', 'char', 'nchar')
)
BEGIN
    PRINT '   ℹ Coluna Status (VARCHAR) encontrada, convertendo para BIT...';
    
    -- Remover constraint CHECK
    SELECT @ConstraintName = name
    FROM sys.check_constraints
    WHERE parent_object_id = OBJECT_ID('gov.Company')
    AND definition LIKE '%Status%';
    
    IF @ConstraintName IS NOT NULL
    BEGIN
        EXEC('ALTER TABLE gov.Company DROP CONSTRAINT ' + @ConstraintName);
        PRINT '   ✓ Constraint CHECK removida: ' + @ConstraintName;
    END
    
    -- Criar coluna temporária
    ALTER TABLE gov.Company
    ADD Status_New BIT NOT NULL DEFAULT 1;
    PRINT '   ✓ Coluna temporária Status_New criada';
    
    -- Migrar dados
    UPDATE gov.Company
    SET Status_New = CASE 
        WHEN Status IN ('Active', 'ATIVA', 'Ativo', 'Ativa', '1', 'true', 'TRUE', 'Yes', 'Sim') THEN 1
        WHEN Status IN ('Inactive', 'INATIVA', 'Inativo', 'Inativa', '0', 'false', 'FALSE', 'No', 'Não') THEN 0
        ELSE 1
    END;
    PRINT '   ✓ Dados migrados (Active/ATIVA → 1, Inactive/INATIVA → 0)';
    
    -- Remover coluna antiga
    ALTER TABLE gov.Company
    DROP COLUMN Status;
    PRINT '   ✓ Coluna Status (VARCHAR) removida';
    
    -- Renomear coluna nova
    EXEC sp_rename 'gov.Company.Status_New', 'Status', 'COLUMN';
    PRINT '   ✓ Coluna Status_New renomeada para Status';
    
    PRINT '   ✅ Status agora é BIT com DEFAULT 1';
END
ELSE IF EXISTS (
    SELECT 1 
    FROM sys.columns c
    INNER JOIN sys.types t ON c.user_type_id = t.user_type_id
    WHERE c.object_id = OBJECT_ID('gov.Company')
    AND c.name = 'Status'
    AND t.name = 'bit'
)
BEGIN
    PRINT '   ℹ Status já é BIT';
    
    IF NOT EXISTS (
        SELECT 1 
        FROM sys.default_constraints dc
        INNER JOIN sys.columns c ON dc.parent_object_id = c.object_id AND dc.parent_column_id = c.column_id
        WHERE c.object_id = OBJECT_ID('gov.Company')
        AND c.name = 'Status'
    )
    BEGIN
        ALTER TABLE gov.Company
        ADD CONSTRAINT DF_Company_Status DEFAULT 1 FOR Status;
        PRINT '   ✓ DEFAULT 1 adicionado em Status';
    END
    ELSE
    BEGIN
        PRINT '   ℹ DEFAULT já existe em Status';
    END
END
ELSE
BEGIN
    ALTER TABLE gov.Company
    ADD Status BIT NOT NULL DEFAULT 1;
    PRINT '   ✓ Coluna Status (BIT) criada com DEFAULT 1';
END

PRINT '';

-- =====================================================
-- 4. VERIFICAR ESTRUTURA FINAL
-- =====================================================

PRINT '========================================';
PRINT 'ESTRUTURA FINAL';
PRINT '========================================';
PRINT '';

PRINT 'gov.Holding:';
SELECT 
    c.column_id AS Ordem,
    c.name AS Coluna,
    t.name AS Tipo,
    CASE WHEN c.is_nullable = 1 THEN 'SIM' ELSE 'NÃO' END AS Nullable,
    CASE WHEN dc.definition IS NOT NULL THEN dc.definition ELSE '' END AS [Default]
FROM sys.columns c
INNER JOIN sys.types t ON c.user_type_id = t.user_type_id
LEFT JOIN sys.default_constraints dc ON c.default_object_id = dc.object_id
WHERE c.object_id = OBJECT_ID('gov.Holding')
AND c.name IN ('HoldingId', 'Nome', 'Sigla', 'Status')
ORDER BY c.column_id;

PRINT '';

PRINT 'gov.Company:';
SELECT 
    c.column_id AS Ordem,
    c.name AS Coluna,
    t.name AS Tipo,
    CASE WHEN c.is_nullable = 1 THEN 'SIM' ELSE 'NÃO' END AS Nullable,
    CASE WHEN dc.definition IS NOT NULL THEN dc.definition ELSE '' END AS [Default]
FROM sys.columns c
INNER JOIN sys.types t ON c.user_type_id = t.user_type_id
LEFT JOIN sys.default_constraints dc ON c.default_object_id = dc.object_id
WHERE c.object_id = OBJECT_ID('gov.Company')
AND c.name IN ('CompanyId', 'Nome', 'Sigla', 'CNPJ', 'Status')
ORDER BY c.column_id;

PRINT '';
PRINT '========================================';
PRINT 'EXEMPLOS DE USO';
PRINT '========================================';
PRINT '';
PRINT '-- Inserir Holding (forma simples - Status = 1 por padrão)';
PRINT 'INSERT INTO gov.Holding (Nome, Sigla)';
PRINT 'VALUES (''Transire Logistica e Serviço'', ''TLogServ'');';
PRINT '';
PRINT '-- Inserir Holding (especificando Status)';
PRINT 'INSERT INTO gov.Holding (Nome, Sigla, Status)';
PRINT 'VALUES (''Transire Logistica e Serviço'', ''TLogServ'', 1);';
PRINT '-- Status: 1 = Ativo, 0 = Inativo';
PRINT '';
PRINT '-- Consultar Holdings';
PRINT 'SELECT ';
PRINT '    Nome,';
PRINT '    Sigla,';
PRINT '    CASE WHEN Status = 1 THEN ''Ativo'' ELSE ''Inativo'' END AS StatusTexto';
PRINT 'FROM gov.Holding;';
PRINT '';

PRINT '✓ Migration V3.2.2 concluída com sucesso!';
PRINT '✓ Status agora é BIT (Boolean) com DEFAULT 1';
PRINT '';

GO
