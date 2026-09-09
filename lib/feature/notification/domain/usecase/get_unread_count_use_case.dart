import 'package:aleman/core/network/apiResult/api_reuslt.dart';
import 'package:aleman/feature/notification/domain/repository/notification_repository.dart';

class GetUnreadCountUseCase {
  final NotificationRepository _repository;

  GetUnreadCountUseCase(this._repository);

  Future<ApiResult<int>> execute() async {
    return await _repository.getUnreadCount();
  }
}
