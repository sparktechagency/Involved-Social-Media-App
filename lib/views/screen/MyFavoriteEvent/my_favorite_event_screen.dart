import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:involved/utils/app_colors.dart';
import 'package:involved/utils/app_icons.dart';
import 'package:involved/utils/app_strings.dart';
import 'package:involved/views/base/custom_app_bar.dart';
import 'package:involved/views/base/custom_button.dart';
import 'package:involved/views/base/custom_list_tile.dart';
import 'package:involved/views/base/custom_network_image.dart';
import 'package:involved/views/base/custom_text.dart';

class MyFavoriteEventScreen extends StatefulWidget {
  const MyFavoriteEventScreen({super.key});

  @override
  State<MyFavoriteEventScreen> createState() => _MyFavoriteEventScreenState();
}

class _MyFavoriteEventScreenState extends State<MyFavoriteEventScreen> {
  final List<bool> bookmarkedList = List.generate(8, (_) => false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: AppStrings.myFavoriteEventList.tr),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          children: [
            Expanded(
              child: GridView.builder(
                padding: EdgeInsets.symmetric(vertical: 8.h),
                itemCount: bookmarkedList.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12.h,
                  crossAxisSpacing: 12.w,
                  childAspectRatio: 0.57,
                ),
                itemBuilder: (context, index) {
                  final isBookmarked = bookmarkedList[index];

                  return Material(
                    color: Colors.white,
                    elevation: 2,
                    borderRadius: BorderRadius.circular(12.r),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12.r),
                      onTap: () => showEventDetailsDialog(
                        context: context,
                        imageUrl:
                            'https://images.unsplash.com/photo-1546069901-ba9599a7e63c',
                        title: 'Pasta Making Class',
                        location: 'Dhaka, Bangladesh',
                        dateTime: '18/06/25 08:30PM',
                        venue: 'Rampura Town Hall Dhaka, Bangladesh',
                        description:
                            "The event is live as soon as it's posted. You can explore various categories and locations...",
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomNetworkImage(
                            imageUrl:
                                'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSeei1bJZYTGM66KOeKixxKnAAaGXqNATMBTS2Q7sBlERDOqPYHStLAXuTOXb3mn9aKFEw&usqp=CAU',
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      CustomText(
                                        text: 'Pasta Making Class',
                                        maxLine: 2,
                                        textOverflow: TextOverflow.ellipsis,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      SizedBox(height: 4.h),
                                      CustomText(
                                        text: 'Dhaka, Bangladesh',
                                        maxLine: 1,
                                        textOverflow: TextOverflow.ellipsis,
                                        fontSize: 12.sp,
                                      ),
                                    ],
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      bookmarkedList[index] =
                                          !bookmarkedList[index];
                                    });
                                  },
                                  child: Icon(
                                    isBookmarked
                                        ? Icons.bookmark
                                        : Icons.bookmark_border,
                                    color: isBookmarked
                                        ? AppColors.primaryColor
                                        : Colors.grey,
                                    size: 22.sp,
                                  ),
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
    required String location,
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
                                ),
                                SizedBox(height: 4.h),
                                CustomText(text: location, fontSize: 12.sp),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              CustomText(text: dateTime),
                              SizedBox(height: 4.h),
                              CustomText(
                                text: AppStrings.eventTime.tr,
                                fontSize: 12.sp,
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 20.h),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: CustomText(
                          text: AppStrings.description.tr,
                          fontWeight: FontWeight.w500,
                          fontSize: 16.sp,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      CustomText(
                        text: description,
                        maxLine: 20,
                        textAlign: TextAlign.start,
                      ),
                      SizedBox(height: 20.h),
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
                      SizedBox(height: 20.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: CustomButton(
                              onTap: () {},
                              text: AppStrings.interested.tr,
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Expanded(
                            child: CustomButton(
                              onTap: () {},
                              text: AppStrings.going.tr,
                              color: Colors.white,
                              textColor: AppColors.primaryColor,
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Expanded(
                            child: CustomButton(
                              onTap: () {
                                addFolderDialog();
                              },
                              text: AppStrings.add.tr,
                              color: Colors.white,
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
                top: -12,
                right: -12,
                child: GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: CircleAvatar(
                    radius: 16.r,
                    backgroundColor: Colors.red,
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
                            onTap: () => Navigator.of(context).pop(),
                            child: Icon(
                              Icons.arrow_back_ios_new_outlined,
                              size: 16.w,
                            ),
                          ),
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
                            Icon(
                              Icons.add_circle_outlined,
                              color: AppColors.primaryColor,
                            ),
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
                      CustomListTile(
                        title: AppStrings.bACHELORETTEPARTY.tr,
                        suffixIcon: SvgPicture.asset(AppIcons.rightArrow),
                      ),
                      CustomListTile(
                        title: AppStrings.bESTDATENIGHTPLACE.tr,
                        suffixIcon: SvgPicture.asset(AppIcons.rightArrow),
                      ),
                      CustomListTile(
                        title: AppStrings.fAVORITES.tr,
                        suffixIcon: SvgPicture.asset(AppIcons.rightArrow),
                      ),
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
