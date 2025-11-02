import 'package:flutter/material.dart';
import '../models/product.dart';

/// 🎨 LOCAL MOCKUP SERVICE - KHÔNG CẦN SUPABASE!
/// Dữ liệu hiển thị trực tiếp từ code, không cần database
class LocalMockupService {
  
  /// 📦 10 SẢN PHẨM MẪU (LOCAL - KHÔNG LƯU VÀO DATABASE)
  static List<Product> getLocalMockProducts() {
    final now = DateTime.now();
    
    return [
      // 🔌 Electronics
      Product(
        id: 'local-1',
        name: 'iPhone 15 Pro Max',
        code: 'IP15PM-001',
        category: 'Electronics',
        quantity: 25,
        price: 32490000,
        description: 'Điện thoại flagship mới nhất với chip A17 Pro và thiết kế Titanium',
        imageUrl: null,
        supplier: 'Apple Inc.',
        minimumQuantity: 10,
        dateAdded: now.subtract(const Duration(days: 30)),
        lastUpdated: now.subtract(const Duration(days: 1)),
      ),
      
      Product(
        id: 'local-2',
        name: 'Samsung Galaxy S24 Ultra',
        code: 'SGS24U-002',
        category: 'Electronics',
        quantity: 18,
        price: 29990000,
        description: 'Điện thoại Android cao cấp với bút S Pen và tính năng AI',
        imageUrl: null,
        supplier: 'Samsung Electronics',
        minimumQuantity: 8,
        dateAdded: now.subtract(const Duration(days: 25)),
        lastUpdated: now.subtract(const Duration(days: 2)),
      ),
      
      Product(
        id: 'local-3',
        name: 'MacBook Pro 16"',
        code: 'MBP16-003',
        category: 'Electronics',
        quantity: 8,
        price: 62490000,
        description: 'Laptop mạnh mẽ cho chuyên gia với chip M3 Max',
        imageUrl: null,
        supplier: 'Apple Inc.',
        minimumQuantity: 5,
        dateAdded: now.subtract(const Duration(days: 20)),
        lastUpdated: now.subtract(const Duration(hours: 5)),
      ),
      
      Product(
        id: 'local-4',
        name: 'Sony WH-1000XM5',
        code: 'SWXM5-004',
        category: 'Electronics',
        quantity: 45,
        price: 9990000,
        description: 'Tai nghe chống ồn hàng đầu thị trường',
        imageUrl: null,
        supplier: 'Sony Corporation',
        minimumQuantity: 15,
        dateAdded: now.subtract(const Duration(days: 15)),
        lastUpdated: now.subtract(const Duration(hours: 10)),
      ),
      
      // 👕 Clothing
      Product(
        id: 'local-5',
        name: 'Nike Air Max 270',
        code: 'NAM270-005',
        category: 'Clothing',
        quantity: 60,
        price: 3750000,
        description: 'Giày chạy bộ thoải mái với đệm Air',
        imageUrl: null,
        supplier: 'Nike Inc.',
        minimumQuantity: 20,
        dateAdded: now.subtract(const Duration(days: 12)),
        lastUpdated: now.subtract(const Duration(hours: 1)),
      ),
      
      Product(
        id: 'local-6',
        name: 'Adidas Ultraboost 22',
        code: 'AUB22-006',
        category: 'Clothing',
        quantity: 42,
        price: 4750000,
        description: 'Giày chạy bộ cao cấp với công nghệ Boost',
        imageUrl: null,
        supplier: 'Adidas AG',
        minimumQuantity: 15,
        dateAdded: now.subtract(const Duration(days: 10)),
        lastUpdated: now.subtract(const Duration(hours: 3)),
      ),
      
      // 📚 Books
      Product(
        id: 'local-7',
        name: 'Clean Code',
        code: 'BOOK-CC-007',
        category: 'Books',
        quantity: 120,
        price: 1075000,
        description: 'Cẩm nang về kỹ thuật phần mềm Agile bởi Robert C. Martin',
        imageUrl: null,
        supplier: 'Prentice Hall',
        minimumQuantity: 30,
        dateAdded: now.subtract(const Duration(days: 8)),
        lastUpdated: now.subtract(const Duration(hours: 5)),
      ),
      
      Product(
        id: 'local-8',
        name: 'Design Patterns',
        code: 'BOOK-DP-008',
        category: 'Books',
        quantity: 85,
        price: 1375000,
        description: 'Các mẫu thiết kế phần mềm hướng đối tượng',
        imageUrl: null,
        supplier: 'Addison-Wesley',
        minimumQuantity: 25,
        dateAdded: now.subtract(const Duration(days: 6)),
        lastUpdated: now.subtract(const Duration(days: 1)),
      ),
      
      // 🍔 Food
      Product(
        id: 'local-9',
        name: 'Organic Green Tea',
        code: 'OGT-009',
        category: 'Food',
        quantity: 200,
        price: 399000,
        description: 'Trà xanh hữu cơ cao cấp từ Nhật Bản',
        imageUrl: null,
        supplier: 'Tea Garden Co.',
        minimumQuantity: 50,
        dateAdded: now.subtract(const Duration(days: 4)),
        lastUpdated: now.subtract(const Duration(hours: 12)),
      ),
      
      Product(
        id: 'local-10',
        name: 'Dark Chocolate Bar',
        code: 'DCB-010',
        category: 'Food',
        quantity: 3, // LOW STOCK!
        price: 225000,
        description: 'Socola đen Bỉ 85% cacao - SẮP HẾT HÀNG!',
        imageUrl: null,
        supplier: 'Chocolatier Belgium',
        minimumQuantity: 10,
        dateAdded: now.subtract(const Duration(days: 2)),
        lastUpdated: now.subtract(const Duration(minutes: 30)),
      ),
    ];
  }

