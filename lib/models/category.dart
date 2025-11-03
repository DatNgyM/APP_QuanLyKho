/// Model cho Categories từ Supabase
class Category {
  final int id;
  final String name;
  final String? slug;
  final String? description;

  Category({
    required this.id,
    required this.name,
    this.slug,
    this.description,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] is int ? json['id'] : int.parse(json['id'].toString()),
      name: json['name']?.toString() ?? 'Unknown',
      slug: json['slug']?.toString(),
      description: json['description']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'slug': slug,
      'description': description,
    };
  }

  @override
  String toString() => name;
}

