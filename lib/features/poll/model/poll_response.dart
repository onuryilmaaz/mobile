// class AnswerDto {
//   final int questionId;
//   final Map<int, int?> selectedOptionIds;
//   final String? textAnswer;

//   AnswerDto({
//     required this.questionId,
//     Map<int, int?>? selectedOptionIds,
//     this.textAnswer,
//   }) : selectedOptionIds = selectedOptionIds ?? {};

//   Map<String, dynamic> toJson() {
//     final m = {
//       'questionId': questionId,
//       'selectedOptionIds': selectedOptionIds.map(
//         (k, v) => MapEntry(k.toString(), v),
//       ),
//     };
//     if (textAnswer != null) m['textAnswer'] = textAnswer.toString();
//     return m;
//   }

//   factory AnswerDto.fromJson(Map<String, dynamic> json) {
//     return AnswerDto(
//       questionId: json['questionId'],
//       selectedOptionIds: (json['selectedOptionIds'] as Map<String, dynamic>)
//           .map((key, value) => MapEntry(int.parse(key), value as int?)),
//       textAnswer: json['textAnswer'],
//     );
//   }
// }

class AnswerDto {
  final int questionId;
  final Map<int, int?> selectedOptionIds;
  final String? textAnswer;

  AnswerDto({
    required this.questionId,
    Map<int, int?>? selectedOptionIds,
    this.textAnswer,
  }) : selectedOptionIds = selectedOptionIds ?? {};

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {'questionId': questionId};

    if (selectedOptionIds.isNotEmpty) {
      data['selectedOptionIds'] = selectedOptionIds.map(
        (k, v) => MapEntry(k.toString(), v),
      );
    }

    if (textAnswer != null) {
      data['textAnswer'] = textAnswer;
    }

    return data;
  }
}

class PollResponseDto {
  final List<AnswerDto> answers;
  PollResponseDto({required this.answers});

  Map<String, dynamic> toJson() => {
    'answers': answers.map((a) => a.toJson()).toList(),
  };
}
