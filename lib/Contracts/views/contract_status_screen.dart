// lib/contracts/views/contract_status_screen.dart

import 'package:flutter/material.dart';
import '../../shared/constants/app_sizes.dart';
import '../services/contract_service.dart';
import '../models/contract.dart';

class ContractStatusScreen extends StatelessWidget {
  final String contractId;
  const ContractStatusScreen({Key? key, required this.contractId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Estado del contrato')),
      body: FutureBuilder<Contract>(
        future: ContractService().fetchById(contractId),
        builder: (ctx, snap) {
          if (snap.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError) {
            return Center(child: Text('Error: ${snap.error}'));
          }
          final contract = snap.data!;
          if (contract.milestones.isEmpty) {
            return const Center(child: Text('No hay hitos definidos.'));
          }

          // Para ilustración: tomamos el primer hito como "próximo"
          final milestone = contract.milestones.first;
          final date = milestone.deadline.toLocal().toString().split(' ')[0];

          return Padding(
            padding: const EdgeInsets.all(AppSizes.paddingM),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSizes.borderRadius),
              ),
              child: Padding(
                padding: const EdgeInsets.all(AppSizes.paddingM),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Próximo Hito:', style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text(milestone.description, style: const TextStyle(fontSize: 18)),
                    const SizedBox(height: 8),
                    Text('Fecha límite: $date'),
                    const SizedBox(height: 8),
                    Text('Monto: \$${milestone.amount.toStringAsFixed(2)}'),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
