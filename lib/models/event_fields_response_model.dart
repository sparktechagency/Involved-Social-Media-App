
class EventFieldsResponseModel {
  final bool success;
  final int statusCode;
  final String message;
  final List<String> data;

  EventFieldsResponseModel({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory EventFieldsResponseModel.fromJson(Map<String, dynamic> json) {
    return EventFieldsResponseModel(
      success: json['success'] ?? false,
      statusCode: json['statusCode'] ?? 0,
      message: json['message'] ?? '',
      data: (json['data'] as List<dynamic>? ?? []).map((e) => e.toString()).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'statusCode': statusCode,
      'message': message,
      'data': data,
    };
  }
}
