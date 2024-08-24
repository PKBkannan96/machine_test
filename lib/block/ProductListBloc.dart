import 'package:bloc/bloc.dart';
import 'package:machine_test/model/product_list_response.dart';

import '../event/ProductListEvent.dart';
import '../repositories/repository.dart';
import '../state/ProductListState.dart';

class ProductListBloc extends Bloc<ProductListEvent, ProductListState> {
  final Repository repository;

  ProductListBloc(this.repository) : super(ProductListInitial()) {
    on<LoadProductList>((event, emit) async {
      emit(ProductListLoading());
      try {
        final response = await repository.getToken();
        emit(ProductListLoadSuccess(response!.products));
      } catch (error) {
        print('Error loading product list: $error');
        emit(ProductListLoadFailure('Failed to load products: $error'));
      }
    });
  }
}