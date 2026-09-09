import 'package:aleman/core/network/apiResult/api_reuslt.dart';
import 'package:aleman/feature/notification/domain/entity/notifications_pagination_entity.dart';
import 'package:aleman/feature/notification/domain/repository/notification_repository.dart';

class GetNotificationsUseCase {
  final NotificationRepository _repository;

  GetNotificationsUseCase(this._repository);

  Future<ApiResult<NotificationsPaginationEntity>> execute({
    int page = 1,
    int limit = 20,
  }) async {
    return await _repository.getNotifications(page: page, limit: limit);
  }
}
