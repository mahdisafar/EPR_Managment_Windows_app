import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../../data/models/shipment_expense_model.dart';
import '../repositories/shipment_repository.dart';

@lazySingleton
class GetShipmentExpensesUseCase {
  final ShipmentRepository repository;

  GetShipmentExpensesUseCase(this.repository);

  Future<Either<Failure, List<ShipmentExpenseModel>>> call(
      String shipmentId) async {
    return await repository.getExpensesByShipmentId(shipmentId);
  }
}
