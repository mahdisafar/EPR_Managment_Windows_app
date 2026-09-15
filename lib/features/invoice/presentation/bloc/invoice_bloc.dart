import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:eprwindowsapp/core/domain/usecase/get_all_customers_use_case.dart';
import 'package:eprwindowsapp/core/domain/usecase/get_all_products_use_case.dart';
import 'package:eprwindowsapp/features/invoice/data/models/invoice_item_model.dart';
import 'package:eprwindowsapp/features/invoice/data/models/invoice_model.dart';
import 'package:eprwindowsapp/features/invoice/domain/usecases/calculate_landed_cost_use_case.dart';
import 'package:eprwindowsapp/features/invoice/domain/usecases/process_purchase_invoice_use_case.dart';
import 'package:eprwindowsapp/features/invoice/domain/usecases/process_sale_invoice_use_case.dart';
import 'package:eprwindowsapp/config/enum.dart';
import 'invoice_event.dart';
import 'invoice_state.dart';

@injectable
class InvoiceBloc extends Bloc<InvoiceEvent, InvoiceState> {
  final ProcessPurchaseInvoiceUseCase processPurchaseInvoiceUseCase;
  final ProcessSaleInvoiceUseCase processSaleInvoiceUseCase;
  final CalculateLandedCostUseCase calculateLandedCostUseCase;
  final GetAllProductsUseCase getAllProductsUseCase;
  final GetAllCustomersUseCase getAllCustomersUseCase;

  InvoiceBloc({
    required this.processPurchaseInvoiceUseCase,
    required this.processSaleInvoiceUseCase,
    required this.calculateLandedCostUseCase,
    required this.getAllProductsUseCase,
    required this.getAllCustomersUseCase,
  }) : super(const InvoiceState()) {
    on<LoadPurchaseInvoiceDependenciesEvent>(_onLoadDependencies);
    on<LoadSaleInvoiceDependenciesEvent>(_onLoadSaleDependencies);
    on<SelectSaleCustomerEvent>(_onSelectSaleCustomer);
    on<AddInvoiceItemEvent>(_onAddItem);
    on<RemoveInvoiceItemEvent>(_onRemoveItem);
    on<UpdateLandedCostsEvent>(_onUpdateLandedCosts);
    on<SubmitPurchaseInvoiceEvent>(_onSubmitInvoice);
    on<SubmitSaleInvoiceEvent>(_onSubmitSaleInvoice);
  }

  Future<void> _onLoadDependencies(
    LoadPurchaseInvoiceDependenciesEvent event,
    Emitter<InvoiceState> emit,
  ) async {
    emit(state.copyWith(status: InvoiceStatus.loading));

    final result = await getAllProductsUseCase();
    result.fold(
      (failure) => emit(state.copyWith(
        status: InvoiceStatus.failure,
        errorMessage: failure.message,
      )),
      (products) => emit(state.copyWith(
        status: InvoiceStatus.ready,
        availableProducts: products,
      )),
    );
  }

  Future<void> _onLoadSaleDependencies(
    LoadSaleInvoiceDependenciesEvent event,
    Emitter<InvoiceState> emit,
  ) async {
    emit(state.copyWith(status: InvoiceStatus.loading));

    final productsResult = await getAllProductsUseCase();
    final customers = await getAllCustomersUseCase();

    productsResult.fold(
      (failure) => emit(state.copyWith(
        status: InvoiceStatus.failure,
        errorMessage: failure.message,
      )),
      (products) => emit(state.copyWith(
        status: InvoiceStatus.ready,
        availableProducts: products,
        availableCustomers: customers,
      )),
    );
  }

  void _onSelectSaleCustomer(
    SelectSaleCustomerEvent event,
    Emitter<InvoiceState> emit,
  ) {
    emit(state.copyWith(selectedCustomer: event.customer));
  }

  void _onAddItem(
    AddInvoiceItemEvent event,
    Emitter<InvoiceState> emit,
  ) {
    final newItem = InvoiceItemModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      invoiceId: '',
      productId: event.product.id,
      quantity: event.quantity,
      unitPrice: event.unitPrice,
      unitLandedCost: event.unitPrice,
      totalPrice: event.quantity * event.unitPrice,
    );

    final updatedItems = List<InvoiceItemModel>.from(state.items)..add(newItem);
    final itemsTotal =
        updatedItems.fold<double>(0.0, (sum, item) => sum + item.totalPrice);

    final recalculatedItems = _recalculateUnitLandedCosts(
      items: updatedItems,
      freightCost: state.freightCost,
      customsCost: state.customsCost,
      laborCost: state.laborCost,
    );

