import 'package:get/get.dart';
import '../models/favorite_event_response_model.dart';
import '../service/api_checker.dart';
import '../service/api_client.dart';
import '../service/api_constants.dart';

class FavoriteEventController extends GetxController {
  RxBool isLoading = false.obs;
  RxList<FavoriteEventItem> favoriteEvents = <FavoriteEventItem>[].obs;
  Rx<Pagination?> pagination = Rx<Pagination?>(null);

  @override
  void onInit() {
    super.onInit();
    getFavoriteEvents();
  }
//==============================================> Get Favorite Events <==================================
  Future<void> getFavoriteEvents({int page = 1, int limit = 10}) async {
    isLoading(true);
    try {
      final response = await ApiClient.getData(
        ApiConstants.getFavoriteEndPoint,
        query: {'page': page.toString(), 'limit': limit.toString()},
      );

      if (response.statusCode == 200) {
        final favoriteEventResponse = FavoriteEventResponseModel.fromJson(response.body);
        
        if (favoriteEventResponse.success) {
          favoriteEvents.assignAll(favoriteEventResponse.data.data);
          pagination.value = favoriteEventResponse.data.pagination;
        } else {
          ApiChecker.checkApi(response);
        }
      } else {
        ApiChecker.checkApi(response);
      }
    } finally {
      isLoading(false);
    }
  }
}