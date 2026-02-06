import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:involved/utils/app_colors.dart';
import 'package:involved/utils/app_icons.dart';
import 'package:involved/utils/app_strings.dart';
import 'package:involved/views/base/custom_button.dart';
import 'package:involved/views/base/custom_list_tile.dart';
import 'package:involved/views/base/custom_network_image.dart';
import 'package:involved/views/base/custom_text.dart';

import '../../../../controller/event_controller.dart';
import '../../../../service/api_constants.dart';

class AllTab extends StatefulWidget {
  final String eventType;
  const AllTab({super.key, required this.eventType});

  @override
  State<AllTab> createState() => _AllTabState();
}

class _AllTabState extends State<AllTab> {
  // Unique controller for each tab to maintain independent lists/loading states
  late EventController eventController;

  @override
  void initState() {
    super.initState();
    // Use a unique tag for each type so tabs don't overwrite each other's data
    eventController = Get.put(EventController(), tag: widget.eventType);

    // Initial fetch
    eventController.fetchEvents(type: widget.eventType);
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
          shrinkWrap: true,
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(vertical: 20.w),
          itemCount: eventController.eventsList.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 12.h,
            crossAxisSpacing: 12.w,
            childAspectRatio: 0.57,
          ),
          itemBuilder: (context, index) {
            final event = eventController.eventsList[index];
            // Assuming you'll handle bookmarking logic later via a controller/API
            bool isBookmarked = false;
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
                  imageUrl: event.image,
                  title: event.title,
                  dateTime: "${event.startDate.day}/${event.startDate.month}/${event.startDate.year}",
                  venue: event.address,
                  description: event.description,
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
                          Icon(
                            isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                            color: isBookmarked ? AppColors.primaryColor : Colors.grey,
                            size: 22.sp,
                          ),
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
                          color: Color(0xffffefd1),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.circle, color: AppColors.primaryColor, size: 12.h),
                            SizedBox(width: 8.w),
                            CustomText(
                              text: 'Live',
                              color: AppColors.primaryColor,
                              fontWeight: FontWeight.w500,
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
                              onTap: () {},
                              text: AppStrings.interested.tr,
                              color: Color(0xffffefd1),
                                broderColor: Color(0xffffefd1),
                                textColor: AppColors.primaryColor
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Expanded(
                            child: CustomButton(
                              onTap: () {},
                              text: AppStrings.going.tr,
                              broderColor: Color(0xffffefd1),
                              textColor: AppColors.primaryColor,
                              color: Color(0xffffefd1),
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Expanded(
                            child: CustomButton(
                              onTap: () {
                                addFolderDialog();
                              },
                              text: AppStrings.add.tr,
                              color: Color(0xffffefd1),
                              broderColor: Color(0xffffefd1),
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
  void addFolderDialog() {
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                              onTap: ()=> Navigator.of(context).pop(),
                              child: Icon(Icons.arrow_back_ios_new_outlined, size: 16.w,)),
                          CustomText(
                            text: AppStrings.save,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                          ),
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
                      Container(
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
                              maxLine: 3,
                              textAlign: TextAlign.start,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 8.h),
                      CustomListTile(title: AppStrings.bACHELORETTEPARTY.tr, suffixIcon: SvgPicture.asset(AppIcons.rightArrow)),
                      CustomListTile(title: AppStrings.bESTDATENIGHTPLACE.tr, suffixIcon: SvgPicture.asset(AppIcons.rightArrow)),
                      CustomListTile(title: AppStrings.fAVORITES.tr, suffixIcon: SvgPicture.asset(AppIcons.rightArrow)),
                      SizedBox(height: 20.h),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}