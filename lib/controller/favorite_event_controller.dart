import 'package:get/get.dart';
import '../models/favorite_event_response_model.dart';
import '../service/api_checker.dart';
import '../service/api_client.dart';
import '../service/api_constants.dart';

class FavoriteEventController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isLoadingMore = false.obs;
  RxBool hasMoreData = true.obs;
  RxList<FavoriteEventItem> favoriteEvents = <FavoriteEventItem>[].obs;
  Rx<Pagination?> pagination = Rx<Pagination?>(null);
  int currentPage = 1;

  @override
  void onInit() {
    super.onInit();
    getFavoriteEvents();
  }

  Future<void> getFavoriteEvents({bool isLoadMore = false, int limit = 10}) async {
    if (!isLoadMore) {
      currentPage = 1;
      favoriteEvents.clear();
      hasMoreData.value = true;
    } else {
      if (!hasMoreData.value || isLoadingMore.value) return;
      currentPage++;
    }

    try {
      if (!isLoadMore) {
        isLoading(true);
      } else {
        isLoadingMore(true);
      }

      final response = await ApiClient.getData(
        ApiConstants.getFavoriteEndPoint,
        query: {'page': currentPage.toString(), 'limit': limit.toString()},
      );

      if (response.statusCode == 200) {
        final favoriteEventResponse = FavoriteEventResponseModel.fromJson(response.body);
        
        if (favoriteEventResponse.success) {
          if (!isLoadMore) {
            favoriteEvents.assignAll(favoriteEventResponse.data.data);
          } else {
            favoriteEvents.addAll(favoriteEventResponse.data.data);
          }
          
          pagination.value = favoriteEventResponse.data.pagination;
          
          // Check if we've loaded all available data
          if (currentPage >= favoriteEventResponse.data.pagination.totalPages) {
            hasMoreData.value = false;
          }
        } else {
          ApiChecker.checkApi(response);
        }
      } else {
        ApiChecker.checkApi(response);
      }
    } finally {
      isLoading(false);
      isLoadingMore(false);
    }
  }

  Future<void> loadMore() async {
    if (hasMoreData.value && !isLoadingMore.value) {
      await getFavoriteEvents(isLoadMore: true);
    }
  }
}