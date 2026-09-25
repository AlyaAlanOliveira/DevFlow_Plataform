/**
 * DevFlow - Base Service
 * Serviço base com operações CRUD genéricas
 */
import api from './api'

export class BaseService {
  constructor(endpoint) {
    this.endpoint = endpoint
  }

  /**
   * Lista todos os registros
   */
  async getAll(params = {}) {
    const response = await api.get(this.endpoint, { params })
    return response.data
  }

  /**
   * Busca registro por ID
   */
  async getById(id) {
    const response = await api.get(`${this.endpoint}/${id}`)
    return response.data
  }

  /**
   * Cria novo registro
   */
  async create(data) {
    const response = await api.post(this.endpoint, data)
    return response.data
  }

  /**
   * Atualiza registro existente
   */
  async update(id, data) {
    const response = await api.put(`${this.endpoint}/${id}`, data)
    return response.data
  }

  /**
   * Deleta registro (soft delete)
   */
  async delete(id) {
    await api.delete(`${this.endpoint}/${id}`)
    return true
  }
}
