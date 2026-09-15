import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/domain/repositories/auth_repository.dart';

@lazySingleton
class ChangePasswordUseCase {
  final AuthRepository repository;

  ChangePasswordUseCase(this.repository);

  Future<Either<Failure, Unit>> execute({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    if (newPassword.length < 4) {
      return const Left(
          ValidationFailure('رمز جدید باید حداقل ۴ کاراکتر باشد.'));
    }
    if (newPassword != confirmPassword) {
      return const Left(
          ValidationFailure('تکرار رمز جدید با خودش یکسان نیست.'));
    }
    return await repository.changePassword(
      currentPassword: currentPassword,
      newPassword: newPassword,
    );
  }
}
