import 'package:bloc/bloc.dart';
import '../event/CartEvent.dart';
import '../repositories/repository.dart';
import '../state/CartState.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final Repository cartRepository;

  CartBloc(this.cartRepository) : super(CartInitial()) {
    on<CartList>((event, emit) async {
      emit(CartLoading()); // Emit loading state while the request is processed

      try {
        final response = await cartRepository.listCart();

        if (response != null && response.response == 'success') {
          // Assuming response has the cart details after adding/updating an item
          final cartResponse = response; // Extract cart details from the response
          emit(CartLoadSuccess(cartResponse)); // Emit success state with cart details
        } else {
          emit(CartLoadFailure(response?.response ?? 'Failed to add/update cart item.'));
        }
      } catch (error) {
        print('Error adding/updating cart item: $error');
        emit(CartLoadFailure( 'Failed to add/update cart item: $error'));
      }
    });
    on<AddUpdateCartItem>((event, emit) async {
      emit(CartLoading()); // Emit loading state while the request is processed

      try {
        final response = await cartRepository.addProductCart(event.variantId, event.quantity);

        if (response != null && response.response == 'success') {
          // Assuming response has the cart details after adding/updating an item
          final cartResponse = response; // Extract cart details from the response
          emit(CartLoadSuccess(cartResponse)); // Emit success state with cart details
        } else {
          emit(CartLoadFailure(response?.response ?? 'Failed to add/update cart item.'));
        }
      } catch (error) {
        print('Error adding/updating cart item: $error');
        emit(CartLoadFailure( 'Failed to add/update cart item: $error'));
      }
    });
  }
}