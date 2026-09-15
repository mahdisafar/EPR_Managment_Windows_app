import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:eprwindowsapp/core/domain/usecase/get_all_customers_use_case.dart';
import 'package:eprwindowsapp/core/domain/usecase/get_all_invoices_usecase.dart';
import 'package:eprwindowsapp/core/domain/usecase/get_all_products_use_case.dart';
import 'package:eprwindowsapp/features/inventory/data/models/product_model.dart';
import '../../data/models/invoice_model.dart';

part 'invoices_list_event.dart';
part 'invoices_list_state.dart';

@injectable
class InvoicesListBloc extends Bloc<InvoicesListEvent, InvoicesListState> {
  final GetAllInvoicesUseCase getAllInvoicesUseCase;
  final GetAllCustomersUseCase getAllCustomersUseCase;
  final GetAllProductsUseCase getAllProductsUseCase;

  InvoicesListBloc({
    required this.getAllInvoicesUseCase,
    required this.getAllCustomersUseCase,
    required this.getAllProductsUseCase,
  }) : super(InvoicesListInitial()) {
    on<LoadInvoicesListEvent>(_onLoad);
    on<SearchInvoicesListEvent>(_onSearch);
    on<FilterInvoicesByTypeEvent>(_onFilter);
  }

  Future<void> _onLoad(
    LoadInvoicesListEvent event,
    Emitter<InvoicesListState> emit,
  ) async {
    emit(InvoicesListLoading());

    try {
      final invoices = await getAllInvoicesUseCase();
      final customers = await getAllCustomersUseCase();
      final productsResult = await getAllProductsUseCase();
      final products = productsResult.fold(
        (f) => throw Exception(f.message),
        (list) => list,
      );

      final names = <String, String>{
        for (final c in customers) c.id: c.fullName,
      };

      emit(InvoicesListLoaded(
        allInvoices: invoices,
        filteredInvoices: invoices,
        customerNames: names,
        products: products,
      ));
    } catch (e) {
      emit(InvoicesListError(e.toString()));
    }
  }

  void _applyFilter(
    InvoicesListLoaded current,
    String query,
    String typeFilter,
    Emitter<InvoicesListState> emit,
  ) {
    var list = current.allInvoices;
    if (typeFilter != 'all') {
      list = list.where((inv) => inv.type.name == typeFilter).toList();
    }
    final q = query.trim().toLowerCase();
    if (q.isNotEmpty) {
      list = list.where((inv) {
        return inv.invoiceNumber.toLowerCase().contains(q) ||
            (current.customerNames[inv.customerId] ?? '')
                .toLowerCase()
                .contains(q);
      }).toList();
    }
    emit(InvoicesListLoaded(
      allInvoices: current.allInvoices,
      filteredInvoices: list,
      customerNames: current.customerNames,
      products: current.products,
      query: query,
      typeFilter: typeFilter,
    ));
  }

  void _onSearch(
    SearchInvoicesListEvent event,
    Emitter<InvoicesListState> emit,
  ) {
    if (state is! InvoicesListLoaded) return;
    final current = state as InvoicesListLoaded;
    _applyFilter(current, event.query, current.typeFilter, emit);
  }

  void _onFilter(
    FilterInvoicesByTypeEvent event,
    Emitter<InvoicesListState> emit,
  ) {
    if (state is! InvoicesListLoaded) return;
    final current = state as InvoicesListLoaded;
    _applyFilter(current, current.query, event.typeFilter, emit);
  }
}
