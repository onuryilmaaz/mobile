class OptionUpdateDto {
  final int id;
  final String text;
  final int orderIndex;

  OptionUpdateDto({
    required this.id,
    required this.text,
    required this.orderIndex,
  });

  Map<String, dynamic> toJson() {
    return {'id': id, 'text': text, 'orderIndex': orderIndex};
  }
}
