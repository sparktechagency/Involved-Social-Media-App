import 'package:get/get.dart';
import 'package:involved/views/screen/AboutUs/about_us_screen.dart';
import 'package:involved/views/screen/Auth/change_password_screen.dart';
import 'package:involved/views/screen/Auth/reset_password_screen.dart';
import 'package:involved/views/screen/Auth/sign_in_screen.dart';
import 'package:involved/views/screen/Auth/sign_up_screen.dart';
import 'package:involved/views/screen/Auth/forgot_password_screen.dart';
import 'package:involved/views/screen/Auth/otp_screen.dart';
import 'package:involved/views/screen/Create/create_event_screen.dart';
import 'package:involved/views/screen/Notifications/notifications_screen.dart';
import 'package:involved/views/screen/PrivacyPolicy/privacy_policy_screen.dart';
import 'package:involved/views/screen/Search/search_screen.dart';
import 'package:involved/views/screen/Splash/get_start_screen.dart';
import 'package:involved/views/screen/TermsofServices/terms_services_screen.dart';
import '../views/screen/Calender/calender_screen.dart';
import '../views/screen/Home/home_screen.dart';
import '../views/screen/Profile/profile_screen.dart';
import '../views/screen/Splash/splash_screen.dart';


class AppRoutes{
  static String splashScreen="/splash_screen";
  static String getStartScreen="/get_start_screen";
  static String signInScreen="/sign_in_screen";
  static String signUpScreen="/sign_up_screen";
  static String forgotPasswordScreen="/forgot_password_screen";
  static String resetPasswordScreen="/reset_password_screen";
  static String changePasswordScreen="/change_password_screen";
  static String otpScreen="/otp_screen";
  static String homeScreen="/home_screen";
  static String searchScreen="/search_screen";
  static String profileScreen="/profile_screen";
  static String calenderScreen="/calender_screen";
  static String createEventScreen="/create_event_screen";
  static String privacyPolicyScreen="/privacy_policy_screen";
  static String aboutUsScreen="/about_us_screen";
  static String termsServicesScreen="/terms_services_screen";
  static String notificationsScreen="/notifications_screen";

 static List<GetPage> page=[
    GetPage(name:splashScreen, page: ()=>const SplashScreen()),
    GetPage(name:getStartScreen, page: ()=>const GetStartScreen()),
    GetPage(name:signInScreen, page: ()=> SignInScreen()),
    GetPage(name:signUpScreen, page: ()=> SignUpScreen()),
    GetPage(name:forgotPasswordScreen, page: ()=> ForgotPasswordScreen()),
    GetPage(name:resetPasswordScreen, page: ()=> ResetPasswordScreen()),
    GetPage(name:changePasswordScreen, page: ()=> ChangePasswordScreen()),
    GetPage(name:otpScreen, page: ()=> OtpScreen()),
    GetPage(name:homeScreen, page: ()=>const HomeScreen(),transition:Transition.noTransition),
    GetPage(name:searchScreen, page: ()=> SearchScreen(),transition:Transition.noTransition),
    GetPage(name:calenderScreen, page: ()=> CalenderScreen(),transition:Transition.noTransition),
    GetPage(name:createEventScreen, page: ()=> CreateEventScreen(),transition:Transition.noTransition),
    GetPage(name:profileScreen, page: ()=>const ProfileScreen(),transition: Transition.noTransition),
    GetPage(name:privacyPolicyScreen, page: ()=>const PrivacyPolicyScreen()),
    GetPage(name:aboutUsScreen, page: ()=>const AboutUsScreen()),
    GetPage(name:termsServicesScreen, page: ()=>const TermsServicesScreen()),
    GetPage(name:notificationsScreen, page: ()=> NotificationsScreen()),
  ];
}
