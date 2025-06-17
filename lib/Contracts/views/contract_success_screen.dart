import 'package:flutter/material.dart';
import '../contracts_routes.dart';
import '../../shared/constants/app_strings.dart';
import '../../shared/components/primary_button.dart';

class ContractSuccessScreen extends StatelessWidget {
  const ContractSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle, size: 96, color: Colors.orange),
            const SizedBox(height: 32),
            const Text(
              AppStrings.contractConfirmation,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            PrimaryButton(
              text: 'Volver a contratos',
              onPressed: () => Navigator.pushNamedAndRemoveUntil(
                context,
                ContractsRoutes.list,
                    (r) => false,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
