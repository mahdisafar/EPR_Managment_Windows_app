import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:eprwindowsapp/core/domain/usecase/get_all_customers_use_case.dart';
import '../../data/models/customer_model.dart';
import '../../domain/usecases/add_customer_usecase.dart';

part 'customer_event.dart';
part 'customer_state.dart';

@injectable
class CustomerBloc extends Bloc<CustomerEvent, CustomerState> {
  final GetAllCustomersUseCase getAllCustomersUseCase;
  final AddCustomerUseCase addCustomerUseCase;

  CustomerBloc({
    required this.getAllCustomersUseCase,
    required this.addCustomerUseCase,
  }) : super(CustomerInitialState()) {
    on<LoadCustomersEvent>(_onLoadCustomers);
    on<AddCustomerEvent>(_onAddCustomer);
  }

  Future<void> _onLoadCustomers(
    LoadCustomersEvent event,
    Emitter<CustomerState> emit,
  ) async {
    emit(CustomerLoadingState());
    try {
      final customers = await getAllCustomersUseCase();

      List<CustomerModel> filtered = List.from(customers);
      if (event.searchQuery != null && event.searchQuery!.trim().isNotEmpty) {
        final query = event.searchQuery!.trim().toLowerCase();
        filtered = filtered.where((c) {
          return c.fullName.toLowerCase().contains(query) ||
              c.code.toLowerCase().contains(query) ||
              c.phoneNumber.contains(query);
        }).toList();
      }

      double totalReceivables = 0;
      double totalPayables = 0;

      for (var c in customers) {
        if (c.currentBalance > 0) {
          totalReceivables += c.currentBalance;
        } else if (c.currentBalance < 0) {
          totalPayables += c.currentBalance.abs();
        }
      }

      emit(CustomerLoadedState(
        customers: customers,
        filteredCustomers: filtered,
        searchQuery: event.searchQuery ?? '',
        totalReceivables: totalReceivables,
        totalPayables: totalPayables,
      ));
    } catch (e) {
      emit(CustomerErrorState('خطا در دریافت لیست مشتریان: ${e.toString()}'));
    }
  }

  Future<void> _onAddCustomer(
    AddCustomerEvent event,
    Emitter<CustomerState> emit,
  ) async {
    try {
      await addCustomerUseCase(event.customer);
      emit(const CustomerSuccessState('مشتری جدید با موفقیت ثبت شد'));
      add(const LoadCustomersEvent());
    } catch (e) {
      emit(CustomerErrorState('خطا در ثبت مشتری: ${e.toString()}'));
    }
  }
}
