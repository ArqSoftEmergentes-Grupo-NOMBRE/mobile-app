import 'dart:convert';
import 'dart:io' show Platform;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class HttpClient {
  static final String baseUrl = Platform.isAndroid
      ? 'http://10.0.2.2:3000'
      : 'http://localhost:3000';
  //  static const String baseUrl = 'https://api.tarketcontracts.com';

  /// Recupera el token de sesión
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  /// Guarda el token
  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  /// Elimina el token
  static Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
  }

  static Map<String, String> _buildHeaders(
      String? token,
      Map<String, String>? additional,
      ) {
    final headers = <String, String>{ 'Content-Type': 'application/json' };
    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }
    if (additional != null) {
      headers.addAll(additional);
    }
    return headers;
  }

  static Future<http.Response> get(
      String endpoint, {
        Map<String, String>? headers,
        String? token,
      }) async {
    token ??= await getToken();
    final url = Uri.parse('$baseUrl$endpoint');
    return http.get(url, headers: _buildHeaders(token, headers));
  }

  static Future<http.Response> post(
      String endpoint,
      Map<String, dynamic> body, {
        Map<String, String>? headers,
        String? token,
      }) async {
    token ??= await getToken();
    final url = Uri.parse('$baseUrl$endpoint');
    return http.post(
      url,
      headers: _buildHeaders(token, headers),
      body: jsonEncode(body),
    );
  }

  static Future<http.Response> put(
      String endpoint,
      Map<String, dynamic> body, {
        Map<String, String>? headers,
        String? token,
      }) async {
    token ??= await getToken();
    final url = Uri.parse('$baseUrl$endpoint');
    return http.put(
      url,
      headers: _buildHeaders(token, headers),
      body: jsonEncode(body),
    );
  }

  static Future<http.Response> delete(
      String endpoint, {
        Map<String, String>? headers,
        String? token,
      }) async {
    token ??= await getToken();
    final url = Uri.parse('$baseUrl$endpoint');
    return http.delete(url, headers: _buildHeaders(token, headers));
  }
}
