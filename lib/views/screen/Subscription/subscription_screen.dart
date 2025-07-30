import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:involved/utils/app_colors.dart';
import 'package:involved/utils/app_icons.dart';
import 'package:involved/utils/app_strings.dart';
import 'package:involved/views/base/custom_app_bar.dart';
import 'package:involved/views/base/custom_button.dart';
import 'package:involved/views/base/custom_text.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  String selectedPlan = 'Basic Users';

  void selectPlan(String title) {
    setState(() {
      selectedPlan = title;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: AppStrings.subscription.tr),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
        child: Column(
          children: [
            SubscriptionCard(
              title: 'Basic Users',
              badgeText: 'Free Subscription',
              price: 'Free',
              features: const [
                'Can view the 15 closest events in proximity per day',
                'Can use the Interested and Going buttons',
                'Cannot use the Add button',
                'Cannot see the crowd counter feature',
              ],
              isSelected: selectedPlan == 'Basic Users',
              onSelect: () => selectPlan('Basic Users'),
            ),
            SizedBox(height: 16.h),
            SubscriptionCard(
              title: 'VIP Users',
              badgeText: '1 Month',
              price: '\$3.99/Month',
              features: const [
                'Can view all events on the app',
                'Can use all the features on the app',
                'Can see the crowd counter feature',
                'Can submit an event Suggestion',
              ],
              isSelected: selectedPlan == 'VIP Users',
              onSelect: () => selectPlan('VIP Users'),
            ),
            SizedBox(height: 16.h),
            SubscriptionCard(
              title: 'Business Users',
              badgeText: '1 Month',
              price: '\$40.99/Month',
              features: const [
                'Can view all events on the app',
                'Can see the crowd counter feature',
                'Can submit their own events',
              ],
              isSelected: selectedPlan == 'Business Users',
              onSelect: () => selectPlan('Business Users'),
            ),
            SizedBox(height: 32.h),
            CustomButton(onTap: (){}, text: AppStrings.payNow.tr)
          ],
        ),
      ),
    );
  }
}

class SubscriptionCard extends StatelessWidget {
  final String title;
  final String badgeText;
  final String price;
  final List<String> features;
  final bool isSelected;
  final VoidCallback onSelect;

  const SubscriptionCard({
    super.key,
    required this.title,
    required this.badgeText,
    required this.price,
    required this.features,
    required this.isSelected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final highlightColor = isSelected ? Colors.green.shade100 : Colors.white;
    final borderColor = isSelected ? AppColors.primaryColor : Colors.grey.shade300;

    return GestureDetector(
      onTap: onSelect,
      child: Container(
        decoration: BoxDecoration(
          color: highlightColor,
          border: Border.all(color: borderColor, width: 1.5),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Badge(badgeText: badgeText),
            SizedBox(height: 12.h),
            Padding(
              padding: EdgeInsets.all(8.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      SvgPicture.asset(AppIcons.sub),
                      SizedBox(width: 8.w),
                      CustomText(
                       text: title,
                        fontSize: 18.sp, fontWeight: FontWeight.w500),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ...features.map(
                        (text) => Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(top: 5),
                          child: Icon(Icons.check_circle, color: Colors.green, size: 18),
                        ),
                        const SizedBox(width: 8),
                        Expanded(child: Text(text, style: const TextStyle(fontSize: 14))),
                      ],
                    ),
                  ),
                  if (price != 'Free') ...[
                    SizedBox(height: 16.h),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: CustomText(
                      text: price,
                          color: Colors.green,
                          fontWeight: FontWeight.w500,
                          fontSize: 24.sp,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String badgeText;

  const _Badge({required this.badgeText});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:  EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: AppColors.primaryColor,
        borderRadius: BorderRadius.only(bottomRight: Radius.circular(12.r), topLeft: Radius.circular(12.r)),
      ),
      child: CustomText(
       text: badgeText,
        color: Colors.white
      ),
    );
  }
}