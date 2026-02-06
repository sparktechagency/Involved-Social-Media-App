
import 'package:get/get.dart';
import 'package:involved/service/api_client.dart';
import 'package:involved/service/api_constants.dart';
import 'dart:developer';

import '../models/collection_name_response_model.dart';

class CollectionController extends GetxController {
  // --- Observables ---
  RxBool isLoading = false.obs;
  RxList<String> collectionList = <String>[].obs;

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

  // --- Refresh Method ---
  Future<void> refreshCollections() async {
    await getCollections();
  }
}