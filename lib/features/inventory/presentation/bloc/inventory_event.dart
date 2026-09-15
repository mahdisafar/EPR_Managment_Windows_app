part of 'inventory_bloc.dart';

abstract class InventoryEvent extends Equatable {
  const InventoryEvent();

  @override
  List<Object> get props => [];
}

class LoadInventoryProductsEvent extends InventoryEvent {}

class AddInventoryProductEvent extends InventoryEvent {
  final ProductModel product;

  const AddInventoryProductEvent(this.product);

  @override
  List<Object> get props => [product];
}

class SearchInventoryProductsEvent extends InventoryEvent {
  final String query;

  const SearchInventoryProductsEvent(this.query);

  @override
  List<Object> get props => [query];
}
