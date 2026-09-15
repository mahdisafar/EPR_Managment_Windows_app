import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:eprwindowsapp/config/enum.dart';
import 'package:eprwindowsapp/core/domain/usecase/get_all_accounts_usecase.dart';
import 'package:eprwindowsapp/core/models/account_model.dart';
import '../../data/models/shipment_expense_model.dart';
import '../../data/models/shipment_model.dart';
import '../../domain/usecases/add_shipment_expense_usecase.dart';
import '../../domain/usecases/get_shipment_expenses_usecase.dart';
import '../../domain/usecases/get_shipments_usecase.dart';
import '../../domain/usecases/register_shipment_usecase.dart';
import '../../domain/usecases/update_shipment_status_usecase.dart';

part 'shipment_event.dart';
part 'shipment_state.dart';

@injectable
class ShipmentBloc extends Bloc<ShipmentEvent, ShipmentState> {
  final GetShipmentsUseCase getShipmentsUseCase;
  final RegisterShipmentUseCase registerShipmentUseCase;
  final UpdateShipmentStatusUseCase updateShipmentStatusUseCase;
  final GetShipmentExpensesUseCase getShipmentExpensesUseCase;
  final AddShipmentExpenseUseCase addShipmentExpenseUseCase;
  final GetAllAccountsUseCase getAllAccountsUseCase;

  ShipmentBloc({
    required this.getShipmentsUseCase,
    required this.registerShipmentUseCase,
    required this.updateShipmentStatusUseCase,
    required this.getShipmentExpensesUseCase,
    required this.addShipmentExpenseUseCase,
    required this.getAllAccountsUseCase,
  }) : super(ShipmentInitial()) {
    on<LoadShipmentsEvent>(_onLoadShipments);
    on<SearchShipmentsEvent>(_onSearch);
    on<RegisterShipmentEvent>(_onRegister);
    on<LoadShipmentDetailEvent>(_onLoadDetail);
    on<AdvanceShipmentStatusEvent>(_onAdvanceStatus);
    on<AddShipmentExpenseEvent>(_onAddExpense);
  }

  Future<void> _onLoadShipments(
    LoadShipmentsEvent event,
    Emitter<ShipmentState> emit,
  ) async {
    emit(ShipmentLoading());

    final result = await getShipmentsUseCase();
    result.fold(
      (failure) => emit(ShipmentError(failure.message)),
      (shipments) => emit(ShipmentListLoaded(
        allShipments: shipments,
        filteredShipments: shipments,
      )),
    );
  }

  void _onSearch(
    SearchShipmentsEvent event,
    Emitter<ShipmentState> emit,
  ) {
    if (state is! ShipmentListLoaded) return;
    final current = state as ShipmentListLoaded;

    final query = event.query.trim().toLowerCase();
    final filtered = query.isEmpty
        ? current.allShipments
        : current.allShipments.where((s) {
            return s.shipmentNumber.toLowerCase().contains(query) ||
                s.goodsType.toLowerCase().contains(query) ||
                s.driverName.toLowerCase().contains(query) ||
                s.transportCompany.toLowerCase().contains(query);
          }).toList();

    emit(ShipmentListLoaded(
      allShipments: current.allShipments,
      filteredShipments: filtered,
      query: event.query,
    ));
  }

  Future<void> _onRegister(
    RegisterShipmentEvent event,
    Emitter<ShipmentState> emit,
  ) async {
    emit(ShipmentLoading());

    final result =
        await registerShipmentUseCase.execute(shipment: event.shipment);
    await result.fold(
      (failure) async => emit(ShipmentError(failure.message)),
      (_) async => add(LoadShipmentsEvent()),
    );
  }

  Future<void> _onLoadDetail(
    LoadShipmentDetailEvent event,
    Emitter<ShipmentState> emit,
  ) async {
    final expensesResult = await getShipmentExpensesUseCase(event.shipment.id);
    final accountsResult = await getAllAccountsUseCase();

    final accounts = accountsResult.fold(
      (f) => <AccountModel>[],
      (list) => list,
    );

    expensesResult.fold(
      (failure) => emit(ShipmentError(failure.message)),
      (expenses) => emit(ShipmentDetailLoaded(
        shipment: event.shipment,
        expenses: expenses,
        accounts: accounts,
      )),
    );
  }

  Future<void> _onAdvanceStatus(
    AdvanceShipmentStatusEvent event,
    Emitter<ShipmentState> emit,
  ) async {
    final statuses = ShipmentStatus.values;
    final currentIndex = statuses.indexOf(event.shipment.status);

    if (currentIndex >= statuses.length - 1) {
      final current =
          state is ShipmentDetailLoaded ? state as ShipmentDetailLoaded : null;
      if (current != null) {
        emit(ShipmentDetailError(
          shipment: current.shipment,
          expenses: current.expenses,
          accounts: current.accounts,
          message: 'محموله قبلاً به آخرین مرحله (انبار) رسیده است.',
        ));
      } else {
        emit(const ShipmentError(
            'محموله قبلاً به آخرین مرحله (انبار) رسیده است.'));
      }
      return;
    }

    final nextStatus = statuses[currentIndex + 1];
    final result =
        await updateShipmentStatusUseCase(event.shipment.id, nextStatus);

    await result.fold(
      (failure) async {
        final current = state is ShipmentDetailLoaded
            ? state as ShipmentDetailLoaded
            : null;
        if (current != null) {
          emit(ShipmentDetailError(
            shipment: current.shipment,
            expenses: current.expenses,
            accounts: current.accounts,
            message: failure.message,
          ));
        } else {
          emit(ShipmentError(failure.message));
        }
      },
      (_) async {
        add(LoadShipmentDetailEvent(
          event.shipment.copyWith(status: nextStatus),
        ));
      },
    );
  }

  Future<void> _onAddExpense(
    AddShipmentExpenseEvent event,
    Emitter<ShipmentState> emit,
  ) async {
    final result = await addShipmentExpenseUseCase(event.expense);

    await result.fold(
      (failure) async {
        final current = state is ShipmentDetailLoaded
            ? state as ShipmentDetailLoaded
            : null;
        if (current != null) {
          emit(ShipmentDetailError(
            shipment: current.shipment,
            expenses: current.expenses,
            accounts: current.accounts,
            message: failure.message,
          ));
        } else {
          emit(ShipmentError(failure.message));
        }
      },
      (_) async {
        if (state is ShipmentDetailLoaded) {
          final current = state as ShipmentDetailLoaded;
          add(LoadShipmentDetailEvent(current.shipment));
        }
      },
    );
  }
}
