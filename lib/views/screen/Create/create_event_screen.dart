import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:involved/controller/profile_controller.dart';
import 'package:involved/utils/app_colors.dart';
import 'package:involved/utils/app_icons.dart';
import 'package:involved/utils/app_images.dart';
import 'package:involved/utils/app_strings.dart';
import 'package:involved/views/base/custom_app_bar.dart';
import 'package:involved/views/base/custom_button.dart';
import 'package:involved/views/base/custom_network_image.dart';
import 'package:involved/views/base/custom_text.dart';
import 'package:involved/views/base/custom_text_field.dart';

import '../../../controller/event_fields_controller.dart';
import '../../../controller/event_post_controller.dart';
import '../../../models/event_response_model.dart';


class CreateEventScreen extends StatefulWidget {
  const CreateEventScreen({super.key});

  @override
  State<CreateEventScreen> createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  final EventFieldsController fieldsController = Get.put(EventFieldsController());
  final EventPostController postController = Get.put(EventPostController());

  String? _selectedEventType;
  String? _selectedEventCategory;
  String? _selectedOccurrenceType;
  List<String> selectedAtmospheres = [];

  bool isEdit = false;
  String? eventId;

  @override
  void initState() {
    super.initState();
    _checkAndPopulateData();
  }

  void _checkAndPopulateData() {
    // Check if arguments were passed (Editing mode)
    if (Get.arguments != null && Get.arguments is Event) {
      isEdit = true;
      final Event event = Get.arguments;
      eventId = event.id.toString();

      // 1. Fill Text Controllers
      postController.titleCTRL.text = event.title;
      postController.locationCTRL.text = event.address;
      postController.descriptionCTRL.text = event.description;

      // Formatting dates for the text fields
      postController.eventDateCTRL.text = event.startDate.toIso8601String().split('.')[0];
      postController.eventEndTimeCTRL.text = event.endDate.toIso8601String().split('.')[0];

      // 2. Preset Dropdowns and Lists
      _selectedEventType = event.type;
      _selectedEventCategory = event.category;
      _selectedOccurrenceType = event.occurrenceType;
      selectedAtmospheres = List<String>.from(event.atmosphere);

      // Note: For images, we usually keep postController.imagePath empty
      // unless the user picks a NEW one to upload.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Change title based on mode
      appBar: CustomAppBar(title: isEdit ? "Edit Event" : AppStrings.createEvent.tr),
      body: Obx(() {
        if (fieldsController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        return SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
            child: Card(
              color: const Color(0xffFFEFD1),
              child: Padding(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(child: Image.asset(AppImages.logos, width: 142.w, height: 64.h)),
                    SizedBox(height: 12.h),

                    _buildFormContainer(
                      label: AppStrings.eventTitle.tr,
                      child: CustomTextField(
                        borderColor: Colors.white,
                        controller: postController.titleCTRL,
                        hintText: AppStrings.enterEventName.tr,
                      ),
                    ),
                    SizedBox(height: 16.h),

                    _buildDropdownContainer(
                      label: AppStrings.eventType.tr,
                      value: _selectedEventType,
                      items: fieldsController.typesList,
                      hint: 'Select Event Type'.tr,
                      onChanged: (val) => setState(() => _selectedEventType = val),
                    ),
                    SizedBox(height: 16.h),

                    _buildDropdownContainer(
                      label: AppStrings.eventCategories.tr,
                      value: _selectedEventCategory,
                      items: fieldsController.categoriesList,
                      hint: 'Select Category'.tr,
                      onChanged: (val) => setState(() => _selectedEventCategory = val),
                    ),
                    SizedBox(height: 16.h),

                    _buildFormContainer(
                      label: AppStrings.location.tr,
                      child: CustomTextField(
                        controller: postController.locationCTRL,
                        borderColor: Colors.white,
                        hintText: AppStrings.enterEventLocation.tr,
                      ),
                    ),
                    SizedBox(height: 16.h),

                    _buildFormContainer(
                      label: "Event Start",
                      child: CustomTextField(
                        onTap: () => pickDateTime(context, isStartTime: true),
                        readOnly: true,
                        controller: postController.eventDateCTRL,
                        suffixIcon: Icon(Icons.calendar_month, color: AppColors.primaryColor),
                        hintText: "Select Start Date & Time",
                      ),
                    ),
                    SizedBox(height: 16.h),

                    _buildFormContainer(
                      label: "Event End",
                      child: CustomTextField(
                        onTap: () => pickDateTime(context, isStartTime: false),
                        readOnly: true,
                        controller: postController.eventEndTimeCTRL,
                        suffixIcon: Icon(Icons.calendar_month, color: AppColors.primaryColor),
                        hintText: "Select End Date & Time",
                      ),
                    ),
                    SizedBox(height: 16.h),

                    // --- Atmosphere ---
                    CustomText(
                      left: 9.w,
                      text: 'Atmosphere'.tr,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryColor,
                    ),
                    SizedBox(height: 8.h),
                    GestureDetector(
                      onTap: () => pickAtmosphere(context),
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8.r),
                          border: Border.all(color: AppColors.primaryColor, width: 1.w),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: CustomText(
                                  text: "Select Atmosphere".tr,
                                  color: Colors.black54,
                                  fontSize: 14.sp),
                            ),
                            Icon(Icons.add_circle_outline, color: AppColors.primaryColor, size: 24.sp),
                          ],
                        ),
                      ),
                    ),
                    if (selectedAtmospheres.isNotEmpty)
                      Padding(
                        padding: EdgeInsets.only(top: 12.h, left: 4.w, right: 4.w),
                        child: Wrap(
                          spacing: 8.0,
                          runSpacing: 4.0,
                          children: selectedAtmospheres.map((item) => _atmosphereChip(item)).toList(),
                        ),
                      ),
                    SizedBox(height: 16.h),

                    // --- Description ---
                    _buildFormContainer(
                      label: AppStrings.description.tr,
                      child: CustomTextField(
                        controller: postController.descriptionCTRL,
                        hintText: 'Write a description...'.tr,
                        maxLines: 3,
                        borderColor: Colors.white,
                      ),
                    ),
                    SizedBox(height: 16.h),

                    // --- Occurrence ---
                    _buildDropdownContainer(
                      label: AppStrings.occurrenceType.tr,
                      value: _selectedOccurrenceType,
                      items: fieldsController.occurrencesList,
                      hint: 'Select Occurrence'.tr,
                      onChanged: (val) => setState(() => _selectedOccurrenceType = val),
                    ),
                    SizedBox(height: 16.h),

                    // --- Image Section ---
                    _buildImageSection(),
                    SizedBox(height: 32.h),

                    // --- Submit Button ---
                    Obx(() => CustomButton(
                        loading: postController.isPosting.value,
                        onTap: () {
                          if (isEdit) {
                            // Call Update Method (You need to add this to your controller)
                            postController.updateEvent(
                              eventId: eventId!,
                              type: _selectedEventType,
                              category: _selectedEventCategory,
                              occurrenceType: _selectedOccurrenceType,
                              atmosphere: selectedAtmospheres,
                            );
                          } else {
                            postController.createEvent(
                              type: _selectedEventType,
                              category: _selectedEventCategory,
                              occurrenceType: _selectedOccurrenceType,
                              atmosphere: selectedAtmospheres,
                            );
                          }
                        },
                        text: isEdit ? "Update Event" : AppStrings.createEvent.tr)),
                    SizedBox(height: 32.h),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  // --- Date Picking Logic ---
  Future<void> pickDateTime(BuildContext context, {required bool isStartTime}) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (pickedDate == null) return;

    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime == null) return;

    final DateTime fullDateTime = DateTime(
      pickedDate.year,
      pickedDate.month,
      pickedDate.day,
      pickedTime.hour,
      pickedTime.minute,
    );

    // Format matches your successful Postman example: yyyy-MM-ddTHH:mm:ss
    String formattedDateTime =
        "${fullDateTime.year}-${fullDateTime.month.toString().padLeft(2, '0')}-${fullDateTime.day.toString().padLeft(2, '0')}T${fullDateTime.hour.toString().padLeft(2, '0')}:${fullDateTime.minute.toString().padLeft(2, '0')}:00";

    setState(() {
      if (isStartTime) {
        postController.eventDateCTRL.text = formattedDateTime;
      } else {
        postController.eventEndTimeCTRL.text = formattedDateTime;
      }
    });
  }

