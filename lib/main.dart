import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:machine_test/block/ProductListBloc.dart';
import 'package:machine_test/repositories/repository.dart';
import 'package:machine_test/screen/HomeScreen.dart';
import 'constants/colors.dart';
import 'api/api_client.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    // Set the status bar and navigation bar colors
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: primaryColor,
      systemNavigationBarColor: Colors.black,
      statusBarIconBrightness: Brightness.light,
    ));

    // Create the ApiClient and AuthRepository instances
    final apiClient = ApiClient(ApiClient.createDio());
    final productRepository = Repository(apiClient);

    return MultiBlocProvider(
      providers: [
        BlocProvider<ProductListBloc>(
          create: (context) => ProductListBloc(productRepository),
        ),
      ],
      child: MaterialApp(
        title: 'Poetroll',
        theme: ThemeData(
          primaryColor: primaryColor,
          colorScheme: ColorScheme.fromSeed(seedColor: primaryColor),
          useMaterial3: true,
        ),
        home: HomeScreen(), // Replace with your HomeScreen class
      ),
    );
  }
}