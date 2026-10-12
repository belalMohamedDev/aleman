import 'package:aleman/feature/voice_assistant/data/model/voice_assistant_response.dart';

enum VoiceAssistantStatus {
  idle,
  listening,
  processing,
  success,
  error,
}

class VoiceAssistantState {
  final VoiceAssistantStatus status;
  final String recognizedText;
  final double soundLevel;
  final VoiceAssistantResponse? response;
  final String? errorMessage;
  final bool isSpeaking;

  const VoiceAssistantState({
    this.status = VoiceAssistantStatus.idle,
    this.recognizedText = '',
    this.soundLevel = 0.0,
    this.response,
    this.errorMessage,
    this.isSpeaking = false,
  });

  VoiceAssistantState copyWith({
    VoiceAssistantStatus? status,
    String? recognizedText,
    double? soundLevel,
    VoiceAssistantResponse? response,
    String? errorMessage,
    bool? isSpeaking,
  }) {
    return VoiceAssistantState(
      status: status ?? this.status,
      recognizedText: recognizedText ?? this.recognizedText,
      soundLevel: soundLevel ?? this.soundLevel,
      response: response ?? this.response,
      errorMessage: errorMessage,
      isSpeaking: isSpeaking ?? this.isSpeaking,
    );
  }
}
