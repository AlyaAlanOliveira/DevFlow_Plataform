-- =============================================
-- DevFlow ALYA - Consultar CompanyId da ALYA
-- =============================================

USE DevFlow_ALYA;
GO

-- Buscar o CompanyId da empresa ALYA
SELECT 
    CompanyId,
    Nome,
    Sigla,
    CNPJ,
    IsActive
FROM gov.Company
WHERE Sigla = 'ALYA'
AND IsDeleted = 0;

-- Resultado esperado:
-- CompanyId: [UUID gerado dinamicamente]
-- Nome: ALYA Serviços e Logística LTDA
-- Sigla: ALYA
-- CNPJ: 12.345.678/0001-90
-- IsActive: 1
