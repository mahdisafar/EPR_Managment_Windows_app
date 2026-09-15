import 'package:equatable/equatable.dart';
import '../../../../core/database/table_constants.dart';
import '../../../../config/enum.dart';

class ShipmentModel extends Equatable {
  final String id;
  final String shipmentNumber;
  final String originCountry;
  final String originCity;
  final String destinationCountry;
  final String destinationCity;
  final DateTime dispatchDate;
  final ShipmentStatus status;
  final String transportCompany;
  final String vehicleNumber;
  final String driverName;
  final String goodsType;
  final int packageCount;
  final double weight;
  final double declaredValue;
  final double totalCustomsAndTransportCosts;

  const ShipmentModel({
    required this.id,
    required this.shipmentNumber,
    required this.originCountry,
    required this.originCity,
    required this.destinationCountry,
    required this.destinationCity,
    required this.dispatchDate,
    required this.status,
    required this.transportCompany,
    required this.vehicleNumber,
    required this.driverName,
    required this.goodsType,
    required this.packageCount,
    required this.weight,
    required this.declaredValue,
    this.totalCustomsAndTransportCosts = 0.0,
  });

  ShipmentModel copyWith({
    String? id,
    String? shipmentNumber,
    String? originCountry,
    String? originCity,
    String? destinationCountry,
    String? destinationCity,
    DateTime? dispatchDate,
    ShipmentStatus? status,
    String? transportCompany,
    String? vehicleNumber,
    String? driverName,
    String? goodsType,
    int? packageCount,
    double? weight,
    double? declaredValue,
    double? totalCustomsAndTransportCosts,
  }) {
    return ShipmentModel(
      id: id ?? this.id,
      shipmentNumber: shipmentNumber ?? this.shipmentNumber,
      originCountry: originCountry ?? this.originCountry,
      originCity: originCity ?? this.originCity,
      destinationCountry: destinationCountry ?? this.destinationCountry,
      destinationCity: destinationCity ?? this.destinationCity,
      dispatchDate: dispatchDate ?? this.dispatchDate,
      status: status ?? this.status,
      transportCompany: transportCompany ?? this.transportCompany,
      vehicleNumber: vehicleNumber ?? this.vehicleNumber,
      driverName: driverName ?? this.driverName,
      goodsType: goodsType ?? this.goodsType,
      packageCount: packageCount ?? this.packageCount,
      weight: weight ?? this.weight,
      declaredValue: declaredValue ?? this.declaredValue,
      totalCustomsAndTransportCosts:
          totalCustomsAndTransportCosts ?? this.totalCustomsAndTransportCosts,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      TableConstants.columnId: id,
      TableConstants.colShipmentNumber: shipmentNumber,
      TableConstants.colOriginCountry: originCountry,
      TableConstants.colOriginCity: originCity,
      TableConstants.colDestinationCountry: destinationCountry,
      TableConstants.colDestinationCity: destinationCity,
      TableConstants.colDispatchDate: dispatchDate.toIso8601String(),
      TableConstants.colStatus: status.name,
      TableConstants.colTransportCompany: transportCompany,
      TableConstants.colTruckNumber: vehicleNumber,
      TableConstants.colDriverName: driverName,
      TableConstants.colCargoType: goodsType,
      TableConstants.colPackageCount: packageCount,
      TableConstants.colWeight: weight,
      TableConstants.colCargoValue: declaredValue,
      TableConstants.colTotalCosts: totalCustomsAndTransportCosts,
    };
  }

  factory ShipmentModel.fromMap(Map<String, dynamic> map) {
    return ShipmentModel(
      id: map[TableConstants.columnId] as String,
      shipmentNumber: map[TableConstants.colShipmentNumber] as String,
      originCountry: map[TableConstants.colOriginCountry] as String,
      originCity: map[TableConstants.colOriginCity] as String,
      destinationCountry: map[TableConstants.colDestinationCountry] as String,
      destinationCity: map[TableConstants.colDestinationCity] as String,
      dispatchDate:
          DateTime.parse(map[TableConstants.colDispatchDate] as String),
      status:
          ShipmentStatus.values.byName(map[TableConstants.colStatus] as String),
      transportCompany: map[TableConstants.colTransportCompany] as String,
      vehicleNumber: map[TableConstants.colTruckNumber] as String,
      driverName: map[TableConstants.colDriverName] as String,
      goodsType: map[TableConstants.colCargoType] as String,
      packageCount: map[TableConstants.colPackageCount] as int,
      weight: (map[TableConstants.colWeight] as num).toDouble(),
      declaredValue: (map[TableConstants.colCargoValue] as num).toDouble(),
      totalCustomsAndTransportCosts:
          (map[TableConstants.colTotalCosts] as num? ?? 0.0).toDouble(),
    );
  }

  @override
  List<Object?> get props => [
        id,
        shipmentNumber,
        originCountry,
        originCity,
        destinationCountry,
        destinationCity,
        dispatchDate,
        status,
        transportCompany,
        vehicleNumber,
        driverName,
        goodsType,
        packageCount,
        weight,
        declaredValue,
        totalCustomsAndTransportCosts,
      ];
}
