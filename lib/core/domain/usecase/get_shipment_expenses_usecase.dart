import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../features/shipment/data/models/shipment_expense_model.dart';
import '../../../features/shipment/domain/repositories/shipment_repository.dart';
import '../../error/failures.dart';

@lazySingleton
class GetShipmentExpensesUseCase {
  final ShipmentRepository repository;

  GetShipmentExpensesUseCase(this.repository);

  Future<List<ShipmentExpenseModel>> call(String shipmentId) async {
    final result = await repository.getExpensesByShipmentId(shipmentId);
    return result.fold(
      (f) => throw Exception(f.message),
      (list) => list,
    );
  }
}
