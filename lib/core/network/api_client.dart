import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../config/api_config.dart';
import 'api_exception.dart';

/// Único punto que habla HTTP. Traduce códigos de error a ApiException.
class ApiClient {
  ApiClient({http.Client? client}) : _client = client ?? http.Client();
  final http.Client _client;

  Future<Map<String, dynamic>> get(String path, {Map<String, String>? query}) async {
    if (ApiConfig.apiKey.isEmpty) {
      throw ApiException('Falta la API key. Ejecuta con --dart-define=FOOTBALL_API_KEY=...');
    }
    final uri = Uri.parse('${ApiConfig.baseUrl}$path').replace(queryParameters: query);
    try {
      final res = await _client
          .get(uri, headers: {'X-Auth-Token': ApiConfig.apiKey})
          .timeout(const Duration(seconds: 15));
      final body = utf8.decode(res.bodyBytes);
      final json = body.isEmpty ? <String, dynamic>{} : jsonDecode(body) as Map<String, dynamic>;
      if (res.statusCode == 200) return json;
      throw ApiException(_messageFor(res.statusCode, json), statusCode: res.statusCode);
    } on SocketException {
      throw ApiException('Sin conexión a internet');
    } on TimeoutException {
      throw ApiException('El servidor tardó demasiado en responder');
    } on FormatException {
      throw ApiException('Respuesta inválida del servidor');
    }
  }

  String _messageFor(int code, Map<String, dynamic> json) {
    switch (code) {
      case 400:
        return 'Solicitud inválida (400): ${json['message'] ?? 'parámetros incorrectos'}';
      case 403:
        return 'Sin permiso (403): la API key no permite este recurso';
      case 404:
        return 'No encontrado (404): el recurso no existe';
      case 429:
        return 'Demasiadas peticiones (429): espera un minuto e intenta de nuevo';
      default:
        return 'Error del servidor ($code)';
    }
  }
}
