import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// 🎨 Service để tạo dữ liệu mẫu (mockup) tự động
/// Dữ liệu giống hệt với SQL script
class MockupDataService {
  static final client = Supabase.instance.client;

  /// 📦 Dữ liệu mẫu PRODUCTS (10 sản phẩm)
  static final List<Map<String, dynamic>> mockProducts = [
    // 🔌 Electronics (4 products)
    {
      'name': 'iPhone 15 Pro Max',
      'code': 'IP15PM-001',
      'category': 'Electronics',
      'quantity': 25,
      'price': 32490000, // ₫32.490.000
      'description': 'Điện thoại flagship mới nhất với chip A17 Pro và thiết kế Titanium',
      'image_url': null,
      'supplier': 'Apple Inc.',
      'minimum_quantity': 10,
    },
    {
      'name': 'Samsung Galaxy S24 Ultra',
      'code': 'SGS24U-002',
      'category': 'Electronics',
      'quantity': 18,
      'price': 29990000, // ₫29.990.000
      'description': 'Điện thoại Android cao cấp với bút S Pen và tính năng AI',
      'image_url': null,
      'supplier': 'Samsung Electronics',
      'minimum_quantity': 8,
    },
    {
      'name': 'MacBook Pro 16"',
      'code': 'MBP16-003',
      'category': 'Electronics',
      'quantity': 8,
      'price': 62490000, // ₫62.490.000
      'description': 'Laptop mạnh mẽ cho chuyên gia với chip M3 Max',
      'image_url': null,
      'supplier': 'Apple Inc.',
      'minimum_quantity': 5,
    },
    {
      'name': 'Sony WH-1000XM5',
      'code': 'SWXM5-004',
      'category': 'Electronics',
      'quantity': 45,
      'price': 9990000, // ₫9.990.000
      'description': 'Tai nghe chống ồn hàng đầu thị trường',
      'image_url': null,
      'supplier': 'Sony Corporation',
      'minimum_quantity': 15,
    },

    // 👕 Clothing (2 products)
    {
      'name': 'Nike Air Max 270',
      'code': 'NAM270-005',
      'category': 'Clothing',
      'quantity': 60,
      'price': 3750000, // ₫3.750.000
      'description': 'Giày chạy bộ thoải mái với đệm Air',
      'image_url': null,
      'supplier': 'Nike Inc.',
      'minimum_quantity': 20,
    },
    {
      'name': 'Adidas Ultraboost 22',
      'code': 'AUB22-006',
      'category': 'Clothing',
      'quantity': 42,
      'price': 4750000, // ₫4.750.000
      'description': 'Giày chạy bộ cao cấp với công nghệ Boost',
      'image_url': null,
      'supplier': 'Adidas AG',
      'minimum_quantity': 15,
    },

    // 📚 Books (2 products)
    {
      'name': 'Clean Code',
      'code': 'BOOK-CC-007',
      'category': 'Books',
      'quantity': 120,
      'price': 1075000, // ₫1.075.000
      'description': 'Cẩm nang về kỹ thuật phần mềm Agile bởi Robert C. Martin',
      'image_url': null,
      'supplier': 'Prentice Hall',
      'minimum_quantity': 30,
    },
    {
      'name': 'Design Patterns',
      'code': 'BOOK-DP-008',
      'category': 'Books',
      'quantity': 85,
      'price': 1375000, // ₫1.375.000
      'description': 'Các mẫu thiết kế phần mềm hướng đối tượng',
      'image_url': null,
      'supplier': 'Addison-Wesley',
      'minimum_quantity': 25,
    },

    // 🍔 Food (2 products)
    {
      'name': 'Organic Green Tea',
      'code': 'OGT-009',
      'category': 'Food',
      'quantity': 200,
      'price': 399000, // ₫399.000
      'description': 'Trà xanh hữu cơ cao cấp từ Nhật Bản',
      'image_url': null,
      'supplier': 'Tea Garden Co.',
      'minimum_quantity': 50,
    },
    {
      'name': 'Dark Chocolate Bar',
      'code': 'DCB-010',
      'category': 'Food',
      'quantity': 3, // LOW STOCK!
      'price': 225000, // ₫225.000
      'description': 'Socola đen Bỉ 85% cacao - SẮP HẾT HÀNG!',
      'image_url': null,
      'supplier': 'Chocolatier Belgium',
      'minimum_quantity': 10,
    },
  ];

