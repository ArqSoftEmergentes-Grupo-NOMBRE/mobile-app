import 'package:flutter/material.dart';
import '../../shared/constants/app_sizes.dart';
import '../models/milestone.dart';
import '../services/contract_service.dart';
import '../contracts_routes.dart';

class ContractDeliveryScreen extends StatelessWidget {
  final String contractId;
  const ContractDeliveryScreen({super.key, required this.contractId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detalles de entrega')),
      body: FutureBuilder<List<Milestone>>(
        future: ContractService().fetchDelivery(contractId),
        builder: (ctx, snap) {
          if (snap.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError) {
            return Center(child: Text('Error: ${snap.error}'));
          }
          final items = snap.data!;
          return Padding(
            padding: const EdgeInsets.all(AppSizes.paddingM),
            child: Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    itemCount: items.length,
                    separatorBuilder: (_, __) => const Divider(),
                    itemBuilder: (_, i) {
                      final m = items[i];
                      return ListTile(
                        title: Text(m.description),
                        subtitle: Text(
                          'Entregado: ${m.deadline.toLocal().toIso8601String().split('T')[0]}',
                        ),
                        trailing:
                        Text('\$${m.amount.toStringAsFixed(2)}'),
                      );
                    },
                  ),
                ),
                const SizedBox(height: AppSizes.paddingM),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      ContractsRoutes.signature,
                      arguments: contractId,
                    );
                  },
                  child: const Text('Ver firma'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
