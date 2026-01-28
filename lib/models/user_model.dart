class UserModel {
  bool? success;
  int? statusCode;
  String? message;
  UserData? data;

  UserModel({this.success, this.statusCode, this.message, this.data});

  UserModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    statusCode = json['statusCode'];
    message = json['message'];
    data = json['data'] != null ? UserData.fromJson(json['data']) : null;
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

class UserData {
  String? id;
  String? name;
  String? email;
  bool? isEmailVerified;
  bool? isPhoneVerified;
  String? image;
  String? role;
  String? address;
  List<String>? interests;
  Location? location;
  String? createdAt;
  String? updatedAt;
  int? v;
  Subscription? subscription;
  String? status;
  String? purchaseDate;
  String? subscriptionExpire;

  UserData({
    this.id,
    this.name,
    this.email,
    this.isEmailVerified,
    this.isPhoneVerified,
    this.image,
    this.role,
    this.address,
    this.interests,
    this.location,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.subscription,
    this.status,
    this.purchaseDate,
    this.subscriptionExpire,
  });

  UserData.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    name = json['name'];
    email = json['email'];
    isEmailVerified = json['isEmailVerified'];
    isPhoneVerified = json['isPhoneVerified'];
    image = json['image'];
    role = json['role'];
    address = json['address'];
    interests = json['interests']?.cast<String>();
    location = json['location'] != null ? Location.fromJson(json['location']) : null;
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    v = json['__v'];
    subscription = json['subscription'] != null ? Subscription.fromJson(json['subscription']) : null;
    status = json['status'];
    purchaseDate = json['purchaseDate'];
    subscriptionExpire = json['subscriptionExpire'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['isEmailVerified'] = isEmailVerified;
    data['isPhoneVerified'] = isPhoneVerified;
    data['image'] = image;
    data['role'] = role;
    data['address'] = address;
    data['interests'] = interests;
    if (location != null) {
      data['location'] = location!.toJson();
    }
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = v;
    if (subscription != null) {
      data['subscription'] = subscription!.toJson();
    }
    data['status'] = status;
    data['purchaseDate'] = purchaseDate;
    data['subscriptionExpire'] = subscriptionExpire;
    return data;
  }
}

class Location {
  double? lat;
  double? long;

  Location({this.lat, this.long});

  Location.fromJson(Map<String, dynamic> json) {
    lat = json['lat']?.toDouble();
    long = json['long']?.toDouble();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['lat'] = lat;
    data['long'] = long;
    return data;
  }
}

class Subscription {
  String? id;
  String? name;
  String? details;

  Subscription({this.id, this.name, this.details});

  Subscription.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    name = json['name'];
    details = json['details'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = id;
    data['name'] = name;
    data['details'] = details;
    return data;
  }
}