
import 'dart:convert';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:involved/service/api_client.dart';
import 'package:involved/service/api_constants.dart';
import 'dart:developer';
import 'package:flutter/material.dart';
import '../models/collection_grouped_response_model.dart';
import '../models/collection_name_filter_response_model.dart';
import '../models/collection_name_response_model.dart';

class CollectionController extends GetxController {
  // --- Observables ---
  RxBool isLoading = false.obs;
  RxBool isSaving = false.obs;
  RxBool isFilterLoading = false.obs; // Separate loader for the detail/filter screen

  // For the dialog selection (simple strings)
  RxList<String> collectionList = <String>[].obs;

  // For the profile/collection screen (grouped items with images)
  RxList<CollectionItem> groupedCollections = <CollectionItem>[].obs;

  // NEW: For the MyPlanScreen (Filtered events by collection name)
  RxList<FilterCollectionItem> filteredEvents = <FilterCollectionItem>[].obs;

  @override
  void onInit() {
    super.onInit();
    getCollections();
    getGroupedCollections();
  }

  // --- 1. Fetch Simple Names (For Add to Album Dialogs) ---
  Future<void> getCollections() async {
    isLoading(true);
    try {
      Response response = await ApiClient.getData(ApiConstants.collectionName);
      if (response.statusCode == 200) {
        CollectionNameResponseModel responseModel =
        CollectionNameResponseModel.fromJson(response.body);
        collectionList.assignAll(responseModel.data.collection);
      }
    } catch (e) {
      log("Exception in getCollections: $e");
    } finally {
      isLoading(false);
    }
  }

  // --- 2. Fetch Grouped Collections (For Profile Screen) ---
  Future<void> getGroupedCollections() async {
    isLoading(true);
    try {
      Response response = await ApiClient.getData(ApiConstants.collectionGrouped);
      if (response.statusCode == 200) {
        CollectionGroupedResponseModel responseModel =
        CollectionGroupedResponseModel.fromJson(response.body);
        groupedCollections.assignAll(responseModel.data.collections.data);
      }
    } catch (e) {
      log("Exception in getGroupedCollections: $e");
    } finally {
      isLoading(false);
    }
  }

  // --- 3. NEW: Filter Collections by Name (For MyPlanScreen) ---
  Future<void> fetchEventsByCollection(String name) async {
    isFilterLoading(true);
    filteredEvents.clear(); // Clear old data before fetching new
    try {
      // API: /collection?collectionName=Tour
      String url = "${ApiConstants.filterWithCollectionName}?collectionName=$name";
      Response response = await ApiClient.getData(url);

      if (response.statusCode == 200) {
        CollectionNameFilterResponseModel responseModel =
        CollectionNameFilterResponseModel.fromJson(response.body);

        filteredEvents.assignAll(responseModel.data.collections.data);
        log("Filtered Events for $name: ${filteredEvents.length}");
      } else {
        log("Filter Error: ${response.statusText}");
      }
    } catch (e) {
      log("Exception in fetchEventsByCollection: $e");
    } finally {
      isFilterLoading(false);
    }
  }

  // --- 4. Save to Collection ---
  Future<void> saveToCollection({
    required String albumName,
    required String eventId,
    required String status,
  }) async {
    isSaving(true);
    try {
      Map<String, dynamic> bodyMap = {
        "collectionName": albumName,
        "event": eventId,
        "status": status,
      };

      Response response = await ApiClient.postData(
        ApiConstants.saveCollection,
        jsonEncode(bodyMap),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        Fluttertoast.showToast(msg: "Saved to $albumName", backgroundColor: Colors.green);
        refreshCollections();
        if (Get.isOverlaysOpen) Get.back();
      } else {
        String errorMessage = response.body?['message'] ?? response.statusText ?? "Failed";
        Fluttertoast.showToast(msg: errorMessage, backgroundColor: Colors.red);
      }
    } catch (e) {
      log("Exception in saveToCollection: $e");
    } finally {
      isSaving(false);
    }
  }

  // --- Refresh Method ---
  Future<void> refreshCollections() async {
    await Future.wait([
      getCollections(),
      getGroupedCollections(),
    ]);
  }
}