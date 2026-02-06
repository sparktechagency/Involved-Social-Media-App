
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:involved/models/self_event_response_model.dart';
import 'package:involved/service/api_client.dart';
import 'package:involved/service/api_constants.dart';

class SelfEventController extends GetxController {
  RxList<EventItem> selfEventsList = <EventItem>[].obs;
  RxBool isLoading = false.obs;

  // Pagination
  RxInt currentPage = 1.obs;
  RxInt totalPages = 1.obs;

  @override
  void onInit() {
    super.onInit();
    fetchSelfEvents();
  }

  /// Fetch events created by the user (Self Events)
  Future<void> fetchSelfEvents({int page = 1}) async {
    // Only show full screen loader on first page
    if (page == 1) isLoading(true);

    try {
      // Build URL with pagination
      String url = "${ApiConstants.selfEvent}?page=$page&limit=10";

      debugPrint("Fetching Self Events: $url");

      final response = await ApiClient.getData(url);

      if (response.statusCode == 200 && response.body != null) {
        final selfEventResponse = SelfEventResponseModel.fromJson(response.body);

        if (selfEventResponse.success) {
          if (page == 1) {
            selfEventsList.assignAll(selfEventResponse.data.events);
          } else {
            selfEventsList.addAll(selfEventResponse.data.events);
          }

          // Update pagination info
          currentPage.value = selfEventResponse.data.pagination.page;
          totalPages.value = selfEventResponse.data.pagination.totalPages;
        }
      } else {
        debugPrint("Error fetching self events: ${response.statusText}");
      }
    } catch (e) {
      debugPrint("Exception in fetchSelfEvents: $e");
    } finally {
      isLoading(false);
    }
  }

  /// Load more logic for infinite scrolling
  void loadMore() {
    if (currentPage.value < totalPages.value && !isLoading.value) {
      fetchSelfEvents(page: currentPage.value + 1);
    }
  }

  /// Refresh the list
  Future<void> refreshEvents() async {
    currentPage.value = 1;
    await fetchSelfEvents(page: 1);
  }
}