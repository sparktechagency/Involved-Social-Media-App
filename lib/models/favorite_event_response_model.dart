import 'event_response_model.dart'; // Import the existing event model

class FavoriteEventResponseModel {
  final bool success;
  final int statusCode;
  final String message;
  final FavoriteEventsData data;

  FavoriteEventResponseModel({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory FavoriteEventResponseModel.fromJson(Map<String, dynamic> json) {
    return FavoriteEventResponseModel(
      success: json['success'] ?? false,
      statusCode: json['statusCode'] ?? 0,
      message: json['message'] ?? '',
      data: FavoriteEventsData.fromJson(json['data'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'statusCode': statusCode,
      'message': message,
      'data': data.toJson(),
    };
  }
}

class FavoriteEventsData {
  final List<FavoriteEventItem> data;
  final Pagination pagination;

  FavoriteEventsData({
    required this.data,
    required this.pagination,
  });

  factory FavoriteEventsData.fromJson(Map<String, dynamic> json) {
    return FavoriteEventsData(
      data: (json['data'] as List<dynamic>? ?? [])
          .map((e) => FavoriteEventItem.fromJson(e))
          .toList(),
      pagination: Pagination.fromJson(json['pagination'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data.map((e) => e.toJson()).toList(),
      'pagination': pagination.toJson(),
    };
  }
}

class FavoriteEventItem {
  final String id;
  final Event event; // Using the imported Event model

  FavoriteEventItem({
    required this.id,
    required this.event,
  });

  factory FavoriteEventItem.fromJson(Map<String, dynamic> json) {
    return FavoriteEventItem(
      id: json['_id'] ?? '',
      event: Event.fromJson(json['event'] ?? {}), // Using the imported Event model
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'event': event.toJson(),
    };
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
      page: json['page'] ?? 1,
      limit: json['limit'] ?? 10,
      totalPages: json['totalPages'] ?? 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total': total,
      'page': page,
      'limit': limit,
      'totalPages': totalPages,
    };
  }
}