/**
 * DevFlow - Reference Services
 * Services para entidades de referência
 */
import { BaseService } from './baseService'

export const priorityService = new BaseService('/priorities')
export const demandTypeService = new BaseService('/demand-types')
export const workflowStatusService = new BaseService('/workflow-status')
export const actorComplexityService = new BaseService('/actor-complexities')
export const useCaseComplexityService = new BaseService('/usecase-complexities')
export const operationService = new BaseService('/operations')
export const ucpConfigurationService = new BaseService('/ucp-configurations')
