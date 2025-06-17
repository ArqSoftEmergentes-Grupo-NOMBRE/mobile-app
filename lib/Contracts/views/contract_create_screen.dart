import 'package:flutter/material.dart';
import 'package:file_selector/file_selector.dart';
import '../../shared/components/custom_textfield.dart';
import '../../shared/components/primary_button.dart';
import '../../shared/constants/app_sizes.dart';
import '../../shared/constants/app_strings.dart';
import '../../shared/utils/validators.dart';
import '../models/create_contract_args.dart';
import '../contracts_routes.dart';

class ContractCreateScreen extends StatefulWidget {
  final String developerId;
  const ContractCreateScreen({super.key, required this.developerId});

  @override
  State<ContractCreateScreen> createState() => _ContractCreateScreenState();
}

class _ContractCreateScreenState extends State<ContractCreateScreen> {
  final _formKey         = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descController  = TextEditingController();
  String? _referenceFilePath;
  String? _referenceFileName;

  Future<void> _pickFile() async {
    final typeGroup = XTypeGroup(label: 'todos', extensions: ['*']);
    final XFile? file = await openFile(acceptedTypeGroups: [typeGroup]);
    if (file != null) {
      setState(() {
        _referenceFilePath = file.path;
        _referenceFileName = file.name;
      });
    }
  }

  void _continue() {
    if (_formKey.currentState?.validate() ?? false) {
      final args = CreateContractArgs(
        developerId:   widget.developerId,
        title:         _titleController.text.trim(),
        description:   _descController.text.trim(),
        referenceFile: _referenceFilePath,
        milestones:    [],
      );
      Navigator.pushNamed(
        context,
        ContractsRoutes.payments,
        arguments: args,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.contractDetails)),
      body: Padding(
        padding: const EdgeInsets.all(AppSizes.paddingM),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              CustomTextField(
                hint:       AppStrings.newContract,
                controller: _titleController,
                validator:  Validators.required,
              ),
              const SizedBox(height: AppSizes.paddingM),
              CustomTextField(
                hint:       AppStrings.contractSummary,
                controller: _descController,
                validator:  Validators.required,
              ),
              const SizedBox(height: AppSizes.paddingM),
              PrimaryButton(
                text:      _referenceFileName ?? AppStrings.uploadFile,
                fullWidth: false,
                onPressed: _pickFile,
              ),
              const SizedBox(height: AppSizes.paddingL),
              PrimaryButton(
                text:     AppStrings.nextButton,
                onPressed:_continue,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
