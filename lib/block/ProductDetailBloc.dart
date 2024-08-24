import 'package:bloc/bloc.dart';

import '../event/ProductDetailEvent.dart';
import '../repositories/repository.dart';
import '../state/ProductDetailState.dart'; // Adjust the import based on your file structure

class ProductDetailBloc extends Bloc<ProductDetailEvent, ProductDetailState> {
  final Repository repository;

  ProductDetailBloc(this.repository) : super(ProductDetailInitial()) {
    on<LoadProductDetail>((event, emit) async {
      emit(ProductDetailLoading());
      try {
        final response = await repository.getProductDetails(event.productId);
        if (response != null) {
          emit(ProductDetailLoadSuccess(response));
        } else {
          emit(ProductDetailLoadFailure('No details found for the product.'));
        }
      } catch (error) {
        print('Error loading product details: $error');
        emit(ProductDetailLoadFailure('Failed to load product details: $error'));
      }
    });
  }
}