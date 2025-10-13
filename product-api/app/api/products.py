from typing import List
from fastapi import APIRouter, Depends, HTTPException, Query
from sqlalchemy.orm import Session
from app.core.database import get_db
from app.crud.product import product
from app.schemas.product import Product, ProductCreate, ProductUpdate, ProductWithCategory
from app.utils.cache import cache

router = APIRouter()

@router.get("/", response_model=List[ProductWithCategory])
def read_products(
    skip: int = Query(0, ge=0),
    limit: int = Query(100, ge=1, le=1000),
    category_id: int = Query(None, description="Filter by category ID"),
    include_category: bool = Query(True, description="Include category information"),
    db: Session = Depends(get_db)
):
    """
    Retrieve products with optional category filtering and category information
    """
    # Try to get from cache first
    cache_key = f"products:{skip}:{limit}:{category_id}:{include_category}"
    cached_products = cache.get(cache_key)
    
    if cached_products:
        return cached_products
    
    # If not in cache, get from database
    if category_id:
        products = product.get_by_category(db, category_id=category_id, skip=skip, limit=limit)
    elif include_category:
        products = product.get_multi_with_category(db, skip=skip, limit=limit)
    else:
        products = product.get_multi(db, skip=skip, limit=limit)
    
    # Convert to dict for caching
    if include_category and not category_id:
        products_dict = [ProductWithCategory.from_orm(p).dict() for p in products]
    else:
        # Load category information for products if needed
        if category_id or include_category:
            products_dict = []
            for p in products:
                if not hasattr(p, 'category') or p.category is None:
                    # Load category if not already loaded
                    p = product.get_with_category(db, p.id)
                products_dict.append(ProductWithCategory.from_orm(p).dict())
        else:
            products_dict = [Product.from_orm(p).dict() for p in products]
    
    cache.set(cache_key, products_dict)
    
    return products

@router.post("/", response_model=Product, status_code=201)
def create_product(
    product_in: ProductCreate,
    db: Session = Depends(get_db)
):
    created_product = product.create(db=db, obj_in=product_in)
    # Clear products cache
    cache.clear_pattern("products:*")
    return created_product

@router.get("/{product_id}", response_model=ProductWithCategory)
def read_product(
    product_id: int,
    include_category: bool = Query(True, description="Include category information"),
    db: Session = Depends(get_db)
):
    """
    Get product by ID with optional category information
    """
    # Try cache first
    cache_key = f"product:{product_id}:{include_category}"
    cached_product = cache.get(cache_key)
    
    if cached_product:
        return cached_product
    
    if include_category:
        db_product = product.get_with_category(db, id=product_id)
    else:
        db_product = product.get(db, id=product_id)
        
    if db_product is None:
        raise HTTPException(status_code=404, detail="Product not found")
    
    # Cache the product
    if include_category:
        product_dict = ProductWithCategory.from_orm(db_product).dict()
    else:
        product_dict = Product.from_orm(db_product).dict()
    cache.set(cache_key, product_dict)
    
    return db_product

@router.put("/{product_id}", response_model=ProductWithCategory)
def update_product(
    product_id: int,
    product_in: ProductUpdate,
    db: Session = Depends(get_db)
):
    """
    Update product
    """
    db_product = product.get(db, id=product_id)
    if db_product is None:
        raise HTTPException(status_code=404, detail="Product not found")
    
    updated_product = product.update(db=db, db_obj=db_product, obj_in=product_in)
    
    updated_product_with_category = product.get_with_category(db, id=product_id)
    
    cache.delete(f"product:{product_id}:True")
    cache.delete(f"product:{product_id}:False")
    cache.clear_pattern("products:*")
    
    return updated_product_with_category

@router.delete("/{product_id}", status_code=204)
def delete_product(
    product_id: int,
    db: Session = Depends(get_db)
):
    db_product = product.get(db, id=product_id)
    if db_product is None:
        raise HTTPException(status_code=404, detail="Product not found")
    
    product.remove(db=db, id=product_id)
    
    # Clear cache
    cache.delete(f"product:{product_id}:True")
    cache.delete(f"product:{product_id}:False")
    cache.clear_pattern("products:*")
    
    return None
