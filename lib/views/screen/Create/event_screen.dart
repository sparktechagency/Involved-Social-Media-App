import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:involved/helpers/route.dart';
import 'package:involved/utils/app_colors.dart';
import 'package:involved/utils/app_strings.dart';
import 'package:involved/views/base/bottom_menu..dart';
import 'package:involved/views/base/custom_network_image.dart';
import 'package:involved/views/base/custom_text.dart';

class EventScreen extends StatelessWidget {
  const EventScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomMenu(2),
      //===========================> Appbar Section <============================
      appBar: AppBar(
        title: CustomText(
          text: AppStrings.createEvent.tr,
          fontWeight: FontWeight.w500,
          fontSize: 16.sp,
        ),
        backgroundColor: Colors.white,
        leading: SizedBox(),
      ),
      //===========================> Body Section <=============================
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: 5,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      /*showEventDetailsDialog(
                        context: context,
                        imageUrl:
                        'https://images.unsplash.com/photo-1546069901-ba9599a7e63c',
                        title: 'Pasta Making Class',
                        location: 'Dhaka Bangladesh',
                        dateTime: '18/06/25 08:30PM',
                        venue: 'Rampura Town Hall Dhaka Bangladesh',
                        description:
                        "The event is live as soon as it's posted. You can explore various categories and locations, or search by specific names, dates, and more. Whether you're attending a business launch, a community fundraiser, or an influencer meet-up, our platform",
                      );*/
                     Get.toNamed(AppRoutes.eventDetailsScreen);
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
                            //===========================> Event Image <================
                            CustomNetworkImage(
                              imageUrl:
                                  'https://images.unsplash.com/photo-1546069901-ba9599a7e63c',
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      CustomText(
                                        text: 'Pasta Making Class',
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      SizedBox(height: 4.h),
                                      CustomText(
                                        text: 'Dhaka Bangladesh',
                                        fontSize: 12.sp,
                                      ),
                                    ],
                                  ),
                                ),

                                /// Time
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    CustomText(text: '18/06/25 08:30PM'),
                                    SizedBox(height: 4.h),
                                    CustomText(
                                      text: AppStrings.eventTime.tr,
                                      fontSize: 12.sp,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),

      //===========================> FloatingActionButton Section <=============================
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primaryColor,
        onPressed: () {
          Get.toNamed(AppRoutes.createEventScreen);
        },
        shape: const CircleBorder(),
        child: Icon(Icons.add, color: Colors.white),
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
