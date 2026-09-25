# ✅ DevFlow ALYA - Checklist de Execução

## 📋 PRÉ-REQUISITOS

Antes de começar, verifique:

- [ ] Python 3.13+ instalado
  ```bash
  python --version
  # Deve mostrar: Python 3.13.x
  ```

- [ ] Node.js 18+ instalado
  ```bash
  node --version
  # Deve mostrar: v18.x.x ou v20.x.x
  ```

- [ ] SQL Server rodando
  ```bash
  # Testar conexão
  sqlcmd -S ALYA-TI-001\SQLSERVERLOCAL -U DevFlowUser -P <senha>
  ```

- [ ] Banco de dados DevFlow_ALYA criado e populado

---

## 🔧 CONFIGURAÇÃO INICIAL

### Backend

- [ ] Criar ambiente virtual
  ```bash
  cd backend
  python -m venv venv
  ```

- [ ] Ativar ambiente virtual
  ```bash
  # Git Bash
  source venv/Scripts/activate
  
  # CMD
  venv\Scripts\activate
  ```

- [ ] Instalar dependências
  ```bash
  pip install -r requirements.txt
  ```

- [ ] Configurar .env
  ```bash
  cp .env.example .env
  # Editar .env com suas configurações
  ```

### Frontend

- [ ] Instalar dependências
  ```bash
  cd frontend
  npm install
  ```

- [ ] Configurar .env
  ```bash
  cp .env.example .env
  # Verificar se está correto
  ```

---

## 🚀 EXECUÇÃO

### Opção 1: Scripts Automáticos (Recomendado)

- [ ] **Executar tudo de uma vez:**
  ```bash
  # Duplo clique em:
  start-all.bat
  ```

- [ ] **Ou executar separadamente:**
  ```bash
  # Terminal 1:
  start-backend.bat
  
  # Terminal 2:
  start-frontend.bat
  ```

### Opção 2: Manual

- [ ] **Backend (Terminal 1):**
  ```bash
  cd backend
  source venv/Scripts/activate
  python run.py
  ```

- [ ] **Frontend (Terminal 2):**
  ```bash
  cd frontend
  npm run dev
  ```

---

## ✅ VALIDAÇÃO

### Backend

- [ ] Backend iniciou sem erros
- [ ] Acessar: http://localhost:8000/health
  - Deve retornar: `{"status": "healthy", ...}`

- [ ] Acessar: http://localhost:8000/docs
  - Deve mostrar Swagger UI com todos os endpoints

- [ ] Testar endpoint:
  ```bash
  curl http://localhost:8000/api/v1/priorities
  ```
  - Deve retornar JSON com lista de prioridades

### Frontend

- [ ] Frontend iniciou sem erros
- [ ] Acessar: http://localhost:5173
  - Deve mostrar Dashboard

- [ ] Dashboard carrega:
  - [ ] Cartões de estatísticas com números
  - [ ] Ações rápidas clicáveis
  - [ ] Menu lateral funciona

### Integração

- [ ] Abrir DevTools (F12) → Network
- [ ] Recarregar página
- [ ] Verificar chamadas API:
  - [ ] GET /api/v1/priorities → Status 200
  - [ ] GET /api/v1/demand-types → Status 200
  - [ ] GET /api/v1/workflow-status → Status 200
  - [ ] GET /api/v1/operations → Status 200

---

## 🧪 TESTE FUNCIONAL

### CRUD de Priority

#### Criar
- [ ] Clicar em "Prioridades" no menu
- [ ] Clicar em "Adicionar"
- [ ] Preencher formulário:
  - Código: `TEST`
  - Nome: `Teste`
  - SLA: `15`
  - Cor: Escolher no color picker
  - Ordem: `99`
- [ ] Clicar em "Salvar"
- [ ] ✅ Mensagem de sucesso aparece
- [ ] ✅ Registro aparece na tabela

