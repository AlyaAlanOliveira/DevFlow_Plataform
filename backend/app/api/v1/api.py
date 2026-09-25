"""
DevFlow - API Router v1
Router principal da API v1
"""
from fastapi import APIRouter
from app.api.v1.endpoints import (
    priority,
    demand_type,
    workflow_status,
    actor_complexity,
    usecase_complexity,
    operation,
    ucp_configuration
)

api_router = APIRouter()

# Endpoints de Referência (ref schema)
api_router.include_router(priority.router)
api_router.include_router(demand_type.router)
api_router.include_router(workflow_status.router)
api_router.include_router(actor_complexity.router)
api_router.include_router(usecase_complexity.router)

# Endpoints de Configuração (cfg schema)
api_router.include_router(operation.router)
api_router.include_router(ucp_configuration.router)
