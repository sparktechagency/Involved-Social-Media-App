import 'package:flutter/material.dart';
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