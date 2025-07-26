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
    return index == menuIndex ? Colors.white : theme.disabledColor;
  }

  BottomNavigationBarItem getItem(
      String image, String title, ThemeData theme, int index) {
    return BottomNavigationBarItem(
        label: title,
        icon: Padding(
          padding: const EdgeInsets.only(top:8),
          child: SvgPicture.asset(
            image,
            height: 24.0,
            width: 24.0,
            color: colorByIndex(theme, index),
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    List<BottomNavigationBarItem> menuItems = [
      getItem(menuIndex ==0 ? AppIcons.homeOut: AppIcons.homeOut, 'Home', theme, 0),
      getItem(menuIndex ==0 ? AppIcons.search: AppIcons.search, 'Search', theme, 1),
      getItem( menuIndex ==1 ? AppIcons.addFill :  AppIcons.addFill, 'Create', theme, 2),
      getItem( menuIndex ==1 ? AppIcons.calender :  AppIcons.calender, 'Calendar', theme, 3),
      getItem(menuIndex ==2 ? AppIcons.profileOutline: AppIcons.profileOutline, 'Profile', theme, 4),
    ];

    return Container(

      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(20.r),topLeft: Radius.circular(20.r)
          ),
          boxShadow: const [
            BoxShadow(color:Colors.black38,spreadRadius:0,blurRadius: 10)
          ]
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(20.r),topLeft: Radius.circular(20.r)

        ),
        child: BottomNavigationBar(
           backgroundColor: AppColors.primaryColor,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: AppColors.backgroundColor,
          currentIndex: menuIndex,
          onTap: (value) {
            switch (value) {
              case 0:
                Get.offAndToNamed(AppRoutes.homeScreen);
                break;
              case 1:
                Get.offAndToNamed(AppRoutes.categoriesScreen);
                break;
              case 2:
                Get.offAndToNamed(AppRoutes.categoriesScreen);
                break;
              case 3:
                Get.offAndToNamed(AppRoutes.categoriesScreen);
                break;
              case 4:
                Get.offAndToNamed(AppRoutes.profileScreen);
                break;
            }
          },
          items: menuItems,
        ),
      ),
    );
  }
}