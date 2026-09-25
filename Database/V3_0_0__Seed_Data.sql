-- =============================================
-- DevFlow - Seed Data (Dados Iniciais)
-- Version: 3.0.0
-- Description: Dados padrão para inicialização do sistema
-- =============================================

-- Usuário Sistema para criação inicial
DECLARE @SystemUserId UNIQUEIDENTIFIER = '00000000-0000-0000-0000-000000000001';

-- =============================================
-- 1. PRIORIDADES
-- =============================================
INSERT INTO ref.Priority (PriorityId, Code, Name, Description, SLADays, ColorHex, DisplayOrder, IsActive, CreatedAt, CreatedBy, IsDeleted)
VALUES
    (NEWID(), 'LOW', 'Baixa', 'Prioridade baixa - pode aguardar', 90, '#28A745', 1, 1, GETUTCDATE(), @SystemUserId, 0),
    (NEWID(), 'MEDIUM', 'Média', 'Prioridade média - prazo normal', 45, '#FFC107', 2, 1, GETUTCDATE(), @SystemUserId, 0),
    (NEWID(), 'HIGH', 'Alta', 'Prioridade alta - urgente', 15, '#FF9800', 3, 1, GETUTCDATE(), @SystemUserId, 0),
    (NEWID(), 'CRITICAL', 'Crítica', 'Prioridade crítica - emergencial', 5, '#DC3545', 4, 1, GETUTCDATE(), @SystemUserId, 0);
GO

-- Usuário Sistema para criação inicial
DECLARE @SystemUserId UNIQUEIDENTIFIER = '00000000-0000-0000-0000-000000000001';

-- =============================================
-- 2. TIPOS DE DEMANDA
-- =============================================
INSERT INTO ref.DemandType (DemandTypeId, Code, Name, Description, RequiresImpactAnalysis, RequiresSecurityReview, IsActive, CreatedAt, CreatedBy, IsDeleted)
VALUES
    (NEWID(), 'NEW_FEATURE', 'Nova Funcionalidade', 'Inclusão de nova feature no sistema', 1, 1, 1, GETUTCDATE(), @SystemUserId, 0),
    (NEWID(), 'INTEGRATION_INTERNAL', 'Integração Interna', 'Integração com outros sistemas internos', 1, 1, 1, GETUTCDATE(), @SystemUserId, 0),
    (NEWID(), 'INTEGRATION_CLIENT', 'Integração Cliente', 'Integração com sistemas de clientes', 1, 1, 1, GETUTCDATE(), @SystemUserId, 0),
    (NEWID(), 'INTEGRATION_VENDOR', 'Integração Fornecedor', 'Integração com sistemas de fornecedores', 1, 1, 1, GETUTCDATE(), @SystemUserId, 0),
    (NEWID(), 'AUTOMATION_SYSTEM', 'Automação de Sistema', 'Automação de processos dentro de sistemas', 1, 0, 1, GETUTCDATE(), @SystemUserId, 0),
    (NEWID(), 'AUTOMATION_MANUAL', 'Automação Manual', 'Automação de processos manuais com planilhas', 0, 0, 1, GETUTCDATE(), @SystemUserId, 0),
    (NEWID(), 'IMPROVEMENT', 'Melhoria', 'Melhorias de features já existentes', 0, 0, 1, GETUTCDATE(), @SystemUserId, 0),
    (NEWID(), 'CHANGE', 'Alteração', 'Alteração de features já existentes', 1, 0, 1, GETUTCDATE(), @SystemUserId, 0),
    (NEWID(), 'BUGFIX', 'Correção de Bug', 'Correção de defeitos', 0, 0, 1, GETUTCDATE(), @SystemUserId, 0);
GO

-- Usuário Sistema para criação inicial
DECLARE @SystemUserId UNIQUEIDENTIFIER = '00000000-0000-0000-0000-000000000001';

-- =============================================
-- 3. STATUS DE WORKFLOW
-- =============================================

