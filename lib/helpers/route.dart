import 'package:get/get.dart';

import '../views/screen/Categories/categories_screen.dart';
import '../views/screen/Home/home_screen.dart';
import '../views/screen/Profile/profile_screen.dart';
import '../views/screen/Splash/splash_screen.dart';


class AppRoutes{
  static String splashScreen="/splash_screen";
  static String homeScreen="/home_screen";
  static String profileScreen="/profile_screen";
  static String categoriesScreen="/categories_screen";
  static String locationScreen="/location_screen";
  static String locationPickerScreen="/location_picker_screen";

 static List<GetPage> page=[
    GetPage(name:splashScreen, page: ()=>const SplashScreen()),
    GetPage(name:homeScreen, page: ()=>const HomeScreen(),transition:Transition.noTransition),
    GetPage(name:categoriesScreen, page: ()=>const CategoriesScreen(),transition:Transition.noTransition),
    GetPage(name:profileScreen, page: ()=>const ProfileScreen(),transition: Transition.noTransition),
  ];
}
