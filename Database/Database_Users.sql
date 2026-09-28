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

GRANT SELECT ON SCHEMA::ref TO [DevFlowUser];
GRANT SELECT ON SCHEMA::cfg TO [DevFlowUser];
GRANT SELECT ON SCHEMA::sec TO [DevFlowUser];
GRANT SELECT ON SCHEMA::gov TO [DevFlowUser];
GRANT SELECT ON SCHEMA::syst TO [DevFlowUser];
GRANT SELECT ON SCHEMA::portfolio TO [DevFlowUser];
GRANT SELECT ON SCHEMA::workflow TO [DevFlowUser];
GRANT SELECT ON SCHEMA::req TO [DevFlowUser];
GRANT SELECT ON SCHEMA::agile TO [DevFlowUser];
GRANT SELECT ON SCHEMA::ucp TO [DevFlowUser];
GRANT SELECT ON SCHEMA::qa TO [DevFlowUser];
GRANT SELECT ON SCHEMA::release TO [DevFlowUser];
GRANT SELECT ON SCHEMA::files TO [DevFlowUser];
GRANT SELECT ON SCHEMA::ai TO [DevFlowUser];
GRANT SELECT ON SCHEMA::audit TO [DevFlowUser];
GRANT SELECT ON SCHEMA::bi TO [DevFlowUser];

GRANT INSERT ON SCHEMA::ref TO [DevFlowUser];
GRANT INSERT ON SCHEMA::cfg TO [DevFlowUser];
GRANT INSERT ON SCHEMA::sec TO [DevFlowUser];
GRANT INSERT ON SCHEMA::gov TO [DevFlowUser];
GRANT INSERT ON SCHEMA::syst TO [DevFlowUser];
GRANT INSERT ON SCHEMA::portfolio TO [DevFlowUser];
GRANT INSERT ON SCHEMA::workflow TO [DevFlowUser];
GRANT INSERT ON SCHEMA::req TO [DevFlowUser];
GRANT INSERT ON SCHEMA::agile TO [DevFlowUser];
GRANT INSERT ON SCHEMA::ucp TO [DevFlowUser];
GRANT INSERT ON SCHEMA::qa TO [DevFlowUser];
GRANT INSERT ON SCHEMA::release TO [DevFlowUser];
GRANT INSERT ON SCHEMA::files TO [DevFlowUser];
GRANT INSERT ON SCHEMA::ai TO [DevFlowUser];
GRANT INSERT ON SCHEMA::audit TO [DevFlowUser];
GRANT INSERT ON SCHEMA::bi TO [DevFlowUser];

GRANT UPDATE ON SCHEMA::ref TO [DevFlowUser];
GRANT UPDATE ON SCHEMA::cfg TO [DevFlowUser];
GRANT UPDATE ON SCHEMA::sec TO [DevFlowUser];
GRANT UPDATE ON SCHEMA::gov TO [DevFlowUser];
GRANT UPDATE ON SCHEMA::syst TO [DevFlowUser];
GRANT UPDATE ON SCHEMA::portfolio TO [DevFlowUser];
GRANT UPDATE ON SCHEMA::workflow TO [DevFlowUser];
GRANT UPDATE ON SCHEMA::req TO [DevFlowUser];
GRANT UPDATE ON SCHEMA::agile TO [DevFlowUser];
GRANT UPDATE ON SCHEMA::ucp TO [DevFlowUser];
GRANT UPDATE ON SCHEMA::qa TO [DevFlowUser];
GRANT UPDATE ON SCHEMA::release TO [DevFlowUser];
GRANT UPDATE ON SCHEMA::files TO [DevFlowUser];
GRANT UPDATE ON SCHEMA::ai TO [DevFlowUser];
GRANT UPDATE ON SCHEMA::audit TO [DevFlowUser];
GRANT UPDATE ON SCHEMA::bi TO [DevFlowUser];

GRANT EXECUTE ON SCHEMA::ref TO [DevFlowUser];
GRANT EXECUTE ON SCHEMA::cfg TO [DevFlowUser];
GRANT EXECUTE ON SCHEMA::sec TO [DevFlowUser];
GRANT EXECUTE ON SCHEMA::gov TO [DevFlowUser];
GRANT EXECUTE ON SCHEMA::syst TO [DevFlowUser];
GRANT EXECUTE ON SCHEMA::portfolio TO [DevFlowUser];
GRANT EXECUTE ON SCHEMA::workflow TO [DevFlowUser];
GRANT EXECUTE ON SCHEMA::req TO [DevFlowUser];
GRANT EXECUTE ON SCHEMA::agile TO [DevFlowUser];
GRANT EXECUTE ON SCHEMA::ucp TO [DevFlowUser];
GRANT EXECUTE ON SCHEMA::qa TO [DevFlowUser];
GRANT EXECUTE ON SCHEMA::release TO [DevFlowUser];
GRANT EXECUTE ON SCHEMA::files TO [DevFlowUser];
GRANT EXECUTE ON SCHEMA::ai TO [DevFlowUser];
GRANT EXECUTE ON SCHEMA::audit TO [DevFlowUser];
GRANT EXECUTE ON SCHEMA::bi TO [DevFlowUser];