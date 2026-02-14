import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:involved/utils/app_colors.dart';
import 'package:involved/utils/app_icons.dart';
import 'package:involved/utils/app_images.dart';
import 'package:involved/utils/app_strings.dart';
import 'package:involved/views/base/bottom_menu..dart';
import 'package:involved/views/base/custom_button.dart';
import 'package:involved/views/base/custom_list_tile.dart';
import 'package:involved/views/base/custom_network_image.dart';
import 'package:involved/views/base/custom_text.dart';
import 'package:involved/views/base/custom_text_field.dart';

import '../../../controller/collection_name_controller.dart';
import '../../../controller/event_controller.dart';
import '../../../controller/event_fields_controller.dart';
import '../../../controller/favorite_controller.dart';
import '../../../service/api_constants.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController searchCTRL = TextEditingController();
  final EventController eventController = Get.put(EventController());
  final CollectionController collectionController = Get.put(CollectionController());
  final EventFieldsController fieldsController = Get.put(EventFieldsController());
  late FavoriteController favoriteController;
  final TextEditingController newAlbumCTRL = TextEditingController();
  final TextEditingController addressFilterCTRL = TextEditingController();
  RxString selectedCategory = "Event categories".obs;
  RxString selectedDate = "Event date".obs;
  // Filter variables
  RxDouble distanceValue = 40.0.obs;

  Timer? _debounce;


  @override
  void initState() {
    super.initState();
    try {
      favoriteController = Get.find<FavoriteController>();
    } catch (e) {
      favoriteController = Get.put(FavoriteController());
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      eventController.fetchEvents();
    });

    addressFilterCTRL.addListener(() {
      if (_debounce?.isActive ?? false) _debounce!.cancel();
      _debounce = Timer(const Duration(milliseconds: 500), () {
        if (addressFilterCTRL.text.isNotEmpty) {
          eventController.fetchLocationSuggestions(addressFilterCTRL.text);
        }
      });
    });
  }

  @override
  void dispose() {
    searchCTRL.dispose();
    _debounce?.cancel(); // cancel any pending debounce
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomMenu(1),
      appBar: AppBar(
        title: CustomText(
          text: AppStrings.search.tr,
          fontWeight: FontWeight.w500,
          fontSize: 16.sp,
        ),
        backgroundColor: Colors.white,
        leading: const SizedBox(),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          children: [
            //==============================> Search Field & Filter Button <==============================
            Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    controller: searchCTRL,
                    prefixIcon: Icon(Icons.search_rounded, color: AppColors.primaryColor),
                    hintText: AppStrings.searchEvent.tr,
                    // ADD THIS:
                    onChanged: (val) {
                      eventController.filterSearch(val);
                    },
                    suffixIcon: IconButton(
                      onPressed: () {
                        searchCTRL.clear();
                        eventController.filterSearch(""); // Reset list when cleared
                      },
                      icon: const Icon(Icons.clear, color: Colors.grey),
                    ),
                  ),
                ),
                SizedBox(width: 8.w),
                GestureDetector(
                  onTap: () => showFilterBottomSheet(context),
                  child: Container(
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor, // Dark Green from your image
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.filter_alt_outlined, color: Colors.white, size: 24.sp),
                  ),
                ),
              ],
            ),
            SizedBox(height: 24.h),

            //==============================> Results Grid <==============================
            Expanded(
              child: Obx(() {
                // Check loading and the FILTERED list specifically
                if (eventController.isLoading.value && eventController.filteredEventsList.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }

                // If no results found after filtering
                if (eventController.filteredEventsList.isEmpty) {
                  return Center(child: CustomText(text: "No events found".tr));
                }

                return GridView.builder(
                  padding: EdgeInsets.symmetric(vertical: 8.h),
                  // IMPORTANT: Use filteredEventsList here
                  itemCount: eventController.filteredEventsList.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12.h,
                    crossAxisSpacing: 12.w,
                    childAspectRatio: 0.57,
                  ),
                  itemBuilder: (context, index) {
                    final event = eventController.filteredEventsList[index];
                    final fullImageUrl = "${ApiConstants.imageBaseUrl}${event.image}";

                    return Material(
                      color: Colors.white,
                      elevation: 2,
                      borderRadius: BorderRadius.circular(12.r),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12.r),
                        onTap: () => showEventDetailsDialog(
                            context: context,
                            imageUrl: fullImageUrl,
                            title: event.title,
                            dateTime: "${event.startDate.day}/${event.startDate.month}/${event.startDate.year}",
                            venue: event.address,
                            description: event.description,
                            status: event.status,
                            eventId: event.id.toString()
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomNetworkImage(
                              imageUrl: fullImageUrl,
                              height: 240.h,
                              width: double.infinity,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(12.r),
                                topRight: Radius.circular(12.r),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(8.w),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        CustomText(
                                          text: event.title,
                                          maxLine: 2,
                                          textOverflow: TextOverflow.ellipsis,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        SizedBox(height: 4.h),
                                        CustomText(
                                          text: event.address,
                                          maxLine: 1,
                                          textOverflow: TextOverflow.ellipsis,
                                          fontSize: 12.sp,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Obx(() {
                                    bool isCurrentlyFavorite = favoriteController.isFavorite(event.id);
                                    return GestureDetector(
                                      onTap: () {
                                        favoriteController.toggleFavorite(event.id);
                                      },
                                      child: Icon(
                                        isCurrentlyFavorite ?Icons.bookmark : Icons.bookmark_border,
                                        color: isCurrentlyFavorite ? AppColors.primaryColor : Colors.grey,
                                        size: 22.sp,
                                      ),
                                    );
                                  }),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  //==============================> Event Details Dialog <==============================
  void showEventDetailsDialog({
    required BuildContext context,
    required String imageUrl,
    required String title,
    required String dateTime,
    required String venue,
    required String description,
    required String status,
    required String eventId,
  }) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24.r),
          ),
          insetPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
          backgroundColor: Colors.white,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Padding(
                padding: EdgeInsets.all(16.w),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomNetworkImage(
                        imageUrl: imageUrl,
                        height: 180.h,
                        width: double.infinity,
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      SizedBox(height: 16.h),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomText(
                                  text: title,
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w500,
                                  maxLine: 3,
                                  textAlign: TextAlign.start,
                                  color: AppColors.primaryColor,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20.h),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(
                              text: 'Event Date & Time'.tr,
                              fontSize: 12.sp,
                              color: AppColors.primaryColor,
                            ),
                            SizedBox(height: 4.h),
                            CustomText(text: dateTime,
                                color: AppColors.primaryColor),
                          ],
                        ),
                      ),
                      SizedBox(height: 20.h),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: CustomText(
                          text: AppStrings.description.tr,
                          fontWeight: FontWeight.w500,
                          fontSize: 16.sp,
                          color: AppColors.primaryColor,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      CustomText(
                        text: description,
                        color: AppColors.primaryColor,
                        maxLine: 20,
                        textAlign: TextAlign.start,
                      ),
                      SizedBox(height: 16.h),
                      //================================> Location Container <==============================
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(12.w),
                        decoration: BoxDecoration(
                          color: Color(0xffffefd1),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.location_on, color: AppColors.primaryColor),
                            SizedBox(width: 8.w),
                            Expanded(
                              child: CustomText(
                                text: venue,
                                color: AppColors.primaryColor,
                                fontWeight: FontWeight.w500,
                                maxLine: 3,
                                textAlign: TextAlign.start,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 16.h),
                      //================================> Live Container <==============================
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(12.w),
                        decoration: BoxDecoration(
                          color: const Color(0xffffefd1),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Dynamic Color applied here
                            Icon(
                                Icons.circle,
                                color: getStatusColor(status),
                                size: 12.h
                            ),
                            SizedBox(width: 8.w),
                            CustomText(
                              text: status,
                              // Using the same color for the text looks professional
                              color: getStatusColor(status),
                              fontWeight: FontWeight.w700,
                              maxLine: 3,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20.h),
                      //================================> Interested, Going and Add Button <==============================
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: CustomButton(
                              onTap: () => showPlanConfirmation(context, eventId, "Interested"),
                              text: AppStrings.interested.tr,
                              color: const Color(0xffffefd1),
                              broderColor: const Color(0xffffefd1),
                              textColor: AppColors.primaryColor,
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Expanded(
                            child: CustomButton(
                              onTap: () => showPlanConfirmation(context, eventId, "Going"),
                              text: AppStrings.going.tr,
                              broderColor: const Color(0xffffefd1),
                              textColor: AppColors.primaryColor,
                              color: const Color(0xffffefd1),
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Expanded(
                            child: CustomButton(
                              onTap: () => addFolderDialog(eventId),
                              text: AppStrings.add.tr,
                              color: const Color(0xffffefd1),
                              broderColor: const Color(0xffffefd1),
                              textColor: AppColors.primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: -8,
                right: -8,
                child: GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: CircleAvatar(
                    radius: 16.r,
                    backgroundColor: AppColors.primaryColor,
                    child: Icon(Icons.close, color: Colors.white, size: 16.sp),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  //==============================> Event Details Dialog <==============================
  void addFolderDialog(String eventId) {
    bool isCreatingNew = false; // Local state to toggle UI

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        // We use StatefulBuilder to update UI (TextField toggle) inside the dialog
        return StatefulBuilder(builder: (context, setModalState) {
          return Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.r)),
            insetPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
            backgroundColor: Colors.white,
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                            onTap: () => Navigator.of(context).pop(),
                            child: Icon(Icons.arrow_back_ios_new_outlined, size: 16.w)),
                        CustomText(text: AppStrings.save, fontSize: 16.sp, fontWeight: FontWeight.w500),
                      ],
                    ),
                    SizedBox(height: 20.h),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: CustomText(
                        text: AppStrings.addToAlbum.tr,
                        fontWeight: FontWeight.w500,
                        fontSize: 16.sp,
                      ),
                    ),
                    SizedBox(height: 8.h),

                    // --- Toggle between Button and TextField ---
                    if (!isCreatingNew)
                      GestureDetector(
                        onTap: () => setModalState(() => isCreatingNew = true),
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(12.w),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12.r),
                            border: Border.all(color: AppColors.greyColor),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.add_circle_outlined, color: AppColors.primaryColor),
                              SizedBox(width: 8.w),
                              CustomText(
                                text: AppStrings.createNewAlbum.tr,
                                color: AppColors.greyColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ],
                          ),
                        ),
                      )
                    else
                      Row(
                        children: [
                          Expanded(
                            child: CustomTextField(
                              controller: newAlbumCTRL,
                              hintText: "Enter album name...",
                            ),
                          ),
                          SizedBox(width: 8.w),
                          // --- The Save (+) Icon Button ---
                          IconButton(
                            onPressed: () {
                              if (newAlbumCTRL.text.isNotEmpty) {
                                collectionController.saveToCollection(
                                  albumName: newAlbumCTRL.text.trim(),
                                  eventId: eventId,
                                  status: "Added", // Passing Added as status
                                );
                                newAlbumCTRL.clear();
                              }
                            },
                            icon: Icon(Icons.add_box, color: AppColors.primaryColor, size: 32.sp),
                          )
                        ],
                      ),

                    SizedBox(height: 16.h),

                    // --- Existing Collection List ---
                    Obx(() {
                      if (collectionController.isLoading.value) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      return Column(
                        children: collectionController.collectionList.map((album) {
                          return CustomListTile(
                            title: album,
                            suffixIcon: SvgPicture.asset(AppIcons.rightArrow),
                            onTap: () {
                              collectionController.saveToCollection(
                                albumName: album,
                                eventId: eventId,
                                status: "Added",
                              );
                            },
                          );
                        }).toList(),
                      );
                    }),
                    SizedBox(height: 20.h),
                  ],
                ),
              ),
            ),
          );
        });
      },
    );
  }

  void showPlanConfirmation(BuildContext context, String eventId, String planStatus) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white, // Strictly white background
          surfaceTintColor: Colors.white, // Prevents Material 3 tinting
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
          title: CustomText(
            text: "Add to My Plans?",
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryColor,
          ),
          content: CustomText(
            text: "Would you like to mark this event as '$planStatus' in your plans?",
            maxLine: 2,
            color: Colors.black87,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: CustomText(
                  text: "Cancel",
                  color: Colors.grey,
                  fontWeight: FontWeight.w500
              ),
            ),
            // Using a more prominent style for the Confirm action
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: const Color(0xffffefd1), // Match your button theme
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
              ),
              onPressed: () {
                Navigator.pop(context); // Close confirmation dialog

                collectionController.saveToCollection(
                  albumName: "MY PLANS",
                  eventId: eventId,
                  status: planStatus,
                );
              },
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.w),
                child: CustomText(
                  text: "Confirm",
                  color: AppColors.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }


  void showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: EdgeInsets.only(
              left: 20.w,
              right: 20.w,
              top: 20.w,
              bottom: MediaQuery.of(context).viewInsets.bottom + 20.w // Handle keyboard
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(30.r)),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40.w,
                    height: 4.h,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                Center(
                  child: CustomText(
                    text: "Filters",
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 24.h),

                // 1. Address Field (CustomTextField)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTextField(
                      controller: addressFilterCTRL,
                      hintText: "Search location...",
                      onChanged: (val) {
                        // This triggers your Google Places API call in the controller
                        eventController.fetchLocationSuggestions(val);
                      },
                      suffixIcon: IconButton(
                        onPressed: () {
                          addressFilterCTRL.clear();
                          eventController.locationSuggestions.clear();
                          // Reset stored coordinates
                          eventController.selectedLat.value = null;
                          eventController.selectedLng.value = null;
                        },
                        icon: const Icon(Icons.clear, color: Colors.grey),
                      ),
                    ),

                    // Suggestions List
                    Obx(() {
                      if (eventController.locationSuggestions.isEmpty) return const SizedBox.shrink();

                      return Container(
                        constraints: BoxConstraints(maxHeight: 200.h),
                        margin: EdgeInsets.only(top: 4.h),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: eventController.locationSuggestions.length,
                          itemBuilder: (context, index) {
                            final suggestion = eventController.locationSuggestions[index];
                            return ListTile(
                              leading: Icon(Icons.location_on, color: AppColors.primaryColor, size: 18.sp),
                              title: CustomText(
                                text: suggestion['description']!,
                                fontSize: 13.sp,
                                textAlign: TextAlign.start,
                              ),
                              onTap: () {
                                addressFilterCTRL.text = suggestion['description']!;
                                eventController.selectLocationSuggestion(suggestion['placeId']!);
                                // Focus remains or close suggestions
                                eventController.locationSuggestions.clear();
                              },
                            );
                          },
                        ),
                      );
                    }),
                  ],
                ),
                SizedBox(height: 12.h),

                // 2. Category Dropdown Selector
                Obx(() => _buildFilterSelector(
                  label: selectedCategory.value,
                  onTap: () {
                    _showCategoryPicker(context); // Call the picker method
                  },
                )),
                SizedBox(height: 12.h),

                // 3. Date Calendar Picker
                Obx(() => _buildFilterSelector(
                  label: selectedDate.value,
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101),
                    );
                    if (pickedDate != null) {
                      // This sets the UI display and makes the Apply logic simpler
                      // Result: 2026-02-13
                      selectedDate.value = "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
                    }
                  },
                )),
                SizedBox(height: 24.h),

                CustomText(text: "Distance", fontWeight: FontWeight.w500),
                SizedBox(height: 8.h),

                // Distance Slider Container
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 16.h),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: AppColors.primaryColor.withOpacity(0.3)),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomText(text: "0 Miles", fontSize: 12.sp, color: Colors.grey),
                          CustomText(text: "1000 Miles", fontSize: 12.sp, color: Colors.grey),
                        ],
                      ),
                      Obx(() => SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          activeTrackColor: AppColors.primaryColor,
                          thumbColor: AppColors.primaryColor,
                          overlayColor: AppColors.primaryColor.withOpacity(0.2),
                          trackHeight: 4,
                        ),
                        child: Slider(
                          value: distanceValue.value,
                          min: 0,
                          max: 1000,
                          divisions: 1000,
                          onChanged: (val) => distanceValue.value = val,
                        ),
                      )),
                      Obx(() => CustomText(
                        text: "${distanceValue.value.round()}miles",
                        fontSize: 12.sp,
                        color: AppColors.primaryColor,
                        fontWeight: FontWeight.w600,
                      )),
                    ],
                  ),
                ),

                SizedBox(height: 32.h),

                CustomButton(
                  text: "Apply Filters",
                  onTap: () {
                    // 1. Strict Validation: Location is mandatory for filtering
                    if (eventController.selectedLat.value == null || eventController.selectedLng.value == null) {
                      Fluttertoast.showToast(
                        msg: "Please search and select a location to filter events",
                        backgroundColor: Colors.red,
                      );
                      return;
                    }

                    // 2. Format Date: Use formatted string if it's not the default hint
                    String finalDate = (selectedDate.value == "Event date") ? "" : selectedDate.value;

                    // 3. Call fetch with mandatory lat/long and category
                    eventController.fetchEvents(
                      category: selectedCategory.value == "Event categories" ? "" : selectedCategory.value,
                      date: finalDate,
                      lat: eventController.selectedLat.value,
                      long: eventController.selectedLng.value,
                      maxDistance: distanceValue.value,
                      searchTerm: searchCTRL.text,
                    );

                    Navigator.pop(context);
                  },
                ),
                SizedBox(height: 12.h),
                // Reset Button
                Center(
                  child: TextButton(
                    onPressed: () {
                      selectedCategory.value = "Event categories";
                      selectedDate.value = "Event date";
                      distanceValue.value = 40.0;
                      addressFilterCTRL.clear();
                      eventController.selectedLat.value = null;
                      eventController.selectedLng.value = null;
                      eventController.fetchEvents();
                      Navigator.pop(context);
                    },
                    child: CustomText(text: "Reset Filters", color: Colors.red),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }



// Updated Helper Widget for Selectors
  Widget _buildFilterSelector({required String label, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: AppColors.primaryColor.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Expanded(
              child: CustomText(
                text: label,
                color: Colors.grey[600]!,
                textAlign: TextAlign.start, // Start left alignment
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 14.sp, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  void _showCategoryPicker(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white, // Prevents grey tint in Material 3
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
          child: Container(
            padding: EdgeInsets.all(16.w),
            constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.7),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomText(
                      text: "Select Category",
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryColor,
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(Icons.close, size: 20.sp),
                    )
                  ],
                ),
                const Divider(),

                // List Content
                Flexible(
                  child: Obx(() {
                    if (fieldsController.isLoading.value) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (fieldsController.categoriesList.isEmpty) {
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 20.h),
                        child: CustomText(text: "No categories found"),
                      );
                    }

                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: fieldsController.categoriesList.length,
                      itemBuilder: (context, index) {
                        final category = fieldsController.categoriesList[index];
                        return Obx(() {
                          // Check if this item is currently selected
                          bool isSelected = selectedCategory.value == category;

                          return InkWell(
                            onTap: () {
                              selectedCategory.value = category;
                              Navigator.pop(context);
                            },
                            child: Container(
                              margin: EdgeInsets.symmetric(vertical: 4.h),
                              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
                              decoration: BoxDecoration(
                                color: isSelected ? const Color(0xffffefd1) : Colors.transparent,
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    isSelected ? Icons.check_circle : Icons.circle_outlined,
                                    color: isSelected ? AppColors.primaryColor : Colors.grey,
                                    size: 20.sp,
                                  ),
                                  SizedBox(width: 12.w),
                                  Expanded(
                                    child: CustomText(
                                      text: category,
                                      textAlign: TextAlign.start,
                                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                                      color: isSelected ? AppColors.primaryColor : Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        });
                      },
                    );
                  }),
                ),
              ],
            ),
          ),
        );
      },
    );
  }


  Color getStatusColor(String status) {
    switch (status) {
      case "Quiet":
        return AppColors.primaryColor; // Your Primary Color
      case "Moderate":
        return Colors.yellow;          // Yellow
      case "Busy":
        return Colors.red;             // Red
      case "Pending":
        return Colors.orange;          // Default/Orange
      case "Active":
        return Colors.green;           // Suggested Green
      case "Expire":
        return Colors.grey;            // Suggested Grey
      case "Rejected":
        return Colors.black;           // Suggested Black
      default:
        return AppColors.primaryColor; // Fallback
    }
  }
}
