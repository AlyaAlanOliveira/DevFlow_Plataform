<template>
  <div>
    <!-- Welcome Card -->
    <v-card class="mb-6" color="primary" variant="elevated">
      <v-card-text class="pa-6">
        <div class="d-flex align-center">
          <v-icon size="64" class="mr-4">mdi-view-dashboard</v-icon>
          <div>
            <h1 class="text-h4 font-weight-bold mb-2">Bem-vindo ao DevFlow ALYA</h1>
            <p class="text-subtitle-1 mb-0">
              Plataforma de Governança de Engenharia de Software
            </p>
          </div>
        </div>
      </v-card-text>
    </v-card>

    <!-- Stats Cards -->
    <v-row>
      <v-col cols="12" md="3">
        <v-card>
          <v-card-text>
            <div class="d-flex align-center justify-space-between">
              <div>
                <p class="text-caption text-grey mb-1">Prioridades</p>
                <h2 class="text-h4">{{ stats.priorities }}</h2>
              </div>
              <v-icon size="48" color="primary">mdi-flag</v-icon>
            </div>
          </v-card-text>
        </v-card>
      </v-col>

      <v-col cols="12" md="3">
        <v-card>
          <v-card-text>
            <div class="d-flex align-center justify-space-between">
              <div>
                <p class="text-caption text-grey mb-1">Tipos de Demanda</p>
                <h2 class="text-h4">{{ stats.demandTypes }}</h2>
              </div>
              <v-icon size="48" color="success">mdi-file-document</v-icon>
            </div>
          </v-card-text>
        </v-card>
      </v-col>

      <v-col cols="12" md="3">
        <v-card>
          <v-card-text>
            <div class="d-flex align-center justify-space-between">
              <div>
                <p class="text-caption text-grey mb-1">Status Workflow</p>
                <h2 class="text-h4">{{ stats.workflowStatus }}</h2>
              </div>
              <v-icon size="48" color="warning">mdi-state-machine</v-icon>
            </div>
          </v-card-text>
        </v-card>
      </v-col>

      <v-col cols="12" md="3">
        <v-card>
          <v-card-text>
            <div class="d-flex align-center justify-space-between">
              <div>
                <p class="text-caption text-grey mb-1">Operações</p>
                <h2 class="text-h4">{{ stats.operations }}</h2>
              </div>
              <v-icon size="48" color="error">mdi-office-building</v-icon>
            </div>
          </v-card-text>
        </v-card>
      </v-col>
    </v-row>

    <!-- Quick Actions -->
    <v-card class="mt-6">
      <v-card-title>
        <v-icon start>mdi-lightning-bolt</v-icon>
        Ações Rápidas
      </v-card-title>
      <v-divider></v-divider>
      <v-card-text>
        <v-row>
          <v-col cols="12" md="3" v-for="action in quickActions" :key="action.title">
            <v-card
              :to="action.to"
              hover
              class="text-center pa-4"
            >
              <v-icon size="48" :color="action.color" class="mb-2">
                {{ action.icon }}
              </v-icon>
              <h3 class="text-subtitle-1">{{ action.title }}</h3>
            </v-card>
          </v-col>
        </v-row>
      </v-card-text>
    </v-card>

    <!-- System Info -->
    <v-card class="mt-6">
      <v-card-title>
        <v-icon start>mdi-information</v-icon>
        Informações do Sistema
      </v-card-title>
      <v-divider></v-divider>
      <v-card-text>
        <v-list>
          <v-list-item>
            <v-list-item-title>Versão</v-list-item-title>
            <v-list-item-subtitle>1.0.0</v-list-item-subtitle>
          </v-list-item>
          <v-list-item>
            <v-list-item-title>Ambiente</v-list-item-title>
            <v-list-item-subtitle>Desenvolvimento</v-list-item-subtitle>
          </v-list-item>
          <v-list-item>
            <v-list-item-title>API Backend</v-list-item-title>
            <v-list-item-subtitle>http://localhost:8000</v-list-item-subtitle>
          </v-list-item>
        </v-list>
      </v-card-text>
    </v-card>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import {
  priorityService,
  demandTypeService,
  workflowStatusService,
  operationService
} from '@/services/referenceService'

const stats = ref({
  priorities: 0,
  demandTypes: 0,
  workflowStatus: 0,
  operations: 0
})

const quickActions = [
  {
    title: 'Prioridades',
    icon: 'mdi-flag',
    color: 'primary',
    to: '/priorities'
  },
  {
    title: 'Tipos de Demanda',
    icon: 'mdi-file-document',
    color: 'success',
    to: '/demand-types'
  },
  {
    title: 'Status Workflow',
    icon: 'mdi-state-machine',
    color: 'warning',
    to: '/workflow-status'
  },
  {
    title: 'Operações',
    icon: 'mdi-office-building',
    color: 'error',
    to: '/operations'
  }
]

async function loadStats() {
  try {
    const [priorities, demandTypes, workflowStatus, operations] = await Promise.all([
      priorityService.getAll({ active_only: true }),
      demandTypeService.getAll({ active_only: true }),
      workflowStatusService.getAll({ active_only: true }),
      operationService.getAll({ active_only: true })
    ])

    stats.value = {
      priorities: priorities.total || 0,
      demandTypes: demandTypes.total || 0,
      workflowStatus: workflowStatus.total || 0,
      operations: operations.total || 0
    }
  } catch (error) {
    console.error('Erro ao carregar estatísticas:', error)
  }
}

onMounted(() => {
  loadStats()
})
</script>
