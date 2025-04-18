import 'package:mobile/features/poll/models/option_create_dto.dart';
import 'package:mobile/features/poll/models/question_detail_dto.dart';

class QuestionUpdateDto {
  final int id;
  final String text;
  final QuestionType type;
  final int orderIndex;
  final bool isRequired;
  final int? maxSelections;
  final List<OptionCreateDto>? options;

  const QuestionUpdateDto({
    required this.id,
    required this.text,
    required this.type,
    required this.orderIndex,
    required this.isRequired,
    required this.maxSelections,
    required this.options,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'type': type.toString().split('.').last,
      'orderIndex': orderIndex,
      'isRequired': isRequired,
      'maxSelections': maxSelections,
      'options': options?.map((o) => o.toJson()).toList(),
    };
  }
}
