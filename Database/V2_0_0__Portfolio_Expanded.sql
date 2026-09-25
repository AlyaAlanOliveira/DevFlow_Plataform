-- =============================================
-- DevFlow - Portfolio Expanded (Portfolio Expandido)
-- Version: 2.0.0
-- Description: Expansão de BusinessCase e Demand com todos os campos necessários
-- =============================================

-- Adicionar colunas ao BusinessCase
ALTER TABLE portfolio.BusinessCase ADD
    CompanyId UNIQUEIDENTIFIER NOT NULL CONSTRAINT DF_BusinessCase_CompanyId_Temp DEFAULT '00000000-0000-0000-0000-000000000000',
    AreaId UNIQUEIDENTIFIER NOT NULL CONSTRAINT DF_BusinessCase_AreaId_Temp DEFAULT '00000000-0000-0000-0000-000000000000',
    RequestedByUserId UNIQUEIDENTIFIER NOT NULL CONSTRAINT DF_BusinessCase_RequestedByUserId_Temp DEFAULT '00000000-0000-0000-0000-000000000000',
    Description NVARCHAR(MAX),
    BusinessJustification NVARCHAR(MAX),
    ExpectedBenefits NVARCHAR(MAX),
    EstimatedBudget DECIMAL(18,2),
    RequestedDate DATETIME2 NOT NULL CONSTRAINT DF_BusinessCase_RequestedDate DEFAULT GETUTCDATE(),
    ApprovedByUserId UNIQUEIDENTIFIER,
    ApprovedDate DATETIME2,
    RejectedByUserId UNIQUEIDENTIFIER,
    RejectedDate DATETIME2,
    RejectionReason NVARCHAR(MAX),
    -- Auditoria
    CreatedAt DATETIME2 NOT NULL CONSTRAINT DF_BusinessCase_CreatedAt DEFAULT GETUTCDATE(),
    CreatedBy UNIQUEIDENTIFIER NOT NULL CONSTRAINT DF_BusinessCase_CreatedBy_Temp DEFAULT '00000000-0000-0000-0000-000000000000',
    UpdatedAt DATETIME2,
    UpdatedBy UNIQUEIDENTIFIER,
    DeletedAt DATETIME2,
    DeletedBy UNIQUEIDENTIFIER,
    IsDeleted BIT NOT NULL CONSTRAINT DF_BusinessCase_IsDeleted DEFAULT 0,
    RowVersion ROWVERSION;
GO

-- Adicionar constraints ao BusinessCase
ALTER TABLE portfolio.BusinessCase ADD
    CONSTRAINT FK_BusinessCase_Company FOREIGN KEY (CompanyId) REFERENCES gov.Company(CompanyId),
    CONSTRAINT FK_BusinessCase_Area FOREIGN KEY (AreaId) REFERENCES gov.Area(AreaId),
    CONSTRAINT FK_BusinessCase_RequestedBy FOREIGN KEY (RequestedByUserId) REFERENCES sec.[User](UserId),
    CONSTRAINT FK_BusinessCase_ApprovedBy FOREIGN KEY (ApprovedByUserId) REFERENCES sec.[User](UserId),
    CONSTRAINT FK_BusinessCase_RejectedBy FOREIGN KEY (RejectedByUserId) REFERENCES sec.[User](UserId),
    CONSTRAINT CK_BusinessCase_ApprovalDates CHECK (ApprovedDate IS NULL OR RejectedDate IS NULL);
GO

CREATE INDEX IX_BusinessCase_CompanyId ON portfolio.BusinessCase(CompanyId) WHERE IsDeleted = 0;
CREATE INDEX IX_BusinessCase_AreaId ON portfolio.BusinessCase(AreaId) WHERE IsDeleted = 0;
CREATE INDEX IX_BusinessCase_RequestedByUserId ON portfolio.BusinessCase(RequestedByUserId) WHERE IsDeleted = 0;
CREATE INDEX IX_BusinessCase_Status ON portfolio.BusinessCase(Status) WHERE IsDeleted = 0;
GO

