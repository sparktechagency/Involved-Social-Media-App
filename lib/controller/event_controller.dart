import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:involved/models/event_response_model.dart';
import 'package:involved/service/api_client.dart';
import 'package:involved/service/api_constants.dart';
import 'package:http/http.dart' as http;

class EventController extends GetxController {
  RxList<Event> eventsList = <Event>[].obs;

  // This is the list you will actually use in your GridView.builder
  RxList<Event> filteredEventsList = <Event>[].obs;
  RxString searchQuery = "".obs;
  RxBool isLoading = false.obs;
  RxInt currentPage = 1.obs;
  RxInt totalPages = 1.obs;

  RxnDouble selectedLat = RxnDouble();
  RxnDouble selectedLng = RxnDouble();

  RxList<Map<String, String>> locationSuggestions = <Map<String, String>>[].obs;
  RxBool isLocationLoading = false.obs;

  static const String googleApiKey = "AIzaSyCsyn14DBYbKmeQOaKKICtaQq6C9MUDJ8Y";


  @override
  void onInit() {
    super.onInit();
    ever(eventsList, (_) {
      if (searchQuery.value.isEmpty) {
        filteredEventsList.assignAll(eventsList);
      }
    });
  }

  Future<void> fetchEvents({
    String? type,
    String? category,
    double? lat,
    String? date,
    double? long,
    int page = 1,
    double? maxDistance,
    String? searchTerm,
  }) async {
    isLoading(true);

    try {
      String url = ApiConstants.eventFields;
      List<String> queryParams = [];
      if (category != null && category.isNotEmpty) queryParams.add("category=$category");
      if (type != null && type.isNotEmpty) queryParams.add("type=$type");
      if (searchTerm != null && searchTerm.isNotEmpty) queryParams.add("search=$searchTerm");
      if (date != null && date.isNotEmpty) queryParams.add("date=$date");
      if (page > 1) queryParams.add("page=$page");
      if (lat != null && long != null) {
        queryParams.add("lat=$lat");
        queryParams.add("long=$long");
        if (maxDistance != null) queryParams.add("maxDistance=$maxDistance");
      }



      if (queryParams.isNotEmpty) url += "?${queryParams.join("&")}";

      final response = await ApiClient.getData(url);

      if (response.statusCode == 200 && response.body != null) {
        final eventResponse = EventResponseModel.fromJson(response.body);
        if (eventResponse.success) {
          if (page == 1) {
            eventsList.assignAll(eventResponse.data.events);
          } else {
            eventsList.addAll(eventResponse.data.events);
          }

          // --- SYNC POINT ---
          // Update filtered list whenever the master list changes
          filteredEventsList.assignAll(eventsList);

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

  /// Local Filter Logic
  void filterSearch(String query) {
    if (query.isEmpty) {
      // If search is cleared, show everything
      filteredEventsList.assignAll(eventsList);
    } else {
      // Filter the master eventsList and update the filtered observable
      filteredEventsList.assignAll(
          eventsList.where((event) =>
              event.title.toLowerCase().contains(query.toLowerCase())
          ).toList()
      );
    }
  }


// Inside EventController

  Future<void> selectLocationSuggestion(String placeId) async {
    try {
      final uri = Uri.parse(
        "https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$googleApiKey",
      );
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        locationSuggestions.clear();
        final location = data["result"]["geometry"]["location"];

        selectedLat.value = location["lat"];
        selectedLng.value = location["lng"];

        locationSuggestions.clear();
      }
    } catch (e) {
      debugPrint("Select location error: $e");
    }
  }

  Future<void> fetchLocationSuggestions(String input) async {
    if (input.isEmpty) {
      locationSuggestions.clear();
      return;
    }

    isLocationLoading(true);
    try {
      final url = "https://maps.googleapis.com/maps/api/place/autocomplete/json"
          "?input=$input"
          "&key=$googleApiKey";

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List predictions = data['predictions'];

        locationSuggestions.assignAll(predictions.map((p) => {
          "description": p["description"] as String,
          "placeId": p["place_id"] as String,
        }).toList());
      }
    } catch (e) {
      debugPrint("Location Suggestion Error: $e");
    } finally {
      isLocationLoading(false);
    }
  }


  Future<void> deleteEvent(String eventId) async {
    try {
      String url = "${ApiConstants.eventFields}/$eventId";
      final response = await ApiClient.deleteData(url);

      if (response.statusCode == 200) {
        // Remove from both lists to keep UI consistent
        eventsList.removeWhere((event) => event.id == eventId);
        filteredEventsList.removeWhere((event) => event.id == eventId);

        Fluttertoast.showToast(msg: "Event deleted", backgroundColor: Colors.green);
      }
    } catch (e) {
      debugPrint("Delete Error: $e");
    }
  }
}