import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/router/app_router.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';

class EprApp extends StatelessWidget {
  const EprApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        final authenticated = state is AuthAuthenticated;
        return MaterialApp.router(
          title: 'ERP Managment',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            fontFamily: 'IranYekan',
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF1E3A8A),
            ),
            scaffoldBackgroundColor: const Color(0xFFF8FAFC),
            cardColor: Colors.white,
            dividerColor: Colors.grey.shade200,
            useMaterial3: true,
          ),
          routerConfig: authenticated ? appRouter : loginRouter,
        );
      },
    );
  }
}
