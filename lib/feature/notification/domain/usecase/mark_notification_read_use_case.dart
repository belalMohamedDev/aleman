import 'package:aleman/core/network/apiResult/api_reuslt.dart';
import 'package:aleman/feature/Authentication/data/model/authResponse/message_response.dart';
import 'package:aleman/feature/notification/domain/repository/notification_repository.dart';

class MarkNotificationReadUseCase {
  final NotificationRepository _repository;

  MarkNotificationReadUseCase(this._repository);

  Future<ApiResult<MessageResponse>> execute(int notificationId) async {
    return await _repository.markNotificationAsRead(notificationId);
  }
}
