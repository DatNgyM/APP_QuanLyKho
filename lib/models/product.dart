class Product {
  final String id;
  final String name;
  final String code; // SKU
  final String category;
  final int? categoryId;
  final String supplier; // Brand name
  final int? brandId;
  final int quantity;
  final double price;
  final String description;
  
  // Images
  final String? imageUrl;
  final List<String> images;
  
  // Rating & Reviews
  final double rating;
  final int reviews;
  final int discount;
  
  // Badges & Features
  final List<String> badges;
  final List<String> features;
  
  // Specifications (JSON)
  final Map<String, dynamic>? specifications;
  
  // Dates
  final int minimumQuantity;
  final DateTime dateAdded;
  final DateTime lastUpdated;

  Product({
    required this.id,
    required this.name,
    required this.code,
    required this.category,
    this.categoryId,
    required this.supplier,
    this.brandId,
    required this.quantity,
    required this.price,
    required this.description,
    this.imageUrl,
    this.images = const [],
    this.rating = 0.0,
    this.reviews = 0,
    this.discount = 0,
    this.badges = const [],
    this.features = const [],
    this.specifications,
    required this.minimumQuantity,
    required this.dateAdded,
    required this.lastUpdated,
  });

  Product copyWith({
    String? id,
    String? name,
    String? code,
    String? category,
    int? categoryId,
    String? supplier,
    int? brandId,
    int? quantity,
    double? price,
    String? description,
    String? imageUrl,
    List<String>? images,
    double? rating,
    int? reviews,
    int? discount,
    List<String>? badges,
    List<String>? features,
    Map<String, dynamic>? specifications,
    int? minimumQuantity,
    DateTime? dateAdded,
    DateTime? lastUpdated,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      code: code ?? this.code,
      category: category ?? this.category,
      categoryId: categoryId ?? this.categoryId,
      supplier: supplier ?? this.supplier,
      brandId: brandId ?? this.brandId,
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      images: images ?? this.images,
      rating: rating ?? this.rating,
      reviews: reviews ?? this.reviews,
      discount: discount ?? this.discount,
      badges: badges ?? this.badges,
      features: features ?? this.features,
      specifications: specifications ?? this.specifications,
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
      'category_id': categoryId,
      'supplier': supplier,
      'brand_id': brandId,
      'quantity': quantity,
      'price': price,
      'description': description,
      'imageUrl': imageUrl,
      'images': images,
      'rating': rating,
      'reviews': reviews,
      'discount': discount,
      'badges': badges,
      'features': features,
      'specifications': specifications,
      'minimumQuantity': minimumQuantity,
      'dateAdded': dateAdded.toIso8601String(),
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }

  factory Product.fromJson(Map<String, dynamic> json) {
    // Helper để parse list an toàn
    List<String> parseStringList(dynamic value) {
      if (value == null) return [];
      if (value is List) {
        return value.map((e) => e.toString()).toList();
      }
      return [];
    }

    // Helper để parse double an toàn
    double parseDouble(dynamic value) {
      if (value == null) return 0.0;
      if (value is double) return value;
      if (value is int) return value.toDouble();
      if (value is String) return double.tryParse(value) ?? 0.0;
      return 0.0;
    }

    // Helper để parse int an toàn
    int parseInt(dynamic value) {
      if (value == null) return 0;
      if (value is int) return value;
      if (value is double) return value.toInt();
      if (value is String) return int.tryParse(value) ?? 0;
      return 0;
    }

    return Product(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? 'Unknown Product',
      code: json['code']?.toString() ?? json['sku']?.toString() ?? 'N/A',
      category: json['category']?.toString() ?? 'Other',
      categoryId: json['category_id'],
      supplier: json['supplier']?.toString() ?? 'Unknown',
      brandId: json['brand_id'],
      quantity: parseInt(json['quantity']),
      price: parseDouble(json['price']),
      description: json['description']?.toString() ?? '',
      imageUrl: json['imageUrl']?.toString() ?? json['image_url']?.toString(),
      images: parseStringList(json['images']),
      rating: parseDouble(json['rating']),
      reviews: parseInt(json['reviews']),
      discount: parseInt(json['discount']),
      badges: parseStringList(json['badges']),
      features: parseStringList(json['features']),
      specifications: json['specifications'] is Map ? Map<String, dynamic>.from(json['specifications']) : null,
      minimumQuantity: parseInt(json['minimumQuantity'] ?? json['minimum_quantity']),
      dateAdded: json['dateAdded'] != null 
          ? DateTime.parse(json['dateAdded'])
          : (json['created_at'] != null ? DateTime.parse(json['created_at']) : DateTime.now()),
      lastUpdated: json['lastUpdated'] != null
          ? DateTime.parse(json['lastUpdated'])
          : (json['updated_at'] != null ? DateTime.parse(json['updated_at']) : DateTime.now()),
    );
  }
}

