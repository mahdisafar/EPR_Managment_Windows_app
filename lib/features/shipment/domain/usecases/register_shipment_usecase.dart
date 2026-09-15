import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../../data/models/shipment_model.dart';
import '../repositories/shipment_repository.dart';

@lazySingleton
class RegisterShipmentUseCase {
  final ShipmentRepository repository;

  RegisterShipmentUseCase(this.repository);

  Future<Either<Failure, Unit>> execute(
      {required ShipmentModel shipment}) async {
    if (shipment.shipmentNumber.trim().isEmpty) {
      return const Left(ValidationFailure('شماره محموله الزامی است.'));
    }
    if (shipment.packageCount <= 0) {
      return const Left(
          ValidationFailure('تعداد بسته باید بزرگ‌تر از صفر باشد.'));
    }
    if (shipment.weight <= 0) {
      return const Left(
          ValidationFailure('وزن محموله باید بزرگ‌تر از صفر باشد.'));
    }
    if (shipment.originCity.trim().isEmpty ||
        shipment.destinationCity.trim().isEmpty) {
      return const Left(ValidationFailure('شهر مبدأ و مقصد الزامی است.'));
    }

    return await repository.addShipment(shipment);
  }
}
