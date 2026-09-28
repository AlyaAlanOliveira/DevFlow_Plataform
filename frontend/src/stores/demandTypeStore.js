/**
 * DevFlow - DemandType Store
 */
import { defineStore } from 'pinia'
import { ref } from 'vue'
import { demandTypeService } from '@/services/referenceService'

export const useDemandTypeStore = defineStore('demandType', () => {
  const demandTypes = ref([])
  const loading = ref(false)
  const error = ref(null)

  async function fetchAll(params = { active_only: true }) {
    loading.value = true
    error.value = null
    try {
      const response = await demandTypeService.getAll(params)
      demandTypes.value = response.items || []
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
      return await demandTypeService.getById(id)
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
      const newItem = await demandTypeService.create(data)
      demandTypes.value.push(newItem)
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
      const updated = await demandTypeService.update(id, data)
      const index = demandTypes.value.findIndex(item => item.DemandTypeId === id)
      if (index !== -1) {
        demandTypes.value[index] = updated
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
      await demandTypeService.delete(id)
      demandTypes.value = demandTypes.value.filter(item => item.DemandTypeId !== id)
      return true
    } catch (err) {
      error.value = err.message
      throw err
    } finally {
      loading.value = false
    }
  }

  return {
    demandTypes,
    loading,
    error,
    fetchAll,
    fetchById,
    create,
    update,
    remove
  }
})
