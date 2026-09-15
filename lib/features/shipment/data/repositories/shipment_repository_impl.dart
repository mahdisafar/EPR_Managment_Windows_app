import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../../../../config/enum.dart';
import '../../domain/repositories/shipment_repository.dart';
import '../datasources/shipment_local_data_source.dart';
import '../models/shipment_expense_model.dart';
import '../models/shipment_model.dart';

@LazySingleton(as: ShipmentRepository)
class ShipmentRepositoryImpl implements ShipmentRepository {
  final ShipmentLocalDataSource localDataSource;

  ShipmentRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, Unit>> addShipment(ShipmentModel shipment) async {
    try {
      await localDataSource.insertShipment(shipment);
      return const Right(unit);
    } catch (e) {
      return Left(DatabaseFailure('خطا در ثبت محموله: $e'));
    }
  }

  @override
  Future<Either<Failure, List<ShipmentModel>>> getShipments() async {
    try {
      final shipments = await localDataSource.getShipments();
      return Right(shipments);
    } catch (e) {
      return Left(DatabaseFailure('خطا در دریافت لیست محموله‌ها: $e'));
    }
  }

  @override
  Future<Either<Failure, Unit>> updateShipmentStatus(
      String shipmentId, ShipmentStatus newStatus) async {
    try {
      await localDataSource.updateShipmentStatus(shipmentId, newStatus);
      return const Right(unit);
    } catch (e) {
      return Left(DatabaseFailure('خطا در به‌روزرسانی وضعیت محموله: $e'));
    }
  }

  @override
  Future<Either<Failure, Unit>> addShipmentExpense(
      ShipmentExpenseModel expense) async {
    try {
      await localDataSource.insertShipmentExpense(expense);
      return const Right(unit);
    } catch (e) {
      return Left(DatabaseFailure('خطا در ثبت مصرف محموله: $e'));
    }
  }

  @override
  Future<Either<Failure, List<ShipmentExpenseModel>>> getExpensesByShipmentId(
      String shipmentId) async {
    try {
      final expenses =
          await localDataSource.getExpensesByShipmentId(shipmentId);
      return Right(expenses);
    } catch (e) {
      return Left(DatabaseFailure('خطا در دریافت مصارف محموله: $e'));
    }
  }
}
