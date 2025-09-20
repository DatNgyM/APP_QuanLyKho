import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/product.dart';
import '../models/activity.dart';

/// Temporary storage service using SharedPreferences
/// This is designed for easy migration to PostgreSQL later
class TempStorageService {
  static const String _productsKey = 'products';
  static const String _activitiesKey = 'activities';
  static const String _categoriesKey = 'categories';

  static TempStorageService? _instance;
  static TempStorageService get instance =>
      _instance ??= TempStorageService._();
  TempStorageService._();

  // Products CRUD
  Future<List<Product>> getAllProducts() async {
    final prefs = await SharedPreferences.getInstance();
    final productsJson = prefs.getStringList(_productsKey) ?? [];
    return productsJson
        .map((json) => Product.fromJson(jsonDecode(json)))
        .toList();
  }

  Future<String> saveProduct(Product product) async {
    final prefs = await SharedPreferences.getInstance();
    final products = await getAllProducts();

    // Update existing or add new
    final existingIndex = products.indexWhere((p) => p.id == product.id);
    if (existingIndex >= 0) {
      products[existingIndex] = product;
    } else {
      products.add(product);
    }

    // Save back to storage
    final productsJson = products.map((p) => jsonEncode(p.toJson())).toList();
    await prefs.setStringList(_productsKey, productsJson);

    // Log activity
    await _logActivity(Activity(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: existingIndex >= 0 ? 'product_updated' : 'product_added',
      description:
          '${existingIndex >= 0 ? 'Updated' : 'Added'} product: ${product.name}',
      productId: product.id,
      timestamp: DateTime.now(),
    ));

    return product.id;
  }

  Future<void> deleteProduct(String productId) async {
    final prefs = await SharedPreferences.getInstance();
    final products = await getAllProducts();
    final product = products.firstWhere((p) => p.id == productId);

    products.removeWhere((p) => p.id == productId);

    final productsJson = products.map((p) => jsonEncode(p.toJson())).toList();
    await prefs.setStringList(_productsKey, productsJson);

    // Log activity
    await _logActivity(Activity(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: 'product_deleted',
      description: 'Deleted product: ${product.name}',
      productId: null,
      timestamp: DateTime.now(),
    ));
  }

  Future<List<Product>> searchProducts(String query) async {
    final products = await getAllProducts();
    return products
        .where((product) =>
            product.name.toLowerCase().contains(query.toLowerCase()) ||
            product.code.toLowerCase().contains(query.toLowerCase()) ||
            product.description.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  Future<List<Product>> getProductsByCategory(String category) async {
    final products = await getAllProducts();
    return products.where((product) => product.category == category).toList();
  }

  Future<List<Product>> getLowStockProducts() async {
    final products = await getAllProducts();
    return products
        .where((product) => product.quantity <= product.minimumQuantity)
        .toList();
  }

  // Statistics
  Future<Map<String, dynamic>> getStatistics() async {
    final products = await getAllProducts();

    final totalProducts = products.length;
    final totalValue = products.fold(
        0.0, (sum, product) => sum + (product.quantity * product.price));
    final lowStockCount =
        products.where((p) => p.quantity <= p.minimumQuantity).length;

    // Calculate revenue for last 30 days (simulated)
    final now = DateTime.now();
    final thirtyDaysAgo = now.subtract(Duration(days: 30));
    final activities = await getRecentActivities();
    final recentActivities =
        activities.where((a) => a.timestamp.isAfter(thirtyDaysAgo)).length;

    return {
      'totalProducts': totalProducts,
      'totalValue': totalValue,
      'lowStockCount': lowStockCount,
      'recentActivities': recentActivities,
    };
  }

  // Revenue data for charts (simulated)
  Future<List<Map<String, dynamic>>> getRevenueData({int days = 30}) async {
    final List<Map<String, dynamic>> revenueData = [];
    final now = DateTime.now();

    for (int i = days - 1; i >= 0; i--) {
      final date = now.subtract(Duration(days: i));
      // Simulate revenue data (in real app, this would come from sales records)
      final revenue = (1000 + (i * 50) + (date.day * 10)).toDouble();

      revenueData.add({
        'date': date,
        'revenue': revenue,
        'day': date.day,
        'month': date.month,
      });
    }

    return revenueData;
  }

  // Activities
  Future<void> _logActivity(Activity activity) async {
    final prefs = await SharedPreferences.getInstance();
    final activities = await getRecentActivities();
    activities.insert(0, activity); // Add to beginning

    // Keep only last 100 activities
    if (activities.length > 100) {
      activities.removeRange(100, activities.length);
    }

    final activitiesJson =
        activities.map((a) => jsonEncode(a.toJson())).toList();
    await prefs.setStringList(_activitiesKey, activitiesJson);
  }

  Future<List<Activity>> getRecentActivities({int limit = 10}) async {
    final prefs = await SharedPreferences.getInstance();
    final activitiesJson = prefs.getStringList(_activitiesKey) ?? [];
    final activities = activitiesJson
        .map((json) => Activity.fromJson(jsonDecode(json)))
        .toList();

    return activities.take(limit).toList();
  }

  // Categories
  Future<List<String>> getCategories() async {
    final prefs = await SharedPreferences.getInstance();
    final categoriesJson = prefs.getStringList(_categoriesKey);

    if (categoriesJson == null || categoriesJson.isEmpty) {
      // Initialize with default categories
      final defaultCategories = [
        'Electronics',
        'Clothing',
        'Books',
        'Food',
        'Other'
      ];
      await prefs.setStringList(_categoriesKey, defaultCategories);
      return defaultCategories;
    }

    return categoriesJson;
  }

  Future<void> addCategory(String category) async {
    final prefs = await SharedPreferences.getInstance();
    final categories = await getCategories();

    if (!categories.contains(category)) {
      categories.add(category);
      await prefs.setStringList(_categoriesKey, categories);
    }
  }

  // Export data
  Future<Map<String, dynamic>> exportData() async {
    final products = await getAllProducts();
    final activities = await getRecentActivities(limit: 100);
    final statistics = await getStatistics();
    final revenueData = await getRevenueData();

    return {
      'products': products.map((p) => p.toJson()).toList(),
      'activities': activities.map((a) => a.toJson()).toList(),
      'statistics': statistics,
      'revenueData': revenueData,
      'exportDate': DateTime.now().toIso8601String(),
    };
  }

  // Clear all data (for testing)
  Future<void> clearAllData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_productsKey);
    await prefs.remove(_activitiesKey);
    await prefs.remove(_categoriesKey);
  }
}

