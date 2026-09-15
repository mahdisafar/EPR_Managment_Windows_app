import 'package:dartz/dartz.dart';
import '../../error/failures.dart';

abstract class AuthRepository {
  Future<Either<Failure, Unit>> ensureInitialized();
  Future<Either<Failure, bool>> verifyPassword(String password);
  Future<Either<Failure, Unit>> changePassword({
    required String currentPassword,
    required String newPassword,
  });
}