  /// 📝 Dữ liệu mẫu ACTIVITIES (8 hoạt động)
  static List<Map<String, dynamic>> getMockActivities() {
    final now = DateTime.now();
    return [
      {
        'action_type': 'add',
        'title': 'Product Added',
        'subtitle': 'iPhone 15 Pro Max - 25 units',
        'created_at': now.subtract(const Duration(minutes: 5)).toIso8601String(),
      },
      {
        'action_type': 'add',
        'title': 'Product Added',
        'subtitle': 'Samsung Galaxy S24 Ultra - 18 units',
        'created_at': now.subtract(const Duration(minutes: 15)).toIso8601String(),
      },
      {
        'action_type': 'update',
        'title': 'Product Updated',
        'subtitle': 'Nike Air Max 270 - Stock updated',
        'created_at': now.subtract(const Duration(hours: 1)).toIso8601String(),
      },
      {
        'action_type': 'low_stock_alert',
        'title': 'Low Stock Alert',
        'subtitle': 'Dark Chocolate Bar is running low',
        'created_at': now.subtract(const Duration(hours: 2)).toIso8601String(),
      },
      {
        'action_type': 'add',
        'title': 'Product Added',
        'subtitle': 'MacBook Pro 16" - 8 units',
        'created_at': now.subtract(const Duration(hours: 3)).toIso8601String(),
      },
      {
        'action_type': 'update',
        'title': 'Product Updated',
        'subtitle': 'Clean Code - Price adjusted',
        'created_at': now.subtract(const Duration(hours: 5)).toIso8601String(),
      },
      {
        'action_type': 'add',
        'title': 'Product Added',
        'subtitle': 'Organic Green Tea - 200 units',
        'created_at': now.subtract(const Duration(days: 1)).toIso8601String(),
      },
      {
        'action_type': 'delete',
        'title': 'Product Deleted',
        'subtitle': 'Old product removed from inventory',
        'created_at': now.subtract(const Duration(days: 2)).toIso8601String(),
      },
    ];
  }

  /// 🚀 TỰ ĐỘNG INSERT MOCKUP DATA VÀO SUPABASE
  /// Call function này để tạo dữ liệu mẫu
  static Future<Map<String, dynamic>> insertMockupData() async {
    try {
      final userId = client.auth.currentUser?.id;
      if (userId == null) {
        debugPrint('❌ ERROR: User chưa đăng nhập');
        return {
          'success': false,
          'message': 'User chưa đăng nhập',
        };
      }

      debugPrint('👤 User ID: $userId');
      debugPrint('📦 Bắt đầu insert ${mockProducts.length} products...');

      int productsInserted = 0;
      int activitiesInserted = 0;
      List<String> errors = [];

      // Insert Products
      for (var product in mockProducts) {
        try {
          debugPrint('  → Inserting: ${product['name']}...');
          
          // Tạo object để insert
          final productData = <String, dynamic>{
            'name': product['name'],
            'sku': product['code'], // code → sku (theo schema thật)
            'quantity': product['quantity'],
            'price': product['price'],
            'description': product['description'],
          };

          // Thêm các cột optional nếu tồn tại trong schema
          if (product['category'] != null) {
            productData['category'] = product['category'];
          }
          if (product['supplier'] != null) {
            productData['supplier'] = product['supplier'];
          }
          if (product['minimum_quantity'] != null) {
            productData['minimum_quantity'] = product['minimum_quantity'];
          }
          if (product['image_url'] != null) {
            productData['image_url'] = product['image_url'];
          }
          if (product['code'] != null) {
            productData['code'] = product['code'];
          }

          final response = await client.from('products').insert(productData).select();
          
          debugPrint('  ✅ Inserted: ${product['name']} - Response: $response');
          productsInserted++;
        } catch (e) {
          debugPrint('  ❌ Error inserting ${product['name']}: $e');
          errors.add('${product['name']}: $e');
        }
      }

      debugPrint('📝 Bắt đầu insert ${getMockActivities().length} activities...');

      // Insert Activities
      for (var activity in getMockActivities()) {
        try {
          final activityData = <String, dynamic>{
            'action_type': activity['action_type'],
            'title': activity['title'],
            'subtitle': activity['subtitle'],
          };

          // Thêm user_id nếu có
          try {
            activityData['user_id'] = userId;
          } catch (e) {
            debugPrint('  ⚠️ Skip user_id for activity');
          }

          // Thêm created_at nếu table hỗ trợ
          if (activity['created_at'] != null) {
            activityData['created_at'] = activity['created_at'];
          }

          await client.from('activities').insert(activityData);
          activitiesInserted++;
          debugPrint('  ✅ Inserted activity: ${activity['title']}');
        } catch (e) {
          debugPrint('  ❌ Error inserting activity: $e');
          errors.add('Activity: $e');
        }
      }

      debugPrint('🎉 HOÀN THÀNH: $productsInserted products, $activitiesInserted activities');
      
      if (errors.isNotEmpty) {
        debugPrint('⚠️ Có ${errors.length} lỗi:');
        for (var error in errors) {
          debugPrint('  - $error');
        }
      }

      return {
        'success': productsInserted > 0,
        'message': productsInserted > 0 
            ? 'Mockup data inserted successfully!' 
            : 'No data inserted. Check errors.',
        'productsInserted': productsInserted,
        'activitiesInserted': activitiesInserted,
        'errors': errors,
        'autoLoaded': true,
      };
    } catch (e) {
      debugPrint('❌ FATAL ERROR: $e');
      return {
        'success': false,
        'message': 'Error: $e',
        'autoLoaded': false,
      };
    }
  }

