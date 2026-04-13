class FunkoModel {
  final String id;
  final String name;
  final String categoryName;
  final int number;
  final String rarity;
  final bool isGlowInTheDark;
  final String image;
  final int createdAt;

  FunkoModel({
    required this.id,
    required this.name,
    required this.categoryName,
    required this.number,
    required this.rarity,
    required this.isGlowInTheDark,
    required this.image,
    required this.createdAt,
  });

  factory FunkoModel.fromJson(Map<String, dynamic> json) {
    return FunkoModel(
      id: json['id'],
      name: json['name'],
      categoryName: json['categoryName'],
      number: json['number'] is int
          ? json['number']
          : int.tryParse(json['number'].toString()) ?? 0,
      rarity: json['rarity'] ?? '',
      isGlowInTheDark: json['isGlowInTheDark'] ?? false,
      image: json['image'] ?? '',
      createdAt: json['createdAt'] is int
          ? json['createdAt']
          : int.tryParse(json['createdAt'].toString()) ?? 0,
    );
  }
}
