part of 'inventory_bloc.dart';

abstract class InventoryState extends Equatable {
  const InventoryState();

  @override
  List<Object> get props => [];
}

class InventoryInitial extends InventoryState {}

class InventoryLoading extends InventoryState {}

class InventoryLoaded extends InventoryState {
  final List<ProductModel> allProducts;
  final List<ProductModel> filteredProducts;
  final String query;

  const InventoryLoaded({
    required this.allProducts,
    required this.filteredProducts,
    this.query = '',
  });

  @override
  List<Object> get props => [allProducts, filteredProducts, query];
}

class InventoryError extends InventoryState {
  final String message;

  const InventoryError(this.message);

  @override
  List<Object> get props => [message];
}
