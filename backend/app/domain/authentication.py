"""
DevFlow - Authentication Domain Models
"""
from sqlalchemy import Column, String, Boolean, Integer, DateTime, Text, ForeignKey
from sqlalchemy.dialects.mssql import UNIQUEIDENTIFIER
from sqlalchemy.orm import relationship
from app.domain.base import BaseModel
import uuid


class EntraIDTenant(BaseModel):
    """
    Configuração de Tenant Entra ID (Azure AD) para autenticação multi-tenant.
    
    Suporta múltiplos tenants (ALYA, Mobyan, TaNaPorta, futuros) com
    configuração centralizada e auditada.
    """
    __tablename__ = "EntraIDTenant"
    __table_args__ = {'schema': 'auth'}
    
    # Identificação
    EntraIDTenantId = Column(
        UNIQUEIDENTIFIER,
        primary_key=True,
        default=uuid.uuid4,
        nullable=False
    )
    CompanyId = Column(
        UNIQUEIDENTIFIER,
        ForeignKey('gov.Company.CompanyId'),
        nullable=False,
        unique=True
    )
    
    # Configuração Entra ID
    TenantId = Column(UNIQUEIDENTIFIER, nullable=False, unique=True)
    TenantName = Column(String(255), nullable=False)
    TenantDomain = Column(String(255), nullable=False)
    
    # App Registration
    ClientId = Column(UNIQUEIDENTIFIER, nullable=False, unique=True)
    ClientSecretEncrypted = Column(Text, nullable=True)  # Encrypted
    CertificateThumbprint = Column(String(100), nullable=True)
    
    # Endpoints
    Authority = Column(String(500), nullable=False)
    RedirectUri = Column(String(500), nullable=False)
    PostLogoutRedirectUri = Column(String(500), nullable=True)
    
    # Configurações
    IsActive = Column(Boolean, nullable=False, default=True)
    AllowAutoUserCreation = Column(Boolean, nullable=False, default=True)
    RequireGroupMembership = Column(Boolean, nullable=False, default=False)
    AllowedGroupIds = Column(Text, nullable=True)  # JSON array
    
    # Mapeamento de Roles
    RoleMappingConfig = Column(Text, nullable=True)  # JSON config
    
    # Metadados
    Description = Column(String(500), nullable=True)
    ConfigurationNotes = Column(Text, nullable=True)
    
    # Estatísticas
    LastSyncDate = Column(DateTime, nullable=True)
    TotalUsersSync = Column(Integer, nullable=False, default=0)
    LastLoginDate = Column(DateTime, nullable=True)
    
    # Relationships
    # company = relationship("Company", back_populates="entraid_tenant")
    
    def __repr__(self):
        return f"<EntraIDTenant {self.TenantName} ({self.TenantDomain})>"


class AuthenticationLog(BaseModel):
    """
    Log de tentativas de autenticação via Entra ID.
    
    Registra sucessos, falhas e informações técnicas para auditoria.
    """
    __tablename__ = "AuthenticationLog"
    __table_args__ = {'schema': 'auth'}
    
    AuthenticationLogId = Column(
        UNIQUEIDENTIFIER,
        primary_key=True,
        default=uuid.uuid4,
        nullable=False
    )
    UserId = Column(
        UNIQUEIDENTIFIER,
        ForeignKey('sec.User.UserId'),
        nullable=True
    )
    EntraIDTenantId = Column(
        UNIQUEIDENTIFIER,
        ForeignKey('auth.EntraIDTenant.EntraIDTenantId'),
        nullable=True
    )
    
    # Dados do Login
    Email = Column(String(255), nullable=False)
    LoginTimestamp = Column(DateTime, nullable=False)
    LoginStatus = Column(String(50), nullable=False)  # Success, Failed, Blocked
    FailureReason = Column(String(500), nullable=True)
    
    # Dados Técnicos
    IPAddress = Column(String(50), nullable=True)
    UserAgent = Column(String(500), nullable=True)
    TokenClaims = Column(Text, nullable=True)  # JSON
    
    # Relationships
    # user = relationship("User", back_populates="auth_logs")
    # tenant = relationship("EntraIDTenant", back_populates="auth_logs")
    
    def __repr__(self):
        return f"<AuthenticationLog {self.Email} - {self.LoginStatus}>"
