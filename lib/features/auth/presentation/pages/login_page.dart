import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/auth_bloc.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _passwordCtrl = TextEditingController();
  bool _obscure = true;
  @override
  void dispose() {
    _passwordCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        body: BlocListener<AuthBloc, AuthState>(
          listenWhen: (prev, curr) =>
              curr is AuthUnauthenticated && curr.message != null,
          listener: (context, state) {
            if (state is AuthUnauthenticated && state.message != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message!,
                      style: const TextStyle(fontFamily: 'IranYekan')),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 380),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.lock_outline,
                          size: 48, color: Color(0xFF1E3A8A)),
                      const SizedBox(height: 16),
                      const Text('سیستم حسابداری ERP',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'IranYekan')),
                      const SizedBox(height: 4),
                      Text('برای ورود، رمز عبور را وارد کنید',
                          style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade600,
                              fontFamily: 'IranYekan')),
                      const SizedBox(height: 24),
                      TextField(
                        controller: _passwordCtrl,
                        obscureText: _obscure,
                        autofocus: true,
                        onSubmitted: (_) => _submit(),
                        decoration: InputDecoration(
                          labelText: 'رمز عبور',
                          labelStyle: const TextStyle(fontFamily: 'IranYekan'),
                          border: const OutlineInputBorder(),
                          prefixIcon: const Icon(Icons.password),
                          suffixIcon: IconButton(
                            tooltip: _obscure ? 'نمایش رمز' : 'پنهان کردن رمز',
                            icon: Icon(_obscure
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined),
                            onPressed: () =>
                                setState(() => _obscure = !_obscure),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: BlocBuilder<AuthBloc, AuthState>(
                          builder: (context, state) {
                            final loading = state is AuthLoading;
                            return ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF1E3A8A),
                                foregroundColor: Colors.white,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                              ),
                              onPressed: loading
                                  ? null
                                  : () => context.read<AuthBloc>().add(
                                      LoginSubmittedEvent(_passwordCtrl.text)),
                              child: loading
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                          strokeWidth: 2, color: Colors.white),
                                    )
                                  : const Text('ورود',
                                      style: TextStyle(
                                          fontFamily: 'IranYekan',
                                          fontSize: 15)),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _submit() {
    context.read<AuthBloc>().add(LoginSubmittedEvent(_passwordCtrl.text));
  }
}
