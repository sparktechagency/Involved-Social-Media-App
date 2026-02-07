import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:involved/controller/profile_controller.dart';
import 'package:involved/helpers/route.dart';
import 'package:involved/utils/app_colors.dart';
import 'package:involved/utils/app_icons.dart';
import 'package:involved/utils/app_images.dart';
import 'package:involved/utils/app_strings.dart';
import 'package:involved/views/base/custom_text.dart';
import 'package:involved/views/screen/Home/InnerWidget/all_tab.dart';
import '../../../controller/event_fields_controller.dart';
import '../../base/bottom_menu..dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  // Access your controller
  final EventFieldsController fieldsController = Get.put(EventFieldsController());
  TabController? _tabController;

  @override
  void initState() {
    super.initState();

    // Listen to changes in typesList to initialize TabController
    ever(fieldsController.typesList, (List<String> types) {
      if (types.isNotEmpty) {
        setState(() {
          // Length is dynamic items + 1 (for "All")
          _tabController = TabController(length: types.length + 1, vsync: this);
        });
      }
    });

    // Handle case where data might already be there
    if (fieldsController.typesList.isNotEmpty) {
      _tabController = TabController(length: fieldsController.typesList.length + 1, vsync: this);
    }
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // Show loader while fetching dynamic tab values
      if (fieldsController.isLoading.value || _tabController == null) {
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      }

      return Scaffold(
        bottomNavigationBar: BottomMenu(0),
        appBar: AppBar(
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset(AppImages.logo, width: 142.w, height: 64.h),
              InkWell(
                onTap: () => Get.toNamed(AppRoutes.notificationsScreen),
                child: SvgPicture.asset(AppIcons.notification),
              ),
            ],
          ),
          bottom: TabBar(
            isScrollable: true, // Set to true since dynamic lists can be long
            controller: _tabController,
            indicatorColor: AppColors.primaryColor,
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey,
            tabs: [
              // 1. Static "All" Tab
              Tab(child: CustomText(text: AppStrings.all.tr, fontSize: 12.sp)),

              // 2. Dynamic Tabs from API
              ...fieldsController.typesList.map((typeName) => Tab(
                child: CustomText(text: typeName.tr, fontSize: 12.sp),
              )),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            // Index 0: "All" - we pass empty string for type
            const AllTab(eventType: ""),

            // Dynamic types from the fields controller
            ...fieldsController.typesList.map((type) => AllTab(eventType: type)),
          ],
        ),
      );
    });
  }
}