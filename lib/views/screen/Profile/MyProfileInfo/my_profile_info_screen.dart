import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:involved/helpers/route.dart';
import 'package:involved/utils/app_strings.dart';
import 'package:involved/views/base/custom_app_bar.dart';
import 'package:involved/views/base/custom_button.dart';
import 'package:involved/views/base/custom_network_image.dart';
import 'package:involved/views/base/custom_text.dart';

class MyProfileInfoScreen extends StatelessWidget {
  const MyProfileInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: AppStrings.myProfile.tr),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Center(
            child: Column(
              children: [
                //====================> User Profile Image <====================
                CustomNetworkImage(
                  imageUrl:
                      'https://t4.ftcdn.net/jpg/02/24/86/95/360_F_224869519_aRaeLneqALfPNBzg0xxMZXghtvBXkfIA.jpg',
                  height: 145.h,
                  width: 145.w,
                  boxShape: BoxShape.circle,
                  border: Border.all(width: 4.w, color: Color(0xffFFEFD1)),
                ),
                SizedBox(height: 12.h),
                //=========================> User Name <========================
                CustomText(
                  text: 'Bashar Islam',
                  fontWeight: FontWeight.w600,
                  fontSize: 20.sp,
                ),
                SizedBox(height: 12.h),
                //=========================> Edit Profile Button <========================
                CustomButton(
                  onTap: () {
                    Get.toNamed(AppRoutes.editProfileScreen);
                  },
                  width: 98.w,
                  height: 36.h,
                  text: AppStrings.editProfile.tr,
                ),
                SizedBox(height: 12.h),
                //=========================> Event GridView <========================
                GridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16.w,
                  crossAxisSpacing: 16.h,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  childAspectRatio: 0.85,
                  children: [
                    _buildCard(
                      onTab: (){
                        Get.toNamed(AppRoutes.myPlanScreen);
                      },
                      context,
                      image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSeei1bJZYTGM66KOeKixxKnAAaGXqNATMBTS2Q7sBlERDOqPYHStLAXuTOXb3mn9aKFEw&usqp=CAU',
                      label: AppStrings.mYPLANS.tr,
                    ),
                    _buildCard(
                      onTab: (){},
                      context,
                      image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRyvetnLOz5AF4JPJGxqw0EJpwpBHl9swwqww&s',
                      label: AppStrings.bACHELORETTEPARTY.tr,
                    ),
                    _buildCard(
                      onTab: (){},
                      context,
                      image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTYI-hLybIa7uE5KPYs9Cy1j_LBylAH3KoK-mKy_zVxV2S1i6zdm2pyLYHnU83ZKAHDlww&usqp=CAU',
                      label: AppStrings.bESTDATE.tr,
                    ),
                    _buildCard(
                      onTab: (){},
                      context,
                      image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSeei1bJZYTGM66KOeKixxKnAAaGXqNATMBTS2Q7sBlERDOqPYHStLAXuTOXb3mn9aKFEw&usqp=CAU',
                      label: AppStrings.fAVORITES.tr,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  //==========================================> Build Card <==================================
  Widget _buildCard(BuildContext context,
      {required VoidCallback onTab,required String image, required String label}) {
    return GestureDetector(
      onTap: onTab,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14.r),
          image: DecorationImage(
            image: NetworkImage(image),
            fit: BoxFit.cover,
          ),
        ),
        alignment: Alignment.bottomCenter,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.green.withOpacity(0.85),
            borderRadius: BorderRadius.circular(14.r),
          ),
          padding: EdgeInsets.symmetric(vertical: 12.h),
          width: double.infinity,
          child: CustomText(
            text: label,
            textAlign: TextAlign.center,
              color: Colors.white,
              fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
