class PollDetail {
  int? id;
  String? title;
  String? description;
  String? createdDate;
  String? expiryDate;
  bool? isActive;
  int? questionCount;
  int? responseCount;
  int? categoryId;
  String? newCategoryName;
  List<Question>? questions;

  PollDetail({
    this.id,
    this.title,
    this.description,
    this.createdDate,
    this.expiryDate,
    this.isActive,
    this.questionCount,
    this.responseCount,
    this.categoryId,
    this.newCategoryName,
    this.questions,
  });

  factory PollDetail.fromJson(Map<String, dynamic> json) {
    return PollDetail(
      id: json['id'] as int?,
      title: json['title'] as String?,
      description: json['description'] as String?,
      createdDate: json['createdDate'] as String?,
      expiryDate: json['expiryDate'] as String?,
      isActive: json['isActive'] as bool?,
      questionCount:
          json['questions'] != null ? (json['questions'] as List).length : null,
      responseCount: json['responseCount'] as int?,
      categoryId: json['categoryId'] as int?,
      newCategoryName: json['newCategoryName'] as String?,
      questions:
          (json['questions'] as List<dynamic>?)
              ?.map((q) => Question.fromJson(q as Map<String, dynamic>))
              .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{
      'id': id,
      'title': title,
      'description': description,
      'createdDate': createdDate,
      'expiryDate': expiryDate,
      'isActive': isActive,
      'responseCount': responseCount,
      'categoryId': categoryId,
      'newCategoryName': newCategoryName,
    };
    if (questions != null) {
      data['questions'] = questions!.map((q) => q.toJson()).toList();
    }
    return data;
  }
}

class Question {
  int id;
  String text;
  int type; // 0: single, 1: text, 2: yes/no, 3: multi, 4: ranking
  int orderIndex;
  bool isRequired;
  int? maxSelections;
  List<Option> options;

  Question({
    required this.id,
    required this.text,
    required this.type,
    required this.orderIndex,
    required this.isRequired,
    this.maxSelections,
    required this.options,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'] as int,
      text: json['text'] as String,
      type: json['type'] as int,
      orderIndex: json['orderIndex'] as int,
      isRequired: json['isRequired'] as bool,
      maxSelections: json['maxSelections'] as int?,
      options:
          (json['options'] as List<dynamic>)
              .map((o) => Option.fromJson(o as Map<String, dynamic>))
              .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'type': type,
      'orderIndex': orderIndex,
      'isRequired': isRequired,
      'maxSelections': maxSelections,
      'options': options.map((o) => o.toJson()).toList(),
    };
  }
}

class Option {
  int id;
  String text;
  int orderIndex;

  Option({required this.id, required this.text, required this.orderIndex});

  factory Option.fromJson(Map<String, dynamic> json) {
    return Option(
      id: json['id'] as int,
      text: json['text'] as String,
      orderIndex: json['orderIndex'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'text': text, 'orderIndex': orderIndex};
  }
}
