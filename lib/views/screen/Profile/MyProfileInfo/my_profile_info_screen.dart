import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:involved/controller/profile_controller.dart';
import 'package:involved/helpers/route.dart';
import 'package:involved/service/api_constants.dart';
import 'package:involved/utils/app_colors.dart';
import 'package:involved/utils/app_constants.dart';
import 'package:involved/utils/app_icons.dart';
import 'package:involved/utils/app_strings.dart';
import 'package:involved/views/base/custom_app_bar.dart';
import 'package:involved/views/base/custom_button.dart';
import 'package:involved/views/base/custom_network_image.dart';
import 'package:involved/views/base/custom_text.dart';

import '../../../../controller/collection_name_controller.dart';

class MyProfileInfoScreen extends StatelessWidget {
  const MyProfileInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ProfileController _profileController = Get.put(ProfileController());
    // 1. Initialize the CollectionController to get grouped data
    final CollectionController _collectionController = Get.put(CollectionController());

    return Scaffold(
      appBar: CustomAppBar(title: AppStrings.myProfile.tr),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Center(
                child: Column(
                  children: [
                    //====================> User Profile Image <====================
                    Obx(() {
                      final user = _profileController.userProfile.value;
                      return Stack(
                        children: [
                          CustomNetworkImage(
                            imageUrl: user?.image != null
                                ? '${ApiConstants.imageBaseUrl}${user?.image}'
                                : 'https://res.cloudinary.com/dl2okzz5j/image/upload/v1768475842/author_icon_udm2jo.png',
                            height: 145.h,
                            width: 145.w,
                            boxShape: BoxShape.circle,
                            border: Border.all(width: 4.w, color: const Color(0xffFFEFD1)),
                          ),
                          /*if (user?.isEmailVerified == true || user?.isPhoneVerified == true)
                            Positioned(
                                right: 10.w,
                                top: 10.h,
                                child: SvgPicture.asset(AppIcons.verify))*/
                        ],
                      );
                    }),
                    SizedBox(height: 12.h),
                    //=========================> User Name <========================
                    Obx(() {
                      final user = _profileController.userProfile.value;
                      return CustomText(
                        text: user?.name?.capitalize ?? 'User',
                        fontWeight: FontWeight.w600,
                        fontSize: 20.sp,
                      );
                    }),
                    SizedBox(height: 12.h),
                    //=========================> Edit Profile Button <========================
                    Obx(() {
                      final user = _profileController.userProfile.value;
                      return CustomButton(
                        onTap: () {
                          Get.toNamed(AppRoutes.editProfileScreen, parameters: {
                            'name': user?.name ?? 'Enter name',
                            'address': user?.address ?? 'Enter address',
                            'phone': user?.phone ?? '',
                          });
                        },
                        width: 98.w,
                        height: 36.h,
                        color: const Color(0xffFAE9CB),
                        textColor: AppColors.primaryColor,
                        text: AppStrings.editProfile.tr,
                      );
                    }),
                    SizedBox(height: 12.h),
                  ],
                ),
              ),
            ),
          ),

          //=========================> Real Grouped Event GridView <========================
          Obx(() {
            // Show loading indicator if data is being fetched
            if (_collectionController.isLoading.value && _collectionController.groupedCollections.isEmpty) {
              return const SliverFillRemaining(
                child: Center(child: CircularProgressIndicator()),
              );
            }

            // Show empty state if no collections found
            if (_collectionController.groupedCollections.isEmpty) {
              return SliverFillRemaining(
                child: Center(child: CustomText(text: "No collections found")),
              );
            }

            return SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
              sliver: SliverGrid(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12.w, // Slightly increased spacing
                  crossAxisSpacing: 12.h,
                  childAspectRatio: 0.75,
                ),
                delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                    // Get real item from controller
                    final item = _collectionController.groupedCollections[index];

                    // Construct image URL
                    String fullImageUrl = item.event.image.startsWith('http')
                        ? item.event.image
                        : "${ApiConstants.imageBaseUrl}${item.event.image}";

                    return _buildCard(
                      context,
                      onTab: () {
                        // Pass the collection name to the next screen to filter events
                        Get.toNamed(AppRoutes.myPlanScreen, arguments: item.collectionName);
                      },
                      image: fullImageUrl,
                      label: item.collectionName,
                    );
                  },
                  childCount: _collectionController.groupedCollections.length,
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  //==========================================> Build Card <==================================
  Widget _buildCard(BuildContext context,
      {required VoidCallback onTab, required String image, required String label}) {
    return GestureDetector(
      onTap: onTab,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14.r),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(8.r),
              child: CustomText(
                text: label.toUpperCase(), // Using uppercase to match your style
                fontWeight: FontWeight.w700,
                fontSize: 12.sp,
                maxLine: 1,
                textOverflow: TextOverflow.ellipsis,
              ),
            ),
            Expanded(
              child: CustomNetworkImage(
                imageUrl: image,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(14.r),
                  bottomRight: Radius.circular(14.r),
                ),
                width: double.infinity,
                height: double.infinity,
              ),
            ),
          ],
        ),
      ),
    );
  }
}