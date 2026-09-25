"""
DevFlow - Database Configuration
Configuração do SQLAlchemy e gerenciamento de sessões
"""
from typing import Generator
from sqlalchemy import create_engine, event
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker, Session
from app.core.config import settings

# Engine do SQLAlchemy
engine = create_engine(
    settings.database_url,
    pool_size=settings.DB_POOL_SIZE,
    max_overflow=settings.DB_MAX_OVERFLOW,
    pool_timeout=settings.DB_POOL_TIMEOUT,
    echo=settings.DB_ECHO,
    pool_pre_ping=True,  # Verifica conexão antes de usar
)

# Session factory
SessionLocal = sessionmaker(
    autocommit=False,
    autoflush=False,
    bind=engine
)

# Base para os models
Base = declarative_base()


def get_db() -> Generator[Session, None, None]:
    """
    Dependency para obter sessão do banco de dados
    
    Yields:
        Session: Sessão do SQLAlchemy
    """
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()


# Event listener para configurar timezone UTC
@event.listens_for(engine, "connect")
def set_timezone_utc(dbapi_conn, connection_record):
    """Configura timezone UTC para a conexão"""
    cursor = dbapi_conn.cursor()
    cursor.execute("SET TIME ZONE 'UTC'")
    cursor.close()