  /// 📝 8 HOẠT ĐỘNG MẪU (LOCAL)
  static List<Map<String, dynamic>> getLocalMockActivities() {
    final now = DateTime.now();
    
    return [
      {
        'id': 'act-1',
        'action_type': 'add',
        'title': 'Product Added',
        'subtitle': 'iPhone 15 Pro Max - 25 units',
        'created_at': now.subtract(const Duration(minutes: 5)).toIso8601String(),
      },
      {
        'id': 'act-2',
        'action_type': 'add',
        'title': 'Product Added',
        'subtitle': 'Samsung Galaxy S24 Ultra - 18 units',
        'created_at': now.subtract(const Duration(minutes: 15)).toIso8601String(),
      },
      {
        'id': 'act-3',
        'action_type': 'update',
        'title': 'Product Updated',
        'subtitle': 'Nike Air Max 270 - Stock updated',
        'created_at': now.subtract(const Duration(hours: 1)).toIso8601String(),
      },
      {
        'id': 'act-4',
        'action_type': 'low_stock_alert',
        'title': 'Low Stock Alert',
        'subtitle': 'Dark Chocolate Bar is running low',
        'created_at': now.subtract(const Duration(hours: 2)).toIso8601String(),
      },
      {
        'id': 'act-5',
        'action_type': 'add',
        'title': 'Product Added',
        'subtitle': 'MacBook Pro 16" - 8 units',
        'created_at': now.subtract(const Duration(hours: 3)).toIso8601String(),
      },
      {
        'id': 'act-6',
        'action_type': 'update',
        'title': 'Product Updated',
        'subtitle': 'Clean Code - Price adjusted',
        'created_at': now.subtract(const Duration(hours: 5)).toIso8601String(),
      },
      {
        'id': 'act-7',
        'action_type': 'add',
        'title': 'Product Added',
        'subtitle': 'Organic Green Tea - 200 units',
        'created_at': now.subtract(const Duration(days: 1)).toIso8601String(),
      },
      {
        'id': 'act-8',
        'action_type': 'delete',
        'title': 'Product Deleted',
        'subtitle': 'Old product removed from inventory',
        'created_at': now.subtract(const Duration(days: 2)).toIso8601String(),
      },
    ];
  }

  /// 📊 THỐNG KÊ LOCAL
  static Map<String, dynamic> getLocalStats() {
    final products = getLocalMockProducts();
    
    return {
      'totalProducts': products.length,
      'lowStockCount': products.where((p) => p.quantity <= p.minimumQuantity).length,
      'outOfStockCount': products.where((p) => p.quantity == 0).length,
      'totalValue': products.fold<double>(
        0.0,
        (sum, p) => sum + (p.quantity * p.price),
      ),
    };
  }
}

