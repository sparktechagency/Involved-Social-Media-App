import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:involved/models/event_response_model.dart';
import 'package:involved/service/api_client.dart';
import 'package:involved/service/api_constants.dart';

class EventController extends GetxController {
  RxList<Event> eventsList = <Event>[].obs;
  RxBool isLoading = false.obs;

  // Pagination
  RxInt currentPage = 1.obs;
  RxInt totalPages = 1.obs;


  @override
  void onInit() {
    super.onInit();
    // This is safe and runs automatically when Get.put is called
    fetchEvents(type: "");
  }


  /// Fetch Events with required Type and optional Location
  Future<void> fetchEvents({
    String type = "", // Default to empty
    double? lat,
    double? long,
    int page = 1,
    String searchTerm = "", // Added for search functionality
  }) async {
    isLoading(true);
    try {
      // Base URL
      String url = ApiConstants.eventFields;
      List<String> queryParams = [];

      // Add params only if they exist/are needed
      if (type.isNotEmpty) queryParams.add("type=$type");
      if (page > 1) queryParams.add("page=$page");
      if (searchTerm.isNotEmpty) queryParams.add("search=$searchTerm");
      if (lat != null && long != null) {
        queryParams.add("lat=$lat");
        queryParams.add("long=$long");
      }

      // Join with '?' if params exist
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


  /// Load more logic
  void loadNextPage(String type, {double? lat, double? long}) {
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