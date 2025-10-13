from typing import List
from fastapi import APIRouter, Depends, HTTPException, Query
from sqlalchemy.orm import Session
from app.core.database import get_db
from app.crud.category import category
from app.schemas.category import Category, CategoryCreate, CategoryUpdate, CategoryWithProducts
from app.utils.cache import cache

router = APIRouter()

@router.get("/", response_model=List[Category])
def read_categories(
    skip: int = Query(0, ge=0),
    limit: int = Query(100, ge=1, le=1000),
    include_products: bool = Query(False, description="Include products in each category"),
    db: Session = Depends(get_db)
):
    """
    Retrieve categories with optional products inclusion
    """
    # Try to get from cache first
    cache_key = f"categories:{skip}:{limit}:{include_products}"
    cached_categories = cache.get(cache_key)
    
    if cached_categories:
        return cached_categories
    
    # If not in cache, get from database
    if include_products:
        categories = category.get_multi_with_products(db, skip=skip, limit=limit)
        # Convert to CategoryWithProducts schema
        categories_dict = [CategoryWithProducts.from_orm(c).dict() for c in categories]
    else:
        categories = category.get_multi(db, skip=skip, limit=limit)
        # Convert to Category schema
        categories_dict = [Category.from_orm(c).dict() for c in categories]
    
    cache.set(cache_key, categories_dict)
    return categories

@router.post("/", response_model=Category, status_code=201)
def create_category(
    category_in: CategoryCreate,
    db: Session = Depends(get_db)
):
    """
    Create new category
    """
    # Check if category name already exists
    existing_category = category.get_by_name(db, name=category_in.name)
    if existing_category:
        raise HTTPException(status_code=400, detail="Category name already exists")
    
    created_category = category.create(db=db, obj_in=category_in)
    
    # Clear categories cache
    cache.clear_pattern("categories:*")
    
    return created_category

@router.get("/{category_id}", response_model=CategoryWithProducts)
def read_category(
    category_id: int,
    include_products: bool = Query(True, description="Include products in the category"),
    db: Session = Depends(get_db)
):
    """
    Get category by ID with optional products
    """
    # Try cache first
    cache_key = f"category:{category_id}:{include_products}"
    cached_category = cache.get(cache_key)
    
    if cached_category:
        return cached_category
    
    if include_products:
        db_category = category.get_with_products(db, id=category_id)
    else:
        db_category = category.get(db, id=category_id)
        
    if db_category is None:
        raise HTTPException(status_code=404, detail="Category not found")
    
    # Cache the category
    if include_products:
        category_dict = CategoryWithProducts.from_orm(db_category).dict()
    else:
        category_dict = Category.from_orm(db_category).dict()
    cache.set(cache_key, category_dict)
    
    return db_category

@router.put("/{category_id}", response_model=Category)
def update_category(
    category_id: int,
    category_in: CategoryUpdate,
    db: Session = Depends(get_db)
):
    """
    Update category
    """
    db_category = category.get(db, id=category_id)
    if db_category is None:
        raise HTTPException(status_code=404, detail="Category not found")
    
    # Check if new name already exists (if name is being updated)
    if category_in.name and category_in.name != db_category.name:
        existing_category = category.get_by_name(db, name=category_in.name)
        if existing_category:
            raise HTTPException(status_code=400, detail="Category name already exists")
    
    updated_category = category.update(db=db, db_obj=db_category, obj_in=category_in)
    
    # Clear cache
    cache.delete(f"category:{category_id}:True")
    cache.delete(f"category:{category_id}:False")
    cache.clear_pattern("categories:*")
    
    return updated_category

@router.delete("/{category_id}", status_code=204)
def delete_category(
    category_id: int,
    db: Session = Depends(get_db)
):
    """
    Delete category (only if no products are associated)
    """
    db_category = category.get(db, id=category_id)
    if db_category is None:
        raise HTTPException(status_code=404, detail="Category not found")
    
    category.remove(db=db, id=category_id)
    
    # Clear cache
    cache.delete(f"category:{category_id}:True")
    cache.delete(f"category:{category_id}:False")
    cache.clear_pattern("categories:*")
    
    return None

@router.get("/{category_id}/products")
def read_category_products(
    category_id: int,
    skip: int = Query(0, ge=0),
    limit: int = Query(100, ge=1, le=1000),
    db: Session = Depends(get_db)
):
    """
    Get all products in a specific category
    """
    # Verify category exists
    db_category = category.get(db, id=category_id)
    if db_category is None:
        raise HTTPException(status_code=404, detail="Category not found")
    
    from app.crud.product import product
    products = product.get_by_category(db, category_id=category_id, skip=skip, limit=limit)
    
    return products