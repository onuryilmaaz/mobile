// ignore_for_file: unnecessary_new, prefer_collection_literals, unnecessary_this

class PollDetail {
  int? id;
  String? title;
  String? description;
  String? createdDate;
  String? expiryDate;
  bool? isActive;
  List<Questions>? questions;
  int? categoryId;
  String? newCategoryName;

  PollDetail({
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

  PollDetail.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    createdDate = json['createdDate'];
    expiryDate = json['expiryDate'];
    isActive = json['isActive'];
    if (json['questions'] != null) {
      questions = <Questions>[];
      json['questions'].forEach((v) {
        questions!.add(new Questions.fromJson(v));
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

class Questions {
  int? id;
  String? text;
  int? type;
  int? orderIndex;
  bool? isRequired;
  int? maxSelections;
  List<Option>? options;

  Questions({
    this.id,
    this.text,
    this.type,
    this.orderIndex,
    this.isRequired,
    this.maxSelections,
    this.options,
  });

  Questions.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    text = json['text'];
    type = json['type'];
    orderIndex = json['orderIndex'];
    isRequired = json['isRequired'];
    maxSelections = json['maxSelections'];
    if (json['options'] != null) {
      options = <Option>[];
      json['options'].forEach((v) {
        options!.add(new Option.fromJson(v));
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

class Option {
  int? id;
  String? text;
  int? orderIndex;

  Option({this.id, this.text, this.orderIndex});

  Option.fromJson(Map<String, dynamic> json) {
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
