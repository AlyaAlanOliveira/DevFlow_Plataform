"""
DevFlow - Priority API Endpoints
Endpoints REST para Priority
"""
from typing import List
from uuid import UUID, uuid4
from fastapi import APIRouter, Depends, Query, status
from sqlalchemy.orm import Session

from app.core.database import get_db
from app.services.reference import PriorityService
from app.schemas.reference import (
    PriorityCreate,
    PriorityUpdate,
    PriorityResponse
)
from app.schemas.base import PaginatedResponse

router = APIRouter(prefix="/priorities", tags=["Priorities"])


@router.get(
    "",
    response_model=PaginatedResponse,
    summary="Listar Prioridades",
    description="Lista todas as prioridades com paginação"
)
def list_priorities(
    skip: int = Query(0, ge=0, description="Registros para pular"),
    limit: int = Query(100, ge=1, le=1000, description="Limite de registros"),
    active_only: bool = Query(True, description="Apenas ativos?"),
    db: Session = Depends(get_db)
):
    """Lista todas as prioridades"""
    service = PriorityService(db)
    items, total = service.get_all(skip, limit, active_only)
    
    return PaginatedResponse(
        total=total,
        skip=skip,
        limit=limit,
        items=[PriorityResponse.model_validate(item) for item in items]
    )


@router.get(
    "/{priority_id}",
    response_model=PriorityResponse,
    summary="Buscar Prioridade",
    description="Busca uma prioridade por ID"
)
def get_priority(
    priority_id: UUID,
    db: Session = Depends(get_db)
):
    """Busca prioridade por ID"""
    service = PriorityService(db)
    priority = service.get_by_id(priority_id)
    return PriorityResponse.model_validate(priority)


@router.post(
    "",
    response_model=PriorityResponse,
    status_code=status.HTTP_201_CREATED,
    summary="Criar Prioridade",
    description="Cria uma nova prioridade"
)
def create_priority(
    data: PriorityCreate,
    db: Session = Depends(get_db)
):
    """Cria nova prioridade"""
    # TODO: Pegar usuário autenticado
    created_by = uuid4()  # Temporário
    
    service = PriorityService(db)
    priority = service.create(data, created_by)
    return PriorityResponse.model_validate(priority)


@router.put(
    "/{priority_id}",
    response_model=PriorityResponse,
    summary="Atualizar Prioridade",
    description="Atualiza uma prioridade existente"
)
def update_priority(
    priority_id: UUID,
    data: PriorityUpdate,
    db: Session = Depends(get_db)
):
    """Atualiza prioridade"""
    # TODO: Pegar usuário autenticado
    updated_by = uuid4()  # Temporário
    
    service = PriorityService(db)
    priority = service.update(priority_id, data, updated_by)
    return PriorityResponse.model_validate(priority)


@router.delete(
    "/{priority_id}",
    status_code=status.HTTP_204_NO_CONTENT,
    summary="Deletar Prioridade",
    description="Faz soft delete de uma prioridade"
)
def delete_priority(
    priority_id: UUID,
    db: Session = Depends(get_db)
):
    """Deleta prioridade (soft delete)"""
    # TODO: Pegar usuário autenticado
    deleted_by = uuid4()  # Temporário
    
    service = PriorityService(db)
    service.delete(priority_id, deleted_by)
    return None
