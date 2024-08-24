import 'package:equatable/equatable.dart';

import '../model/CartResponse.dart';

abstract class CartState extends Equatable {
  const CartState();

  @override
  List<Object> get props => [];
}

class CartInitial extends CartState {}

class CartLoading extends CartState {}

class CartLoadSuccess extends CartState {
  final CartResponse cartResponse;

  const CartLoadSuccess(this.cartResponse);

  @override
  List<Object> get props => [cartResponse];
}

class CartLoadFailure extends CartState {
  final String error;

  const CartLoadFailure(this.error);

  @override
  List<Object> get props => [error];
}