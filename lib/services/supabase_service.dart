import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/product.dart';
import '../models/category.dart';
import '../models/brand.dart';
import '../models/order.dart';
import '../models/order_item.dart';
import '../models/order_status.dart';
import '../models/order_type.dart';

class SupabaseService {
  static final SupabaseService _instance = SupabaseService._internal();
  factory SupabaseService() => _instance;
  SupabaseService._internal();

  static SupabaseClient get client => Supabase.instance.client;

  // ==================== AUTH METHODS ====================

  /// Đăng nhập với email và password
  /// ✅ CHỈ ADMIN (role_id = 1) mới được login App Quản Lý Kho
  Future<Map<String, dynamic>> signInWithEmail(
      String email, String password) async {
    try {
      // Bước 1: Login qua Supabase Auth (auth.users)
      final authResponse = await client.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (authResponse.user == null) {
        throw Exception('❌ Đăng nhập thất bại');
      }

      // Bước 2: Lấy thông tin user từ public.users (đã được trigger đồng bộ)
      final userResponse = await client
          .from('users')
          .select('*, Role(*)')
          .eq('id', authResponse.user!.id)
          .single();

      // Bước 3: CHỈ CHO PHÉP ADMIN (role_id = 1) LOGIN APP
      final roleId = userResponse['role_id'] as int?;
      final roleName = userResponse['Role']?['name'] as String?;

      if (roleId == 1) {
        // ✅ ADMIN → Login được cả App và Web
        debugPrint('✅ Admin "$email" đã đăng nhập App Quản Lý Kho');
        return {
          'user': authResponse.user,
          'profile': userResponse,
          'role_id': roleId,
          'role_name': roleName,
        };
      } else {
        // ❌ Không phải Admin → Từ chối và đăng xuất
        await client.auth.signOut();
        throw Exception(
          '🚫 Chỉ Admin mới có quyền truy cập App Quản Lý Kho.\n\n'
          'Tài khoản: $email\n'
          'Vai trò hiện tại: ${roleName ?? "Unknown"}\n\n'
          'Vui lòng liên hệ quản trị viên để được cấp quyền Admin.',
        );
      }
    } on PostgrestException catch (e) {
      await client.auth.signOut();
      debugPrint('❌ Lỗi database: ${e.message}');
      throw Exception('❌ Lỗi database: ${e.message}');
    } catch (e) {
      debugPrint('❌ Lỗi đăng nhập: $e');
      rethrow;
    }
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

  // ==================== CATEGORY & BRAND METHODS ====================

  /// Lấy tất cả categories
  Future<List<Category>> getCategories() async {
    try {
      final response =
          await client.from('categories').select().order('id', ascending: true);

      return (response as List).map((json) => Category.fromJson(json)).toList();
    } catch (e) {
      debugPrint('❌ Error loading categories: $e');
      return [];
    }
  }

  /// Lấy tất cả brands
  Future<List<Brand>> getBrands() async {
    try {
      final response =
          await client.from('brands').select().order('id', ascending: true);

      return (response as List).map((json) => Brand.fromJson(json)).toList();
    } catch (e) {
      debugPrint('❌ Error loading brands: $e');
      return [];
    }
  }

  // ==================== PRODUCT METHODS ====================

  /// Lấy tất cả products với categories và brands
  Future<List<Product>> getProducts() async {
    try {
      debugPrint('🔄 Fetching products from Supabase...');

      // Fetch categories và brands trước
      final categories = await getCategories();
      final brands = await getBrands();

      debugPrint(
          '📦 Loaded ${categories.length} categories, ${brands.length} brands');

      // Map category_id -> name
      final categoryMap = {for (var c in categories) c.id: c.name};
      // Map brand_id -> name
      final brandMap = {for (var b in brands) b.id: b.name};

      final response = await client
          .from('products')
          .select()
          .order('created_at', ascending: false);

      debugPrint(
          '📱 Loaded ${(response as List).length} products from Supabase');

      return (response as List)
          .map((json) => Product.fromJson({
                'id': json['id'].toString(),
                'name': json['name'] ?? 'Unknown Product',
                'code': json['sku'] ?? json['code'] ?? 'N/A',
                'category_id': json['category_id'],
                'category': categoryMap[json['category_id']] ??
                    _getCategoryName(json['category_id']),
                'brand_id': json['brand_id'],
                'supplier': brandMap[json['brand_id']] ??
                    _getBrandName(json['brand_id']),
                'quantity': json['quantity'] ?? 0,
                'price': json['price'],
                'description': json['description'] ?? '',
                'image_url': json['image_url'],
                'images': json['images'],
                'rating': json['rating'],
                'reviews': json['reviews'],
                'discount': json['discount'],
                'badges': json['badges'],
                'features': json['features'],
                'specifications': json['specifications'],
                'minimum_quantity': json['minimum_quantity'] ?? 5,
                'created_at': json['created_at'],
              }))
          .toList();
    } catch (e) {
      debugPrint('❌ Error loading products from Supabase: $e');
      debugPrint('Stack trace: ${StackTrace.current}');
      rethrow;
    }
  }

  /// Helper: Get category name từ ID
  String _getCategoryName(int? categoryId) {
    switch (categoryId) {
      case 1:
        return 'Electronics';
      case 2:
        return 'Laptop';
      case 3:
        return 'Tablet';
      case 4:
        return 'Accessories';
      case 5:
        return 'Watch';
      default:
        return 'Other';
    }
  }

  /// Helper: Get brand name từ ID
  String _getBrandName(int? brandId) {
    switch (brandId) {
      case 1:
        return 'Apple Inc.';
      case 2:
        return 'Samsung Electronics';
      case 3:
        return 'Xiaomi';
      case 4:
        return 'OPPO';
      case 5:
        return 'Vivo';
      case 6:
        return 'Nike Inc.';
      case 7:
        return 'Adidas AG';
      case 8:
        return 'Publisher';
      default:
        return 'Unknown';
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
    // ✅ Bỏ check authentication vì policies cho phép public access
    // final userId = client.auth.currentUser?.id;
    // if (userId == null) throw Exception('User not authenticated');

    final response = await client
        .from('products')
        .insert({
          'name': product.name,
          'sku': product.code,
          'category_id': product.categoryId ?? 1, // Dùng ID từ product
          'brand_id': product.brandId ?? 1, // Dùng ID từ product
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

  /// Helper: Get category ID từ name (DEPRECATED - Không dùng nữa)
  /// Giữ lại để tương thích với code cũ
  // int _getCategoryId(String category) {
  //   switch (category.toLowerCase()) {
  //     case 'electronics': return 1;
  //     case 'laptop': return 2;
  //     case 'tablet': return 3;
  //     case 'accessories': return 4;
  //     case 'clothing': return 4;
  //     case 'books': return 4;
  //     case 'food': return 4;
  //     case 'watch': return 5;
  //     default: return 4;
  //   }
  // }

  /// Cập nhật product
  Future<void> updateProduct(Product product) async {
    // ✅ Bỏ check authentication vì policies cho phép public access
    // final userId = client.auth.currentUser?.id;
    // if (userId == null) throw Exception('User not authenticated');

    await client.from('products').update({
      'name': product.name,
      'sku': product.code,
      'category_id': product.categoryId ?? 1, // Dùng ID từ product
      'brand_id': product.brandId ?? 1, // Dùng ID từ product
      'quantity': product.quantity,
      'price': product.price,
      'description': product.description,
      'image_url': product.imageUrl,
      'minimum_quantity': product.minimumQuantity,
    }).eq('id', int.parse(product.id));
  }

  /// Xóa product
  Future<void> deleteProduct(String productId) async {
    // ✅ Bỏ check authentication vì policies cho phép public access
    // final userId = client.auth.currentUser?.id;
    // if (userId == null) throw Exception('User not authenticated');

    await client.from('products').delete().eq('id', int.parse(productId));
  }

  // ==================== ACTIVITY METHODS ====================
  // ❌ KHÔNG DÙNG - Activities lưu local để tối ưu Supabase

  // /// Lấy các hoạt động gần đây
  // Future<List<Map<String, dynamic>>> getRecentActivities(
  //     {int limit = 10}) async {
  //   try {
  //     final response = await client
  //         .from('activities')
  //         .select()
  //         .order('created_at', ascending: false)
  //         .limit(limit);
  //
  //     return List<Map<String, dynamic>>.from(response);
  //   } catch (e) {
  //     debugPrint('⚠️ Activities table không tồn tại hoặc lỗi: $e');
  //     // Return empty nếu bảng không tồn tại
  //     return [];
  //   }
  // }

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

  // ==================== ORDER METHODS ====================

  /// Lấy tất cả orders của app kho
  Future<List<Order>> getOrders({
    OrderType? orderType,
    OrderStatus? status,
  }) async {
    try {
      debugPrint('🔄 Fetching orders from Supabase...');

      // Build query step by step
      // ✅ Chỉ rõ relationship để tránh ambiguous: users!orders_staff_id_fkey
      dynamic query = client.from('orders').select(
          '*, order_items(*, products(*)), staff:users!orders_staff_id_fkey(*)');

      // Apply filters (trước khi order)
      query = query.eq('order_source', 'app'); // Chỉ lấy đơn app

      if (orderType != null) {
        query = query.eq('order_type', orderType.value);
      }

      if (status != null) {
        query = query.eq('status', status.value);
      }

      // Order cuối cùng
      query = query.order('order_date', ascending: false);

      final response = await query as List;

      debugPrint('📦 Loaded ${response.length} orders from Supabase');

      return response.map((json) => Order.fromJson(json)).toList();
    } catch (e) {
      debugPrint('❌ Error loading orders from Supabase: $e');
      rethrow;
    }
  }

  /// Lấy một order theo ID
  Future<Order> getOrderById(int orderId) async {
    try {
      // ✅ Chỉ rõ relationship để tránh ambiguous: users!orders_staff_id_fkey
      final response = await client
          .from('orders')
          .select(
              '*, order_items(*, products(*)), staff:users!orders_staff_id_fkey(*)')
          .eq('id', orderId)
          .single();

      return Order.fromJson(response);
    } catch (e) {
      debugPrint('❌ Error loading order $orderId: $e');
      rethrow;
    }
  }

  /// Tạo order mới (nhập hoặc xuất hàng)
  Future<int> createOrder({
    required OrderType orderType,
    required List<OrderItem> items,
    String? partnerName,
    String? partnerPhone,
    String? partnerAddress,
    String? notes,
  }) async {
    try {
      final userId = client.auth.currentUser?.id;
      if (userId == null) throw Exception('User not authenticated');

      // Tính tổng tiền
      final totalAmount = items.fold<double>(
        0.0,
        (sum, item) => sum + (item.quantity * item.unitPrice),
      );

      // Bước 1: Tạo order
      final orderResponse = await client
          .from('orders')
          .insert({
            'order_source': 'app',
            'order_type': orderType.value,
            'user_id': null, // App không link với users
            'order_date': DateTime.now().toIso8601String(),
            'status': 'pending',
            'total_amount': totalAmount,
            'staff_id': userId,
            'notes': notes,
          })
          .select()
          .single();

      final orderId = orderResponse['id'] as int;
      debugPrint('✅ Created order #$orderId');

      // Bước 2: Tạo order_items
      final orderItemsData = items.map((item) {
        return {
          'order_id': orderId,
          'product_id': item.productId,
          'quantity': item.quantity,
          'unit_price': item.unitPrice,
        };
      }).toList();

      await client.from('order_items').insert(orderItemsData);

      debugPrint('✅ Created ${items.length} order items');

      return orderId;
    } catch (e) {
      debugPrint('❌ Error creating order: $e');
      rethrow;
    }
  }

  /// Cập nhật trạng thái order
  Future<void> updateOrderStatus(int orderId, OrderStatus newStatus) async {
    try {
      await client.from('orders').update({
        'status': newStatus.value,
      }).eq('id', orderId);

      debugPrint('✅ Updated order #$orderId to ${newStatus.value}');
    } catch (e) {
      debugPrint('❌ Error updating order status: $e');
      rethrow;
    }
  }

  /// Hủy order
  Future<void> cancelOrder(int orderId) async {
    try {
      await updateOrderStatus(orderId, OrderStatus.cancelled);
      debugPrint('✅ Cancelled order #$orderId');
    } catch (e) {
      debugPrint('❌ Error cancelling order: $e');
      rethrow;
    }
  }

  /// Xóa order (chỉ admin)
  Future<void> deleteOrder(int orderId) async {
    try {
      // Xóa order_items trước (cascade delete nếu có setup)
      await client.from('order_items').delete().eq('order_id', orderId);

      // Xóa order
      await client.from('orders').delete().eq('id', orderId);

      debugPrint('✅ Deleted order #$orderId');
    } catch (e) {
      debugPrint('❌ Error deleting order: $e');
      rethrow;
    }
  }

  /// Kiểm tra tồn kho sản phẩm
  Future<bool> checkProductStock(int productId, int requiredQuantity) async {
    try {
      final response = await client
          .from('products')
          .select('quantity')
          .eq('id', productId)
          .single();

      final currentStock = response['quantity'] as int;
      return currentStock >= requiredQuantity;
    } catch (e) {
      debugPrint('❌ Error checking stock: $e');
      return false;
    }
  }

  /// Lấy thống kê orders
  Future<Map<String, int>> getOrderStatistics() async {
    try {
      final orders = await getOrders();

      final totalOrders = orders.length;
      final importOrders =
          orders.where((o) => o.orderType == OrderType.import).length;
      final exportOrders =
          orders.where((o) => o.orderType == OrderType.export).length;
      final pendingOrders =
          orders.where((o) => o.status == OrderStatus.pending).length;
      final processingOrders =
          orders.where((o) => o.status == OrderStatus.processing).length;
      final completedOrders =
          orders.where((o) => o.status == OrderStatus.completed).length;
      final cancelledOrders =
          orders.where((o) => o.status == OrderStatus.cancelled).length;

      return {
        'total': totalOrders,
        'import': importOrders,
        'export': exportOrders,
        'pending': pendingOrders,
        'processing': processingOrders,
        'completed': completedOrders,
        'cancelled': cancelledOrders,
      };
    } catch (e) {
      debugPrint('❌ Error getting order statistics: $e');
      return {
        'total': 0,
        'import': 0,
        'export': 0,
        'pending': 0,
        'processing': 0,
        'completed': 0,
        'cancelled': 0,
      };
    }
  }
}
