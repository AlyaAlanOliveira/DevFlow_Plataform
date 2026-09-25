-- =============================================
-- DevFlow - UCP (Use Case Points - Estimativas)
-- Version: 2.4.0
-- Description: Sistema completo de estimativas UCP
-- =============================================

-- Estimate (Estimativas UCP)
CREATE TABLE ucp.Estimate (
    EstimateId UNIQUEIDENTIFIER NOT NULL PRIMARY KEY DEFAULT NEWID(),
    DemandId UNIQUEIDENTIFIER NOT NULL,
    Code VARCHAR(30) NOT NULL UNIQUE,
    UCPConfigurationId UNIQUEIDENTIFIER NOT NULL,
    SquadId UNIQUEIDENTIFIER NOT NULL,
    -- Cálculos UCP
    UAW DECIMAL(10,2) NOT NULL DEFAULT 0,
    UUCW DECIMAL(10,2) NOT NULL DEFAULT 0,
    UUCP DECIMAL(10,2) NOT NULL DEFAULT 0,
    TCF DECIMAL(5,2) NOT NULL DEFAULT 1.00,
    EF DECIMAL(5,2) NOT NULL DEFAULT 1.00,
    UCP DECIMAL(10,2) NOT NULL DEFAULT 0,
    -- Esforço
    TotalHours DECIMAL(10,2) NOT NULL DEFAULT 0,
    DevelopmentHours DECIMAL(10,2) NOT NULL DEFAULT 0,
    TestHours DECIMAL(10,2) NOT NULL DEFAULT 0,
    HomologationHours DECIMAL(10,2) NOT NULL DEFAULT 0,
    -- Custo e Prazo
    EstimatedCost DECIMAL(18,2),
    MaxSimultaneousResources INT NOT NULL DEFAULT 1,
    EstimatedDays INT,
    -- Aprovação
    Status VARCHAR(30) NOT NULL DEFAULT 'Draft',
    EstimatedByUserId UNIQUEIDENTIFIER NOT NULL,
    EstimatedDate DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
    ApprovedByUserId UNIQUEIDENTIFIER,
    ApprovedDate DATETIME2,
    RejectedByUserId UNIQUEIDENTIFIER,
    RejectedDate DATETIME2,
    RejectionReason NVARCHAR(MAX),
    -- Auditoria
    CreatedAt DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
    CreatedBy UNIQUEIDENTIFIER NOT NULL,
    UpdatedAt DATETIME2,
    UpdatedBy UNIQUEIDENTIFIER,
    DeletedAt DATETIME2,
    DeletedBy UNIQUEIDENTIFIER,
    IsDeleted BIT NOT NULL DEFAULT 0,
    RowVersion ROWVERSION,
    CONSTRAINT FK_Estimate_Demand FOREIGN KEY (DemandId) REFERENCES portfolio.Demand(DemandId),
    CONSTRAINT FK_Estimate_UCPConfig FOREIGN KEY (UCPConfigurationId) REFERENCES cfg.UCPConfiguration(UCPConfigurationId),
    CONSTRAINT FK_Estimate_Squad FOREIGN KEY (SquadId) REFERENCES gov.Squad(SquadId),
    CONSTRAINT FK_Estimate_EstimatedBy FOREIGN KEY (EstimatedByUserId) REFERENCES sec.[User](UserId),
    CONSTRAINT FK_Estimate_ApprovedBy FOREIGN KEY (ApprovedByUserId) REFERENCES sec.[User](UserId),
    CONSTRAINT FK_Estimate_RejectedBy FOREIGN KEY (RejectedByUserId) REFERENCES sec.[User](UserId),
    CONSTRAINT CK_Estimate_Status CHECK (Status IN ('Draft','InReview','Approved','Rejected')),
    CONSTRAINT CK_Estimate_MaxResources CHECK (MaxSimultaneousResources > 0),
    CONSTRAINT CK_Estimate_ApprovalDates CHECK (ApprovedDate IS NULL OR RejectedDate IS NULL)
);
GO

CREATE INDEX IX_Estimate_DemandId ON ucp.Estimate(DemandId) WHERE IsDeleted = 0;
CREATE INDEX IX_Estimate_Code ON ucp.Estimate(Code) WHERE IsDeleted = 0;
CREATE INDEX IX_Estimate_SquadId ON ucp.Estimate(SquadId) WHERE IsDeleted = 0;
CREATE INDEX IX_Estimate_Status ON ucp.Estimate(Status) WHERE IsDeleted = 0;
CREATE INDEX IX_Estimate_EstimatedByUserId ON ucp.Estimate(EstimatedByUserId) WHERE IsDeleted = 0;
GO

