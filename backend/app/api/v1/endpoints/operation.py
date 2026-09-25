"""
DevFlow - Operation API Endpoints
"""
from uuid import UUID, uuid4
from fastapi import APIRouter, Depends, Query, status
from sqlalchemy.orm import Session

from app.core.database import get_db
from app.services.configuration import OperationService
from app.schemas.configuration import OperationCreate, OperationUpdate, OperationResponse
from app.schemas.base import PaginatedResponse

router = APIRouter(prefix="/operations", tags=["Operations"])


@router.get("", response_model=PaginatedResponse)
def list_operations(
    skip: int = Query(0, ge=0),
    limit: int = Query(100, ge=1, le=1000),
    active_only: bool = Query(True),
    db: Session = Depends(get_db)
):
    """Lista todas as operações"""
    service = OperationService(db)
    items, total = service.get_all(skip, limit, active_only)
    
    return PaginatedResponse(
        total=total,
        skip=skip,
        limit=limit,
        items=[OperationResponse.model_validate(item) for item in items]
    )


@router.get("/{operation_id}", response_model=OperationResponse)
def get_operation(operation_id: UUID, db: Session = Depends(get_db)):
    """Busca operação por ID"""
    service = OperationService(db)
    operation = service.get_by_id(operation_id)
    return OperationResponse.model_validate(operation)


@router.post("", response_model=OperationResponse, status_code=status.HTTP_201_CREATED)
def create_operation(data: OperationCreate, db: Session = Depends(get_db)):
    """Cria nova operação"""
    created_by = uuid4()
    service = OperationService(db)
    operation = service.create(data, created_by)
    return OperationResponse.model_validate(operation)


@router.put("/{operation_id}", response_model=OperationResponse)
def update_operation(operation_id: UUID, data: OperationUpdate, db: Session = Depends(get_db)):
    """Atualiza operação"""
    updated_by = uuid4()
    service = OperationService(db)
    operation = service.update(operation_id, data, updated_by)
    return OperationResponse.model_validate(operation)


@router.delete("/{operation_id}", status_code=status.HTTP_204_NO_CONTENT)
def delete_operation(operation_id: UUID, db: Session = Depends(get_db)):
    """Deleta operação (soft delete)"""
    deleted_by = uuid4()
    service = OperationService(db)
    service.delete(operation_id, deleted_by)
    return None
