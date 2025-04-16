class PollListDto {
  final int id;
  final String title;
  final String description;
  final DateTime createdDate;
  final DateTime? expiryDate;
  final bool isActive;
  final int? categoryId;
  final String? newCategoryName;
  final int questionCount;
  final int responseCount;

  PollListDto({
    required this.id,
    required this.title,
    required this.description,
    required this.createdDate,
    this.expiryDate,
    required this.isActive,
    this.categoryId,
    this.newCategoryName,
    required this.questionCount,
    required this.responseCount,
  });

  factory PollListDto.fromJson(Map<String, dynamic> json) {
    return PollListDto(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      createdDate: DateTime.parse(json['createdDate']),
      expiryDate:
          json['expiryDate'] != null
              ? DateTime.parse(json['expiryDate'])
              : null,
      isActive: json['isActive'],
      categoryId: json['categoryId'],
      newCategoryName: json['newCategoryName'],
      questionCount: json['questionCount'],
      responseCount: json['responseCount'],
    );
  }
}
