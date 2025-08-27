import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:involved/controller/profile_controller.dart';
import 'package:involved/utils/app_colors.dart';
import 'package:involved/utils/app_icons.dart';
import 'package:involved/utils/app_images.dart';
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
  final TextEditingController descriptionCTRL = TextEditingController();

  String? _selectedEventType;
  String? _selectedGiveawayGiftCard;
  String? _selectedEventCategory;
  String? _selectedOccurrenceType;

  List<String> eventTypes = ['Giveaway', 'Music', 'Experience', 'Night Life', 'Fitness', 'Art and Culture'];
  List<String> giveawayGiftCards = ['\$25 Gift Card', '\$50 Gift Card', '\$100 Gift Card'];
  List<String> eventCategories = ['Beach Club', 'Bingo', 'Book Club', 'Brunch', 'Charity'];
  List<String> occurrenceTypes = ['One Time Event', 'Weekly Event', 'Monthly Event'];
  List<String> atmosphereOptions =
  ['Romantic', 'Casual', 'Sexy', 'Chill', 'Active', 'Party', 'Outdoors',
    'Sophisticated', 'Bohemian', 'Professional'];

  Map<String, bool> selectedAtmospheres = {};

  @override
  void initState() {
    super.initState();
    for (var option in atmosphereOptions) {
      selectedAtmospheres[option] = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: AppStrings.createEvent.tr),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
          child: Card(
            color: Color(0xffFFEFD1),
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(child: Image.asset(AppImages.logos, width: 142.w, height: 64.h)),
                  SizedBox(height: 12.h),
                  //=======================> Event Title Text Field <===================
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(width: 1.w, color: AppColors.primaryColor)
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(8.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            left: 9.w,
                            text: AppStrings.eventTitle.tr,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primaryColor,
                          ),
                          CustomTextField(
                            borderColor: Colors.white,
                            controller: titleCTRL,
                            hintText: AppStrings.enterEventName.tr,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  //=======================> Event Type Dropdown Button <===================
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8.r),
                        border: Border.all(width: 1.w, color: AppColors.primaryColor)
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(8.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            left: 9.w,
                            text: AppStrings.eventType.tr,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primaryColor,
                          ),
                          DropdownButton<String>(
                            isExpanded: true,
                            dropdownColor: Colors.white,
                            value: _selectedEventType,
                            hint:  CustomText(
                              left: 10.w,
                              text: 'Select Event Type'.tr,
                              color: Colors.black,
                            ),
                            icon: SvgPicture.asset(AppIcons.rightArrow),
                            onChanged: (String? newValue) {
                              setState(() {
                                _selectedEventType = newValue;
                              });
                            },
                            underline: SizedBox(),
                            items: eventTypes.map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child:CustomText(
                                  left: 10.w,
                                  text: value,
                                  color: Colors.black,
                                ),
                              );
                            }).toList(),
                          ),

                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  //=======================> Giveaway Gift Card Dropdown Button <===================
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8.r),
                        border: Border.all(width: 1.w, color: AppColors.primaryColor)
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(8.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            left: 9.w,
                            text: AppStrings.giveawayGiftCard.tr,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primaryColor,
                          ),
                          DropdownButton<String>(
                            isExpanded: true,
                            dropdownColor: Colors.white,
                            value: _selectedGiveawayGiftCard,
                            hint:  CustomText(
                              left: 10.w,
                              text: 'Select Gift Card'.tr,
                              color: Colors.black,
                            ),
                            icon: SvgPicture.asset(AppIcons.rightArrow),
                            onChanged: (String? newValue) {
                              setState(() {
                                _selectedGiveawayGiftCard = newValue;
                              });
                            },
                            underline: SizedBox(),
                            items: giveawayGiftCards.map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child:CustomText(
                                  left: 10.w,
                                  text: value,
                                  color: Colors.black,
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  //=======================> Event Category Dropdown Button <===================
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8.r),
                        border: Border.all(width: 1.w, color: AppColors.primaryColor)
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(8.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            left: 9.w,
                            text: AppStrings.eventCategories.tr,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primaryColor,
                          ),
                          DropdownButton<String>(
                            isExpanded: true,
                            dropdownColor: Colors.white,
                            value: _selectedEventCategory,
                            hint:  CustomText(
                              left: 10.w,
                              text: 'Select Category'.tr,
                              color: Colors.black,
                            ),
                            icon: SvgPicture.asset(AppIcons.rightArrow),
                            onChanged: (String? newValue) {
                              setState(() {
                                _selectedEventCategory = newValue;
                              });
                            },
                            underline: SizedBox(),
                            items: eventCategories.map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child:CustomText(
                                  left: 10.w,
                                  text: value,
                                  color: Colors.black,
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  //=======================> Location Text Field <===================
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8.r),
                        border: Border.all(width: 1.w, color: AppColors.primaryColor)
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(8.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            left: 9.w,
                            text: AppStrings.location.tr,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primaryColor,
                          ),
                          CustomTextField(
                            controller: locationCTRL,
                            borderColor: Colors.white,
                            hintText: AppStrings.enterEventLocation.tr,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  //=======================> Event Date Text Field <===================
                  CustomTextField(
                    onTap: (){
                      pickBirthDate(context);
                    },
                    readOnly: true,
                    controller: eventDateCTRL,
                    suffixIcon: SvgPicture.asset(AppIcons.calender, color: AppColors.primaryColor),
                    hintText: AppStrings.eventDate.tr,
                  ),
                  SizedBox(height: 16.h),
                  //=======================> Event Time Text Field <===================
                  CustomTextField(
                    onTap: (){
                      selectTime(context);
                    },
                    readOnly: true,
                    controller: eventTimeCTRL,
                    suffixIcon: SvgPicture.asset(AppIcons.clock, color: AppColors.primaryColor),
                    hintText: AppStrings.eventTime.tr,
                  ),
                  SizedBox(height: 16.h),
                  //=======================> Atmosphere Check Box Section <===================
                  CustomText(
                    left: 9.w,
                    text: 'Atmosphere'.tr,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryColor,
                  ),
                  SizedBox(height: 16.h),
                  SizedBox(
                    height: 300.h,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: atmosphereOptions.length,
                      itemBuilder: (context, index) {
                        String option = atmosphereOptions[index];
                        return CheckboxListTile(
                          title: Text(option, style: TextStyle(color: Colors.black),),
                          value: selectedAtmospheres[option] ?? false,
                          checkColor: AppColors.whiteColor,
                          activeColor: AppColors.primaryColor,
                          side: BorderSide(color: AppColors.primaryColor),

                          onChanged: (bool? value) {
                            setState(() {
                              selectedAtmospheres[option] = value ?? false;
                            });
                          },
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 16.h),
                  //=======================> Event Description Text Field <===================
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8.r),
                        border: Border.all(width: 1.w, color: AppColors.primaryColor)
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(8.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            left: 9.w,
                            text: AppStrings.description.tr,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primaryColor,
                          ),
                          CustomTextField(
                            controller: descriptionCTRL,
                            hintText: 'Write a description maximum 50 character'.tr,
                            maxLines: 3,
                            borderColor: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  //=======================> Occurrence Type Text Field <===================
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8.r),
                        border: Border.all(width: 1.w, color: AppColors.primaryColor)
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(8.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            left: 9.w,
                            text: AppStrings.occurrenceType.tr,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primaryColor,
                          ),
                          DropdownButton<String>(
                            isExpanded: true,
                            dropdownColor: Colors.white,
                            value: _selectedOccurrenceType,
                            hint:  CustomText(
                              left: 10.w,
                              text: 'Select Occurrence Type'.tr,
                              color: Colors.black,
                            ),
                            icon: SvgPicture.asset(AppIcons.rightArrow),
                            onChanged: (String? newValue) {
                              setState(() {
                                _selectedOccurrenceType = newValue;
                              });
                            },
                            underline: SizedBox(),
                            items: occurrenceTypes.map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child:CustomText(
                                  left: 10.w,
                                  text: value,
                                  color: Colors.black,
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 16.h),
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
                  SizedBox(height: 32.h),
                  //=======================> Create Event Button <===================
                  CustomButton(onTap: () {}, text: AppStrings.createEvent.tr),
                  SizedBox(height: 32.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  //==========================> Show Calender Function <=======================
  Future<void> pickBirthDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(3050),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            dialogBackgroundColor: Colors.white,
            colorScheme: ColorScheme.light(
              primary: AppColors.primaryColor,
              onSurface: Colors.black, // Text color
            ),
          ),
          child: child!,
        );
      },
    );
    if (pickedDate != null) {
      eventDateCTRL.text =
      "${pickedDate.month}-${pickedDate.day}-${pickedDate.year}";
    }
  }
  //==========================> Show Clock Function <=======================
  Future<void> selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            dialogBackgroundColor: Colors.white,
            colorScheme: ColorScheme.light(
              primary: AppColors.primaryColor,
              onSurface: Colors.black, // Text color
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedTime != null) {
      setState(() {
        final hours = pickedTime.hour % 12 == 0 ? 12 : pickedTime.hour % 12;
        final minutes = pickedTime.minute.toString().padLeft(2, '0');
        final period = pickedTime.period == DayPeriod.am ? 'AM' : 'PM';
        eventTimeCTRL.text = "${hours.toString().padLeft(2, '0')}:$minutes $period";
      });
    }
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
