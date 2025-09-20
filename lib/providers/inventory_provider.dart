import 'package:flutter/material.dart';
import '../services/temp_storage_service.dart';
import '../models/product.dart';

class InventoryProvider extends ChangeNotifier {
  final TempStorageService _storage = TempStorageService.instance;
  List<Product> _products = [];
  String _searchQuery = '';
  String _selectedCategory = 'All';
  String _sortBy = 'name';
  bool _sortAscending = true;
  bool _isLoading = false;

  // Getters
  List<Product> get products => _getFilteredProducts();
  List<String> get categories =>
      ['All', 'Electronics', 'Clothing', 'Books', 'Food', 'Other'];
  List<String> get sortOptions =>
      ['name', 'price', 'quantity', 'dateAdded', 'lastUpdated'];
  String get searchQuery => _searchQuery;
  String get selectedCategory => _selectedCategory;
  String get sortBy => _sortBy;
  bool get sortAscending => _sortAscending;
  bool get isLoading => _isLoading;

  // Statistics
  int get totalProducts => _products.length;
  double get totalValue => _products.fold(
      0.0, (sum, product) => sum + (product.quantity * product.price));
  int get lowStockCount =>
      _products.where((p) => p.quantity <= p.minimumQuantity).length;
  int get outOfStockCount => _products.where((p) => p.quantity == 0).length;

  InventoryProvider() {
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    _isLoading = true;
    notifyListeners();

    try {
      _products = await _storage.getAllProducts();
    } catch (e) {
      debugPrint('Error loading products: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  List<Product> _getFilteredProducts() {
    List<Product> filtered = List.from(_products);

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      filtered = filtered
          .where((product) =>
              product.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              product.code.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              product.description
                  .toLowerCase()
                  .contains(_searchQuery.toLowerCase()))
          .toList();
    }

    // Apply category filter
    if (_selectedCategory != 'All') {
      filtered = filtered
          .where((product) => product.category == _selectedCategory)
          .toList();
    }

    // Apply sorting
    filtered.sort((a, b) {
      int comparison = 0;
      switch (_sortBy) {
        case 'name':
          comparison = a.name.compareTo(b.name);
          break;
        case 'price':
          comparison = a.price.compareTo(b.price);
          break;
        case 'quantity':
          comparison = a.quantity.compareTo(b.quantity);
          break;
        case 'dateAdded':
          comparison = a.dateAdded.compareTo(b.dateAdded);
          break;
        case 'lastUpdated':
          comparison = a.lastUpdated.compareTo(b.lastUpdated);
          break;
      }
      return _sortAscending ? comparison : -comparison;
    });

    return filtered;
  }

  // Search and filter methods
  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setSelectedCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void setSortBy(String sortBy) {
    _sortBy = sortBy;
    notifyListeners();
  }

  void setSortAscending(bool ascending) {
    _sortAscending = ascending;
    notifyListeners();
  }

  // Product CRUD operations
  Future<String> addProduct(Product product) async {
    try {
      final id = await _storage.saveProduct(product);
      await _loadProducts();
      return id;
    } catch (e) {
      debugPrint('Error adding product: $e');
      rethrow;
    }
  }

  Future<void> updateProduct(Product product) async {
    try {
      await _storage.saveProduct(product);
      await _loadProducts();
    } catch (e) {
      debugPrint('Error updating product: $e');
      rethrow;
    }
  }

  Future<void> deleteProduct(String productId) async {
    try {
      await _storage.deleteProduct(productId);
      await _loadProducts();
    } catch (e) {
      debugPrint('Error deleting product: $e');
      rethrow;
    }
  }

  // Statistics methods
  Future<Map<String, dynamic>> getStatistics() async {
    return await _storage.getStatistics();
  }

  Future<List<Map<String, dynamic>>> getRevenueData({int days = 30}) async {
    return await _storage.getRevenueData(days: days);
  }

  // Export data
  Future<Map<String, dynamic>> exportData() async {
    return await _storage.exportData();
  }

  // Refresh data
  Future<void> refresh() async {
    await _loadProducts();
  }
}
