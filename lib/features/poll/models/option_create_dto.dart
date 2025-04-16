class OptionCreateDto {
  final String text;
  final int orderIndex;

  OptionCreateDto({required this.text, required this.orderIndex});

  Map<String, dynamic> toJson() {
    return {'text': text, 'orderIndex': orderIndex};
  }
}
