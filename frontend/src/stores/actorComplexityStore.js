/**
 * DevFlow - ActorComplexity Store
 */
import { defineStore } from 'pinia'
import { ref } from 'vue'
import { actorComplexityService } from '@/services/referenceService'

export const useActorComplexityStore = defineStore('actorComplexity', () => {
  const actorComplexities = ref([])
  const loading = ref(false)
  const error = ref(null)

  async function fetchAll(params = { active_only: true }) {
    loading.value = true
    error.value = null
    try {
      const response = await actorComplexityService.getAll(params)
      actorComplexities.value = response.items || []
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
      return await actorComplexityService.getById(id)
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
      const newItem = await actorComplexityService.create(data)
      actorComplexities.value.push(newItem)
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
      const updated = await actorComplexityService.update(id, data)
      const index = actorComplexities.value.findIndex(item => item.ActorComplexityId === id)
      if (index !== -1) {
        actorComplexities.value[index] = updated
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
      await actorComplexityService.delete(id)
      actorComplexities.value = actorComplexities.value.filter(item => item.ActorComplexityId !== id)
      return true
    } catch (err) {
      error.value = err.message
      throw err
    } finally {
      loading.value = false
    }
  }

  return {
    actorComplexities,
    loading,
    error,
    fetchAll,
    fetchById,
    create,
    update,
    remove
  }
})
