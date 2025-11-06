/// Trạng thái đơn hàng
enum OrderStatus {
  pending('pending', 'Chờ xác nhận', 'Pending'),
  processing('processing', 'Đang xử lý', 'Processing'),
  completed('completed', 'Hoàn thành', 'Completed'),
  cancelled('cancelled', 'Đã hủy', 'Cancelled');

  final String value;
  final String labelVi;
  final String labelEn;

  const OrderStatus(this.value, this.labelVi, this.labelEn);

  static OrderStatus fromString(String value) {
    return OrderStatus.values.firstWhere(
      (status) => status.value.toLowerCase() == value.toLowerCase(),
      orElse: () => OrderStatus.pending,
    );
  }

  String getLabel(String languageCode) {
    return languageCode == 'vi' ? labelVi : labelEn;
  }
}

