/**
 * DevFlow - Priority Store
 * Gerenciamento de estado para Prioridades
 */
import { defineStore } from 'pinia'
import { ref } from 'vue'
import { priorityService } from '@/services/referenceService'

export const usePriorityStore = defineStore('priority', () => {
  // State
  const priorities = ref([])
  const loading = ref(false)
  const error = ref(null)

  // Actions
  async function fetchAll(params = { active_only: true }) {
    loading.value = true
    error.value = null
    try {
      const response = await priorityService.getAll(params)
      priorities.value = response.items || []
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
      return await priorityService.getById(id)
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
      const newPriority = await priorityService.create(data)
      priorities.value.push(newPriority)
      return newPriority
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
      const updated = await priorityService.update(id, data)
      const index = priorities.value.findIndex(p => p.PriorityId === id)
      if (index !== -1) {
        priorities.value[index] = updated
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
      await priorityService.delete(id)
      priorities.value = priorities.value.filter(p => p.PriorityId !== id)
      return true
    } catch (err) {
      error.value = err.message
      throw err
    } finally {
      loading.value = false
    }
  }

  return {
    // State
    priorities,
    loading,
    error,
    // Actions
    fetchAll,
    fetchById,
    create,
    update,
    remove
  }
})
