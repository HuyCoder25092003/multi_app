import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:multi_store_app/models/order.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../global_variables.dart';
import '../services/manage_http_response.dart';

class OrderController {
  uploadOrders({
    required String id,
    required String fullName,
    required String email,
    required String state,
    required String city,
    required String locality,
    required String productName,
    required int productPrice,
    required int quantity,
    required String category,
    required String image,
    required String buyerId,
    required String vendorId,
    required bool processing,
    required bool delivered,
    required String paymentStatus,
    required String paymentIntentId,
    required String paymentMethod,
    required context,
  }) async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String? token = preferences.getString("auth_token");
      final Order order = Order(
        id: id,
        fullName: fullName,
        email: email,
        state: state,
        city: city,
        locality: locality,
        productName: productName,
        productPrice: productPrice,
        quantity: quantity,
        category: category,
        image: image,
        buyerId: buyerId,
        vendorId: vendorId,
        processing: processing,
        delivered: delivered,
        paymentStatus: paymentStatus,
        paymentIntentId: paymentIntentId,
        paymentMethod: paymentMethod
      );
      http.Response response = await http.post(
        Uri.parse("$uri/api/orders"),
        body: order.toJson(),
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
          "x-auth-token": token!,
        },
      );
      manageHttpResponse(
        response: response,
        context: context,
        onSuccess: () {
          showSnackBar(context, "You have placed an order");
        },
      );
    } catch (e) {
      showSnackBar(context, "$e");
    }
  }

  Future<List<Order>> loadOrders({required String buyerId}) async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String? token = preferences.getString("auth_token");
      http.Response response = await http.get(
        Uri.parse("$uri/api/orders/$buyerId"),
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
      } else if (response.statusCode == 404) {
        return [];
      } else {
        throw Exception("Failed to load orders");
      }
    } catch (e) {
      throw Exception("Error loading order: $e");
    }
  }

  Future<void> deleteOrder({required String id, required context}) async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String? token = preferences.getString("auth_token");
      http.Response response = await http.delete(
        Uri.parse("$uri/api/orders/$id"),
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
          "x-auth-token": token!,
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

  Future<int> getDeliveredOrderCount({required String buyerId}) async {
    try {
      List<Order> orders = await loadOrders(buyerId: buyerId);
      int deliveredCount = orders.where((order) => order.delivered).length;
      return deliveredCount;
    } catch (e) {
      throw Exception("Error counting Delivered Orders");
    }
  }

  Future<Map<String, dynamic>> createPaymentIntent({
    required int amount,
    required String currency,
  }) async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String? token = preferences.getString("auth_token");
      http.Response response = await http.post(
        Uri.parse("$uri/api/payment-intent"),
        body: jsonEncode({"amount": amount, "currency": currency}),
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
          "x-auth-token": token!,
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception("Failed to create payment intent ${response.body}");
      }
    } catch (e) {
      throw Exception("Error Create Payment Intent: $e");
    }
  }

  Future<Map<String, dynamic>> getPaymentIntentStatus({
    required BuildContext context,
    required String paymentIntentId,
  }) async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String? token = preferences.getString("auth_token");
      http.Response response = await http.get(
        Uri.parse("$uri/api/payment-intent/$paymentIntentId"),
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
          "x-auth-token": token!,
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception("Failed to get payment intent ${response.body}");
      }
    } catch (e) {
      throw Exception("Failed to get payment intent $e");
    }
  }
}
