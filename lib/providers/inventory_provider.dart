import 'package:flutter/material.dart';

class Product {
  final String id;
  final String name;
  final String code;
  final String category;
  final int quantity;
  final double price;
  final String description;
  final String? imageUrl;
  final String supplier;
  final int minimumQuantity;
  final DateTime dateAdded;
  final DateTime lastUpdated;

  Product({
    required this.id,
    required this.name,
    required this.code,
    required this.category,
    required this.quantity,
    required this.price,
    required this.description,
    this.imageUrl,
    required this.supplier,
    required this.minimumQuantity,
    required this.dateAdded,
    required this.lastUpdated,
  });

  Product copyWith({
    String? id,
    String? name,
    String? code,
    String? category,
    int? quantity,
    double? price,
    String? description,
    String? imageUrl,
    String? supplier,
    int? minimumQuantity,
    DateTime? dateAdded,
    DateTime? lastUpdated,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      code: code ?? this.code,
      category: category ?? this.category,
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      supplier: supplier ?? this.supplier,
      minimumQuantity: minimumQuantity ?? this.minimumQuantity,
      dateAdded: dateAdded ?? this.dateAdded,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'code': code,
      'category': category,
      'quantity': quantity,
      'price': price,
      'description': description,
      'imageUrl': imageUrl,
      'supplier': supplier,
      'minimumQuantity': minimumQuantity,
      'dateAdded': dateAdded.toIso8601String(),
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      code: json['code'],
      category: json['category'],
      quantity: json['quantity'],
      price: json['price'].toDouble(),
      description: json['description'],
      imageUrl: json['imageUrl'],
      supplier: json['supplier'],
      minimumQuantity: json['minimumQuantity'],
      dateAdded: DateTime.parse(json['dateAdded']),
      lastUpdated: DateTime.parse(json['lastUpdated']),
    );
  }
}

class InventoryProvider extends ChangeNotifier {
  final List<Product> _products = [
    Product(
      id: '1',
      name: 'Nike Air Max 270',
      code: 'NAM270-001',
      category: 'Clothing',
      quantity: 45,
      price: 150.00,
      description: 'Comfortable running shoes',
      supplier: 'Nike Inc.',
      minimumQuantity: 10,
      dateAdded: DateTime.now().subtract(const Duration(days: 30)),
      lastUpdated: DateTime.now().subtract(const Duration(days: 5)),
    ),
    Product(
      id: '2',
      name: 'Samsung Galaxy S24',
      code: 'SGS24-001',
      category: 'Electronics',
      quantity: 18,
      price: 899.99,
      description: 'Premium Android smartphone',
      supplier: 'Samsung Electronics',
      minimumQuantity: 5,
      dateAdded: DateTime.now().subtract(const Duration(days: 15)),
      lastUpdated: DateTime.now().subtract(const Duration(days: 2)),
    ),
    Product(
      id: '3',
      name: 'iPhone 15 Pro',
      code: 'IPH15P-001',
      category: 'Electronics',
      quantity: 25,
      price: 999.99,
      description: 'Latest iPhone with Pro features',
      supplier: 'Apple Inc.',
      minimumQuantity: 5,
      dateAdded: DateTime.now().subtract(const Duration(days: 10)),
      lastUpdated: DateTime.now().subtract(const Duration(days: 1)),
    ),
    Product(
      id: '4',
      name: 'Organic Coffee Beans',
      code: 'OCB-001',
      category: 'Food',
      quantity: 8,
      price: 24.99,
      description: 'Premium organic coffee beans',
      supplier: 'Coffee Co.',
      minimumQuantity: 15,
      dateAdded: DateTime.now().subtract(const Duration(days: 20)),
      lastUpdated: DateTime.now().subtract(const Duration(days: 3)),
    ),
  ];
  String _searchQuery = '';
  String _selectedCategory = 'All';
  String _sortBy = 'name';
  bool _sortAscending = true;

  List<Product> get products => _getFilteredAndSortedProducts();
  String get searchQuery => _searchQuery;
  String get selectedCategory => _selectedCategory;
  String get sortBy => _sortBy;
  bool get sortAscending => _sortAscending;

