import 'package:flutter/material.dart';
import '../../shared/components/custom_textfield.dart';
import '../../shared/components/primary_button.dart';
import '../../shared/constants/app_strings.dart';
import '../../shared/utils/validators.dart';
import '../models/user_profile.dart';
import '../services/profile_service.dart';

class ProfileForm extends StatefulWidget {
  const ProfileForm({Key? key}) : super(key: key);

  @override
  State<ProfileForm> createState() => _ProfileFormState();
}

class _ProfileFormState extends State<ProfileForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController  = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  bool _isLoading = false;
  bool _isSaving  = false;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    setState(() => _isLoading = true);
    try {
      final profile = await ProfileService().fetchProfile();
      _nameController .text = profile.name;
      _emailController.text = profile.email;
      _phoneController.text = profile.phone ?? '';
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);
    try {
      final updated = UserProfile(
        name : _nameController .text.trim(),
        email: _emailController.text.trim(),
        phone: _phoneController.text.trim().isEmpty
            ? null
            : _phoneController.text.trim(),
      );
      final success = await ProfileService().updateProfile(updated);
      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Perfil actualizado correctamente.')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Form(
      key: _formKey,
      child: Column(
        children: [
          CustomTextField(
            hint       : AppStrings.nameHint,
            controller : _nameController,
            validator  : Validators.required,
          ),
          const SizedBox(height: 16),
          CustomTextField(
            hint       : AppStrings.emailHint,
            controller : _emailController,
            keyboardType: TextInputType.emailAddress,
            validator  : Validators.email,
          ),
          const SizedBox(height: 16),
          CustomTextField(
            hint       : AppStrings.phoneHint,
            controller : _phoneController,
            keyboardType: TextInputType.phone,
            validator  : Validators.required,
          ),
          const SizedBox(height: 24),
          PrimaryButton(
            text     : 'Guardar cambios',
            isLoading: _isSaving,
            onPressed: _submit,
          ),
        ],
      ),
    );
  }
}
