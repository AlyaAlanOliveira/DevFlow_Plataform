"""
DevFlow - Authentication Services
"""
from typing import List, Optional
from uuid import UUID
from sqlalchemy.orm import Session
from cryptography.fernet import Fernet
import os
import base64

from app.repositories.authentication import (
    EntraIDTenantRepository,
    AuthenticationLogRepository
)
from app.schemas.authentication import (
    EntraIDTenantCreate,
    EntraIDTenantUpdate,
    EntraIDTenantResponse,
    AuthenticationLogCreate
)
from app.domain.authentication import EntraIDTenant


class EntraIDTenantService:
    """Service for managing Entra ID Tenant configurations"""
    
    def __init__(self, db: Session):
        self.db = db
        self.repository = EntraIDTenantRepository(db)
        self._init_encryption()
    
    def _init_encryption(self):
        """Initialize encryption key for client secrets"""
        # In production, this should come from environment variable or key vault
        encryption_key = os.getenv('ENCRYPTION_KEY')
        if not encryption_key:
            # Generate a key for development (DO NOT use in production)
            encryption_key = Fernet.generate_key().decode()
            print(f"WARNING: Using generated encryption key. Set ENCRYPTION_KEY in production!")
        
        self.cipher = Fernet(encryption_key.encode())
    
    def _encrypt_secret(self, secret: str) -> str:
        """Encrypt client secret"""
        if not secret:
            return None
        return self.cipher.encrypt(secret.encode()).decode()
    
    def _decrypt_secret(self, encrypted_secret: str) -> str:
        """Decrypt client secret"""
        if not encrypted_secret:
            return None
        return self.cipher.decrypt(encrypted_secret.encode()).decode()
    
    def get_all(self, active_only: bool = False) -> List[EntraIDTenant]:
        """Get all tenant configurations"""
        return self.repository.get_all_tenants(active_only=active_only)
    
    def get_by_id(self, tenant_id: UUID) -> Optional[EntraIDTenant]:
        """Get tenant configuration by ID"""
        return self.repository.get_by_id(tenant_id)
    
    def get_by_company_id(self, company_id: UUID) -> Optional[EntraIDTenant]:
        """Get tenant configuration by company ID"""
        return self.repository.get_by_company_id(company_id)
    
    def get_by_domain(self, domain: str) -> Optional[EntraIDTenant]:
        """Get tenant configuration by domain"""
        return self.repository.get_by_domain(domain)
    
    def create(
        self,
        data: EntraIDTenantCreate,
        created_by: UUID
    ) -> EntraIDTenant:
        """Create new tenant configuration"""
        # Encrypt client secret if provided
        encrypted_secret = None
        if data.ClientSecret:
            encrypted_secret = self._encrypt_secret(data.ClientSecret)
        
        # Build authority URL if not provided
        authority = data.Authority
        if not authority:
            authority = f"https://login.microsoftonline.com/{data.TenantId}"
        
        tenant = EntraIDTenant(
            CompanyId=data.CompanyId,
            TenantId=data.TenantId,
            TenantName=data.TenantName,
            TenantDomain=data.TenantDomain.lower(),
            ClientId=data.ClientId,
            ClientSecretEncrypted=encrypted_secret,
            CertificateThumbprint=data.CertificateThumbprint,
            Authority=authority,
            RedirectUri=data.RedirectUri,
            PostLogoutRedirectUri=data.PostLogoutRedirectUri,
            IsActive=data.IsActive,
            AllowAutoUserCreation=data.AllowAutoUserCreation,
            RequireGroupMembership=data.RequireGroupMembership,
            AllowedGroupIds=data.AllowedGroupIds,
            RoleMappingConfig=data.RoleMappingConfig,
            Description=data.Description,
            ConfigurationNotes=data.ConfigurationNotes,
            CreatedBy=created_by
        )
        
        return self.repository.create(tenant)
    
    def update(
        self,
        tenant_id: UUID,
        data: EntraIDTenantUpdate,
        updated_by: UUID
    ) -> Optional[EntraIDTenant]:
        """Update tenant configuration"""
        tenant = self.repository.get_by_id(tenant_id)
        if not tenant:
            return None
        
        # Update fields
        update_data = data.model_dump(exclude_unset=True)
        
        # Handle client secret encryption
        if 'ClientSecret' in update_data:
            client_secret = update_data.pop('ClientSecret')
            if client_secret:
                update_data['ClientSecretEncrypted'] = self._encrypt_secret(client_secret)
        
        # Update domain to lowercase
        if 'TenantDomain' in update_data:
            update_data['TenantDomain'] = update_data['TenantDomain'].lower()
        
        return self.repository.update(tenant_id, update_data, updated_by)
    
    def delete(
        self,
        tenant_id: UUID,
        deleted_by: UUID
    ) -> bool:
        """Soft delete tenant configuration"""
        return self.repository.soft_delete(tenant_id, deleted_by)
    
    def get_decrypted_secret(self, tenant_id: UUID) -> Optional[str]:
        """
        Get decrypted client secret (use with caution!)
        Only for internal use during authentication flow.
        """
        tenant = self.repository.get_by_id(tenant_id)
        if not tenant or not tenant.ClientSecretEncrypted:
            return None
        
        return self._decrypt_secret(tenant.ClientSecretEncrypted)
    
    def test_configuration(self, tenant_id: UUID) -> dict:
        """
        Test tenant configuration (basic validation)
        Full OAuth flow testing should be done separately
        """
        tenant = self.repository.get_by_id(tenant_id)
        if not tenant:
            return {
                'success': False,
                'message': 'Tenant configuration not found'
            }
        
        issues = []
        
        # Check required fields
        if not tenant.IsActive:
            issues.append('Tenant is not active')
        
        if not tenant.ClientSecretEncrypted and not tenant.CertificateThumbprint:
            issues.append('No authentication method configured')
        
        if not tenant.Authority:
            issues.append('Authority URL not configured')
        
        if not tenant.RedirectUri:
            issues.append('Redirect URI not configured')
        
        if issues:
            return {
                'success': False,
                'message': 'Configuration has issues',
                'issues': issues
            }
        
        return {
            'success': True,
            'message': 'Configuration appears valid',
            'tenant_name': tenant.TenantName,
            'tenant_domain': tenant.TenantDomain
        }


