import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:involved/utils/app_colors.dart';
import 'package:involved/utils/app_strings.dart';
import 'package:involved/views/base/custom_app_bar.dart';
import 'package:involved/views/base/custom_network_image.dart';
import 'package:involved/views/base/custom_text.dart';

class MyPlanScreen extends StatelessWidget {
  const MyPlanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: AppStrings.mYPLANS.tr),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            //================================> Event Section <========================
            Expanded(
              child: Card(
                clipBehavior: Clip.none,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                elevation: 2,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: 5,
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.all(12.w),
                      child: InkWell(
                        onTap: () {
                          showEventDetailsDialog(
                            context: context,
                            imageUrl:
                                'https://images.unsplash.com/photo-1546069901-ba9599a7e63c',
                            title: 'Pasta Making Class',
                            location: 'Dhaka Bangladesh',
                            dateTime: '18/06/25 08:30PM',
                            venue: 'Rampura Town Hall Dhaka Bangladesh',
                            description:
                                "The event is live as soon as it's posted. You can explore various categories and locations, or search by specific names, dates, and more. Whether you're attending a business launch, a community fundraiser, or an influencer meet-up, our platform",
                          );
                        },
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomNetworkImage(
                                  imageUrl:
                                      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTwaA8j3JXCUJK6s0E139bWxzBDGcLkBaAaZBUycCpQo-9_9JZf99E2r7QQrTKS7qyNNmk&usqp=CAU',
                                  height: 72.h,
                                  width: 72.w,
                                  borderRadius: BorderRadius.circular(4.r),
                                ),
                                SizedBox(width: 12.w),
                                //========================> Title Container <==========================
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      CustomText(
                                        text: 'Virginia Philips Wine Tasting',
                                        maxLine: 2,
                                        textAlign: TextAlign.start,
                                      ),
                                      SizedBox(height: 4.h),
                                      CustomText(
                                        text: 'Dhaka Bangladesh',
                                        color: AppColors.greyColor,
                                      ),
                                      SizedBox(height: 4.h),
                                      CustomText(
                                        text: '18/06/25 08:30PM',
                                        color: AppColors.greyColor,
                                      ),
                                    ],
                                  ),
                                ),
                                //========================> Status Container <==========================
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryColor,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: CustomText(
                                    text: 'Interested',
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                            Divider(thickness: 1.5, color: Colors.grey),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
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
