import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import '../database/database_helper.dart';
import 'injection.config.dart';

final sl = GetIt.instance;

@InjectableInit(preferRelativeImports: true)
Future<void> configureDependencies() async {
  sl.registerLazySingleton<DatabaseHelper>(() => DatabaseHelper.instance);
  sl.init();
}
