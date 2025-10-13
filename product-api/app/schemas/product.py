from pydantic import BaseModel, Field, validator
from typing import Optional
from datetime import datetime
from decimal import Decimal

class ProductBase(BaseModel):
    name: str = Field(..., min_length=1, max_length=255)
    description: Optional[str] = Field(None, max_length=500)
    price: Decimal = Field(..., gt=0, decimal_places=2)
    category_id: int = Field(..., gt=0)

class ProductCreate(ProductBase):
    @validator('name')
    def name_must_not_be_empty(cls, v):
        if not v.strip():
            raise ValueError('Name cannot be empty')
        return v.strip()

class ProductUpdate(BaseModel):
    name: Optional[str] = Field(None, min_length=1, max_length=255)
    description: Optional[str] = Field(None, max_length=500)
    price: Optional[Decimal] = Field(None, gt=0, decimal_places=2)
    category_id: Optional[int] = Field(None, gt=0)

class ProductInDBBase(ProductBase):
    id: int
    created_at: datetime
    updated_at: Optional[datetime]
    
    class Config:
        from_attributes = True

# Schema đơn giản cho Category khi hiển thị trong Product
class CategoryInProduct(BaseModel):
    id: int
    name: str
    
    class Config:
        from_attributes = True

class Product(ProductInDBBase):
    pass

# Schema cho Product kèm theo thông tin category
class ProductWithCategory(ProductInDBBase):
    category: CategoryInProduct

class ProductInDB(ProductInDBBase):
    pass
