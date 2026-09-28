"""
DevFlow - Security and Authorization
"""
from typing import Optional
from uuid import UUID
from fastapi import Depends, HTTPException, status
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials
from sqlalchemy.orm import Session

from app.core.database import get_db


# Security scheme for JWT tokens (future implementation)
security = HTTPBearer(auto_error=False)


class AuthorizationError(HTTPException):
    """Custom exception for authorization errors"""
    def __init__(self, detail: str = "Not authorized"):
        super().__init__(
            status_code=status.HTTP_403_FORBIDDEN,
            detail=detail
        )


class AuthenticationError(HTTPException):
    """Custom exception for authentication errors"""
    def __init__(self, detail: str = "Not authenticated"):
        super().__init__(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail=detail,
            headers={"WWW-Authenticate": "Bearer"}
        )


# ==================== Current User Dependencies ====================

async def get_current_user_id(
    credentials: Optional[HTTPAuthorizationCredentials] = Depends(security),
    db: Session = Depends(get_db)
) -> UUID:
    """
    Get current authenticated user ID from JWT token.
    
    TODO: Implement full JWT validation when Entra ID is configured.
    For now, returns a mock admin user ID for development.
    """
    # TODO: Implement JWT token validation
    # 1. Validate token signature
    # 2. Check token expiration
    # 3. Extract user ID from claims
    # 4. Verify user exists in database
    
    # TEMPORARY: Return mock admin user for development
    # This should be replaced with actual JWT validation
    mock_admin_id = UUID('00000000-0000-0000-0000-000000000001')
    
    if not credentials:
        # For development, allow unauthenticated access
        # TODO: Remove this in production
        return mock_admin_id
    
    # TODO: Validate token and extract user ID
    return mock_admin_id


async def get_current_user(
    user_id: UUID = Depends(get_current_user_id),
    db: Session = Depends(get_db)
):
    """
    Get current authenticated user object.
    
    TODO: Implement full user retrieval when Entra ID is configured.
    """
    from app.domain.security import User
    
    user = db.query(User).filter(User.UserId == user_id).first()
    
    if not user:
        raise AuthenticationError("User not found")
    
    if not user.IsActive:
        raise AuthorizationError("User account is inactive")
    
    return user


# ==================== Admin Authorization ====================

async def require_admin_devflow(
    current_user = Depends(get_current_user)
):
    """
    Require that the current user has AdminDevFlow flag.
    
    Use this dependency on endpoints that should only be accessible
    to DevFlow administrators.
    
    Example:
        @router.get("/admin/tenants", dependencies=[Depends(require_admin_devflow)])
        async def get_tenants():
            ...
    """
    if not hasattr(current_user, 'IsAdminDevFlow'):
        raise AuthorizationError("User does not have admin privileges")
    
    if not current_user.IsAdminDevFlow:
        raise AuthorizationError(
            "Access denied. This resource requires DevFlow Administrator privileges."
        )
    
    return current_user


async def get_admin_user(
    user = Depends(require_admin_devflow)
):
    """
    Get current user and ensure they are a DevFlow admin.
    Returns the user object for use in endpoint logic.
    """
    return user


# ==================== Permission Checking ====================

def check_permission(
    user,
    resource: str,
    action: str
) -> bool:
    """
    Check if user has permission for a specific resource and action.
    
    Args:
        user: User object
        resource: Resource name (e.g., "EntraIDTenant", "User")
        action: Action name (e.g., "Create", "Read", "Update", "Delete")
    
    Returns:
        bool: True if user has permission
    
    TODO: Implement full RBAC when permission system is ready
    """
    # Admin DevFlow has all permissions
    if hasattr(user, 'IsAdminDevFlow') and user.IsAdminDevFlow:
        return True
    
    # TODO: Implement role-based permission checking
    # 1. Get user roles
    # 2. Get role permissions
    # 3. Check if any role has the required permission
    
    return False


async def require_permission(
    resource: str,
    action: str,
    current_user = Depends(get_current_user)
):
    """
    Require that the current user has a specific permission.
    
    Example:
        @router.post("/demands", dependencies=[Depends(require_permission("Demand", "Create"))])
        async def create_demand():
            ...
    """
    if not check_permission(current_user, resource, action):
        raise AuthorizationError(
            f"Access denied. Required permission: {resource}.{action}"
        )
    
    return current_user


# ==================== Helper Functions ====================

def create_access_token(data: dict, expires_delta: Optional[int] = None) -> str:
    """
    Create JWT access token.
    
    TODO: Implement JWT token creation
    """
    # TODO: Implement JWT token creation with expiration
    pass


def verify_token(token: str) -> dict:
    """
    Verify and decode JWT token.
    
    TODO: Implement JWT token verification
    """
    # TODO: Implement JWT token verification
    pass


def hash_password(password: str) -> str:
    """
    Hash password using bcrypt.
    
    Note: Not needed for Entra ID authentication,
    but useful for local admin accounts.
    """
    from passlib.context import CryptContext
    pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")
    return pwd_context.hash(password)


def verify_password(plain_password: str, hashed_password: str) -> bool:
    """
    Verify password against hash.
    """
    from passlib.context import CryptContext
    pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")
    return pwd_context.verify(plain_password, hashed_password)
