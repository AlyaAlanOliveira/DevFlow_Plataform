"""
DevFlow - API Router v1
Router principal da API v1
"""
from fastapi import APIRouter
from app.api.v1.endpoints import priority

api_router = APIRouter()

# Incluir endpoints de referência
api_router.include_router(priority.router)

# TODO: Adicionar outros routers
# api_router.include_router(demand_type.router)
# api_router.include_router(workflow_status.router)
# api_router.include_router(actor_complexity.router)
# api_router.include_router(usecase_complexity.router)
