
class CollectionNameResponseModel {
  final bool success;
  final int statusCode;
  final String message;
  final CollectionData data;

  CollectionNameResponseModel({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory CollectionNameResponseModel.fromJson(Map<String, dynamic> json) {
    return CollectionNameResponseModel(
      success: json['success'] ?? false,
      statusCode: json['statusCode'] ?? 0,
      message: json['message'] ?? '',
      data: CollectionData.fromJson(json['data'] ?? {}),
    );
  }
}

class CollectionData {
  final List<String> collection;

  CollectionData({required this.collection});

  factory CollectionData.fromJson(Map<String, dynamic> json) {
    return CollectionData(
      collection: (json['collection'] as List<dynamic>? ?? [])
          .map((e) => e.toString())
          .toList(),
    );
  }
}
