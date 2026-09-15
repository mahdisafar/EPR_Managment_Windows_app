import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../config/enum.dart';
import '../../data/models/shipment_expense_model.dart';
import '../../data/models/shipment_model.dart';

abstract class ShipmentRepository {
  Future<Either<Failure, Unit>> addShipment(ShipmentModel shipment);
  Future<Either<Failure, List<ShipmentModel>>> getShipments();
  Future<Either<Failure, Unit>> updateShipmentStatus(
      String shipmentId, ShipmentStatus newStatus);
  Future<Either<Failure, Unit>> addShipmentExpense(
      ShipmentExpenseModel expense);
  Future<Either<Failure, List<ShipmentExpenseModel>>> getExpensesByShipmentId(
      String shipmentId);
}
