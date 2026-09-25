-- =============================================
-- DevFlow - Agile (User Stories, Regras de Negócio, Critérios de Aceite)
-- Version: 2.3.0
-- Description: Estrutura completa para gestão ágil
-- =============================================

-- UserStory (User Stories)
CREATE TABLE agile.UserStory (
    UserStoryId UNIQUEIDENTIFIER NOT NULL PRIMARY KEY DEFAULT NEWID(),
    UseCaseId UNIQUEIDENTIFIER NOT NULL,
    Code VARCHAR(30) NOT NULL UNIQUE,
    Title NVARCHAR(300) NOT NULL,
    AsA NVARCHAR(200) NOT NULL,
    IWant NVARCHAR(500) NOT NULL,
    SoThat NVARCHAR(500) NOT NULL,
    Description NVARCHAR(MAX),
    StoryPoints INT,
    Priority VARCHAR(20),
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
    CONSTRAINT FK_UserStory_UseCase FOREIGN KEY (UseCaseId) REFERENCES req.UseCase(UseCaseId),
    CONSTRAINT CK_UserStory_StoryPoints CHECK (StoryPoints IS NULL OR StoryPoints BETWEEN 1 AND 100),
    CONSTRAINT CK_UserStory_Priority CHECK (Priority IS NULL OR Priority IN ('Low','Medium','High','Critical')),
    CONSTRAINT CK_UserStory_Status CHECK (Status IN ('Draft','InReview','Approved','Rejected','InProgress','Done','Cancelled'))
);
GO

CREATE INDEX IX_UserStory_UseCaseId ON agile.UserStory(UseCaseId) WHERE IsDeleted = 0;
CREATE INDEX IX_UserStory_Code ON agile.UserStory(Code) WHERE IsDeleted = 0;
CREATE INDEX IX_UserStory_Status ON agile.UserStory(Status) WHERE IsDeleted = 0;
CREATE INDEX IX_UserStory_Priority ON agile.UserStory(Priority) WHERE IsDeleted = 0;
GO

-- BusinessRule (Regras de Negócio)
CREATE TABLE agile.BusinessRule (
    BusinessRuleId UNIQUEIDENTIFIER NOT NULL PRIMARY KEY DEFAULT NEWID(),
    UserStoryId UNIQUEIDENTIFIER NOT NULL,
    Code VARCHAR(30) NOT NULL,
    Title NVARCHAR(300) NOT NULL,
    Description NVARCHAR(MAX) NOT NULL,
    -- Auditoria
    CreatedAt DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
    CreatedBy UNIQUEIDENTIFIER NOT NULL,
    UpdatedAt DATETIME2,
    UpdatedBy UNIQUEIDENTIFIER,
    DeletedAt DATETIME2,
    DeletedBy UNIQUEIDENTIFIER,
    IsDeleted BIT NOT NULL DEFAULT 0,
    RowVersion ROWVERSION,
    CONSTRAINT FK_BusinessRule_UserStory FOREIGN KEY (UserStoryId) REFERENCES agile.UserStory(UserStoryId),
    CONSTRAINT UK_BusinessRule_Code UNIQUE (UserStoryId, Code)
);
GO

CREATE INDEX IX_BusinessRule_UserStoryId ON agile.BusinessRule(UserStoryId) WHERE IsDeleted = 0;
CREATE INDEX IX_BusinessRule_Code ON agile.BusinessRule(Code) WHERE IsDeleted = 0;
GO

-- AcceptanceCriteria (Critérios de Aceite)
CREATE TABLE agile.AcceptanceCriteria (
    AcceptanceCriteriaId UNIQUEIDENTIFIER NOT NULL PRIMARY KEY DEFAULT NEWID(),
    BusinessRuleId UNIQUEIDENTIFIER NOT NULL,
    Code VARCHAR(30) NOT NULL,
    Description NVARCHAR(MAX) NOT NULL,
    GivenWhenThen NVARCHAR(MAX),
    DisplayOrder INT NOT NULL,
    -- Auditoria
    CreatedAt DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
    CreatedBy UNIQUEIDENTIFIER NOT NULL,
    UpdatedAt DATETIME2,
    UpdatedBy UNIQUEIDENTIFIER,
    DeletedAt DATETIME2,
    DeletedBy UNIQUEIDENTIFIER,
    IsDeleted BIT NOT NULL DEFAULT 0,
    RowVersion ROWVERSION,
    CONSTRAINT FK_AcceptanceCriteria_BusinessRule FOREIGN KEY (BusinessRuleId) REFERENCES agile.BusinessRule(BusinessRuleId),
    CONSTRAINT UK_AcceptanceCriteria_Code UNIQUE (BusinessRuleId, Code)
);
GO

CREATE INDEX IX_AcceptanceCriteria_BusinessRuleId ON agile.AcceptanceCriteria(BusinessRuleId) WHERE IsDeleted = 0;
CREATE INDEX IX_AcceptanceCriteria_DisplayOrder ON agile.AcceptanceCriteria(BusinessRuleId, DisplayOrder) WHERE IsDeleted = 0;
GO

