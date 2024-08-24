import 'package:equatable/equatable.dart';
import '../model/ProductDetailResponse.dart';

abstract class ProductDetailState extends Equatable {
  const ProductDetailState();

  @override
  List<Object> get props => [];
}

class ProductDetailInitial extends ProductDetailState {}

class ProductDetailLoading extends ProductDetailState {}

class ProductDetailLoadSuccess extends ProductDetailState {
  final ProductDetailResponse productDetailResponse;

  const ProductDetailLoadSuccess(this.productDetailResponse);

  @override
  List<Object> get props => [productDetailResponse];
}

class ProductDetailLoadFailure extends ProductDetailState {
  final String error;

  const ProductDetailLoadFailure(this.error);

  @override
  List<Object> get props => [error];
}