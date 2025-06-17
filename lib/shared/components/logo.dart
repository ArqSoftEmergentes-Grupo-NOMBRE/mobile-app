import 'package:flutter/material.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      width: 100,
      child: Image.asset(
        'assets/images/Logo-Application.png',
        fit: BoxFit.contain,
      ),
    );
  }
}
