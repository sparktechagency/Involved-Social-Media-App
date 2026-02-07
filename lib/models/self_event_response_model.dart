
class SelfEventResponseModel {
  final bool success;
  final int statusCode;
  final String message;
  final EventData data;

  SelfEventResponseModel({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory SelfEventResponseModel.fromJson(Map<String, dynamic> json) {
    return SelfEventResponseModel(
      success: json['success'] ?? false,
      statusCode: json['statusCode'] ?? 0,
      message: json['message'] ?? '',
      data: EventData.fromJson(json['data'] ?? {}),
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

class EventData {
  final List<EventItem> events;
  final Pagination pagination;

  EventData({
    required this.events,
    required this.pagination,
  });

  factory EventData.fromJson(Map<String, dynamic> json) {
    return EventData(
      events: (json['data'] as List<dynamic>? ?? [])
          .map((e) => EventItem.fromJson(e))
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

class EventItem {
  final String id;
  final String title;
  final String type;
  final String category;
  final Location location;
  final String address;
  final DateTime startDate;
  final DateTime endDate;
  final List<String> atmosphere;
  final String description;
  final String occurrenceType;
  final String image;
  final String status;

  EventItem({
    required this.id,
    required this.title,
    required this.type,
    required this.category,
    required this.location,
    required this.address,
    required this.startDate,
    required this.endDate,
    required this.atmosphere,
    required this.description,
    required this.occurrenceType,
    required this.image,
    required this.status,
  });

  factory EventItem.fromJson(Map<String, dynamic> json) {
    return EventItem(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      type: json['type'] ?? '',
      category: json['category'] ?? '',
      location: Location.fromJson(json['location'] ?? {}),
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
      'location': location.toJson(),
      'address': address,
      'startDate': startDate.toIso8601String(),
      'atmosphere': atmosphere,
      'description': description,
      'occurrenceType': occurrenceType,
      'image': image,
      'status': status,
    };
  }
}

class Location {
  final String type;
  final List<double> coordinates;

  Location({
    required this.type,
    required this.coordinates,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      type: json['type'] ?? '',
      coordinates: (json['coordinates'] as List<dynamic>? ?? [])
          .map((e) => (e as num).toDouble())
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'coordinates': coordinates,
    };
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
      page: json['page'] ?? 1,
      limit: json['limit'] ?? 10,
      total: json['total'] ?? 0,
      totalPages: json['totalPages'] ?? 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'page': page,
      'limit': limit,
      'total': total,
      'totalPages': totalPages,
    };
  }
}
