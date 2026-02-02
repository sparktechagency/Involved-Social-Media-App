class SettingContentModel {
  bool? success;
  int? statusCode;
  String? message;
  Data? data;

  SettingContentModel({this.success, this.statusCode, this.message, this.data});

  SettingContentModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    statusCode = json['statusCode'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['statusCode'] = statusCode;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? title;
  String? content;
  String? updatedAt;

  Data({this.title, this.content, this.updatedAt});

  Data.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    content = json['content'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['content'] = content;
    data['updatedAt'] = updatedAt;
    return data;
  }
}