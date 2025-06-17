import 'package:flutter/material.dart';

class SignatureBox extends StatelessWidget {
  final VoidCallback onSign;

  const SignatureBox({super.key, required this.onSign});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          'Confirmación de firma digital',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        const SizedBox(height: 16),
        const Icon(Icons.edit_document, size: 80, color: Colors.white54),
        const SizedBox(height: 16),
        ElevatedButton.icon(
          onPressed: onSign,
          icon: const Icon(Icons.check),
          label: const Text('Firmar contrato'),
        ),
      ],
    );
  }
}
