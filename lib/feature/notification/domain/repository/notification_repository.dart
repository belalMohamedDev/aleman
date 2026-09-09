import 'package:aleman/core/network/apiResult/api_reuslt.dart';
import 'package:aleman/feature/Authentication/data/model/authResponse/message_response.dart';
import 'package:aleman/feature/notification/data/model/request/register_token_request_body.dart';
import 'package:aleman/feature/notification/data/model/request/remove_token_request_body.dart';
import 'package:aleman/feature/notification/domain/entity/notifications_pagination_entity.dart';

abstract class NotificationRepository {
  Future<ApiResult<MessageResponse>> registerDeviceToken(
    RegisterTokenRequestBody body,
  );

  Future<ApiResult<MessageResponse>> removeDeviceToken(
    RemoveTokenRequestBody body,
  );

  Future<ApiResult<NotificationsPaginationEntity>> getNotifications({
    int page = 1,
    int limit = 20,
  });

  Future<ApiResult<int>> getUnreadCount();

  Future<ApiResult<MessageResponse>> markNotificationAsRead(int notificationId);

  Future<ApiResult<MessageResponse>> markAllNotificationsAsRead();
}
