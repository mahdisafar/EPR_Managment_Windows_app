import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../features/shipment/data/models/shipment_model.dart';
import '../../../features/shipment/domain/repositories/shipment_repository.dart';
import '../../error/failures.dart';

@lazySingleton
class GetAllShipmentsUseCase {
  final ShipmentRepository repository;

  GetAllShipmentsUseCase(this.repository);

  Future<List<ShipmentModel>> call() async {
    final result = await repository.getShipments();
    return result.fold(
      (f) => throw Exception(f.message),
      (list) => list,
    );
  }
}
