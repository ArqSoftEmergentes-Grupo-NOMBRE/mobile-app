import 'package:flutter/material.dart';
import '../../shared/constants/app_sizes.dart';
import '../models/milestone.dart';

typedef DateCallback = void Function(DateTime);

class MilestoneRow extends StatelessWidget {
  final Milestone milestone;
  final bool editable;
  final ValueChanged<String>? onDescriptionChanged;
  final ValueChanged<String>? onAmountChanged;
  final DateCallback? onDeadlinePicked;

  const MilestoneRow({
    Key? key,
    required this.milestone,
    this.editable = false,
    this.onDescriptionChanged,
    this.onAmountChanged,
    this.onDeadlinePicked,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Descripción
        TextFormField(
          initialValue: milestone.description,
          decoration: const InputDecoration(
            hintText: 'Descripción del hito',
          ),
          enabled: editable,
          onChanged: onDescriptionChanged,
        ),
        const SizedBox(height: AppSizes.paddingS),

        // Monto
        TextFormField(
          initialValue: milestone.amount.toStringAsFixed(2),
          decoration: const InputDecoration(
            hintText: 'Monto (USD)',
          ),
          keyboardType: TextInputType.number,
          enabled: editable,
          onChanged: onAmountChanged,
        ),
        const SizedBox(height: AppSizes.paddingS),

        // Fecha límite
        Row(
          children: [
            Text(
              'Fecha límite: ${milestone.deadline.toLocal().toIso8601String().split('T')[0]}',
            ),
            if (editable)
              IconButton(
                icon: const Icon(
                  Icons.calendar_today,
                  size: AppSizes.iconSizeM,
                ),
                onPressed: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: milestone.deadline,
                    firstDate: DateTime.now().subtract(const Duration(days: 365)),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (picked != null && onDeadlinePicked != null) {
                    onDeadlinePicked!(picked);
                  }
                },
              ),
          ],
        ),
        const Divider(),
      ],
    );
  }
}
