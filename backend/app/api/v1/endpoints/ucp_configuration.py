"""
DevFlow - UCPConfiguration API Endpoints
"""
from uuid import UUID, uuid4
from fastapi import APIRouter, Depends, Query, status
from sqlalchemy.orm import Session

from app.core.database import get_db
from app.services.configuration import UCPConfigurationService
from app.schemas.configuration import UCPConfigurationCreate, UCPConfigurationUpdate, UCPConfigurationResponse
from app.schemas.base import PaginatedResponse

router = APIRouter(prefix="/ucp-configurations", tags=["UCP Configurations"])


@router.get("", response_model=PaginatedResponse)
def list_ucp_configurations(
    skip: int = Query(0, ge=0),
    limit: int = Query(100, ge=1, le=1000),
    active_only: bool = Query(True),
    db: Session = Depends(get_db)
):
    """Lista todas as configurações UCP"""
    service = UCPConfigurationService(db)
    items, total = service.get_all(skip, limit, active_only)
    
    return PaginatedResponse(
        total=total,
        skip=skip,
        limit=limit,
        items=[UCPConfigurationResponse.model_validate(item) for item in items]
    )


@router.get("/current", response_model=UCPConfigurationResponse)
def get_current_ucp_configuration(db: Session = Depends(get_db)):
    """Busca configuração UCP vigente (atual)"""
    service = UCPConfigurationService(db)
    config = service.get_current()
    return UCPConfigurationResponse.model_validate(config)


@router.get("/{config_id}", response_model=UCPConfigurationResponse)
def get_ucp_configuration(config_id: UUID, db: Session = Depends(get_db)):
    """Busca configuração UCP por ID"""
    service = UCPConfigurationService(db)
    config = service.get_by_id(config_id)
    return UCPConfigurationResponse.model_validate(config)


@router.post("", response_model=UCPConfigurationResponse, status_code=status.HTTP_201_CREATED)
def create_ucp_configuration(data: UCPConfigurationCreate, db: Session = Depends(get_db)):
    """Cria nova configuração UCP"""
    created_by = uuid4()
    service = UCPConfigurationService(db)
    config = service.create(data, created_by)
    return UCPConfigurationResponse.model_validate(config)


@router.put("/{config_id}", response_model=UCPConfigurationResponse)
def update_ucp_configuration(config_id: UUID, data: UCPConfigurationUpdate, db: Session = Depends(get_db)):
    """Atualiza configuração UCP"""
    updated_by = uuid4()
    service = UCPConfigurationService(db)
    config = service.update(config_id, data, updated_by)
    return UCPConfigurationResponse.model_validate(config)


@router.delete("/{config_id}", status_code=status.HTTP_204_NO_CONTENT)
def delete_ucp_configuration(config_id: UUID, db: Session = Depends(get_db)):
    """Deleta configuração UCP (soft delete)"""
    deleted_by = uuid4()
    service = UCPConfigurationService(db)
    service.delete(config_id, deleted_by)
    return None
