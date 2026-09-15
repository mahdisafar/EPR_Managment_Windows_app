import 'dart:math';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../database/auth_local_data_source.dart';
import '../../error/failures.dart';
import '../../domain/repositories/auth_repository.dart';

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl({required this.localDataSource});

  static const String _saltKey = 'pwd_salt';
  static const String _hashKey = 'pwd_hash';
  static const String _defaultPassword = 'admin';

  String _hash(String saltHex, String password) {
    return sha256.convert(utf8.encode(saltHex + password)).toString();
  }

  String _generateSalt() {
    final r = Random.secure();
    return List.generate(32, (_) => r.nextInt(256))
        .map((b) => b.toRadixString(16).padLeft(2, '0'))
        .join();
  }

  @override
  Future<Either<Failure, Unit>> ensureInitialized() async {
    try {
      final existing = await localDataSource.getSetting(_saltKey);
      if (existing == null) {
        final salt = _generateSalt();
        await localDataSource.setSetting(_saltKey, salt);
        await localDataSource.setSetting(
            _hashKey, _hash(salt, _defaultPassword));
      }
      return const Right(unit);
    } catch (e) {
      return Left(DatabaseFailure('خطا در آماده‌سازی رمز عبور: $e'));
    }
  }

  @override
  Future<Either<Failure, bool>> verifyPassword(String password) async {
    try {
      await ensureInitialized();
      final salt = await localDataSource.getSetting(_saltKey);
      final stored = await localDataSource.getSetting(_hashKey);
      if (salt == null || stored == null) return const Right(false);
      return Right(_hash(salt, password) == stored);
    } catch (e) {
      return Left(DatabaseFailure('خطا در بررسی رمز عبور: $e'));
    }
  }

  @override
  Future<Either<Failure, Unit>> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      final valid = await verifyPassword(currentPassword);
      final isValid = valid.fold((f) => throw Exception(f.message), (v) => v);
      if (!isValid) {
        return const Left(ValidationFailure('رمز عبور فعلی اشتباه است.'));
      }
      final salt = _generateSalt();
      await localDataSource.setSetting(_saltKey, salt);
      await localDataSource.setSetting(_hashKey, _hash(salt, newPassword));
      return const Right(unit);
    } catch (e) {
      return Left(DatabaseFailure('خطا در تغییر رمز عبور: $e'));
    }
  }
}
