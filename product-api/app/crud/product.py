from sqlalchemy.orm import Session, joinedload
from sqlalchemy.exc import IntegrityError
from fastapi import HTTPException
from typing import List, Optional
from app.models.product import Product
from app.models.category import Category
from app.schemas.product import ProductCreate, ProductUpdate

class ProductCRUD:
    def get(self, db: Session, id: int) -> Optional[Product]:
        return db.query(Product).filter(Product.id == id).first()
    
    def get_with_category(self, db: Session, id: int) -> Optional[Product]:
        """Get product with its category"""
        return db.query(Product).options(joinedload(Product.category)).filter(Product.id == id).first()
    
    def get_multi(self, db: Session, skip: int = 0, limit: int = 100) -> List[Product]:
        return db.query(Product).offset(skip).limit(limit).all()
    
    def get_multi_with_category(self, db: Session, skip: int = 0, limit: int = 100) -> List[Product]:
        """Get products with their categories"""
        return db.query(Product).options(joinedload(Product.category)).offset(skip).limit(limit).all()
    
    def get_by_category(self, db: Session, category_id: int, skip: int = 0, limit: int = 100) -> List[Product]:
        """Get products by category"""
        return db.query(Product).filter(Product.category_id == category_id).offset(skip).limit(limit).all()
    
    def create(self, db: Session, obj_in: ProductCreate) -> Product:
        try:
            # Verify category exists
            category = db.query(Category).filter(Category.id == obj_in.category_id).first()
            if not category:
                raise HTTPException(status_code=404, detail="Category not found")
                
            db_obj = Product(**obj_in.dict())
            db.add(db_obj)
            db.commit()
            db.refresh(db_obj)
            return db_obj
        except IntegrityError:
            db.rollback()
            raise HTTPException(status_code=400, detail="Product name already exists")
    
    def update(self, db: Session, db_obj: Product, obj_in: ProductUpdate) -> Product:
        try:
            update_data = obj_in.dict(exclude_unset=True)
            
            # Verify category exists if category_id is being updated
            if 'category_id' in update_data:
                category = db.query(Category).filter(Category.id == update_data['category_id']).first()
                if not category:
                    raise HTTPException(status_code=404, detail="Category not found")
            
            for field, value in update_data.items():
                setattr(db_obj, field, value)
            db.commit()
            db.refresh(db_obj)
            return db_obj
        except IntegrityError:
            db.rollback()
            raise HTTPException(status_code=400, detail="Product name already exists")
    
    def remove(self, db: Session, id: int) -> Product:
        obj = db.query(Product).get(id)
        if obj:
            db.delete(obj)
            db.commit()
        return obj

product = ProductCRUD()
