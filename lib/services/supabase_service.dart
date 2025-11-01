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

  /// Lấy tất cả products của user hiện tại
  Future<List<Product>> getProducts() async {
    final response = await client
        .from('products')
        .select()
        .order('created_at', ascending: false);

    return (response as List)
        .map((json) => Product.fromJson({
              'id': json['id'],
              'name': json['name'],
              'code': json['code'],
              'category': json['category'],
              'quantity': json['quantity'],
              'price': json['price'],
              'description': json['description'] ?? '',
              'imageUrl': json['image_url'],
              'supplier': json['supplier'] ?? '',
              'minimumQuantity': json['minimum_quantity'] ?? 5,
              'dateAdded': json['created_at'],
              'lastUpdated': json['updated_at'],
            }))
        .toList();
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

    final response = await client
        .from('products')
        .insert({
          'user_id': userId,
          'name': product.name,
          'code': product.code,
          'category': product.category,
          'quantity': product.quantity,
          'price': product.price,
          'description': product.description,
          'image_url': product.imageUrl,
          'supplier': product.supplier,
          'minimum_quantity': product.minimumQuantity,
        })
        .select()
        .single();

    // Log activity
    await _logActivity(
      userId: userId,
      productId: response['id'],
      actionType: 'add',
      title: 'Product Added',
      subtitle: '${product.name} - ${product.quantity} units',
    );

    return response['id'];
  }

  /// Cập nhật product
  Future<void> updateProduct(Product product) async {
    final userId = client.auth.currentUser?.id;
    if (userId == null) throw Exception('User not authenticated');

    await client.from('products').update({
      'name': product.name,
      'code': product.code,
      'category': product.category,
      'quantity': product.quantity,
      'price': product.price,
      'description': product.description,
      'image_url': product.imageUrl,
      'supplier': product.supplier,
      'minimum_quantity': product.minimumQuantity,
    }).eq('id', product.id);

    // Log activity
    await _logActivity(
      userId: userId,
      productId: product.id,
      actionType: 'update',
      title: 'Product Updated',
      subtitle: product.name,
    );
  }

  /// Xóa product
  Future<void> deleteProduct(String productId) async {
    final userId = client.auth.currentUser?.id;
    if (userId == null) throw Exception('User not authenticated');

    await client.from('products').delete().eq('id', productId);

    // Log activity
    await _logActivity(
      userId: userId,
      productId: productId,
      actionType: 'delete',
      title: 'Product Deleted',
      subtitle: 'Product removed from inventory',
    );
  }

  // ==================== ACTIVITY METHODS ====================

  /// Lấy các hoạt động gần đây
  Future<List<Map<String, dynamic>>> getRecentActivities(
      {int limit = 10}) async {
    final response = await client
        .from('activities')
        .select()
        .order('created_at', ascending: false)
        .limit(limit);

    return List<Map<String, dynamic>>.from(response);
  }

  /// Log một activity mới
  Future<void> _logActivity({
    required String userId,
    String? productId,
    required String actionType,
    required String title,
    String? subtitle,
  }) async {
    await client.from('activities').insert({
      'user_id': userId,
      'product_id': productId,
      'action_type': actionType,
      'title': title,
      'subtitle': subtitle,
    });
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
