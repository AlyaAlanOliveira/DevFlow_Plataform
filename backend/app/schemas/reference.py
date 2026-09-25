"""
DevFlow - Reference Schemas
Schemas para tabelas de referência
"""
from typing import Optional
from uuid import UUID
from pydantic import Field, field_validator
from app.schemas.base import BaseCreateSchema, BaseUpdateSchema, BaseResponseSchema


# ==================== Priority ====================

class PriorityCreate(BaseCreateSchema):
    """Schema para criação de Priority"""
    
    Code: str = Field(..., max_length=20, description="Código da prioridade")
    Name: str = Field(..., max_length=100, description="Nome da prioridade")
    Description: Optional[str] = Field(None, max_length=500, description="Descrição")
    SLADays: int = Field(..., gt=0, description="SLA em dias")
    ColorHex: Optional[str] = Field(None, max_length=7, pattern=r"^#[0-9A-Fa-f]{6}$", description="Cor em hexadecimal")
    DisplayOrder: int = Field(..., ge=1, description="Ordem de exibição")
    IsActive: bool = Field(True, description="Está ativo?")


class PriorityUpdate(BaseUpdateSchema):
    """Schema para atualização de Priority"""
    
    Code: Optional[str] = Field(None, max_length=20)
    Name: Optional[str] = Field(None, max_length=100)
    Description: Optional[str] = Field(None, max_length=500)
    SLADays: Optional[int] = Field(None, gt=0)
    ColorHex: Optional[str] = Field(None, max_length=7, pattern=r"^#[0-9A-Fa-f]{6}$")
    DisplayOrder: Optional[int] = Field(None, ge=1)
    IsActive: Optional[bool] = None


class PriorityResponse(BaseResponseSchema):
    """Schema para resposta de Priority"""
    
    PriorityId: UUID
    Code: str
    Name: str
    Description: Optional[str]
    SLADays: int
    ColorHex: Optional[str]
    DisplayOrder: int
    IsActive: bool


# ==================== DemandType ====================

class DemandTypeCreate(BaseCreateSchema):
    """Schema para criação de DemandType"""
    
    Code: str = Field(..., max_length=20, description="Código do tipo de demanda")
    Name: str = Field(..., max_length=100, description="Nome do tipo de demanda")
    Description: Optional[str] = Field(None, max_length=500, description="Descrição")
    RequiresImpactAnalysis: bool = Field(False, description="Requer análise de impacto?")
    RequiresSecurityReview: bool = Field(False, description="Requer revisão de segurança?")
    IsActive: bool = Field(True, description="Está ativo?")


class DemandTypeUpdate(BaseUpdateSchema):
    """Schema para atualização de DemandType"""
    
    Code: Optional[str] = Field(None, max_length=20)
    Name: Optional[str] = Field(None, max_length=100)
    Description: Optional[str] = Field(None, max_length=500)
    RequiresImpactAnalysis: Optional[bool] = None
    RequiresSecurityReview: Optional[bool] = None
    IsActive: Optional[bool] = None


class DemandTypeResponse(BaseResponseSchema):
    """Schema para resposta de DemandType"""
    
    DemandTypeId: UUID
    Code: str
    Name: str
    Description: Optional[str]
    RequiresImpactAnalysis: bool
    RequiresSecurityReview: bool
    IsActive: bool


# ==================== WorkflowStatus ====================

class WorkflowStatusCreate(BaseCreateSchema):
    """Schema para criação de WorkflowStatus"""
    
    EntityType: str = Field(..., max_length=50, description="Tipo de entidade")
    Code: str = Field(..., max_length=30, description="Código do status")
    Name: str = Field(..., max_length=100, description="Nome do status")
    Description: Optional[str] = Field(None, max_length=500, description="Descrição")
    IsFinal: bool = Field(False, description="É status final?")
    IsRejection: bool = Field(False, description="É rejeição?")
    DisplayOrder: int = Field(..., ge=1, description="Ordem de exibição")
    ColorHex: Optional[str] = Field(None, max_length=7, pattern=r"^#[0-9A-Fa-f]{6}$", description="Cor em hexadecimal")
    IsActive: bool = Field(True, description="Está ativo?")
    
    @field_validator("EntityType")
    @classmethod
    def validate_entity_type(cls, v: str) -> str:
        """Valida o tipo de entidade"""
        allowed = [
            "BusinessCase", "Demand", "Requirement", "UseCase", 
            "UserStory", "Estimate", "Sprint", "TestCase", "Release", "GMUD"
        ]
        if v not in allowed:
            raise ValueError(f"EntityType deve ser um de: {', '.join(allowed)}")
        return v


