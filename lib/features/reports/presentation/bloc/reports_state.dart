part of 'reports_bloc.dart';

class CustomerBalanceRow {
  final String code;
  final String name;
  final double totalPurchases;
  final double totalPayments;
  final double balance;

  const CustomerBalanceRow({
    required this.code,
    required this.name,
    required this.totalPurchases,
    required this.totalPayments,
    required this.balance,
  });
}

class ShipmentSummaryRow {
  final String number;
  final String route;
  final String statusLabel;
  final double cargoValue;
  final double totalExpenses;

  const ShipmentSummaryRow({
    required this.number,
    required this.route,
    required this.statusLabel,
    required this.cargoValue,
    required this.totalExpenses,
  });
}

class ReportMonthlyData {
  final DateTime month;
  final double income;
  final double expense;

  const ReportMonthlyData({
    required this.month,
    required this.income,
    required this.expense,
  });
}

abstract class ReportsState extends Equatable {
  const ReportsState();

  @override
  List<Object> get props => [];
}

class ReportsInitial extends ReportsState {}

class ReportsLoading extends ReportsState {}

class ReportsLoaded extends ReportsState {
  final ProfitAndLossReport report;
  final List<ReportMonthlyData> monthlyData;
  final List<CustomerBalanceRow> customerBalances;
  final List<ShipmentSummaryRow> shipmentSummaries;
  final DateFilterType selectedFilter;

  const ReportsLoaded({
    required this.report,
    this.monthlyData = const [],
    this.customerBalances = const [],
    this.shipmentSummaries = const [],
    required this.selectedFilter,
  });

  double get totalCustomerDebt =>
      customerBalances.fold(0.0, (s, c) => s + (c.balance > 0 ? c.balance : 0));

  double get totalShipmentExpenses =>
      shipmentSummaries.fold(0.0, (s, x) => s + x.totalExpenses);

  @override
  List<Object> get props => [
        report,
        monthlyData,
        customerBalances,
        shipmentSummaries,
        selectedFilter
      ];
}

class ReportsError extends ReportsState {
  final String message;

  const ReportsError(this.message);

  @override
  List<Object> get props => [message];
}
