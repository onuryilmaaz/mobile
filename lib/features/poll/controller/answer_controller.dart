import 'package:mobile/features/poll/model/poll_response.dart';

class AnswerController {
  final Map<int, dynamic> _answers = {}; // questionId -> answer

  void selectOption(int questionId, int optionId, bool isSelected) {
    if (!_answers.containsKey(questionId)) {
      _answers[questionId] = <int>{};
    }
    final selectedOptions = _answers[questionId] as Set<int>;
    if (isSelected) {
      selectedOptions.add(optionId);
    } else {
      selectedOptions.remove(optionId);
    }
  }

  void setTextAnswer(int questionId, String text) {
    _answers[questionId] = text;
  }

  void setPointAnswer(int questionId, int optionId, int point) {
    if (!_answers.containsKey(questionId)) {
      _answers[questionId] = <int, int>{};
    }
    final pointsMap = _answers[questionId] as Map<int, int>;
    pointsMap[optionId] = point;
  }

  void setAnswer(int questionId, dynamic answer) {
    _answers[questionId] = answer;
  }

  List<AnswerDto> getAnswers() {
    List<AnswerDto> result = [];

    _answers.forEach((questionId, answer) {
      if (answer is String) {
        result.add(
          AnswerDto(
            questionId: questionId,
            selectedOptionIds: {},
            textAnswer: answer,
          ),
        );
      } else if (answer is Set<int>) {
        Map<int, int?> selectedOptions = {
          for (var optionId in answer) optionId: null,
        };
        result.add(
          AnswerDto(questionId: questionId, selectedOptionIds: selectedOptions),
        );
      } else if (answer is Map<int, int>) {
        result.add(
          AnswerDto(
            questionId: questionId,
            selectedOptionIds: Map<int, int?>.from(answer),
          ),
        );
      }
    });

    return result;
  }

  void clear() {
    _answers.clear();
  }
}
