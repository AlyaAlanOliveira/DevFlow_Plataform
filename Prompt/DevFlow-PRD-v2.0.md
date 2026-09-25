# DevFlow PRD v2.0

## Visão Estratégica

DevFlow é uma plataforma corporativa de Governança de Engenharia de Software do Grupo ALYA, suportando ALYA, Mobyan e TaNaPorta.

### Objetivos
- Governança ponta a ponta
- Engenharia de requisitos
- Estimativas UCP automatizadas
- Gestão ágil
- Release e GMUD
- Assistentes de IA

---

# Estrutura Organizacional

## Holding
- ALYA
- Mobyan
- TaNaPorta

## Hierarquia
Holding -> Empresa -> Diretoria -> Área -> Squad -> Usuário

### Regras
- Todo usuário pertence a uma empresa.
- Demandas podem impactar múltiplas empresas.
- Dashboards consolidados e por empresa.

---

# Segurança

## Autenticação
- Microsoft Entra ID
- SSO corporativo
- MFA controlado pelo Entra ID

## Autorização
RBAC baseado em perfis.

### Perfis
- ADMIN
- MANAGER
- PRODUCT_OWNER
- BUSINESS_ANALYST
- ARCHITECT
- DEVELOPER
- QA
- REQUESTER

---

# Domínio 1 - Governança

## Cadastro de Sistemas

### Dados Gerais
- Nome
- Sigla
- Empresa Proprietária
- Área Responsável
- Gestor
- Criticidade
- Status

### Características Técnicas
- Arquitetura
- Tecnologias
- APIs
- Integrações
- Mensageria
- MFA
- SSO
- Internet Facing
- LGPD
- Alta Disponibilidade

## Cadastro de Squads

### Squad Profile
- Nome
- Empresa
- Área
- Capacidade
- Velocity
- Scrum Master
- Product Owner
- Tech Lead

### Indicadores
- Conhecimento de Negócio
- Conhecimento dos Sistemas
- Conhecimento Técnico
- Maturidade Scrum
- Disponibilidade
- Produtividade

---

# Domínio 2 - Engenharia de Requisitos

## Fluxo Corporativo

1. Business Case
2. Demanda
3. Caso de Uso Macro
4. User Stories
5. Estimativa UCP
6. Planejamento
7. Desenvolvimento
8. Testes
9. Homologação
10. Release
11. GMUD
12. Produção

## Business Case

### Campos
- Problema
- Objetivo
- Benefício
- ROI
- TCO
- Payback
- Impacto Operacional
- Impacto Financeiro
- Impacto Estratégico

## Demanda

### Campos
- Número
- Título
- Descrição
- Área
- Sistema
- Prioridade
- Impacto
- Urgência
- Complexidade
- Solicitante

## Caso de Uso Macro

### Campos
- Objetivo
- Atores
- Fluxo Atual
- Fluxo Futuro
- Solução Proposta
- Premissas
- Restrições
- Dependências
- Riscos

## User Stories

Formato:

Como <perfil>
Quero <funcionalidade>
Para <benefício>

### Complementos
- Objetivo
- Regras de Negócio
- Critérios de Aceite
- Evidências

---

# Domínio 3 - Planejamento e Estimativas

## Modelo UCP

UCP = (UAW + UUCW) x TCF x EF

## Fontes de Informação

### Sistema
Alimenta fatores técnicos.

### Squad
Alimenta fatores ambientais.

### Demanda
Complementa fatores específicos.

## Perfil Técnico do Sistema

### Herdados Automaticamente
- Segurança
- Integrações
- Concorrência
- Portabilidade
- Ambiente Distribuído

## Perfil Ambiental da Squad

### Herdados Automaticamente
- Conhecimento Negócio
- Conhecimento Sistema
- Conhecimento Técnico
- Disponibilidade
- Velocity
- Maturidade Scrum

## Fatores Dependentes da Demanda
- Performance
- Usabilidade
- Complexidade
- Estabilidade dos Requisitos

## Distribuição de Esforço
- Concepção: 5%
- Elaboração: 35%
- Construção: 50%
- Transição: 10%

## Estimativa Financeira
- Horas
- Dias
- Recursos
- Valor Hora
- Investimento

---

# Domínio 4 - Execução

## Backlog
- Epic
- Feature
- User Story
- Task

## Sprint
- Início
- Fim
- Capacidade
- Objetivo
- Velocity

## Testes
- Unitário
- Integração
- Sistema
- Homologação

## Release
- Nome
- Versão
- Ambiente
- Responsável

## GMUD
- Janela
- Impacto
- Risco
- Rollback
- Validação

---

# Domínio 5 - Inteligência Artificial

## AI Demand Analyst
- Revisão da demanda
- Benefícios
- ROI

## AI Business Analyst
- Requisitos
- Casos de Uso

## AI Scrum Specialist
- Epic
- Feature
- Story
- Task

## AI UCP Specialist
- UAW
- UUCW
- TCF
- EF
- UCP
- Prazo
- Custo

## AI Architect
- Riscos
- Dependências
- Integrações

## AI Quality Reviewer
- Governança
- Consistência
- Auditoria

---

# Rastreabilidade

Holding
-> Empresa
-> Sistema
-> Demanda
-> Benefício
-> Requisito
-> Caso de Uso
-> User Story
-> Task
-> Teste
-> Release
-> GMUD
-> Produção

---

# Arquitetura Base

## Frontend
- Vue 3
- TypeScript
- Pinia
- Vuetify

## Backend
- Python
- FastAPI
- SQLAlchemy

## Banco
- SQL Server 2025

## Infraestrutura
- Redis
- RabbitMQ
- OpenTelemetry
- Prometheus
- Grafana

---

# Microsserviços

- Identity Service
- Organization Service
- User Service
- Squad Service
- System Catalog Service
- Demand Service
- Requirement Service
- Use Case Service
- User Story Service
- UCP Service
- Planning Service
- Release Service
- GMUD Service
- Audit Service
- Notification Service
- AI Service

---

# Critérios de Sucesso

- 100% rastreabilidade.
- Automação da estimativa UCP.
- Redução do esforço documental.
- Governança corporativa centralizada.
- Integração entre ALYA, Mobyan e TaNaPorta.
