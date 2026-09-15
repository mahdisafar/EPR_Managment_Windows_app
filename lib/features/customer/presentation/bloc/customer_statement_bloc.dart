import 'package:equatable/equatable.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../data/models/customer_statement_dto.dart';
import '../../domain/usecases/get_customer_statement_usecase.dart';
import '../../domain/usecases/record_customer_payment_usecase.dart';

part 'customer_statement_event.dart';
part 'customer_statement_state.dart';

@injectable
class CustomerStatementBloc
    extends Bloc<CustomerStatementEvent, CustomerStatementState> {
  final GetCustomerStatementUseCase getCustomerStatementUseCase;
  final RecordCustomerPaymentUseCase recordCustomerPaymentUseCase;

  CustomerStatementBloc({
    required this.getCustomerStatementUseCase,
    required this.recordCustomerPaymentUseCase,
  }) : super(CustomerStatementInitialState()) {
    on<LoadCustomerStatementEvent>(_onLoadStatement);
    on<RecordPaymentEvent>(_onRecordPayment);
  }

  Future<void> _onLoadStatement(
    LoadCustomerStatementEvent event,
    Emitter<CustomerStatementState> emit,
  ) async {
    emit(CustomerStatementLoadingState());
    try {
      final statement = await getCustomerStatementUseCase(event.customerId);
      emit(CustomerStatementLoadedState(statement));
    } catch (e) {
      emit(CustomerStatementErrorState(
          'خطا در دریافت صورت‌حساب: ${e.toString()}'));
    }
  }

  Future<void> _onRecordPayment(
    RecordPaymentEvent event,
    Emitter<CustomerStatementState> emit,
  ) async {
    try {
      await recordCustomerPaymentUseCase(
        customerId: event.customerId,
        amount: event.amount,
      );
      emit(const PaymentRecordedSuccessState('دریافت وجه با موفقیت ثبت شد'));
      add(LoadCustomerStatementEvent(event.customerId));
    } catch (e) {
      emit(CustomerStatementErrorState('خطا در ثبت پرداخت: ${e.toString()}'));
    }
  }
}
