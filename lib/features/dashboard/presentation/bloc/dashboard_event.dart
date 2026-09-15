part of 'dashboard_bloc.dart';

enum DateFilterType { today, thisWeek, thisMonth, thisYear, allTime, custom }

abstract class DashboardEvent extends Equatable {
  const DashboardEvent();

  @override
  List<Object?> get props => [];
}

class FetchDashboardSummaryEvent extends DashboardEvent {
  final DateFilterType filter;
  final DateTime? customStartDate;
  final DateTime? customEndDate;

  const FetchDashboardSummaryEvent({
    this.filter = DateFilterType.thisMonth,
    this.customStartDate,
    this.customEndDate,
  });

  @override
  List<Object?> get props => [filter, customStartDate, customEndDate];
}
