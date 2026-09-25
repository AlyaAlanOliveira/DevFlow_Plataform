# DevFlow Frontend - Quick Start

## 🚀 Início Rápido (5 minutos)

### 1. Instalar Node.js

Verifique se o Node.js está instalado:
```bash
node --version
npm --version
```

**Versão recomendada**: Node.js 18+ ou 20+

### 2. Instalar dependências

```bash
cd frontend
npm install
```

### 3. Configurar variáveis de ambiente

```bash
# Windows
copy .env.example .env

# Linux/Mac
cp .env.example .env
```

### 4. Executar aplicação

```bash
npm run dev
```

### 5. Acessar aplicação

Abra no navegador:
- **Frontend**: http://localhost:5173
- **Backend API**: http://localhost:8000/docs

### 6. Testar funcionalidades

1. ✅ Acesse o Dashboard
2. ✅ Navegue para "Prioridades"
3. ✅ Clique em "Adicionar"
4. ✅ Preencha o formulário
5. ✅ Salve e veja na tabela

## 🐛 Troubleshooting

### Erro: Cannot find module

```bash
npm install
```

### Erro: Port 5173 already in use

```bash
# Alterar porta no vite.config.js
server: {
  port: 5174
}
```

### Erro de conexão com API

1. Verifique se o backend está rodando: http://localhost:8000/health
2. Verifique o `.env`: `VITE_API_URL=http://localhost:8000/api/v1`

## 📚 Próximos Passos

1. ✅ Explore o Dashboard
2. ✅ Teste todas as telas de referência
3. ✅ Crie alguns registros de teste
4. ✅ Familiarize-se com a navegação

## 🔗 Links Úteis

- [Vue 3 Docs](https://vuejs.org/)
- [Vuetify 3 Docs](https://vuetifyjs.com/)
- [Pinia Docs](https://pinia.vuejs.org/)

---

**Dúvidas?** Consulte o [README.md](./README.md) completo.
