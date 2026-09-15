import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:eprwindowsapp/config/enum.dart';
import 'package:eprwindowsapp/core/domain/usecase/get_all_customers_use_case.dart';
import 'package:eprwindowsapp/core/domain/usecase/get_all_invoices_usecase.dart';
import 'package:eprwindowsapp/core/domain/usecase/get_all_shipments_usecase.dart';
import 'package:eprwindowsapp/core/domain/usecase/get_shipment_expenses_usecase.dart';
import 'package:eprwindowsapp/features/shipment/presentation/widgets/shipment_data_table.dart'
    show ShipmentDataTable;
import '../../../dashboard/domain/usecases/get_financial_summary_usecase.dart';
import '../../../dashboard/presentation/bloc/dashboard_bloc.dart';
import '../../domain/usecases/get_profit_and_loss_use_case.dart';

part 'reports_event.dart';
part 'reports_state.dart';

@injectable
class ReportsBloc extends Bloc<ReportsEvent, ReportsState> {
  final GetProfitAndLossUseCase getProfitAndLossUseCase;
  final GetFinancialSummaryUseCase getFinancialSummaryUseCase;
  final GetAllCustomersUseCase getAllCustomersUseCase;
  final GetAllInvoicesUseCase getAllInvoicesUseCase;
  final GetAllShipmentsUseCase getAllShipmentsUseCase;
  final GetShipmentExpensesUseCase getShipmentExpensesUseCase;

  ReportsBloc({
    required this.getProfitAndLossUseCase,
    required this.getFinancialSummaryUseCase,
    required this.getAllCustomersUseCase,
    required this.getAllInvoicesUseCase,
    required this.getAllShipmentsUseCase,
    required this.getShipmentExpensesUseCase,
  }) : super(ReportsInitial()) {
    on<FetchProfitLossReportEvent>(_onFetch);
  }

  (DateTime, DateTime) _resolveRange(FetchProfitLossReportEvent event) {
    final now = DateTime.now();
    if (event.filter == DateFilterType.custom &&
        event.customStartDate != null &&
        event.customEndDate != null) {
      return (event.customStartDate!, event.customEndDate!);
    }
    switch (event.filter) {
      case DateFilterType.today:
        return (DateTime(now.year, now.month, now.day), now);
      case DateFilterType.thisWeek:
        return (
          DateTime(now.year, now.month, now.day - (now.weekday - 1)),
          now
        );
      case DateFilterType.thisMonth:
        return (DateTime(now.year, now.month, 1), now);
      case DateFilterType.thisYear:
        return (DateTime(now.year, 1, 1), now);
      case DateFilterType.allTime:
      case DateFilterType.custom:
        return (DateTime(2000), now);
    }
  }

  Future<void> _onFetch(
    FetchProfitLossReportEvent event,
    Emitter<ReportsState> emit,
  ) async {
    emit(ReportsLoading());

    final range = _resolveRange(event);

    final reportResult = await getProfitAndLossUseCase.execute(
      startDate: range.$1,
      endDate: range.$2,
    );

    final failureOrReport = await reportResult.fold(
      (f) async => f,
      (report) async => report,
    );
    if (failureOrReport is String) {
      emit(ReportsError(failureOrReport));
      return;
    }
    final report = failureOrReport as ProfitAndLossReport;

    final now = DateTime.now();
    final monthly = <ReportMonthlyData>[];
    for (var i = 5; i >= 0; i--) {
      final m = DateTime(now.year, now.month - i, 1);
      final mSummary = await getFinancialSummaryUseCase(
        startDate: DateTime(m.year, m.month, 1),
        endDate: DateTime(m.year, m.month + 1, 0, 23, 59, 59),
      );
      monthly.add(ReportMonthlyData(
        month: m,
        income: mSummary['total_income'] ?? 0.0,
        expense: mSummary['total_expense'] ?? 0.0,
      ));
    }

    final customers = await getAllCustomersUseCase();
    final invoices = await getAllInvoicesUseCase();
    final salesByCustomer = <String, double>{};
    for (final inv in invoices) {
      if (inv.type == InvoiceType.sale && inv.customerId != null) {
        salesByCustomer[inv.customerId!] =
            (salesByCustomer[inv.customerId!] ?? 0) + inv.totalAmount;
      }
    }
    final balances = customers.map((c) {
      final sales = salesByCustomer[c.id] ?? 0.0;
      final payments = c.initialBalance + sales - c.currentBalance;
      return CustomerBalanceRow(
        code: c.code,
        name: c.fullName,
        totalPurchases: sales,
        totalPayments: payments,
        balance: c.currentBalance,
      );
    }).toList()
      ..sort((a, b) => b.balance.compareTo(a.balance));

    final shipments = await getAllShipmentsUseCase();
    final shipmentRows = <ShipmentSummaryRow>[];
    for (final s in shipments) {
      final expenses = await getShipmentExpensesUseCase(s.id);
      final total = expenses.fold<double>(0.0, (sum, e) => sum + e.amount);
      shipmentRows.add(ShipmentSummaryRow(
        number: s.shipmentNumber,
        route: '${s.originCity} ← ${s.destinationCity}',
        statusLabel: ShipmentDataTable.statusLabel(s.status),
        cargoValue: s.declaredValue,
        totalExpenses: total,
      ));
    }

    emit(ReportsLoaded(
      report: report,
      monthlyData: monthly,
      customerBalances: balances,
      shipmentSummaries: shipmentRows,
      selectedFilter: event.filter,
    ));
  }
}