  // --- Atmosphere Selection Chip ---
  Widget _atmosphereChip(String atmosphere) {
    return Chip(
      label: CustomText(text: atmosphere, color: Colors.white, fontSize: 12.sp),
      backgroundColor: AppColors.primaryColor,
      deleteIcon: Icon(Icons.cancel, size: 16.sp, color: Colors.white),
      onDeleted: () => setState(() => selectedAtmospheres.remove(atmosphere)),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
    );
  }

  // --- Atmosphere Picker ---
  Future<void> pickAtmosphere(BuildContext context) async {
    List<String> tempSelected = List.from(selectedAtmospheres);
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24.r))),
      backgroundColor: Colors.white,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) {
          return Padding(
            padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, MediaQuery.of(context).viewInsets.bottom + 24.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(width: 40.w, height: 4.h, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10.r))),
                SizedBox(height: 16.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomText(text: 'Select Atmosphere'.tr, fontSize: 20.sp, fontWeight: FontWeight.bold, color: Colors.black),
                    IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close, color: Colors.grey)),
                  ],
                ),
                SizedBox(height: 16.h),
                ConstrainedBox(
                  constraints: BoxConstraints(maxHeight: 350.h),
                  child: SingleChildScrollView(
                    child: Wrap(
                      spacing: 10.w,
                      runSpacing: 10.h,
                      children: fieldsController.atmospheresList.map((item) {
                        final isSelected = tempSelected.contains(item);
                        return GestureDetector(
                          onTap: () => setModalState(() => isSelected ? tempSelected.remove(item) : tempSelected.add(item)),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                            decoration: BoxDecoration(
                              color: isSelected ? AppColors.primaryColor : Colors.white,
                              borderRadius: BorderRadius.circular(30.r),
                              border: Border.all(color: isSelected ? AppColors.primaryColor : Colors.grey[300]!, width: 1.5.w),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (isSelected) Icon(Icons.check, size: 16.sp, color: Colors.white),
                                if (isSelected) SizedBox(width: 6.w),
                                CustomText(text: item, color: isSelected ? Colors.white : Colors.black87, fontSize: 14.sp),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                SizedBox(height: 24.h),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                    ),
                    onPressed: () {
                      setState(() => selectedAtmospheres = List.from(tempSelected));
                      Navigator.pop(context);
                    },
                    child: CustomText(text: 'Apply Selection'.tr, color: Colors.white, fontSize: 16.sp, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // --- Image Section ---
  Widget _buildImageSection() {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(side: BorderSide(width: 1.w, color: AppColors.primaryColor), borderRadius: BorderRadius.circular(12.r)),
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          children: [
            CustomText(text: AppStrings.uploadImage.tr, fontWeight: FontWeight.w500, fontSize: 16.sp),
            SizedBox(height: 16.h),
            Obx(() => Container(
              height: 200.h, width: 279.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(color: AppColors.greyColor),
                image: postController.imagePath.value.isNotEmpty
                    ? DecorationImage(image: FileImage(File(postController.imagePath.value)), fit: BoxFit.cover)
                    : null,
              ),
              child: postController.imagePath.value.isEmpty
                  ? Center(child: IconButton(onPressed: _showImagePickerOption, icon: const Icon(Icons.add_a_photo)))
                  : Align(alignment: Alignment.topRight, child: IconButton(onPressed: () => postController.imagePath.value = "", icon: const Icon(Icons.cancel, color: Colors.red))),
            )),
          ],
        ),
      ),
    );
  }

  // --- Reusable Containers ---
  Widget _buildFormContainer({required String label, required Widget child}) {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8.r), border: Border.all(width: 1.w, color: AppColors.primaryColor)),
      child: Padding(
        padding: EdgeInsets.all(8.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(left: 9.w, text: label, fontSize: 16.sp, fontWeight: FontWeight.w700, color: AppColors.primaryColor),
            child,
          ],
        ),
      ),
    );
  }

  Widget _buildDropdownContainer({required String label, String? value, required List<String> items, required String hint, required Function(String?) onChanged}) {
    return _buildFormContainer(
      label: label,
      child: DropdownButton<String>(
        isExpanded: true,
        dropdownColor: Colors.white,
        value: value,
        hint: CustomText(left: 10.w, text: hint, color: Colors.black),
        icon: SvgPicture.asset(AppIcons.rightArrow),
        underline: const SizedBox(),
        onChanged: onChanged,
        items: items.map((val) => DropdownMenuItem(value: val, child: CustomText(left: 10.w, text: val, color: Colors.black))).toList(),
      ),
    );
  }

  void _showImagePickerOption() {
    Get.bottomSheet(Container(
      color: Colors.white, padding: EdgeInsets.all(20.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(onPressed: () => postController.pickImage(ImageSource.camera), icon: Icon(Icons.camera_alt, size: 40.sp, color: AppColors.primaryColor)),
          IconButton(onPressed: () => postController.pickImage(ImageSource.gallery), icon: Icon(Icons.image, size: 40.sp, color: AppColors.primaryColor)),
        ],
      ),
    ));
  }
}