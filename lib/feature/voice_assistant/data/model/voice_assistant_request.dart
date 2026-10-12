class VoiceAssistantRequest {
  final String query;
  final String? currentScreen;

  const VoiceAssistantRequest({
    required this.query,
    this.currentScreen,
  });

  Map<String, dynamic> toJson() => {
        'query': query,
        if (currentScreen != null) 'currentScreen': currentScreen,
      };
}
