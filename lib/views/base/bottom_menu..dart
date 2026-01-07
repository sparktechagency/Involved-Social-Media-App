/*
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

  Color colorByIndex(ThemeData theme, int index) {
    return index == menuIndex ? Color(0xffFFEFD1) : theme.disabledColor;
  }

  BottomNavigationBarItem getItem(
      String image, String title, ThemeData theme, int index) {
    bool isSelected = index == menuIndex;
    return BottomNavigationBarItem(
        label: title,
        icon: Padding(
          padding: const EdgeInsets.only(top:8),
          child: Column(
            children: [
              SvgPicture.asset(
                image,
                height: 24.0,
                width: 24.0,
              ),
              SizedBox(height: 5.h),
              Container(
                height: 3.h,
                width: 32.w,
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primaryColor : Colors.transparent,
                  borderRadius: BorderRadius.circular(1.r),
                ),
              ),
            ],
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    List<BottomNavigationBarItem> menuItems = [
      getItem(menuIndex ==0 ? AppIcons.homeOut: AppIcons.homeOut, 'Home', theme, 0),
      getItem(menuIndex ==1 ? AppIcons.search: AppIcons.search, 'Search', theme, 1),
      getItem( menuIndex ==2 ? AppIcons.addFill :  AppIcons.addFill, 'Create', theme, 2),
      getItem( menuIndex ==3 ? AppIcons.calender :  AppIcons.calender, 'Calendar', theme, 3),
      getItem(menuIndex ==4 ? AppIcons.profileOutline: AppIcons.profileOutline, 'Profile', theme, 4),
    ];
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(width: 1.w, color: AppColors.primaryColor),
            boxShadow: const [
              BoxShadow(color:Colors.black38,spreadRadius:0,blurRadius: 10)
            ]
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20.r),
          child: BottomNavigationBar(
             backgroundColor: AppColors.whiteColor,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: Color(0xffFFEFD1),
            currentIndex: menuIndex,
            onTap: (value) {
              switch (value) {
                case 0:
                  Get.offAndToNamed(AppRoutes.homeScreen);
                  break;
                case 1:
                  Get.offAndToNamed(AppRoutes.searchScreen);
                  break;
                case 2:
                  Get.offAndToNamed(AppRoutes.eventScreen);
                  break;
                case 3:
                  Get.offAndToNamed(AppRoutes.calenderScreen);
                  break;
                case 4:
                  Get.offAndToNamed(AppRoutes.profileScreen);
                  break;
              }
            },
            items: menuItems,
          ),
        ),
      ),
    );
  }
}*/

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

  Color colorByIndex(ThemeData theme, int index) {
    return index == menuIndex ? Color(0xffFFEFD1) : theme.disabledColor;
  }

  BottomNavigationBarItem getItem(
      String image, String title, ThemeData theme, int index) {
    bool isSelected = index == menuIndex;
    return BottomNavigationBarItem(
        label: title,
        icon: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SizedBox(height: 5.h),
            Container(
              height: 3.h,
              width: 32.w,
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primaryColor : Colors.transparent,
                borderRadius: BorderRadius.circular(1.r),
              ),
            ),
            SizedBox(height: 5.h),
            SvgPicture.asset(
              image,
              height: 24.0,
              width: 24.0,
              color: AppColors.primaryColor,
            ),
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    List<BottomNavigationBarItem> menuItems = [
      getItem(menuIndex == 0 ? AppIcons.homeOut : AppIcons.homeOut, 'Home'.tr, theme, 0),
      getItem(menuIndex == 1 ? AppIcons.search : AppIcons.search, 'Search'.tr, theme, 1),
      getItem(menuIndex == 2 ? AppIcons.addFill : AppIcons.addFill, 'Create'.tr, theme, 2),
      getItem(menuIndex == 3 ? AppIcons.calender : AppIcons.calender,'Calender'.tr, theme, 3),
      getItem(menuIndex == 4 ? AppIcons.profileOutline : AppIcons.profileOutline,'Profile'.tr, theme, 4),
    ];
    return Padding(
      padding: EdgeInsets.only(top: 8.h, left: 20.w, right: 20.w, bottom: 20.h),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(width: 1.w, color: AppColors.primaryColor),
            boxShadow: [
              BoxShadow(color: Colors.black38, spreadRadius: 2, blurRadius: 10.r)
            ]),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20.r),
          child: BottomNavigationBar(
            backgroundColor: AppColors.whiteColor,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: AppColors.primaryColor,
            currentIndex: menuIndex,
            onTap: (value) {
              switch (value) {
                case 0:
                  Get.offAndToNamed(AppRoutes.homeScreen);
                  break;
                case 1:
                  Get.offAndToNamed(AppRoutes.searchScreen);
                  break;
                case 2:
                  Get.offAndToNamed(AppRoutes.eventScreen);
                  break;
                case 3:
                  Get.offAndToNamed(AppRoutes.calenderScreen);
                  break;
                case 4:
                  Get.offAndToNamed(AppRoutes.profileScreen);
                  break;
              }
            },
            items: menuItems,
          ),
        ),
      ),
    );
  }
}