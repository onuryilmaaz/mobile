class CategoryUpdateDto {
  final String id;
  final String name;

  const CategoryUpdateDto({required this.id, required this.name});

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name};
  }
}
