part of 'shipment_bloc.dart';

abstract class ShipmentState extends Equatable {
  const ShipmentState();

  @override
  List<Object> get props => [];
}

class ShipmentInitial extends ShipmentState {}

class ShipmentLoading extends ShipmentState {}

class ShipmentListLoaded extends ShipmentState {
  final List<ShipmentModel> allShipments;
  final List<ShipmentModel> filteredShipments;
  final String query;

  const ShipmentListLoaded({
    required this.allShipments,
    required this.filteredShipments,
    this.query = '',
  });

  @override
  List<Object> get props => [allShipments, filteredShipments, query];
}

class ShipmentDetailLoaded extends ShipmentState {
  final ShipmentModel shipment;
  final List<ShipmentExpenseModel> expenses;
  final List<AccountModel> accounts;

  const ShipmentDetailLoaded({
    required this.shipment,
    required this.expenses,
    this.accounts = const [],
  });

  double get totalExpenses => expenses.fold(0.0, (sum, e) => sum + e.amount);

  @override
  List<Object> get props => [shipment, expenses, accounts];
}

class ShipmentExpenseAdded extends ShipmentDetailLoaded {
  const ShipmentExpenseAdded({
    required super.shipment,
    required super.expenses,
    super.accounts,
  });
}

class ShipmentDetailError extends ShipmentDetailLoaded {
  final String message;

  const ShipmentDetailError({
    required super.shipment,
    required super.expenses,
    super.accounts,
    required this.message,
  });

  @override
  List<Object> get props => [shipment, expenses, accounts, message];
}

class ShipmentError extends ShipmentState {
  final String message;

  const ShipmentError(this.message);

  @override
  List<Object> get props => [message];
}
