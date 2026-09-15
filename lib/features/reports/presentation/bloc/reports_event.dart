part of 'reports_bloc.dart';

abstract class ReportsEvent extends Equatable {
  const ReportsEvent();

  @override
  List<Object?> get props => [];
}

class FetchProfitLossReportEvent extends ReportsEvent {
  final DateFilterType filter;
  final DateTime? customStartDate;
  final DateTime? customEndDate;

  const FetchProfitLossReportEvent({
    this.filter = DateFilterType.thisMonth,
    this.customStartDate,
    this.customEndDate,
  });

  @override
  List<Object?> get props => [filter, customStartDate, customEndDate];
}
