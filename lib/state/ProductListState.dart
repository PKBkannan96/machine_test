import 'package:equatable/equatable.dart';

import '../model/product_list_response.dart';

abstract class ProductListState extends Equatable {
  const ProductListState();

  @override
  List<Object> get props => [];
}

class ProductListInitial extends ProductListState {}

class ProductListLoading extends ProductListState {}

class ProductListLoadSuccess extends ProductListState {
  final List<Product> productListResponse;

  const ProductListLoadSuccess(this.productListResponse);

  @override
  List<Object> get props => [productListResponse];
}

class ProductListLoadFailure extends ProductListState {
  final String error;

  const ProductListLoadFailure(this.error);

  @override
  List<Object> get props => [error];
}