import 'package:mobile/features/poll/model/option_update.dart';

class QuestionUpdate {
  String text;
  final int type;
  final int orderIndex;
  final bool isRequired;
  final int? maxSelections;
  final List<OptionUpdate> options;

  QuestionUpdate({
    required this.text,
    required this.type,
    required this.orderIndex,
    required this.isRequired,
    required this.maxSelections,
    required this.options,
  });

  factory QuestionUpdate.fromJson(Map<String, dynamic> json) {
    return QuestionUpdate(
      text: json['text'],
      type: json['type'],
      orderIndex: json['orderIndex'],
      isRequired: json['isRequired'],
      maxSelections: json['maxSelections'],
      options: List<OptionUpdate>.from(
        (json['options'] as List).map((x) => OptionUpdate.fromJson(x)),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'type': type,
      'orderIndex': orderIndex,
      'isRequired': isRequired,
      'maxSelections': maxSelections,
      'options': options.map((x) => x.toJson()).toList(),
    };
  }
}
