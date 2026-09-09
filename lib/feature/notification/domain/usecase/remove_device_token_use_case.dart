import 'package:aleman/core/network/apiResult/api_reuslt.dart';
import 'package:aleman/feature/Authentication/data/model/authResponse/message_response.dart';
import 'package:aleman/feature/notification/data/model/request/remove_token_request_body.dart';
import 'package:aleman/feature/notification/domain/repository/notification_repository.dart';

class RemoveDeviceTokenUseCase {
  final NotificationRepository _repository;

  RemoveDeviceTokenUseCase(this._repository);

  Future<ApiResult<MessageResponse>> execute(
    RemoveTokenRequestBody body,
  ) async {
    return await _repository.removeDeviceToken(body);
  }
}
