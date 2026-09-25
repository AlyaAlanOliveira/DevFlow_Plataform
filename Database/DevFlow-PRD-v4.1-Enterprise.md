# DevFlow PRD v4.1 Enterprise

## Executive Summary
DevFlow é uma plataforma corporativa de governança de engenharia de software para o Grupo ALYA (ALYA, Mobyan e TaNaPorta).

## Visão
Centralizar todo o ciclo de desenvolvimento de software, desde o Business Case até a implantação produtiva e governança pós-entrega.

## Objetivos Estratégicos
- Governança ponta a ponta
- Engenharia de requisitos
- Estimativas UCP
- Gestão Ágil
- Release e GMUD
- IA Multiagente
- Analytics Corporativo
- Arquitetura Cloud Agnostic

## Estrutura Organizacional
Holding > Company > Directorate > Area > Squad > User

## Segurança
- Microsoft Entra ID
- MFA obrigatório
- RBAC
- Usuários locais proibidos

## Domínios de Negócio
- Governança
- Sistemas
- Portfolio
- Workflow
- Requisitos
- Agile
- UCP
- QA
- Release
- IA
- Auditoria
- Analytics

## Workflow Corporativo
Business Case -> Demand -> Requirement -> UseCase -> UserStory -> Estimate -> Sprint -> Test -> Release -> GMUD -> Production

## Modelo UCP
UCP = (UAW + UUCW) x TCF x EF

### TCF
Herdado parcialmente do Sistema.

### EF
Herdado parcialmente da Squad.

### Variáveis da Demanda
- Performance
- Usabilidade
- Complexidade
- Estabilidade

## Arquitetura Técnica

### Frontend
- Vue 3
- TypeScript
- Pinia
- Vuetify

### Backend
- Python
- FastAPI
- SQLAlchemy

### Banco de Dados
- SQL Server 2025

### Infraestrutura
- Redis
- RabbitMQ
- Grafana
- Prometheus
- OpenTelemetry

### IA
- Azure OpenAI
- Azure AI Search

# 24. Cloud & Infrastructure Strategy

## Objetivo
O DevFlow deverá ser desenvolvido seguindo princípios de Cloud Agnostic Architecture.

## Cloud Focal
Microsoft Azure

## Clouds Suportadas
- Microsoft Azure
- Amazon Web Services (AWS)
- Google Cloud Platform (GCP)

## Princípios
### Cloud Agnostic
Evitar vendor lock-in.

### Container First
Toda aplicação deverá ser executada em Docker.

### Kubernetes First
Compatível com:
- AKS
- EKS
- GKE

### Infrastructure as Code
Terraform como padrão.

## Arquitetura de Infraestrutura
### Frontend
- Vue 3
- NGINX
- Docker

### Backend
- FastAPI
- Docker

### Banco
- Azure SQL Managed Instance
- SQL Server VM Azure
- SQL Server AWS
- SQL Server GCP
- SQL Server Kubernetes

### Cache
- Redis

### Mensageria
- RabbitMQ

## Identidade
### Inicial
Microsoft Entra ID

### Futuro
- OIDC
- OAuth2
- SAML 2.0

## IA
### Inicial
Azure OpenAI

### Estratégia
Utilizar camada de abstração de provedores.

## Busca Semântica
### Inicial
Azure AI Search

### Futuro
- ElasticSearch
- OpenSearch

## CI/CD
- Azure DevOps
- GitHub Actions
- GitLab CI/CD

## Observabilidade
- OpenTelemetry
- Prometheus
- Grafana

## ADR-009 Cloud Agnostic Architecture

### Decisão
O DevFlow seguirá os princípios:
- Cloud Agnostic
- Container First
- Kubernetes First
- Infrastructure as Code
- Provider Abstraction

### Benefícios
- Menor Vendor Lock-In
- Portabilidade
- Flexibilidade para M&A
- MultiCloud Ready

## RNF-CLOUD

### RNF-CLOUD-001
Toda aplicação deve executar em container Docker.

### RNF-CLOUD-002
Toda implantação deve ser compatível com Kubernetes.

### RNF-CLOUD-003
Toda infraestrutura deve ser provisionável por Terraform.

### RNF-CLOUD-004
Nenhuma regra de negócio poderá depender diretamente de APIs exclusivas de um provedor cloud.

### RNF-CLOUD-005
Integrações externas devem ser abstraídas.

### RNF-CLOUD-006
Suporte à migração Azure, AWS e GCP.

## Schemas Oficiais
ref, cfg, sec, gov, sys, portfolio, workflow, req, agile, ucp, qa, release, file, ai, audit, bi

## Auditoria
CreatedAt, CreatedBy, UpdatedAt, UpdatedBy, DeletedAt, DeletedBy, IsDeleted e RowVersion.

## Exclusão
Soft delete obrigatório.

## Definition of Done
- Demanda aprovada
- Requisitos aprovados
- User Stories aprovadas
- Testes aprovados
- Release aprovada
- GMUD aprovada
- Auditoria registrada
- Documentação atualizada

## Roadmap
### MVP
Governança, Sistemas e Demandas

### V1
Requisitos, UML e User Stories

### V2
UCP e Planejamento

### V3
Release, GMUD e Dashboards

### V4
IA Multiagente, Analytics e Predições
