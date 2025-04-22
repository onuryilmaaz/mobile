import 'package:mobile/features/poll/model/poll_response.dart';

class AnswerController {
  final Map<int, AnswerDto> _answers = {};

  void setSingleChoice(int questionId, int selectedOptionId) {
    _answers[questionId] = AnswerDto(
      questionId: questionId,
      selectedOptionIds: {selectedOptionId: null},
    );
  }

  void setTextAnswer(int questionId, String text) {
    _answers[questionId] = AnswerDto(questionId: questionId, textAnswer: text);
  }

  void setMultiChoice(int questionId, List<int> selectedIds) {
    final map = {for (var id in selectedIds) id: null};
    _answers[questionId] = AnswerDto(
      questionId: questionId,
      selectedOptionIds: map,
    );
  }

  void setRanking(int questionId, List<int> rankedIds) {
    final map = {
      for (int i = 0; i < rankedIds.length; i++) rankedIds[i]: i + 1,
    };
    _answers[questionId] = AnswerDto(
      questionId: questionId,
      selectedOptionIds: map,
    );
  }

  List<AnswerDto> getAnswers() {
    return _answers.values.toList();
  }
}
