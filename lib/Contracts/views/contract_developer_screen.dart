import 'package:flutter/material.dart';
import '../../shared/components/custom_textfield.dart';
import '../../shared/components/primary_button.dart';
import '../../shared/constants/app_sizes.dart';
import '../models/developer.dart';
import '../contracts_routes.dart';

class ContractDeveloperScreen extends StatefulWidget {
  const ContractDeveloperScreen({super.key});

  @override
  State<ContractDeveloperScreen> createState() => _ContractDeveloperScreenState();
}

class _ContractDeveloperScreenState extends State<ContractDeveloperScreen> {
  final _searchController = TextEditingController();
  String? selectedDeveloperId;

  final developers = const <Developer>[
    Developer(id: '1', name: 'Javier Torres', contracts: 12, rating: 4),
    Developer(id: '2', name: 'Orlando Chavez', contracts: 9, rating: 5),
    Developer(id: '3', name: 'Jose Soto', contracts: 6, rating: 4),
    Developer(id: '4', name: 'Carlos Rojas', contracts: 8, rating: 3),
    Developer(id: '5', name: 'Maria Lopez', contracts: 4, rating: 5),
  ];

  List<Developer> get _filtered => developers
      .where((d) => d.name.toLowerCase().contains(_searchController.text.toLowerCase()))
      .toList();

  void _continue() {
    if (selectedDeveloperId != null) {
      Navigator.pushNamed(
        context,
        ContractsRoutes.create,
        arguments: {'developerId': selectedDeveloperId!},
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecciona un desarrollador.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Selecciona desarrollador')),
      body: Padding(
        padding: const EdgeInsets.all(AppSizes.paddingM),
        child: Column(
          children: [
            CustomTextField(
              hint: 'Buscar desarrollador',
              controller: _searchController,
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: AppSizes.paddingM),
            Expanded(
              child: _filtered.isEmpty
                  ? const Center(child: Text('No se encontraron desarrolladores.'))
                  : ListView.builder(
                itemCount: _filtered.length,
                itemBuilder: (_, i) {
                  final d = _filtered[i];
                  final isSel = d.id == selectedDeveloperId;
                  return Card(
                    color: isSel ? Colors.blue.withOpacity(0.3) : Colors.grey[900],
                    child: ListTile(
                      title: Text(d.name, style: const TextStyle(color: Colors.white)),
                      subtitle: Text('${d.contracts} contratos',
                          style: const TextStyle(color: Colors.white70)),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: List.generate(
                          d.rating,
                              (_) => const Icon(Icons.star, size: 16, color: Colors.orange),
                        ),
                      ),
                      onTap: () => setState(() => selectedDeveloperId = d.id),
                    ),
                  );
                },
              ),
            ),
            PrimaryButton(text: 'Siguiente', onPressed: _continue),
          ],
        ),
      ),
    );
  }
}
