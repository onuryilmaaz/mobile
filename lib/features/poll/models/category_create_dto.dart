class CategoryCreateDto {
  final String name;

  const CategoryCreateDto({required this.name});

  Map<String, dynamic> toJson() {
    return {'name': name};
  }
}
