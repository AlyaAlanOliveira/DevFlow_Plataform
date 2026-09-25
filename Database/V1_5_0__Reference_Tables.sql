-- =============================================
-- DevFlow - Reference Tables (Tabelas de Domínio)
-- Version: 1.5.0
-- Description: Tabelas de referência e domínio configuráveis
-- =============================================

-- Priority (Prioridades)
CREATE TABLE ref.Priority (
    PriorityId UNIQUEIDENTIFIER NOT NULL PRIMARY KEY DEFAULT NEWID(),
    Code VARCHAR(20) NOT NULL UNIQUE,
    Name NVARCHAR(100) NOT NULL,
    Description NVARCHAR(500),
    SLADays INT NOT NULL,
    ColorHex VARCHAR(7),
    DisplayOrder INT NOT NULL,
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
    CONSTRAINT CK_Priority_SLADays CHECK (SLADays > 0)
);
GO

CREATE INDEX IX_Priority_Code ON ref.Priority(Code) WHERE IsDeleted = 0;
CREATE INDEX IX_Priority_DisplayOrder ON ref.Priority(DisplayOrder) WHERE IsDeleted = 0;
GO

-- DemandType (Tipos de Demanda)
CREATE TABLE ref.DemandType (
    DemandTypeId UNIQUEIDENTIFIER NOT NULL PRIMARY KEY DEFAULT NEWID(),
    Code VARCHAR(20) NOT NULL UNIQUE,
    Name NVARCHAR(100) NOT NULL,
    Description NVARCHAR(500),
    RequiresImpactAnalysis BIT NOT NULL DEFAULT 0,
    RequiresSecurityReview BIT NOT NULL DEFAULT 0,
    IsActive BIT NOT NULL DEFAULT 1,
    -- Auditoria
    CreatedAt DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
    CreatedBy UNIQUEIDENTIFIER NOT NULL,
    UpdatedAt DATETIME2,
    UpdatedBy UNIQUEIDENTIFIER,
    DeletedAt DATETIME2,
    DeletedBy UNIQUEIDENTIFIER,
    IsDeleted BIT NOT NULL DEFAULT 0,
    RowVersion ROWVERSION
);
GO

CREATE INDEX IX_DemandType_Code ON ref.DemandType(Code) WHERE IsDeleted = 0;
GO

-- WorkflowStatus (Status de Workflow por Entidade)
CREATE TABLE ref.WorkflowStatus (
    WorkflowStatusId UNIQUEIDENTIFIER NOT NULL PRIMARY KEY DEFAULT NEWID(),
    EntityType VARCHAR(50) NOT NULL,
    Code VARCHAR(30) NOT NULL,
    Name NVARCHAR(100) NOT NULL,
    Description NVARCHAR(500),
    IsFinal BIT NOT NULL DEFAULT 0,
    IsRejection BIT NOT NULL DEFAULT 0,
    DisplayOrder INT NOT NULL,
    ColorHex VARCHAR(7),
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
    CONSTRAINT UK_WorkflowStatus_EntityType_Code UNIQUE (EntityType, Code),
    CONSTRAINT CK_WorkflowStatus_EntityType CHECK (EntityType IN ('BusinessCase','Demand','Requirement','UseCase','UserStory','Estimate','Sprint','TestCase','Release','GMUD'))
);
GO

CREATE INDEX IX_WorkflowStatus_EntityType ON ref.WorkflowStatus(EntityType) WHERE IsDeleted = 0;
CREATE INDEX IX_WorkflowStatus_DisplayOrder ON ref.WorkflowStatus(EntityType, DisplayOrder) WHERE IsDeleted = 0;
GO

-- ActorComplexity (Complexidade de Atores UCP)
CREATE TABLE ref.ActorComplexity (
    ActorComplexityId UNIQUEIDENTIFIER NOT NULL PRIMARY KEY DEFAULT NEWID(),
    Code VARCHAR(20) NOT NULL UNIQUE,
    Name NVARCHAR(100) NOT NULL,
    Description NVARCHAR(500),
    WeightFactor DECIMAL(5,2) NOT NULL,
    DisplayOrder INT NOT NULL,
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
    CONSTRAINT CK_ActorComplexity_WeightFactor CHECK (WeightFactor > 0)
);
GO

CREATE INDEX IX_ActorComplexity_Code ON ref.ActorComplexity(Code) WHERE IsDeleted = 0;
GO

-- UseCaseComplexity (Complexidade de Casos de Uso UCP)
CREATE TABLE ref.UseCaseComplexity (
    UseCaseComplexityId UNIQUEIDENTIFIER NOT NULL PRIMARY KEY DEFAULT NEWID(),
    Code VARCHAR(20) NOT NULL UNIQUE,
    Name NVARCHAR(100) NOT NULL,
    Description NVARCHAR(500),
    TransactionMin INT NOT NULL,
    TransactionMax INT NOT NULL,
    WeightFactor DECIMAL(5,2) NOT NULL,
    DisplayOrder INT NOT NULL,
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
    CONSTRAINT CK_UseCaseComplexity_Transactions CHECK (TransactionMin <= TransactionMax),
    CONSTRAINT CK_UseCaseComplexity_WeightFactor CHECK (WeightFactor > 0)
);
GO

CREATE INDEX IX_UseCaseComplexity_Code ON ref.UseCaseComplexity(Code) WHERE IsDeleted = 0;
GO
