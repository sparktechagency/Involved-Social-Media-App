import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:involved/views/base/custom_network_image.dart';
import '../../helpers/route.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_icons.dart';

class BottomMenu extends StatelessWidget {
  final int menuIndex;
  final String? profileImageUrl;
  const BottomMenu(this.menuIndex, {this.profileImageUrl, super.key});

  @override
  Widget build(BuildContext context) {
    final items = [
      {
        "icon": AppIcons.homeOut ?? 'assets/icons/default_home.svg',
        "route": AppRoutes.homeScreen,
      },
      {
        "icon": AppIcons.search ?? 'assets/icons/default_search.svg',
        "route": AppRoutes.searchScreen,
      },
      {
        "icon": AppIcons.addFill ?? 'assets/icons/default_add.svg',
        "route": AppRoutes.eventScreen,
      },
      {
        "icon": AppIcons.calender ?? 'assets/icons/default_calendar.svg',
        "route": AppRoutes.calenderScreen,
      },
      {
        "route": AppRoutes.profileScreen,
      },
    ];

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 18.h),
      margin: EdgeInsets.only(left: 20.w, right: 20.w, bottom: 58.h),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(color: AppColors.primaryColor.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(items.length, (index) {
          final isSelected = index == menuIndex;
          final item = items[index];
          final isProfileRoute = item["route"] == AppRoutes.profileScreen;

          return GestureDetector(
            onTap: () => Get.offAndToNamed(item["route"] as String),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (isProfileRoute)
                  CustomNetworkImage(
                    imageUrl: profileImageUrl ?? 'https://images.rawpixel.com/image_800/czNmcy1wcml2YXRlL3Jhd3BpeGVsX2ltYWdlcy93ZWJzaXRlX2NvbnRlbnQvbHIvcm0zMjgtMzY2LXRvbmctMDhfMS5qcGc.jpg',
                    boxShape: BoxShape.circle,
                    border: Border.all(width: 1.w, color: AppColors.primaryColor),
                    height: 28.h,
                    width: 28.h,
                  )
                else
                  SvgPicture.asset(
                    item["icon"]!,
                    height: 28.h,
                    width: 28.w,
                    color: AppColors.primaryColor,
                  ),
                SizedBox(height: 8.h),
                if (isSelected)
                  Container(
                    height: 3.h,
                    width: 32.w,
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      borderRadius: BorderRadius.circular(1.r),
                    ),
                  )
                else
                  SizedBox(),
              ],
            ),
          );
        }),
      ),
    );
  }
}