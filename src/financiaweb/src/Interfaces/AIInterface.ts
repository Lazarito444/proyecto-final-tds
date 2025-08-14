export interface Suggestion {
  mainSuggestion: string;
  sideSuggestions: string[];
}

export interface Prediction {
  mainPrediction: string;
  sidePredictions: string[];
}

export interface ChatMessage {
  role: "user" | "assistant";
  content: string;
}