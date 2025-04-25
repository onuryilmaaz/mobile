class OptionUpdate {
  final String text;
  final int orderIndex;

  OptionUpdate({required this.text, required this.orderIndex});

  factory OptionUpdate.fromJson(Map<String, dynamic> json) {
    return OptionUpdate(text: json['text'], orderIndex: json['orderIndex']);
  }

  Map<String, dynamic> toJson() {
    return {'text': text, 'orderIndex': orderIndex};
  }
}
