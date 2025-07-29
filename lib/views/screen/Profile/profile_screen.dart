import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:involved/utils/app_icons.dart';
import 'package:involved/utils/app_strings.dart';
import 'package:involved/views/base/custom_list_tile.dart';
import 'package:involved/views/base/custom_network_image.dart';
import '../../../controller/profile_controller.dart';
import '../../../helpers/route.dart';
import '../../../utils/app_colors.dart';
import '../../base/bottom_menu..dart';
import '../../base/custom_button.dart';
import '../../base/custom_text.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ProfileController _controller = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomMenu(4),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 65.h),
          child: Column(
            children: [
              CustomText(
                text: AppStrings.profile.tr,
                fontWeight: FontWeight.w600,
                fontSize: 20.sp,
              ),
              SizedBox(height: 24.h),
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
              SizedBox(height: 24.h),
              //===================================> List Tile Card <==========================================
              Card(
                elevation: 5.5,
                shadowColor: AppColors.primaryColor,
                color: Colors.white,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 14.w,
                    vertical: 16.h,
                  ),
                  child: Center(
                    child: Column(
                      children: [
                        //===================> Subscription Container <=================
                        Container(
                          decoration: BoxDecoration(
                            color: AppColors.backgroundColor,
                            borderRadius: BorderRadius.circular(12.r),
                            border: Border.all(
                              width: 2.w,
                              color: AppColors.primaryColor,
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(12.w),
                            child: Row(
                              children: [
                                SvgPicture.asset(AppIcons.sub),
                                SizedBox(width: 8.w),
                                //===================> Subscription Pack <================
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CustomText(
                                      text: AppStrings.mySubscription.tr,
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    CustomText(
                                      text: AppStrings.manageYourSubscription.tr,
                                      fontSize: 12.sp,
                                    ),
                                  ],
                                ),
                                Spacer(),
                                //===================> Explore Button <================
                                CustomButton(
                                  onTap: () {
                                   // Get.toNamed(AppRoutes.subscriptionScreen);
                                  },
                                  text: 'Explore'.tr,
                                  fontSize: 10.sp,
                                  width: 80.w,
                                  height: 27.h,
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 16.h),
                        //===================> Personal Information ListTile <=================
                        CustomListTile(
                          onTap: () {
                            // Get.toNamed(AppRoutes.);
                          },
                          title: AppStrings.myProfile.tr,
                          prefixIcon: SvgPicture.asset(AppIcons.user),
                          suffixIcon: SvgPicture.asset(AppIcons.rightArrow),
                        ),
                        //===================> My Wallet ListTile <=================
                        CustomListTile(
                          onTap: () {
                            // Get.toNamed(AppRoutes.);
                          },
                          title: AppStrings.myFavoriteEventList.tr,
                          prefixIcon: SvgPicture.asset(AppIcons.event),
                          suffixIcon: SvgPicture.asset(AppIcons.rightArrow),
                        ),
                        //===================> Change Password ListTile <=================
                        CustomListTile(
                          onTap: () {
                            Get.toNamed(AppRoutes.changePasswordScreen);
                          },
                          title: AppStrings.changePassword.tr,
                          prefixIcon: SvgPicture.asset(AppIcons.key),
                          suffixIcon: SvgPicture.asset(AppIcons.rightArrow),
                        ),
                        //===================> Privacy Policy ListTile <=================
                        CustomListTile(
                          onTap: () {
                            Get.toNamed(AppRoutes.privacyPolicyScreen);
                          },
                          title: AppStrings.privacyPolicy.tr,
                          prefixIcon: SvgPicture.asset(AppIcons.privacy),
                          suffixIcon: SvgPicture.asset(AppIcons.rightArrow),
                        ),
                        //===================> Terms & Conditions ListTile <=================
                        CustomListTile(
                          onTap: () {
                            Get.toNamed(AppRoutes.termsServicesScreen);
                          },
                          title: AppStrings.termsConditions.tr,
                          prefixIcon: SvgPicture.asset(AppIcons.terms),
                          suffixIcon: SvgPicture.asset(AppIcons.rightArrow),
                        ),
                        //===================> About Us ListTile <=================
                        CustomListTile(
                          onTap: () {
                            Get.toNamed(AppRoutes.aboutUsScreen);
                          },
                          title: AppStrings.aboutUs.tr,
                          prefixIcon: SvgPicture.asset(AppIcons.about),
                          suffixIcon: SvgPicture.asset(AppIcons.rightArrow),
                        ),
                        //===================> Logout ListTile <=================
                        CustomListTile(
                          onTap: () {
                            _showCustomBottomSheet(context);
                          },
                          title: AppStrings.logout.tr,
                          prefixIcon: SvgPicture.asset(AppIcons.log),
                          suffixIcon: SvgPicture.asset(AppIcons.rightArrow),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //===============================> Log Out Bottom Sheet <===============================
  _showCustomBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (BuildContext context) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24.r),
              topRight: Radius.circular(24.r),
            ),
            border: Border(
              top: BorderSide(width: 2.w, color: AppColors.primaryColor),
            ),
            color: AppColors.whiteColor,
          ),
          padding: EdgeInsets.symmetric(horizontal: 44.w),
          child: IntrinsicHeight(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 24.h),
                SizedBox(
                  width: 50.w,
                  child: Divider(color: AppColors.greyColor, thickness: 5.5),
                ),
                SizedBox(height: 24.h),
                SvgPicture.asset(AppIcons.logout, width: 130.w, height: 130.h),
                SizedBox(height: 24.h),
                CustomText(
                  text: AppStrings.logout.tr,
                  maxLine: 2,
                  fontWeight: FontWeight.w600,
                  fontSize: 18.sp,
                ),
                SizedBox(height: 24.h),
                CustomText(text: AppStrings.areYouSureToLogout.tr, maxLine: 5),
                SizedBox(height: 24.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomButton(
                      color: Colors.white,
                      textColor: AppColors.textColor,
                      width: 134.w,
                      onTap: () {
                        Get.back();
                      },
                      text: AppStrings.no.tr,
                    ),
                    CustomButton(
                      width: 134.w,
                      onTap: () {
                        Get.offAllNamed(AppStrings.signIn);
                      },
                      text: AppStrings.yes.tr,
                    ),
                  ],
                ),
                SizedBox(height: 32.h),
              ],
            ),
          ),
        );
      },
    );
  }

  //====================================> Pick Image Gallery and Camera <====================
  void _showImagePickerOption() {
    showModalBottomSheet(
      backgroundColor: AppColors.whiteColor,
      context: context,
      builder: (builder) {
        return Padding(
          padding: const EdgeInsets.all(18.0),
          child: Row(
            children: [
              //=========================> Pick Image Gallery <==================
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    _controller.pickImage(ImageSource.gallery);
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.image,
                        size: 50.w,
                        color: AppColors.primaryColor,
                      ),
                      SizedBox(height: 8.h),
                      CustomText(
                        text: 'Gallery',
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                        fontSize: 16.sp,
                      ),
                    ],
                  ),
                ),
              ),
              //=========================> Pick Image Camera <====================
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    _controller.pickImage(ImageSource.camera);
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.camera_alt,
                        size: 50.w,
                        color: AppColors.primaryColor,
                      ),
                      SizedBox(height: 8.h),
                      CustomText(
                        text: 'Camera',
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                        fontSize: 16.sp,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
