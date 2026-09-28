/**
 * DevFlow - WorkflowStatus Store
 */
import { defineStore } from 'pinia'
import { ref } from 'vue'
import { workflowStatusService } from '@/services/referenceService'

export const useWorkflowStatusStore = defineStore('workflowStatus', () => {
  const workflowStatuses = ref([])
  const loading = ref(false)
  const error = ref(null)

  async function fetchAll(params = {}) {
    loading.value = true
    error.value = null
    try {
      const response = await workflowStatusService.getAll(params)
      workflowStatuses.value = response.items || []
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
      return await workflowStatusService.getById(id)
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
      const newItem = await workflowStatusService.create(data)
      workflowStatuses.value.push(newItem)
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
      const updated = await workflowStatusService.update(id, data)
      const index = workflowStatuses.value.findIndex(item => item.WorkflowStatusId === id)
      if (index !== -1) {
        workflowStatuses.value[index] = updated
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
      await workflowStatusService.delete(id)
      workflowStatuses.value = workflowStatuses.value.filter(item => item.WorkflowStatusId !== id)
      return true
    } catch (err) {
      error.value = err.message
      throw err
    } finally {
      loading.value = false
    }
  }

  return {
    workflowStatuses,
    loading,
    error,
    fetchAll,
    fetchById,
    create,
    update,
    remove
  }
})
