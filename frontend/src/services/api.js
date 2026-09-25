/**
 * DevFlow - API Service
 * Configuração centralizada do Axios para chamadas à API
 */
import axios from 'axios'

const api = axios.create({
  baseURL: import.meta.env.VITE_API_URL || 'http://localhost:8000/api/v1',
  timeout: 30000,
  headers: {
    'Content-Type': 'application/json'
  }
})

// Request interceptor
api.interceptors.request.use(
  (config) => {
    // TODO: Adicionar token de autenticação
    // const token = localStorage.getItem('token')
    // if (token) {
    //   config.headers.Authorization = `Bearer ${token}`
    // }
    return config
  },
  (error) => {
    return Promise.reject(error)
  }
)

// Response interceptor
api.interceptors.response.use(
  (response) => {
    return response
  },
  (error) => {
    // Tratamento global de erros
    if (error.response) {
      switch (error.response.status) {
        case 401:
          // TODO: Redirecionar para login
          console.error('Não autorizado')
          break
        case 403:
          console.error('Acesso negado')
          break
        case 404:
          console.error('Recurso não encontrado')
          break
        case 500:
          console.error('Erro no servidor')
          break
        default:
          console.error('Erro na requisição:', error.response.data)
      }
    }
    return Promise.reject(error)
  }
)

export default api