-- Status para BusinessCase
INSERT INTO ref.WorkflowStatus (WorkflowStatusId, EntityType, Code, Name, Description, IsFinal, IsRejection, DisplayOrder, ColorHex, IsActive, CreatedAt, CreatedBy, IsDeleted)
VALUES
    (NEWID(), 'BusinessCase', 'DRAFT', 'Rascunho', 'Business case em elaboração', 0, 0, 1, '#6C757D', 1, GETUTCDATE(), @SystemUserId, 0),
    (NEWID(), 'BusinessCase', 'PENDING_APPROVAL', 'Pendente Aprovação', 'Aguardando aprovação', 0, 0, 2, '#FFC107', 1, GETUTCDATE(), @SystemUserId, 0),
    (NEWID(), 'BusinessCase', 'APPROVED', 'Aprovado', 'Business case aprovado', 1, 0, 3, '#28A745', 1, GETUTCDATE(), @SystemUserId, 0),
    (NEWID(), 'BusinessCase', 'REJECTED', 'Rejeitado', 'Business case rejeitado', 1, 1, 4, '#DC3545', 1, GETUTCDATE(), @SystemUserId, 0);

-- Status para Demand
INSERT INTO ref.WorkflowStatus (WorkflowStatusId, EntityType, Code, Name, Description, IsFinal, IsRejection, DisplayOrder, ColorHex, IsActive, CreatedAt, CreatedBy, IsDeleted)
VALUES
    (NEWID(), 'Demand', 'DRAFT', 'Rascunho', 'Demanda em elaboração', 0, 0, 1, '#6C757D', 1, GETUTCDATE(), @SystemUserId, 0),
    (NEWID(), 'Demand', 'PENDING_APPROVAL', 'Pendente Aprovação', 'Aguardando aprovação', 0, 0, 2, '#FFC107', 1, GETUTCDATE(), @SystemUserId, 0),
    (NEWID(), 'Demand', 'APPROVED', 'Aprovado', 'Demanda aprovada', 0, 0, 3, '#28A745', 1, GETUTCDATE(), @SystemUserId, 0),
    (NEWID(), 'Demand', 'IN_ANALYSIS', 'Em Análise', 'Em análise de requisitos', 0, 0, 4, '#17A2B8', 1, GETUTCDATE(), @SystemUserId, 0),
    (NEWID(), 'Demand', 'IN_DEVELOPMENT', 'Em Desenvolvimento', 'Em desenvolvimento', 0, 0, 5, '#007BFF', 1, GETUTCDATE(), @SystemUserId, 0),
    (NEWID(), 'Demand', 'IN_TEST', 'Em Teste', 'Em fase de testes', 0, 0, 6, '#6F42C1', 1, GETUTCDATE(), @SystemUserId, 0),
    (NEWID(), 'Demand', 'DONE', 'Concluído', 'Demanda concluída', 1, 0, 7, '#28A745', 1, GETUTCDATE(), @SystemUserId, 0),
    (NEWID(), 'Demand', 'REJECTED', 'Rejeitado', 'Demanda rejeitada', 1, 1, 8, '#DC3545', 1, GETUTCDATE(), @SystemUserId, 0),
    (NEWID(), 'Demand', 'CANCELLED', 'Cancelado', 'Demanda cancelada', 1, 0, 9, '#6C757D', 1, GETUTCDATE(), @SystemUserId, 0);

-- Status para Requirement
INSERT INTO ref.WorkflowStatus (WorkflowStatusId, EntityType, Code, Name, Description, IsFinal, IsRejection, DisplayOrder, ColorHex, IsActive, CreatedAt, CreatedBy, IsDeleted)
VALUES
    (NEWID(), 'Requirement', 'DRAFT', 'Rascunho', 'Requisito em elaboração', 0, 0, 1, '#6C757D', 1, GETUTCDATE(), @SystemUserId, 0),
    (NEWID(), 'Requirement', 'IN_REVIEW', 'Em Revisão', 'Requisito em revisão', 0, 0, 2, '#FFC107', 1, GETUTCDATE(), @SystemUserId, 0),
    (NEWID(), 'Requirement', 'APPROVED', 'Aprovado', 'Requisito aprovado', 1, 0, 3, '#28A745', 1, GETUTCDATE(), @SystemUserId, 0),
    (NEWID(), 'Requirement', 'REJECTED', 'Rejeitado', 'Requisito rejeitado', 1, 1, 4, '#DC3545', 1, GETUTCDATE(), @SystemUserId, 0);