-- Adicionar colunas ao Demand
ALTER TABLE portfolio.Demand ADD
    SystemId UNIQUEIDENTIFIER NOT NULL CONSTRAINT DF_Demand_SystemId_Temp DEFAULT '00000000-0000-0000-0000-000000000000',
    DemandTypeId UNIQUEIDENTIFIER NOT NULL CONSTRAINT DF_Demand_DemandTypeId_Temp DEFAULT '00000000-0000-0000-0000-000000000000',
    AreaId UNIQUEIDENTIFIER NOT NULL CONSTRAINT DF_Demand_AreaId_Temp DEFAULT '00000000-0000-0000-0000-000000000000',
    RequestedByUserId UNIQUEIDENTIFIER NOT NULL CONSTRAINT DF_Demand_RequestedByUserId_Temp DEFAULT '00000000-0000-0000-0000-000000000000',
    AssignedToUserId UNIQUEIDENTIFIER,
    AssignedDate DATETIME2,
    AssignedByUserId UNIQUEIDENTIFIER,
    Description NVARCHAR(MAX),
    CurrentSituation NVARCHAR(MAX),
    ProposedSolution NVARCHAR(MAX),
    ExpectedResults NVARCHAR(MAX),
    ImpactAnalysis NVARCHAR(MAX),
    -- UCP Factors (específicos da demanda)
    PerformanceComplexity DECIMAL(3,2),
    UsabilityComplexity DECIMAL(3,2),
    TechnicalComplexity DECIMAL(3,2),
    StabilityRequirement DECIMAL(3,2),
    -- Datas
    RequestedDate DATETIME2 NOT NULL CONSTRAINT DF_Demand_RequestedDate DEFAULT GETUTCDATE(),
    TargetDate DATE,
    ApprovedByUserId UNIQUEIDENTIFIER,
    ApprovedDate DATETIME2,
    RejectedByUserId UNIQUEIDENTIFIER,
    RejectedDate DATETIME2,
    RejectionReason NVARCHAR(MAX),
    -- Auditoria
    CreatedAt DATETIME2 NOT NULL CONSTRAINT DF_Demand_CreatedAt DEFAULT GETUTCDATE(),
    CreatedBy UNIQUEIDENTIFIER NOT NULL CONSTRAINT DF_Demand_CreatedBy_Temp DEFAULT '00000000-0000-0000-0000-000000000000',
    UpdatedAt DATETIME2,
    UpdatedBy UNIQUEIDENTIFIER,
    DeletedAt DATETIME2,
    DeletedBy UNIQUEIDENTIFIER,
    IsDeleted BIT NOT NULL CONSTRAINT DF_Demand_IsDeleted DEFAULT 0,
    RowVersion ROWVERSION;
GO

-- Adicionar constraints ao Demand
ALTER TABLE portfolio.Demand ADD
    CONSTRAINT FK_Demand_System FOREIGN KEY (SystemId) REFERENCES syst.[System](SystemId),
    CONSTRAINT FK_Demand_DemandType FOREIGN KEY (DemandTypeId) REFERENCES ref.DemandType(DemandTypeId),
    CONSTRAINT FK_Demand_Area FOREIGN KEY (AreaId) REFERENCES gov.Area(AreaId),
    CONSTRAINT FK_Demand_RequestedBy FOREIGN KEY (RequestedByUserId) REFERENCES sec.[User](UserId),
    CONSTRAINT FK_Demand_AssignedTo FOREIGN KEY (AssignedToUserId) REFERENCES sec.[User](UserId),
    CONSTRAINT FK_Demand_AssignedBy FOREIGN KEY (AssignedByUserId) REFERENCES sec.[User](UserId),
    CONSTRAINT FK_Demand_ApprovedBy FOREIGN KEY (ApprovedByUserId) REFERENCES sec.[User](UserId),
    CONSTRAINT FK_Demand_RejectedBy FOREIGN KEY (RejectedByUserId) REFERENCES sec.[User](UserId),
    CONSTRAINT CK_Demand_ApprovalDates CHECK (ApprovedDate IS NULL OR RejectedDate IS NULL),
    CONSTRAINT CK_Demand_PerformanceComplexity CHECK (PerformanceComplexity IS NULL OR PerformanceComplexity BETWEEN 0 AND 5),
    CONSTRAINT CK_Demand_UsabilityComplexity CHECK (UsabilityComplexity IS NULL OR UsabilityComplexity BETWEEN 0 AND 5),
    CONSTRAINT CK_Demand_TechnicalComplexity CHECK (TechnicalComplexity IS NULL OR TechnicalComplexity BETWEEN 0 AND 5),
    CONSTRAINT CK_Demand_StabilityRequirement CHECK (StabilityRequirement IS NULL OR StabilityRequirement BETWEEN 0 AND 5);
