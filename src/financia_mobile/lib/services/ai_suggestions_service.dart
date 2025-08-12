/*import 'dart:io';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:financia_mobile/config/app_preferences.dart';
import 'package:financia_mobile/models/ai_suggestions_model.dart';

class AiSuggestionsService {
  final Dio dio = Dio(
    BaseOptions(
      baseUrl: 'http://10.0.0.13:5189/api/',
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
    ),
  );

  // Método para verificar si el usuario tiene transacciones
  Future<bool> hasTransactions() async {
    final token = await AppPreferences.getStringPreference('accessToken');

    try {
      final response = await dio.get(
        'transaction',
        options: Options(
          headers: {
            HttpHeaders.authorizationHeader: 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        final transactions = response.data as List?;
        return transactions != null && transactions.isNotEmpty;
      }
      return false;
    } catch (e) {
      debugPrint('Error verificando transacciones: $e');
      return false; // Asumimos que no hay transacciones si hay error
    }
  }

  Future<AiSuggestionsResponse> getSuggestions({String lang = 'es'}) async {
    // Primero verificar si hay transacciones
    final hasUserTransactions = await hasTransactions();

    if (!hasUserTransactions) {
      return AiSuggestionsResponse(
        mainSuggestion:
            "Para poder generar sugerencias personalizadas, necesitas registrar algunas transacciones primero. ¡Comienza agregando tus ingresos y gastos!",
        sideSuggestions: [
          "Registra tus ingresos mensuales",
          "Anota tus gastos principales",
          "Categoriza tus transacciones correctamente",
        ],
      );
    }

    final token = await AppPreferences.getStringPreference('accessToken');

    debugPrint('=== INICIANDO PETICIÓN DE SUGERENCIAS ===');
    debugPrint('Token: ${token?.substring(0, 20)}...');
    debugPrint('Lang: $lang');

    try {
      final response = await dio.get(
        'ai/suggestions',
        queryParameters: {'lang': lang},
        options: Options(
          headers: {
            HttpHeaders.authorizationHeader: 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      debugPrint('Status Code: ${response.statusCode}');
      debugPrint('Response Data: ${response.data}');

      if (response.statusCode == 200) {
        final data = response.data;

        // Verificar si la respuesta contiene JSON crudo de OpenAI
        if (_isOpenAIRawResponse(data)) {
          debugPrint('Detectado JSON crudo de OpenAI, extrayendo contenido...');
          return _extractFromOpenAIResponse(data);
        }

        return AiSuggestionsResponse.fromJson(data);
      } else {
        throw Exception("Error al obtener sugerencias: ${response.statusCode}");
      }
    } on DioException catch (e) {
      debugPrint('=== ERROR EN SUGERENCIAS ===');
      debugPrint('Tipo de error: ${e.type}');
      debugPrint('Mensaje: ${e.message}');
      debugPrint('Response: ${e.response?.data}');
      debugPrint('Status Code: ${e.response?.statusCode}');

      String errorMessage = "Error al obtener sugerencias";

      if (e.response?.statusCode == 500) {
        final responseData = e.response?.data;
        if (responseData is String) {
          if (responseData.contains("API Key")) {
            errorMessage =
                "El servidor no tiene configurada la API Key de OpenAI";
          } else {
            errorMessage = "Error interno del servidor: $responseData";
          }
        }
      } else if (e.response?.statusCode == 401) {
        errorMessage = "No autorizado. Verifica tu sesión";
      } else if (e.type == DioExceptionType.connectionTimeout) {
        errorMessage = "Tiempo de conexión agotado";
      } else if (e.type == DioExceptionType.receiveTimeout) {
        errorMessage = "Tiempo de respuesta agotado";
      } else {
        errorMessage = "Error de conexión: ${e.message}";
      }

      throw Exception(errorMessage);
    } catch (e) {
      debugPrint('Error inesperado: $e');
      throw Exception("Error inesperado: $e");
    }
  }

  Future<AiPredictionsResponse> getPredictions({String lang = 'es'}) async {
    // Primero verificar si hay transacciones
    final hasUserTransactions = await hasTransactions();

    if (!hasUserTransactions) {
      return AiPredictionsResponse(
        mainPrediction:
            "Para generar predicciones financieras precisas, necesitas tener un historial de transacciones. ¡Empieza registrando tus movimientos financieros!",
        sidePredictions: [
          "Registra al menos un mes de transacciones",
          "Incluye tanto ingresos como gastos",
          "Mantén un registro constante para mejores predicciones",
        ],
      );
    }

    final token = await AppPreferences.getStringPreference('accessToken');

    debugPrint('=== INICIANDO PETICIÓN DE PREDICCIONES ===');
    debugPrint('Token: ${token?.substring(0, 20)}...');
    debugPrint('Lang: $lang');

    try {
      final response = await dio.get(
        'ai/predictions',
        queryParameters: {'lang': lang},
        options: Options(
          headers: {
            HttpHeaders.authorizationHeader: 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      debugPrint('Status Code: ${response.statusCode}');
      debugPrint('Response Data: ${response.data}');

      if (response.statusCode == 200) {
        final data = response.data;

        // Verificar si la respuesta contiene JSON crudo de OpenAI
        if (_isOpenAIRawResponse(data)) {
          debugPrint('Detectado JSON crudo de OpenAI, extrayendo contenido...');
          return _extractPredictionsFromOpenAIResponse(data);
        }

        return AiPredictionsResponse.fromJson(data);
      } else {
        throw Exception(
          "Error al obtener predicciones: ${response.statusCode}",
        );
      }
    } on DioException catch (e) {
      debugPrint('=== ERROR EN PREDICCIONES ===');
      debugPrint('Tipo de error: ${e.type}');
      debugPrint('Mensaje: ${e.message}');
      debugPrint('Response: ${e.response?.data}');
      debugPrint('Status Code: ${e.response?.statusCode}');

      String errorMessage = "Error al obtener predicciones";

      if (e.response?.statusCode == 500) {
        final responseData = e.response?.data;
        if (responseData is String) {
          if (responseData.contains("API Key")) {
            errorMessage =
                "El servidor no tiene configurada la API Key de OpenAI";
          } else {
            errorMessage = "Error interno del servidor: $responseData";
          }
        }
      } else if (e.response?.statusCode == 401) {
        errorMessage = "No autorizado. Verifica tu sesión";
      } else if (e.type == DioExceptionType.connectionTimeout) {
        errorMessage = "Tiempo de conexión agotado";
      } else if (e.type == DioExceptionType.receiveTimeout) {
        errorMessage = "Tiempo de respuesta agotado";
      } else {
        errorMessage = "Error de conexión: ${e.message}";
      }

      throw Exception(errorMessage);
    } catch (e) {
      debugPrint('Error inesperado: $e');
      throw Exception("Error inesperado: $e");
    }
  }

  Future<AiChatResponse> chatWithAi(
    ChatWithAiRequest request, {
    String lang = 'es',
  }) async {
    // Verificar si hay transacciones para el chat también
    final hasUserTransactions = await hasTransactions();

    if (!hasUserTransactions) {
      return AiChatResponse(
        aiResponse:
            "Para poder ayudarte con consultas financieras personalizadas, necesitas tener transacciones registradas en tu cuenta. Por favor, agrega algunas transacciones primero y luego podrás hacer preguntas específicas sobre tus finanzas.",
      );
    }

    final token = await AppPreferences.getStringPreference('accessToken');

    debugPrint('=== INICIANDO CHAT CON IA ===');
    debugPrint('Token: ${token?.substring(0, 20)}...');
    debugPrint('Lang: $lang');
    debugPrint('Prompt: ${request.prompt}');

    try {
      final response = await dio.post(
        'ai/chatbot',
        queryParameters: {'lang': lang},
        data: request.toJson(),
        options: Options(
          headers: {
            HttpHeaders.authorizationHeader: 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      debugPrint('Status Code: ${response.statusCode}');
      debugPrint('Response Data: ${response.data}');

      if (response.statusCode == 200) {
        final data = response.data;

        // Verificar si la respuesta contiene JSON crudo de OpenAI
        if (_isOpenAIRawResponse(data)) {
          debugPrint('Detectado JSON crudo de OpenAI, extrayendo contenido...');
          return _extractChatFromOpenAIResponse(data);
        }

        return AiChatResponse.fromJson(data);
      } else {
        throw Exception("Error al chatear con IA: ${response.statusCode}");
      }
    } on DioException catch (e) {
      debugPrint('=== ERROR EN CHAT ===');
      debugPrint('Tipo de error: ${e.type}');
      debugPrint('Mensaje: ${e.message}');
      debugPrint('Response: ${e.response?.data}');
      debugPrint('Status Code: ${e.response?.statusCode}');

      String errorMessage = "Error al chatear con IA";

      if (e.response?.statusCode == 500) {
        final responseData = e.response?.data;
        if (responseData is String) {
          if (responseData.contains("API Key")) {
            errorMessage =
                "El servidor no tiene configurada la API Key de OpenAI";
          } else {
            errorMessage = "Error interno del servidor: $responseData";
          }
        }
      } else if (e.response?.statusCode == 401) {
        errorMessage = "No autorizado. Verifica tu sesión";
      } else if (e.type == DioExceptionType.connectionTimeout) {
        errorMessage = "Tiempo de conexión agotado";
      } else if (e.type == DioExceptionType.receiveTimeout) {
        errorMessage = "Tiempo de respuesta agotado";
      } else {
        errorMessage = "Error de conexión: ${e.message}";
      }

      throw Exception(errorMessage);
    } catch (e) {
      debugPrint('Error inesperado: $e');
      throw Exception("Error inesperado: $e");
    }
  }

  // Método para detectar si la respuesta es JSON crudo de OpenAI
  bool _isOpenAIRawResponse(dynamic data) {
    if (data is Map<String, dynamic>) {
      return data.containsKey('id') &&
          data.containsKey('object') &&
          data.containsKey('choices') &&
          data['object'] == 'chat.completion';
    }
    return false;
  }

  // Extraer contenido de respuesta cruda de OpenAI para sugerencias
  AiSuggestionsResponse _extractFromOpenAIResponse(Map<String, dynamic> data) {
    try {
      final content = data['choices'][0]['message']['content'] as String;

      // Intentar parsear como JSON
      try {
        final Map<String, dynamic> parsedContent = Map<String, dynamic>.from(
          jsonDecode(content),
        );
        return AiSuggestionsResponse.fromJson({
          'MainSuggestion':
              parsedContent['mainSuggestion'] ??
              parsedContent['MainSuggestion'] ??
              content,
          'SideSuggestions':
              parsedContent['sideSuggestions'] ??
              parsedContent['SideSuggestions'] ??
              [],
        });
      } catch (e) {
        // Si no se puede parsear como JSON, usar el contenido como sugerencia principal
        return AiSuggestionsResponse(
          mainSuggestion: content,
          sideSuggestions: [],
        );
      }
    } catch (e) {
      return AiSuggestionsResponse(
        mainSuggestion: "Error al procesar la respuesta de la IA",
        sideSuggestions: [],
      );
    }
  }

  // Extraer contenido de respuesta cruda de OpenAI para predicciones
  AiPredictionsResponse _extractPredictionsFromOpenAIResponse(
    Map<String, dynamic> data,
  ) {
    try {
      final content = data['choices'][0]['message']['content'] as String;

      // Intentar parsear como JSON
      try {
        final Map<String, dynamic> parsedContent = Map<String, dynamic>.from(
          jsonDecode(content),
        );
        return AiPredictionsResponse.fromJson({
          'MainPrediction':
              parsedContent['mainPrediction'] ??
              parsedContent['MainPrediction'] ??
              content,
          'SidePredictions':
              parsedContent['sidePredictions'] ??
              parsedContent['SidePredictions'] ??
              [],
        });
      } catch (e) {
        return AiPredictionsResponse(
          mainPrediction: content,
          sidePredictions: [],
        );
      }
    } catch (e) {
      return AiPredictionsResponse(
        mainPrediction: "Error al procesar la respuesta de la IA",
        sidePredictions: [],
      );
    }
  }

  // Extraer contenido de respuesta cruda de OpenAI para chat
  AiChatResponse _extractChatFromOpenAIResponse(Map<String, dynamic> data) {
    try {
      final content = data['choices'][0]['message']['content'] as String;
      return AiChatResponse(aiResponse: content);
    } catch (e) {
      return AiChatResponse(
        aiResponse: "Error al procesar la respuesta de la IA",
      );
    }
  }
}*/
import 'dart:io';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:financia_mobile/config/dio_factory.dart';
import 'package:financia_mobile/generated/l10n.dart';
import 'package:financia_mobile/config/app_preferences.dart';
import 'package:financia_mobile/models/ai_suggestions_model.dart';
import 'package:flutter/src/widgets/framework.dart';

