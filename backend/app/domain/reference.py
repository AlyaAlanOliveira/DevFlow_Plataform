"""
DevFlow - Reference Domain Models
Models para tabelas de referência (schema ref)
"""
from sqlalchemy import Column, String, Integer, Boolean, Numeric
from sqlalchemy.dialects.mssql import UNIQUEIDENTIFIER
from app.domain.base import BaseModel


class Priority(BaseModel):
    """Model para ref.Priority"""
    
    __tablename__ = "Priority"
    __table_args__ = {"schema": "ref"}
    
    PriorityId = Column(UNIQUEIDENTIFIER, primary_key=True)
    Code = Column(String(20), nullable=False, unique=True)
    Name = Column(String(100), nullable=False)
    Description = Column(String(500), nullable=True)
    SLADays = Column(Integer, nullable=False)
    ColorHex = Column(String(7), nullable=True)
    DisplayOrder = Column(Integer, nullable=False)
    IsActive = Column(Boolean, nullable=False, default=True)


class DemandType(BaseModel):
    """Model para ref.DemandType"""
    
    __tablename__ = "DemandType"
    __table_args__ = {"schema": "ref"}
    
    DemandTypeId = Column(UNIQUEIDENTIFIER, primary_key=True)
    Code = Column(String(20), nullable=False, unique=True)
    Name = Column(String(100), nullable=False)
    Description = Column(String(500), nullable=True)
    RequiresImpactAnalysis = Column(Boolean, nullable=False, default=False)
    RequiresSecurityReview = Column(Boolean, nullable=False, default=False)
    IsActive = Column(Boolean, nullable=False, default=True)


class WorkflowStatus(BaseModel):
    """Model para ref.WorkflowStatus"""
    
    __tablename__ = "WorkflowStatus"
    __table_args__ = {"schema": "ref"}
    
    WorkflowStatusId = Column(UNIQUEIDENTIFIER, primary_key=True)
    EntityType = Column(String(50), nullable=False)
    Code = Column(String(30), nullable=False)
    Name = Column(String(100), nullable=False)
    Description = Column(String(500), nullable=True)
    IsFinal = Column(Boolean, nullable=False, default=False)
    IsRejection = Column(Boolean, nullable=False, default=False)
    DisplayOrder = Column(Integer, nullable=False)
    ColorHex = Column(String(7), nullable=True)
    IsActive = Column(Boolean, nullable=False, default=True)


class ActorComplexity(BaseModel):
    """Model para ref.ActorComplexity"""
    
    __tablename__ = "ActorComplexity"
    __table_args__ = {"schema": "ref"}
    
    ActorComplexityId = Column(UNIQUEIDENTIFIER, primary_key=True)
    Code = Column(String(20), nullable=False, unique=True)
    Name = Column(String(100), nullable=False)
    Description = Column(String(500), nullable=True)
    WeightFactor = Column(Numeric(5, 2), nullable=False)
    DisplayOrder = Column(Integer, nullable=False)
    IsActive = Column(Boolean, nullable=False, default=True)


class UseCaseComplexity(BaseModel):
    """Model para ref.UseCaseComplexity"""
    
    __tablename__ = "UseCaseComplexity"
    __table_args__ = {"schema": "ref"}
    
    UseCaseComplexityId = Column(UNIQUEIDENTIFIER, primary_key=True)
    Code = Column(String(20), nullable=False, unique=True)
    Name = Column(String(100), nullable=False)
    Description = Column(String(500), nullable=True)
    TransactionMin = Column(Integer, nullable=False)
    TransactionMax = Column(Integer, nullable=False)
    WeightFactor = Column(Numeric(5, 2), nullable=False)
    DisplayOrder = Column(Integer, nullable=False)
    IsActive = Column(Boolean, nullable=False, default=True)
