import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../helpers/route.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_icons.dart';

class BottomMenu extends StatelessWidget {
  final int menuIndex;
  const BottomMenu(this.menuIndex, {super.key});

  @override
  Widget build(BuildContext context) {
    final items = [
      {
        "icon": AppIcons.homeOut ?? 'assets/icons/default_home.svg',
        "activeIcon": AppIcons.homeOut ?? 'assets/icons/default_home.svg',
        "route": AppRoutes.homeScreen,
      },
      {
        "icon": AppIcons.search ?? 'assets/icons/default_search.svg',
        "activeIcon": AppIcons.search ?? 'assets/icons/default_search.svg',
        "route": AppRoutes.searchScreen,
      },
      {
        "icon": AppIcons.addFill ?? 'assets/icons/default_add.svg',
        "activeIcon": AppIcons.addFill ?? 'assets/icons/default_add.svg',
        "route": AppRoutes.eventScreen,
      },
      {
        "icon": AppIcons.calender ?? 'assets/icons/default_calendar.svg',
        "activeIcon": AppIcons.calender ?? 'assets/icons/default_calendar.svg',
        "route": AppRoutes.calenderScreen,
      },
      {
        "icon": AppIcons.profileOutline ?? 'assets/icons/default_profile.svg',
        "activeIcon": AppIcons.profileOutline ?? 'assets/icons/default_profile.svg',
        "route": AppRoutes.profileScreen,
      },
    ];

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
      margin: EdgeInsets.only(left: 20.w, right: 20.w, bottom: 48.h),
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
          return GestureDetector(
            onTap: () => Get.offAndToNamed(item["route"] as String),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  isSelected ? item["activeIcon"]! : item["icon"]!,
                  height: 24.h,
                  width: 24.w,
                  color: AppColors.primaryColor,
                ),
                SizedBox(height: 8.h),
                isSelected ?
                Container(
                  height: 3.h,
                  width: 32.w,
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primaryColor : Colors.transparent,
                    borderRadius: BorderRadius.circular(1.r),
                  ),
                ): SizedBox(),

              ],
            ),
          );
        }),
      ),
    );
  }
}