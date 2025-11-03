/// Model cho Brands từ Supabase
class Brand {
  final int id;
  final String name;
  final String? slug;
  final String? logo;
  final String? description;
  final DateTime? createdAt;

  Brand({
    required this.id,
    required this.name,
    this.slug,
    this.logo,
    this.description,
    this.createdAt,
  });

  factory Brand.fromJson(Map<String, dynamic> json) {
    return Brand(
      id: json['id'] is int ? json['id'] : int.parse(json['id'].toString()),
      name: json['name']?.toString() ?? 'Unknown',
      slug: json['slug']?.toString(),
      logo: json['logo']?.toString(),
      description: json['description']?.toString(),
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'slug': slug,
      'logo': logo,
      'description': description,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  @override
  String toString() => name;
}

