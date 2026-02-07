import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:involved/models/event_response_model.dart';
import 'package:involved/service/api_client.dart';
import 'package:involved/service/api_constants.dart';

class EventController extends GetxController {
  RxList<Event> eventsList = <Event>[].obs;
  RxBool isLoading = false.obs;

  RxInt currentPage = 1.obs;
  RxInt totalPages = 1.obs;

  /// Fetch Events - Only adds parameters to URL if they have values
  Future<void> fetchEvents({
    String? type,        // Changed to nullable
    double? lat,
    String? date,
    double? long,
    int page = 1,
    String? searchTerm,  // Changed to nullable
  }) async {
    isLoading(true);

    if (page == 1) eventsList.assignAll([]);

    try {
      String url = ApiConstants.eventFields;
      List<String> queryParams = [];

      // Only add 'type' if it's not null and not empty
      if (type != null && type.isNotEmpty) {
        queryParams.add("type=$type");
      }

      // Only add 'search' if it's not null and not empty
      if (searchTerm != null && searchTerm.isNotEmpty) {
        queryParams.add("search=$searchTerm");
      }
      if (date != null && date.isNotEmpty) queryParams.add("date=$date");

      if (page > 1) {
        queryParams.add("page=$page");
      }

      if (lat != null && long != null) {
        queryParams.add("lat=$lat");
        queryParams.add("long=$long");
      }

      // Build the final URL
      if (queryParams.isNotEmpty) {
        url += "?${queryParams.join("&")}";
      }

      debugPrint("Request URL: $url");

      final response = await ApiClient.getData(url);

      if (response.statusCode == 200 && response.body != null) {
        final eventResponse = EventResponseModel.fromJson(response.body);
        if (eventResponse.success) {
          if (page == 1) {
            eventsList.assignAll(eventResponse.data.events);
          } else {
            eventsList.addAll(eventResponse.data.events);
          }
          currentPage.value = eventResponse.data.pagination.page;
          totalPages.value = eventResponse.data.pagination.totalPages;
        }
      }
    } catch (e) {
      debugPrint("Exception: $e");
    } finally {
      isLoading(false);
    }
  }

  /// Delete Event Method
  Future<void> deleteEvent(String eventId) async {
    try {
      // Build URL: /event/697484c415b0b39a64203074
      String url = "${ApiConstants.eventFields}/$eventId";

      debugPrint("Deleting Event URL: $url");

      final response = await ApiClient.deleteData(url);

      if (response.statusCode == 200) {
        // 1. Instantly remove from the local observable list
        eventsList.removeWhere((event) => event.id == eventId);

        // 2. Feedback to user
        String message = response.body['message'] ?? "Event deleted successfully";
        Fluttertoast.showToast(
          msg: message,
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );
      } else {
        String errorMsg = response.body['message'] ?? "Failed to delete event";
        Fluttertoast.showToast(
          msg: errorMsg,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
    } catch (e) {
      debugPrint("Exception during delete: $e");
      Fluttertoast.showToast(msg: "An error occurred");
    }
  }

  void loadNextPage(String? type, {double? lat, double? long}) {
    if (currentPage.value < totalPages.value && !isLoading.value) {
      fetchEvents(
        type: type,
        page: currentPage.value + 1,
        lat: lat,
        long: long,
      );
    }
  }
}