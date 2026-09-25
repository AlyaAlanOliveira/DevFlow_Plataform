"""
DevFlow - Configuration Services
Services para tabelas de configuração (Business Logic)
"""
from typing import List
from uuid import UUID, uuid4
from datetime import datetime
from sqlalchemy.orm import Session
from fastapi import HTTPException, status

from app.domain.configuration import Operation, UCPConfiguration
from app.repositories.configuration import OperationRepository, UCPConfigurationRepository
from app.schemas.configuration import (
    OperationCreate,
    OperationUpdate,
    UCPConfigurationCreate,
    UCPConfigurationUpdate
)


class OperationService:
    """Service para Operation"""
    
    def __init__(self, db: Session):
        self.db = db
        self.repository = OperationRepository(db)
    
    def get_all(
        self, 
        skip: int = 0, 
        limit: int = 100,
        active_only: bool = True
    ) -> tuple[List[Operation], int]:
        """Busca todas as operações"""
        items = self.repository.get_active() if active_only else self.repository.get_all(skip, limit)
        total = len(items) if active_only else self.repository.count()
        return items, total
    
    def get_by_id(self, operation_id: UUID) -> Operation:
        """Busca operação por ID"""
        operation = self.repository.get_by_id(operation_id)
        if not operation:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail=f"Operation com ID {operation_id} não encontrada"
            )
        return operation
    
    def create(self, data: OperationCreate, created_by: UUID) -> Operation:
        """Cria nova operação"""
        existing = self.repository.get_by_code(data.Code)
        if existing:
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail=f"Operation com código {data.Code} já existe"
            )
        
        operation = Operation(
            OperationId=uuid4(),
            **data.model_dump(),
            CreatedAt=datetime.utcnow(),
            CreatedBy=created_by
        )
        
        return self.repository.create(operation)
    
    def update(
        self, 
        operation_id: UUID, 
        data: OperationUpdate,
        updated_by: UUID
    ) -> Operation:
        """Atualiza operação"""
        operation = self.get_by_id(operation_id)
        
        for field, value in data.model_dump(exclude_unset=True).items():
            setattr(operation, field, value)
        
        operation.UpdatedAt = datetime.utcnow()
        operation.UpdatedBy = updated_by
        
        return self.repository.update(operation)
    
    def delete(self, operation_id: UUID, deleted_by: UUID) -> bool:
        """Faz soft delete de operação"""
        operation = self.get_by_id(operation_id)
        return self.repository.soft_delete(operation_id, deleted_by)


class UCPConfigurationService:
    """Service para UCPConfiguration"""
    
    def __init__(self, db: Session):
        self.db = db
        self.repository = UCPConfigurationRepository(db)
    
    def get_all(
        self, 
        skip: int = 0, 
        limit: int = 100,
        active_only: bool = True
    ) -> tuple[List[UCPConfiguration], int]:
        """Busca todas as configurações UCP"""
        items = self.repository.get_active() if active_only else self.repository.get_all(skip, limit)
        total = len(items) if active_only else self.repository.count()
        return items, total
    
    def get_by_id(self, config_id: UUID) -> UCPConfiguration:
        """Busca configuração por ID"""
        config = self.repository.get_by_id(config_id)
        if not config:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail=f"UCPConfiguration com ID {config_id} não encontrada"
            )
        return config
    
    def get_current(self) -> UCPConfiguration:
        """Busca configuração UCP atual (vigente)"""
        config = self.repository.get_current()
        if not config:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail="Nenhuma configuração UCP vigente encontrada"
            )
        return config
    
    def create(self, data: UCPConfigurationCreate, created_by: UUID) -> UCPConfiguration:
        """Cria nova configuração UCP"""
        config = UCPConfiguration(
            UCPConfigurationId=uuid4(),
            **data.model_dump(),
            CreatedAt=datetime.utcnow(),
            CreatedBy=created_by
        )
        
        return self.repository.create(config)
    
    def update(
        self, 
        config_id: UUID, 
        data: UCPConfigurationUpdate,
        updated_by: UUID
    ) -> UCPConfiguration:
        """Atualiza configuração UCP"""
        config = self.get_by_id(config_id)
        
        for field, value in data.model_dump(exclude_unset=True).items():
            setattr(config, field, value)
        
        config.UpdatedAt = datetime.utcnow()
        config.UpdatedBy = updated_by
        
        return self.repository.update(config)
    
    def delete(self, config_id: UUID, deleted_by: UUID) -> bool:
        """Faz soft delete de configuração UCP"""
        config = self.get_by_id(config_id)
        return self.repository.soft_delete(config_id, deleted_by)
