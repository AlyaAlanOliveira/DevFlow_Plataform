"""
DevFlow - Reference Repositories
Repositories para tabelas de referência
"""
from typing import List, Optional
from sqlalchemy.orm import Session
from sqlalchemy import and_
from app.domain.reference import (
    Priority,
    DemandType,
    WorkflowStatus,
    ActorComplexity,
    UseCaseComplexity
)
from app.repositories.base import BaseRepository


class PriorityRepository(BaseRepository[Priority]):
    """Repository para Priority"""
    
    def __init__(self, db: Session):
        super().__init__(Priority, db)
    
    def get_by_code(self, code: str) -> Optional[Priority]:
        """Busca prioridade por código"""
        return self.db.query(Priority).filter(
            and_(
                Priority.Code == code,
                Priority.IsDeleted == False
            )
        ).first()
    
    def get_active(self) -> List[Priority]:
        """Busca todas as prioridades ativas"""
        return self.db.query(Priority).filter(
            and_(
                Priority.IsActive == True,
                Priority.IsDeleted == False
            )
        ).order_by(Priority.DisplayOrder).all()


class DemandTypeRepository(BaseRepository[DemandType]):
    """Repository para DemandType"""
    
    def __init__(self, db: Session):
        super().__init__(DemandType, db)
    
    def get_by_code(self, code: str) -> Optional[DemandType]:
        """Busca tipo de demanda por código"""
        return self.db.query(DemandType).filter(
            and_(
                DemandType.Code == code,
                DemandType.IsDeleted == False
            )
        ).first()
    
    def get_active(self) -> List[DemandType]:
        """Busca todos os tipos de demanda ativos"""
        return self.db.query(DemandType).filter(
            and_(
                DemandType.IsActive == True,
                DemandType.IsDeleted == False
            )
        ).order_by(DemandType.Name).all()


class WorkflowStatusRepository(BaseRepository[WorkflowStatus]):
    """Repository para WorkflowStatus"""
    
    def __init__(self, db: Session):
        super().__init__(WorkflowStatus, db)
    
    def get_by_entity_and_code(
        self, 
        entity_type: str, 
        code: str
    ) -> Optional[WorkflowStatus]:
        """Busca status por tipo de entidade e código"""
        return self.db.query(WorkflowStatus).filter(
            and_(
                WorkflowStatus.EntityType == entity_type,
                WorkflowStatus.Code == code,
                WorkflowStatus.IsDeleted == False
            )
        ).first()
    
    def get_by_entity_type(self, entity_type: str) -> List[WorkflowStatus]:
        """Busca todos os status de um tipo de entidade"""
        return self.db.query(WorkflowStatus).filter(
            and_(
                WorkflowStatus.EntityType == entity_type,
                WorkflowStatus.IsActive == True,
                WorkflowStatus.IsDeleted == False
            )
        ).order_by(WorkflowStatus.DisplayOrder).all()


class ActorComplexityRepository(BaseRepository[ActorComplexity]):
    """Repository para ActorComplexity"""
    
    def __init__(self, db: Session):
        super().__init__(ActorComplexity, db)
    
    def get_by_code(self, code: str) -> Optional[ActorComplexity]:
        """Busca complexidade de ator por código"""
        return self.db.query(ActorComplexity).filter(
            and_(
                ActorComplexity.Code == code,
                ActorComplexity.IsDeleted == False
            )
        ).first()
    
    def get_active(self) -> List[ActorComplexity]:
        """Busca todas as complexidades ativas"""
        return self.db.query(ActorComplexity).filter(
            and_(
                ActorComplexity.IsActive == True,
                ActorComplexity.IsDeleted == False
            )
        ).order_by(ActorComplexity.DisplayOrder).all()


class UseCaseComplexityRepository(BaseRepository[UseCaseComplexity]):
    """Repository para UseCaseComplexity"""
    
    def __init__(self, db: Session):
        super().__init__(UseCaseComplexity, db)
    
    def get_by_code(self, code: str) -> Optional[UseCaseComplexity]:
        """Busca complexidade de caso de uso por código"""
        return self.db.query(UseCaseComplexity).filter(
            and_(
                UseCaseComplexity.Code == code,
                UseCaseComplexity.IsDeleted == False
            )
        ).first()
    
    def get_active(self) -> List[UseCaseComplexity]:
        """Busca todas as complexidades ativas"""
        return self.db.query(UseCaseComplexity).filter(
            and_(
                UseCaseComplexity.IsActive == True,
                UseCaseComplexity.IsDeleted == False
            )
        ).order_by(UseCaseComplexity.DisplayOrder).all()
    
    def get_by_transaction_count(
        self, 
        transaction_count: int
    ) -> Optional[UseCaseComplexity]:
        """Busca complexidade baseada no número de transações"""
        return self.db.query(UseCaseComplexity).filter(
            and_(
                UseCaseComplexity.TransactionMin <= transaction_count,
                UseCaseComplexity.TransactionMax >= transaction_count,
                UseCaseComplexity.IsActive == True,
                UseCaseComplexity.IsDeleted == False
            )
        ).first()
