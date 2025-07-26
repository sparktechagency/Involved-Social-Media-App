import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:involved/utils/app_colors.dart';
import 'package:involved/utils/app_icons.dart';
import 'package:timeago/timeago.dart' as TimeAgo;
import '../../../utils/app_strings.dart';
import '../../base/custom_app_bar.dart';
import '../../base/custom_text.dart';

class NotificationsScreen extends StatelessWidget {
  NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: AppStrings.notifications.tr),
      //================================> Body section <=======================
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.h),
        child: Column(
          children: [
            //================================> Notification section <=======================
            Expanded(
              child: ListView.builder(
                itemCount: 6,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.only(
                      bottom: 16.h,
                      top: index == 0 ? 16.h : 0,
                    ),
                    child: _Notification(
                      'Ariana your view this',
                      DateTime.now().subtract(Duration(minutes: index * 10)),
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
}

_Notification(String title, DateTime time) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 8.w),
    decoration: BoxDecoration(borderRadius: BorderRadius.circular(4.r)),
    child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              children: [
                //==============================> Notification Icon <=========================
                Container(
                  margin: EdgeInsets.only(right: 8.w),
                  padding: EdgeInsets.all(8.w),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xffffffff),
                  ),
                  child: SvgPicture.asset(
                    AppIcons.notification,
                    width: 32.w,
                    height: 32.h,
                  ),
                ),
              ],
            ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //==============================> Notification Text <=========================
                  CustomText(
                    text: title,
                    fontSize: 14.h,
                    maxLine: 3,
                    textAlign: TextAlign.start,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: CustomText(
                      top: 2.h,
                      text: TimeAgo.format(time),
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF8C8C8C),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        Divider(color: AppColors.textColor),
      ],
    ),
  );
}
