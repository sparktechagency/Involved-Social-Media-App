import 'dart:io';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:involved/service/api_client.dart';
import 'package:involved/service/api_constants.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';

class EventPostController extends GetxController {
  // --- Text Controllers ---
  final titleCTRL = TextEditingController();
  final locationCTRL = TextEditingController();
  final eventDateCTRL = TextEditingController();
  final eventTimeCTRL = TextEditingController();
  final descriptionCTRL = TextEditingController();
  final eventEndTimeCTRL = TextEditingController();

  // --- Image Handling ---
  RxString imagePath = "".obs;
  final ImagePicker _picker = ImagePicker();

  // Helper method for clean Toast calls
  void _showToast(String message, Color bgColor) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: bgColor,
      textColor: Colors.white,
      fontSize: 14.0,
    );
  }

  Future<void> pickImage(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(source: source, imageQuality: 50);
    if (pickedFile != null) {
      imagePath.value = pickedFile.path;
      Get.back();
    }
  }

  RxBool isPosting = false.obs;

  Future<Position?> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _showToast("Please enable location services.", Colors.orange);
      return null;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        _showToast("Location permissions are required.", Colors.red);
        return null;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      _showToast("Location permissions are permanently denied.", Colors.red);
      return null;
    }

    return await Geolocator.getCurrentPosition();
  }

  // Inside EventPostController class

  Future<void> createEvent({
    String? type,
    String? category,
    List<String>? atmosphere,
    String? occurrenceType,
  }) async {
    if (titleCTRL.text.isEmpty) {
      _showToast("Please enter an event title", Colors.red);
      return;
    }

    // 1. Get Location Coordinates
    debugPrint("====> Requesting Location...");
    Position? position = await _getCurrentLocation();

    if (position == null) return;

    isPosting(true);
    try {
      Map<String, String> body = {};
      body['title'] = titleCTRL.text.trim();
      body['address'] = locationCTRL.text.trim();
      body['description'] = descriptionCTRL.text.trim();
      body['startDate'] = eventDateCTRL.text;
      body['endDate'] = eventEndTimeCTRL.text;
      if (type != null) body['type'] = type;
      if (category != null) body['category'] = category;
      if (occurrenceType != null) body['occurrenceType'] = occurrenceType;

// Standard array format for nested objects in multipart
      body['location[coordinates][0]'] = position.longitude.toString();
      body['location[coordinates][1]'] = position.latitude.toString();

      // --- FIXED ATMOSPHERE ---
      if (atmosphere != null && atmosphere.isNotEmpty) {
        for (int i = 0; i < atmosphere.length; i++) {
          // Use index [i] to prevent overwriting if multiple atmospheres are selected
          body['atmosphere[$i]'] = atmosphere[i];
        }
      }

      List<MultipartBody> multipartFiles = [];
      if (imagePath.value.isNotEmpty) {
        multipartFiles.add(MultipartBody('image', File(imagePath.value)));
      }

      debugPrint("====> Final Body Sending: $body");

      Response response = await ApiClient.postMultipartData(
        ApiConstants.eventFields,
        body,
        multipartBody: multipartFiles,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.back();
        _showToast("Event created successfully!", Colors.green);
      } else {
        debugPrint("====> Error Body: ${response.bodyString}");
        _showToast("Failed to create event", Colors.red);
      }
    } catch (e) {
      debugPrint("====> Exception: $e");
    } finally {
      isPosting(false);
    }
  }
}