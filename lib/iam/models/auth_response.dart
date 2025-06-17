import 'package:equatable/equatable.dart';

class AuthResponse extends Equatable {
  final String token;
  final String? message;

  const AuthResponse({
    required this.token,
    this.message,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      token: json['token'] as String,
      message: json['message'] as String?,
    );
  }

  @override
  List<Object?> get props => [token, message];
}
