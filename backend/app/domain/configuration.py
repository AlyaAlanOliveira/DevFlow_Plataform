"""
DevFlow - Configuration Domain Models
Models para tabelas de configuração (schema cfg)
"""
from datetime import date
from sqlalchemy import Column, String, Integer, Boolean, Numeric, Date, Text, ForeignKey
from sqlalchemy.dialects.mssql import UNIQUEIDENTIFIER
from sqlalchemy.orm import relationship
from app.domain.base import BaseModel


class Operation(BaseModel):
    """Model para cfg.Operation"""
    
    __tablename__ = "Operation"
    __table_args__ = {"schema": "cfg"}
    
    OperationId = Column(UNIQUEIDENTIFIER, primary_key=True)
    Code = Column(String(20), nullable=False, unique=True)
    Name = Column(String(200), nullable=False)
    Description = Column(String(1000), nullable=True)
    CompanyId = Column(UNIQUEIDENTIFIER, ForeignKey("gov.Company.CompanyId"), nullable=False)
    ClientType = Column(String(30), nullable=False)
    IsActive = Column(Boolean, nullable=False, default=True)


class UCPConfiguration(BaseModel):
    """Model para cfg.UCPConfiguration"""
    
    __tablename__ = "UCPConfiguration"
    __table_args__ = {"schema": "cfg"}
    
    UCPConfigurationId = Column(UNIQUEIDENTIFIER, primary_key=True)
    Name = Column(String(200), nullable=False)
    Description = Column(String(1000), nullable=True)
    HoursPerUCP = Column(Numeric(5, 2), nullable=False)
    DevelopmentPercentage = Column(Numeric(5, 2), nullable=False, default=60.00)
    TestPercentage = Column(Numeric(5, 2), nullable=False, default=20.00)
    HomologationPercentage = Column(Numeric(5, 2), nullable=False, default=20.00)
    HourlyRate = Column(Numeric(10, 2), nullable=True)
    EffectiveFrom = Column(Date, nullable=False)
    EffectiveTo = Column(Date, nullable=True)
    IsActive = Column(Boolean, nullable=False, default=True)


class ApplicationSettings(BaseModel):
    """Model para cfg.ApplicationSettings"""
    
    __tablename__ = "ApplicationSettings"
    __table_args__ = {"schema": "cfg"}
    
    ApplicationSettingId = Column(UNIQUEIDENTIFIER, primary_key=True)
    SettingKey = Column(String(100), nullable=False, unique=True)
    SettingValue = Column(Text, nullable=False)
    DataType = Column(String(20), nullable=False)
    Description = Column(String(500), nullable=True)
    IsEncrypted = Column(Boolean, nullable=False, default=False)
    IsActive = Column(Boolean, nullable=False, default=True)
