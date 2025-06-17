import 'package:flutter/material.dart';
import '../../shared/components/logo.dart';
import '../../shared/constants/app_strings.dart';
import '../components/signup_form.dart';
import '../iam_routes.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 64),
              const AppLogo(),
              const SizedBox(height: 48),
              Text(
                AppStrings.signupTitle,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: const Color(0xFF0059DC),
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 32),
              const SignupForm(),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(AppStrings.haveAccount),
                  GestureDetector(
                    onTap: () => Navigator.pushReplacementNamed(
                      context,
                      AuthRoutes.login,
                    ),
                    child: Text(
                      AppStrings.goToLogin,
                      style: const TextStyle(
                        color: Color(0xFF0059DC),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
