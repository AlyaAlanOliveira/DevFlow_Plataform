/**
 * DevFlow - UCPConfiguration Store
 */
import { defineStore } from 'pinia'
import { ref } from 'vue'
import { ucpConfigurationService } from '@/services/referenceService'

export const useUCPConfigurationStore = defineStore('ucpConfiguration', () => {
  const ucpConfigurations = ref([])
  const loading = ref(false)
  const error = ref(null)

  async function fetchAll(params = { active_only: true }) {
    loading.value = true
    error.value = null
    try {
      const response = await ucpConfigurationService.getAll(params)
      ucpConfigurations.value = response.items || []
      return response
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
      return await ucpConfigurationService.getById(id)
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
      const newItem = await ucpConfigurationService.create(data)
      ucpConfigurations.value.push(newItem)
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
      const updated = await ucpConfigurationService.update(id, data)
      const index = ucpConfigurations.value.findIndex(item => item.UCPConfigurationId === id)
      if (index !== -1) {
        ucpConfigurations.value[index] = updated
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
      await ucpConfigurationService.delete(id)
      ucpConfigurations.value = ucpConfigurations.value.filter(item => item.UCPConfigurationId !== id)
      return true
    } catch (err) {
      error.value = err.message
      throw err
    } finally {
      loading.value = false
    }
  }

  return {
    ucpConfigurations,
    loading,
    error,
    fetchAll,
    fetchById,
    create,
    update,
    remove
  }
})
