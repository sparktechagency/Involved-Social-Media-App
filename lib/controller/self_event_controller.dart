
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
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


  Future<void> deleteEvent(String eventId) async {
    try {
      // Build URL: /event/697484c415b0b39a64203074
      String url = "${ApiConstants.eventFields}/$eventId";

      debugPrint("Deleting Event URL: $url");

      final response = await ApiClient.deleteData(url);

      if (response.statusCode == 200) {
        // 1. Instantly remove from the local observable list
        selfEventsList.removeWhere((event) => event.id == eventId);

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