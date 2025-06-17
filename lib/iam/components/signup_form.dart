import 'package:flutter/material.dart';
import '../../shared/components/custom_textfield.dart';
import '../../shared/components/primary_button.dart';
import '../../shared/utils/validators.dart';
import '../../shared/constants/app_strings.dart';
import '../models/auth_request.dart';
import '../services/auth_service.dart';

class SignupForm extends StatefulWidget {
  const SignupForm({Key? key}) : super(key: key);

  @override
  State<SignupForm> createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController     = TextEditingController();
  final _emailController    = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final request = AuthRequest(
      name:     _nameController.text.trim(),
      email:    _emailController.text.trim(),
      password: _passwordController.text,
    );

    try {
      final success = await AuthService().signup(request);
      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registro exitoso. Inicia sesión.')),
        );
        Navigator.pushReplacementNamed(context, '/login');
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
            hint:      AppStrings.nameHint,
            controller: _nameController,
            validator: Validators.required,
          ),
          const SizedBox(height: 16),
          CustomTextField(
            hint:       AppStrings.emailHint,
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            validator:  Validators.email,
          ),
          const SizedBox(height: 16),
          CustomTextField(
            hint:       AppStrings.passwordHint,
            controller: _passwordController,
            obscure:    true,
            validator:  Validators.minLengthValidator(6),
          ),
          const SizedBox(height: 24),
          PrimaryButton(
            text:      AppStrings.signupButton,
            isLoading: _isLoading,
            onPressed: _submit,
          ),
        ],
      ),
    );
  }
}
