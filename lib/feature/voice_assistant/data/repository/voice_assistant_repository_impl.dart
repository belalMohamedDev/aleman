import 'package:aleman/core/network/api/app_api.dart';
import 'package:aleman/core/network/apiResult/api_reuslt.dart';
import 'package:aleman/core/network/error_handler/api_error_handler.dart';
import 'package:aleman/feature/voice_assistant/data/model/voice_assistant_request.dart';
import 'package:aleman/feature/voice_assistant/data/model/voice_assistant_response.dart';
import 'package:aleman/feature/voice_assistant/data/repository/voice_assistant_repository.dart';

class VoiceAssistantRepositoryImpl implements VoiceAssistantRepository {
  final AppServiceClient _apiService;

  VoiceAssistantRepositoryImpl(this._apiService);

  @override
  Future<ApiResult<VoiceAssistantResponse>> processVoiceCommand(
    VoiceAssistantRequest request,
  ) async {
    try {
      final response = await _apiService.processVoiceCommand(request);
      return ApiResult.success(response);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }
}
