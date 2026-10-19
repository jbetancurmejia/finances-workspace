import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:money_app/features/auth/domain/entities/credentials.dart';
import 'package:money_app/features/auth/domain/entities/registration.dart';

final class AuthForm extends StatefulWidget {
  const AuthForm({
    required this.isLoading,
    required this.onLogin,
    required this.onRegister,
    super.key,
  });

  final bool isLoading;
  final ValueChanged<Credentials> onLogin;
  final ValueChanged<Registration> onRegister;

  @override
  State<AuthForm> createState() => _AuthFormState();
}

final class _AuthFormState extends State<AuthForm> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _salaryController = TextEditingController();
  final _hoursController = TextEditingController();
  bool _isRegisterMode = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _salaryController.dispose();
    _hoursController.dispose();
    super.dispose();
  }

  void _submit() {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (!_isRegisterMode) {
      widget.onLogin(Credentials(email: email, password: password));
      return;
    }

    widget.onRegister(
      Registration(
        email: email,
        password: password,
        displayName: _nameController.text.trim(),
        monthlySalary: int.tryParse(_salaryController.text.trim()) ?? 0,
        monthlyWorkHours: double.tryParse(_hoursController.text.trim()) ?? 0,
      ),
    );
  }

  void _toggleMode() {
    setState(() => _isRegisterMode = !_isRegisterMode);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (_isRegisterMode) ...[
          TextField(
            controller: _nameController,
            decoration: InputDecoration(labelText: 'auth.displayName'.tr()),
          ),
          const SizedBox(height: 12),
        ],
        TextField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(labelText: 'auth.email'.tr()),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _passwordController,
          obscureText: true,
          decoration: InputDecoration(labelText: 'auth.password'.tr()),
        ),
        if (_isRegisterMode) ...[
          const SizedBox(height: 12),
          TextField(
            controller: _salaryController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: 'auth.monthlySalary'.tr()),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _hoursController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: 'auth.monthlyWorkHours'.tr()),
          ),
        ],
        const SizedBox(height: 24),
        FilledButton(
          onPressed: widget.isLoading ? null : _submit,
          child: Text(
            _isRegisterMode ? 'auth.registerAction'.tr() : 'auth.loginAction'.tr(),
          ),
        ),
        TextButton(
          onPressed: widget.isLoading ? null : _toggleMode,
          child: Text(
            _isRegisterMode ? 'auth.switchToLogin'.tr() : 'auth.switchToRegister'.tr(),
          ),
        ),
      ],
    );
  }
}
