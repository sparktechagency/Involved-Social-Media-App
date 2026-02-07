class CollectionNameFilterResponseModel {
  final bool success;
  final int statusCode;
  final String message;
  final EventCollectionsData data;

  CollectionNameFilterResponseModel({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory CollectionNameFilterResponseModel.fromJson(Map<String, dynamic> json) {
    return CollectionNameFilterResponseModel(
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
  final List<FilterCollectionItem> data;
  final Pagination pagination;

  Collections({
    required this.data,
    required this.pagination,
  });

  factory Collections.fromJson(Map<String, dynamic> json) {
    return Collections(
      data: (json['data'] as List<dynamic>? ?? [])
          .map((e) => FilterCollectionItem.fromJson(e))
          .toList(),
      pagination: Pagination.fromJson(json['pagination'] ?? {}),
    );
  }
}
class FilterCollectionItem {
  final String id;
  final Event event;
  final String collectionName;
  final String status;

  FilterCollectionItem({
    required this.id,
    required this.event,
    required this.collectionName,
    required this.status,
  });

  factory FilterCollectionItem.fromJson(Map<String, dynamic> json) {
    return FilterCollectionItem(
      id: json['_id'] ?? '',
      event: Event.fromJson(json['event'] ?? {}),
      collectionName: json['collectionName'] ?? '',
      status: json['status'] ?? '',
    );
  }
}
class Event {
  final String id;
  final String title;
  final String category;
  final String address;
  final String image;
  final String status;

  Event({
    required this.id,
    required this.title,
    required this.category,
    required this.address,
    required this.image,
    required this.status,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      category: json['category'] ?? '',
      address: json['address'] ?? '',
      image: json['image'] ?? '',
      status: json['status'] ?? '',
    );
  }
}
class Pagination {
  final int page;
  final int limit;
  final int total;
  final int totalPages;

  Pagination({
    required this.page,
    required this.limit,
    required this.total,
    required this.totalPages,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      page: json['page'] ?? 0,
      limit: json['limit'] ?? 0,
      total: json['total'] ?? 0,
      totalPages: json['totalPages'] ?? 0,
    );
  }
}
