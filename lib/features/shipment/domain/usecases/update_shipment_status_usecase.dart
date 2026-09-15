import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../../../../config/enum.dart';
import '../repositories/shipment_repository.dart';

@lazySingleton
class UpdateShipmentStatusUseCase {
  final ShipmentRepository repository;

  UpdateShipmentStatusUseCase(this.repository);

  Future<Either<Failure, Unit>> call(
      String shipmentId, ShipmentStatus newStatus) async {
    return await repository.updateShipmentStatus(shipmentId, newStatus);
  }
}
