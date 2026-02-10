import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:involved/controller/favorite_controller.dart';
import 'package:involved/utils/app_colors.dart';
import 'package:involved/utils/app_icons.dart';
import 'package:involved/utils/app_strings.dart';
import 'package:involved/views/base/custom_button.dart';
import 'package:involved/views/base/custom_list_tile.dart';
import 'package:involved/views/base/custom_network_image.dart';
import 'package:involved/views/base/custom_text.dart';

import '../../../../controller/collection_name_controller.dart';
import '../../../../controller/event_controller.dart';
import '../../../../service/api_constants.dart';
import '../../../base/custom_text_field.dart';

class AllTab extends StatefulWidget {
  final String eventType;
  const AllTab({super.key, required this.eventType});

  @override
  State<AllTab> createState() => _AllTabState();
}

class _AllTabState extends State<AllTab> {
  // Unique controller for each tab to maintain independent lists/loading states
  late EventController eventController;
  late FavoriteController favoriteController;

  late CollectionController collectionController;
  final TextEditingController newAlbumCTRL = TextEditingController();

  @override
  void initState() {
    super.initState();

    eventController = Get.put(EventController(), tag: widget.eventType);
    try {
      favoriteController = Get.find<FavoriteController>();
    } catch (e) {
      favoriteController = Get.put(FavoriteController());
    }
    
    try {
      collectionController = Get.find<CollectionController>();
    } catch (e) {
      collectionController = Get.put(CollectionController());
    }

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // Load favorites first to ensure correct status display
      await favoriteController.loadFavoritedEvents();
      // Pass the eventType directly.
      // If widget.eventType is "", our new controller logic will
      // automatically skip adding "type=" to the URL.
      eventController.fetchEvents(type: widget.eventType);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (eventController.isLoading.value && eventController.eventsList.isEmpty) {
        return const Center(child: CircularProgressIndicator());
      }

      if (eventController.eventsList.isEmpty) {
        return Center(child: CustomText(text: "No events found"));
      }

      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: GridView.builder(
          shrinkWrap: false,
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(vertical: 20.w),
          itemCount: eventController.eventsList.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 12.h,
            crossAxisSpacing: 12.w,
            childAspectRatio: 0.71,
          ),
          itemBuilder: (context, index) {
            final event = eventController.eventsList[index];
            String fullImageUrl = event.image.startsWith('http')
                ? event.image
                : "${ApiConstants.imageBaseUrl}${event.image}";

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
                      height: 180.h, // Adjusted to fit card better
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
                                isCurrentlyFavorite ? Icons.favorite : Icons.favorite_border,
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
        ),
      );
    });
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
                                  color: AppColors.primaryColor,
                                ),
                                SizedBox(height: 4.h),
                              ],
                            ),
                          ),
                          Icon(Icons.share, color: AppColors.primaryColor,)
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
                        InkWell(
                            onTap: () => Navigator.of(context).pop(),
                            child: CustomText(text: AppStrings.save, fontSize: 16.sp, fontWeight: FontWeight.w500)),
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