    emit(state.copyWith(
      items: recalculatedItems,
      totalItemsAmount: itemsTotal,
    ));
  }

  void _onRemoveItem(
    RemoveInvoiceItemEvent event,
    Emitter<InvoiceState> emit,
  ) {
    final updatedItems = List<InvoiceItemModel>.from(state.items)
      ..removeAt(event.index);
    final itemsTotal =
        updatedItems.fold<double>(0.0, (sum, item) => sum + item.totalPrice);

    final recalculatedItems = _recalculateUnitLandedCosts(
      items: updatedItems,
      freightCost: state.freightCost,
      customsCost: state.customsCost,
      laborCost: state.laborCost,
    );

    emit(state.copyWith(
      items: recalculatedItems,
      totalItemsAmount: itemsTotal,
    ));
  }

  void _onUpdateLandedCosts(
    UpdateLandedCostsEvent event,
    Emitter<InvoiceState> emit,
  ) {
    final totalSideCosts =
        event.freightCost + event.customsCost + event.laborCost;

    final recalculatedItems = _recalculateUnitLandedCosts(
      items: state.items,
      freightCost: event.freightCost,
      customsCost: event.customsCost,
      laborCost: event.laborCost,
    );

    emit(state.copyWith(
      freightCost: event.freightCost,
      customsCost: event.customsCost,
      laborCost: event.laborCost,
      totalLandedCost: totalSideCosts,
      items: recalculatedItems,
    ));
  }

  Future<void> _onSubmitInvoice(
    SubmitPurchaseInvoiceEvent event,
    Emitter<InvoiceState> emit,
  ) async {
    if (state.items.isEmpty) {
      emit(state.copyWith(
        status: InvoiceStatus.failure,
        errorMessage: 'اقلام فاکتور نمی‌تواند خالی باشد.',
      ));
      return;
    }

    emit(state.copyWith(status: InvoiceStatus.submitting));

    try {
      final invoiceInputs = state.items.map((item) {
        final product = state.availableProducts.firstWhere(
          (p) => p.id == item.productId,
          orElse: () => throw Exception('محصول مورد نظر یافت نشد.'),
        );
        return InvoiceItemInput(
          productId: item.productId,
          productName: product.name,
          quantity: item.quantity.round(),
          unitPrice: item.unitPrice,
        );
      }).toList();

      final additionalExpenses = [
        if (state.freightCost > 0)
          AdditionalExpense(title: 'کرایه حمل', amount: state.freightCost),
        if (state.customsCost > 0)
          AdditionalExpense(title: 'گمرک', amount: state.customsCost),
        if (state.laborCost > 0)
          AdditionalExpense(title: 'تخلیه و بارگیری', amount: state.laborCost),
      ];

      final parsedDate = DateTime.tryParse(event.date) ?? DateTime.now();

      final purchaseInvoice = InvoiceModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        invoiceNumber: event.invoiceNumber,
        type: InvoiceType.purchase,
        date: parsedDate,
        totalAmount: state.grandTotal,
        shipmentId: event.shipmentId,
        details: event.supplierName
            .trim(),
      );

      await processPurchaseInvoiceUseCase.execute(
        purchaseInvoice: purchaseInvoice,
        supplierAccountId: event.supplierAccountId ?? event.supplierName,
        paymentAccountId: event.paymentAccountId ?? 'default_payment_account',
        items: invoiceInputs,
        additionalExpenses: additionalExpenses,
      );

      emit(state.copyWith(status: InvoiceStatus.success));
    } catch (e) {
      emit(state.copyWith(
        status: InvoiceStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onSubmitSaleInvoice(
    SubmitSaleInvoiceEvent event,
    Emitter<InvoiceState> emit,
  ) async {
    if (state.items.isEmpty) {
      emit(state.copyWith(
        status: InvoiceStatus.failure,
        errorMessage: 'اقلام فاکتور نمی‌تواند خالی باشد.',
      ));
      return;
    }
    if (event.invoiceNumber.trim().isEmpty) {
      emit(state.copyWith(
        status: InvoiceStatus.failure,
        errorMessage: 'شماره فاکتور را وارد کنید.',
      ));
      return;
    }
    if (state.selectedCustomer == null) {
      emit(state.copyWith(
        status: InvoiceStatus.failure,
        errorMessage: 'انتخاب مشتری الزامی است.',
      ));
      return;
    }

    emit(state.copyWith(status: InvoiceStatus.submitting));

    try {
      final invoiceId = DateTime.now().millisecondsSinceEpoch.toString();

      final itemsWithInvoiceId = state.items
          .map((item) => item.copyWith(invoiceId: invoiceId))
          .toList();

      final saleInvoice = InvoiceModel(
        id: invoiceId,
        invoiceNumber: event.invoiceNumber,
        type: InvoiceType.sale,
        customerId: state.selectedCustomer!.id,
        date: DateTime.tryParse(event.date) ?? DateTime.now(),
        totalAmount: state.totalItemsAmount,
        items: itemsWithInvoiceId,
      );

      await processSaleInvoiceUseCase.execute(
        saleInvoice: saleInvoice,
        isCashPayment: false,
      );

      emit(state.copyWith(status: InvoiceStatus.success));
    } catch (e) {
      emit(state.copyWith(
        status: InvoiceStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  List<InvoiceItemModel> _recalculateUnitLandedCosts({
    required List<InvoiceItemModel> items,
    required double freightCost,
    required double customsCost,
    required double laborCost,
  }) {
    if (items.isEmpty) return items;

    final expenses = [
      if (freightCost > 0)
        AdditionalExpense(title: 'کرایه حمل', amount: freightCost),
      if (customsCost > 0)
        AdditionalExpense(title: 'گمرک', amount: customsCost),
      if (laborCost > 0)
        AdditionalExpense(title: 'تخلیه و بارگیری', amount: laborCost),
    ];

    if (expenses.isEmpty) return items;

    final inputs = items.map((item) {
      final product = state.availableProducts.firstWhere(
        (p) => p.id == item.productId,
        orElse: () => throw Exception('محصول مورد نظر یافت نشد.'),
      );
      return InvoiceItemInput(
        productId: item.productId,
        productName: product.name,
        quantity: item.quantity.round(),
        unitPrice: item.unitPrice,
      );
    }).toList();

    final calculationResult = calculateLandedCostUseCase(
      items: inputs,
      expenses: expenses,
      allocationMethod: LandedCostAllocationMethod.byValue,
    );

    return List.generate(items.length, (index) {
      final calculatedItem = calculationResult.items[index];
      return items[index].copyWith(
        unitLandedCost: calculatedItem.unitLandedCost,
      );
    });
  }
}
