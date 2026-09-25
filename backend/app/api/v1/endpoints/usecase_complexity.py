"""
DevFlow - UseCaseComplexity API Endpoints
"""
from uuid import UUID, uuid4
from fastapi import APIRouter, Depends, Query, status
from sqlalchemy.orm import Session

from app.core.database import get_db
from app.services.reference import UseCaseComplexityService
from app.schemas.reference import UseCaseComplexityCreate, UseCaseComplexityUpdate, UseCaseComplexityResponse
from app.schemas.base import PaginatedResponse

router = APIRouter(prefix="/usecase-complexities", tags=["UseCase Complexities"])


@router.get("", response_model=PaginatedResponse)
def list_usecase_complexities(
    skip: int = Query(0, ge=0),
    limit: int = Query(100, ge=1, le=1000),
    active_only: bool = Query(True),
    db: Session = Depends(get_db)
):
    """Lista todas as complexidades de caso de uso"""
    service = UseCaseComplexityService(db)
    items, total = service.get_all(skip, limit, active_only)
    
    return PaginatedResponse(
        total=total,
        skip=skip,
        limit=limit,
        items=[UseCaseComplexityResponse.model_validate(item) for item in items]
    )


@router.get("/{complexity_id}", response_model=UseCaseComplexityResponse)
def get_usecase_complexity(complexity_id: UUID, db: Session = Depends(get_db)):
    """Busca complexidade por ID"""
    service = UseCaseComplexityService(db)
    complexity = service.get_by_id(complexity_id)
    return UseCaseComplexityResponse.model_validate(complexity)


@router.post("", response_model=UseCaseComplexityResponse, status_code=status.HTTP_201_CREATED)
def create_usecase_complexity(data: UseCaseComplexityCreate, db: Session = Depends(get_db)):
    """Cria nova complexidade de caso de uso"""
    created_by = uuid4()
    service = UseCaseComplexityService(db)
    complexity = service.create(data, created_by)
    return UseCaseComplexityResponse.model_validate(complexity)


@router.put("/{complexity_id}", response_model=UseCaseComplexityResponse)
def update_usecase_complexity(complexity_id: UUID, data: UseCaseComplexityUpdate, db: Session = Depends(get_db)):
    """Atualiza complexidade de caso de uso"""
    updated_by = uuid4()
    service = UseCaseComplexityService(db)
    complexity = service.update(complexity_id, data, updated_by)
    return UseCaseComplexityResponse.model_validate(complexity)


@router.delete("/{complexity_id}", status_code=status.HTTP_204_NO_CONTENT)
def delete_usecase_complexity(complexity_id: UUID, db: Session = Depends(get_db)):
    """Deleta complexidade de caso de uso (soft delete)"""
    deleted_by = uuid4()
    service = UseCaseComplexityService(db)
    service.delete(complexity_id, deleted_by)
    return None
