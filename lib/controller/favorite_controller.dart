import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../models/favorite_event_response_model.dart';
import '../service/api_checker.dart';
import '../service/api_client.dart';
import '../service/api_constants.dart';

class FavoriteController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isLoadingMore = false.obs;
  RxBool hasMoreData = true.obs;
  RxList<FavoriteEventItem> favoriteEvents = <FavoriteEventItem>[].obs;
  Rx<Pagination?> pagination = Rx<Pagination?>(null);
  int currentPage = 1;
  final RxSet<String> _favoritedEventIds = <String>{}.obs;

  Set<String> get favoritedEventIds => _favoritedEventIds;

  @override
  void onInit() {
    super.onInit();
    getFavoriteEvents();
    loadFavoritedEvents();
  }

  //============================================> Get Favorite Events <===================================
  Future<void> getFavoriteEvents({
    bool isLoadMore = false,
    int limit = 10,
  }) async {
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
        final favoriteEventResponse = FavoriteEventResponseModel.fromJson(
          response.body,
        );
        if (favoriteEventResponse.success) {
          if (!isLoadMore) {
            favoriteEvents.assignAll(favoriteEventResponse.data.data);
          } else {
            favoriteEvents.addAll(favoriteEventResponse.data.data);
          }
          pagination.value = favoriteEventResponse.data.pagination;
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

  //============================================> Load More Events <===================================
  Future<void> loadMore() async {
    if (hasMoreData.value && !isLoadingMore.value) {
      await getFavoriteEvents(isLoadMore: true);
    }
  }

  //============================================> Load Favorite Events <===================================
  Future<void> loadFavoritedEvents() async {
    try {
      final response = await ApiClient.getData(
        ApiConstants.getFavoriteEndPoint,
      );
      if (response.statusCode == 200) {
        final favoriteResponse = FavoriteEventResponseModel.fromJson(
          response.body,
        );
        if (favoriteResponse.success) {
          _favoritedEventIds.clear();
          for (var favoriteItem in favoriteResponse.data.data) {
            _favoritedEventIds.add(favoriteItem.event.id);
          }
        }
      }
    } catch (e) {
      debugPrint("Error loading favorite events: $e");
    }
  }

  //============================================> Add Favorite <===================================
  Future<bool> addFavorite(String eventId) async {
    try {
      final response = await ApiClient.postData(
        ApiConstants.addFavoriteEndPoint,
        {'eventId': eventId},
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        _favoritedEventIds.add(eventId);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  //============================================> Remove Favorite <===================================
  Future<bool> removeFavorite(String eventId) async {
    try {
      final response = await ApiClient.deleteData(
        ApiConstants.deleteFavoriteEndPoint(eventId),
      );

      if (response.statusCode == 200) {
        // Remove from local list
        _favoritedEventIds.remove(eventId);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      // Handle error
      return false;
    }
  }

  //============================================> Toggle Favorite <===================================
  Future<bool> toggleFavorite(String eventId) async {
    bool wasFavorite = _favoritedEventIds.contains(eventId);
    bool success;
    if (wasFavorite) {
      _favoritedEventIds.remove(eventId);
    } else {
      _favoritedEventIds.add(eventId);
    }
    if (wasFavorite) {
      success = await removeFavorite(eventId);
    } else {
      success = await addFavorite(eventId);
    }
    if (!success) {
      if (wasFavorite) {
        _favoritedEventIds.add(eventId);
      } else {
        _favoritedEventIds.remove(eventId);
      }
    }
    return success;
  }

  bool isFavorite(String eventId) {
    return _favoritedEventIds.contains(eventId);
  }
}
