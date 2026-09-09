import 'package:aleman/core/network/api/app_api.dart';
import 'package:aleman/core/network/apiResult/api_reuslt.dart';
import 'package:aleman/core/network/error_handler/api_error_handler.dart';
import 'package:aleman/feature/Authentication/data/model/authResponse/message_response.dart';
import 'package:aleman/feature/notification/data/mapper/notification_mapper.dart';
import 'package:aleman/feature/notification/data/model/request/register_token_request_body.dart';
import 'package:aleman/feature/notification/data/model/request/remove_token_request_body.dart';
import 'package:aleman/feature/notification/domain/entity/notifications_pagination_entity.dart';
import 'package:aleman/feature/notification/domain/repository/notification_repository.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final AppServiceClient _apiService;

  NotificationRepositoryImpl(this._apiService);

  @override
  Future<ApiResult<MessageResponse>> registerDeviceToken(
    RegisterTokenRequestBody body,
  ) async {
    try {
      final response = await _apiService.registerDeviceToken(body);
      return ApiResult.success(response);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  @override
  Future<ApiResult<MessageResponse>> removeDeviceToken(
    RemoveTokenRequestBody body,
  ) async {
    try {
      final response = await _apiService.removeDeviceToken(body);
      return ApiResult.success(response);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  @override
  Future<ApiResult<NotificationsPaginationEntity>> getNotifications({
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final response = await _apiService.getNotifications(page, limit);
      return ApiResult.success(response.toEntity());
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  @override
  Future<ApiResult<int>> getUnreadCount() async {
    try {
      final response = await _apiService.getUnreadNotificationsCount();
      return ApiResult.success(response.unreadCount ?? 0);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  @override
  Future<ApiResult<MessageResponse>> markNotificationAsRead(
    int notificationId,
  ) async {
    try {
      final response = await _apiService.markNotificationAsRead(notificationId);
      return ApiResult.success(response);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  @override
  Future<ApiResult<MessageResponse>> markAllNotificationsAsRead() async {
    try {
      final response = await _apiService.markAllNotificationsAsRead();
      return ApiResult.success(response);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }
}
