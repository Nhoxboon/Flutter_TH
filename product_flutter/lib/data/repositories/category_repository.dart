import '../models/category_model.dart';
import '../services/api_service.dart';
import '../../core/errors/exceptions.dart';

abstract class CategoryRepository {
  Future<List<Category>> getCategories({
    int skip = 0,
    int limit = 100,
    bool includeProducts = false,
  });
  Future<Category> getCategoryById(int id, {bool includeProducts = true});
  Future<Category> createCategory(CreateCategoryRequest request);
  Future<Category> updateCategory(int id, UpdateCategoryRequest request);
  Future<void> deleteCategory(int id);
}

class CategoryRepositoryImpl implements CategoryRepository {
  final ApiService _apiService;

  CategoryRepositoryImpl({required ApiService apiService})
      : _apiService = apiService;

  @override
  Future<List<Category>> getCategories({
    int skip = 0,
    int limit = 100,
    bool includeProducts = false,
  }) async {
    try {
      return await _apiService.getCategories(
        skip: skip,
        limit: limit,
        includeProducts: includeProducts,
      );
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<Category> getCategoryById(int id,
      {bool includeProducts = true}) async {
    try {
      return await _apiService.getCategoryById(id,
          includeProducts: includeProducts);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<Category> createCategory(CreateCategoryRequest request) async {
    try {
      return await _apiService.createCategory(request);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<Category> updateCategory(int id, UpdateCategoryRequest request) async {
    try {
      return await _apiService.updateCategory(id, request);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> deleteCategory(int id) async {
    try {
      await _apiService.deleteCategory(id);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
