import 'package:flutter/material.dart';
import '../services/supabase_service.dart';
import '../models/product.dart';

/// 🧪 Helper class để test CRUD operations cho products
/// 
/// Sử dụng:
/// ```dart
/// await ProductTestHelper.runAllTests();
/// ```
class ProductTestHelper {
  static final _supabaseService = SupabaseService();

  /// Chạy tất cả các test CRUD
  static Future<void> runAllTests() async {
    debugPrint('\n🧪 ========== BẮT ĐẦU TEST CRUD OPERATIONS ==========\n');

    try {
      // Test 1: Đọc sản phẩm
      await testReadProducts();

      // Test 2: Thêm sản phẩm
      final productId = await testAddProduct();

      if (productId != null) {
        // Test 3: Cập nhật sản phẩm
        await testUpdateProduct(productId);

        // Test 4: Xóa sản phẩm
        await testDeleteProduct(productId);
      }

      debugPrint('\n✅ ========== TẤT CẢ TEST ĐÃ HOÀN THÀNH ==========\n');
    } catch (e) {
      debugPrint('\n❌ ========== TEST THẤT BẠI ==========');
      debugPrint('Lỗi: $e');
      debugPrint('Stack: ${StackTrace.current}');
    }
  }

  /// Test 1️⃣: Đọc danh sách sản phẩm
  static Future<void> testReadProducts() async {
    debugPrint('1️⃣ TEST READ: Đọc danh sách sản phẩm từ Supabase...');

    try {
      final products = await _supabaseService.getProducts();
      debugPrint('   ✅ Đọc thành công ${products.length} sản phẩm');
      
      if (products.isNotEmpty) {
        final firstProduct = products.first;
        debugPrint('   📦 Sản phẩm đầu tiên: ${firstProduct.name} (ID: ${firstProduct.id})');
      } else {
        debugPrint('   ⚠️ Database chưa có sản phẩm nào');
      }
    } catch (e) {
      debugPrint('   ❌ Lỗi đọc sản phẩm: $e');
      rethrow;
    }
  }

  /// Test 2️⃣: Thêm sản phẩm mới
  static Future<String?> testAddProduct() async {
    debugPrint('\n2️⃣ TEST INSERT: Thêm sản phẩm mới vào Supabase...');

    try {
      final testProduct = Product(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: 'Test Product ${DateTime.now().second}',
        code: 'TEST-${DateTime.now().millisecondsSinceEpoch}',
        category: 'Electronics',
        supplier: 'Test Supplier',
        quantity: 100,
        price: 999.99,
        description: 'This is a test product created by ProductTestHelper',
        minimumQuantity: 10,
        dateAdded: DateTime.now(),
        lastUpdated: DateTime.now(),
      );

      final productId = await _supabaseService.addProduct(testProduct);
      debugPrint('   ✅ Thêm sản phẩm thành công! ID: $productId');
      debugPrint('   📦 Sản phẩm: ${testProduct.name}');
      
      return productId;
    } catch (e) {
      debugPrint('   ❌ Lỗi thêm sản phẩm: $e');
      rethrow;
    }
  }

  /// Test 3️⃣: Cập nhật sản phẩm
  static Future<void> testUpdateProduct(String productId) async {
    debugPrint('\n3️⃣ TEST UPDATE: Cập nhật sản phẩm ID: $productId...');

    try {
      final updatedProduct = Product(
        id: productId,
        name: 'Updated Test Product ${DateTime.now().second}',
        code: 'TEST-UPDATED-${DateTime.now().millisecondsSinceEpoch}',
        category: 'Electronics',
        supplier: 'Updated Supplier',
        quantity: 200,
        price: 1499.99,
        description: 'This product has been updated by ProductTestHelper',
        minimumQuantity: 15,
        dateAdded: DateTime.now(),
        lastUpdated: DateTime.now(),
      );

      await _supabaseService.updateProduct(updatedProduct);
      debugPrint('   ✅ Cập nhật sản phẩm thành công!');
      debugPrint('   📦 Sản phẩm mới: ${updatedProduct.name}');
      debugPrint('   💰 Giá mới: \$${updatedProduct.price}');
    } catch (e) {
      debugPrint('   ❌ Lỗi cập nhật sản phẩm: $e');
      rethrow;
    }
  }

  /// Test 4️⃣: Xóa sản phẩm
  static Future<void> testDeleteProduct(String productId) async {
    debugPrint('\n4️⃣ TEST DELETE: Xóa sản phẩm ID: $productId...');

    try {
      await _supabaseService.deleteProduct(productId);
      debugPrint('   ✅ Xóa sản phẩm thành công!');
      debugPrint('   🗑️ Đã xóa sản phẩm ID: $productId');
    } catch (e) {
      debugPrint('   ❌ Lỗi xóa sản phẩm: $e');
      rethrow;
    }
  }

  /// Test đơn lẻ: Chỉ test thêm sản phẩm
  static Future<void> testAddOnly() async {
    debugPrint('\n🧪 ========== TEST THÊM SẢN PHẨM ==========\n');
    try {
      await testAddProduct();
      debugPrint('\n✅ ========== TEST HOÀN THÀNH ==========\n');
    } catch (e) {
      debugPrint('\n❌ TEST THẤT BẠI: $e\n');
    }
  }

  /// Test đơn lẻ: Chỉ test đọc sản phẩm
  static Future<void> testReadOnly() async {
    debugPrint('\n🧪 ========== TEST ĐỌC SẢN PHẨM ==========\n');
    try {
      await testReadProducts();
      debugPrint('\n✅ ========== TEST HOÀN THÀNH ==========\n');
    } catch (e) {
      debugPrint('\n❌ TEST THẤT BẠI: $e\n');
    }
  }

  /// Kiểm tra kết nối Supabase
  static Future<bool> checkConnection() async {
    debugPrint('\n🔌 Kiểm tra kết nối Supabase...');
    
    try {
      final categories = await _supabaseService.getCategories();
      debugPrint('   ✅ Kết nối thành công! Loaded ${categories.length} categories');
      return true;
    } catch (e) {
      debugPrint('   ❌ Kết nối thất bại: $e');
      return false;
    }
  }

  /// In ra thống kê database
  static Future<void> printStatistics() async {
    debugPrint('\n📊 ========== THỐNG KÊ DATABASE ==========\n');
    
    try {
      final stats = await _supabaseService.getStatistics();
      debugPrint('   📦 Tổng số sản phẩm: ${stats['totalProducts']}');
      debugPrint('   ⚠️ Sản phẩm sắp hết: ${stats['lowStockCount']}');
      debugPrint('   ❌ Sản phẩm hết hàng: ${stats['outOfStockCount']}');
      debugPrint('   💰 Tổng giá trị kho: \$${stats['totalValue'].toStringAsFixed(2)}');
      debugPrint('\n==========================================\n');
    } catch (e) {
      debugPrint('   ❌ Lỗi lấy thống kê: $e\n');
    }
  }
}

