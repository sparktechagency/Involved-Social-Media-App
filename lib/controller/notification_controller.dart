import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../models/notification_response_model.dart';
import '../models/favorite_event_response_model.dart';
import '../service/api_checker.dart';
import '../service/api_client.dart';
import '../service/api_constants.dart';

class NotificationController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isLoadingMore = false.obs;
  RxBool hasMoreData = true.obs;
  RxList<NotificationItem> notifications = <NotificationItem>[].obs;
  Rx<Pagination?> pagination = Rx<Pagination?>(null);
  int currentPage = 1;

  @override
  void onInit() {
    super.onInit();
    getNotifications();
  }

  //============================================> Get Notifications <===================================
  Future<void> getNotifications({
    bool isLoadMore = false,
    int limit = 10,
  }) async {
    if (!isLoadMore) {
      currentPage = 1;
      notifications.clear();
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
        ApiConstants.notificationEndPoint,
        query: {'page': currentPage.toString(), 'limit': limit.toString()},
      );

      if (response.statusCode == 200) {
        final notificationResponse = NotificationResponseModel.fromJson(
          response.body,
        );
        if (notificationResponse.success) {
          if (!isLoadMore) {
            notifications.assignAll(notificationResponse.data.data);
          } else {
            notifications.addAll(notificationResponse.data.data);
          }
          pagination.value = notificationResponse.data.pagination;
          if (currentPage >= notificationResponse.data.pagination.totalPages) {
            hasMoreData.value = false;
          }
        } else {
          ApiChecker.checkApi(response);
        }
      } else {
        ApiChecker.checkApi(response);
      }
    } catch (e) {
      debugPrint("Error fetching notifications: $e");
    } finally {
      isLoading(false);
      isLoadingMore(false);
    }
  }

  //============================================> Load More <===================================
  Future<void> loadMore() async {
    if (hasMoreData.value && !isLoadingMore.value) {
      await getNotifications(isLoadMore: true);
    }
  }
}
