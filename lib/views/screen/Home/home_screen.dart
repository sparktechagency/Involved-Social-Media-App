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
    _tabController = TabController(length: 6, vsync: this);
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
      length: 6,
      child: Scaffold(
        bottomNavigationBar: BottomMenu(0),
        appBar: AppBar(
          backgroundColor: Colors.white,
            automaticallyImplyLeading: false,
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
                child: Align(
                  alignment: Alignment.center,
                  child: CustomText(text: AppStrings.all.tr, fontSize: 12.sp),
                ),
              ),
              //========================> Reading Tab <====================
              Tab(
                child: Align(
                  alignment: Alignment.center,
                  child: CustomText(text: 'Reading'.tr, fontSize: 12.sp),
                ),
              ),
              //========================> Music Tab <====================
              Tab(
                child: Align(
                  alignment: Alignment.center,
                  child: CustomText(
                    text: 'Music'.tr,
                    fontSize: 12.sp,
                  ),
                ),
              ),
              //========================> Cooking Tab <====================
              Tab(
                child: Align(
                  alignment: Alignment.center,
                  child: CustomText(text: 'Cooking'.tr, fontSize: 12.sp),
                ),
              ),
              //========================> Special Events Tab <====================
              Tab(
                child: Align(
                  alignment: Alignment.center,
                  child: CustomText(text: 'Special Events'.tr, fontSize: 12.sp),
                ),
              ),
              //========================> Pets Tab <====================
              Tab(
                child: Align(
                  alignment: Alignment.center,
                  child: CustomText(text: 'Pets'.tr, fontSize: 12.sp),
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
              AllTab(),
            ],
          )
      ),
    );
  }
}
