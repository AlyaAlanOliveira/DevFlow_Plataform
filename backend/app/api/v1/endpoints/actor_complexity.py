"""
DevFlow - ActorComplexity API Endpoints
"""
from uuid import UUID, uuid4
from fastapi import APIRouter, Depends, Query, status
from sqlalchemy.orm import Session

from app.core.database import get_db
from app.services.reference import ActorComplexityService
from app.schemas.reference import ActorComplexityCreate, ActorComplexityUpdate, ActorComplexityResponse
from app.schemas.base import PaginatedResponse

router = APIRouter(prefix="/actor-complexities", tags=["Actor Complexities"])


@router.get("", response_model=PaginatedResponse)
def list_actor_complexities(
    skip: int = Query(0, ge=0),
    limit: int = Query(100, ge=1, le=1000),
    active_only: bool = Query(True),
    db: Session = Depends(get_db)
):
    """Lista todas as complexidades de ator"""
    service = ActorComplexityService(db)
    items, total = service.get_all(skip, limit, active_only)
    
    return PaginatedResponse(
        total=total,
        skip=skip,
        limit=limit,
        items=[ActorComplexityResponse.model_validate(item) for item in items]
    )


@router.get("/{complexity_id}", response_model=ActorComplexityResponse)
def get_actor_complexity(complexity_id: UUID, db: Session = Depends(get_db)):
    """Busca complexidade por ID"""
    service = ActorComplexityService(db)
    complexity = service.get_by_id(complexity_id)
    return ActorComplexityResponse.model_validate(complexity)


@router.post("", response_model=ActorComplexityResponse, status_code=status.HTTP_201_CREATED)
def create_actor_complexity(data: ActorComplexityCreate, db: Session = Depends(get_db)):
    """Cria nova complexidade de ator"""
    created_by = uuid4()
    service = ActorComplexityService(db)
    complexity = service.create(data, created_by)
    return ActorComplexityResponse.model_validate(complexity)


@router.put("/{complexity_id}", response_model=ActorComplexityResponse)
def update_actor_complexity(complexity_id: UUID, data: ActorComplexityUpdate, db: Session = Depends(get_db)):
    """Atualiza complexidade de ator"""
    updated_by = uuid4()
    service = ActorComplexityService(db)
    complexity = service.update(complexity_id, data, updated_by)
    return ActorComplexityResponse.model_validate(complexity)


@router.delete("/{complexity_id}", status_code=status.HTTP_204_NO_CONTENT)
def delete_actor_complexity(complexity_id: UUID, db: Session = Depends(get_db)):
    """Deleta complexidade de ator (soft delete)"""
    deleted_by = uuid4()
    service = ActorComplexityService(db)
    service.delete(complexity_id, deleted_by)
    return None
