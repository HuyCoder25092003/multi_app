import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:multi_store_app/provider/delivered_order_count_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../global_variables.dart';
import '../models/user.dart';
import '../provider/user_provider.dart';
import '../services/manage_http_response.dart';

final providerContainer = ProviderContainer();

class AuthController {
  Future<void> signUpUsers({
    required BuildContext context,
    required String email,
    required String fullName,
    required String password,
  }) async {
    try {
      User user = User(
        id: "",
        fullName: fullName,
        email: email,
        state: "",
        city: "",
        locality: "",
        password: password,
        token: "",
      );

      http.Response response = await http.post(
        Uri.parse("$uri/api/signup"),
        body: user.toJson(),
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
        },
      );

      manageHttpResponse(
        response: response,
        context: context,
        onSuccess: () {
          Navigator.pushNamed(context, loginRoute);
          showSnackBar(context, "Account has been created for you");
        },
      );
    } catch (e) {}
  }

  Future<void> signInUsers({
    required BuildContext context,
    required String email,
    required String password,
    required WidgetRef ref,
  }) async {
    try {
      http.Response response = await http.post(
        Uri.parse("$uri/api/signin"),
        body: jsonEncode({"email": email, "password": password}),
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
        },
      );

      manageHttpResponse(
        response: response,
        context: context,
        onSuccess: () async {
          //Access sharedPreferences for token and user data storage
          SharedPreferences preferences = await SharedPreferences.getInstance();

          //Extract the authentication token from the response body
          String token = jsonDecode(response.body)["token"];

          //STORE the authentication token securely in SharedPreferences
          await preferences.setString("auth_token", token);

          //Encode the user data recived from the backend as json
          final userJson = jsonEncode(jsonDecode(response.body)["user"]);

          //Update the application state with the user data using Riverpod
          ref.read(userProvider.notifier).setUser(userJson);
          ref.read(deliveredOrderCountProvider.notifier).resetCount();

          //store the data in SharedPreferences for future use

          await preferences.setString("user", userJson);

          Navigator.pushNamedAndRemoveUntil(
            context,
            mainScreenRoute,
            (route) => false,
          );
          showSnackBar(context, "Logged In");
        },
      );
    } catch (e) {
      print("Error: $e");
    }
  }

  Future<void> signOutUser({required BuildContext context}) async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      //clear the token and user from SharedPreferences
      await preferences.remove("auth_token");
      await preferences.remove("user");
      //clear the user state
      providerContainer.read(userProvider.notifier).signOut();
      //navigate the user back to the login screen
      Navigator.pushNamedAndRemoveUntil(context, loginRoute, (route) => false);

      showSnackBar(context, "signout successfully");
    } catch (e) {
      showSnackBar(context, "error signing out");
    }
  }

  //Update user's state, city and locality
  Future<void> updateUserLocation({
    required BuildContext context,
    required String id,
    required String state,
    required String city,
    required String locality,
    required WidgetRef ref,
  }) async {
    try {
      http.Response response = await http.put(
        Uri.parse("$uri/api/users/$id"),
        body: jsonEncode({"state": state, "city": city, "locality": locality}),
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
        },
      );

      manageHttpResponse(
        response: response,
        context: context,
        onSuccess: () async {
          final updateUser = jsonDecode(response.body);

          SharedPreferences preferences = await SharedPreferences.getInstance();
          final userJson = jsonEncode(updateUser);

          ref.read(userProvider.notifier).setUser(userJson);

          await preferences.setString("user", userJson);
        },
      );
    } catch (e) {
      showSnackBar(context, "Error updating location");
    }
  }
}