#### Pesquisar
- [ ] Digitar "Teste" na caixa de pesquisa
- [ ] ✅ Tabela filtra e mostra apenas o registro

#### Editar
- [ ] Clicar no ícone de lápis
- [ ] Alterar nome para "Teste Editado"
- [ ] Clicar em "Salvar"
- [ ] ✅ Mensagem de sucesso aparece
- [ ] ✅ Nome atualizado na tabela

#### Excluir
- [ ] Clicar no ícone de lixeira
- [ ] Confirmar exclusão
- [ ] ✅ Mensagem de sucesso aparece
- [ ] ✅ Registro removido da tabela

---

## 🎨 TESTE DE INTERFACE

### Dashboard
- [ ] Cartões de estatísticas:
  - [ ] Prioridades: Mostra número correto
  - [ ] Tipos de Demanda: Mostra número correto
  - [ ] Status Workflow: Mostra número correto
  - [ ] Operações: Mostra número correto

- [ ] Ações Rápidas:
  - [ ] Todos os 4 cards clicáveis
  - [ ] Navegação funciona

### Layout
- [ ] App Bar:
  - [ ] Logo e título visíveis
  - [ ] Menu hambúrguer funciona
  - [ ] Menu de usuário funciona

- [ ] Navigation Drawer:
  - [ ] Abre/fecha corretamente
  - [ ] Todos os itens clicáveis
  - [ ] Organização por categorias

- [ ] Responsividade:
  - [ ] Redimensionar janela
  - [ ] Layout se adapta

### Tabela de Priority
- [ ] Colunas visíveis:
  - [ ] Código
  - [ ] Nome
  - [ ] SLA
  - [ ] Cor (chip colorido)
  - [ ] Ordem
  - [ ] Status (chip verde/vermelho)
  - [ ] Ações

- [ ] Funcionalidades:
  - [ ] Ordenação por coluna
  - [ ] Pesquisa funciona
  - [ ] Paginação funciona
  - [ ] Loading state aparece

### Formulário
- [ ] Campos:
  - [ ] Todos os campos visíveis
  - [ ] Validações funcionam
  - [ ] Color picker funciona
  - [ ] Switch Ativo/Inativo funciona

- [ ] Validações:
  - [ ] Campos obrigatórios marcados
  - [ ] Erro ao deixar campo vazio
  - [ ] Formato de cor validado

- [ ] Ações:
  - [ ] Botão Cancelar fecha dialog
  - [ ] Botão Salvar desabilitado se inválido
  - [ ] Loading state durante salvamento

---

## 🐛 TROUBLESHOOTING

Se algo não funcionar, verifique:

### Backend não inicia
- [ ] Ambiente virtual ativado?
- [ ] Dependências instaladas?
- [ ] .env configurado corretamente?
- [ ] SQL Server rodando?
- [ ] Porta 8000 livre?

### Frontend não inicia
- [ ] Node.js instalado?
- [ ] npm install executado?
- [ ] .env configurado?
- [ ] Porta 5173 livre?

### Dados não aparecem
- [ ] Backend rodando?
- [ ] Console do navegador (F12) sem erros?
- [ ] Network tab mostra chamadas API?
- [ ] Dados existem no banco?

---

## 📊 RESULTADO ESPERADO

Ao final, você deve ter:

✅ Backend rodando em http://localhost:8000  
✅ Frontend rodando em http://localhost:5173  
✅ Dashboard funcional com estatísticas  
✅ CRUD de Priority 100% operacional  
✅ Integração Backend-Frontend validada  
✅ Todos os testes funcionais passando  

---

## 🎉 SUCESSO!

Se todos os itens acima estão marcados, **PARABÉNS!**

O DevFlow ALYA está funcionando perfeitamente! 🚀

### Próximos passos:
1. Completar demais telas (copiar PriorityView.vue)
2. Cadastrar dados reais
3. Expandir funcionalidades
4. Deploy em produção

---

**Data:** 2026-09-25  
**Versão:** 1.0.0
