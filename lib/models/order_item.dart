import 'product.dart';

/// Chi tiết sản phẩm trong đơn hàng
class OrderItem {
  final int id;
  final int orderId;
  final int productId;
  final int quantity;
  final double unitPrice;
  
  // Optional: Product info (khi join)
  final Product? product;

  OrderItem({
    required this.id,
    required this.orderId,
    required this.productId,
    required this.quantity,
    required this.unitPrice,
    this.product,
  });

  /// Tính tổng tiền của item này
  double get totalPrice => quantity * unitPrice;

  /// Copy with
  OrderItem copyWith({
    int? id,
    int? orderId,
    int? productId,
    int? quantity,
    double? unitPrice,
    Product? product,
  }) {
    return OrderItem(
      id: id ?? this.id,
      orderId: orderId ?? this.orderId,
      productId: productId ?? this.productId,
      quantity: quantity ?? this.quantity,
      unitPrice: unitPrice ?? this.unitPrice,
      product: product ?? this.product,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order_id': orderId,
      'product_id': productId,
      'quantity': quantity,
      'unit_price': unitPrice,
    };
  }

  /// Create from JSON
  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json['id'] as int,
      orderId: json['order_id'] as int,
      productId: json['product_id'] as int,
      quantity: json['quantity'] as int,
      unitPrice: (json['unit_price'] as num).toDouble(),
      product: json['products'] != null
          ? Product.fromJson(json['products'] as Map<String, dynamic>)
          : null,
    );
  }

  @override
  String toString() {
    return 'OrderItem(id: $id, orderId: $orderId, productId: $productId, '
        'quantity: $quantity, unitPrice: $unitPrice)';
  }
}

