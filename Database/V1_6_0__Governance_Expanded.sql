-- =============================================
-- DevFlow - Governance Expanded (Governança Expandida)
-- Version: 1.6.0
-- Description: Estrutura organizacional completa (Directorate, Area, Squad)
-- =============================================

-- Directorate (Diretorias)
CREATE TABLE gov.Directorate (
    DirectorateId UNIQUEIDENTIFIER NOT NULL PRIMARY KEY DEFAULT NEWID(),
    CompanyId UNIQUEIDENTIFIER NOT NULL,
    Code VARCHAR(20) NOT NULL,
    Name NVARCHAR(200) NOT NULL,
    Description NVARCHAR(1000),
    DirectorUserId UNIQUEIDENTIFIER,
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
    CONSTRAINT FK_Directorate_Company FOREIGN KEY (CompanyId) REFERENCES gov.Company(CompanyId),
    CONSTRAINT FK_Directorate_Director FOREIGN KEY (DirectorUserId) REFERENCES sec.[User](UserId),
    CONSTRAINT UK_Directorate_Code UNIQUE (CompanyId, Code)
);
GO

CREATE INDEX IX_Directorate_CompanyId ON gov.Directorate(CompanyId) WHERE IsDeleted = 0;
CREATE INDEX IX_Directorate_DirectorUserId ON gov.Directorate(DirectorUserId) WHERE IsDeleted = 0;
GO

-- Area (Áreas)
CREATE TABLE gov.Area (
    AreaId UNIQUEIDENTIFIER NOT NULL PRIMARY KEY DEFAULT NEWID(),
    DirectorateId UNIQUEIDENTIFIER NOT NULL,
    Code VARCHAR(20) NOT NULL,
    Name NVARCHAR(200) NOT NULL,
    Description NVARCHAR(1000),
    ManagerUserId UNIQUEIDENTIFIER,
    IsDemandRequester BIT NOT NULL DEFAULT 1,
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
    CONSTRAINT FK_Area_Directorate FOREIGN KEY (DirectorateId) REFERENCES gov.Directorate(DirectorateId),
    CONSTRAINT FK_Area_Manager FOREIGN KEY (ManagerUserId) REFERENCES sec.[User](UserId),
    CONSTRAINT UK_Area_Code UNIQUE (DirectorateId, Code)
);
GO

CREATE INDEX IX_Area_DirectorateId ON gov.Area(DirectorateId) WHERE IsDeleted = 0;
CREATE INDEX IX_Area_ManagerUserId ON gov.Area(ManagerUserId) WHERE IsDeleted = 0;
CREATE INDEX IX_Area_IsDemandRequester ON gov.Area(IsDemandRequester) WHERE IsDeleted = 0 AND IsActive = 1;
GO

