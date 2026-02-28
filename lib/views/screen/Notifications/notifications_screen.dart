import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:involved/controller/notification_controller.dart';
import 'package:involved/utils/app_colors.dart';
import 'package:involved/utils/app_icons.dart';
import 'package:timeago/timeago.dart' as TimeAgo;
import '../../../utils/app_strings.dart';
import '../../base/custom_app_bar.dart';
import '../../base/custom_text.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  late NotificationController _notificationController;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _notificationController = Get.put(NotificationController());
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _notificationController.loadMore();
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: AppStrings.notifications.tr),
      //================================> Body section <=======================
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.h),
        child: Obx(() {
          if (_notificationController.isLoading.value &&
              _notificationController.notifications.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (_notificationController.notifications.isEmpty) {
            return Center(
              child: CustomText(
                text: 'No notifications found',
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
              ),
            );
          }

          return ListView.builder(
            controller: _scrollController,
            itemCount: _notificationController.notifications.length +
                (_notificationController.hasMoreData.value ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == _notificationController.notifications.length) {
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  child: const Center(child: CircularProgressIndicator()),
                );
              }

              final notification =
                  _notificationController.notifications[index];
              return Padding(
                padding: EdgeInsets.only(
                  bottom: 16.h,
                  top: index == 0 ? 16.h : 0,
                ),
                child: _notificationTile(notification.title,
                    notification.description, notification.createdAt),
              );
            },
          );
        }),
      ),
    );
  }
}

Widget _notificationTile(String title, String description, DateTime time) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 8.w),
    decoration: BoxDecoration(borderRadius: BorderRadius.circular(4.r)),
    child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
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
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //==============================> Notification Title <=========================
                  CustomText(
                    text: title,
                    fontSize: 14.h,
                    maxLine: 3,
                    fontWeight: FontWeight.w500,
                    textAlign: TextAlign.start,
                  ),
                  //==============================> Notification Description <=========================
                  CustomText(
                    top: 2.h,
                    text: description,
                    fontSize: 12.h,
                    maxLine: 2,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF8C8C8C),
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
