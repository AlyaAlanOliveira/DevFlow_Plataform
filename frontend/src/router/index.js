/**
 * DevFlow - Vue Router Configuration
 */
import { createRouter, createWebHistory } from 'vue-router'

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    {
      path: '/',
      component: () => import('@/layouts/MainLayout.vue'),
      children: [
        {
          path: '',
          name: 'dashboard',
          component: () => import('@/views/Dashboard.vue'),
          meta: { title: 'Dashboard' }
        },
        {
          path: 'priorities',
          name: 'priorities',
          component: () => import('@/views/reference/PriorityView.vue'),
          meta: { title: 'Prioridades' }
        },
        {
          path: 'demand-types',
          name: 'demand-types',
          component: () => import('@/views/reference/DemandTypeView.vue'),
          meta: { title: 'Tipos de Demanda' }
        },
        {
          path: 'workflow-status',
          name: 'workflow-status',
          component: () => import('@/views/reference/WorkflowStatusView.vue'),
          meta: { title: 'Status de Workflow' }
        },
        {
          path: 'actor-complexities',
          name: 'actor-complexities',
          component: () => import('@/views/reference/ActorComplexityView.vue'),
          meta: { title: 'Complexidade de Atores' }
        },
        {
          path: 'usecase-complexities',
          name: 'usecase-complexities',
          component: () => import('@/views/reference/UseCaseComplexityView.vue'),
          meta: { title: 'Complexidade de Casos de Uso' }
        },
        {
          path: 'operations',
          name: 'operations',
          component: () => import('@/views/configuration/OperationView.vue'),
          meta: { title: 'Operações' }
        },
        {
          path: 'ucp-configurations',
          name: 'ucp-configurations',
          component: () => import('@/views/configuration/UCPConfigurationView.vue'),
          meta: { title: 'Configurações UCP' }
        }
      ]
    }
  ]
})

// Navigation guard
router.beforeEach((to, from, next) => {
  // Atualizar título da página
  document.title = to.meta.title ? `${to.meta.title} - DevFlow ALYA` : 'DevFlow ALYA'
  next()
})

export default router
