import 'order_status.dart';
import 'order_type.dart';
import 'order_item.dart';

/// Model Đơn hàng (cho cả web và app kho)
class Order {
  final int id;
  final String orderSource; // 'web' hoặc 'app'
  final OrderType orderType; // sale, import, export
  final String? userId; // Nullable - app có thể lưu text thay vì link
  final DateTime orderDate;
  final OrderStatus status;
  final double totalAmount;
  final String? staffId; // Người tạo/xử lý
  final String? notes; // Ghi chú

  // Partner info (cho app kho - không link với users)
  final String? partnerName; // Tên nhà cung cấp/khách hàng
  final String? partnerPhone;
  final String? partnerAddress;

  // Optional: Order items (khi join)
  final List<OrderItem>? items;

  Order({
    required this.id,
    this.orderSource = 'app',
    required this.orderType,
    this.userId,
    required this.orderDate,
    required this.status,
    required this.totalAmount,
    this.staffId,
    this.notes,
    this.partnerName,
    this.partnerPhone,
    this.partnerAddress,
    this.items,
  });

  /// Tính tổng số lượng sản phẩm
  int get totalQuantity {
    if (items == null || items!.isEmpty) return 0;
    return items!.fold(0, (sum, item) => sum + item.quantity);
  }

  /// Kiểm tra có phải đơn nhập không
  bool get isImport => orderType == OrderType.import;

  /// Kiểm tra có phải đơn xuất không
  bool get isExport => orderType == OrderType.export;

  /// Kiểm tra có thể hủy không
  bool get canCancel =>
      status != OrderStatus.completed && status != OrderStatus.cancelled;

  /// Kiểm tra có thể cập nhật trạng thái không
  bool get canUpdateStatus => status != OrderStatus.cancelled;

  /// Copy with
  Order copyWith({
    int? id,
    String? orderSource,
    OrderType? orderType,
    String? userId,
    DateTime? orderDate,
    OrderStatus? status,
    double? totalAmount,
    String? staffId,
    String? notes,
    String? partnerName,
    String? partnerPhone,
    String? partnerAddress,
    List<OrderItem>? items,
  }) {
    return Order(
      id: id ?? this.id,
      orderSource: orderSource ?? this.orderSource,
      orderType: orderType ?? this.orderType,
      userId: userId ?? this.userId,
      orderDate: orderDate ?? this.orderDate,
      status: status ?? this.status,
      totalAmount: totalAmount ?? this.totalAmount,
      staffId: staffId ?? this.staffId,
      notes: notes ?? this.notes,
      partnerName: partnerName ?? this.partnerName,
      partnerPhone: partnerPhone ?? this.partnerPhone,
      partnerAddress: partnerAddress ?? this.partnerAddress,
      items: items ?? this.items,
    );
  }

  /// Convert to JSON (để gửi lên Supabase)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order_source': orderSource,
      'order_type': orderType.value,
      'user_id': userId,
      'order_date': orderDate.toIso8601String(),
      'status': status.value,
      'total_amount': totalAmount,
      'staff_id': staffId,
      'notes': notes,
    };
  }

  /// Create from JSON (từ Supabase)
  factory Order.fromJson(Map<String, dynamic> json) {
    // Parse items nếu có
    List<OrderItem>? items;
    if (json['order_items'] != null) {
      items = (json['order_items'] as List)
          .map((item) => OrderItem.fromJson(item as Map<String, dynamic>))
          .toList();
    }

    // Parse user/staff info nếu có
    String? partnerName;
    String? partnerPhone;
    String? partnerAddress;
    
    // Ưu tiên lấy từ 'users' (nếu là đơn web có user_id)
    // Hoặc từ 'staff' (nếu query dùng staff:users!orders_staff_id_fkey)
    final userInfo = json['users'] ?? json['staff'];
    if (userInfo != null && userInfo is Map<String, dynamic>) {
      partnerName = userInfo['full_name'] as String?;
      partnerPhone = userInfo['phone'] as String?;
      partnerAddress = userInfo['address'] as String?;
    }

    return Order(
      id: json['id'] as int,
      orderSource: json['order_source'] as String? ?? 'app',
      orderType: OrderType.fromString(json['order_type'] as String? ?? 'import'),
      userId: json['user_id'] as String?,
      orderDate: DateTime.parse(json['order_date'] as String),
      status: OrderStatus.fromString(json['status'] as String? ?? 'pending'),
      totalAmount: (json['total_amount'] as num).toDouble(),
      staffId: json['staff_id'] as String?,
      notes: json['notes'] as String?,
      partnerName: partnerName,
      partnerPhone: partnerPhone,
      partnerAddress: partnerAddress,
      items: items,
    );
  }

  @override
  String toString() {
    return 'Order(id: $id, type: ${orderType.value}, status: ${status.value}, '
        'amount: $totalAmount, date: $orderDate)';
  }
}

