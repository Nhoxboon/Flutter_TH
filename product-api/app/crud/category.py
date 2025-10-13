from sqlalchemy.orm import Session, joinedload
from sqlalchemy.exc import IntegrityError
from fastapi import HTTPException
from typing import List, Optional
from app.models.category import Category
from app.schemas.category import CategoryCreate, CategoryUpdate

class CategoryCRUD:
    def get(self, db: Session, id: int) -> Optional[Category]:
        return db.query(Category).filter(Category.id == id).first()
    
    def get_with_products(self, db: Session, id: int) -> Optional[Category]:
        """Get category with its products"""
        return db.query(Category).options(joinedload(Category.products)).filter(Category.id == id).first()
    
    def get_multi(self, db: Session, skip: int = 0, limit: int = 100) -> List[Category]:
        return db.query(Category).offset(skip).limit(limit).all()
    
    def get_multi_with_products(self, db: Session, skip: int = 0, limit: int = 100) -> List[Category]:
        """Get categories with their products"""
        return db.query(Category).options(joinedload(Category.products)).offset(skip).limit(limit).all()
    
    def create(self, db: Session, obj_in: CategoryCreate) -> Category:
        try:
            db_obj = Category(**obj_in.dict())
            db.add(db_obj)
            db.commit()
            db.refresh(db_obj)
            return db_obj
        except IntegrityError:
            db.rollback()
            raise HTTPException(status_code=400, detail="Category name already exists")
    
    def update(self, db: Session, db_obj: Category, obj_in: CategoryUpdate) -> Category:
        try:
            update_data = obj_in.dict(exclude_unset=True)
            for field, value in update_data.items():
                setattr(db_obj, field, value)
            db.commit()
            db.refresh(db_obj)
            return db_obj
        except IntegrityError:
            db.rollback()
            raise HTTPException(status_code=400, detail="Category name already exists")
    
    def remove(self, db: Session, id: int) -> Category:
        obj = db.query(Category).get(id)
        if obj:
            if obj.products:
                raise HTTPException(
                    status_code=400, 
                    detail="Cannot delete category with existing products. Please move or delete products first."
                )
            db.delete(obj)
            db.commit()
        return obj
    
    def get_by_name(self, db: Session, name: str) -> Optional[Category]:
        return db.query(Category).filter(Category.name == name).first()

category = CategoryCRUD()