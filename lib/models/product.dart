class Product {
  final String id;
  final String name;
  final String code;
  final String category;
  final int quantity;
  final double price;
  final String description;
  final String? imageUrl;
  final String supplier;
  final int minimumQuantity;
  final DateTime dateAdded;
  final DateTime lastUpdated;

  Product({
    required this.id,
    required this.name,
    required this.code,
    required this.category,
    required this.quantity,
    required this.price,
    required this.description,
    this.imageUrl,
    required this.supplier,
    required this.minimumQuantity,
    required this.dateAdded,
    required this.lastUpdated,
  });

  Product copyWith({
    String? id,
    String? name,
    String? code,
    String? category,
    int? quantity,
    double? price,
    String? description,
    String? imageUrl,
    String? supplier,
    int? minimumQuantity,
    DateTime? dateAdded,
    DateTime? lastUpdated,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      code: code ?? this.code,
      category: category ?? this.category,
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      supplier: supplier ?? this.supplier,
      minimumQuantity: minimumQuantity ?? this.minimumQuantity,
      dateAdded: dateAdded ?? this.dateAdded,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'code': code,
      'category': category,
      'quantity': quantity,
      'price': price,
      'description': description,
      'imageUrl': imageUrl,
      'supplier': supplier,
      'minimumQuantity': minimumQuantity,
      'dateAdded': dateAdded.toIso8601String(),
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      code: json['code'],
      category: json['category'],
      quantity: json['quantity'],
      price: json['price'].toDouble(),
      description: json['description'],
      imageUrl: json['imageUrl'],
      supplier: json['supplier'],
      minimumQuantity: json['minimumQuantity'],
      dateAdded: DateTime.parse(json['dateAdded']),
      lastUpdated: DateTime.parse(json['lastUpdated']),
    );
  }
}

