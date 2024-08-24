import 'package:equatable/equatable.dart';

// Abstract event class for cart operations
abstract class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object?> get props => [];
}

// Event for adding or updating a cart item
class AddUpdateCartItem extends CartEvent {
  final int variantId;
  final int quantity;

  const AddUpdateCartItem({
    required this.variantId,
    required this.quantity,
  });

  @override
  List<Object?> get props => [variantId, quantity];
}
class CartList extends CartEvent {

  const CartList();

  @override
  List<Object> get props => [];
}