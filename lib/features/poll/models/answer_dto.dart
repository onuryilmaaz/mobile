class AnswerDto {
  final int questionId;
  final String? textAnswer;
  final Map<int, int?> selectedOptionIds; // OptionId -> RankOrder

  AnswerDto({
    required this.questionId,
    this.textAnswer,
    required this.selectedOptionIds,
  });

  Map<String, dynamic> toJson() {
    return {
      'questionId': questionId,
      'textAnswer': textAnswer,
      'selectedOptionIds': selectedOptionIds,
    };
  }
}
