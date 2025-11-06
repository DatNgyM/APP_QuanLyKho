import 'package:flutter/material.dart';
import '../models/order.dart';
import '../models/order_item.dart';
import '../models/order_status.dart';
import '../models/order_type.dart';
import '../services/supabase_service.dart';

class OrderProvider extends ChangeNotifier {
  final SupabaseService _supabaseService = SupabaseService();
  
  List<Order> _orders = [];
  bool _isLoading = false;
  bool _hasError = false;
  String? _errorMessage;
  
  // Filters
  OrderType? _selectedOrderType;
  OrderStatus? _selectedStatus;
  String _searchQuery = '';

  // Getters
  List<Order> get orders => _getFilteredOrders();
  List<Order> get importOrders => _orders.where((o) => o.isImport).toList();
  List<Order> get exportOrders => _orders.where((o) => o.isExport).toList();
  
  bool get isLoading => _isLoading;
  bool get hasError => _hasError;
  String? get errorMessage => _errorMessage;
  
  OrderType? get selectedOrderType => _selectedOrderType;
  OrderStatus? get selectedStatus => _selectedStatus;
  String get searchQuery => _searchQuery;

  // Statistics
  int get totalOrders => _orders.length;
  int get importOrdersCount => _orders.where((o) => o.isImport).length;
  int get exportOrdersCount => _orders.where((o) => o.isExport).length;
  int get pendingOrdersCount => _orders.where((o) => o.status == OrderStatus.pending).length;
  int get processingOrdersCount => _orders.where((o) => o.status == OrderStatus.processing).length;
  int get completedOrdersCount => _orders.where((o) => o.status == OrderStatus.completed).length;
  int get cancelledOrdersCount => _orders.where((o) => o.status == OrderStatus.cancelled).length;

  double get totalImportAmount => _orders
      .where((o) => o.isImport && o.status == OrderStatus.completed)
      .fold(0.0, (sum, o) => sum + o.totalAmount);
  
  double get totalExportAmount => _orders
      .where((o) => o.isExport && o.status == OrderStatus.completed)
      .fold(0.0, (sum, o) => sum + o.totalAmount);

  OrderProvider() {
    _loadOrders();
  }

  /// Load orders từ Supabase
  Future<void> _loadOrders() async {
    _isLoading = true;
    _hasError = false;
    _errorMessage = null;
    notifyListeners();

    try {
      debugPrint('🔄 Loading orders from Supabase...');
      _orders = await _supabaseService.getOrders();
      debugPrint('✅ Loaded ${_orders.length} orders');
      
      _hasError = false;
      _errorMessage = null;
    } catch (e) {
      debugPrint('❌ Error loading orders: $e');
      _hasError = true;
      _errorMessage = 'Không thể tải danh sách đơn hàng.\n\n'
          'Lỗi: ${e.toString()}';
      _orders = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Lọc orders theo filter hiện tại
  List<Order> _getFilteredOrders() {
    List<Order> filtered = List.from(_orders);

    // Filter theo loại đơn
    if (_selectedOrderType != null) {
      filtered = filtered.where((o) => o.orderType == _selectedOrderType).toList();
    }

    // Filter theo trạng thái
    if (_selectedStatus != null) {
      filtered = filtered.where((o) => o.status == _selectedStatus).toList();
    }

    // Search
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((o) {
        final query = _searchQuery.toLowerCase();
        return o.id.toString().contains(query) ||
            (o.partnerName?.toLowerCase().contains(query) ?? false) ||
            (o.notes?.toLowerCase().contains(query) ?? false);
      }).toList();
    }

    return filtered;
  }

  /// Set filter loại đơn
  void setOrderTypeFilter(OrderType? type) {
    _selectedOrderType = type;
    notifyListeners();
  }

  /// Set filter trạng thái
  void setStatusFilter(OrderStatus? status) {
    _selectedStatus = status;
    notifyListeners();
  }

  /// Set search query
  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  /// Clear tất cả filters
  void clearFilters() {
    _selectedOrderType = null;
    _selectedStatus = null;
    _searchQuery = '';
    notifyListeners();
  }

  /// Refresh orders
  Future<void> refresh() async {
    await _loadOrders();
  }

  /// Tạo order mới
  Future<int> createOrder({
    required OrderType orderType,
    required List<OrderItem> items,
    String? partnerName,
    String? partnerPhone,
    String? partnerAddress,
    String? notes,
  }) async {
    try {
      debugPrint('🔄 Creating new order...');
      
      final orderId = await _supabaseService.createOrder(
        orderType: orderType,
        items: items,
        partnerName: partnerName,
        partnerPhone: partnerPhone,
        partnerAddress: partnerAddress,
        notes: notes,
      );

      debugPrint('✅ Created order #$orderId');
      
      // Refresh danh sách
      await _loadOrders();
      
      return orderId;
    } catch (e) {
      debugPrint('❌ Error creating order: $e');
      rethrow;
    }
  }

  /// Cập nhật trạng thái order
  Future<void> updateOrderStatus(int orderId, OrderStatus newStatus) async {
    try {
      debugPrint('🔄 Updating order #$orderId to ${newStatus.value}...');
      
      await _supabaseService.updateOrderStatus(orderId, newStatus);
      
      debugPrint('✅ Updated order #$orderId');
      
      // Refresh danh sách
      await _loadOrders();
    } catch (e) {
      debugPrint('❌ Error updating order status: $e');
      rethrow;
    }
  }

  /// Hủy order
  Future<void> cancelOrder(int orderId) async {
    try {
      debugPrint('🔄 Cancelling order #$orderId...');
      
      await _supabaseService.cancelOrder(orderId);
      
      debugPrint('✅ Cancelled order #$orderId');
      
      // Refresh danh sách
      await _loadOrders();
    } catch (e) {
      debugPrint('❌ Error cancelling order: $e');
      rethrow;
    }
  }

  /// Xóa order
  Future<void> deleteOrder(int orderId) async {
    try {
      debugPrint('🔄 Deleting order #$orderId...');
      
      await _supabaseService.deleteOrder(orderId);
      
      debugPrint('✅ Deleted order #$orderId');
      
      // Refresh danh sách
      await _loadOrders();
    } catch (e) {
      debugPrint('❌ Error deleting order: $e');
      rethrow;
    }
  }

  /// Lấy order theo ID
  Future<Order?> getOrderById(int orderId) async {
    try {
      return await _supabaseService.getOrderById(orderId);
    } catch (e) {
      debugPrint('❌ Error getting order #$orderId: $e');
      return null;
    }
  }

  /// Kiểm tra tồn kho
  Future<bool> checkProductStock(int productId, int requiredQuantity) async {
    return await _supabaseService.checkProductStock(productId, requiredQuantity);
  }
}

