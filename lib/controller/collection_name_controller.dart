
import 'dart:convert';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:involved/service/api_client.dart';
import 'package:involved/service/api_constants.dart';
import 'dart:developer';
import 'package:flutter/material.dart';
import '../models/collection_name_response_model.dart';

class CollectionController extends GetxController {
  // --- Observables ---
  RxBool isLoading = false.obs;
  RxList<String> collectionList = <String>[].obs;
  RxBool isSaving = false.obs;

  @override
  void onInit() {
    super.onInit();
    getCollections();
  }

  // --- API Call ---
  Future<void> getCollections() async {
    isLoading(true);
    try {
      Response response = await ApiClient.getData(ApiConstants.collectionName);

      if (response.statusCode == 200) {
        // Map the JSON response to your Model
        CollectionNameResponseModel responseModel =
        CollectionNameResponseModel.fromJson(response.body);

        // Update the observable list with the collection data
        collectionList.assignAll(responseModel.data.collection);

        log("Collections Loaded: ${collectionList.length}");
      } else {
        log("Error Fetching Collections: ${response.statusText}");
      }
    } catch (e) {
      log("Exception in CollectionController: $e");
    } finally {
      isLoading(false);
    }
  }


  Future<void> saveToCollection({
    required String albumName,
    required String eventId,
    required String status,
  }) async {
    isSaving(true);
    try {
      // 1. Create the Map
      Map<String, dynamic> bodyMap = {
        "collectionName": albumName,
        "event": eventId,
        "status": status,
      };

      // 2. Manually encode to JSON String
      String encodedBody = jsonEncode(bodyMap);

      // 3. Send the String to ApiClient
      Response response = await ApiClient.postData(
        ApiConstants.saveCollection,
        encodedBody,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        Fluttertoast.showToast(msg: "Saved to $albumName", backgroundColor: Colors.green);
        refreshCollections();
        Get.back();
      } else {
        // Safely extract the server's error message
        String errorMessage = "Failed to save";
        if (response.body != null && response.body is Map) {
          errorMessage = response.body['message'] ?? response.statusText;
        } else {
          errorMessage = response.statusText ?? "Error: ${response.statusCode}";
        }

        Fluttertoast.showToast(
          msg: errorMessage,
          backgroundColor: Colors.red,
          toastLength: Toast.LENGTH_LONG,
        );
      }
    } catch (e) {
      log("Exception in saveToCollection: $e");
      Fluttertoast.showToast(msg: "An unexpected error occurred", backgroundColor: Colors.red);
    } finally {
      isSaving(false);
    }
  }

  // --- Refresh Method ---
  Future<void> refreshCollections() async {
    await getCollections();
  }
}