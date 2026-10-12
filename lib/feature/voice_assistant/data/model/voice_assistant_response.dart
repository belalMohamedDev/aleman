class VoiceAssistantResponse {
  final bool success;
  final String intent;
  final String spokenReply;
  final String action;
  final dynamic data;
  final String? audioUrl;

  const VoiceAssistantResponse({
    required this.success,
    required this.intent,
    required this.spokenReply,
    required this.action,
    this.data,
    this.audioUrl,
  });

  factory VoiceAssistantResponse.fromJson(Map<String, dynamic> json) {
    return VoiceAssistantResponse(
      success: json['success'] as bool? ?? false,
      intent: (json['intent'] as String?) ?? 'Unknown',
      spokenReply: (json['spokenReply'] as String?) ??
          (json['replyMessage'] as String?) ??
          (json['message'] as String?) ??
          'تم استلام طلبك.',
      action: (json['action'] as String?) ?? 'none',
      data: json['data'],
      audioUrl: json['audioUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'success': success,
        'intent': intent,
        'spokenReply': spokenReply,
        'action': action,
        'data': data,
        'audioUrl': audioUrl,
      };
}
