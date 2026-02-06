import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:involved/models/event_fields_response_model.dart';
import 'package:involved/service/api_client.dart';
import 'package:involved/service/api_constants.dart';

class EventFieldsController extends GetxController {
  // Observables for the lists
  RxList<String> categoriesList = <String>[].obs;
  RxList<String> typesList = <String>[].obs;
  RxList<String> atmospheresList = <String>[].obs;
  RxList<String> occurrencesList = <String>[].obs;
  RxList<String> statusesList = <String>[].obs;

  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAllEventFields();
  }

  /// Generic function to fetch fields
  /// Injects [middlePart] into /event/[middlePart]/fields
  Future<List<String>> getFields(String middlePart) async {
    try {
      // The logic: "/event/" + "categories" + "/fields"
      final String url = "${ApiConstants.eventFields}$middlePart/fields";

      debugPrint("Fetching from: $url");
      final response = await ApiClient.getData(url);

      if (response.statusCode == 200 && response.body != null) {
        final model = EventFieldsResponseModel.fromJson(response.body);
        if (model.success) {
          return model.data;
        }
      }
      return [];
    } catch (e) {
      debugPrint("Error fetching fields for $middlePart: $e");
      return [];
    }
  }

  /// Fetches all required dropdown data in parallel
  Future<void> fetchAllEventFields() async {
    isLoading(true);
    try {
      final results = await Future.wait([
        getFields('categories'),
        getFields('types'),
        getFields('atmospheres'),
        getFields('occurrence'),
        getFields('status'),
      ]);

      categoriesList.value = results[0];
      typesList.value = results[1];
      atmospheresList.value = results[2];
      occurrencesList.value = results[3];
      statusesList.value = results[4];
    } finally {
      isLoading(false);
    }
  }
}