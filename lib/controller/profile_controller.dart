import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:involved/helpers/prefs_helpers.dart';
import 'package:involved/models/user_model.dart';
import 'package:involved/service/api_client.dart';
import 'package:involved/service/api_constants.dart';
import 'package:involved/utils/app_constants.dart';

import '../utils/app_colors.dart';

class ProfileController extends GetxController {
  Rx<File?> selectedImage = Rx<File?>(null);
  RxString imagesPath = ''.obs;
  RxBool isUpdatingProfile = false.obs;
  String title = "Profile Screen";

  // User profile data
  Rx<UserData?> userProfile = Rx<UserData?>(null);
  RxBool isLoadingProfile = false.obs;

  @override
  void onInit() {
    debugPrint("On Init  $title");
    super.onInit();
  }

  @override
  void onReady() {
    // Load user profile when controller is ready
    debugPrint("On onReady  $title");
    getUserProfile();
    super.onReady();
  }

  // Fetch user profile data
  Future<void> getUserProfile() async {
    isLoadingProfile(true);
    try {
      final response = await ApiClient.getData(ApiConstants.getProfileEndPoint);

      if (response.statusCode == 200 && response.body != null) {
        final userData = UserModel.fromJson(response.body);
        if (userData.success == true) {
          userProfile.value = userData.data;
          update();
        } else {
          debugPrint('Failed to load user profile: ${userData.message}');
        }
      } else {
        debugPrint('Failed to load user profile: ${response.statusText}');
      }
    } catch (e) {
      debugPrint('Error getting user profile: $e');
    } finally {
      isLoadingProfile(false);
    }
  }

  //===============================> Edit Profile Screen <=============================
  final TextEditingController nameCTRL = TextEditingController();
  final TextEditingController phoneCTRL = TextEditingController();
  final TextEditingController addressCTRL = TextEditingController();

  //===============================> Image Picker <=============================
  Future pickImage(ImageSource source) async {
    final returnImage = await ImagePicker().pickImage(source: source);
    if (returnImage == null) return;
    selectedImage.value = File(returnImage.path);
    imagesPath.value = selectedImage.value!.path;
    //  image = File(returnImage.path).readAsBytesSync();
    update();
    print('ImagesPath===========================>:${imagesPath.value}');
    Get.back(); //
  }

  //==========================> Show Calender Function <=======================
 /* Future<void> pickBirthDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(3050),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            dialogBackgroundColor: Colors.white,
            colorScheme: ColorScheme.light(
              primary: AppColors.primaryColor,
              onSurface: Colors.black, // Text color
            ),
          ),
          child: child!,
        );
      },
    );
    if (pickedDate != null) {
      dateBirthCTRL.text =
          "${pickedDate.month}-${pickedDate.day}-${pickedDate.year}";
    }
  }*/

  //==========================> Update Profile Function <=======================
  Future<bool> updateProfile() async {
    isUpdatingProfile(true);
    try {
      Map<String, String> fields = {
        'name': nameCTRL.text.trim(),
        'address': addressCTRL.text.trim(),
      };

      // Only add phone field if it's not empty
      if (phoneCTRL.text.trim().isNotEmpty) {
        fields['phone'] = phoneCTRL.text.trim();
      }

      List<MultipartBody>? multipartBody;
      if (selectedImage.value != null) {
        multipartBody = [MultipartBody('image', selectedImage.value!)];
      }

      final response = await ApiClient.putMultipartData(
        ApiConstants.updateProfileEndPoint,
        fields,
        multipartBody: multipartBody,
      );

      if (response.statusCode == 200) {
        // Refresh the profile data after successful update
        await getUserProfile();
        // Clear the selected image after successful upload
        selectedImage.value = null;
        Fluttertoast.showToast(
          msg: "Profile updated successfully",
          backgroundColor: Colors.green,
        );
        return true;
      } else {
        Fluttertoast.showToast(
          msg: "Failed to update profile: ${response.statusText}",
          backgroundColor: Colors.red,
        );
        return false;
      }
    } catch (e) {
      debugPrint('Error updating profile: $e');
      Fluttertoast.showToast(
        msg: "Error updating profile: $e",
        backgroundColor: Colors.red,
      );
      return false;
    } finally {
      isUpdatingProfile(false);
    }
  }
}
