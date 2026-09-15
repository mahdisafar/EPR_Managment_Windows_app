import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/auth_bloc.dart';

class ChangePasswordDialog extends StatefulWidget {
  const ChangePasswordDialog({super.key});

  @override
  State<ChangePasswordDialog> createState() => _ChangePasswordDialogState();
}

class _ChangePasswordDialogState extends State<ChangePasswordDialog> {
  final _formKey = GlobalKey<FormState>();
  final _currentCtrl = TextEditingController();
  final _newCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();

  @override
  void dispose() {
    _currentCtrl.dispose();
    _newCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  bool _obscureCurrent = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: BlocListener<AuthBloc, AuthState>(
        listenWhen: (prev, curr) =>
            curr is AuthPasswordChanged || curr is AuthPasswordChangeError,
        listener: (context, state) {
          if (state is AuthPasswordChanged) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('رمز عبور با موفقیت تغییر یافت.',
                    style: TextStyle(fontFamily: 'IranYekan')),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.of(context).pop();
          } else if (state is AuthPasswordChangeError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message,
                    style: const TextStyle(fontFamily: 'IranYekan')),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Row(children: [
            Icon(Icons.lock_reset, color: Color(0xFF1E3A8A)),
            SizedBox(width: 8),
            Text('تغییر رمز عبور',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'IranYekan')),
          ]),
          content: SizedBox(
            width: 380,
            child: Form(
              key: _formKey,
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                TextFormField(
                  controller: _currentCtrl,
                  obscureText: _obscureCurrent,
                  decoration: InputDecoration(
                    labelText: 'رمز عبور فعلی *',
                    labelStyle: const TextStyle(fontFamily: 'IranYekan'),
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      tooltip: _obscureCurrent ? 'نمایش رمز' : 'پنهان کردن رمز',
                      icon: Icon(_obscureCurrent
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined),
                      onPressed: () =>
                          setState(() => _obscureCurrent = !_obscureCurrent),
                    ),
                  ),
                  validator: (v) =>
                      v == null || v.isEmpty ? 'رمز فعلی الزامی است' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _newCtrl,
                  obscureText: _obscureNew,
                  decoration: InputDecoration(
                    labelText: 'رمز جدید (حداقل ۴ کاراکتر) *',
                    labelStyle: const TextStyle(fontFamily: 'IranYekan'),
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      tooltip: _obscureNew ? 'نمایش رمز' : 'پنهان کردن رمز',
                      icon: Icon(_obscureNew
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined),
                      onPressed: () =>
                          setState(() => _obscureNew = !_obscureNew),
                    ),
                  ),
                  validator: (v) =>
                      v == null || v.length < 4 ? 'حداقل ۴ کاراکتر' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _confirmCtrl,
                  obscureText: _obscureConfirm,
                  decoration: InputDecoration(
                    labelText: 'تکرار رمز جدید *',
                    labelStyle: const TextStyle(fontFamily: 'IranYekan'),
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      tooltip: _obscureConfirm ? 'نمایش رمز' : 'پنهان کردن رمز',
                      icon: Icon(_obscureConfirm
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined),
                      onPressed: () =>
                          setState(() => _obscureConfirm = !_obscureConfirm),
                    ),
                  ),
                  validator: (v) =>
                      v != _newCtrl.text ? 'با رمز جدید یکسان نیست' : null,
                ),
              ]),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('انصراف',
                  style:
                      TextStyle(color: Colors.grey, fontFamily: 'IranYekan')),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1E3A8A),
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  context.read<AuthBloc>().add(ChangePasswordSubmittedEvent(
                        currentPassword: _currentCtrl.text,
                        newPassword: _newCtrl.text,
                        confirmPassword: _confirmCtrl.text,
                      ));
                }
              },
              child: const Text('تغییر رمز',
                  style: TextStyle(fontFamily: 'IranYekan')),
            ),
          ],
        ),
      ),
    );
  }
}
