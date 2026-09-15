import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:eprwindowsapp/core/domain/usecase/get_all_customers_use_case.dart';
import '../../domain/usecases/get_financial_summary_usecase.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';

@injectable
class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final GetFinancialSummaryUseCase getFinancialSummaryUseCase;
  final GetAllCustomersUseCase getAllCustomersUseCase;

  DashboardBloc({
    required this.getFinancialSummaryUseCase,
    required this.getAllCustomersUseCase,
  }) : super(DashboardInitialState()) {
    on<FetchDashboardSummaryEvent>(_onFetchSummary);
  }

  Future<void> _onFetchSummary(
    FetchDashboardSummaryEvent event,
    Emitter<DashboardState> emit,
  ) async {
    emit(DashboardLoadingState());

    try {
      DateTime? start = event.customStartDate;
      DateTime? end = event.customEndDate;
      final now = DateTime.now();

      if (event.filter != DateFilterType.allTime && start == null) {
        switch (event.filter) {
          case DateFilterType.today:
            start = DateTime(now.year, now.month, now.day);
            break;
          case DateFilterType.thisWeek:
            start = DateTime(now.year, now.month, now.day - (now.weekday - 1));
            break;
          case DateFilterType.thisMonth:
            start = DateTime(now.year, now.month, 1);
            break;
          case DateFilterType.thisYear:
            start = DateTime(now.year, 1, 1);
            break;
          default:
            break;
        }
        end ??= now;
      }

      final summary = Map<String, double>.from(
        await getFinancialSummaryUseCase(startDate: start, endDate: end),
      );

      final customers = await getAllCustomersUseCase();
      final totalReceivable = customers
          .where((c) => c.currentBalance > 0)
          .fold<double>(0.0, (sum, c) => sum + c.currentBalance);
      summary['total_receivable'] = totalReceivable;

      final monthly = <MonthlyFinanceData>[];
      for (var i = 5; i >= 0; i--) {
        final m = DateTime(now.year, now.month - i, 1);
        final mStart = DateTime(m.year, m.month, 1);
        final mEnd = DateTime(m.year, m.month + 1, 0, 23, 59, 59);
        final mSummary =
            await getFinancialSummaryUseCase(startDate: mStart, endDate: mEnd);
        monthly.add(MonthlyFinanceData(
          month: m,
          income: mSummary['total_income'] ?? 0.0,
          expense: mSummary['total_expense'] ?? 0.0,
        ));
      }

      emit(DashboardLoadedState(
        summary: summary,
        monthlyData: monthly,
        selectedFilter: event.filter,
        startDate: start,
        endDate: end,
      ));
    } catch (e) {
      emit(DashboardErrorState("خطا در دریافت اطلاعات مالی: ${e.toString()}"));
    }
  }
}
