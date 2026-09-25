"""
DevFlow - Base Model
Model base com campos de auditoria
"""
from datetime import datetime
from typing import Optional
from uuid import UUID, uuid4
from sqlalchemy import Column, DateTime, Boolean, String
from sqlalchemy.dialects.mssql import UNIQUEIDENTIFIER, TIMESTAMP
from app.core.database import Base


class AuditMixin:
    """Mixin com campos de auditoria obrigatórios"""
    
    # Criação
    CreatedAt = Column(DateTime, nullable=False, default=datetime.utcnow)
    CreatedBy = Column(UNIQUEIDENTIFIER, nullable=False)
    
    # Atualização
    UpdatedAt = Column(DateTime, nullable=True, onupdate=datetime.utcnow)
    UpdatedBy = Column(UNIQUEIDENTIFIER, nullable=True)
    
    # Exclusão (Soft Delete)
    DeletedAt = Column(DateTime, nullable=True)
    DeletedBy = Column(UNIQUEIDENTIFIER, nullable=True)
    IsDeleted = Column(Boolean, nullable=False, default=False)
    
    # Controle de Concorrência
    RowVersion = Column(TIMESTAMP, nullable=False)


class BaseModel(Base, AuditMixin):
    """Model base abstrato com auditoria"""
    
    __abstract__ = True
    
    def to_dict(self) -> dict:
        """Converte o model para dicionário"""
        return {
            column.name: getattr(self, column.name)
            for column in self.__table__.columns
        }
