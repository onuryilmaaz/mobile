import 'package:mobile/features/poll/models/question_detail_dto.dart';

import 'option_create_dto.dart';

class QuestionCreateDto {
  final String text;
  final QuestionType type;
  final int orderIndex;
  final bool isRequired;
  final int? maxSelections;
  final List<OptionCreateDto>? options;

  QuestionCreateDto({
    required this.text,
    required this.type,
    required this.orderIndex,
    required this.isRequired,
    this.maxSelections,
    this.options,
  });

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'type': type.toString().split('.').last,
      'orderIndex': orderIndex,
      'isRequired': isRequired,
      'maxSelections': maxSelections,
      'options': options?.map((o) => o.toJson()).toList(),
    };
  }
}
