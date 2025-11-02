import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/product.dart';

class SupabaseService {
  static final SupabaseService _instance = SupabaseService._internal();
  factory SupabaseService() => _instance;
  SupabaseService._internal();

  static SupabaseClient get client => Supabase.instance.client;

  // ==================== AUTH METHODS ====================

  /// Đăng nhập với email và password
  Future<AuthResponse> signInWithEmail(String email, String password) async {
    return await client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  /// Đăng ký tài khoản mới
  Future<AuthResponse> signUpWithEmail(
    String email,
    String password,
    String fullName,
  ) async {
    return await client.auth.signUp(
      email: email,
      password: password,
      data: {'full_name': fullName},
      emailRedirectTo: null, // Không cần redirect
    );
  }

  /// Đăng xuất
  Future<void> signOut() async {
    await client.auth.signOut();
  }

  /// Lấy thông tin user hiện tại
  User? getCurrentUser() {
    return client.auth.currentUser;
  }

  /// Stream để lắng nghe thay đổi trạng thái auth
  Stream<AuthState> get authStateChanges => client.auth.onAuthStateChange;

  // ==================== PRODUCT METHODS ====================

  /// Lấy tất cả products
  Future<List<Product>> getProducts() async {
    try {
      final response = await client
          .from('products')
          .select()
          .order('created_at', ascending: false);

      return (response as List)
          .map((json) => Product.fromJson({
                'id': json['id'].toString(),
                'name': json['name'] ?? 'Unknown Product',
                'code': json['sku'] ?? json['code'] ?? 'N/A',
                'category': _getCategoryName(json['category_id']),
                'quantity': json['quantity'] ?? 0,
                'price': (json['price'] is int) 
                    ? (json['price'] as int).toDouble()
                    : (json['price'] ?? 0.0),
                'description': json['description'] ?? '',
                'imageUrl': json['image_url'],
                'supplier': _getBrandName(json['brand_id']),
                'minimumQuantity': json['minimum_quantity'] ?? 5,
                'dateAdded': json['created_at'] != null 
                    ? DateTime.parse(json['created_at'])
                    : DateTime.now(),
                'lastUpdated': json['updated_at'] != null
                    ? DateTime.parse(json['updated_at'])
                    : DateTime.now(),
              }))
          .toList();
    } catch (e) {
      debugPrint('❌ Error loading products from Supabase: $e');
      rethrow;
    }
  }

  /// Helper: Get category name từ ID
  String _getCategoryName(int? categoryId) {
    switch (categoryId) {
      case 1: return 'Electronics';
      case 2: return 'Laptop';
      case 3: return 'Tablet';
      case 4: return 'Accessories';
      case 5: return 'Watch';
      default: return 'Other';
    }
  }

  /// Helper: Get brand name từ ID
  String _getBrandName(int? brandId) {
    switch (brandId) {
      case 1: return 'Apple Inc.';
      case 2: return 'Samsung Electronics';
      case 3: return 'Xiaomi';
      case 4: return 'OPPO';
      case 5: return 'Vivo';
      case 6: return 'Nike Inc.';
      case 7: return 'Adidas AG';
      case 8: return 'Publisher';
      default: return 'Unknown';
    }
  }

  /// Lấy một product theo ID
  Future<Product> getProduct(String id) async {
    final response =
        await client.from('products').select().eq('id', id).single();

    return Product.fromJson({
      'id': response['id'],
      'name': response['name'],
      'code': response['code'],
      'category': response['category'],
      'quantity': response['quantity'],
      'price': response['price'],
      'description': response['description'] ?? '',
      'imageUrl': response['image_url'],
      'supplier': response['supplier'] ?? '',
      'minimumQuantity': response['minimum_quantity'] ?? 5,
      'dateAdded': response['created_at'],
      'lastUpdated': response['updated_at'],
    });
  }

  /// Thêm product mới
  Future<String> addProduct(Product product) async {
    final userId = client.auth.currentUser?.id;
    if (userId == null) throw Exception('User not authenticated');

    // Map category name → category_id
    final categoryId = _getCategoryId(product.category);
    
    final response = await client
        .from('products')
        .insert({
          'name': product.name,
          'sku': product.code,
          'category_id': categoryId,
          'brand_id': 1, // Default: Apple
          'quantity': product.quantity,
          'price': product.price,
          'description': product.description,
          'image_url': product.imageUrl,
          'minimum_quantity': product.minimumQuantity,
          'rating': 0.0,
          'reviews': 0,
          'discount': 0,
        })
        .select()
        .single();

    return response['id'].toString();
  }

  /// Helper: Get category ID từ name
  int _getCategoryId(String category) {
    switch (category.toLowerCase()) {
      case 'electronics': return 1;
      case 'laptop': return 2;
      case 'tablet': return 3;
      case 'accessories': return 4;
      case 'clothing': return 4; // Map Clothing → Accessories
      case 'books': return 4; // Map Books → Accessories
      case 'food': return 4; // Map Food → Accessories
      case 'watch': return 5;
      default: return 4;
    }
  }

  /// Cập nhật product
  Future<void> updateProduct(Product product) async {
    final userId = client.auth.currentUser?.id;
    if (userId == null) throw Exception('User not authenticated');

    // Map category name → category_id
    final categoryId = _getCategoryId(product.category);

    await client.from('products').update({
      'name': product.name,
      'sku': product.code,
      'category_id': categoryId,
      'quantity': product.quantity,
      'price': product.price,
      'description': product.description,
      'image_url': product.imageUrl,
      'minimum_quantity': product.minimumQuantity,
    }).eq('id', int.parse(product.id));
  }

  /// Xóa product
  Future<void> deleteProduct(String productId) async {
    final userId = client.auth.currentUser?.id;
    if (userId == null) throw Exception('User not authenticated');

    await client.from('products').delete().eq('id', int.parse(productId));
  }

  // ==================== ACTIVITY METHODS ====================

  /// Lấy các hoạt động gần đây
  Future<List<Map<String, dynamic>>> getRecentActivities(
      {int limit = 10}) async {
    try {
      final response = await client
          .from('activities')
          .select()
          .order('created_at', ascending: false)
          .limit(limit);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      debugPrint('⚠️ Activities table không tồn tại hoặc lỗi: $e');
      // Return empty nếu bảng không tồn tại
      return [];
    }
  }

  // ==================== STATISTICS METHODS ====================

  /// Lấy thống kê tổng quan
  Future<Map<String, dynamic>> getStatistics() async {
    final products = await getProducts();

    final totalProducts = products.length;
    final lowStockCount =
        products.where((p) => p.quantity <= p.minimumQuantity).length;
    final outOfStockCount = products.where((p) => p.quantity == 0).length;
    final totalValue = products.fold<double>(
      0.0,
      (sum, p) => sum + (p.quantity * p.price),
    );

    return {
      'totalProducts': totalProducts,
      'lowStockCount': lowStockCount,
      'outOfStockCount': outOfStockCount,
      'totalValue': totalValue,
    };
  }

  // ==================== UPLOAD IMAGE ====================

  /// Upload ảnh sản phẩm lên Supabase Storage (Optional)
  /// Note: This function is not yet implemented
  // Future<String?> uploadProductImage(String filePath, String fileName) async {
  //   try {
  //     final bytes = await _getBytesFromFile(filePath);
  //     await client.storage.from('products').uploadBinary(
  //       fileName,
  //       bytes,
  //     );
  //
  //     final url = client.storage.from('products').getPublicUrl(fileName);
  //     return url;
  //   } catch (e) {
  //     debugPrint('Error uploading image: $e');
  //     return null;
  //   }
  // }

  // Future<Uint8List> _getBytesFromFile(String filePath) async {
  //   // TODO: Implement file reading based on platform
  //   throw UnimplementedError('File reading not implemented');
  // }
}
