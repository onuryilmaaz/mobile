// ignore_for_file: unnecessary_new, prefer_collection_literals, unnecessary_this

class PollsResponse {
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

  PollsResponse({
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
  });

  PollsResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    createdDate = json['createdDate'];
    expiryDate = json['expiryDate'];
    isActive = json['isActive'];
    questionCount = json['questionCount'];
    responseCount = json['responseCount'];
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
    data['questionCount'] = this.questionCount;
    data['responseCount'] = this.responseCount;
    data['categoryId'] = this.categoryId;
    data['newCategoryName'] = this.newCategoryName;
    return data;
  }
}