class AuthenticationLogService:
    """Service for managing authentication logs"""
    
    def __init__(self, db: Session):
        self.db = db
        self.repository = AuthenticationLogRepository(db)
    
    def log_authentication(
        self,
        data: AuthenticationLogCreate
    ) -> None:
        """Log an authentication attempt"""
        from datetime import datetime
        from app.domain.authentication import AuthenticationLog
        
        log = AuthenticationLog(
            UserId=data.UserId,
            EntraIDTenantId=data.EntraIDTenantId,
            Email=data.Email.lower(),
            LoginTimestamp=datetime.utcnow(),
            LoginStatus=data.LoginStatus,
            FailureReason=data.FailureReason,
            IPAddress=data.IPAddress,
            UserAgent=data.UserAgent,
            TokenClaims=data.TokenClaims
        )
        
        self.repository.create(log)
    
    def get_user_logs(
        self,
        user_id: UUID,
        limit: int = 100
    ) -> List:
        """Get authentication logs for a user"""
        return self.repository.get_by_user(user_id, limit)
    
    def get_email_logs(
        self,
        email: str,
        limit: int = 100
    ) -> List:
        """Get authentication logs for an email"""
        return self.repository.get_by_email(email, limit)
    
    def check_failed_attempts(
        self,
        email: str,
        max_attempts: int = 5,
        minutes: int = 30
    ) -> tuple[bool, int]:
        """
        Check if email has too many failed login attempts
        Returns (is_blocked, attempt_count)
        """
        failed = self.repository.get_failed_attempts(email, minutes)
        attempt_count = len(failed)
        is_blocked = attempt_count >= max_attempts
        
        return is_blocked, attempt_count
