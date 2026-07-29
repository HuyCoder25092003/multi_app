import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:multi_store_app/provider/user_provider.dart';
import 'package:multi_store_app/views/screens/detail/screens/checkout_screen.dart';
import 'package:multi_store_app/views/screens/detail/screens/order_screen.dart';
import 'package:multi_store_app/views/screens/detail/screens/search_product_screen.dart';
import 'package:multi_store_app/views/screens/detail/screens/shipping_address_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import './global_variables.dart';
import './views/screens/authentication_screens/login_screen.dart';
import './views/screens/authentication_screens/register_screen.dart';
import './views/screens/main_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Stripe.publishableKey =
      "pk_test_51TyWrzA4bFSZIOtmWQxzXi5VRNN3rKhPRBI1Hz3o9KGeses1wzLKJE33rU6bvnAUS3kr6mG524luW370VAvyYIST00gnvGP1zG";

  await Stripe.instance.applySettings();

  runApp(ProviderScope(child: const MyApp()));
}

//Root widget of the application, a cosummerWidget to cosume state change
class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  //Method to check the token and set the user data if available
  Future<void> checkTokenAndUser(WidgetRef ref) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    //Retrive the authentication token and user data stored locally.
    String? token = preferences.getString("auth_token");

    String? userJson = preferences.getString("user");

    // if both token and user data are avaible,update the user state
    if (token != null && userJson != null) {
      ref.read(userProvider.notifier).setUser(userJson);
    } else {
      ref.read(userProvider.notifier).signOut();
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: Colors.transparent),
    );
    return MaterialApp(
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
      home: FutureBuilder(
        future: checkTokenAndUser(ref),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final user = ref.watch(userProvider);
          return user != null ? MainScreen() : LoginScreen();
        },
      ),
      routes: {
        loginRoute: (context) => LoginScreen(),
        regitserRoute: (context) => RegisterScreen(),
        mainScreenRoute: (context) => MainScreen(),
        checkOutScreenRoute: (context) => CheckoutScreen(),
        shippingAddressScreenRoute: (context) => ShippingAddressScreen(),
        orderScreenRoute: (context) => OrderScreen(),
        searchProductScreenRoute: (context) => SearchProductScreen(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
