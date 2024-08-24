import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:machine_test/block/ProductDetailBloc.dart';
import 'package:machine_test/block/CartBloc.dart';
import 'package:machine_test/api/api_client.dart';
import 'package:machine_test/repositories/repository.dart';
import 'package:machine_test/state/ProductDetailState.dart';
import 'package:machine_test/state/CartState.dart';
import 'package:machine_test/event/ProductDetailEvent.dart';
import 'package:machine_test/event/CartEvent.dart';
import '../model/ProductDetailResponse.dart';
import 'CartListScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductDetailScreen extends StatefulWidget {
  final int productId;
  final String image;
  final int initialCartCount;

  ProductDetailScreen({
    required this.productId,
    required this.image,
    required this.initialCartCount,
  });

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final ValueNotifier<bool> _isLoading = ValueNotifier(false);
  late int _cartCount;

  @override
  void initState() {
    super.initState();
    _cartCount = widget.initialCartCount;
    _loadCartCount(); // Load cart count from SharedPreferences
  }

  // Load cart count from SharedPreferences
  Future<void> _loadCartCount() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _cartCount = prefs.getInt('cartCount') ?? widget.initialCartCount;
    });
  }

  // Save cart count to SharedPreferences
  Future<void> _saveCartCount(int count) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('cartCount', count);
  }

  @override
  void dispose() {
    _isLoading.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final apiClient = ApiClient(ApiClient.createDio());
    final repository = Repository(apiClient);

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ProductDetailBloc(repository)
            ..add(LoadProductDetail(widget.productId)),
        ),
        BlocProvider(
          create: (context) => CartBloc(repository),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: Text('Product Details'),
          actions: [
            BlocBuilder<CartBloc, CartState>(
              builder: (context, state) {
                if (state is CartLoadSuccess) {
                  _cartCount = state.cartResponse.cartItemCount;
                  _saveCartCount(_cartCount); // Save the updated cart count to SharedPreferences
                } else if (state is CartLoadFailure) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Order Limit Exceeded'),
                        duration: Duration(seconds: 2),
                        backgroundColor: Colors.red,
                      ),
                    );
                  });
                }

                return IconButton(
                  icon: Stack(
                    children: [
                      Icon(Icons.shopping_cart),
                      if (_cartCount > 0)
                        Positioned(
                          right: 0,
                          child: CircleAvatar(
                            radius: 8,
                            backgroundColor: Colors.red,
                            child: Text(
                              '$_cartCount',
                              style: TextStyle(fontSize: 12, color: Colors.white),
                            ),
                          ),
                        ),
                    ],
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CartListScreen()),
                    );
                  },
                );
              },
            ),
          ],
        ),
        body: Stack(
          children: [
            BlocBuilder<ProductDetailBloc, ProductDetailState>(
              builder: (context, state) {
                if (state is ProductDetailLoading) {
                  return Center(child: CircularProgressIndicator());
                } else if (state is ProductDetailLoadSuccess) {
                  return _buildProductDetail(context, state.productDetailResponse);
                } else if (state is ProductDetailLoadFailure) {
                  return Center(child: Text('Failed to load product details: ${state.error}'));
                } else {
                  return Center(child: Text('No product details available'));
                }
              },
            ),
            // Transparent loader
            ValueListenableBuilder<bool>(
              valueListenable: _isLoading,
              builder: (context, isLoading, child) {
                if (isLoading) {
                  return Container(
                    color: Colors.black54,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
                return SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductDetail(BuildContext context, ProductDetailResponse productDetailResponse) {
    final product = productDetailResponse.products;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              widget.image,
              fit: BoxFit.cover,
              width: double.infinity,
              height: 200,
            ),
            SizedBox(height: 16),
            Text(
              product.productName,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Brand: ${product.brandName}',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            SizedBox(height: 8),
            Text(
              'Price: ${product.variants[0].price}',
              style: TextStyle(fontSize: 18, color: Colors.green),
            ),
            SizedBox(height: 16),
            Text(
              'Description:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              product.productLongDescription,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              'THC Content: ${product.thcType}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'CBD Content: ${product.cbdType}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'Plant Type: ${product.plantType}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                _addToCart(context, product.variants[0].id);
              },
              child: Text('Add to Cart'),
            ),
          ],
        ),
      ),
    );
  }

  void _addToCart(BuildContext context, int variantId) {
    final quantity = 1;
    _isLoading.value = true; // Start loading

    context.read<CartBloc>().add(AddUpdateCartItem(variantId: variantId, quantity: quantity));

    // Listen to CartBloc changes to stop loading
    context.read<CartBloc>().stream.listen((state) {
      if (state is CartLoadSuccess || state is CartLoadFailure) {
        _isLoading.value = false; // Stop loading
      }
    });
  }
}