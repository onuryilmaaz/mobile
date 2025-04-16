import 'answer_dto.dart';

class PollResponseDto {
  final List<AnswerDto> answers;

  PollResponseDto({required this.answers});

  Map<String, dynamic> toJson() {
    return {'answers': answers.map((a) => a.toJson()).toList()};
  }
}
