"""
DevFlow - Configuration Repositories
Repositories para tabelas de configuração
"""
from typing import List, Optional
from datetime import date
from sqlalchemy.orm import Session
from sqlalchemy import and_
from app.domain.configuration import Operation, UCPConfiguration
from app.repositories.base import BaseRepository


class OperationRepository(BaseRepository[Operation]):
    """Repository para Operation"""
    
    def __init__(self, db: Session):
        super().__init__(Operation, db)
    
    def get_by_code(self, code: str) -> Optional[Operation]:
        """Busca operação por código"""
        return self.db.query(Operation).filter(
            and_(
                Operation.Code == code,
                Operation.IsDeleted == False
            )
        ).first()
    
    def get_active(self) -> List[Operation]:
        """Busca todas as operações ativas"""
        return self.db.query(Operation).filter(
            and_(
                Operation.IsActive == True,
                Operation.IsDeleted == False
            )
        ).order_by(Operation.Name).all()
    
    def get_by_company(self, company_id) -> List[Operation]:
        """Busca operações por empresa"""
        return self.db.query(Operation).filter(
            and_(
                Operation.CompanyId == company_id,
                Operation.IsActive == True,
                Operation.IsDeleted == False
            )
        ).order_by(Operation.Name).all()


class UCPConfigurationRepository(BaseRepository[UCPConfiguration]):
    """Repository para UCPConfiguration"""
    
    def __init__(self, db: Session):
        super().__init__(UCPConfiguration, db)
    
    def get_active(self) -> List[UCPConfiguration]:
        """Busca todas as configurações ativas"""
        return self.db.query(UCPConfiguration).filter(
            and_(
                UCPConfiguration.IsActive == True,
                UCPConfiguration.IsDeleted == False
            )
        ).order_by(UCPConfiguration.EffectiveFrom.desc()).all()
    
    def get_current(self) -> Optional[UCPConfiguration]:
        """Busca configuração UCP vigente (atual)"""
        today = date.today()
        return self.db.query(UCPConfiguration).filter(
            and_(
                UCPConfiguration.EffectiveFrom <= today,
                (UCPConfiguration.EffectiveTo.is_(None) | (UCPConfiguration.EffectiveTo >= today)),
                UCPConfiguration.IsActive == True,
                UCPConfiguration.IsDeleted == False
            )
        ).order_by(UCPConfiguration.EffectiveFrom.desc()).first()
    
    def get_by_date(self, target_date: date) -> Optional[UCPConfiguration]:
        """Busca configuração UCP vigente em uma data específica"""
        return self.db.query(UCPConfiguration).filter(
            and_(
                UCPConfiguration.EffectiveFrom <= target_date,
                (UCPConfiguration.EffectiveTo.is_(None) | (UCPConfiguration.EffectiveTo >= target_date)),
                UCPConfiguration.IsActive == True,
                UCPConfiguration.IsDeleted == False
            )
        ).order_by(UCPConfiguration.EffectiveFrom.desc()).first()
