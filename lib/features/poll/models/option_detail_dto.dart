class OptionDetailDto {
  final int id;
  final String text;
  final int orderIndex;

  OptionDetailDto({
    required this.id,
    required this.text,
    required this.orderIndex,
  });

  factory OptionDetailDto.fromJson(Map<String, dynamic> json) {
    return OptionDetailDto(
      id: json['id'],
      text: json['text'],
      orderIndex: json['orderIndex'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'text': text, 'orderIndex': orderIndex};
  }
}