-- Squad (Times de Desenvolvimento)
CREATE TABLE gov.Squad (
    SquadId UNIQUEIDENTIFIER NOT NULL PRIMARY KEY DEFAULT NEWID(),
    AreaId UNIQUEIDENTIFIER NOT NULL,
    Code VARCHAR(20) NOT NULL,
    Name NVARCHAR(200) NOT NULL,
    Description NVARCHAR(1000),
    ScrumMasterUserId UNIQUEIDENTIFIER,
    ProductOwnerUserId UNIQUEIDENTIFIER,
    -- Capacidade e Velocidade
    SprintDurationDays INT NOT NULL DEFAULT 14,
    CapacityHoursPerSprint DECIMAL(10,2),
    AverageVelocityPoints DECIMAL(10,2),
    -- Fatores Ambientais (EF) - UCP
    -- FA1: Familiaridade com Rational Unified Process
    FA1_Familiarity DECIMAL(3,2) DEFAULT 3.00,
    -- FA2: Experiência na aplicação
    FA2_ApplicationExperience DECIMAL(3,2) DEFAULT 3.00,
    -- FA3: Experiência em orientação a objetos
    FA3_OOExperience DECIMAL(3,2) DEFAULT 3.00,
    -- FA4: Capacidade do analista líder
    FA4_LeadAnalystCapability DECIMAL(3,2) DEFAULT 3.00,
    -- FA5: Motivação
    FA5_Motivation DECIMAL(3,2) DEFAULT 3.00,
    -- FA6: Requisitos estáveis (não usado conforme SystemPrompt)
    -- FA7: Pessoal part-time
    FA7_PartTimeStaff DECIMAL(3,2) DEFAULT 3.00,
    -- FA8: Dificuldade da linguagem de programação
    FA8_DifficultyProgrammingLanguage DECIMAL(3,2) DEFAULT 3.00,
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
    CONSTRAINT FK_Squad_Area FOREIGN KEY (AreaId) REFERENCES gov.Area(AreaId),
    CONSTRAINT FK_Squad_ScrumMaster FOREIGN KEY (ScrumMasterUserId) REFERENCES sec.[User](UserId),
    CONSTRAINT FK_Squad_ProductOwner FOREIGN KEY (ProductOwnerUserId) REFERENCES sec.[User](UserId),
    CONSTRAINT UK_Squad_Code UNIQUE (AreaId, Code),
    CONSTRAINT CK_Squad_SprintDuration CHECK (SprintDurationDays BETWEEN 7 AND 30),
    CONSTRAINT CK_Squad_FA1 CHECK (FA1_Familiarity BETWEEN 0 AND 5),
    CONSTRAINT CK_Squad_FA2 CHECK (FA2_ApplicationExperience BETWEEN 0 AND 5),
    CONSTRAINT CK_Squad_FA3 CHECK (FA3_OOExperience BETWEEN 0 AND 5),
    CONSTRAINT CK_Squad_FA4 CHECK (FA4_LeadAnalystCapability BETWEEN 0 AND 5),
    CONSTRAINT CK_Squad_FA5 CHECK (FA5_Motivation BETWEEN 0 AND 5),
    CONSTRAINT CK_Squad_FA7 CHECK (FA7_PartTimeStaff BETWEEN 0 AND 5),
    CONSTRAINT CK_Squad_FA8 CHECK (FA8_DifficultyProgrammingLanguage BETWEEN 0 AND 5)
);
GO

CREATE INDEX IX_Squad_AreaId ON gov.Squad(AreaId) WHERE IsDeleted = 0;
CREATE INDEX IX_Squad_ScrumMasterUserId ON gov.Squad(ScrumMasterUserId) WHERE IsDeleted = 0;
CREATE INDEX IX_Squad_ProductOwnerUserId ON gov.Squad(ProductOwnerUserId) WHERE IsDeleted = 0;
GO

-- SquadMember (Membros das Squads)
CREATE TABLE gov.SquadMember (
    SquadMemberId UNIQUEIDENTIFIER NOT NULL PRIMARY KEY DEFAULT NEWID(),
    SquadId UNIQUEIDENTIFIER NOT NULL,
    UserId UNIQUEIDENTIFIER NOT NULL,
    RoleCode VARCHAR(30) NOT NULL,
    AllocationPercentage DECIMAL(5,2) NOT NULL DEFAULT 100.00,
    StartDate DATE NOT NULL,
    EndDate DATE,
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
    CONSTRAINT FK_SquadMember_Squad FOREIGN KEY (SquadId) REFERENCES gov.Squad(SquadId),
    CONSTRAINT FK_SquadMember_User FOREIGN KEY (UserId) REFERENCES sec.[User](UserId),
    CONSTRAINT UK_SquadMember UNIQUE (SquadId, UserId, StartDate),
    CONSTRAINT CK_SquadMember_RoleCode CHECK (RoleCode IN ('BA','DEV','QA','PO','SM','ARCH','LEAD')),
    CONSTRAINT CK_SquadMember_Allocation CHECK (AllocationPercentage BETWEEN 0 AND 100),
    CONSTRAINT CK_SquadMember_Dates CHECK (EndDate IS NULL OR EndDate >= StartDate)
);
GO

CREATE INDEX IX_SquadMember_SquadId ON gov.SquadMember(SquadId) WHERE IsDeleted = 0;
CREATE INDEX IX_SquadMember_UserId ON gov.SquadMember(UserId) WHERE IsDeleted = 0;
CREATE INDEX IX_SquadMember_RoleCode ON gov.SquadMember(RoleCode) WHERE IsDeleted = 0;
CREATE INDEX IX_SquadMember_Active ON gov.SquadMember(SquadId, UserId) WHERE IsDeleted = 0 AND IsActive = 1 AND EndDate IS NULL;
GO
