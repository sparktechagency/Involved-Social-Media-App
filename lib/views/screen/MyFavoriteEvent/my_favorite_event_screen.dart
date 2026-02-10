import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:involved/controller/collection_name_controller.dart';
import 'package:involved/controller/favorite_controller.dart';
import 'package:involved/service/api_constants.dart';
import 'package:involved/utils/app_colors.dart';
import 'package:involved/utils/app_icons.dart';
import 'package:involved/utils/app_strings.dart';
import 'package:involved/views/base/custom_app_bar.dart';
import 'package:involved/views/base/custom_button.dart';
import 'package:involved/views/base/custom_list_tile.dart';
import 'package:involved/views/base/custom_network_image.dart';
import 'package:involved/views/base/custom_text.dart';
import 'package:involved/views/base/custom_text_field.dart';

class MyFavoriteEventScreen extends StatefulWidget {
  const MyFavoriteEventScreen({super.key});

  @override
  State<MyFavoriteEventScreen> createState() => _MyFavoriteEventScreenState();
}

class _MyFavoriteEventScreenState extends State<MyFavoriteEventScreen> {
  final TextEditingController newAlbumCTRL = TextEditingController();
  late FavoriteController _favoriteController;
  late CollectionController collectionController;

  @override
  void initState() {
    super.initState();
    _favoriteController = Get.put(FavoriteController());
    collectionController = Get.put(CollectionController());
    try {
      _favoriteController = Get.find<FavoriteController>();
      collectionController = Get.find<CollectionController>();
    } catch (e) {
      _favoriteController = Get.put(FavoriteController());
      collectionController = Get.put(CollectionController());
    }
  }

  @override
  void dispose() {
    _favoriteController.dispose();
    collectionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: AppStrings.myFavoriteEventList.tr),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Obx(() {
          if (_favoriteController.isLoading.value &&
              _favoriteController.favoriteEvents.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (_favoriteController.favoriteEvents.isEmpty) {
            return Center(
              child: CustomText(
                text: 'No favorite events found',
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
              ),
            );
          }

          return Column(
            children: [
              Expanded(
                child: NotificationListener<ScrollNotification>(
                  onNotification: (ScrollNotification scrollInfo) {
                    if (scrollInfo.metrics.pixels ==
                            scrollInfo.metrics.maxScrollExtent &&
                        !_favoriteController.isLoadingMore.value &&
                        _favoriteController.hasMoreData.value) {
                      _favoriteController.loadMore();
                    }
                    return false;
                  },
                  child: ListView.builder(
                    padding: EdgeInsets.symmetric(vertical: 8.h),
                    itemCount:
                        _favoriteController.favoriteEvents.length +
                        (_favoriteController.isLoadingMore.value ? 1 : 0),
                    itemBuilder: (context, index) {
                      // Show loading indicator at the end if loading more
                      if (index >= _favoriteController.favoriteEvents.length) {
                        return Container(
                          padding: EdgeInsets.symmetric(vertical: 10.h),
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }

                      final favoriteEvent =
                          _favoriteController.favoriteEvents[index];
                      final event = favoriteEvent.event;

                      return Container(
                        margin: EdgeInsets.only(bottom: 12.h),
                        child: Material(
                          color: Colors.white,
                          elevation: 2,
                          borderRadius: BorderRadius.circular(12.r),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(12.r),
                            onTap: () => showEventDetailsDialog(
                              context: context,
                              imageUrl: '${ApiConstants.imageBaseUrl}${event.image}',
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
                                  imageUrl:
                                      '${ApiConstants.imageBaseUrl}${event.image}',
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            CustomText(
                                              text: event.title,
                                              maxLine: 2,
                                              textOverflow:
                                                  TextOverflow.ellipsis,
                                              fontWeight: FontWeight.w500,
                                            ),
                                            SizedBox(height: 4.h),
                                            CustomText(
                                              text: event.address,
                                              maxLine: 1,
                                              textOverflow:
                                                  TextOverflow.ellipsis,
                                              fontSize: 12.sp,
                                            ),
                                          ],
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () async {
                                          final favoriteEvent =
                                              _favoriteController
                                                  .favoriteEvents[index];
                                          _favoriteController.favoriteEvents
                                              .removeAt(index);
                                          await _favoriteController
                                              .removeFavorite(
                                                favoriteEvent.event.id,
                                              );
                                          // No message shown - just instant UI change
                                        },
                                        child: Icon(
                                          Icons.favorite,
                                          color: AppColors.primaryColor,
                                          size: 22.sp,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          );
        }),
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