GO

CREATE INDEX IX_Demand_SystemId ON portfolio.Demand(SystemId) WHERE IsDeleted = 0;
CREATE INDEX IX_Demand_DemandTypeId ON portfolio.Demand(DemandTypeId) WHERE IsDeleted = 0;
CREATE INDEX IX_Demand_AreaId ON portfolio.Demand(AreaId) WHERE IsDeleted = 0;
CREATE INDEX IX_Demand_RequestedByUserId ON portfolio.Demand(RequestedByUserId) WHERE IsDeleted = 0;
CREATE INDEX IX_Demand_AssignedToUserId ON portfolio.Demand(AssignedToUserId) WHERE IsDeleted = 0;
CREATE INDEX IX_Demand_Status ON portfolio.Demand(Status) WHERE IsDeleted = 0;
CREATE INDEX IX_Demand_Priority ON portfolio.Demand(Priority) WHERE IsDeleted = 0;
CREATE INDEX IX_Demand_TargetDate ON portfolio.Demand(TargetDate) WHERE IsDeleted = 0;
GO

-- DemandOperation (Operações relacionadas à demanda - N:N)
CREATE TABLE portfolio.DemandOperation (
    DemandOperationId UNIQUEIDENTIFIER NOT NULL PRIMARY KEY DEFAULT NEWID(),
    DemandId UNIQUEIDENTIFIER NOT NULL,
    OperationId UNIQUEIDENTIFIER NOT NULL,
    -- Auditoria
    CreatedAt DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
    CreatedBy UNIQUEIDENTIFIER NOT NULL,
    IsDeleted BIT NOT NULL DEFAULT 0,
    CONSTRAINT FK_DemandOperation_Demand FOREIGN KEY (DemandId) REFERENCES portfolio.Demand(DemandId),
    CONSTRAINT FK_DemandOperation_Operation FOREIGN KEY (OperationId) REFERENCES cfg.Operation(OperationId),
    CONSTRAINT UK_DemandOperation UNIQUE (DemandId, OperationId)
);
GO

CREATE INDEX IX_DemandOperation_DemandId ON portfolio.DemandOperation(DemandId) WHERE IsDeleted = 0;
CREATE INDEX IX_DemandOperation_OperationId ON portfolio.DemandOperation(OperationId) WHERE IsDeleted = 0;
GO

-- DemandPriorityHistory (Histórico de mudanças de prioridade)
CREATE TABLE portfolio.DemandPriorityHistory (
    DemandPriorityHistoryId UNIQUEIDENTIFIER NOT NULL PRIMARY KEY DEFAULT NEWID(),
    DemandId UNIQUEIDENTIFIER NOT NULL,
    FromPriorityId UNIQUEIDENTIFIER,
    ToPriorityId UNIQUEIDENTIFIER NOT NULL,
    ChangedByUserId UNIQUEIDENTIFIER NOT NULL,
    ChangedAt DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
    Justification NVARCHAR(MAX),
    CONSTRAINT FK_DemandPriorityHistory_Demand FOREIGN KEY (DemandId) REFERENCES portfolio.Demand(DemandId),
    CONSTRAINT FK_DemandPriorityHistory_FromPriority FOREIGN KEY (FromPriorityId) REFERENCES ref.Priority(PriorityId),
    CONSTRAINT FK_DemandPriorityHistory_ToPriority FOREIGN KEY (ToPriorityId) REFERENCES ref.Priority(PriorityId),
    CONSTRAINT FK_DemandPriorityHistory_User FOREIGN KEY (ChangedByUserId) REFERENCES sec.[User](UserId)
);
GO

CREATE INDEX IX_DemandPriorityHistory_DemandId ON portfolio.DemandPriorityHistory(DemandId);
CREATE INDEX IX_DemandPriorityHistory_ChangedAt ON portfolio.DemandPriorityHistory(ChangedAt);
GO
