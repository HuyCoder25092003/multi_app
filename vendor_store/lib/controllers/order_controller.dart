import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../global_variables.dart';
import '../models/order.dart';
import '../services/manage_http_response.dart';

class OrderController {
  Future<List<Order>> loadOrders({required String vendorId}) async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String? token = preferences.getString("auth_token");
      http.Response response = await http.get(
        Uri.parse("$uri/api/orders/vendors/$vendorId"),
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
          "x-auth-token": token!,
        },
      );

      print(response.body);

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);

        List<Order> orders = data
            .map((order) => Order.fromJson(order))
            .toList();
        return orders;
      } else {
        throw Exception("Failed to load orders");
      }
    } catch (e) {
      throw Exception("Error loading order: $e");
    }
  }

  Future<void> deleteOrder({required String id, required context}) async {
    try {
      http.Response response = await http.delete(
        Uri.parse("$uri/api/orders/$id"),
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
        },
      );

      manageHttpResponse(
        response: response,
        context: context,
        onSuccess: () {
          showSnackBar(context, "Order Deleted successfully");
        },
      );
    } catch (e) {
      showSnackBar(context, "$e");
    }
  }

  Future<void> updateDeliveryStatus({
    required String id,
    required context,
  }) async {
    try {
      http.Response response = await http.patch(
        Uri.parse("$uri/api/orders/$id/delivered"),
        body: jsonEncode({"delivered": true, "processing": false}),
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
        },
      );

      manageHttpResponse(
        response: response,
        context: context,
        onSuccess: () {
          showSnackBar(context, "Order Update");
        },
      );
    } catch (e) {
      throw Exception("Error loading order: $e");
    }
  }

  Future<void> cancelOrder({required String id, required context}) async {
    try {
      http.Response response = await http.patch(
        Uri.parse("$uri/api/orders/$id/processing"),
        body: jsonEncode({"processing": false, "delivered": false}),
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
        },
      );

      manageHttpResponse(
        response: response,
        context: context,
        onSuccess: () {
          showSnackBar(context, "Order Canceled");
        },
      );
    } catch (e) {
      throw Exception("Error loading order: $e");
    }
  }
}
