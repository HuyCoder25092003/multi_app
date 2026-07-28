import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vendor_store/global_variables.dart';
import 'package:vendor_store/models/vendor.dart';
import 'package:vendor_store/provider/vendor_provider.dart';

import '../services/manage_http_response.dart';

final providerContainer = ProviderContainer();

class VendorAuthController {
  Future<void> signUpVendor({
    required context,
    required String email,
    required String fullName,
    required String password,
  }) async {
    try {
      Vendor vendor = Vendor(
        id: "",
        fullName: fullName,
        email: email,
        state: "",
        city: "",
        locality: "",
        role: "",
        password: password,
      );
      http.Response response = await http.post(
        Uri.parse("$uri/api/vendor/signup"),
        body: vendor.toJson(),
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
        },
      );

      manageHttpResponse(
        response: response,
        context: context,
        onSuccess: () {
          showSnackBar(context, "Vendor Account Created");
        },
      );
    } catch (e) {
      showSnackBar(context, "$e");
    }
  }

  Future<void> signInVendor({
    required context,
    required String email,
    required String password,
  }) async {
    try {
      http.Response response = await http.post(
        Uri.parse("$uri/api/vendor/signin"),
        body: jsonEncode({"email": email, "password": password}),
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
        },
      );

      manageHttpResponse(
        response: response,
        context: context,
        onSuccess: () async {
          SharedPreferences preferences = await SharedPreferences.getInstance();

          //Extract the authentication token from the response body
          String token = jsonDecode(response.body)["token"];

          //STORE the authentication token securely in SharedPreferences
          await preferences.setString("auth_token", token);

          //Encode the user data recived from the backend as json
          final vendorJson = jsonEncode(jsonDecode(response.body)["vendor"]);

          //Update the application state with the vendor data using Riverpod
          providerContainer.read(vendorProvider.notifier).setVendor(vendorJson);

          //store the data in SharedPreferences for future vendor

          await preferences.setString("vendor", vendorJson);

          Navigator.pushNamedAndRemoveUntil(
            context,
            "/mainVendorScreen",
            (route) => false,
          );
          showSnackBar(context, "Logged in succesfully");
        },
      );
    } catch (e) {
      showSnackBar(context, "$e");
    }
  }
}