-- Status para UseCase
INSERT INTO ref.WorkflowStatus (WorkflowStatusId, EntityType, Code, Name, Description, IsFinal, IsRejection, DisplayOrder, ColorHex, IsActive, CreatedAt, CreatedBy, IsDeleted)
VALUES
    (NEWID(), 'UseCase', 'DRAFT', 'Rascunho', 'Caso de uso em elaboração', 0, 0, 1, '#6C757D', 1, GETUTCDATE(), @SystemUserId, 0),
    (NEWID(), 'UseCase', 'IN_REVIEW', 'Em Revisão', 'Caso de uso em revisão', 0, 0, 2, '#FFC107', 1, GETUTCDATE(), @SystemUserId, 0),
    (NEWID(), 'UseCase', 'APPROVED', 'Aprovado', 'Caso de uso aprovado', 1, 0, 3, '#28A745', 1, GETUTCDATE(), @SystemUserId, 0),
    (NEWID(), 'UseCase', 'REJECTED', 'Rejeitado', 'Caso de uso rejeitado', 1, 1, 4, '#DC3545', 1, GETUTCDATE(), @SystemUserId, 0);

-- Status para UserStory
INSERT INTO ref.WorkflowStatus (WorkflowStatusId, EntityType, Code, Name, Description, IsFinal, IsRejection, DisplayOrder, ColorHex, IsActive, CreatedAt, CreatedBy, IsDeleted)
VALUES
    (NEWID(), 'UserStory', 'DRAFT', 'Rascunho', 'User story em elaboração', 0, 0, 1, '#6C757D', 1, GETUTCDATE(), @SystemUserId, 0),
    (NEWID(), 'UserStory', 'IN_REVIEW', 'Em Revisão', 'User story em revisão', 0, 0, 2, '#FFC107', 1, GETUTCDATE(), @SystemUserId, 0),
    (NEWID(), 'UserStory', 'APPROVED', 'Aprovado', 'User story aprovado', 0, 0, 3, '#28A745', 1, GETUTCDATE(), @SystemUserId, 0),
    (NEWID(), 'UserStory', 'IN_SPRINT', 'Na Sprint', 'User story em sprint', 0, 0, 4, '#007BFF', 1, GETUTCDATE(), @SystemUserId, 0),
    (NEWID(), 'UserStory', 'DONE', 'Concluído', 'User story concluído', 1, 0, 5, '#28A745', 1, GETUTCDATE(), @SystemUserId, 0),
    (NEWID(), 'UserStory', 'REJECTED', 'Rejeitado', 'User story rejeitado', 1, 1, 6, '#DC3545', 1, GETUTCDATE(), @SystemUserId, 0);

-- Status para Estimate
INSERT INTO ref.WorkflowStatus (WorkflowStatusId, EntityType, Code, Name, Description, IsFinal, IsRejection, DisplayOrder, ColorHex, IsActive, CreatedAt, CreatedBy, IsDeleted)
VALUES
    (NEWID(), 'Estimate', 'DRAFT', 'Rascunho', 'Estimativa em elaboração', 0, 0, 1, '#6C757D', 1, GETUTCDATE(), @SystemUserId, 0),
    (NEWID(), 'Estimate', 'IN_REVIEW', 'Em Revisão', 'Estimativa em revisão', 0, 0, 2, '#FFC107', 1, GETUTCDATE(), @SystemUserId, 0),
    (NEWID(), 'Estimate', 'APPROVED', 'Aprovado', 'Estimativa aprovada', 1, 0, 3, '#28A745', 1, GETUTCDATE(), @SystemUserId, 0),
    (NEWID(), 'Estimate', 'REJECTED', 'Rejeitado', 'Estimativa rejeitada', 1, 1, 4, '#DC3545', 1, GETUTCDATE(), @SystemUserId, 0);
GO

-- Usuário Sistema para criação inicial
DECLARE @SystemUserId UNIQUEIDENTIFIER = '00000000-0000-0000-0000-000000000001';

-- =============================================
-- 4. COMPLEXIDADE DE ATORES (UCP)
-- =============================================
INSERT INTO ref.ActorComplexity (ActorComplexityId, Code, Name, Description, WeightFactor, DisplayOrder, IsActive, CreatedAt, CreatedBy, IsDeleted)
VALUES
    (NEWID(), 'SIMPLE', 'Simples', 'Ator simples - API definida', 1.00, 1, 1, GETUTCDATE(), @SystemUserId, 0),
    (NEWID(), 'AVERAGE', 'Médio', 'Ator médio - protocolo ou interface', 2.00, 2, 1, GETUTCDATE(), @SystemUserId, 0),
    (NEWID(), 'COMPLEX', 'Complexo', 'Ator complexo - interface gráfica', 3.00, 3, 1, GETUTCDATE(), @SystemUserId, 0);
