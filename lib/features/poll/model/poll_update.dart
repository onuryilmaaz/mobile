// ignore_for_file: unnecessary_new, unnecessary_this, prefer_collection_literals

class PollUpdate {
  int? id;
  String? title;
  String? description;
  String? createdDate;
  String? expiryDate;
  bool? isActive;
  List<QuestionUpdate>? questions;
  int? categoryId;
  String? newCategoryName;

  PollUpdate({
    this.id,
    this.title,
    this.description,
    this.createdDate,
    this.expiryDate,
    this.isActive,
    this.questions,
    this.categoryId,
    this.newCategoryName,
  });

  PollUpdate.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    createdDate = json['createdDate'];
    expiryDate = json['expiryDate'];
    isActive = json['isActive'];
    if (json['questions'] != null) {
      questions = <QuestionUpdate>[];
      json['questions'].forEach((v) {
        questions!.add(new QuestionUpdate.fromJson(v));
      });
    }
    categoryId = json['categoryId'];
    newCategoryName = json['newCategoryName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['description'] = this.description;
    data['createdDate'] = this.createdDate;
    data['expiryDate'] = this.expiryDate;
    data['isActive'] = this.isActive;
    if (this.questions != null) {
      data['questions'] = this.questions!.map((v) => v.toJson()).toList();
    }
    data['categoryId'] = this.categoryId;
    data['newCategoryName'] = this.newCategoryName;
    return data;
  }
}

class QuestionUpdate {
  int? id;
  String? text;
  int? type;
  int? orderIndex;
  bool? isRequired;
  int? maxSelections;
  List<OptionUpdate>? options;

  QuestionUpdate({
    this.id,
    this.text,
    this.type,
    this.orderIndex,
    this.isRequired,
    this.maxSelections,
    this.options,
  });

  QuestionUpdate.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    text = json['text'];
    type = json['type'];
    orderIndex = json['orderIndex'];
    isRequired = json['isRequired'];
    maxSelections = json['maxSelections'];
    if (json['options'] != null) {
      options = <OptionUpdate>[];
      json['options'].forEach((v) {
        options!.add(new OptionUpdate.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['text'] = this.text;
    data['type'] = this.type;
    data['orderIndex'] = this.orderIndex;
    data['isRequired'] = this.isRequired;
    data['maxSelections'] = this.maxSelections;
    if (this.options != null) {
      data['options'] = this.options!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class OptionUpdate {
  int? id;
  String? text;
  int? orderIndex;

  OptionUpdate({this.id, this.text, this.orderIndex});

  OptionUpdate.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    text = json['text'];
    orderIndex = json['orderIndex'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['text'] = this.text;
    data['orderIndex'] = this.orderIndex;
    return data;
  }
}
