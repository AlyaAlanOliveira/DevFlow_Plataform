CREATE LOGIN DevFlowAdm WITH PASSWORD = 'D3vFl0w#Aly@';
CREATE USER DevFlowAdm FOR LOGIN DevFlowAdm;

-- Concedendo permissões no banco de dados
USE DevFlow_ALYA;

-- Permissões para criar e alterar objetos
GRANT CREATE TABLE TO DevFlowAdm;
GRANT CREATE VIEW TO DevFlowAdm;
GRANT CREATE PROCEDURE TO DevFlowAdm;
GRANT CREATE FUNCTION TO DevFlowAdm;
GRANT ALTER TO DevFlowAdm;

GRANT ALTER ON SCHEMA::devflow TO DevFlowAdm;

-- Criação do login e usuário
CREATE LOGIN DevFlowUser WITH PASSWORD = 'D3vFl0w#Us3r35';
CREATE USER DevFlowUser FOR LOGIN DevFlowUser;

-- Concedendo permissões no banco de dados
USE DevFlow_ALYA;

-- Permissões para manipular dados
GRANT SELECT ON SCHEMA::devflow TO [DevFlowUser];
GRANT INSERT ON SCHEMA::devflow TO [DevFlowUser];
GRANT UPDATE ON SCHEMA::devflow TO [DevFlowUser];
GRANT EXECUTE ON SCHEMA::devflow TO [DevFlowUser];

