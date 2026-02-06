import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:involved/helpers/route.dart';
import 'package:involved/utils/app_colors.dart';
import 'package:involved/utils/app_strings.dart';
import 'package:involved/views/base/bottom_menu..dart';
import 'package:involved/views/base/custom_network_image.dart';
import 'package:involved/views/base/custom_text.dart';
import '../../../controller/self_event_controller.dart';
import '../../../service/api_constants.dart';

class EventScreen extends StatelessWidget {
  const EventScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize the controller
    final SelfEventController controller = Get.put(SelfEventController());
    final ScrollController scrollController = ScrollController();

    // Setup infinite scroll listener
    scrollController.addListener(() {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
        controller.loadMore();
      }
    });

    return Scaffold(
      bottomNavigationBar: BottomMenu(2),
      appBar: AppBar(
        title: CustomText(
          text: AppStrings.createEvent.tr,
          fontWeight: FontWeight.w500,
          fontSize: 16.sp,
        ),
        backgroundColor: Colors.white,
        leading: const SizedBox(),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Obx(() {
          // Full screen loader only for initial fetch
          if (controller.isLoading.value && controller.selfEventsList.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.selfEventsList.isEmpty) {
            return Center(child: CustomText(text: "No events found"));
          }

          return RefreshIndicator(
            onRefresh: () => controller.refreshEvents(),
            child: ListView.builder(
              controller: scrollController,
              padding: EdgeInsets.only(top: 8.h, bottom: 20.h),
              itemCount: controller.selfEventsList.length + (controller.isLoading.value ? 1 : 0),
              itemBuilder: (context, index) {
                // Show a small loader at the bottom when fetching next page
                if (index == controller.selfEventsList.length) {
                  return const Center(child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: CircularProgressIndicator(),
                  ));
                }

                final event = controller.selfEventsList[index];

                // Construct Image URL
                String fullImageUrl = event.image.startsWith('http')
                    ? event.image
                    : "${ApiConstants.imageBaseUrl}${event.image}";

                // Format Date
                String formattedDate = DateFormat('dd/MM/yy hh:mm a').format(event.startDate);

                return Padding(
                  padding: EdgeInsets.only(bottom: 12.h),
                  child: InkWell(
                    onTap: () {
                      showEventDetailsDialog(
                        context: context,
                        imageUrl: fullImageUrl,
                        title: event.title,
                        location: event.address,
                        dateTime: formattedDate,
                        venue: event.address, // Or specific venue field if available
                        description: event.description,
                      );
                    },
                    child: Card(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          width: 1.w,
                          color: AppColors.primaryColor,
                        ),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      elevation: 5,
                      child: Padding(
                        padding: EdgeInsets.all(14.w),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CustomNetworkImage(
                              imageUrl: fullImageUrl,
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
                                        text: event.title,
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w500,
                                        maxLine: 1,
                                        textOverflow: TextOverflow.ellipsis,
                                      ),
                                      SizedBox(height: 4.h),
                                      CustomText(
                                        text: event.address,
                                        fontSize: 12.sp,
                                        maxLine: 1,
                                        textOverflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    CustomText(
                                      text: formattedDate,
                                      fontSize: 12.sp,
                                    ),
                                    SizedBox(height: 4.h),
                                    CustomText(
                                      text: AppStrings.eventTime.tr,
                                      fontSize: 12.sp,
                                      color: Colors.grey,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        }),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primaryColor,
        onPressed: () => Get.toNamed(AppRoutes.createEventScreen),
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Colors.white),
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
