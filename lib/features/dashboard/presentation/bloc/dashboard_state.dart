part of 'dashboard_bloc.dart';

class MonthlyFinanceData {
  final DateTime month;
  final double income;
  final double expense;

  const MonthlyFinanceData({
    required this.month,
    required this.income,
    required this.expense,
  });
}

abstract class DashboardState extends Equatable {
  const DashboardState();

  @override
  List<Object?> get props => [];
}

class DashboardInitialState extends DashboardState {}

class DashboardLoadingState extends DashboardState {}

class DashboardLoadedState extends DashboardState {
  final Map<String, double> summary;
  final List<MonthlyFinanceData> monthlyData;
  final DateFilterType selectedFilter;
  final DateTime? startDate;
  final DateTime? endDate;

  const DashboardLoadedState({
    required this.summary,
    this.monthlyData = const [],
    required this.selectedFilter,
    this.startDate,
    this.endDate,
  });

  @override
  List<Object?> get props =>
      [summary, monthlyData, selectedFilter, startDate, endDate];
}

class DashboardErrorState extends DashboardState {
  final String message;

  const DashboardErrorState(this.message);

  @override
  List<Object?> get props => [message];
}
