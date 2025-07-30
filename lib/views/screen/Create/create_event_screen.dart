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

class CreateEventScreen extends StatefulWidget {
  const CreateEventScreen({super.key});

  @override
  State<CreateEventScreen> createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  final ProfileController _controller = Get.put(ProfileController());
  final TextEditingController titleCTRL = TextEditingController();
  final TextEditingController locationCTRL = TextEditingController();
  final TextEditingController eventDateCTRL = TextEditingController();
  final TextEditingController eventTimeCTRL = TextEditingController();
  final TextEditingController categoryCTRL = TextEditingController();
  final TextEditingController typeCTRL = TextEditingController();
  final TextEditingController descriptionCTRL = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: AppStrings.createEvent.tr),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
          child: Column(
            children: [
              //=======================> Event Title Text Field <===================
              CustomTextField(
                controller: titleCTRL,
                hintText: AppStrings.enterEventName.tr,
                labelText: AppStrings.eventTitle.tr,
              ),
              SizedBox(height: 12.h),
              //=======================> Event Location Text Field <===================
              CustomTextField(
                controller: locationCTRL,
                hintText: AppStrings.enterEventLocation.tr,
                labelText: AppStrings.eventLocation.tr,
              ),
              SizedBox(height: 12.h),
              //=======================> Event Date Text Field <===================
              CustomTextField(
                controller: eventDateCTRL,
                hintText: AppStrings.eventDate.tr,
              ),
              SizedBox(height: 12.h),
              //=======================> Event Time Text Field <===================
              CustomTextField(
                controller: eventTimeCTRL,
                hintText: AppStrings.eventTime.tr,
              ),
              SizedBox(height: 12.h),
              //=======================> Event Category Text Field <===================
              CustomTextField(
                controller: categoryCTRL,
                hintText: AppStrings.tapToSelect.tr,
                labelText: AppStrings.category.tr,
              ),
              SizedBox(height: 12.h),
              //=======================> Event Category Text Field <===================
              CustomTextField(
                controller: typeCTRL,
                hintText: AppStrings.tapToSelect.tr,
                labelText: AppStrings.occurrenceType.tr,
              ),
              SizedBox(height: 12.h),
              //==============================> Event picture section <=======================
              Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  side: BorderSide(width: 1.w, color: AppColors.primaryColor),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                elevation: 2,
                child: Padding(
                  padding: EdgeInsets.all(24.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        text: AppStrings.uploadImage.tr,
                        fontWeight: FontWeight.w500,
                        fontSize: 16.sp,
                      ),
                      SizedBox(height: 16.h),
                      Stack(
                        children: [
                          CustomNetworkImage(
                            imageUrl: '',
                            height: 200.h,
                            width: 279.w,
                            borderRadius: BorderRadius.circular(8.r),
                            border: Border.all(
                              width: 2.w,
                              color: AppColors.greyColor,
                            ),
                          ),
                          //==============================> Edit Profile Button <=======================
                          Positioned(
                            top: 80.h,
                            right: 50.w,
                            left: 50.w,
                            bottom: 80.h,
                            child: InkWell(
                              onTap: () {
                                _showImagePickerOption();
                              },
                              child: SvgPicture.asset(
                                AppIcons.edit,
                                width: 24.w,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 22.h),
              //=======================> Event Description Text Field <===================
              CustomTextField(
                controller: descriptionCTRL,
                hintText: AppStrings.description.tr,
                maxLines: 5,
              ),
              SizedBox(height: 32.h),
              //=======================> Create Event Button <===================
              CustomButton(onTap: () {}, text: AppStrings.createEvent.tr),
              SizedBox(height: 32.h),
            ],
          ),
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
