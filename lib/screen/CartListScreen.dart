import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:machine_test/event/CartEvent.dart';
import 'package:machine_test/model/CartResponse.dart';
import 'package:machine_test/screen/CheckoutScreen.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import shared_preferences

import '../api/api_client.dart';
import '../block/CartBloc.dart';
import '../repositories/repository.dart';
import '../state/CartState.dart';

class CartListScreen extends StatefulWidget {
  @override
  _CartListScreenState createState() => _CartListScreenState();
}

class _CartListScreenState extends State<CartListScreen> {
  CartResponse? _cachedCartResponse;

  @override
  void initState() {
    super.initState();
    _loadCachedCartData(); // Load cached cart data when the screen initializes
  }

  // Load cached cart data from SharedPreferences
  Future<void> _loadCachedCartData() async {
    final prefs = await SharedPreferences.getInstance();
    final cartData = prefs.getString('cachedCartData');
    if (cartData != null) {
      setState(() {
        _cachedCartResponse = CartResponse.fromJson(cartData as Map<String, dynamic>); // Assuming CartResponse has a fromJson method
      });
    }
  }

  // Save cart data to SharedPreferences
  Future<void> _saveCartData(CartResponse cartResponse) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('cachedCartData', cartResponse.toJson() as String); // Assuming CartResponse has a toJson method
  }

  @override
  Widget build(BuildContext context) {
    final apiClient = ApiClient(ApiClient.createDio());
    final repository = Repository(apiClient);

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => CartBloc(repository)
            ..add(CartList()), // Dispatching CartList event
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: Text('Cart List'),
        ),
        body: BlocConsumer<CartBloc, CartState>(
          listener: (context, state) {
            if (state is CartLoadFailure) {
              // Show SnackBar when there's an error
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Failed to load cart items: ${state.error}'),
                  backgroundColor: Colors.red,
                ),
              );
              // Keep old data in case of failure
              if (_cachedCartResponse != null) {
                setState(() {
                  _cachedCartResponse = _cachedCartResponse; // Retain old data
                });
              }
            } else if (state is CartLoadSuccess) {
              // Save new cart data to SharedPreferences
              _saveCartData(state.cartResponse);
              setState(() {
                _cachedCartResponse = state.cartResponse;
              });
            }
          },
          builder: (context, state) {
            if (state is CartLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is CartLoadSuccess) {
              return Column(
                children: [
                  Expanded(
                    child: _buildCartList(context, state.cartResponse),
                  ),
                  _buildCartTotals(context,state.cartResponse),
                ],
              );
            } else if (state is CartLoadFailure) {
              // Show cached data if available
              if (_cachedCartResponse != null) {
                return Column(
                  children: [
                    Expanded(
                      child: _buildCartList(context, _cachedCartResponse!),
                    ),
                    _buildCartTotals(context,_cachedCartResponse!),
                  ],
                );
              }
              // If no cached data, show an empty container
              return SizedBox.shrink();
            } else {
              return Center(child: Text('No cart items available'));
            }
          },
        ),
      ),
    );
  }

  Widget _buildCartList(BuildContext context, CartResponse cartListResponse) {
    final cartItems = cartListResponse.cartItems;

    return ListView.builder(
      itemCount: cartItems.length,
      itemBuilder: (context, index) {
        final item = cartItems[index];

        return ListTile(
          leading: Image.network(
            item.image,
            width: 100,
            height: 100,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Image.asset('assets/images/help_me_wt_icon.png', width: 100, height: 100, fit: BoxFit.cover);
            },
          ),
          title: Text(item.name),
          subtitle: Text('Price: ${item.price}'),
          trailing: Row(
            mainAxisSize: MainAxisSize.min, // Ensure row only takes the necessary width
            children: [
              IconButton(
                icon: Icon(Icons.remove),
                onPressed: () {
                  context.read<CartBloc>().add(AddUpdateCartItem(variantId: item.productId, quantity: -1));
                },
              ),
              Text('${item.quantity}', style: TextStyle(fontSize: 16)), // Adjust text style as needed
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  context.read<CartBloc>().add(AddUpdateCartItem(variantId: item.productId, quantity: 1));
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCartTotals(BuildContext context, CartResponse cartListResponse) {
    final totalAmount = double.tryParse(cartListResponse.totalAmount) ?? 0.0;
    final totalTax = double.tryParse(cartListResponse.totalTax) ?? 0.0;
    final grandTotal = double.tryParse(cartListResponse.grandTotal) ?? 0.0;

    // Check if the cart is empty
    final isCartEmpty = cartListResponse.cartItems.isEmpty;

    return Container(
      padding: EdgeInsets.all(16.0),
      color: Colors.grey[900], // Dark grey background for totals
      child: Column(
        children: [
          Text('Total Amount: \$${totalAmount.toStringAsFixed(2)}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
          Text('Total Tax: \$${totalTax.toStringAsFixed(2)}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
          SizedBox(height: 8),
          Text('Grand Total: \$${grandTotal.toStringAsFixed(2)}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green)),
          SizedBox(height: 16),
          SizedBox(
            width: double.infinity, // Ensure the button spans the width of the screen
            child: ElevatedButton(
              onPressed: () {
                if (isCartEmpty) {
                  // Show a message if the cart is empty
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('No items in the cart.'),
                      backgroundColor: Colors.red,
                    ),
                  );
                } else {
                  // Navigate to Checkoutscreen if the cart is not empty
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Checkoutscreen()),
                  );
                }
              },
              child: Text('Proceed'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue, // Button color
                padding: EdgeInsets.symmetric(vertical: 16.0), // Button height
              ),
            ),
          ),
        ],
      ),
    );
  }
}