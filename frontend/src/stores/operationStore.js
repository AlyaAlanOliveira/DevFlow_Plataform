/**
 * DevFlow - Operation Store
 */
import { defineStore } from 'pinia'
import { ref } from 'vue'
import { operationService } from '@/services/referenceService'

export const useOperationStore = defineStore('operation', () => {
  const operations = ref([])
  const loading = ref(false)
  const error = ref(null)

  async function fetchAll(params = { active_only: true }) {
    loading.value = true
    error.value = null
    try {
      const response = await operationService.getAll(params)
      operations.value = response.items || []
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
      return await operationService.getById(id)
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
      const newItem = await operationService.create(data)
      operations.value.push(newItem)
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
      const updated = await operationService.update(id, data)
      const index = operations.value.findIndex(item => item.OperationId === id)
      if (index !== -1) {
        operations.value[index] = updated
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
      await operationService.delete(id)
      operations.value = operations.value.filter(item => item.OperationId !== id)
      return true
    } catch (err) {
      error.value = err.message
      throw err
    } finally {
      loading.value = false
    }
  }

  return {
    operations,
    loading,
    error,
    fetchAll,
    fetchById,
    create,
    update,
    remove
  }
})
