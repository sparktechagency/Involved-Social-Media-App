
class CollectionGroupedResponseModel {
  final bool success;
  final int statusCode;
  final String message;
  final EventCollectionsData data;

  CollectionGroupedResponseModel({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory CollectionGroupedResponseModel.fromJson(Map<String, dynamic> json) {
    return CollectionGroupedResponseModel(
      success: json['success'] ?? false,
      statusCode: json['statusCode'] ?? 0,
      message: json['message'] ?? '',
      data: EventCollectionsData.fromJson(json['data'] ?? {}),
    );
  }
}

class EventCollectionsData {
  final Collections collections;

  EventCollectionsData({required this.collections});

  factory EventCollectionsData.fromJson(Map<String, dynamic> json) {
    return EventCollectionsData(
      collections: Collections.fromJson(json['collections'] ?? {}),
    );
  }
}
class Collections {
  final List<CollectionItem> data;
  final Pagination pagination;

  Collections({
    required this.data,
    required this.pagination,
  });

  factory Collections.fromJson(Map<String, dynamic> json) {
    return Collections(
      data: (json['data'] as List<dynamic>? ?? [])
          .map((e) => CollectionItem.fromJson(e))
          .toList(),
      pagination: Pagination.fromJson(json['pagination'] ?? {}),
    );
  }
}
class CollectionItem {
  final EventRef event;
  final String collectionName;

  CollectionItem({
    required this.event,
    required this.collectionName,
  });

  factory CollectionItem.fromJson(Map<String, dynamic> json) {
    return CollectionItem(
      event: EventRef.fromJson(json['events'] ?? {}),
      collectionName: json['collectionName'] ?? '',
    );
  }
}
class EventRef {
  final String id;
  final String image;

  EventRef({
    required this.id,
    required this.image,
  });

  factory EventRef.fromJson(Map<String, dynamic> json) {
    return EventRef(
      id: json['_id'] ?? '',
      image: json['image'] ?? '',
    );
  }
}
class Pagination {
  final int total;
  final int page;
  final int limit;
  final int totalPages;

  Pagination({
    required this.total,
    required this.page,
    required this.limit,
    required this.totalPages,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      total: json['total'] ?? 0,
      page: json['page'] ?? 0,
      limit: json['limit'] ?? 0,
      totalPages: json['totalPages'] ?? 0,
    );
  }
}
