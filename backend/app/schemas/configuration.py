"""
DevFlow - Configuration Schemas
Schemas para tabelas de configuração
"""
from datetime import date
from typing import Optional
from uuid import UUID
from pydantic import Field, field_validator
from app.schemas.base import BaseCreateSchema, BaseUpdateSchema, BaseResponseSchema


# ==================== Operation ====================

class OperationCreate(BaseCreateSchema):
    """Schema para criação de Operation"""
    
    Code: str = Field(..., max_length=20, description="Código da operação")
    Name: str = Field(..., max_length=200, description="Nome da operação")
    Description: Optional[str] = Field(None, max_length=1000, description="Descrição")
    CompanyId: UUID = Field(..., description="ID da empresa")
    ClientType: str = Field(..., max_length=30, description="Tipo de cliente")
    IsActive: bool = Field(True, description="Está ativo?")
    
    @field_validator("ClientType")
    @classmethod
    def validate_client_type(cls, v: str) -> str:
        """Valida o tipo de cliente"""
        allowed = ["Internal", "External", "Partner"]
        if v not in allowed:
            raise ValueError(f"ClientType deve ser um de: {', '.join(allowed)}")
        return v


class OperationUpdate(BaseUpdateSchema):
    """Schema para atualização de Operation"""
    
    Code: Optional[str] = Field(None, max_length=20)
    Name: Optional[str] = Field(None, max_length=200)
    Description: Optional[str] = Field(None, max_length=1000)
    CompanyId: Optional[UUID] = None
    ClientType: Optional[str] = Field(None, max_length=30)
    IsActive: Optional[bool] = None


class OperationResponse(BaseResponseSchema):
    """Schema para resposta de Operation"""
    
    OperationId: UUID
    Code: str
    Name: str
    Description: Optional[str]
    CompanyId: UUID
    ClientType: str
    IsActive: bool


# ==================== UCPConfiguration ====================

class UCPConfigurationCreate(BaseCreateSchema):
    """Schema para criação de UCPConfiguration"""
    
    Name: str = Field(..., max_length=200, description="Nome da configuração")
    Description: Optional[str] = Field(None, max_length=1000, description="Descrição")
    HoursPerUCP: float = Field(..., gt=0, description="Horas por UCP")
    DevelopmentPercentage: float = Field(60.00, ge=0, le=100, description="% Desenvolvimento")
    TestPercentage: float = Field(20.00, ge=0, le=100, description="% Teste")
    HomologationPercentage: float = Field(20.00, ge=0, le=100, description="% Homologação")
    HourlyRate: Optional[float] = Field(None, gt=0, description="Valor hora/homem")
    EffectiveFrom: date = Field(..., description="Data de início")
    EffectiveTo: Optional[date] = Field(None, description="Data de fim")
    IsActive: bool = Field(True, description="Está ativo?")
    
    @field_validator("HomologationPercentage")
    @classmethod
    def validate_total_percentage(cls, v: float, info) -> float:
        """Valida que a soma dos percentuais é 100%"""
        if "DevelopmentPercentage" in info.data and "TestPercentage" in info.data:
            total = info.data["DevelopmentPercentage"] + info.data["TestPercentage"] + v
            if abs(total - 100.0) > 0.01:  # Tolerância para erros de ponto flutuante
                raise ValueError("A soma dos percentuais deve ser 100%")
        return v
    
    @field_validator("EffectiveTo")
    @classmethod
    def validate_effective_to(cls, v: Optional[date], info) -> Optional[date]:
        """Valida que EffectiveTo >= EffectiveFrom"""
        if v and "EffectiveFrom" in info.data and v < info.data["EffectiveFrom"]:
            raise ValueError("EffectiveTo deve ser maior ou igual a EffectiveFrom")
        return v


class UCPConfigurationUpdate(BaseUpdateSchema):
    """Schema para atualização de UCPConfiguration"""
    
    Name: Optional[str] = Field(None, max_length=200)
    Description: Optional[str] = Field(None, max_length=1000)
    HoursPerUCP: Optional[float] = Field(None, gt=0)
    DevelopmentPercentage: Optional[float] = Field(None, ge=0, le=100)
    TestPercentage: Optional[float] = Field(None, ge=0, le=100)
    HomologationPercentage: Optional[float] = Field(None, ge=0, le=100)
    HourlyRate: Optional[float] = Field(None, gt=0)
    EffectiveFrom: Optional[date] = None
    EffectiveTo: Optional[date] = None
    IsActive: Optional[bool] = None


class UCPConfigurationResponse(BaseResponseSchema):
    """Schema para resposta de UCPConfiguration"""
    
    UCPConfigurationId: UUID
    Name: str
    Description: Optional[str]
    HoursPerUCP: float
    DevelopmentPercentage: float
    TestPercentage: float
    HomologationPercentage: float
    HourlyRate: Optional[float]
    EffectiveFrom: date
    EffectiveTo: Optional[date]
    IsActive: bool
