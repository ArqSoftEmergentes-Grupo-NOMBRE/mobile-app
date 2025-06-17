import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../shared/constants/app_sizes.dart';
import '../../shared/constants/app_strings.dart';
import '../contracts_routes.dart';
import '../models/contract.dart';
import '../models/enums.dart';

class ContractCard extends StatelessWidget {
  final Contract contract;

  const ContractCard({Key? key, required this.contract}) : super(key: key);

  Color _statusColor(ContractStatus s) {
    switch (s) {
      case ContractStatus.active:
        return Colors.greenAccent;
      case ContractStatus.pending:
        return Colors.orangeAccent;
      case ContractStatus.completed:
        return Colors.blueGrey;
      case ContractStatus.cancelled:
        return Colors.redAccent;
    }
  }

  @override
  Widget build(BuildContext context) {
    final total = contract.milestones.fold<double>(0, (sum, m) => sum + m.amount);
    final created = DateFormat('dd – MM – yyyy').format(contract.createdAt);

    return Card(
      margin: const EdgeInsets.symmetric(
        vertical: 8,
        horizontal: AppSizes.paddingM,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.borderRadius),
      ),
      color: Colors.grey[850],
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSizes.paddingM),
            child: Row(
              children: [
                // FOTO DEL DESARROLLADOR
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    contract.developerPhotoUrl,
                    width: 64,
                    height: 64,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      width: 64,
                      height: 64,
                      color: Colors.grey,
                      child: const Icon(Icons.person, color: Colors.white54),
                    ),
                  ),
                ),

                const SizedBox(width: AppSizes.paddingM),

                // DATOS Y BOTONES
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // TÍTULO
                      Text(
                        contract.projectTitle,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),

                      // NOMBRE DEL DEV
                      Text(
                        contract.developerName,
                        style: const TextStyle(color: Colors.white70),
                      ),
                      const SizedBox(height: 2),

                      // FECHA DE CREACIÓN
                      Text(
                        created,
                        style: const TextStyle(
                          color: Colors.white38,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 8),

                      // BOTONES, envueltos para que no overflow
                      Row(
                        children: [
                          Flexible(
                            child: ElevatedButton(
                              onPressed: () => Navigator.pushNamed(
                                context,
                                ContractsRoutes.delivery,
                                arguments: contract.id,
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black87,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text(AppStrings.viewDetails),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Flexible(
                            child: ElevatedButton(
                              onPressed: () {
                                final route = contract.status == ContractStatus.active
                                    ? ContractsRoutes.status
                                    : ContractsRoutes.signature;
                                Navigator.pushNamed(context, route,
                                    arguments: contract.id);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: contract.status == ContractStatus.active
                                    ? const Color(0xFFF06915)
                                    : Colors.black87,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Text(
                                contract.status == ContractStatus.active
                                    ? AppStrings.reviewButton
                                    : AppStrings.signatureButton,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // FRANJA DE ESTADO
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: _statusColor(contract.status),
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(AppSizes.borderRadius),
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              contract.status.displayName.toUpperCase(),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
