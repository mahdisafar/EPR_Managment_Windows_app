import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'app.dart';
import 'core/di/injection.dart';
import 'core/database/seed_data.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  sqfliteFfiInit();
  await initializeDateFormatting('fa_IR', null);

  await configureDependencies();
  await SeedData.seedIfEmpty();

  final authBloc = sl<AuthBloc>()..add(AuthStartedEvent());

  runApp(BlocProvider.value(value: authBloc, child: const EprApp()));
}
