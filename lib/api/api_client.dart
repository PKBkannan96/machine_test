import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:machine_test/model/CartResponse.dart';
import 'package:retrofit/retrofit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/DeviceRegistrationResponse.dart';
import '../model/ProductDetailResponse.dart';
import '../model/TokenResponse.dart';
import '../model/product_list_response.dart';
part 'api_client.g.dart';

@RestApi(baseUrl: "https://emjays.thetunagroup.com/api/")
abstract class ApiClient {
  factory ApiClient(Dio dio, {String? baseUrl}) = _ApiClient;

  @POST("guestToken")
  Future<TokenResponse> getGuestToken(
    @Query("secret_key")  String secretKey,
    @Query("device_type")  String deviceType,
    @Query("device_id")  String deviceId,
  );
  @POST("deviceRegister")
  Future<DeviceRegistrationResponse> registerDevice(
    @Query("device_id")  String deviceId,
    @Query("device_type")  String deviceType,
    @Query("location_id")  String locationId,
    @Query("push_type")  String pushType,
    @Query("push_token")  String pushToken);

  @POST("productList")
  Future<ProductListResponse> getProductList(
    @Query("device_id")  String deviceId,
    @Query("device_type")  String deviceType,
    @Query("category_id")  String categoryId,
    @Query("location_id")  String locationId,
    @Query("skip")  String skip,
    @Query("take")  String take,
  );
  @POST("productDetails")
  Future<ProductDetailResponse> getProductDetails(
    @Query("device_id")  String deviceId,
    @Query("device_type")  String deviceType,
    @Query("location_id")  String locationId,
    @Query("product_id")  int product_id,
  );

  @POST("addUpdateCart")
  Future<CartResponse> addProductCart(
    @Query("device_id")  String deviceId,
    @Query("device_type")  String deviceType,
    @Query("user_id")  int user_id,
    @Query("location_id")  String locationId,
    @Query("variant_id")  int variant_id,
    @Query("quantity")  int quantity,
  );
  @POST("listCartItems")
  Future<CartResponse> listCart(
    @Query("device_id")  String deviceId,
    @Query("device_type")  String deviceType,
    @Query("user_id")  int user_id,
    @Query("location_id")  String locationId,
  );


  static Dio createDio() {
    final dio = Dio(BaseOptions(contentType: "application/json"));
    dio.interceptors.add(JsonResponseInterceptor());
    return dio;
  }
}

class JsonResponseInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    print('TokePtint $token');
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
      print('Authorization header set: Bearer $token');
    }
    super.onRequest(options, handler);

  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // Decode the response data from JSON
    response.data = json.decode(response.data.toString());
    super.onResponse(response, handler);
  }
}