GO

-- Usuário Sistema para criação inicial
DECLARE @SystemUserId UNIQUEIDENTIFIER = '00000000-0000-0000-0000-000000000001';

-- =============================================
-- 5. COMPLEXIDADE DE CASOS DE USO (UCP)
-- =============================================
INSERT INTO ref.UseCaseComplexity (UseCaseComplexityId, Code, Name, Description, TransactionMin, TransactionMax, WeightFactor, DisplayOrder, IsActive, CreatedAt, CreatedBy, IsDeleted)
VALUES
    (NEWID(), 'SIMPLE', 'Simples', 'Caso de uso simples - 1 a 3 transações', 1, 3, 5.00, 1, 1, GETUTCDATE(), @SystemUserId, 0),
    (NEWID(), 'AVERAGE', 'Médio', 'Caso de uso médio - 4 a 7 transações', 4, 7, 10.00, 2, 1, GETUTCDATE(), @SystemUserId, 0),
    (NEWID(), 'COMPLEX', 'Complexo', 'Caso de uso complexo - 8+ transações', 8, 999, 15.00, 3, 1, GETUTCDATE(), @SystemUserId, 0);
GO

-- Usuário Sistema para criação inicial
DECLARE @SystemUserId UNIQUEIDENTIFIER = '00000000-0000-0000-0000-000000000001';

-- =============================================
-- 6. CONFIGURAÇÃO UCP PADRÃO
-- =============================================
INSERT INTO cfg.UCPConfiguration (UCPConfigurationId, Name, Description, HoursPerUCP, DevelopmentPercentage, TestPercentage, HomologationPercentage, HourlyRate, EffectiveFrom, EffectiveTo, IsActive, CreatedAt, CreatedBy, IsDeleted)
VALUES
    (NEWID(), 'Configuração Padrão 2026', 'Configuração padrão de UCP para 2026', 20.00, 60.00, 20.00, 20.00, 150.00, '2026-01-01', NULL, 1, GETUTCDATE(), @SystemUserId, 0);
GO

-- Usuário Sistema para criação inicial
DECLARE @SystemUserId UNIQUEIDENTIFIER = '00000000-0000-0000-0000-000000000001';

-- =============================================
-- 7. ROLES PADRÃO
-- =============================================
INSERT INTO sec.[Role] (RoleId, Code, Name, Description, IsSystemRole, IsActive, CreatedAt, CreatedBy, IsDeleted)
VALUES
    (NEWID(), 'ADMIN', 'Administrador', 'Administrador do sistema com acesso total', 1, 1, GETUTCDATE(), @SystemUserId, 0),
    (NEWID(), 'PO', 'Product Owner', 'Product Owner - gerencia backlog e prioridades', 1, 1, GETUTCDATE(), @SystemUserId, 0),
    (NEWID(), 'SM', 'Scrum Master', 'Scrum Master - facilita processos ágeis', 1, 1, GETUTCDATE(), @SystemUserId, 0),
    (NEWID(), 'BA', 'Business Analyst', 'Analista de Negócios - elabora requisitos', 1, 1, GETUTCDATE(), @SystemUserId, 0),
    (NEWID(), 'DEV', 'Developer', 'Desenvolvedor - implementa soluções', 1, 1, GETUTCDATE(), @SystemUserId, 0),
    (NEWID(), 'QA', 'Quality Analyst', 'Analista de Qualidade - testa soluções', 1, 1, GETUTCDATE(), @SystemUserId, 0),
    (NEWID(), 'REQUESTER', 'Solicitante', 'Solicitante de demandas', 1, 1, GETUTCDATE(), @SystemUserId, 0),
    (NEWID(), 'APPROVER', 'Aprovador', 'Aprovador de demandas e requisitos', 1, 1, GETUTCDATE(), @SystemUserId, 0),
    (NEWID(), 'VIEWER', 'Visualizador', 'Visualizador - apenas leitura', 1, 1, GETUTCDATE(), @SystemUserId, 0);
GO

-- Usuário Sistema para criação inicial
DECLARE @SystemUserId UNIQUEIDENTIFIER = '00000000-0000-0000-0000-000000000001';

