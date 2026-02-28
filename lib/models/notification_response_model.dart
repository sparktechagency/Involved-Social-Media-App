import 'favorite_event_response_model.dart';

class NotificationResponseModel {
  final bool success;
  final int statusCode;
  final NotificationData data;

  NotificationResponseModel({
    required this.success,
    required this.statusCode,
    required this.data,
  });

  factory NotificationResponseModel.fromJson(Map<String, dynamic> json) {
    return NotificationResponseModel(
      success: json['success'] ?? false,
      statusCode: json['statusCode'] ?? 0,
      data: NotificationData.fromJson(json['data'] ?? {}),
    );
  }
}

class NotificationData {
  final List<NotificationItem> data;
  final Pagination pagination;

  NotificationData({
    required this.data,
    required this.pagination,
  });

  factory NotificationData.fromJson(Map<String, dynamic> json) {
    return NotificationData(
      data: (json['data'] as List<dynamic>? ?? [])
          .map((e) => NotificationItem.fromJson(e))
          .toList(),
      pagination: Pagination.fromJson(json['pagination'] ?? {}),
    );
  }
}

class NotificationItem {
  final String id;
  final String user;
  final String title;
  final String description;
  final String type;
  final bool isViewed;
  final DateTime createdAt;
  final DateTime updatedAt;

  NotificationItem({
    required this.id,
    required this.user,
    required this.title,
    required this.description,
    required this.type,
    required this.isViewed,
    required this.createdAt,
    required this.updatedAt,
  });

  factory NotificationItem.fromJson(Map<String, dynamic> json) {
    return NotificationItem(
      id: json['_id'] ?? '',
      user: json['user'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      type: json['type'] ?? '',
      isViewed: json['isViewed'] ?? false,
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt'] ?? '') ?? DateTime.now(),
    );
  }
}
