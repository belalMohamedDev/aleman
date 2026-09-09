import 'package:aleman/core/network/apiResult/api_reuslt.dart';
import 'package:aleman/feature/Authentication/data/model/authResponse/message_response.dart';
import 'package:aleman/feature/notification/data/model/request/register_token_request_body.dart';
import 'package:aleman/feature/notification/domain/repository/notification_repository.dart';

class RegisterDeviceTokenUseCase {
  final NotificationRepository _repository;

  RegisterDeviceTokenUseCase(this._repository);

  Future<ApiResult<MessageResponse>> execute(
    RegisterTokenRequestBody body,
  ) async {
    return await _repository.registerDeviceToken(body);
  }
}
