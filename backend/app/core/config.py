"""
DevFlow - Core Configuration
Configurações centralizadas da aplicação
"""
from typing import List
from pydantic_settings import BaseSettings
from pydantic import Field


class Settings(BaseSettings):
    """Configurações da aplicação"""
    
    # Application
    APP_NAME: str = "DevFlow ALYA"
    APP_VERSION: str = "1.0.0"
    APP_ENV: str = "development"
    DEBUG: bool = True
    
    # Database
    DB_DRIVER: str = "ODBC Driver 18 for SQL Server"
    DB_SERVER: str = "ALYA-TI-001\\SQLSERVERLOCAL"
    DB_NAME: str = "DevFlow_ALYA"
    DB_USER: str = "DevFlowUser"
    DB_PASSWORD: str = "D3vFl0w#Us3r35"
    DB_POOL_SIZE: int = 10
    DB_MAX_OVERFLOW: int = 20
    DB_POOL_TIMEOUT: int = 30
    DB_ECHO: bool = False
    
    # Security
    SECRET_KEY: str = "your-secret-key-here-change-in-production"
    ALGORITHM: str = "HS256"
    ACCESS_TOKEN_EXPIRE_MINUTES: int = 30
    
    # CORS
    CORS_ORIGINS: List[str] = [
        "http://localhost:3000",
        "http://localhost:5173",
        "http://localhost:8080"
    ]
    
    # API
    API_V1_PREFIX: str = "/api/v1"
    API_DOCS_URL: str = "/docs"
    API_REDOC_URL: str = "/redoc"
    
    # Logging
    LOG_LEVEL: str = "INFO"
    LOG_FORMAT: str = "json"
    
    @property
    def database_url(self) -> str:
        """Retorna a URL de conexão do banco de dados"""
        return (
            f"mssql+pyodbc://{self.DB_USER}:{self.DB_PASSWORD}"
            f"@{self.DB_SERVER}/{self.DB_NAME}"
            f"?driver={self.DB_DRIVER.replace(' ', '+')}"
            f"&TrustServerCertificate=yes"
        )
    
    class Config:
        env_file = ".env"
        case_sensitive = True


# Instância global de configurações
settings = Settings()
