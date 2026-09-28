"""
DevFlow - Authentication Repositories
"""
from typing import List, Optional
from uuid import UUID
from sqlalchemy.orm import Session
from sqlalchemy import and_
from app.repositories.base import BaseRepository
from app.domain.authentication import EntraIDTenant, AuthenticationLog


class EntraIDTenantRepository(BaseRepository[EntraIDTenant]):
    """Repository for EntraIDTenant operations"""
    
    def __init__(self, db: Session):
        super().__init__(EntraIDTenant, db)
    
    def get_by_company_id(self, company_id: UUID) -> Optional[EntraIDTenant]:
        """Get tenant configuration by company ID"""
        return self.db.query(EntraIDTenant).filter(
            and_(
                EntraIDTenant.CompanyId == company_id,
                EntraIDTenant.IsDeleted == False
            )
        ).first()
    
    def get_by_tenant_id(self, tenant_id: UUID) -> Optional[EntraIDTenant]:
        """Get tenant configuration by Entra ID Tenant ID"""
        return self.db.query(EntraIDTenant).filter(
            and_(
                EntraIDTenant.TenantId == tenant_id,
                EntraIDTenant.IsDeleted == False
            )
        ).first()
    
    def get_by_domain(self, domain: str) -> Optional[EntraIDTenant]:
        """Get tenant configuration by domain"""
        return self.db.query(EntraIDTenant).filter(
            and_(
                EntraIDTenant.TenantDomain == domain.lower(),
                EntraIDTenant.IsDeleted == False
            )
        ).first()
    
    def get_by_client_id(self, client_id: UUID) -> Optional[EntraIDTenant]:
        """Get tenant configuration by Client ID"""
        return self.db.query(EntraIDTenant).filter(
            and_(
                EntraIDTenant.ClientId == client_id,
                EntraIDTenant.IsDeleted == False
            )
        ).first()
    
    def get_active_tenants(self) -> List[EntraIDTenant]:
        """Get all active tenant configurations"""
        return self.db.query(EntraIDTenant).filter(
            and_(
                EntraIDTenant.IsActive == True,
                EntraIDTenant.IsDeleted == False
            )
        ).all()
    
    def get_all_tenants(self, active_only: bool = False) -> List[EntraIDTenant]:
        """Get all tenant configurations"""
        query = self.db.query(EntraIDTenant).filter(
            EntraIDTenant.IsDeleted == False
        )
        
        if active_only:
            query = query.filter(EntraIDTenant.IsActive == True)
        
        return query.order_by(EntraIDTenant.TenantName).all()


class AuthenticationLogRepository(BaseRepository[AuthenticationLog]):
    """Repository for AuthenticationLog operations"""
    
    def __init__(self, db: Session):
        super().__init__(AuthenticationLog, db)
    
    def get_by_user(
        self,
        user_id: UUID,
        limit: int = 100
    ) -> List[AuthenticationLog]:
        """Get authentication logs for a user"""
        return self.db.query(AuthenticationLog).filter(
            AuthenticationLog.UserId == user_id
        ).order_by(
            AuthenticationLog.LoginTimestamp.desc()
        ).limit(limit).all()
    
    def get_by_email(
        self,
        email: str,
        limit: int = 100
    ) -> List[AuthenticationLog]:
        """Get authentication logs for an email"""
        return self.db.query(AuthenticationLog).filter(
            AuthenticationLog.Email == email.lower()
        ).order_by(
            AuthenticationLog.LoginTimestamp.desc()
        ).limit(limit).all()
    
    def get_by_tenant(
        self,
        tenant_id: UUID,
        limit: int = 100
    ) -> List[AuthenticationLog]:
        """Get authentication logs for a tenant"""
        return self.db.query(AuthenticationLog).filter(
            AuthenticationLog.EntraIDTenantId == tenant_id
        ).order_by(
            AuthenticationLog.LoginTimestamp.desc()
        ).limit(limit).all()
    
    def get_failed_attempts(
        self,
        email: str,
        minutes: int = 30
    ) -> List[AuthenticationLog]:
        """Get recent failed login attempts for an email"""
        from datetime import datetime, timedelta
        
        cutoff = datetime.utcnow() - timedelta(minutes=minutes)
        
        return self.db.query(AuthenticationLog).filter(
            and_(
                AuthenticationLog.Email == email.lower(),
                AuthenticationLog.LoginStatus == 'Failed',
                AuthenticationLog.LoginTimestamp >= cutoff
            )
        ).order_by(
            AuthenticationLog.LoginTimestamp.desc()
        ).all()
