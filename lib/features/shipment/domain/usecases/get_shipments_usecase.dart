import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../../data/models/shipment_model.dart';
import '../repositories/shipment_repository.dart';

@lazySingleton
class GetShipmentsUseCase {
  final ShipmentRepository repository;

  GetShipmentsUseCase(this.repository);

  Future<Either<Failure, List<ShipmentModel>>> call() async {
    return await repository.getShipments();
  }
}
