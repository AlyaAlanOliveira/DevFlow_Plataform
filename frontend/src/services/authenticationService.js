/**
 * DevFlow - Authentication Service
 * API calls for Entra ID Tenant management
 */
import apiClient from './apiClient'

const BASE_URL = '/entraid-tenants'

export const entraidTenantService = {
  /**
   * Get all Entra ID tenants
   */
  async getAll(params = {}) {
    const response = await apiClient.get(BASE_URL, { params })
    return response.data
  },

  /**
   * Get Entra ID tenant by ID
   */
  async getById(id) {
    const response = await apiClient.get(`${BASE_URL}/${id}`)
    return response.data
  },

  /**
   * Get Entra ID tenant by Company ID
   */
  async getByCompanyId(companyId) {
    const response = await apiClient.get(`${BASE_URL}/company/${companyId}`)
    return response.data
  },

  /**
   * Create new Entra ID tenant
   */
  async create(data) {
    const response = await apiClient.post(BASE_URL, data)
    return response.data
  },

  /**
   * Update Entra ID tenant
   */
  async update(id, data) {
    const response = await apiClient.put(`${BASE_URL}/${id}`, data)
    return response.data
  },

  /**
   * Delete Entra ID tenant (soft delete)
   */
  async delete(id) {
    await apiClient.delete(`${BASE_URL}/${id}`)
  },

  /**
   * Test tenant configuration
   */
  async testConfig(id) {
    const response = await apiClient.post(`${BASE_URL}/${id}/test`)
    return response.data
  }
}
