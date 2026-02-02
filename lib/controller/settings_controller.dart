import 'package:get/get.dart';
import 'package:involved/models/setting_content_model.dart';
import 'package:involved/service/api_checker.dart';
import 'package:involved/service/api_client.dart';
import 'package:involved/service/api_constants.dart';

class SettingController extends GetxController {
  //==============================> Get Terms and Condition Method <==========================
  var termsConditionLoading = false.obs;
  Rx<SettingContentModel?> termContent = Rx<SettingContentModel?>(null);
  getTermsCondition() async {
    termsConditionLoading.value = true;
    Response response = await ApiClient.getData(ApiConstants.termsConditionEndPoint);
    if (response.statusCode == 200) {
      termContent.value = SettingContentModel.fromJson(response.body);
    } else {
      ApiChecker.checkApi(response);
    }
    termsConditionLoading.value = false;
  }

//==========================> Get Privacy Policy Method <=======================
  RxBool getPrivacyLoading = false.obs;
  Rx<SettingContentModel?> privacyContent = Rx<SettingContentModel?>(null);
  getPrivacy() async {
    getPrivacyLoading.value = true;
    Response response = await ApiClient.getData(ApiConstants.privacyPolicyEndPoint);
    if (response.statusCode == 200) {
      privacyContent.value = SettingContentModel.fromJson(response.body);
    } else {
      ApiChecker.checkApi(response);
    }
    getPrivacyLoading.value = false;
  }

  //==============================> Get Contact Us Method <==========================
  RxBool getContactUsLoading = false.obs;
  Rx<SettingContentModel?> contactUsContent = Rx<SettingContentModel?>(null);
  getContactUs() async {
    getContactUsLoading.value = true;
    Response response = await ApiClient.getData(ApiConstants.contactUsEndPoint);
    if (response.statusCode == 200) {
      contactUsContent.value = SettingContentModel.fromJson(response.body);
    } else {
      ApiChecker.checkApi(response);
    }
    getContactUsLoading.value = false;
  }
}
