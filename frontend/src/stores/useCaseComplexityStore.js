/**
 * DevFlow - UseCaseComplexity Store
 */
import { defineStore } from 'pinia'
import { ref } from 'vue'
import { useCaseComplexityService } from '@/services/referenceService'

export const useUseCaseComplexityStore = defineStore('useCaseComplexity', () => {
  const useCaseComplexities = ref([])
  const loading = ref(false)
  const error = ref(null)

  async function fetchAll(params = { active_only: true }) {
    loading.value = true
    error.value = null
    try {
      const response = await useCaseComplexityService.getAll(params)
      useCaseComplexities.value = response.items || []
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
      return await useCaseComplexityService.getById(id)
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
      const newItem = await useCaseComplexityService.create(data)
      useCaseComplexities.value.push(newItem)
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
      const updated = await useCaseComplexityService.update(id, data)
      const index = useCaseComplexities.value.findIndex(item => item.UseCaseComplexityId === id)
      if (index !== -1) {
        useCaseComplexities.value[index] = updated
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
      await useCaseComplexityService.delete(id)
      useCaseComplexities.value = useCaseComplexities.value.filter(item => item.UseCaseComplexityId !== id)
      return true
    } catch (err) {
      error.value = err.message
      throw err
    } finally {
      loading.value = false
    }
  }

  return {
    useCaseComplexities,
    loading,
    error,
    fetchAll,
    fetchById,
    create,
    update,
    remove
  }
})
