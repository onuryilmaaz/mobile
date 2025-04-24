class PollCreate {
  final String title;
  final String description;
  final int categoryId;
  final String categoryName;
  final String? createdDate;
  final String? expiryDate;
  final bool isActive;
  final List<QuestionCreate> questions;

  PollCreate({
    required this.title,
    required this.description,
    required this.categoryId,
    required this.categoryName,
    required this.createdDate,
    required this.expiryDate,
    required this.isActive,
    required this.questions,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'categoryId': categoryId,
      'categoryName': categoryName,
      'createdDate': createdDate,
      'expiryDate': expiryDate,
      'isActive': isActive,
      'questions': questions.map((q) => q.toJson()).toList(),
    };
  }
}

class QuestionCreate {
  final String text;
  final int type;
  final int orderIndex;
  final bool isRequired;
  final int maxSelections;
  final List<OptionCreate> options;

  QuestionCreate({
    required this.text,
    required this.type,
    required this.orderIndex,
    required this.isRequired,
    required this.maxSelections,
    required this.options,
  });

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'type': type,
      'orderIndex': orderIndex,
      'isRequired': isRequired,
      'maxSelections': maxSelections,
      'options': options.map((o) => o.toJson()).toList(),
    };
  }
}

class OptionCreate {
  final String text;
  final int orderIndex;

  OptionCreate({required this.text, required this.orderIndex});

  Map<String, dynamic> toJson() {
    return {'text': text, 'orderIndex': orderIndex};
  }
}
