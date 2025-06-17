import 'package:flutter/material.dart';
import 'Profile/profile_routes.dart';
import 'shared/theme/app_theme.dart';
import 'iam/iam_routes.dart';
import 'Profile/profile_routes.dart';
import 'Contracts/contracts_routes.dart';

void main() => runApp(const TarketApp());

class TarketApp extends StatelessWidget {
  const TarketApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tarket Contracts',
      theme: AppTheme.darkTheme,
      initialRoute: AuthRoutes.login,
      routes: {
        ...AuthRoutes.getRoutes(),
        ...ProfileRoutes.getRoutes(),
        ...ContractsRoutes.getRoutes(),
      },
    );
  }
}
