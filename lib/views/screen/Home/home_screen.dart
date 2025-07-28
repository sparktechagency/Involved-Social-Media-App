import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:involved/helpers/route.dart';
import 'package:involved/utils/app_colors.dart';
import 'package:involved/utils/app_icons.dart';
import 'package:involved/utils/app_images.dart';
import 'package:involved/utils/app_strings.dart';
import 'package:involved/views/base/custom_text.dart';
import 'package:involved/views/screen/Home/InnerWidget/all_tab.dart';
import '../../base/bottom_menu..dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _tabController.removeListener(() {});
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        bottomNavigationBar: BottomMenu(0),
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset(AppImages.logo, width: 142.w, height: 64.h),
              InkWell(
                onTap: () {
                  Get.toNamed(AppRoutes.notificationsScreen);
                },
                child: SvgPicture.asset(AppIcons.notification),
              ),
            ],
          ),
          bottom: TabBar(
            padding: EdgeInsets.zero,
            labelPadding: EdgeInsets.zero,
            indicatorPadding: EdgeInsets.zero,
            controller: _tabController,
            indicatorColor: AppColors.primaryColor,
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey,
            tabs: [
              //========================> All Tab <====================
              Tab(
                child: Container(
                  decoration: BoxDecoration(
                    color: _tabController.index == 0
                        ? const Color(0xFFebf9ff)
                        : Colors.transparent,
                  ),
                  child: Align(
                    alignment: Alignment.center,
                    child: CustomText(text: AppStrings.all.tr, fontSize: 12.sp),
                  ),
                ),
              ),
              //========================> Dining Tab <====================
              Tab(
                child: Container(
                  decoration: BoxDecoration(
                    color: _tabController.index == 1
                        ? const Color(0xFFebf9ff)
                        : Colors.transparent,
                  ),
                  child: Align(
                    alignment: Alignment.center,
                    child: CustomText(text: AppStrings.dining.tr, fontSize: 12.sp),
                  ),
                ),
              ),
              //========================> Entertainment Tab <====================
              Tab(
                child: Container(
                  decoration: BoxDecoration(
                    color: _tabController.index == 2
                        ? const Color(0xFFebf9ff)
                        : Colors.transparent,
                  ),
                  child: Align(
                    alignment: Alignment.center,
                    child: CustomText(
                      text: AppStrings.entertainment.tr,
                      fontSize: 12.sp,
                    ),
                  ),
                ),
              ),
              //========================> Activities Tab <====================
              Tab(
                child: Container(
                  decoration: BoxDecoration(
                    color: _tabController.index == 3
                        ? const Color(0xFFebf9ff)
                        : Colors.transparent,
                  ),
                  child: Align(
                    alignment: Alignment.center,
                    child: CustomText(text: AppStrings.activities.tr, fontSize: 12.sp),
                  ),
                ),
              ),
              //========================> Map Tab <====================
              Tab(
                child: Container(
                  decoration: BoxDecoration(
                    color: _tabController.index == 4
                        ? const Color(0xFFebf9ff)
                        : Colors.transparent,
                  ),
                  child: Align(
                    alignment: Alignment.center,
                    child: CustomText(text: AppStrings.map.tr, fontSize: 12.sp),
                  ),
                ),
              ),
            ],
          )),
          body:TabBarView(
            controller: _tabController,
            children:  [
              AllTab(),
              AllTab(),
              AllTab(),
              AllTab(),
              AllTab(),
            ],
          )
      ),
    );
  }
}
