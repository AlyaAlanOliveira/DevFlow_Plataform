-- =============================================
-- DevFlow - System Catalog (Catálogo de Sistemas)
-- Version: 1.7.0
-- Description: Catálogo de sistemas com fatores técnicos UCP e integrações
-- =============================================

-- System (Sistemas)
CREATE TABLE syst.[System] (
    SystemId UNIQUEIDENTIFIER NOT NULL PRIMARY KEY DEFAULT NEWID(),
    CompanyId UNIQUEIDENTIFIER NOT NULL,
    Code VARCHAR(20) NOT NULL,
    Name NVARCHAR(200) NOT NULL,
    Description NVARCHAR(2000),
    CurrentVersion VARCHAR(50),
    Architecture NVARCHAR(500),
    TechnologyStack NVARCHAR(1000),
    RepositoryUrl NVARCHAR(500),
    DocumentationUrl NVARCHAR(500),
    -- Criticidade
    CriticalityLevel VARCHAR(20) NOT NULL DEFAULT 'Medium',
    -- LGPD
    HasSensitiveData BIT NOT NULL DEFAULT 0,
    LGPDClassification VARCHAR(30),
    -- Fatores Técnicos (TCF) - UCP (escala 0-5)
    -- TF1: Sistema distribuído
    TF1_DistributedSystem DECIMAL(3,2) DEFAULT 3.00,
    -- TF2: Tempo de resposta ou throughput
    TF2_ResponseTime DECIMAL(3,2) DEFAULT 3.00,
    -- TF3: Eficiência do usuário final
    TF3_EndUserEfficiency DECIMAL(3,2) DEFAULT 3.00,
    -- TF4: Processamento complexo
    TF4_ComplexProcessing DECIMAL(3,2) DEFAULT 3.00,
    -- TF5: Reusabilidade
    TF5_Reusability DECIMAL(3,2) DEFAULT 3.00,
    -- TF6: Facilidade de instalação
    TF6_EasyToInstall DECIMAL(3,2) DEFAULT 3.00,
    -- TF7: Facilidade de uso
    TF7_EasyToUse DECIMAL(3,2) DEFAULT 3.00,
    -- TF8: Portabilidade
    TF8_Portability DECIMAL(3,2) DEFAULT 3.00,
    -- TF9: Facilidade de mudança
    TF9_EasyToChange DECIMAL(3,2) DEFAULT 3.00,
    -- TF10: Concorrência
    TF10_Concurrent DECIMAL(3,2) DEFAULT 3.00,
    -- TF11: Segurança
    TF11_Security DECIMAL(3,2) DEFAULT 3.00,
    -- TF12: Acesso de terceiros
    TF12_ThirdPartyAccess DECIMAL(3,2) DEFAULT 3.00,
    -- TF13: Treinamento especial
    TF13_Training DECIMAL(3,2) DEFAULT 3.00,
    -- Gestão
    OwnerUserId UNIQUEIDENTIFIER,
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
    CONSTRAINT FK_System_Company FOREIGN KEY (CompanyId) REFERENCES gov.Company(CompanyId),
    CONSTRAINT FK_System_Owner FOREIGN KEY (OwnerUserId) REFERENCES sec.[User](UserId),
    CONSTRAINT UK_System_Code UNIQUE (CompanyId, Code),
    CONSTRAINT CK_System_CriticalityLevel CHECK (CriticalityLevel IN ('Low','Medium','High','Critical')),
    CONSTRAINT CK_System_LGPDClassification CHECK (LGPDClassification IS NULL OR LGPDClassification IN ('Public','Internal','Confidential','Restricted')),
    -- Validações dos fatores técnicos (0-5)
    CONSTRAINT CK_System_TF1 CHECK (TF1_DistributedSystem BETWEEN 0 AND 5),
    CONSTRAINT CK_System_TF2 CHECK (TF2_ResponseTime BETWEEN 0 AND 5),
    CONSTRAINT CK_System_TF3 CHECK (TF3_EndUserEfficiency BETWEEN 0 AND 5),
    CONSTRAINT CK_System_TF4 CHECK (TF4_ComplexProcessing BETWEEN 0 AND 5),
    CONSTRAINT CK_System_TF5 CHECK (TF5_Reusability BETWEEN 0 AND 5),
    CONSTRAINT CK_System_TF6 CHECK (TF6_EasyToInstall BETWEEN 0 AND 5),
    CONSTRAINT CK_System_TF7 CHECK (TF7_EasyToUse BETWEEN 0 AND 5),
    CONSTRAINT CK_System_TF8 CHECK (TF8_Portability BETWEEN 0 AND 5),
    CONSTRAINT CK_System_TF9 CHECK (TF9_EasyToChange BETWEEN 0 AND 5),
    CONSTRAINT CK_System_TF10 CHECK (TF10_Concurrent BETWEEN 0 AND 5),
    CONSTRAINT CK_System_TF11 CHECK (TF11_Security BETWEEN 0 AND 5),
    CONSTRAINT CK_System_TF12 CHECK (TF12_ThirdPartyAccess BETWEEN 0 AND 5),
    CONSTRAINT CK_System_TF13 CHECK (TF13_Training BETWEEN 0 AND 5)
);
GO

CREATE INDEX IX_System_CompanyId ON syst.[System](CompanyId) WHERE IsDeleted = 0;
CREATE INDEX IX_System_Code ON syst.[System](Code) WHERE IsDeleted = 0;
CREATE INDEX IX_System_OwnerUserId ON syst.[System](OwnerUserId) WHERE IsDeleted = 0;
CREATE INDEX IX_System_CriticalityLevel ON syst.[System](CriticalityLevel) WHERE IsDeleted = 0;
CREATE INDEX IX_System_HasSensitiveData ON syst.[System](HasSensitiveData) WHERE IsDeleted = 0;
GO

-- SystemIntegration (Integrações entre Sistemas)
CREATE TABLE syst.SystemIntegration (
    SystemIntegrationId UNIQUEIDENTIFIER NOT NULL PRIMARY KEY DEFAULT NEWID(),
    SourceSystemId UNIQUEIDENTIFIER NOT NULL,
    TargetSystemId UNIQUEIDENTIFIER NOT NULL,
    IntegrationType VARCHAR(30) NOT NULL,
    Protocol VARCHAR(30),
    Description NVARCHAR(1000),
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
    CONSTRAINT FK_SystemIntegration_Source FOREIGN KEY (SourceSystemId) REFERENCES syst.[System](SystemId),
    CONSTRAINT FK_SystemIntegration_Target FOREIGN KEY (TargetSystemId) REFERENCES syst.[System](SystemId),
    CONSTRAINT CK_SystemIntegration_Type CHECK (IntegrationType IN ('API','Database','File','MessageQueue','WebService','Batch')),
    CONSTRAINT CK_SystemIntegration_Protocol CHECK (Protocol IS NULL OR Protocol IN ('REST','SOAP','GraphQL','gRPC','SFTP','FTP','AMQP','MQTT','JDBC','ODBC')),
    CONSTRAINT CK_SystemIntegration_NotSelf CHECK (SourceSystemId <> TargetSystemId)
);
GO

CREATE INDEX IX_SystemIntegration_SourceSystemId ON syst.SystemIntegration(SourceSystemId) WHERE IsDeleted = 0;
CREATE INDEX IX_SystemIntegration_TargetSystemId ON syst.SystemIntegration(TargetSystemId) WHERE IsDeleted = 0;
CREATE INDEX IX_SystemIntegration_Type ON syst.SystemIntegration(IntegrationType) WHERE IsDeleted = 0;
GO
