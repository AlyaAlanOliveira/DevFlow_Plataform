"""
DevFlow - Base Schemas
Schemas base para validação com Pydantic
"""
from datetime import datetime
from typing import Optional
from uuid import UUID
from pydantic import BaseModel, ConfigDict, Field


class AuditSchema(BaseModel):
    """Schema base com campos de auditoria"""
    
    CreatedAt: datetime
    CreatedBy: UUID
    UpdatedAt: Optional[datetime] = None
    UpdatedBy: Optional[UUID] = None
    DeletedAt: Optional[datetime] = None
    DeletedBy: Optional[UUID] = None
    IsDeleted: bool = False
    
    model_config = ConfigDict(from_attributes=True)


class BaseCreateSchema(BaseModel):
    """Schema base para criação"""
    
    model_config = ConfigDict(from_attributes=True)


class BaseUpdateSchema(BaseModel):
    """Schema base para atualização"""
    
    model_config = ConfigDict(from_attributes=True)


class BaseResponseSchema(AuditSchema):
    """Schema base para resposta"""
    
    pass


class PaginationParams(BaseModel):
    """Parâmetros de paginação"""
    
    skip: int = Field(0, ge=0, description="Número de registros para pular")
    limit: int = Field(100, ge=1, le=1000, description="Número máximo de registros")
    
    model_config = ConfigDict(from_attributes=True)


class PaginatedResponse(BaseModel):
    """Resposta paginada"""
    
    total: int = Field(..., description="Total de registros")
    skip: int = Field(..., description="Registros pulados")
    limit: int = Field(..., description="Limite de registros")
    items: list = Field(..., description="Lista de itens")
    
    model_config = ConfigDict(from_attributes=True)
