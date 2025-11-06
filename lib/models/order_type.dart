/// Loại đơn hàng
enum OrderType {
  sale('sale', 'Bán hàng', 'Sale', '🛒'),
  import('import', 'Nhập hàng', 'Import', '⬇️'),
  export('export', 'Xuất hàng', 'Export', '⬆️');

  final String value;
  final String labelVi;
  final String labelEn;
  final String icon;

  const OrderType(this.value, this.labelVi, this.labelEn, this.icon);

  static OrderType fromString(String value) {
    return OrderType.values.firstWhere(
      (type) => type.value.toLowerCase() == value.toLowerCase(),
      orElse: () => OrderType.sale,
    );
  }

  String getLabel(String languageCode) {
    return languageCode == 'vi' ? labelVi : labelEn;
  }
}

