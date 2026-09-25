-- =============================================
-- DevFlow - Security Expanded (Segurança Expandida)
-- Version: 1.9.0
-- Description: RBAC completo (Roles, Permissions, UserRoles)
-- =============================================

-- Role (Papéis/Funções)
CREATE TABLE sec.[Role] (
    RoleId UNIQUEIDENTIFIER NOT NULL PRIMARY KEY DEFAULT NEWID(),
    Code VARCHAR(50) NOT NULL UNIQUE,
    Name NVARCHAR(200) NOT NULL,
    Description NVARCHAR(1000),
    IsSystemRole BIT NOT NULL DEFAULT 0,
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

CREATE INDEX IX_Role_Code ON sec.[Role](Code) WHERE IsDeleted = 0;
GO

-- Permission (Permissões)
CREATE TABLE sec.Permission (
    PermissionId UNIQUEIDENTIFIER NOT NULL PRIMARY KEY DEFAULT NEWID(),
    Code VARCHAR(100) NOT NULL UNIQUE,
    Name NVARCHAR(200) NOT NULL,
    Description NVARCHAR(1000),
    ResourceType VARCHAR(50) NOT NULL,
    ActionType VARCHAR(30) NOT NULL,
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
    CONSTRAINT CK_Permission_ResourceType CHECK (ResourceType IN ('BusinessCase','Demand','Requirement','UseCase','UserStory','Estimate','Sprint','TestCase','Release','GMUD','System','User','Squad','Area','Report')),
    CONSTRAINT CK_Permission_ActionType CHECK (ActionType IN ('Create','Read','Update','Delete','Approve','Reject','Assign','Prioritize','Execute','Export'))
);
GO

CREATE INDEX IX_Permission_Code ON sec.Permission(Code) WHERE IsDeleted = 0;
CREATE INDEX IX_Permission_ResourceType ON sec.Permission(ResourceType) WHERE IsDeleted = 0;
CREATE INDEX IX_Permission_ActionType ON sec.Permission(ActionType) WHERE IsDeleted = 0;
GO

-- RolePermission (Permissões por Papel)
CREATE TABLE sec.RolePermission (
    RolePermissionId UNIQUEIDENTIFIER NOT NULL PRIMARY KEY DEFAULT NEWID(),
    RoleId UNIQUEIDENTIFIER NOT NULL,
    PermissionId UNIQUEIDENTIFIER NOT NULL,
    -- Auditoria
    CreatedAt DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
    CreatedBy UNIQUEIDENTIFIER NOT NULL,
    IsDeleted BIT NOT NULL DEFAULT 0,
    CONSTRAINT FK_RolePermission_Role FOREIGN KEY (RoleId) REFERENCES sec.[Role](RoleId),
    CONSTRAINT FK_RolePermission_Permission FOREIGN KEY (PermissionId) REFERENCES sec.Permission(PermissionId),
    CONSTRAINT UK_RolePermission UNIQUE (RoleId, PermissionId)
);
GO

CREATE INDEX IX_RolePermission_RoleId ON sec.RolePermission(RoleId) WHERE IsDeleted = 0;
CREATE INDEX IX_RolePermission_PermissionId ON sec.RolePermission(PermissionId) WHERE IsDeleted = 0;
GO

-- UserRole (Papéis dos Usuários com Escopo)
CREATE TABLE sec.UserRole (
    UserRoleId UNIQUEIDENTIFIER NOT NULL PRIMARY KEY DEFAULT NEWID(),
    UserId UNIQUEIDENTIFIER NOT NULL,
    RoleId UNIQUEIDENTIFIER NOT NULL,
    AreaId UNIQUEIDENTIFIER,
    SystemId UNIQUEIDENTIFIER,
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
    CONSTRAINT FK_UserRole_User FOREIGN KEY (UserId) REFERENCES sec.[User](UserId),
    CONSTRAINT FK_UserRole_Role FOREIGN KEY (RoleId) REFERENCES sec.[Role](RoleId),
    CONSTRAINT FK_UserRole_Area FOREIGN KEY (AreaId) REFERENCES gov.Area(AreaId),
    CONSTRAINT FK_UserRole_System FOREIGN KEY (SystemId) REFERENCES syst.[System](SystemId),
    CONSTRAINT CK_UserRole_Dates CHECK (EffectiveTo IS NULL OR EffectiveTo >= EffectiveFrom)
);
GO

CREATE INDEX IX_UserRole_UserId ON sec.UserRole(UserId) WHERE IsDeleted = 0;
CREATE INDEX IX_UserRole_RoleId ON sec.UserRole(RoleId) WHERE IsDeleted = 0;
CREATE INDEX IX_UserRole_AreaId ON sec.UserRole(AreaId) WHERE IsDeleted = 0;
CREATE INDEX IX_UserRole_SystemId ON sec.UserRole(SystemId) WHERE IsDeleted = 0;
CREATE INDEX IX_UserRole_Active ON sec.UserRole(UserId, RoleId) WHERE IsDeleted = 0 AND IsActive = 1;
GO

-- PriorityChangeAuthorization (Autorização para Mudança de Prioridade)
CREATE TABLE sec.PriorityChangeAuthorization (
    PriorityChangeAuthorizationId UNIQUEIDENTIFIER NOT NULL PRIMARY KEY DEFAULT NEWID(),
    UserId UNIQUEIDENTIFIER NOT NULL,
    AreaId UNIQUEIDENTIFIER,
    FromPriorityId UNIQUEIDENTIFIER,
    ToPriorityId UNIQUEIDENTIFIER,
    RequiresJustification BIT NOT NULL DEFAULT 1,
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
    CONSTRAINT FK_PriorityAuth_User FOREIGN KEY (UserId) REFERENCES sec.[User](UserId),
    CONSTRAINT FK_PriorityAuth_Area FOREIGN KEY (AreaId) REFERENCES gov.Area(AreaId),
    CONSTRAINT FK_PriorityAuth_FromPriority FOREIGN KEY (FromPriorityId) REFERENCES ref.Priority(PriorityId),
    CONSTRAINT FK_PriorityAuth_ToPriority FOREIGN KEY (ToPriorityId) REFERENCES ref.Priority(PriorityId)
);
GO

CREATE INDEX IX_PriorityAuth_UserId ON sec.PriorityChangeAuthorization(UserId) WHERE IsDeleted = 0;
CREATE INDEX IX_PriorityAuth_AreaId ON sec.PriorityChangeAuthorization(AreaId) WHERE IsDeleted = 0;
GO
