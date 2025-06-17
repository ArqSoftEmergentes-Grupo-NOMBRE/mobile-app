// lib/contracts/views/contract_payments_screen.dart

import 'package:flutter/material.dart';
import 'package:file_selector/file_selector.dart';           // ← selector federado
import '../../shared/constants/app_sizes.dart';             // ← faltaba
import '../../shared/constants/app_strings.dart';
import '../../shared/components/primary_button.dart';
import '../contracts_routes.dart';
import '../models/create_contract_args.dart';
import '../components/milestone_row.dart';
import '../models/milestone.dart';

class ContractPaymentsScreen extends StatefulWidget {
  final CreateContractArgs args;
  const ContractPaymentsScreen({super.key, required this.args});

  @override
  State<ContractPaymentsScreen> createState() => _ContractPaymentsScreenState();
}

class _ContractPaymentsScreenState extends State<ContractPaymentsScreen> {
  final List<Milestone> _milestones = [];
  String? _pickedFilePath;
  String? _pickedFileName;

  void _addMilestone() {
    setState(() {
      _milestones.add(
        Milestone(
          id: DateTime.now().toIso8601String(),
          description: '',
          amount: 0,
          deadline: DateTime.now(),
        ),
      );
    });
  }

  double get _total =>
      _milestones.fold<double>(0, (sum, m) => sum + m.amount);

  /// ⇨ Nuevo: selecciona archivo con file_selector
  Future<void> _pickReferenceFile() async {
    // Acepta cualquier tipo de archivo
    final typeGroup = XTypeGroup(label: 'todos', extensions: ['*']);
    final XFile? result = await openFile(acceptedTypeGroups: [typeGroup]);

    if (result != null) {
      setState(() {
        _pickedFilePath = result.path;
        _pickedFileName = result.name;
      });
    }
  }

  void _continue() {
    final reviewArgs = {
      'developerId': widget.args.developerId,
      'title': widget.args.title,
      'description': widget.args.description,
      'referenceFile': _pickedFilePath,
      'milestones': _milestones.map((m) => {
        'description': m.description,
        'amount': m.amount.toString(),
        'deadline': m.deadline.toIso8601String(),
      }).toList(),
    };
    Navigator.pushNamed(
      context,
      ContractsRoutes.review,
      arguments: reviewArgs,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
      AppBar(title: const Text(AppStrings.contractSignature)),
      body: Padding(
        padding: const EdgeInsets.all(AppSizes.paddingM),
        child: Column(
          children: [
            // Lista dinámica de hitos
            Expanded(
              child: ListView.builder(
                itemCount: _milestones.length,
                itemBuilder: (ctx, i) {
                  final m = _milestones[i];
                  return MilestoneRow(
                    milestone: m,
                    editable: true,
                    onDescriptionChanged: (v) {
                      setState(() {
                        _milestones[i] = m.copyWith(description: v);
                      });
                    },
                    onAmountChanged: (v) {
                      final parsed = double.tryParse(v) ?? 0;
                      setState(() {
                        _milestones[i] = m.copyWith(amount: parsed);
                      });
                    },
                    onDeadlinePicked: (d) {
                      setState(() {
                        _milestones[i] = m.copyWith(deadline: d);
                      });
                    },
                  );
                },
              ),
            ),

            // + Nuevo hito
            OutlinedButton.icon(
              icon: const Icon(Icons.add),
              label: const Text(AppStrings.newMilestone),
              onPressed: _addMilestone,
            ),
            const SizedBox(height: AppSizes.paddingS),

            // Total
            Text('Total: \$${_total.toStringAsFixed(2)}'),
            const SizedBox(height: AppSizes.paddingM),

            // Botón para adjuntar archivo de referencia
            PrimaryButton(
              text: _pickedFileName ??
                  'Adjuntar archivo de referencia',
              fullWidth: false,
              onPressed: _pickReferenceFile,
            ),
            const SizedBox(height: AppSizes.paddingL),

            // Botón continuar al review
            PrimaryButton(
              text: 'Revisar contrato',
              onPressed: _continue,
            ),
          ],
        ),
      ),
    );
  }
}
