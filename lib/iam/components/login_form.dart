import 'package:flutter/material.dart';
import '../../shared/components/custom_textfield.dart';
import '../../shared/components/primary_button.dart';
import '../../shared/utils/validators.dart';
import '../../shared/constants/app_strings.dart';
import '../services/auth_service.dart';
import '../models/auth_request.dart';
import '../../contracts/contracts_routes.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController    = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final request = AuthRequest(
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );

    try {
      final success = await AuthService().login(request);
      if (success && mounted) {
        Navigator.pushReplacementNamed(context, ContractsRoutes.list);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          CustomTextField(
            hint: AppStrings.emailHint,
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            validator: Validators.email,
          ),
          const SizedBox(height: 16),
          CustomTextField(
            hint: AppStrings.passwordHint,
            controller: _passwordController,
            obscure: true,
            validator: Validators.required,
          ),
          const SizedBox(height: 24),
          PrimaryButton(
            text: AppStrings.loginButton,
            isLoading: _isLoading,
            onPressed: _submit,
          ),
        ],
      ),
    );
  }
}
