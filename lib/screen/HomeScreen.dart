import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:machine_test/block/ProductListBloc.dart';
import 'package:machine_test/block/CartBloc.dart';
import 'package:machine_test/api/api_client.dart';
import 'package:machine_test/repositories/repository.dart';
import 'package:machine_test/state/ProductListState.dart';
import 'package:machine_test/state/CartState.dart';
import 'package:machine_test/event/ProductListEvent.dart';
import 'package:machine_test/event/CartEvent.dart';
import '../model/product_list_response.dart';
import 'ProductDetailScreen.dart';
import 'CartListScreen.dart'; // Import your CartListScreen
import 'package:shared_preferences/shared_preferences.dart'; // Import shared_preferences

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int cartCount = 0;

  @override
  void initState() {
    super.initState();
    _loadCartCount(); // Load cart count from SharedPreferences when initializing
  }

  // Load cart count from SharedPreferences
  Future<void> _loadCartCount() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      cartCount = prefs.getInt('cartCount') ?? 0;
    });
  }

  // Save cart count to SharedPreferences
  Future<void> _saveCartCount(int count) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('cartCount', count);
  }

  @override
  Widget build(BuildContext context) {
    final apiClient = ApiClient(ApiClient.createDio());
    final repository = Repository(apiClient);

    return WillPopScope(
      onWillPop: () async {
        // Handle back button press here
        // Exit the app
        return true; // Return true to allow the app to exit
      },
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => ProductListBloc(repository)..add(LoadProductList()),
          ),
          BlocProvider(
            create: (context) => CartBloc(repository),
          ),
        ],
        child: Scaffold(
          appBar: AppBar(
            title: Text('Products'),
            actions: [
              BlocBuilder<CartBloc, CartState>(
                builder: (context, state) {
                  if (state is CartLoadSuccess) {
                    cartCount = state.cartResponse.cartItemCount; // Update with the total items in the cart
                    _saveCartCount(cartCount); // Save cart count to SharedPreferences
                  }

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => CartListScreen()),
                      ).then((_) {
                        _reloadCartData(); // Reload cart data when returning to HomeScreen
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Stack(
                        children: [
                          Icon(Icons.shopping_cart),
                          if (cartCount > 0)
                            Positioned(
                              right: 0,
                              child: CircleAvatar(
                                radius: 8,
                                backgroundColor: Colors.red,
                                child: Text(
                                  '$cartCount',
                                  style: TextStyle(fontSize: 12, color: Colors.white),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
          body: BlocListener<ProductListBloc, ProductListState>(
            listener: (context, state) {
              if (state is ProductListLoadSuccess) {
                context.read<CartBloc>().add(CartList()); // Dispatch CartList event after product list load success
              }
            },
            child: BlocBuilder<ProductListBloc, ProductListState>(
              builder: (context, state) {
                if (state is ProductListLoading) {
                  return Center(child: CircularProgressIndicator());
                } else if (state is ProductListLoadSuccess) {
                  return _buildProductGrid(context, state.productListResponse);
                } else if (state is ProductListLoadFailure) {
                  return Center(child: Text('Failed to load products: ${state.error}'));
                } else {
                  return Center(child: Text('No products available'));
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProductGrid(BuildContext context, List<Product> products) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 4,
        crossAxisSpacing: 10.0,
        mainAxisSpacing: 10.0,
      ),
      padding: const EdgeInsets.all(10.0),
      itemCount: products.length,
      itemBuilder: (context, index) {
        return Builder(
          builder: (context) {
            final product = products[index];

            // Get the cartCount from CartBloc state using context.select
            int cartCount = context.select((CartBloc bloc) {
              final state = bloc.state;
              return state is CartLoadSuccess ? state.cartResponse.cartItemCount : 0;
            });

            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProductDetailScreen(
                      productId: product.productId,
                      image: product.variants[0].image_url,
                      initialCartCount: cartCount, // Pass cartCount here
                    ),
                  ),
                ).then((_) {
                  _reloadCartData(); // Reload cart data when returning to HomeScreen
                });
              },
              child: Card(
                elevation: 4,
                child: Column(
                  children: [
                    Expanded(
                      child: Image.network(
                        product.variants[0].image_url,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        product.productName,
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        '${product.variants[0].price.toString()}',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // Reload cart data and count when returning to HomeScreen
  void _reloadCartData() {
    context.read<CartBloc>().add(CartList()); // Re-fetch cart items from the API
    _loadCartCount(); // Reload cart count from SharedPreferences
  }
}