-- =============================================
-- 8. PERMISSIONS BÁSICAS
-- =============================================
INSERT INTO sec.Permission (PermissionId, Code, Name, Description, ResourceType, ActionType, IsActive, CreatedAt, CreatedBy, IsDeleted)
VALUES
    -- Demand
    (NEWID(), 'DEMAND_CREATE', 'Criar Demanda', 'Permissão para criar demandas', 'Demand', 'Create', 1, GETUTCDATE(), @SystemUserId, 0),
    (NEWID(), 'DEMAND_READ', 'Visualizar Demanda', 'Permissão para visualizar demandas', 'Demand', 'Read', 1, GETUTCDATE(), @SystemUserId, 0),
    (NEWID(), 'DEMAND_UPDATE', 'Editar Demanda', 'Permissão para editar demandas', 'Demand', 'Update', 1, GETUTCDATE(), @SystemUserId, 0),
    (NEWID(), 'DEMAND_DELETE', 'Excluir Demanda', 'Permissão para excluir demandas', 'Demand', 'Delete', 1, GETUTCDATE(), @SystemUserId, 0),
    (NEWID(), 'DEMAND_APPROVE', 'Aprovar Demanda', 'Permissão para aprovar demandas', 'Demand', 'Approve', 1, GETUTCDATE(), @SystemUserId, 0),
    (NEWID(), 'DEMAND_PRIORITIZE', 'Priorizar Demanda', 'Permissão para alterar prioridade de demandas', 'Demand', 'Prioritize', 1, GETUTCDATE(), @SystemUserId, 0),
    -- Requirement
    (NEWID(), 'REQUIREMENT_CREATE', 'Criar Requisito', 'Permissão para criar requisitos', 'Requirement', 'Create', 1, GETUTCDATE(), @SystemUserId, 0),
    (NEWID(), 'REQUIREMENT_READ', 'Visualizar Requisito', 'Permissão para visualizar requisitos', 'Requirement', 'Read', 1, GETUTCDATE(), @SystemUserId, 0),
    (NEWID(), 'REQUIREMENT_UPDATE', 'Editar Requisito', 'Permissão para editar requisitos', 'Requirement', 'Update', 1, GETUTCDATE(), @SystemUserId, 0),
    (NEWID(), 'REQUIREMENT_APPROVE', 'Aprovar Requisito', 'Permissão para aprovar requisitos', 'Requirement', 'Approve', 1, GETUTCDATE(), @SystemUserId, 0),
    -- UserStory
    (NEWID(), 'USERSTORY_CREATE', 'Criar User Story', 'Permissão para criar user stories', 'UserStory', 'Create', 1, GETUTCDATE(), @SystemUserId, 0),
    (NEWID(), 'USERSTORY_READ', 'Visualizar User Story', 'Permissão para visualizar user stories', 'UserStory', 'Read', 1, GETUTCDATE(), @SystemUserId, 0),
    (NEWID(), 'USERSTORY_UPDATE', 'Editar User Story', 'Permissão para editar user stories', 'UserStory', 'Update', 1, GETUTCDATE(), @SystemUserId, 0),
    (NEWID(), 'USERSTORY_APPROVE', 'Aprovar User Story', 'Permissão para aprovar user stories', 'UserStory', 'Approve', 1, GETUTCDATE(), @SystemUserId, 0),
    -- Estimate
    (NEWID(), 'ESTIMATE_CREATE', 'Criar Estimativa', 'Permissão para criar estimativas', 'Estimate', 'Create', 1, GETUTCDATE(), @SystemUserId, 0),
    (NEWID(), 'ESTIMATE_READ', 'Visualizar Estimativa', 'Permissão para visualizar estimativas', 'Estimate', 'Read', 1, GETUTCDATE(), @SystemUserId, 0),
    (NEWID(), 'ESTIMATE_UPDATE', 'Editar Estimativa', 'Permissão para editar estimativas', 'Estimate', 'Update', 1, GETUTCDATE(), @SystemUserId, 0),
    (NEWID(), 'ESTIMATE_APPROVE', 'Aprovar Estimativa', 'Permissão para aprovar estimativas', 'Estimate', 'Approve', 1, GETUTCDATE(), @SystemUserId, 0);
GO


PRINT 'Seed data inserido com sucesso!';
GO
