"""
DevFlow - DemandType API Endpoints
"""
from uuid import UUID, uuid4
from fastapi import APIRouter, Depends, Query, status
from sqlalchemy.orm import Session

from app.core.database import get_db
from app.services.reference import DemandTypeService
from app.schemas.reference import DemandTypeCreate, DemandTypeUpdate, DemandTypeResponse
from app.schemas.base import PaginatedResponse

router = APIRouter(prefix="/demand-types", tags=["Demand Types"])


@router.get("", response_model=PaginatedResponse)
def list_demand_types(
    skip: int = Query(0, ge=0),
    limit: int = Query(100, ge=1, le=1000),
    active_only: bool = Query(True),
    db: Session = Depends(get_db)
):
    """Lista todos os tipos de demanda"""
    service = DemandTypeService(db)
    items, total = service.get_all(skip, limit, active_only)
    
    return PaginatedResponse(
        total=total,
        skip=skip,
        limit=limit,
        items=[DemandTypeResponse.model_validate(item) for item in items]
    )


@router.get("/{demand_type_id}", response_model=DemandTypeResponse)
def get_demand_type(demand_type_id: UUID, db: Session = Depends(get_db)):
    """Busca tipo de demanda por ID"""
    service = DemandTypeService(db)
    demand_type = service.get_by_id(demand_type_id)
    return DemandTypeResponse.model_validate(demand_type)


@router.post("", response_model=DemandTypeResponse, status_code=status.HTTP_201_CREATED)
def create_demand_type(data: DemandTypeCreate, db: Session = Depends(get_db)):
    """Cria novo tipo de demanda"""
    created_by = uuid4()  # TODO: Pegar usuário autenticado
    service = DemandTypeService(db)
    demand_type = service.create(data, created_by)
    return DemandTypeResponse.model_validate(demand_type)


@router.put("/{demand_type_id}", response_model=DemandTypeResponse)
def update_demand_type(
    demand_type_id: UUID,
    data: DemandTypeUpdate,
    db: Session = Depends(get_db)
):
    """Atualiza tipo de demanda"""
    updated_by = uuid4()  # TODO: Pegar usuário autenticado
    service = DemandTypeService(db)
    demand_type = service.update(demand_type_id, data, updated_by)
    return DemandTypeResponse.model_validate(demand_type)


@router.delete("/{demand_type_id}", status_code=status.HTTP_204_NO_CONTENT)
def delete_demand_type(demand_type_id: UUID, db: Session = Depends(get_db)):
    """Deleta tipo de demanda (soft delete)"""
    deleted_by = uuid4()  # TODO: Pegar usuário autenticado
    service = DemandTypeService(db)
    service.delete(demand_type_id, deleted_by)
    return None