  List<String> get categories => [
        'All',
        'Electronics',
        'Clothing',
        'Books',
        'Food',
        'Other',
      ];

  List<String> get sortOptions => [
        'name',
        'price',
        'quantity',
        'dateAdded',
        'lastUpdated',
      ];

  InventoryProvider() {
    _loadSampleData();
  }

  void _loadSampleData() {
    final now = DateTime.now();
    _products.addAll([
      Product(
        id: '1',
        name: 'iPhone 15 Pro',
        code: 'IPH15P-001',
        category: 'Electronics',
        quantity: 25,
        price: 999.99,
        description: 'Latest iPhone with advanced features',
        supplier: 'Apple Inc.',
        minimumQuantity: 5,
        dateAdded: now.subtract(const Duration(days: 30)),
        lastUpdated: now.subtract(const Duration(days: 1)),
      ),
      Product(
        id: '2',
        name: 'Samsung Galaxy S24',
        code: 'SGS24-001',
        category: 'Electronics',
        quantity: 18,
        price: 899.99,
        description: 'Premium Android smartphone',
        supplier: 'Samsung Electronics',
        minimumQuantity: 3,
        dateAdded: now.subtract(const Duration(days: 25)),
        lastUpdated: now.subtract(const Duration(days: 2)),
      ),
      Product(
        id: '3',
        name: 'Nike Air Max 270',
        code: 'NAM270-001',
        category: 'Clothing',
        quantity: 45,
        price: 150.00,
        description: 'Comfortable running shoes',
        supplier: 'Nike Inc.',
        minimumQuantity: 10,
        dateAdded: now.subtract(const Duration(days: 20)),
        lastUpdated: now.subtract(const Duration(days: 3)),
      ),
      Product(
        id: '4',
        name: 'The Great Gatsby',
        code: 'TGG-001',
        category: 'Books',
        quantity: 12,
        price: 12.99,
        description: 'Classic American novel',
        supplier: 'Penguin Books',
        minimumQuantity: 5,
        dateAdded: now.subtract(const Duration(days: 15)),
        lastUpdated: now.subtract(const Duration(days: 4)),
      ),
      Product(
        id: '5',
        name: 'Organic Coffee Beans',
        code: 'OCB-001',
        category: 'Food',
        quantity: 8,
        price: 24.99,
        description: 'Premium organic coffee beans',
        supplier: 'Coffee Co.',
        minimumQuantity: 15,
        dateAdded: now.subtract(const Duration(days: 10)),
        lastUpdated: now.subtract(const Duration(days: 5)),
      ),
    ]);
    notifyListeners();
  }

  List<Product> _getFilteredAndSortedProducts() {
    List<Product> filtered = _products.where((product) {
      final matchesSearch =
          product.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              product.code.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              product.description.toLowerCase().contains(
                    _searchQuery.toLowerCase(),
                  );

      final matchesCategory =
          _selectedCategory == 'All' || product.category == _selectedCategory;

      return matchesSearch && matchesCategory;
    }).toList();

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

  void addProduct(Product product) {
    _products.add(product);
    notifyListeners();
  }

  void updateProduct(Product product) {
    final index = _products.indexWhere((p) => p.id == product.id);
    if (index != -1) {
      _products[index] = product;
      notifyListeners();
    }
  }

  void deleteProduct(String productId) {
    _products.removeWhere((product) => product.id == productId);
    notifyListeners();
  }

  Product? getProductById(String id) {
    try {
      return _products.firstWhere((product) => product.id == id);
    } catch (e) {
      return null;
    }
  }

  List<Product> getLowStockProducts() {
    return _products
        .where((product) => product.quantity <= product.minimumQuantity)
        .toList();
  }

  List<Product> getOutOfStockProducts() {
    return _products.where((product) => product.quantity == 0).toList();
  }

  int get totalProducts => _products.length;
  int get lowStockCount => getLowStockProducts().length;
  int get outOfStockCount => getOutOfStockProducts().length;
  double get totalValue {
    return _products.fold(
      0.0,
      (sum, product) => sum + (product.price * product.quantity),
    );
  }
}