-- TechnicalFactor (Fatores Técnicos da Estimativa)
CREATE TABLE ucp.TechnicalFactor (
    TechnicalFactorId UNIQUEIDENTIFIER NOT NULL PRIMARY KEY DEFAULT NEWID(),
    EstimateId UNIQUEIDENTIFIER NOT NULL,
    FactorCode VARCHAR(10) NOT NULL,
    FactorValue DECIMAL(3,2) NOT NULL,
    Weight DECIMAL(3,2) NOT NULL,
    WeightedValue DECIMAL(5,2) NOT NULL,
    -- Auditoria
    CreatedAt DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
    CreatedBy UNIQUEIDENTIFIER NOT NULL,
    UpdatedAt DATETIME2,
    UpdatedBy UNIQUEIDENTIFIER,
    IsDeleted BIT NOT NULL DEFAULT 0,
    CONSTRAINT FK_TechnicalFactor_Estimate FOREIGN KEY (EstimateId) REFERENCES ucp.Estimate(EstimateId),
    CONSTRAINT UK_TechnicalFactor UNIQUE (EstimateId, FactorCode),
    CONSTRAINT CK_TechnicalFactor_Code CHECK (FactorCode IN ('TF1','TF2','TF3','TF4','TF5','TF6','TF7','TF8','TF9','TF10','TF11','TF12','TF13')),
    CONSTRAINT CK_TechnicalFactor_Value CHECK (FactorValue BETWEEN 0 AND 5)
);
GO

CREATE INDEX IX_TechnicalFactor_EstimateId ON ucp.TechnicalFactor(EstimateId) WHERE IsDeleted = 0;
GO

-- EnvironmentalFactor (Fatores Ambientais da Estimativa)
CREATE TABLE ucp.EnvironmentalFactor (
    EnvironmentalFactorId UNIQUEIDENTIFIER NOT NULL PRIMARY KEY DEFAULT NEWID(),
    EstimateId UNIQUEIDENTIFIER NOT NULL,
    FactorCode VARCHAR(10) NOT NULL,
    FactorValue DECIMAL(3,2) NOT NULL,
    Weight DECIMAL(3,2) NOT NULL,
    WeightedValue DECIMAL(5,2) NOT NULL,
    -- Auditoria
    CreatedAt DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
    CreatedBy UNIQUEIDENTIFIER NOT NULL,
    UpdatedAt DATETIME2,
    UpdatedBy UNIQUEIDENTIFIER,
    IsDeleted BIT NOT NULL DEFAULT 0,
    CONSTRAINT FK_EnvironmentalFactor_Estimate FOREIGN KEY (EstimateId) REFERENCES ucp.Estimate(EstimateId),
    CONSTRAINT UK_EnvironmentalFactor UNIQUE (EstimateId, FactorCode),
    CONSTRAINT CK_EnvironmentalFactor_Code CHECK (FactorCode IN ('FA1','FA2','FA3','FA4','FA5','FA6','FA7','FA8')),
    CONSTRAINT CK_EnvironmentalFactor_Value CHECK (FactorValue BETWEEN 0 AND 5)
);
GO

CREATE INDEX IX_EnvironmentalFactor_EstimateId ON ucp.EnvironmentalFactor(EstimateId) WHERE IsDeleted = 0;
GO

-- EstimateActorWeight (Peso dos Atores na Estimativa)
CREATE TABLE ucp.EstimateActorWeight (
    EstimateActorWeightId UNIQUEIDENTIFIER NOT NULL PRIMARY KEY DEFAULT NEWID(),
    EstimateId UNIQUEIDENTIFIER NOT NULL,
    ActorId UNIQUEIDENTIFIER NOT NULL,
    ComplexityId UNIQUEIDENTIFIER NOT NULL,
    WeightFactor DECIMAL(5,2) NOT NULL,
    -- Auditoria
    CreatedAt DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
    CreatedBy UNIQUEIDENTIFIER NOT NULL,
    UpdatedAt DATETIME2,
    UpdatedBy UNIQUEIDENTIFIER,
    IsDeleted BIT NOT NULL DEFAULT 0,
    CONSTRAINT FK_EstimateActorWeight_Estimate FOREIGN KEY (EstimateId) REFERENCES ucp.Estimate(EstimateId),
    CONSTRAINT FK_EstimateActorWeight_Actor FOREIGN KEY (ActorId) REFERENCES req.Actor(ActorId),
    CONSTRAINT FK_EstimateActorWeight_Complexity FOREIGN KEY (ComplexityId) REFERENCES ref.ActorComplexity(ActorComplexityId),
    CONSTRAINT UK_EstimateActorWeight UNIQUE (EstimateId, ActorId)
);
GO

