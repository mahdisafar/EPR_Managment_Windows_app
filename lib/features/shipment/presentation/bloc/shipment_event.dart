part of 'shipment_bloc.dart';

abstract class ShipmentEvent extends Equatable {
  const ShipmentEvent();

  @override
  List<Object> get props => [];
}

class LoadShipmentsEvent extends ShipmentEvent {}

class SearchShipmentsEvent extends ShipmentEvent {
  final String query;

  const SearchShipmentsEvent(this.query);

  @override
  List<Object> get props => [query];
}

class RegisterShipmentEvent extends ShipmentEvent {
  final ShipmentModel shipment;

  const RegisterShipmentEvent(this.shipment);

  @override
  List<Object> get props => [shipment];
}

class LoadShipmentDetailEvent extends ShipmentEvent {
  final ShipmentModel shipment;

  const LoadShipmentDetailEvent(this.shipment);

  @override
  List<Object> get props => [shipment];
}

class AdvanceShipmentStatusEvent extends ShipmentEvent {
  final ShipmentModel shipment;

  const AdvanceShipmentStatusEvent(this.shipment);

  @override
  List<Object> get props => [shipment];
}

class AddShipmentExpenseEvent extends ShipmentEvent {
  final ShipmentExpenseModel expense;

  const AddShipmentExpenseEvent(this.expense);

  @override
  List<Object> get props => [expense];
}
