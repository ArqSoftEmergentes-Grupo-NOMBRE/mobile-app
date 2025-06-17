import 'package:flutter/material.dart';
import '../../shared/components/primary_button.dart';
import '../../shared/constants/app_sizes.dart';
import '../../shared/constants/app_strings.dart';
import '../models/contract.dart';
import '../models/enums.dart';
import '../services/contract_service.dart';

class ContractDetailsScreen extends StatelessWidget {
  final String contractId;
  const ContractDetailsScreen({super.key, required this.contractId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.contractDetails)),
      body: FutureBuilder<Contract>(
        future: ContractService().fetchById(contractId),
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError) {
            return Center(child: Text('Error: ${snap.error}'));
          }
          final contract = snap.data!;
          final total = contract.milestones.fold<double>(
              0, (sum, m) => sum + m.amount);
          return Padding(
            padding: const EdgeInsets.all(AppSizes.paddingM),
            child: ListView(
              children: [
                Text(contract.projectTitle,
                    style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: AppSizes.paddingS),
                Text(contract.projectDescription),
                const SizedBox(height: AppSizes.paddingM),
                const Text('Hitos:', style: TextStyle(fontWeight: FontWeight.bold)),
                ...contract.milestones.map((m) => ListTile(
                  title: Text(m.description),
                  subtitle: Text(
                      'Fecha límite: ${m.deadline.toLocal().toIso8601String().split('T')[0]}'),
                  trailing: Text('\$${m.amount.toStringAsFixed(2)}'),
                )),
                const Divider(),
                Text('Total: \$${total.toStringAsFixed(2)}',
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: AppSizes.paddingM),
                if (contract.status == ContractStatus.pending)
                  PrimaryButton(
                    text: 'Firmar contrato',
                    onPressed: () async {
                      await ContractService().signContract(contract.id!);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Contrato firmado.')),
                      );
                      Navigator.pop(context);
                    },
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
