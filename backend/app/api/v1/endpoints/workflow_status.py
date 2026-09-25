"""
DevFlow - WorkflowStatus API Endpoints
"""
from typing import Optional
from uuid import UUID, uuid4
from fastapi import APIRouter, Depends, Query, status
from sqlalchemy.orm import Session

from app.core.database import get_db
from app.services.reference import WorkflowStatusService
from app.schemas.reference import WorkflowStatusCreate, WorkflowStatusUpdate, WorkflowStatusResponse
from app.schemas.base import PaginatedResponse

router = APIRouter(prefix="/workflow-status", tags=["Workflow Status"])


@router.get("", response_model=PaginatedResponse)
def list_workflow_status(
    skip: int = Query(0, ge=0),
    limit: int = Query(100, ge=1, le=1000),
    entity_type: Optional[str] = Query(None, description="Filtrar por tipo de entidade"),
    db: Session = Depends(get_db)
):
    """Lista todos os status de workflow"""
    service = WorkflowStatusService(db)
    items, total = service.get_all(skip, limit, entity_type)
    
    return PaginatedResponse(
        total=total,
        skip=skip,
        limit=limit,
        items=[WorkflowStatusResponse.model_validate(item) for item in items]
    )


@router.get("/{status_id}", response_model=WorkflowStatusResponse)
def get_workflow_status(status_id: UUID, db: Session = Depends(get_db)):
    """Busca status por ID"""
    service = WorkflowStatusService(db)
    workflow_status = service.get_by_id(status_id)
    return WorkflowStatusResponse.model_validate(workflow_status)


@router.post("", response_model=WorkflowStatusResponse, status_code=status.HTTP_201_CREATED)
def create_workflow_status(data: WorkflowStatusCreate, db: Session = Depends(get_db)):
    """Cria novo status de workflow"""
    created_by = uuid4()
    service = WorkflowStatusService(db)
    workflow_status = service.create(data, created_by)
    return WorkflowStatusResponse.model_validate(workflow_status)


@router.put("/{status_id}", response_model=WorkflowStatusResponse)
def update_workflow_status(status_id: UUID, data: WorkflowStatusUpdate, db: Session = Depends(get_db)):
    """Atualiza status de workflow"""
    updated_by = uuid4()
    service = WorkflowStatusService(db)
    workflow_status = service.update(status_id, data, updated_by)
    return WorkflowStatusResponse.model_validate(workflow_status)


@router.delete("/{status_id}", status_code=status.HTTP_204_NO_CONTENT)
def delete_workflow_status(status_id: UUID, db: Session = Depends(get_db)):
    """Deleta status de workflow (soft delete)"""
    deleted_by = uuid4()
    service = WorkflowStatusService(db)
    service.delete(status_id, deleted_by)
    return None
