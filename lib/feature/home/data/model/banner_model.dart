class BannersModel {
  int? id;
  String? title;
  String? imageUrl;
  String? link;
  bool? isActive;
  String? createdAt;

  BannersModel({
    this.id,
    this.title,
    this.imageUrl,
    this.link,
    this.isActive,
    this.createdAt,
  });

  BannersModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    imageUrl = json['imageUrl'];
    link = json['link'];
    isActive = json['isActive'];
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['imageUrl'] = imageUrl;
    data['link'] = link;
    data['isActive'] = isActive;
    data['createdAt'] = createdAt;
    return data;
  }
}
