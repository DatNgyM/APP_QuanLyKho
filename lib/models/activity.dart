class Activity {
  final String id;
  final String type;
  final String description;
  final String? productId;
  final DateTime timestamp;

  Activity({
    required this.id,
    required this.type,
    required this.description,
    this.productId,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'description': description,
      'productId': productId,
      'timestamp': timestamp.millisecondsSinceEpoch,
    };
  }

  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      id: json['id'],
      type: json['type'],
      description: json['description'],
      productId: json['productId'],
      timestamp: DateTime.fromMillisecondsSinceEpoch(json['timestamp']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type,
      'description': description,
      'product_id': productId,
      'timestamp': timestamp.millisecondsSinceEpoch,
    };
  }

  factory Activity.fromMap(Map<String, dynamic> map) {
    return Activity(
      id: map['id'],
      type: map['type'],
      description: map['description'],
      productId: map['product_id'],
      timestamp: DateTime.fromMillisecondsSinceEpoch(map['timestamp']),
    );
  }
}

