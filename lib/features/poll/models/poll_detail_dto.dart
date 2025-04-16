import 'question_detail_dto.dart';

class PollDetailDto {
  final int id;
  final String title;
  final String? description;
  final DateTime createdDate;
  final DateTime? expiryDate;
  final bool isActive;
  final int? categoryId;
  final String? newCategoryName;
  final List<QuestionDetailDto> questions;

  PollDetailDto({
    required this.id,
    required this.title,
    this.description,
    required this.createdDate,
    this.expiryDate,
    required this.isActive,
    this.categoryId,
    this.newCategoryName,
    required this.questions,
  });

  factory PollDetailDto.fromJson(Map<String, dynamic> json) {
    return PollDetailDto(
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
      questions:
          (json['questions'] as List)
              .map((q) => QuestionDetailDto.fromJson(q))
              .toList(),
    );
  }
}