  /// 🔍 KIỂM TRA XEM ĐÃ CÓ DỮ LIỆU CHƯA
  static Future<bool> hasData() async {
    try {
      final response = await client
          .from('products')
          .select('id')
          .limit(1);
      
      return response.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  /// 🎯 AUTO-LOAD MOCKUP NẾU DATABASE RỖNG
  /// Gọi function này khi vào Dashboard lần đầu
  static Future<Map<String, dynamic>> autoLoadMockupIfEmpty() async {
    try {
      final hasExistingData = await hasData();
      
      if (!hasExistingData) {
        debugPrint('📦 Database is empty. Auto-loading mockup data...');
        return await insertMockupData();
      } else {
        return {
          'success': true,
          'message': 'Database already has data',
          'autoLoaded': false,
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Error checking data: $e',
      };
    }
  }

  /// 🧹 XÓA TẤT CẢ DỮ LIỆU (DANGER!)
  static Future<bool> clearAllData() async {
    try {
      await client.from('activities').delete().neq('id', '00000000-0000-0000-0000-000000000000');
      await client.from('products').delete().neq('id', '00000000-0000-0000-0000-000000000000');
      return true;
    } catch (e) {
      debugPrint('Error clearing data: $e');
      return false;
    }
  }

  /// 📊 THỐNG KÊ MOCKUP DATA
  static Map<String, dynamic> getMockupStats() {
    final totalProducts = mockProducts.length;
    final lowStockProducts = mockProducts.where((p) => (p['quantity'] as int) <= (p['minimum_quantity'] as int)).length;
    final outOfStockProducts = mockProducts.where((p) => (p['quantity'] as int) == 0).length;
    final totalValue = mockProducts.fold<double>(
      0.0,
      (sum, p) => sum + ((p['quantity'] as int) * (p['price'] as double)),
    );

    return {
      'totalProducts': totalProducts,
      'lowStockCount': lowStockProducts,
      'outOfStockCount': outOfStockProducts,
      'totalValue': totalValue,
      'categories': {
        'Electronics': mockProducts.where((p) => p['category'] == 'Electronics').length,
        'Clothing': mockProducts.where((p) => p['category'] == 'Clothing').length,
        'Books': mockProducts.where((p) => p['category'] == 'Books').length,
        'Food': mockProducts.where((p) => p['category'] == 'Food').length,
      },
    };
  }
}

