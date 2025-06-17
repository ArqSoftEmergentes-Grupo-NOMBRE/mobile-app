// lib/contracts/views/contract_list_screen.dart

import 'package:flutter/material.dart';
import '../../shared/constants/app_sizes.dart';
import '../../shared/constants/app_strings.dart';
import '../components/contract_card.dart';
import '../models/contract.dart';
import '../services/contract_service.dart';
import '../contracts_routes.dart';

class ContractListScreen extends StatelessWidget {
  const ContractListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.contractsDashboard),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle, size: 28),
            tooltip: 'Mi perfil',
            onPressed: () {
              Navigator.pushNamed(context, '/account');
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Contract>>(
        future: ContractService().fetchAll(),
        builder: (ctx, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError) {
            return Center(child: Text('Error: ${snap.error}'));
          }
          final contracts = snap.data!;
          if (contracts.isEmpty) {
            return const Center(child: Text('No hay contratos.'));
          }
          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: AppSizes.paddingM),
            itemCount: contracts.length,
            itemBuilder: (ctx, i) {
              return ContractCard(contract: contracts[i]);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, ContractsRoutes.developer),
        child: const Icon(Icons.add),
      ),
    );
  }
}
