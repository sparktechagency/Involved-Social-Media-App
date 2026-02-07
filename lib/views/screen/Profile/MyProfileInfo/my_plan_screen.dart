import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:involved/utils/app_colors.dart';
import 'package:involved/utils/app_strings.dart';
import 'package:involved/views/base/custom_app_bar.dart';
import 'package:involved/views/base/custom_network_image.dart';
import 'package:involved/views/base/custom_text.dart';

import '../../../../controller/collection_name_controller.dart';
import '../../../../service/api_constants.dart';

class MyPlanScreen extends StatefulWidget {
  const MyPlanScreen({super.key});

  @override
  State<MyPlanScreen> createState() => _MyPlanScreenState();
}

class _MyPlanScreenState extends State<MyPlanScreen> {
  // 1. Find the controller
  final CollectionController _controller = Get.find<CollectionController>();
  late String collectionName;

  @override
  void initState() {
    super.initState();
    // 2. Get the name passed from Profile (default to MY PLANS if null)
    collectionName = Get.arguments ?? AppStrings.mYPLANS.tr;

    // 3. Trigger the filter API
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.fetchEventsByCollection(collectionName);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: collectionName.toUpperCase()),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          children: [
            Expanded(
              child: Card(
                clipBehavior: Clip.antiAlias,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                elevation: 2,
                child: Obx(() {
                  // 4. Show loading state
                  if (_controller.isFilterLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  // 5. Show empty state
                  if (_controller.filteredEvents.isEmpty) {
                    return Center(
                      child: CustomText(text: "No events found in this collection"),
                    );
                  }

                  return ListView.builder(
                    itemCount: _controller.filteredEvents.length,
                    padding: EdgeInsets.symmetric(horizontal: 8.w),
                    itemBuilder: (context, index) {
                      final item = _controller.filteredEvents[index];
                      final event = item.event;

                      String fullImageUrl = event.image.startsWith('http')
                          ? event.image
                          : "${ApiConstants.imageBaseUrl}${event.image}";

                      return Column(
                        children: [
                          InkWell(
                            onTap: () {
                              showEventDetailsDialog(
                                context: context,
                                imageUrl: fullImageUrl,
                                title: event.title,
                                location: event.address,
                                // Note: Ensure your filter model has dateTime if needed
                                dateTime: "18/06/25 08:30PM",
                                venue: event.address,
                                description: "Description logic here...",
                              );
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 8.w),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomNetworkImage(
                                    imageUrl: fullImageUrl,
                                    height: 72.h,
                                    width: 72.w,
                                    borderRadius: BorderRadius.circular(4.r),
                                  ),
                                  SizedBox(width: 12.w),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        CustomText(
                                          text: event.title,
                                          fontWeight: FontWeight.w600,
                                          maxLine: 2,
                                          textAlign: TextAlign.start,
                                        ),
                                        SizedBox(height: 4.h),
                                        CustomText(
                                          text: event.address,
                                          fontSize: 12.sp,
                                          color: AppColors.greyColor,
                                        ),
                                      ],
                                    ),
                                  ),
                                  //========================> Real Status Label <==========================
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                                    decoration: BoxDecoration(
                                      // Using the primary color for status background
                                      color: AppColors.primaryColor,
                                      borderRadius: BorderRadius.circular(20.r),
                                    ),
                                    child: CustomText(
                                      text: item.status, // Real status (Interested/Going)
                                      color: Colors.white,
                                      fontSize: 10.sp,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          if (index != _controller.filteredEvents.length - 1)
                            const Divider(thickness: 1, color: Color(0xffEEEEEE)),
                        ],
                      );
                    },
                  );
                }),
              ),
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }

  //================================================> Alert Dialog Method <====================================
  void showEventDetailsDialog({
    required BuildContext context,
    required String imageUrl,
    required String title,
    required String location,
    required String dateTime,
    required String venue,
    required String description,
  }) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 24,
          ),
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
                      //===========================> Event Image <================
                      CustomNetworkImage(
                        imageUrl: imageUrl,
                        height: 180.h,
                        width: double.infinity,
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      SizedBox(height: 16.h),
                      //=======================> Title & Date Row <====================
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// Title & Location
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomText(
                                  text: title,
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                                SizedBox(height: 4.h),
                                CustomText(text: location, fontSize: 12.sp),
                              ],
                            ),
                          ),

                          /// Time
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              CustomText(text: dateTime),
                              const SizedBox(height: 4),
                              CustomText(
                                text: AppStrings.eventTime.tr,
                                fontSize: 12.sp,
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 20.h),
                      //===========================> Description Title <===========================
                      Align(
                        alignment: Alignment.centerLeft,
                        child: CustomText(
                          text: AppStrings.description.tr,
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 8.h),

                      /// Description Text
                      CustomText(
                        text: description,
                        maxLine: 20,
                        textAlign: TextAlign.start,
                      ),
                      SizedBox(height: 20.h),
                      //==================================> Location Info Container <============
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(12.w),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(color: AppColors.primaryColor),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              color: AppColors.primaryColor,
                            ),
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
                    ],
                  ),
                ),
              ),

              //=======================> Close Button <============================
              Positioned(
                top: -12,
                right: -12,
                child: GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: CircleAvatar(
                    radius: 16.r,
                    backgroundColor: Colors.red,
                    child: Icon(Icons.close, color: Colors.white, size: 16.w),
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
