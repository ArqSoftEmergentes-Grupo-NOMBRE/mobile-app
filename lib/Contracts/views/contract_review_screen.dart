import 'package:flutter/material.dart';
import '../../shared/constants/app_sizes.dart';
import '../../shared/constants/app_strings.dart';
import '../../shared/components/primary_button.dart';
import '../contracts_routes.dart';
import '../services/contract_service.dart';

class ContractReviewScreen extends StatefulWidget {
  final Map<String, dynamic> contractData;
  const ContractReviewScreen({super.key, required this.contractData});

  @override
  State<ContractReviewScreen> createState() => _ContractReviewScreenState();
}

class _ContractReviewScreenState extends State<ContractReviewScreen> {
  bool _accepted = false;
  bool _sending  = false;

  List<Map<String, dynamic>> get _milestones =>
      List<Map<String, dynamic>>.from(widget.contractData['milestones'] ?? []);

  double get _total => _milestones.fold<double>(
    0,
        (sum, m) => sum + (double.tryParse(m['amount']?.toString() ?? '') ?? 0),
  );

  void _onSend() async {
    if (!_accepted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Debes aceptar y firmar el contrato.')),
      );
      return;
    }
    setState(() => _sending = true);

    // Crea y firma contrato
    // final newContract = Contract(…);
    // await ContractService().create(newContract);
    // await ContractService().signContract(newContract.id!);

    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      setState(() => _sending = false);
      Navigator.pushReplacementNamed(context, ContractsRoutes.success);
    }
  }

  @override
  Widget build(BuildContext context) {
    final data = widget.contractData;
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.contractSignature)),
      body: Padding(
        padding: const EdgeInsets.all(AppSizes.paddingM),
        child: ListView(
          children: [
            Text('${AppStrings.noAccount} ${data['developerId']}', style: const TextStyle(fontWeight: FontWeight.bold)),
            Text('${AppStrings.newContract}: ${data['title']}'),
            Text('${AppStrings.contractSummary}: ${data['description']}'),
            const SizedBox(height: 20),
            const Text('Hitos:', style: TextStyle(fontWeight: FontWeight.bold)),
            ..._milestones.map((m) => ListTile(
              title: Text(m['description'] ?? ''),
              subtitle: Text('Fecha límite: ${m['deadline'] ?? ''}'),
              trailing: Text('\$${m['amount']}'),
            )),
            const Divider(),
            Text('${AppStrings.paymentMethod}: \$${_total.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: AppSizes.paddingL),
            CheckboxListTile(
              value   : _accepted,
              onChanged: (v) => setState(() => _accepted = v ?? false),
              title   : const Text('Confirmo que revisé y acepto.'),
            ),
            const SizedBox(height: AppSizes.paddingL),
            PrimaryButton(
              text     : _sending ? 'Enviando…' : 'Enviar',
              isLoading: _sending,
              onPressed: _sending ? null : _onSend,
            ),
          ],
        ),
      ),
    );
  }
}