CREATE INDEX IX_EstimateActorWeight_EstimateId ON ucp.EstimateActorWeight(EstimateId) WHERE IsDeleted = 0;
CREATE INDEX IX_EstimateActorWeight_ActorId ON ucp.EstimateActorWeight(ActorId) WHERE IsDeleted = 0;
GO

-- EstimateUseCaseWeight (Peso dos Casos de Uso na Estimativa)
CREATE TABLE ucp.EstimateUseCaseWeight (
    EstimateUseCaseWeightId UNIQUEIDENTIFIER NOT NULL PRIMARY KEY DEFAULT NEWID(),
    EstimateId UNIQUEIDENTIFIER NOT NULL,
    UseCaseId UNIQUEIDENTIFIER NOT NULL,
    ComplexityId UNIQUEIDENTIFIER NOT NULL,
    TransactionCount INT NOT NULL,
    WeightFactor DECIMAL(5,2) NOT NULL,
    -- Auditoria
    CreatedAt DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
    CreatedBy UNIQUEIDENTIFIER NOT NULL,
    UpdatedAt DATETIME2,
    UpdatedBy UNIQUEIDENTIFIER,
    IsDeleted BIT NOT NULL DEFAULT 0,
    CONSTRAINT FK_EstimateUseCaseWeight_Estimate FOREIGN KEY (EstimateId) REFERENCES ucp.Estimate(EstimateId),
    CONSTRAINT FK_EstimateUseCaseWeight_UseCase FOREIGN KEY (UseCaseId) REFERENCES req.UseCase(UseCaseId),
    CONSTRAINT FK_EstimateUseCaseWeight_Complexity FOREIGN KEY (ComplexityId) REFERENCES ref.UseCaseComplexity(UseCaseComplexityId),
    CONSTRAINT UK_EstimateUseCaseWeight UNIQUE (EstimateId, UseCaseId),
    CONSTRAINT CK_EstimateUseCaseWeight_TransactionCount CHECK (TransactionCount > 0)
);
GO

CREATE INDEX IX_EstimateUseCaseWeight_EstimateId ON ucp.EstimateUseCaseWeight(EstimateId) WHERE IsDeleted = 0;
CREATE INDEX IX_EstimateUseCaseWeight_UseCaseId ON ucp.EstimateUseCaseWeight(UseCaseId) WHERE IsDeleted = 0;
GO

-- EstimateHistory (Histórico de Estimativas - para comparação)
CREATE TABLE ucp.EstimateHistory (
    EstimateHistoryId UNIQUEIDENTIFIER NOT NULL PRIMARY KEY DEFAULT NEWID(),
    EstimateId UNIQUEIDENTIFIER NOT NULL,
    SnapshotDate DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
    UAW DECIMAL(10,2) NOT NULL,
    UUCW DECIMAL(10,2) NOT NULL,
    UUCP DECIMAL(10,2) NOT NULL,
    TCF DECIMAL(5,2) NOT NULL,
    EF DECIMAL(5,2) NOT NULL,
    UCP DECIMAL(10,2) NOT NULL,
    TotalHours DECIMAL(10,2) NOT NULL,
    EstimatedCost DECIMAL(18,2),
    ChangeReason NVARCHAR(MAX),
    ChangedByUserId UNIQUEIDENTIFIER NOT NULL,
    CONSTRAINT FK_EstimateHistory_Estimate FOREIGN KEY (EstimateId) REFERENCES ucp.Estimate(EstimateId),
    CONSTRAINT FK_EstimateHistory_ChangedBy FOREIGN KEY (ChangedByUserId) REFERENCES sec.[User](UserId)
);
GO

CREATE INDEX IX_EstimateHistory_EstimateId ON ucp.EstimateHistory(EstimateId);
CREATE INDEX IX_EstimateHistory_SnapshotDate ON ucp.EstimateHistory(SnapshotDate);
GO
