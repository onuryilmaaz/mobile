import 'question_create_dto.dart';

class PollCreateDto {
  final String title;
  final String? description;
  final DateTime createdDate;
  final DateTime? expiryDate;
  final bool isActive;
  final int? categoryId;
  final List<QuestionCreateDto> questions;

  PollCreateDto({
    required this.title,
    this.description,
    required this.createdDate,
    this.expiryDate,
    required this.isActive,
    this.categoryId,
    required this.questions,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'createdDate': createdDate.toIso8601String(),
      'expiryDate': expiryDate?.toIso8601String(),
      'isActive': isActive,
      'categoryId': categoryId,
      'questions': questions.map((q) => q.toJson()).toList(),
    };
  }
}
