class CategoryListDto {
  final String id;
  final String name;

  const CategoryListDto({required this.id, required this.name});

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name};
  }
}
