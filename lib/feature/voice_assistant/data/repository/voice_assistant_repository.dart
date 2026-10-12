import 'package:aleman/core/network/apiResult/api_reuslt.dart';
import 'package:aleman/feature/voice_assistant/data/model/voice_assistant_request.dart';
import 'package:aleman/feature/voice_assistant/data/model/voice_assistant_response.dart';

abstract class VoiceAssistantRepository {
  Future<ApiResult<VoiceAssistantResponse>> processVoiceCommand(
    VoiceAssistantRequest request,
  );
}
