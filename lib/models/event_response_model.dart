class EventResponseModel {
  final bool success;
  final int statusCode;
  final String message;
  final EventsData data;

  EventResponseModel({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory EventResponseModel.fromJson(Map<String, dynamic> json) {
    return EventResponseModel(
      success: json['success'] ?? false,
      statusCode: json['statusCode'] ?? 0,
      message: json['message'] ?? '',
      data: EventsData.fromJson(json['data'] ?? {}),
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

class EventsData {
  final List<Event> events;
  final Pagination pagination;

  EventsData({
    required this.events,
    required this.pagination,
  });

  factory EventsData.fromJson(Map<String, dynamic> json) {
    return EventsData(
      events: (json['data'] as List<dynamic>? ?? [])
          .map((e) => Event.fromJson(e))
          .toList(),
      pagination: Pagination.fromJson(json['pagination'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': events.map((e) => e.toJson()).toList(),
      'pagination': pagination.toJson(),
    };
  }
}

class Event {
  final String id;
  final String title;
  final String type;
  final String category;
  final String address;
  final DateTime startDate;
  final DateTime endDate;
  final List<String> atmosphere;
  final String description;
  final String occurrenceType;
  final String image;
  final String status;

  Event({
    required this.id,
    required this.title,
    required this.type,
    required this.category,
    required this.address,
    required this.startDate,
    required this.endDate,
    required this.atmosphere,
    required this.description,
    required this.occurrenceType,
    required this.image,
    required this.status,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      type: json['type'] ?? '',
      category: json['category'] ?? '',
      address: json['address'] ?? '',
      startDate: DateTime.parse(json['startDate'] ?? DateTime.now().toIso8601String()),
      endDate: DateTime.parse(json['endDate'] ?? DateTime.now().toIso8601String()),
      atmosphere: (json['atmosphere'] as List<dynamic>? ?? []).map((e) => e.toString()).toList(),
      description: json['description'] ?? '',
      occurrenceType: json['occurrenceType'] ?? '',
      image: json['image'] ?? '',
      status: json['status'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title,
      'type': type,
      'category': category,
      'address': address,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'atmosphere': atmosphere,
      'description': description,
      'occurrenceType': occurrenceType,
      'image': image,
      'status': status,
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
