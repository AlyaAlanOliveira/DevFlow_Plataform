-- =============================================
-- DevFlow - Workflow (Controle de Fluxo e Aprovações)
-- Version: 2.1.0
-- Description: Workflow de aprovações, revisões e histórico
-- =============================================

-- ApprovalFlow (Fluxo de Aprovação)
CREATE TABLE workflow.ApprovalFlow (
    ApprovalFlowId UNIQUEIDENTIFIER NOT NULL PRIMARY KEY DEFAULT NEWID(),
    EntityType VARCHAR(50) NOT NULL,
    EntityId UNIQUEIDENTIFIER NOT NULL,
    CurrentStepNumber INT NOT NULL DEFAULT 1,
    Status VARCHAR(30) NOT NULL DEFAULT 'Pending',
    StartedAt DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
    CompletedAt DATETIME2,
    -- Auditoria
    CreatedAt DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
    CreatedBy UNIQUEIDENTIFIER NOT NULL,
    UpdatedAt DATETIME2,
    UpdatedBy UNIQUEIDENTIFIER,
    IsDeleted BIT NOT NULL DEFAULT 0,
    RowVersion ROWVERSION,
    CONSTRAINT CK_ApprovalFlow_EntityType CHECK (EntityType IN ('BusinessCase','Demand','Requirement','UseCase','UserStory','Estimate','Sprint','TestCase','Release','GMUD')),
    CONSTRAINT CK_ApprovalFlow_Status CHECK (Status IN ('Pending','InProgress','Approved','Rejected','Cancelled')),
    CONSTRAINT CK_ApprovalFlow_CurrentStep CHECK (CurrentStepNumber > 0)
);
GO

CREATE INDEX IX_ApprovalFlow_EntityType_EntityId ON workflow.ApprovalFlow(EntityType, EntityId) WHERE IsDeleted = 0;
CREATE INDEX IX_ApprovalFlow_Status ON workflow.ApprovalFlow(Status) WHERE IsDeleted = 0;
CREATE INDEX IX_ApprovalFlow_StartedAt ON workflow.ApprovalFlow(StartedAt) WHERE IsDeleted = 0;
GO

-- ApprovalStep (Etapa de Aprovação)
CREATE TABLE workflow.ApprovalStep (
    ApprovalStepId UNIQUEIDENTIFIER NOT NULL PRIMARY KEY DEFAULT NEWID(),
    ApprovalFlowId UNIQUEIDENTIFIER NOT NULL,
    StepNumber INT NOT NULL,
    ApproverUserId UNIQUEIDENTIFIER NOT NULL,
    Status VARCHAR(30) NOT NULL DEFAULT 'Pending',
    RequestedAt DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
    RespondedAt DATETIME2,
    Comments NVARCHAR(MAX),
    -- Auditoria
    CreatedAt DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
    CreatedBy UNIQUEIDENTIFIER NOT NULL,
    UpdatedAt DATETIME2,
    UpdatedBy UNIQUEIDENTIFIER,
    IsDeleted BIT NOT NULL DEFAULT 0,
    RowVersion ROWVERSION,
    CONSTRAINT FK_ApprovalStep_Flow FOREIGN KEY (ApprovalFlowId) REFERENCES workflow.ApprovalFlow(ApprovalFlowId),
    CONSTRAINT FK_ApprovalStep_User FOREIGN KEY (ApproverUserId) REFERENCES sec.[User](UserId),
    CONSTRAINT CK_ApprovalStep_Status CHECK (Status IN ('Pending','Approved','Rejected','Skipped')),
    CONSTRAINT CK_ApprovalStep_StepNumber CHECK (StepNumber > 0)
);
GO

CREATE INDEX IX_ApprovalStep_ApprovalFlowId ON workflow.ApprovalStep(ApprovalFlowId) WHERE IsDeleted = 0;
CREATE INDEX IX_ApprovalStep_ApproverUserId ON workflow.ApprovalStep(ApproverUserId) WHERE IsDeleted = 0;
CREATE INDEX IX_ApprovalStep_Status ON workflow.ApprovalStep(Status) WHERE IsDeleted = 0;
CREATE INDEX IX_ApprovalStep_StepNumber ON workflow.ApprovalStep(ApprovalFlowId, StepNumber) WHERE IsDeleted = 0;
GO

