import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:involved/controller/profile_controller.dart';
import 'package:involved/utils/app_colors.dart';
import 'package:involved/utils/app_icons.dart';
import 'package:involved/utils/app_strings.dart';
import 'package:involved/views/base/custom_app_bar.dart';
import 'package:involved/views/base/custom_button.dart';
import 'package:involved/views/base/custom_network_image.dart';
import 'package:involved/views/base/custom_text.dart';
import 'package:involved/views/base/custom_text_field.dart';
import 'package:involved/service/api_constants.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final ProfileController _controller = Get.put(ProfileController());

  @override
  void initState() {
    super.initState();
    _controller.nameCTRL.text = Get.parameters['name'] ?? '';
    _controller.addressCTRL.text = Get.parameters['address'] ?? '';
     _controller.phoneCTRL.text = Get.parameters['phone'] ?? '';
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _populateFields();
    });
  }

  void _populateFields() {
    if (_controller.userProfile.value != null) {
      _controller.nameCTRL.text = _controller.userProfile.value!.name ?? '';
      _controller.addressCTRL.text = _controller.userProfile.value!.address ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: AppStrings.editProfileInformation.tr),
      body: SingleChildScrollView(
        child: Column(
          children: [
            //==============================> Profile picture section <=======================
            Stack(
              children: [
                Obx(() =>
                  Stack(
                    children: [
                      if (_controller.selectedImage.value != null)
                        CircleAvatar(
                          radius: 72.5.r,
                          backgroundImage: FileImage(_controller.selectedImage.value!),
                          backgroundColor: Colors.grey,
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                width: 2.w,
                                color: AppColors.primaryColor,
                              ),
                            ),
                          ),
                        )
                      else
                        CustomNetworkImage(
                          imageUrl: _controller.userProfile.value?.image != null
                              ? '${ApiConstants.imageBaseUrl}${_controller.userProfile.value!.image}'
                              : 'https://t4.ftcdn.net/jpg/02/24/86/95/360_F_224869519_aRaeLneqALfPNBzg0xxMZXghtvBXkfIA.jpg',
                          height: 145.h,
                          width: 145.w,
                          boxShape: BoxShape.circle,
                          border: Border.all(width: 2.w, color: AppColors.primaryColor),
                        ),
                    ],
                  )
                ),
                //==============================> Edit Profile Button <=======================
                Positioned(
                  right: 5.w,
                  bottom: 5.h,
                  child: InkWell(
                    onTap: () {
                      _showImagePickerOption();
                    },
                    child: SvgPicture.asset(AppIcons.edit),
                  ),
                ),
              ],
            ),
            SizedBox(height: 22.h),
            //==============================> Container Text Field <=======================
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(width: 1.w, color: AppColors.borderColor),
                ),
                child: Padding(
                  padding: EdgeInsets.all(12.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //====================> User Name Text Field <================
                      CustomText(
                        text: AppStrings.userName.tr,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        bottom: 14.h,
                      ),
                      CustomTextField(
                        controller: _controller.nameCTRL,
                        hintText: AppStrings.enterUsername.tr,
                      ),
                      SizedBox(height: 16.h),
                      //========================> Address Text Field <==================
                      CustomText(
                        text: AppStrings.address.tr,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        bottom: 14.h,
                      ),
                      CustomTextField(
                        controller: _controller.addressCTRL,
                        hintText: AppStrings.enterYourAddress.tr,
                      ),
                      //========================> Phone Number Text Field <==================
                      SizedBox(height: 16.h),
                      CustomText(
                        text: AppStrings.phoneNumber.tr,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        bottom: 14.h,
                      ),
                      CustomTextField(
                        controller: _controller.phoneCTRL,
                        hintText: AppStrings.enterPhoneNumber.tr,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 122.h),
            //==============================> Update profile Button <=======================
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              child: Obx(() => CustomButton(
                onTap: () {
                  _controller.updateProfile().then((success) {
                    if (success) {
                      Get.back();
                    }
                  });
                },
                text: _controller.isUpdatingProfile.value
                    ? "Updating..."
                    : AppStrings.updateProfile.tr,
                loading: _controller.isUpdatingProfile.value,
              )),
            ),
            SizedBox(height: 22.h),
          ],
        ),
      ),
    );
  }

  //====================================> Pick Image Gallery and Camera <====================
  void _showImagePickerOption() {
    showModalBottomSheet(
      backgroundColor: AppColors.whiteColor,
      context: context,
      builder: (builder) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 58.h),
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
