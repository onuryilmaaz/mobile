import 'option_detail_dto.dart';

// Question türlerini enum olarak tanımlayalım
enum QuestionType {
  Text,
  SingleChoice,
  MultipleChoice,
  YesNo,
  Ranking,
  MultiSelect,
}

// String'den enum'a dönüşüm için extension
extension QuestionTypeExtension on String {
  QuestionType toQuestionType() {
    return QuestionType.values.firstWhere(
      (e) => e.toString() == 'QuestionType.$this',
      orElse: () => QuestionType.Text,
    );
  }
}

class QuestionDetailDto {
  final int id;
  final String text;
  final QuestionType type;
  final int orderIndex;
  final bool isRequired;
  final int? maxSelections;
  final List<OptionDetailDto> options;

  QuestionDetailDto({
    required this.id,
    required this.text,
    required this.type,
    required this.orderIndex,
    required this.isRequired,
    this.maxSelections,
    required this.options,
  });

  factory QuestionDetailDto.fromJson(Map<String, dynamic> json) {
    return QuestionDetailDto(
      id: json['id'],
      text: json['text'],
      type: json['type'].toString().toQuestionType(),
      orderIndex: json['orderIndex'],
      isRequired: json['isRequired'],
      maxSelections: json['maxSelections'],
      options:
          (json['options'] as List)
              .map((o) => OptionDetailDto.fromJson(o))
              .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'type': type.toString().split('.').last,
      'orderIndex': orderIndex,
      'isRequired': isRequired,
      'maxSelections': maxSelections,
      'options': options.map((o) => o.toJson()).toList(),
    };
  }
}