-- EntityRevision (Histórico de Revisões)
CREATE TABLE workflow.EntityRevision (
    EntityRevisionId UNIQUEIDENTIFIER NOT NULL PRIMARY KEY DEFAULT NEWID(),
    EntityType VARCHAR(50) NOT NULL,
    EntityId UNIQUEIDENTIFIER NOT NULL,
    RevisionNumber INT NOT NULL,
    ContentSnapshot NVARCHAR(MAX),
    ChangeDescription NVARCHAR(MAX),
    RevisedByUserId UNIQUEIDENTIFIER NOT NULL,
    RevisedAt DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
    CONSTRAINT FK_EntityRevision_User FOREIGN KEY (RevisedByUserId) REFERENCES sec.[User](UserId),
    CONSTRAINT UK_EntityRevision UNIQUE (EntityType, EntityId, RevisionNumber),
    CONSTRAINT CK_EntityRevision_EntityType CHECK (EntityType IN ('BusinessCase','Demand','Requirement','UseCase','UserStory','Estimate','Document','PromptTemplate')),
    CONSTRAINT CK_EntityRevision_RevisionNumber CHECK (RevisionNumber > 0)
);
GO

CREATE INDEX IX_EntityRevision_EntityType_EntityId ON workflow.EntityRevision(EntityType, EntityId);
CREATE INDEX IX_EntityRevision_RevisedAt ON workflow.EntityRevision(RevisedAt);
CREATE INDEX IX_EntityRevision_RevisedByUserId ON workflow.EntityRevision(RevisedByUserId);
GO

-- StatusTransition (Transições de Status)
CREATE TABLE workflow.StatusTransition (
    StatusTransitionId UNIQUEIDENTIFIER NOT NULL PRIMARY KEY DEFAULT NEWID(),
    EntityType VARCHAR(50) NOT NULL,
    EntityId UNIQUEIDENTIFIER NOT NULL,
    FromStatusId UNIQUEIDENTIFIER,
    ToStatusId UNIQUEIDENTIFIER NOT NULL,
    TransitionedByUserId UNIQUEIDENTIFIER NOT NULL,
    TransitionedAt DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
    Comments NVARCHAR(MAX),
    CONSTRAINT FK_StatusTransition_FromStatus FOREIGN KEY (FromStatusId) REFERENCES ref.WorkflowStatus(WorkflowStatusId),
    CONSTRAINT FK_StatusTransition_ToStatus FOREIGN KEY (ToStatusId) REFERENCES ref.WorkflowStatus(WorkflowStatusId),
    CONSTRAINT FK_StatusTransition_User FOREIGN KEY (TransitionedByUserId) REFERENCES sec.[User](UserId),
    CONSTRAINT CK_StatusTransition_EntityType CHECK (EntityType IN ('BusinessCase','Demand','Requirement','UseCase','UserStory','Estimate','Sprint','TestCase','Release','GMUD'))
);
GO

CREATE INDEX IX_StatusTransition_EntityType_EntityId ON workflow.StatusTransition(EntityType, EntityId);
CREATE INDEX IX_StatusTransition_TransitionedAt ON workflow.StatusTransition(TransitionedAt);
CREATE INDEX IX_StatusTransition_TransitionedByUserId ON workflow.StatusTransition(TransitionedByUserId);
GO

-- Assignment (Designações de Analistas/Responsáveis)
CREATE TABLE workflow.Assignment (
    AssignmentId UNIQUEIDENTIFIER NOT NULL PRIMARY KEY DEFAULT NEWID(),
    EntityType VARCHAR(50) NOT NULL,
    EntityId UNIQUEIDENTIFIER NOT NULL,
    AssignedToUserId UNIQUEIDENTIFIER NOT NULL,
    AssignedByUserId UNIQUEIDENTIFIER NOT NULL,
    AssignedAt DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
    UnassignedAt DATETIME2,
    UnassignedByUserId UNIQUEIDENTIFIER,
    Comments NVARCHAR(MAX),
    IsActive BIT NOT NULL DEFAULT 1,
    CONSTRAINT FK_Assignment_AssignedTo FOREIGN KEY (AssignedToUserId) REFERENCES sec.[User](UserId),
    CONSTRAINT FK_Assignment_AssignedBy FOREIGN KEY (AssignedByUserId) REFERENCES sec.[User](UserId),
    CONSTRAINT FK_Assignment_UnassignedBy FOREIGN KEY (UnassignedByUserId) REFERENCES sec.[User](UserId),
    CONSTRAINT CK_Assignment_EntityType CHECK (EntityType IN ('Demand','Requirement','UseCase','UserStory','TestCase','Sprint','Release'))
);
GO

CREATE INDEX IX_Assignment_EntityType_EntityId ON workflow.Assignment(EntityType, EntityId) WHERE IsActive = 1;
CREATE INDEX IX_Assignment_AssignedToUserId ON workflow.Assignment(AssignedToUserId) WHERE IsActive = 1;
CREATE INDEX IX_Assignment_AssignedAt ON workflow.Assignment(AssignedAt);
GO
