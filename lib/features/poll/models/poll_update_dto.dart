import 'package:mobile/features/poll/models/question_create_dto.dart';

class PollUpdateDto {
  final String title;
  final String? description;
  final DateTime createdDate;
  final DateTime? expiryDate;
  final bool isActive;
  final List<QuestionCreateDto> questions;

  const PollUpdateDto({
    required this.title,
    required this.description,
    required this.createdDate,
    required this.expiryDate,
    required this.isActive,
    required this.questions,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'createdDate': createdDate.toIso8601String(),
      'expiryDate': expiryDate?.toIso8601String(),
      'isActive': isActive,
      'questions': questions.map((q) => q.toJson()).toList(),
    };
  }
}
