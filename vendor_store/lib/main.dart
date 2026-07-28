import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vendor_store/views/screens/authentication/register_screen.dart';
import 'package:vendor_store/views/screens/main_vendor_screen.dart';

import 'global_variables.dart';
import 'provider/vendor_provider.dart';
import 'views/screens/authentication/login_screen.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  //Method to check the token and set the user data if available

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Future<void> checkTokenAndSetUser(WidgetRef ref) async {
      SharedPreferences preferences = await SharedPreferences.getInstance();

      //Retrive the authentication token and user data stored locally.
      String? token = preferences.getString("auth_token");

      String? vendorJson = preferences.getString("vendor");

      // if both token and user data are avaible,update the user state
      if (token != null && vendorJson != null) {
        ref.read(vendorProvider.notifier).setVendor(vendorJson);
      } else {
        ref.read(vendorProvider.notifier).signOut();
      }
    }

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
      home: FutureBuilder(
        future: checkTokenAndSetUser(ref),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final vendor = ref.watch(vendorProvider);
          return vendor != null ? MainVendorScreen() : LoginScreen();
        },
      ),
      routes: {
        loginRoute: (context) => LoginScreen(),
        regitserRoute: (context) => RegisterScreen(),
        mainVendorScreenRoute: (context) => MainVendorScreen(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
