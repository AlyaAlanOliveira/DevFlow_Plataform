"""
DevFlow - Authentication Schemas (Pydantic)
"""
from pydantic import BaseModel, Field, field_validator
from typing import Optional, List
from datetime import datetime
from uuid import UUID
import json


# ==================== EntraIDTenant Schemas ====================

class EntraIDTenantBase(BaseModel):
    """Base schema for EntraIDTenant"""
    CompanyId: UUID
    TenantId: UUID
    TenantName: str = Field(..., min_length=1, max_length=255)
    TenantDomain: str = Field(..., min_length=3, max_length=255)
    ClientId: UUID
    Authority: str = Field(..., min_length=10, max_length=500)
    RedirectUri: str = Field(..., min_length=10, max_length=500)
    PostLogoutRedirectUri: Optional[str] = Field(None, max_length=500)
    IsActive: bool = True
    AllowAutoUserCreation: bool = True
    RequireGroupMembership: bool = False
    AllowedGroupIds: Optional[str] = None  # JSON string
    RoleMappingConfig: Optional[str] = None  # JSON string
    Description: Optional[str] = Field(None, max_length=500)
    ConfigurationNotes: Optional[str] = None
    
    @field_validator('TenantDomain')
    @classmethod
    def validate_domain(cls, v: str) -> str:
        if '.' not in v:
            raise ValueError('Domain must contain at least one dot')
        return v.lower()
    
    @field_validator('AllowedGroupIds', 'RoleMappingConfig')
    @classmethod
    def validate_json(cls, v: Optional[str]) -> Optional[str]:
        if v is not None and v.strip():
            try:
                json.loads(v)
            except json.JSONDecodeError:
                raise ValueError('Must be valid JSON')
        return v


class EntraIDTenantCreate(EntraIDTenantBase):
    """Schema for creating EntraIDTenant"""
    ClientSecret: Optional[str] = Field(None, min_length=1)  # Will be encrypted
    CertificateThumbprint: Optional[str] = Field(None, max_length=100)
    
    @field_validator('ClientSecret', 'CertificateThumbprint')
    @classmethod
    def validate_auth_method(cls, v, info):
        # At least one authentication method required
        if info.field_name == 'ClientSecret':
            cert = info.data.get('CertificateThumbprint')
            if not v and not cert:
                raise ValueError('Either ClientSecret or CertificateThumbprint is required')
        return v


class EntraIDTenantUpdate(BaseModel):
    """Schema for updating EntraIDTenant"""
    TenantName: Optional[str] = Field(None, min_length=1, max_length=255)
    TenantDomain: Optional[str] = Field(None, min_length=3, max_length=255)
    ClientSecret: Optional[str] = None  # Will be encrypted
    CertificateThumbprint: Optional[str] = Field(None, max_length=100)
    Authority: Optional[str] = Field(None, min_length=10, max_length=500)
    RedirectUri: Optional[str] = Field(None, min_length=10, max_length=500)
    PostLogoutRedirectUri: Optional[str] = Field(None, max_length=500)
    IsActive: Optional[bool] = None
    AllowAutoUserCreation: Optional[bool] = None
    RequireGroupMembership: Optional[bool] = None
    AllowedGroupIds: Optional[str] = None
    RoleMappingConfig: Optional[str] = None
    Description: Optional[str] = Field(None, max_length=500)
    ConfigurationNotes: Optional[str] = None


class EntraIDTenantResponse(EntraIDTenantBase):
    """Schema for EntraIDTenant response"""
    EntraIDTenantId: UUID
    CertificateThumbprint: Optional[str] = None
    LastSyncDate: Optional[datetime] = None
    TotalUsersSync: int = 0
    LastLoginDate: Optional[datetime] = None
    CreatedAt: datetime
    CreatedBy: UUID
    UpdatedAt: Optional[datetime] = None
    UpdatedBy: Optional[UUID] = None
    
    # Security: Never return ClientSecret
    
    class Config:
        from_attributes = True


class EntraIDTenantListItem(BaseModel):
    """Simplified schema for listing tenants"""
    EntraIDTenantId: UUID
    CompanyId: UUID
    TenantName: str
    TenantDomain: str
    IsActive: bool
    TotalUsersSync: int
    LastLoginDate: Optional[datetime] = None
    Description: Optional[str] = None
    
    class Config:
        from_attributes = True


# ==================== Authentication Log Schemas ====================

class AuthenticationLogCreate(BaseModel):
    """Schema for creating authentication log"""
    UserId: Optional[UUID] = None
    EntraIDTenantId: Optional[UUID] = None
    Email: str = Field(..., min_length=3, max_length=255)
    LoginStatus: str = Field(..., min_length=1, max_length=50)
    FailureReason: Optional[str] = Field(None, max_length=500)
    IPAddress: Optional[str] = Field(None, max_length=50)
    UserAgent: Optional[str] = Field(None, max_length=500)
    TokenClaims: Optional[str] = None  # JSON


class AuthenticationLogResponse(BaseModel):
    """Schema for authentication log response"""
    AuthenticationLogId: UUID
    UserId: Optional[UUID] = None
    EntraIDTenantId: Optional[UUID] = None
    Email: str
    LoginTimestamp: datetime
    LoginStatus: str
    FailureReason: Optional[str] = None
    IPAddress: Optional[str] = None
    UserAgent: Optional[str] = None
    
    class Config:
        from_attributes = True


# ==================== Helper Schemas ====================

class TenantConfigTest(BaseModel):
    """Schema for testing tenant configuration"""
    EntraIDTenantId: UUID
    TestEmail: Optional[str] = None


class TenantConfigTestResult(BaseModel):
    """Schema for tenant configuration test result"""
    Success: bool
    Message: str
    Details: Optional[dict] = None