-- Sprint (Sprints)
CREATE TABLE agile.Sprint (
    SprintId UNIQUEIDENTIFIER NOT NULL PRIMARY KEY DEFAULT NEWID(),
    SquadId UNIQUEIDENTIFIER NOT NULL,
    Code VARCHAR(30) NOT NULL,
    Name NVARCHAR(200) NOT NULL,
    Goal NVARCHAR(1000),
    StartDate DATE NOT NULL,
    EndDate DATE NOT NULL,
    Status VARCHAR(30) NOT NULL DEFAULT 'Planned',
    PlannedVelocity DECIMAL(10,2),
    ActualVelocity DECIMAL(10,2),
    -- Auditoria
    CreatedAt DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
    CreatedBy UNIQUEIDENTIFIER NOT NULL,
    UpdatedAt DATETIME2,
    UpdatedBy UNIQUEIDENTIFIER,
    DeletedAt DATETIME2,
    DeletedBy UNIQUEIDENTIFIER,
    IsDeleted BIT NOT NULL DEFAULT 0,
    RowVersion ROWVERSION,
    CONSTRAINT FK_Sprint_Squad FOREIGN KEY (SquadId) REFERENCES gov.Squad(SquadId),
    CONSTRAINT UK_Sprint_Code UNIQUE (SquadId, Code),
    CONSTRAINT CK_Sprint_Dates CHECK (EndDate > StartDate),
    CONSTRAINT CK_Sprint_Status CHECK (Status IN ('Planned','Active','Completed','Cancelled'))
);
GO

CREATE INDEX IX_Sprint_SquadId ON agile.Sprint(SquadId) WHERE IsDeleted = 0;
CREATE INDEX IX_Sprint_Status ON agile.Sprint(Status) WHERE IsDeleted = 0;
CREATE INDEX IX_Sprint_StartDate ON agile.Sprint(StartDate) WHERE IsDeleted = 0;
GO

-- SprintUserStory (User Stories na Sprint)
CREATE TABLE agile.SprintUserStory (
    SprintUserStoryId UNIQUEIDENTIFIER NOT NULL PRIMARY KEY DEFAULT NEWID(),
    SprintId UNIQUEIDENTIFIER NOT NULL,
    UserStoryId UNIQUEIDENTIFIER NOT NULL,
    AssignedToUserId UNIQUEIDENTIFIER,
    Status VARCHAR(30) NOT NULL DEFAULT 'ToDo',
    -- Auditoria
    CreatedAt DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
    CreatedBy UNIQUEIDENTIFIER NOT NULL,
    UpdatedAt DATETIME2,
    UpdatedBy UNIQUEIDENTIFIER,
    IsDeleted BIT NOT NULL DEFAULT 0,
    RowVersion ROWVERSION,
    CONSTRAINT FK_SprintUserStory_Sprint FOREIGN KEY (SprintId) REFERENCES agile.Sprint(SprintId),
    CONSTRAINT FK_SprintUserStory_UserStory FOREIGN KEY (UserStoryId) REFERENCES agile.UserStory(UserStoryId),
    CONSTRAINT FK_SprintUserStory_AssignedTo FOREIGN KEY (AssignedToUserId) REFERENCES sec.[User](UserId),
    CONSTRAINT UK_SprintUserStory UNIQUE (SprintId, UserStoryId),
    CONSTRAINT CK_SprintUserStory_Status CHECK (Status IN ('ToDo','InProgress','InReview','Done','Blocked'))
);
GO

CREATE INDEX IX_SprintUserStory_SprintId ON agile.SprintUserStory(SprintId) WHERE IsDeleted = 0;
CREATE INDEX IX_SprintUserStory_UserStoryId ON agile.SprintUserStory(UserStoryId) WHERE IsDeleted = 0;
CREATE INDEX IX_SprintUserStory_AssignedToUserId ON agile.SprintUserStory(AssignedToUserId) WHERE IsDeleted = 0;
CREATE INDEX IX_SprintUserStory_Status ON agile.SprintUserStory(Status) WHERE IsDeleted = 0;
GO

-- Task (Tarefas técnicas)
CREATE TABLE agile.Task (
    TaskId UNIQUEIDENTIFIER NOT NULL PRIMARY KEY DEFAULT NEWID(),
    UserStoryId UNIQUEIDENTIFIER NOT NULL,
    Title NVARCHAR(300) NOT NULL,
    Description NVARCHAR(MAX),
    AssignedToUserId UNIQUEIDENTIFIER,
    EstimatedHours DECIMAL(10,2),
    ActualHours DECIMAL(10,2),
    Status VARCHAR(30) NOT NULL DEFAULT 'ToDo',
    -- Auditoria
    CreatedAt DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
    CreatedBy UNIQUEIDENTIFIER NOT NULL,
    UpdatedAt DATETIME2,
    UpdatedBy UNIQUEIDENTIFIER,
    DeletedAt DATETIME2,
    DeletedBy UNIQUEIDENTIFIER,
    IsDeleted BIT NOT NULL DEFAULT 0,
    RowVersion ROWVERSION,
    CONSTRAINT FK_Task_UserStory FOREIGN KEY (UserStoryId) REFERENCES agile.UserStory(UserStoryId),
    CONSTRAINT FK_Task_AssignedTo FOREIGN KEY (AssignedToUserId) REFERENCES sec.[User](UserId),
    CONSTRAINT CK_Task_Status CHECK (Status IN ('ToDo','InProgress','Done','Blocked','Cancelled'))
);
GO

CREATE INDEX IX_Task_UserStoryId ON agile.Task(UserStoryId) WHERE IsDeleted = 0;
CREATE INDEX IX_Task_AssignedToUserId ON agile.Task(AssignedToUserId) WHERE IsDeleted = 0;
CREATE INDEX IX_Task_Status ON agile.Task(Status) WHERE IsDeleted = 0;
GO
