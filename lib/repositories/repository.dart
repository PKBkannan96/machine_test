import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:machine_test/model/TokenResponse.dart';
import '../api/api_client.dart';
import '../model/CartResponse.dart';
import '../model/ProductDetailResponse.dart';
import '../model/product_list_response.dart';

class Repository {
  final ApiClient apiClient;

  Repository(this.apiClient);

  Future<bool> _isConnected() async {
    final connectivityResult = await (Connectivity().checkConnectivity());
    return connectivityResult != ConnectivityResult.none;
  }

  // Future<List<Product>> getProduct() async {
  //   if (!await _isConnected()) {
  //     throw 'No internet connection'; // Remove Exception() wrapper
  //   }
  //   try {
  //     final response = await apiClient.getProducts();
  //     print('response_ ${response.last.title}');
  //     return response;
  //   } catch (e) {
  //     print('Login ErrorPkb: $e');
  //     rethrow;
  //   }
  // }

  Future<ProductListResponse?> getToken() async {
    if (!await _isConnected()) {
      throw 'No internet connection'; // Remove Exception() wrapper
    }
    try {
      final response = await apiClient.getGuestToken(
        'hirVfHKUrTmHpUNM89X6N2oaf6ZleLOhIQHCQTMbFHWuoTnOYeoEsQUpRWkNJKwkOYOWebVyN2p',
        '3',
        'pkb',
      );
      print('pkbToken: ${response.toJson()}');
      // Save token to SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_token', response.token);
      var responsr_reg =  await apiClient.registerDevice('pkb','3','1','2','pkb');
      await prefs.setInt('user_id', responsr_reg.guestUserId);
      print('pkbTokenDevReg ${responsr_reg.message}');
        var prolist =  await apiClient.getProductList('pkb', '3', '1', '1', '0', '10',);
      print('pkbTokenPro ${prolist.products[0].productName}');
      return prolist;
    } catch (e) {
      print('Login ErrorPkb: $e');
      rethrow;
    }
  }
  Future<ProductDetailResponse?> getProductDetails(int pro_id) async {
    if (!await _isConnected()) {
      throw 'No internet connection'; // Remove Exception() wrapper
    }
    try {
      return await apiClient.getProductDetails('pkb', '3', '1',pro_id);
    } catch (e) {
      print('Login ErrorPkb: $e');
      rethrow;
    }
  }
  Future<CartResponse?> addProductCart(int variend_id,int qty) async {
    if (!await _isConnected()) {
      throw 'No internet connection'; // Remove Exception() wrapper
    }
    try {
      final prefs = await SharedPreferences.getInstance();
      final user_id = prefs.getInt('user_id');
      return await apiClient.addProductCart('pkb', '3', user_id!,'1',variend_id,qty);
    } catch (e) {
      print('Login ErrorPkb: $e');
      throw 'Order Limit Exceeded';
      rethrow;
    }
  }
  Future<CartResponse?> listCart() async {
    if (!await _isConnected()) {
      throw 'No internet connection'; // Remove Exception() wrapper
    }
    try {
      final prefs = await SharedPreferences.getInstance();
      final user_id = prefs.getInt('user_id');
      return await apiClient.listCart('pkb', '3', user_id!,'1');
    } catch (e) {
      print('Login ErrorPkb: $e');
      rethrow;
    }
  }

  Future<String?> getTokenFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }
}