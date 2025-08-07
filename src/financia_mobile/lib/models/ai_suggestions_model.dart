class AiSuggestionsResponse {
  final String mainSuggestion;
  final List<String> sideSuggestions;

  AiSuggestionsResponse({
    required this.mainSuggestion,
    required this.sideSuggestions,
  });

  factory AiSuggestionsResponse.fromJson(Map<String, dynamic> json) {
    return AiSuggestionsResponse(
      mainSuggestion: json['mainSuggestion'] ?? '',
      sideSuggestions: List<String>.from(json['sideSuggestions'] ?? []),
    );
  }
}

class AiPredictionsResponse {
  final String mainPrediction;
  final List<String> sidePredictions;

  AiPredictionsResponse({
    required this.mainPrediction,
    required this.sidePredictions,
  });

  factory AiPredictionsResponse.fromJson(Map<String, dynamic> json) {
    return AiPredictionsResponse(
      mainPrediction: json['mainPrediction'] ?? '',
      sidePredictions: List<String>.from(json['sidePredictions'] ?? []),
    );
  }
}

class AiChatResponse {
  final String aiResponse;

  AiChatResponse({required this.aiResponse});

  factory AiChatResponse.fromJson(Map<String, dynamic> json) {
    return AiChatResponse(aiResponse: json['aiResponse'] ?? '');
  }
}

class ChatMessage {
  final String message;
  final bool isUser;
  final DateTime timestamp;

  ChatMessage({
    required this.message,
    required this.isUser,
    required this.timestamp,
  });
}

class ChatWithAiRequest {
  final String prompt;

  ChatWithAiRequest({required this.prompt});

  Map<String, dynamic> toJson() {
    return {'prompt': prompt};
  }
}
