"""
DevFlow - Reference Services
Services para tabelas de referência (Business Logic)
"""
from typing import List, Optional
from uuid import UUID, uuid4
from datetime import datetime
from sqlalchemy.orm import Session
from fastapi import HTTPException, status

from app.domain.reference import (
    Priority,
    DemandType,
    WorkflowStatus,
    ActorComplexity,
    UseCaseComplexity
)
from app.repositories.reference import (
    PriorityRepository,
    DemandTypeRepository,
    WorkflowStatusRepository,
    ActorComplexityRepository,
    UseCaseComplexityRepository
)
from app.schemas.reference import (
    PriorityCreate,
    PriorityUpdate,
    DemandTypeCreate,
    DemandTypeUpdate,
    WorkflowStatusCreate,
    WorkflowStatusUpdate,
    ActorComplexityCreate,
    ActorComplexityUpdate,
    UseCaseComplexityCreate,
    UseCaseComplexityUpdate
)


class PriorityService:
    """Service para Priority"""
    
    def __init__(self, db: Session):
        self.db = db
        self.repository = PriorityRepository(db)
    
    def get_all(
        self, 
        skip: int = 0, 
        limit: int = 100,
        active_only: bool = True
    ) -> tuple[List[Priority], int]:
        """Busca todas as prioridades"""
        items = self.repository.get_active() if active_only else self.repository.get_all(skip, limit)
        total = len(items) if active_only else self.repository.count()
        return items, total
    
    def get_by_id(self, priority_id: UUID) -> Priority:
        """Busca prioridade por ID"""
        priority = self.repository.get_by_id(priority_id)
        if not priority:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail=f"Priority com ID {priority_id} não encontrada"
            )
        return priority
    
    def create(self, data: PriorityCreate, created_by: UUID) -> Priority:
        """Cria nova prioridade"""
        # Verifica se código já existe
        existing = self.repository.get_by_code(data.Code)
        if existing:
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail=f"Priority com código {data.Code} já existe"
            )
        
        # Cria objeto
        priority = Priority(
            PriorityId=uuid4(),
            **data.model_dump(),
            CreatedAt=datetime.utcnow(),
            CreatedBy=created_by
        )
        
        return self.repository.create(priority)
    
    def update(
        self, 
        priority_id: UUID, 
        data: PriorityUpdate,
        updated_by: UUID
    ) -> Priority:
        """Atualiza prioridade"""
        priority = self.get_by_id(priority_id)
        
        # Atualiza campos
        for field, value in data.model_dump(exclude_unset=True).items():
            setattr(priority, field, value)
        
        priority.UpdatedAt = datetime.utcnow()
        priority.UpdatedBy = updated_by
        
        return self.repository.update(priority)
    
    def delete(self, priority_id: UUID, deleted_by: UUID) -> bool:
        """Faz soft delete de prioridade"""
        priority = self.get_by_id(priority_id)
        return self.repository.soft_delete(priority_id, deleted_by)


class DemandTypeService:
    """Service para DemandType"""
    
    def __init__(self, db: Session):
        self.db = db
        self.repository = DemandTypeRepository(db)
    
    def get_all(
        self, 
        skip: int = 0, 
        limit: int = 100,
        active_only: bool = True
    ) -> tuple[List[DemandType], int]:
        """Busca todos os tipos de demanda"""
        items = self.repository.get_active() if active_only else self.repository.get_all(skip, limit)
        total = len(items) if active_only else self.repository.count()
        return items, total
    
    def get_by_id(self, demand_type_id: UUID) -> DemandType:
        """Busca tipo de demanda por ID"""
        demand_type = self.repository.get_by_id(demand_type_id)
        if not demand_type:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail=f"DemandType com ID {demand_type_id} não encontrado"
            )
        return demand_type
    
    def create(self, data: DemandTypeCreate, created_by: UUID) -> DemandType:
        """Cria novo tipo de demanda"""
        # Verifica se código já existe
        existing = self.repository.get_by_code(data.Code)
        if existing:
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail=f"DemandType com código {data.Code} já existe"
            )
        
        # Cria objeto
        demand_type = DemandType(
            DemandTypeId=uuid4(),
            **data.model_dump(),
            CreatedAt=datetime.utcnow(),
            CreatedBy=created_by
        )
        
        return self.repository.create(demand_type)
    
    def update(
        self, 
        demand_type_id: UUID, 
        data: DemandTypeUpdate,
        updated_by: UUID
    ) -> DemandType:
        """Atualiza tipo de demanda"""
        demand_type = self.get_by_id(demand_type_id)
        
        # Atualiza campos
        for field, value in data.model_dump(exclude_unset=True).items():
            setattr(demand_type, field, value)
        
        demand_type.UpdatedAt = datetime.utcnow()
        demand_type.UpdatedBy = updated_by
        
        return self.repository.update(demand_type)
    
    def delete(self, demand_type_id: UUID, deleted_by: UUID) -> bool:
        """Faz soft delete de tipo de demanda"""
        demand_type = self.get_by_id(demand_type_id)
        return self.repository.soft_delete(demand_type_id, deleted_by)


class WorkflowStatusService:
    """Service para WorkflowStatus"""
    
    def __init__(self, db: Session):
        self.db = db
        self.repository = WorkflowStatusRepository(db)
    
    def get_all(
        self, 
        skip: int = 0, 
        limit: int = 100,
        entity_type: Optional[str] = None
    ) -> tuple[List[WorkflowStatus], int]:
        """Busca todos os status de workflow"""
        if entity_type:
            items = self.repository.get_by_entity_type(entity_type)
            total = len(items)
        else:
            items = self.repository.get_all(skip, limit)
            total = self.repository.count()
        return items, total
    
    def get_by_id(self, status_id: UUID) -> WorkflowStatus:
        """Busca status por ID"""
        workflow_status = self.repository.get_by_id(status_id)
        if not workflow_status:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail=f"WorkflowStatus com ID {status_id} não encontrado"
            )
        return workflow_status
    
    def create(self, data: WorkflowStatusCreate, created_by: UUID) -> WorkflowStatus:
        """Cria novo status de workflow"""
        # Verifica se já existe
        existing = self.repository.get_by_entity_and_code(data.EntityType, data.Code)
        if existing:
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail=f"WorkflowStatus com EntityType={data.EntityType} e Code={data.Code} já existe"
            )
        
        # Cria objeto
        workflow_status = WorkflowStatus(
            WorkflowStatusId=uuid4(),
            **data.model_dump(),
            CreatedAt=datetime.utcnow(),
            CreatedBy=created_by
        )
        
        return self.repository.create(workflow_status)
    
    def update(
        self, 
        status_id: UUID, 
        data: WorkflowStatusUpdate,
        updated_by: UUID
    ) -> WorkflowStatus:
        """Atualiza status de workflow"""
        workflow_status = self.get_by_id(status_id)
        
        # Atualiza campos
        for field, value in data.model_dump(exclude_unset=True).items():
            setattr(workflow_status, field, value)
        
        workflow_status.UpdatedAt = datetime.utcnow()
        workflow_status.UpdatedBy = updated_by
        
        return self.repository.update(workflow_status)
    
    def delete(self, status_id: UUID, deleted_by: UUID) -> bool:
        """Faz soft delete de status de workflow"""
        workflow_status = self.get_by_id(status_id)
        return self.repository.soft_delete(status_id, deleted_by)


# Services para ActorComplexity e UseCaseComplexity seguem o mesmo padrão...
# (Omitidos por brevidade, mas seguem a mesma estrutura)