class AiSuggestionsService {
  final Dio dio = DioFactory.createDio();

  BuildContext? get context => null;

  // Método para verificar si el usuario tiene transacciones
  Future<bool> hasTransactions() async {
    final token = await AppPreferences.getStringPreference('accessToken');

    try {
      final response = await dio.get(
        'transaction',
        options: Options(
          headers: {
            HttpHeaders.authorizationHeader: 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        final transactions = response.data as List?;
        return transactions != null && transactions.isNotEmpty;
      }
      return false;
    } catch (e) {
      debugPrint('Error verificando transacciones: $e');
      return false; // Asumimos que no hay transacciones si hay error
    }
  }

  Future<AiSuggestionsResponse> getSuggestions({String lang = 'es'}) async {
    // Primero verificar si hay transacciones
    final hasUserTransactions = await hasTransactions();

    if (!hasUserTransactions) {
      return AiSuggestionsResponse(
        mainSuggestion:
            "Para poder generar sugerencias personalizadas, necesitas registrar algunas transacciones primero. ¡Comienza agregando tus ingresos y gastos!",
        sideSuggestions: [
          "Registra tus ingresos mensuales",
          "Anota tus gastos principales",
          "Categoriza tus transacciones correctamente",
        ],
      );
    }

    final token = await AppPreferences.getStringPreference('accessToken');

    debugPrint('=== INICIANDO PETICIÓN DE SUGERENCIAS ===');
    debugPrint('Token: ${token?.substring(0, 20)}...');
    debugPrint('Lang: $lang');

    try {
      final response = await dio.get(
        'ai/suggestions',
        queryParameters: {'lang': lang},
        options: Options(
          headers: {
            HttpHeaders.authorizationHeader: 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      debugPrint('Status Code: ${response.statusCode}');
      debugPrint('Response Data: ${response.data}');

      if (response.statusCode == 200) {
        final data = response.data;

        // Verificar si la respuesta contiene JSON crudo de OpenAI
        if (_isOpenAIRawResponse(data)) {
          debugPrint('Detectado JSON crudo de OpenAI, extrayendo contenido...');
          return _extractFromOpenAIResponse(data);
        }

        return AiSuggestionsResponse.fromJson(data);
      } else {
        throw Exception("Error al obtener sugerencias: ${response.statusCode}");
      }
    } on DioException catch (e) {
      debugPrint('=== ERROR EN SUGERENCIAS ===');
      debugPrint('Tipo de error: ${e.type}');
      debugPrint('Mensaje: ${e.message}');
      debugPrint('Response: ${e.response?.data}');
      debugPrint('Status Code: ${e.response?.statusCode}');

      String errorMessage = "Error al obtener sugerencias";

      if (e.response?.statusCode == 500) {
        final responseData = e.response?.data;
        if (responseData is String) {
          if (responseData.contains("API Key")) {
            errorMessage =
                "El servidor no tiene configurada la API Key de OpenAI";
          } else {
            errorMessage = "Error interno del servidor: $responseData";
          }
        }
      } else if (e.response?.statusCode == 401) {
        errorMessage = "No autorizado. Verifica tu sesión";
      } else if (e.type == DioExceptionType.connectionTimeout) {
        errorMessage = "Tiempo de conexión agotado";
      } else if (e.type == DioExceptionType.receiveTimeout) {
        errorMessage = "Tiempo de respuesta agotado";
      } else {
        errorMessage = "Error de conexión: ${e.message}";
      }

      throw Exception(errorMessage);
    } catch (e) {
      debugPrint('Error inesperado: $e');
      throw Exception("Error inesperado: $e");
    }
  }

  Future<AiPredictionsResponse> getPredictions({String lang = 'es'}) async {
    // Primero verificar si hay transacciones
    final hasUserTransactions = await hasTransactions();

    if (!hasUserTransactions) {
      return AiPredictionsResponse(
        mainPrediction: S.of(context!).no_transactions_predictions_main,
        sidePredictions: [
          S.of(context!).no_transactions_predictions_side1,
          S.of(context!).no_transactions_predictions_side2,
          S.of(context!).no_transactions_predictions_side3,
        ],
      );
    }

    final token = await AppPreferences.getStringPreference('accessToken');

    debugPrint('=== INICIANDO PETICIÓN DE PREDICCIONES ===');
    debugPrint('Token: ${token?.substring(0, 20)}...');
    debugPrint('Lang: $lang');

    try {
      final response = await dio.get(
        'ai/predictions',
        queryParameters: {'lang': lang},
        options: Options(
          headers: {
            HttpHeaders.authorizationHeader: 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      debugPrint('Status Code: ${response.statusCode}');
      debugPrint('Response Data: ${response.data}');

      if (response.statusCode == 200) {
        final data = response.data;

        // Verificar si la respuesta contiene JSON crudo de OpenAI
        if (_isOpenAIRawResponse(data)) {
          debugPrint('Detectado JSON crudo de OpenAI, extrayendo contenido...');
          return _extractPredictionsFromOpenAIResponse(data);
        }

        return AiPredictionsResponse.fromJson(data);
      } else {
        throw Exception(
          "Error al obtener predicciones: ${response.statusCode}",
        );
      }
    } on DioException catch (e) {
      debugPrint('=== ERROR EN PREDICCIONES ===');
      debugPrint('Tipo de error: ${e.type}');
      debugPrint('Mensaje: ${e.message}');
      debugPrint('Response: ${e.response?.data}');
      debugPrint('Status Code: ${e.response?.statusCode}');

      String errorMessage = "Error al obtener predicciones";

      if (e.response?.statusCode == 500) {
        final responseData = e.response?.data;
        if (responseData is String) {
          if (responseData.contains("API Key")) {
            errorMessage =
                "El servidor no tiene configurada la API Key de OpenAI";
          } else {
            errorMessage = "Error interno del servidor: $responseData";
          }
        }
      } else if (e.response?.statusCode == 401) {
        errorMessage = "No autorizado. Verifica tu sesión";
      } else if (e.type == DioExceptionType.connectionTimeout) {
        errorMessage = "Tiempo de conexión agotado";
      } else if (e.type == DioExceptionType.receiveTimeout) {
        errorMessage = "Tiempo de respuesta agotado";
      } else {
        errorMessage = "Error de conexión: ${e.message}";
      }

      throw Exception(errorMessage);
    } catch (e) {
      debugPrint('Error inesperado: $e');
      throw Exception("Error inesperado: $e");
    }
  }

  Future<AiChatResponse> chatWithAi(
    ChatWithAiRequest request, {
    String lang = 'es',
  }) async {
    // Verificar si hay transacciones para el chat también
    final hasUserTransactions = await hasTransactions();

    if (!hasUserTransactions) {
      return AiChatResponse(
        aiResponse:
            "Para poder ayudarte con consultas financieras personalizadas, necesitas tener transacciones registradas en tu cuenta. Por favor, agrega algunas transacciones primero y luego podrás hacer preguntas específicas sobre tus finanzas.",
      );
    }

    final token = await AppPreferences.getStringPreference('accessToken');

    debugPrint('=== INICIANDO CHAT CON IA ===');
    debugPrint('Token: ${token?.substring(0, 20)}...');
    debugPrint('Lang: $lang');
    debugPrint('Prompt: ${request.prompt}');

    try {
      final response = await dio.post(
        'ai/chatbot',
        queryParameters: {'lang': lang},
        data: request.toJson(),
        options: Options(
          headers: {
            HttpHeaders.authorizationHeader: 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      debugPrint('Status Code: ${response.statusCode}');
      debugPrint('Response Data: ${response.data}');

      if (response.statusCode == 200) {
        final data = response.data;

        // Verificar si la respuesta contiene JSON crudo de OpenAI
        if (_isOpenAIRawResponse(data)) {
          debugPrint('Detectado JSON crudo de OpenAI, extrayendo contenido...');
          return _extractChatFromOpenAIResponse(data);
        }

        return AiChatResponse.fromJson(data);
      } else {
        throw Exception("Error al chatear con IA: ${response.statusCode}");
      }
    } on DioException catch (e) {
      debugPrint('=== ERROR EN CHAT ===');
      debugPrint('Tipo de error: ${e.type}');
      debugPrint('Mensaje: ${e.message}');
      debugPrint('Response: ${e.response?.data}');
      debugPrint('Status Code: ${e.response?.statusCode}');

      String errorMessage = "Error al chatear con IA";

      if (e.response?.statusCode == 500) {
        final responseData = e.response?.data;
        if (responseData is String) {
          if (responseData.contains("API Key")) {
            errorMessage =
                "El servidor no tiene configurada la API Key de OpenAI";
          } else {
            errorMessage = "Error interno del servidor: $responseData";
          }
        }
      } else if (e.response?.statusCode == 401) {
        errorMessage = "No autorizado. Verifica tu sesión";
      } else if (e.type == DioExceptionType.connectionTimeout) {
        errorMessage = "Tiempo de conexión agotado";
      } else if (e.type == DioExceptionType.receiveTimeout) {
        errorMessage = "Tiempo de respuesta agotado";
      } else {
        errorMessage = "Error de conexión: ${e.message}";
      }

      throw Exception(errorMessage);
    } catch (e) {
      debugPrint('Error inesperado: $e');
      throw Exception("Error inesperado: $e");
    }
  }

  // Método para detectar si la respuesta es JSON crudo de OpenAI
  bool _isOpenAIRawResponse(dynamic data) {
    if (data is Map<String, dynamic>) {
      return data.containsKey('id') &&
          data.containsKey('object') &&
          data.containsKey('choices') &&
          data['object'] == 'chat.completion';
    }
    return false;
  }

  // Extraer contenido de respuesta cruda de OpenAI para sugerencias
  AiSuggestionsResponse _extractFromOpenAIResponse(Map<String, dynamic> data) {
    try {
      final content = data['choices'][0]['message']['content'] as String;

      // Intentar parsear como JSON
      try {
        final Map<String, dynamic> parsedContent = Map<String, dynamic>.from(
          jsonDecode(content),
        );
        return AiSuggestionsResponse.fromJson({
          'MainSuggestion':
              parsedContent['mainSuggestion'] ??
              parsedContent['MainSuggestion'] ??
              content,
          'SideSuggestions':
              parsedContent['sideSuggestions'] ??
              parsedContent['SideSuggestions'] ??
              [],
        });
      } catch (e) {
        // Si no se puede parsear como JSON, usar el contenido como sugerencia principal
        return AiSuggestionsResponse(
          mainSuggestion: content,
          sideSuggestions: [],
        );
      }
    } catch (e) {
      return AiSuggestionsResponse(
        mainSuggestion: "Error al procesar la respuesta de la IA",
        sideSuggestions: [],
      );
    }
  }

  // Extraer contenido de respuesta cruda de OpenAI para predicciones
  AiPredictionsResponse _extractPredictionsFromOpenAIResponse(
    Map<String, dynamic> data,
  ) {
    try {
      final content = data['choices'][0]['message']['content'] as String;

      // Intentar parsear como JSON
      try {
        final Map<String, dynamic> parsedContent = Map<String, dynamic>.from(
          jsonDecode(content),
        );
        return AiPredictionsResponse.fromJson({
          'MainPrediction':
              parsedContent['mainPrediction'] ??
              parsedContent['MainPrediction'] ??
              content,
          'SidePredictions':
              parsedContent['sidePredictions'] ??
              parsedContent['SidePredictions'] ??
              [],
        });
      } catch (e) {
        return AiPredictionsResponse(
          mainPrediction: content,
          sidePredictions: [],
        );
      }
    } catch (e) {
      return AiPredictionsResponse(
        mainPrediction: "Error al procesar la respuesta de la IA",
        sidePredictions: [],
      );
    }
  }

  // Extraer contenido de respuesta cruda de OpenAI para chat
  AiChatResponse _extractChatFromOpenAIResponse(Map<String, dynamic> data) {
    try {
      final content = data['choices'][0]['message']['content'] as String;
      return AiChatResponse(aiResponse: content);
    } catch (e) {
      return AiChatResponse(
        aiResponse: "Error al procesar la respuesta de la IA",
      );
    }
  }
}
