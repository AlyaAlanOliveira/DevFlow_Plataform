"""
DevFlow - Base Repository
Repository base com operações CRUD genéricas
"""
from typing import Generic, TypeVar, Type, List, Optional
from uuid import UUID
from sqlalchemy.orm import Session
from sqlalchemy import and_
from app.domain.base import BaseModel

ModelType = TypeVar("ModelType", bound=BaseModel)


class BaseRepository(Generic[ModelType]):
    """Repository base com operações CRUD"""
    
    def __init__(self, model: Type[ModelType], db: Session):
        """
        Inicializa o repository
        
        Args:
            model: Classe do model SQLAlchemy
            db: Sessão do banco de dados
        """
        self.model = model
        self.db = db
    
    def get_by_id(self, id: UUID) -> Optional[ModelType]:
        """
        Busca registro por ID
        
        Args:
            id: ID do registro
            
        Returns:
            Registro encontrado ou None
        """
        return self.db.query(self.model).filter(
            and_(
                self.model.__table__.c[f"{self.model.__tablename__}Id"] == id,
                self.model.IsDeleted == False
            )
        ).first()
    
    def get_all(
        self, 
        skip: int = 0, 
        limit: int = 100,
        include_deleted: bool = False
    ) -> List[ModelType]:
        """
        Busca todos os registros
        
        Args:
            skip: Número de registros para pular
            limit: Número máximo de registros
            include_deleted: Incluir registros deletados?
            
        Returns:
            Lista de registros
        """
        query = self.db.query(self.model)
        
        if not include_deleted:
            query = query.filter(self.model.IsDeleted == False)
        
        return query.offset(skip).limit(limit).all()
    
    def count(self, include_deleted: bool = False) -> int:
        """
        Conta total de registros
        
        Args:
            include_deleted: Incluir registros deletados?
            
        Returns:
            Total de registros
        """
        query = self.db.query(self.model)
        
        if not include_deleted:
            query = query.filter(self.model.IsDeleted == False)
        
        return query.count()
    
    def create(self, obj: ModelType) -> ModelType:
        """
        Cria novo registro
        
        Args:
            obj: Objeto a ser criado
            
        Returns:
            Objeto criado
        """
        self.db.add(obj)
        self.db.commit()
        self.db.refresh(obj)
        return obj
    
    def update(self, obj: ModelType) -> ModelType:
        """
        Atualiza registro existente
        
        Args:
            obj: Objeto a ser atualizado
            
        Returns:
            Objeto atualizado
        """
        self.db.commit()
        self.db.refresh(obj)
        return obj
    
    def soft_delete(self, id: UUID, deleted_by: UUID) -> bool:
        """
        Faz soft delete de um registro
        
        Args:
            id: ID do registro
            deleted_by: ID do usuário que está deletando
            
        Returns:
            True se deletado com sucesso
        """
        from datetime import datetime
        
        obj = self.get_by_id(id)
        if not obj:
            return False
        
        obj.IsDeleted = True
        obj.DeletedAt = datetime.utcnow()
        obj.DeletedBy = deleted_by
        
        self.db.commit()
        return True
    
    def restore(self, id: UUID) -> bool:
        """
        Restaura um registro deletado
        
        Args:
            id: ID do registro
            
        Returns:
            True se restaurado com sucesso
        """
        obj = self.db.query(self.model).filter(
            self.model.__table__.c[f"{self.model.__tablename__}Id"] == id
        ).first()
        
        if not obj or not obj.IsDeleted:
            return False
        
        obj.IsDeleted = False
        obj.DeletedAt = None
        obj.DeletedBy = None
        
        self.db.commit()
        return True
