/**
 * DevFlow - Entra ID Tenant Store
 */
import { defineStore } from 'pinia'
import { ref } from 'vue'
import { entraidTenantService } from '@/services/authenticationService'

export const useEntraidTenantStore = defineStore('entraidTenant', () => {
  const tenants = ref([])
  const loading = ref(false)
  const error = ref(null)

  async function fetchAll(params = { active_only: false }) {
    loading.value = true
    error.value = null
    try {
      const data = await entraidTenantService.getAll(params)
      tenants.value = Array.isArray(data) ? data : []
      return data
    } catch (err) {
      error.value = err.message
      throw err
    } finally {
      loading.value = false
    }
  }

  async function fetchById(id) {
    loading.value = true
    error.value = null
    try {
      return await entraidTenantService.getById(id)
    } catch (err) {
      error.value = err.message
      throw err
    } finally {
      loading.value = false
    }
  }

  async function fetchByCompanyId(companyId) {
    loading.value = true
    error.value = null
    try {
      return await entraidTenantService.getByCompanyId(companyId)
    } catch (err) {
      error.value = err.message
      throw err
    } finally {
      loading.value = false
    }
  }

  async function create(data) {
    loading.value = true
    error.value = null
    try {
      const newItem = await entraidTenantService.create(data)
      tenants.value.push(newItem)
      return newItem
    } catch (err) {
      error.value = err.message
      throw err
    } finally {
      loading.value = false
    }
  }

  async function update(id, data) {
    loading.value = true
    error.value = null
    try {
      const updated = await entraidTenantService.update(id, data)
      const index = tenants.value.findIndex(item => item.EntraIDTenantId === id)
      if (index !== -1) {
        tenants.value[index] = updated
      }
      return updated
    } catch (err) {
      error.value = err.message
      throw err
    } finally {
      loading.value = false
    }
  }

  async function remove(id) {
    loading.value = true
    error.value = null
    try {
      await entraidTenantService.delete(id)
      tenants.value = tenants.value.filter(item => item.EntraIDTenantId !== id)
      return true
    } catch (err) {
      error.value = err.message
      throw err
    } finally {
      loading.value = false
    }
  }

  async function testConfig(id) {
    loading.value = true
    error.value = null
    try {
      return await entraidTenantService.testConfig(id)
    } catch (err) {
      error.value = err.message
      throw err
    } finally {
      loading.value = false
    }
  }

  return {
    tenants,
    loading,
    error,
    fetchAll,
    fetchById,
    fetchByCompanyId,
    create,
    update,
    remove,
    testConfig
  }
})
