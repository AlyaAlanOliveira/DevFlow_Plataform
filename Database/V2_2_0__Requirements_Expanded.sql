-- =============================================
-- DevFlow - Requirements Expanded (Requisitos Expandidos)
-- Version: 2.2.0
-- Description: Casos de Uso, Atores e relacionamentos
-- =============================================

-- UseCase (Casos de Uso)
CREATE TABLE req.UseCase (
    UseCaseId UNIQUEIDENTIFIER NOT NULL PRIMARY KEY DEFAULT NEWID(),
    RequirementId UNIQUEIDENTIFIER NOT NULL,
    Code VARCHAR(30) NOT NULL UNIQUE,
    Title NVARCHAR(300) NOT NULL,
    Description NVARCHAR(MAX),
    Preconditions NVARCHAR(MAX),
    Postconditions NVARCHAR(MAX),
    MainFlow NVARCHAR(MAX),
    AlternativeFlows NVARCHAR(MAX),
    ExceptionFlows NVARCHAR(MAX),
    ComplexityId UNIQUEIDENTIFIER,
    Status VARCHAR(30) NOT NULL DEFAULT 'Draft',
    -- Auditoria
    CreatedAt DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
    CreatedBy UNIQUEIDENTIFIER NOT NULL,
    UpdatedAt DATETIME2,
    UpdatedBy UNIQUEIDENTIFIER,
    DeletedAt DATETIME2,
    DeletedBy UNIQUEIDENTIFIER,
    IsDeleted BIT NOT NULL DEFAULT 0,
    RowVersion ROWVERSION,
    CONSTRAINT FK_UseCase_Requirement FOREIGN KEY (RequirementId) REFERENCES req.Requirement(RequirementId),
    CONSTRAINT FK_UseCase_Complexity FOREIGN KEY (ComplexityId) REFERENCES ref.UseCaseComplexity(UseCaseComplexityId),
    CONSTRAINT CK_UseCase_Status CHECK (Status IN ('Draft','InReview','Approved','Rejected','Obsolete'))
);
GO

CREATE INDEX IX_UseCase_RequirementId ON req.UseCase(RequirementId) WHERE IsDeleted = 0;
CREATE INDEX IX_UseCase_Code ON req.UseCase(Code) WHERE IsDeleted = 0;
CREATE INDEX IX_UseCase_ComplexityId ON req.UseCase(ComplexityId) WHERE IsDeleted = 0;
CREATE INDEX IX_UseCase_Status ON req.UseCase(Status) WHERE IsDeleted = 0;
GO

-- Actor (Atores)
CREATE TABLE req.Actor (
    ActorId UNIQUEIDENTIFIER NOT NULL PRIMARY KEY DEFAULT NEWID(),
    DemandId UNIQUEIDENTIFIER NOT NULL,
    Name NVARCHAR(200) NOT NULL,
    Description NVARCHAR(1000),
    ComplexityId UNIQUEIDENTIFIER,
    -- Auditoria
    CreatedAt DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
    CreatedBy UNIQUEIDENTIFIER NOT NULL,
    UpdatedAt DATETIME2,
    UpdatedBy UNIQUEIDENTIFIER,
    DeletedAt DATETIME2,
    DeletedBy UNIQUEIDENTIFIER,
    IsDeleted BIT NOT NULL DEFAULT 0,
    RowVersion ROWVERSION,
    CONSTRAINT FK_Actor_Demand FOREIGN KEY (DemandId) REFERENCES portfolio.Demand(DemandId),
    CONSTRAINT FK_Actor_Complexity FOREIGN KEY (ComplexityId) REFERENCES ref.ActorComplexity(ActorComplexityId)
);
GO

CREATE INDEX IX_Actor_DemandId ON req.Actor(DemandId) WHERE IsDeleted = 0;
CREATE INDEX IX_Actor_ComplexityId ON req.Actor(ComplexityId) WHERE IsDeleted = 0;
GO

-- UseCaseActor (Relacionamento Casos de Uso x Atores)
CREATE TABLE req.UseCaseActor (
    UseCaseActorId UNIQUEIDENTIFIER NOT NULL PRIMARY KEY DEFAULT NEWID(),
    UseCaseId UNIQUEIDENTIFIER NOT NULL,
    ActorId UNIQUEIDENTIFIER NOT NULL,
    InteractionType VARCHAR(30) DEFAULT 'Primary',
    -- Auditoria
    CreatedAt DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
    CreatedBy UNIQUEIDENTIFIER NOT NULL,
    IsDeleted BIT NOT NULL DEFAULT 0,
    CONSTRAINT FK_UseCaseActor_UseCase FOREIGN KEY (UseCaseId) REFERENCES req.UseCase(UseCaseId),
    CONSTRAINT FK_UseCaseActor_Actor FOREIGN KEY (ActorId) REFERENCES req.Actor(ActorId),
    CONSTRAINT UK_UseCaseActor UNIQUE (UseCaseId, ActorId),
    CONSTRAINT CK_UseCaseActor_InteractionType CHECK (InteractionType IN ('Primary','Secondary','System'))
);
GO

CREATE INDEX IX_UseCaseActor_UseCaseId ON req.UseCaseActor(UseCaseId) WHERE IsDeleted = 0;
CREATE INDEX IX_UseCaseActor_ActorId ON req.UseCaseActor(ActorId) WHERE IsDeleted = 0;
GO

-- RequirementDependency (Dependências entre Requisitos)
CREATE TABLE req.RequirementDependency (
    RequirementDependencyId UNIQUEIDENTIFIER NOT NULL PRIMARY KEY DEFAULT NEWID(),
    SourceRequirementId UNIQUEIDENTIFIER NOT NULL,
    TargetRequirementId UNIQUEIDENTIFIER NOT NULL,
    DependencyType VARCHAR(30) NOT NULL,
    Description NVARCHAR(1000),
    -- Auditoria
    CreatedAt DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
    CreatedBy UNIQUEIDENTIFIER NOT NULL,
    IsDeleted BIT NOT NULL DEFAULT 0,
    CONSTRAINT FK_RequirementDependency_Source FOREIGN KEY (SourceRequirementId) REFERENCES req.Requirement(RequirementId),
    CONSTRAINT FK_RequirementDependency_Target FOREIGN KEY (TargetRequirementId) REFERENCES req.Requirement(RequirementId),
    CONSTRAINT CK_RequirementDependency_Type CHECK (DependencyType IN ('DependsOn','Blocks','RelatedTo','Conflicts')),
    CONSTRAINT CK_RequirementDependency_NotSelf CHECK (SourceRequirementId <> TargetRequirementId)
);
GO

CREATE INDEX IX_RequirementDependency_SourceRequirementId ON req.RequirementDependency(SourceRequirementId) WHERE IsDeleted = 0;
CREATE INDEX IX_RequirementDependency_TargetRequirementId ON req.RequirementDependency(TargetRequirementId) WHERE IsDeleted = 0;
GO
