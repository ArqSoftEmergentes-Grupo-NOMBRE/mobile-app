import 'package:flutter/material.dart';
import 'views/login_screen.dart';
import 'views/signup_screen.dart';

class AuthRoutes {
  static const String login  = '/login';
  static const String signup = '/signup';

  static Map<String, WidgetBuilder> getRoutes() => {
    login : (ctx) => const LoginScreen(),
    signup: (ctx) => const SignupScreen(),
  };
}
