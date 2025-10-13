import 'package:flutter/foundation.dart' hide Category;
import '../../data/models/category_model.dart';
import '../../data/repositories/category_repository.dart';
import '../../core/errors/exceptions.dart';

class CategoryProvider extends ChangeNotifier {
  final CategoryRepository _repository;

  CategoryProvider({required CategoryRepository repository})
      : _repository = repository;

  // State
  List<Category> _categories = [];
  bool _isLoading = false;
  String? _errorMessage;
  bool _hasMore = true;
  int _currentPage = 0;
  static const int _pageSize = 20;

  // Getters
  List<Category> get categories => _categories;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get hasMore => _hasMore;
  bool get hasCategories => _categories.isNotEmpty;

  // Load categories
  Future<void> loadCategories({bool refresh = false}) async {
    if (_isLoading) return;
    if (!refresh && !_hasMore) return;

    _setLoading(true);
    _clearError();

    try {
      if (refresh) {
        _currentPage = 0;
        _hasMore = true;
      }

      final newCategories = await _repository.getCategories(
        skip: _currentPage * _pageSize,
        limit: _pageSize,
        includeProducts: false,
      );

      if (refresh) {
        _categories = newCategories;
      } else {
        _categories.addAll(newCategories);
      }

      _hasMore = newCategories.length == _pageSize;
      _currentPage++;
    } catch (e) {
      _setError(_getErrorMessage(e));
    } finally {
      _setLoading(false);
    }
  }

  // Get category by ID
  Future<Category?> getCategoryById(int id) async {
    try {
      return await _repository.getCategoryById(id);
    } catch (e) {
      _setError(_getErrorMessage(e));
      return null;
    }
  }

  // Create category
  Future<bool> createCategory(CreateCategoryRequest request) async {
    _setLoading(true);
    _clearError();

    try {
      final category = await _repository.createCategory(request);
      _categories.insert(0, category);
      notifyListeners();
      return true;
    } catch (e) {
      _setError(_getErrorMessage(e));
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Update category
  Future<bool> updateCategory(int id, UpdateCategoryRequest request) async {
    _setLoading(true);
    _clearError();

    try {
      final updatedCategory = await _repository.updateCategory(id, request);

      final index = _categories.indexWhere((c) => c.id == id);
      if (index != -1) {
        _categories[index] = updatedCategory;
        notifyListeners();
      }

      return true;
    } catch (e) {
      _setError(_getErrorMessage(e));
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Delete category
  Future<bool> deleteCategory(int id) async {
    _setLoading(true);
    _clearError();

    try {
      await _repository.deleteCategory(id);
      _categories.removeWhere((c) => c.id == id);
      notifyListeners();
      return true;
    } catch (e) {
      _setError(_getErrorMessage(e));
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Refresh categories
  Future<void> refresh() async {
    await loadCategories(refresh: true);
  }

  // Clear error
  void clearError() {
    _clearError();
  }

  // Search categories by name
  List<Category> searchCategories(String query) {
    if (query.isEmpty) return _categories;

    return _categories
        .where((category) =>
            category.name.toLowerCase().contains(query.toLowerCase()) ||
            (category.description
                    ?.toLowerCase()
                    .contains(query.toLowerCase()) ??
                false))
        .toList();
  }

  // Private methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  String _getErrorMessage(dynamic error) {
    if (error is ServerException) {
      return error.message;
    } else if (error is NetworkException) {
      return 'Network error. Please check your connection.';
    } else {
      return 'An unexpected error occurred. Please try again.';
    }
  }
}
