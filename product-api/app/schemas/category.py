from pydantic import BaseModel, Field, validator
from typing import Optional, List
from datetime import datetime

class CategoryBase(BaseModel):
    name: str = Field(..., min_length=1, max_length=255)
    description: Optional[str] = Field(None, max_length=500)

class CategoryCreate(CategoryBase):
    @validator('name')
    def name_must_not_be_empty(cls, v):
        if not v.strip():
            raise ValueError('Name cannot be empty')
        return v.strip()

class CategoryUpdate(BaseModel):
    name: Optional[str] = Field(None, min_length=1, max_length=255)
    description: Optional[str] = Field(None, max_length=500)

class CategoryInDBBase(CategoryBase):
    id: int
    created_at: datetime
    updated_at: Optional[datetime]
    
    class Config:
        from_attributes = True

# Schema chỉ cho Category (không bao gồm products)
class Category(CategoryInDBBase):
    pass

# Schema cho Category kèm theo danh sách products (dùng khi cần hiển thị products của category)
class CategoryWithProducts(CategoryInDBBase):
    products: List['ProductInCategory'] = []

# Schema đơn giản cho Product khi hiển thị trong Category (tránh circular import)
class ProductInCategory(BaseModel):
    id: int
    name: str
    price: float
    
    class Config:
        from_attributes = True

class CategoryInDB(CategoryInDBBase):
    pass