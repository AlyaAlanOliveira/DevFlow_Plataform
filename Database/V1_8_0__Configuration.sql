-- =============================================
-- DevFlow - Configuration (Configurações)
-- Version: 1.8.0
-- Description: Tabelas de configuração (Operações, UCP, etc.)
-- =============================================

-- Operation (Operações/Plataformas/Contratantes)
CREATE TABLE cfg.Operation (
    OperationId UNIQUEIDENTIFIER NOT NULL PRIMARY KEY DEFAULT NEWID(),
    Code VARCHAR(20) NOT NULL UNIQUE,
    Name NVARCHAR(200) NOT NULL,
    Description NVARCHAR(1000),
    CompanyId UNIQUEIDENTIFIER NOT NULL,
    ClientType VARCHAR(30) NOT NULL,
    IsActive BIT NOT NULL DEFAULT 1,
    -- Auditoria
    CreatedAt DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
    CreatedBy UNIQUEIDENTIFIER NOT NULL,
    UpdatedAt DATETIME2,
    UpdatedBy UNIQUEIDENTIFIER,
    DeletedAt DATETIME2,
    DeletedBy UNIQUEIDENTIFIER,
    IsDeleted BIT NOT NULL DEFAULT 0,
    RowVersion ROWVERSION,
    CONSTRAINT FK_Operation_Company FOREIGN KEY (CompanyId) REFERENCES gov.Company(CompanyId),
    CONSTRAINT CK_Operation_ClientType CHECK (ClientType IN ('Internal','External','Partner'))
);
GO

CREATE INDEX IX_Operation_CompanyId ON cfg.Operation(CompanyId) WHERE IsDeleted = 0;
CREATE INDEX IX_Operation_Code ON cfg.Operation(Code) WHERE IsDeleted = 0;
CREATE INDEX IX_Operation_ClientType ON cfg.Operation(ClientType) WHERE IsDeleted = 0;
GO

-- UCPConfiguration (Configuração de Horas/UCP)
CREATE TABLE cfg.UCPConfiguration (
    UCPConfigurationId UNIQUEIDENTIFIER NOT NULL PRIMARY KEY DEFAULT NEWID(),
    Name NVARCHAR(200) NOT NULL,
    Description NVARCHAR(1000),
    HoursPerUCP DECIMAL(5,2) NOT NULL,
    DevelopmentPercentage DECIMAL(5,2) NOT NULL DEFAULT 60.00,
    TestPercentage DECIMAL(5,2) NOT NULL DEFAULT 20.00,
    HomologationPercentage DECIMAL(5,2) NOT NULL DEFAULT 20.00,
    HourlyRate DECIMAL(10,2),
    EffectiveFrom DATE NOT NULL,
    EffectiveTo DATE,
    IsActive BIT NOT NULL DEFAULT 1,
    -- Auditoria
    CreatedAt DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
    CreatedBy UNIQUEIDENTIFIER NOT NULL,
    UpdatedAt DATETIME2,
    UpdatedBy UNIQUEIDENTIFIER,
    DeletedAt DATETIME2,
    DeletedBy UNIQUEIDENTIFIER,
    IsDeleted BIT NOT NULL DEFAULT 0,
    RowVersion ROWVERSION,
    CONSTRAINT CK_UCPConfiguration_HoursPerUCP CHECK (HoursPerUCP > 0),
    CONSTRAINT CK_UCPConfiguration_DevelopmentPercentage CHECK (DevelopmentPercentage BETWEEN 0 AND 100),
    CONSTRAINT CK_UCPConfiguration_TestPercentage CHECK (TestPercentage BETWEEN 0 AND 100),
    CONSTRAINT CK_UCPConfiguration_HomologationPercentage CHECK (HomologationPercentage BETWEEN 0 AND 100),
    CONSTRAINT CK_UCPConfiguration_TotalPercentage CHECK (DevelopmentPercentage + TestPercentage + HomologationPercentage = 100),
    CONSTRAINT CK_UCPConfiguration_Dates CHECK (EffectiveTo IS NULL OR EffectiveTo >= EffectiveFrom)
);
GO

CREATE INDEX IX_UCPConfiguration_EffectiveFrom ON cfg.UCPConfiguration(EffectiveFrom) WHERE IsDeleted = 0;
CREATE INDEX IX_UCPConfiguration_Active ON cfg.UCPConfiguration(IsActive, EffectiveFrom, EffectiveTo) WHERE IsDeleted = 0;
GO

-- ApplicationSettings (Configurações Gerais da Aplicação)
CREATE TABLE cfg.ApplicationSettings (
    ApplicationSettingId UNIQUEIDENTIFIER NOT NULL PRIMARY KEY DEFAULT NEWID(),
    SettingKey VARCHAR(100) NOT NULL UNIQUE,
    SettingValue NVARCHAR(MAX) NOT NULL,
    DataType VARCHAR(20) NOT NULL,
    Description NVARCHAR(500),
    IsEncrypted BIT NOT NULL DEFAULT 0,
    IsActive BIT NOT NULL DEFAULT 1,
    -- Auditoria
    CreatedAt DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
    CreatedBy UNIQUEIDENTIFIER NOT NULL,
    UpdatedAt DATETIME2,
    UpdatedBy UNIQUEIDENTIFIER,
    DeletedAt DATETIME2,
    DeletedBy UNIQUEIDENTIFIER,
    IsDeleted BIT NOT NULL DEFAULT 0,
    RowVersion ROWVERSION,
    CONSTRAINT CK_ApplicationSettings_DataType CHECK (DataType IN ('String','Integer','Decimal','Boolean','JSON','DateTime'))
);
GO

CREATE INDEX IX_ApplicationSettings_SettingKey ON cfg.ApplicationSettings(SettingKey) WHERE IsDeleted = 0;
GO
