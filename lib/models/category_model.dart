class CategoryModel {
  final String id;
  final String name;
  final String image;
  final int createdAt;

  CategoryModel({
    required this.id,
    required this.name,
    required this.image,
    required this.createdAt,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'],
      name: json['name'],
      image: json['image'],
      createdAt: json['createdAt'] is int
          ? json['createdAt']
          : int.tryParse(json['createdAt'].toString()) ?? 0,
    );
  }
}
