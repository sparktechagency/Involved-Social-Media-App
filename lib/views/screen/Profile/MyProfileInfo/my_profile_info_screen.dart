import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:involved/controller/profile_controller.dart';
import 'package:involved/helpers/route.dart';
import 'package:involved/utils/app_colors.dart';
import 'package:involved/utils/app_icons.dart';
import 'package:involved/utils/app_strings.dart';
import 'package:involved/views/base/custom_app_bar.dart';
import 'package:involved/views/base/custom_button.dart';
import 'package:involved/views/base/custom_network_image.dart';
import 'package:involved/views/base/custom_text.dart';

class MyProfileInfoScreen extends StatelessWidget {
  const MyProfileInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ProfileController _controller = Get.put(ProfileController());
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
                      final user = _controller.userProfile.value;
                      return Stack(
                        children: [
                          CustomNetworkImage(
                            imageUrl: user?.image ?? 'https://res.cloudinary.com/dl2okzz5j/image/upload/v1768475842/author_icon_udm2jo.png',
                            height: 145.h,
                            width: 145.w,
                            boxShape: BoxShape.circle,
                            border: Border.all(width: 4.w, color: Color(0xffFFEFD1)),
                          ),
                          if (user?.isEmailVerified == true || user?.isPhoneVerified == true)
                            Positioned(
                                right: 10.w,
                                top: 10.h,
                                child: SvgPicture.asset(AppIcons.verify))
                        ],
                      );
                    }),
                    SizedBox(height: 12.h),
                    //=========================> User Name <========================
                    Obx(() {
                      final user = _controller.userProfile.value;
                      return CustomText(
                        text: user?.name?.capitalize ?? 'User',
                        fontWeight: FontWeight.w600,
                        fontSize: 20.sp,
                      );
                    }),
                    SizedBox(height: 12.h),
                    //=========================> Edit Profile Button <========================
                    Obx(() {
                      final user = _controller.userProfile.value;
                      return CustomButton(
                        onTap: () {
                          Get.toNamed(AppRoutes.editProfileScreen, parameters: {
                            'name': user?.name ?? 'Enter  name',
                            'address': user?.address ?? 'Enter address',
                            'phone': '', // phone field doesn't exist in user model
                          });
                        },
                        width: 98.w,
                        height: 36.h,
                        color: Color(0xffFAE9CB),
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
          //=========================> Event GridView <========================
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            sliver: SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 8.w,
                crossAxisSpacing: 8.h,
                childAspectRatio: 0.75,
              ),
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  List<Map<String, dynamic>> cardData = [
                    {
                      'onTab': () => Get.toNamed(AppRoutes.myPlanScreen),
                      'image': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSeei1bJZYTGM66KOeKixxKnAAaGXqNATMBTS2Q7sBlERDOqPYHStLAXuTOXb3mn9aKFEw&usqp=CAU',
                      'label': AppStrings.mYPLANS.tr,
                    },
                    {
                      'onTab': () {},
                      'image': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRyvetnLOz5AF4JPJGxqw0EJpwpBHl9swwqww&s',
                      'label': AppStrings.bACHELORETTEPARTY.tr,
                    },
                    {
                      'onTab': () {},
                      'image': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTYI-hLybIa7uE5KPYs9Cy1j_LBylAH3KoK-mKy_zVxV2S1i6zdm2pyLYHnU83ZKAHDlww&usqp=CAU',
                      'label': AppStrings.bESTDATE.tr,
                    },
                    {
                      'onTab': () {},
                      'image': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSeei1bJZYTGM66KOeKixxKnAAaGXqNATMBTS2Q7sBlERDOqPYHStLAXuTOXb3mn9aKFEw&usqp=CAU',
                      'label': AppStrings.fAVORITES.tr,
                    },
                  ];

                  var data = cardData[index];
                  return _buildCard(
                    context,
                    onTab: data['onTab'],
                    image: data['image'],
                    label: data['label'],
                  );
                },
                childCount: 4,
              ),
            ),
          ),
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
        padding: EdgeInsets.all(8.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              text: label,
              textAlign: TextAlign.center,
              fontWeight: FontWeight.w700,
              fontSize: 12.sp,
              maxLine: 2,
              textOverflow: TextOverflow.ellipsis,
            ),
             // This adds flexible space between text and image
            Expanded(
              child: CustomNetworkImage(
                imageUrl: image,
                borderRadius: BorderRadius.circular(14.r),
                 height:240.h, width: 173.w, // This will make the image fit properly in the available space
              ),
            ),
          ],
        ),
      ),
    );
  }
}
