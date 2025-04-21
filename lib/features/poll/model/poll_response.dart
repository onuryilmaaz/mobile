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
    final m = {
      'questionId': questionId,
      'selectedOptionIds': selectedOptionIds.map(
        (k, v) => MapEntry(k.toString(), v),
      ),
    };
    if (textAnswer != null) m['textAnswer'] = textAnswer.toString();
    return m;
  }
}

class PollResponseDto {
  final List<AnswerDto> answers;
  PollResponseDto({required this.answers});

  Map<String, dynamic> toJson() => {
    'answers': answers.map((a) => a.toJson()).toList(),
  };
}