class WorkflowStatusUpdate(BaseUpdateSchema):
    """Schema para atualização de WorkflowStatus"""
    
    EntityType: Optional[str] = Field(None, max_length=50)
    Code: Optional[str] = Field(None, max_length=30)
    Name: Optional[str] = Field(None, max_length=100)
    Description: Optional[str] = Field(None, max_length=500)
    IsFinal: Optional[bool] = None
    IsRejection: Optional[bool] = None
    DisplayOrder: Optional[int] = Field(None, ge=1)
    ColorHex: Optional[str] = Field(None, max_length=7, pattern=r"^#[0-9A-Fa-f]{6}$")
    IsActive: Optional[bool] = None


class WorkflowStatusResponse(BaseResponseSchema):
    """Schema para resposta de WorkflowStatus"""
    
    WorkflowStatusId: UUID
    EntityType: str
    Code: str
    Name: str
    Description: Optional[str]
    IsFinal: bool
    IsRejection: bool
    DisplayOrder: int
    ColorHex: Optional[str]
    IsActive: bool


# ==================== ActorComplexity ====================

class ActorComplexityCreate(BaseCreateSchema):
    """Schema para criação de ActorComplexity"""
    
    Code: str = Field(..., max_length=20, description="Código da complexidade")
    Name: str = Field(..., max_length=100, description="Nome da complexidade")
    Description: Optional[str] = Field(None, max_length=500, description="Descrição")
    WeightFactor: float = Field(..., gt=0, description="Fator de peso")
    DisplayOrder: int = Field(..., ge=1, description="Ordem de exibição")
    IsActive: bool = Field(True, description="Está ativo?")


class ActorComplexityUpdate(BaseUpdateSchema):
    """Schema para atualização de ActorComplexity"""
    
    Code: Optional[str] = Field(None, max_length=20)
    Name: Optional[str] = Field(None, max_length=100)
    Description: Optional[str] = Field(None, max_length=500)
    WeightFactor: Optional[float] = Field(None, gt=0)
    DisplayOrder: Optional[int] = Field(None, ge=1)
    IsActive: Optional[bool] = None


class ActorComplexityResponse(BaseResponseSchema):
    """Schema para resposta de ActorComplexity"""
    
    ActorComplexityId: UUID
    Code: str
    Name: str
    Description: Optional[str]
    WeightFactor: float
    DisplayOrder: int
    IsActive: bool


# ==================== UseCaseComplexity ====================

class UseCaseComplexityCreate(BaseCreateSchema):
    """Schema para criação de UseCaseComplexity"""
    
    Code: str = Field(..., max_length=20, description="Código da complexidade")
    Name: str = Field(..., max_length=100, description="Nome da complexidade")
    Description: Optional[str] = Field(None, max_length=500, description="Descrição")
    TransactionMin: int = Field(..., ge=1, description="Número mínimo de transações")
    TransactionMax: int = Field(..., ge=1, description="Número máximo de transações")
    WeightFactor: float = Field(..., gt=0, description="Fator de peso")
    DisplayOrder: int = Field(..., ge=1, description="Ordem de exibição")
    IsActive: bool = Field(True, description="Está ativo?")
    
    @field_validator("TransactionMax")
    @classmethod
    def validate_transaction_max(cls, v: int, info) -> int:
        """Valida que TransactionMax >= TransactionMin"""
        if "TransactionMin" in info.data and v < info.data["TransactionMin"]:
            raise ValueError("TransactionMax deve ser maior ou igual a TransactionMin")
        return v


class UseCaseComplexityUpdate(BaseUpdateSchema):
    """Schema para atualização de UseCaseComplexity"""
    
    Code: Optional[str] = Field(None, max_length=20)
    Name: Optional[str] = Field(None, max_length=100)
    Description: Optional[str] = Field(None, max_length=500)
    TransactionMin: Optional[int] = Field(None, ge=1)
    TransactionMax: Optional[int] = Field(None, ge=1)
    WeightFactor: Optional[float] = Field(None, gt=0)
    DisplayOrder: Optional[int] = Field(None, ge=1)
    IsActive: Optional[bool] = None


class UseCaseComplexityResponse(BaseResponseSchema):
    """Schema para resposta de UseCaseComplexity"""
    
    UseCaseComplexityId: UUID
    Code: str
    Name: str
    Description: Optional[str]
    TransactionMin: int
    TransactionMax: int
    WeightFactor: float
    DisplayOrder: int
    IsActive: bool
