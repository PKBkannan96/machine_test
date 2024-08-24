import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:machine_test/event/CartEvent.dart';
import 'package:machine_test/model/CartResponse.dart';
import 'package:machine_test/screen/HomeScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api/api_client.dart';
import '../block/CartBloc.dart';
import '../repositories/repository.dart';
import '../state/CartState.dart';

class Checkoutscreen extends StatefulWidget {
  @override
  _CartListScreenState createState() => _CartListScreenState();
}

class _CartListScreenState extends State<Checkoutscreen> {
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

  // Show confirmation dialog and handle payment
  void _handlePayment(BuildContext context) {
    final grandTotal = double.tryParse(_cachedCartResponse?.grandTotal ?? '0.0') ?? 0.0;

    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dismissing by tapping outside
      builder: (context) => AlertDialog(
        title: Text('Confirm Payment'),
        content: Text('Are you sure you want to pay \$${grandTotal.toStringAsFixed(2)}?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
              _showPaymentSuccess(context, grandTotal); // Show payment success
            },
            child: Text('Confirm'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: Text('Cancel'),
          ),
        ],
      ),
    );
  }

  // Show payment success message
  void _showPaymentSuccess(BuildContext context, double amountPaid) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Payment Successful'),
        content: Text('Amount Paid: \$${amountPaid.toStringAsFixed(2)}'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
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
          title: Text('Check Out'),
        ),
        body: BlocConsumer<CartBloc, CartState>(
          listener: (context, state) {
            if (state is CartLoadFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Failed to load cart items: ${state.error}'),
                  backgroundColor: Colors.red,
                ),
              );
              if (_cachedCartResponse != null) {
                setState(() {
                  _cachedCartResponse = _cachedCartResponse; // Retain old data
                });
              }
            } else if (state is CartLoadSuccess) {
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
                  _buildCartTotals(context, state.cartResponse),
                ],
              );
            } else if (state is CartLoadFailure) {
              if (_cachedCartResponse != null) {
                return Column(
                  children: [
                    Expanded(
                      child: _buildCartList(context, _cachedCartResponse!),
                    ),
                    _buildCartTotals(context, _cachedCartResponse!),
                  ],
                );
              }
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
            mainAxisSize: MainAxisSize.min,
          ),
        );
      },
    );
  }

  Widget _buildCartTotals(BuildContext context, CartResponse cartListResponse) {
    final totalAmount = double.tryParse(cartListResponse.totalAmount) ?? 0.0;
    final totalTax = double.tryParse(cartListResponse.totalTax) ?? 0.0;
    final grandTotal = double.tryParse(cartListResponse.grandTotal) ?? 0.0;

    return Container(
      padding: EdgeInsets.all(16.0),
      color: Colors.white,
      child: Column(
        children: [
          Text('Total Amount: \$${totalAmount.toStringAsFixed(2)}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black)),
          Text('Total Tax: \$${totalTax.toStringAsFixed(2)}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black)),
          SizedBox(height: 8),
          Text('Grand Total: \$${grandTotal.toStringAsFixed(2)}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
          SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                _handlePayment(context); // Show confirmation dialog on button press
              },
              child: Text('Pay'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                padding: EdgeInsets.symmetric(vertical: 16.0),
              ),
            ),
          ),
        ],
      ),
    );
  }
}