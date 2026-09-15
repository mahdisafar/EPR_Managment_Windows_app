import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:eprwindowsapp/core/domain/usecase/get_all_products_use_case.dart';
import 'package:eprwindowsapp/features/inventory/data/models/product_model.dart';
import '../../domain/usecases/add_product_usecase.dart';

part 'inventory_event.dart';
part 'inventory_state.dart';

@injectable
class InventoryBloc extends Bloc<InventoryEvent, InventoryState> {
  final GetAllProductsUseCase getAllProductsUseCase;
  final AddProductUseCase addProductUseCase;

  InventoryBloc({
    required this.getAllProductsUseCase,
    required this.addProductUseCase,
  }) : super(InventoryInitial()) {
    on<LoadInventoryProductsEvent>(_onLoad);
    on<AddInventoryProductEvent>(_onAdd);
    on<SearchInventoryProductsEvent>(_onSearch);
  }

  Future<void> _onLoad(
    LoadInventoryProductsEvent event,
    Emitter<InventoryState> emit,
  ) async {
    emit(InventoryLoading());

    final result = await getAllProductsUseCase();
    result.fold(
      (failure) => emit(InventoryError(failure.message)),
      (products) => emit(InventoryLoaded(
        allProducts: products,
        filteredProducts: products,
      )),
    );
  }

  Future<void> _onAdd(
    AddInventoryProductEvent event,
    Emitter<InventoryState> emit,
  ) async {
    final result = await addProductUseCase.execute(product: event.product);

    await result.fold(
      (failure) async => emit(InventoryError(failure.message)),
      (_) async {
        add(LoadInventoryProductsEvent());
      },
    );
  }

  void _onSearch(
    SearchInventoryProductsEvent event,
    Emitter<InventoryState> emit,
  ) {
    if (state is! InventoryLoaded) return;
    final current = state as InventoryLoaded;

    final query = event.query.trim().toLowerCase();
    final filtered = query.isEmpty
        ? current.allProducts
        : current.allProducts
            .where((p) => p.name.toLowerCase().contains(query))
            .toList();

    emit(InventoryLoaded(
      allProducts: current.allProducts,
      filteredProducts: filtered,
      query: event.query,
    ));
  }
}
