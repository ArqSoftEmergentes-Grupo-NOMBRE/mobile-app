import 'dart:convert';
import '../../shared/services/http_client.dart';
import '../models/auth_request.dart';
import '../models/auth_response.dart';

abstract class IAuthService {
  Future<bool> login(AuthRequest request);
  Future<bool> signup(AuthRequest request);
  Future<void> logout();
  Future<String?> getToken();
  Future<bool> isLoggedIn();
}

class AuthService implements IAuthService {
  static const _loginPath  = '/auth/login';
  static const _signupPath = '/auth/signup';

  @override
  Future<bool> login(AuthRequest request) async {
    final res = await HttpClient.post(_loginPath, request.toJson());
    if (res.statusCode == 200) {
      final body = jsonDecode(res.body) as Map<String, dynamic>;
      final auth = AuthResponse.fromJson(body);
      await HttpClient.saveToken(auth.token);
      return true;
    }
    throw Exception('Error al iniciar sesión: ${res.body}');
  }

  @override
  Future<bool> signup(AuthRequest request) async {
    final res = await HttpClient.post(_signupPath, request.toJson());
    if (res.statusCode == 201) return true;
    throw Exception('Error al registrarse: ${res.body}');
  }

  @override
  Future<void> logout() async {
    await HttpClient.clearToken();
  }

  @override
  Future<String?> getToken() => HttpClient.getToken();

  @override
  Future<bool> isLoggedIn() async {
    final t = await getToken();
    return t != null && t.isNotEmpty;
  }
}
