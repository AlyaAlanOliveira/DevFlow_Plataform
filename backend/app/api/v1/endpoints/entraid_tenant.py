"""
DevFlow - Entra ID Tenant Management Endpoints
PROTECTED: Requires AdminDevFlow permission
"""
from typing import List
from uuid import UUID
from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session

from app.core.database import get_db
from app.core.security import require_admin_devflow, get_admin_user
from app.services.authentication import EntraIDTenantService
from app.schemas.authentication import (
    EntraIDTenantCreate,
    EntraIDTenantUpdate,
    EntraIDTenantResponse,
    EntraIDTenantListItem,
    TenantConfigTest,
    TenantConfigTestResult
)


router = APIRouter(
    prefix="/entraid-tenants",
    tags=["Entra ID Tenants (Admin Only)"],
    dependencies=[Depends(require_admin_devflow)]
)


@router.get(
    "",
    response_model=List[EntraIDTenantListItem],
    summary="List all Entra ID Tenants",
    description="Get list of all configured Entra ID tenants. **Requires AdminDevFlow permission.**"
)
async def list_tenants(
    active_only: bool = False,
    db: Session = Depends(get_db)
):
    """
    List all Entra ID tenant configurations.
    
    **Security:** Requires AdminDevFlow flag.
    
    **Parameters:**
    - **active_only**: If true, return only active tenants
    
    **Returns:** List of tenant configurations (without sensitive data)
    """
    service = EntraIDTenantService(db)
    tenants = service.get_all(active_only=active_only)
    return tenants


@router.get(
    "/{tenant_id}",
    response_model=EntraIDTenantResponse,
    summary="Get Entra ID Tenant by ID",
    description="Get detailed tenant configuration. **Requires AdminDevFlow permission.**"
)
async def get_tenant(
    tenant_id: UUID,
    db: Session = Depends(get_db)
):
    """
    Get detailed Entra ID tenant configuration by ID.
    
    **Security:** Requires AdminDevFlow flag.
    
    **Note:** Client secret is never returned for security reasons.
    
    **Parameters:**
    - **tenant_id**: UUID of the tenant configuration
    
    **Returns:** Detailed tenant configuration
    """
    service = EntraIDTenantService(db)
    tenant = service.get_by_id(tenant_id)
    
    if not tenant:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"Tenant configuration not found: {tenant_id}"
        )
    
    return tenant


@router.get(
    "/company/{company_id}",
    response_model=EntraIDTenantResponse,
    summary="Get Entra ID Tenant by Company",
    description="Get tenant configuration for a specific company. **Requires AdminDevFlow permission.**"
)
async def get_tenant_by_company(
    company_id: UUID,
    db: Session = Depends(get_db)
):
    """
    Get Entra ID tenant configuration for a specific company.
    
    **Security:** Requires AdminDevFlow flag.
    
    **Parameters:**
    - **company_id**: UUID of the company
    
    **Returns:** Tenant configuration for the company
    """
    service = EntraIDTenantService(db)
    tenant = service.get_by_company_id(company_id)
    
    if not tenant:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"No tenant configuration found for company: {company_id}"
        )
    
    return tenant


@router.post(
    "",
    response_model=EntraIDTenantResponse,
    status_code=status.HTTP_201_CREATED,
    summary="Create Entra ID Tenant",
    description="Create new Entra ID tenant configuration. **Requires AdminDevFlow permission.**"
)
async def create_tenant(
    data: EntraIDTenantCreate,
    db: Session = Depends(get_db),
    current_user = Depends(get_admin_user)
):
    """
    Create new Entra ID tenant configuration.
    
    **Security:** Requires AdminDevFlow flag.
    
    **Important:**
    - Client secret will be encrypted before storage
    - Either ClientSecret or CertificateThumbprint is required
    - TenantDomain will be converted to lowercase
    
    **Parameters:**
    - **data**: Tenant configuration data
    
    **Returns:** Created tenant configuration
    """
    service = EntraIDTenantService(db)
    
    # Check if company already has a tenant
    existing = service.get_by_company_id(data.CompanyId)
    if existing:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=f"Company already has a tenant configuration: {existing.TenantName}"
        )
    
    # Check if tenant ID already exists
    existing = service.get_by_tenant_id(data.TenantId)
    if existing:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=f"Tenant ID already configured: {existing.TenantName}"
        )
    
    try:
        tenant = service.create(data, current_user.UserId)
        return tenant
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Error creating tenant configuration: {str(e)}"
        )


@router.put(
    "/{tenant_id}",
    response_model=EntraIDTenantResponse,
    summary="Update Entra ID Tenant",
    description="Update Entra ID tenant configuration. **Requires AdminDevFlow permission.**"
)
async def update_tenant(
    tenant_id: UUID,
    data: EntraIDTenantUpdate,
    db: Session = Depends(get_db),
    current_user = Depends(get_admin_user)
):
    """
    Update Entra ID tenant configuration.
    
    **Security:** Requires AdminDevFlow flag.
    
    **Important:**
    - Client secret will be encrypted if provided
    - Only provided fields will be updated
    
    **Parameters:**
    - **tenant_id**: UUID of the tenant to update
    - **data**: Updated tenant configuration data
    
    **Returns:** Updated tenant configuration
    """
    service = EntraIDTenantService(db)
    
    tenant = service.update(tenant_id, data, current_user.UserId)
    
    if not tenant:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"Tenant configuration not found: {tenant_id}"
        )
    
    return tenant


@router.delete(
    "/{tenant_id}",
    status_code=status.HTTP_204_NO_CONTENT,
    summary="Delete Entra ID Tenant",
    description="Soft delete Entra ID tenant configuration. **Requires AdminDevFlow permission.**"
)
async def delete_tenant(
    tenant_id: UUID,
    db: Session = Depends(get_db),
    current_user = Depends(get_admin_user)
):
    """
    Soft delete Entra ID tenant configuration.
    
    **Security:** Requires AdminDevFlow flag.
    
    **Important:**
    - This is a soft delete (IsDeleted = true)
    - Configuration can be restored if needed
    - Users won't be able to authenticate via this tenant after deletion
    
    **Parameters:**
    - **tenant_id**: UUID of the tenant to delete
    """
    service = EntraIDTenantService(db)
    
    success = service.delete(tenant_id, current_user.UserId)
    
    if not success:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"Tenant configuration not found: {tenant_id}"
        )
    
    return None


@router.post(
    "/{tenant_id}/test",
    response_model=TenantConfigTestResult,
    summary="Test Entra ID Tenant Configuration",
    description="Test tenant configuration validity. **Requires AdminDevFlow permission.**"
)
async def test_tenant_config(
    tenant_id: UUID,
    db: Session = Depends(get_db)
):
    """
    Test Entra ID tenant configuration.
    
    **Security:** Requires AdminDevFlow flag.
    
    **Note:** This performs basic validation only.
    Full OAuth flow testing should be done separately.
    
    **Parameters:**
    - **tenant_id**: UUID of the tenant to test
    
    **Returns:** Test result with success status and details
    """
    service = EntraIDTenantService(db)
    result = service.test_configuration(tenant_id)
    
    return TenantConfigTestResult(**result)
