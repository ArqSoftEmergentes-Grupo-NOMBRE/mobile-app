import 'package:flutter/material.dart';
import '../components/profile_form.dart';
import '../../shared/constants/app_strings.dart';
import '../../IAM/iam_routes.dart';
import '../../shared/services/http_client.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  /// Cierra sesión y redirige al login, sin await en el gap
  void _logout(BuildContext context) {
    HttpClient.clearToken().then((_) {
      Navigator.pushReplacementNamed(context, AuthRoutes.login);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.accountTitle),
        leading: const BackButton(),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _logout(context),
            tooltip: 'Cerrar sesión',
          ),
        ],
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: ProfileForm(),
      ),
    );
  }
}
