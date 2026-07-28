import 'dart:convert';

import 'package:http/http.dart' as http;

import '../global_variables.dart';
import '../models/buyer.dart';

class BuyerController {
  Future<List<Buyer>> loadBuyer() async {
    try {
      http.Response response = await http.get(
        Uri.parse("$uri/api/users"),
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
        },
      );

      print(response.body);

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);

        List<Buyer> buyers = data.map((buyer) => Buyer.fromMap(buyer)).toList();

        return buyers;
      } else
        throw Exception("Failed to load Buyers");
    } catch (e) {
      throw Exception("Error loading Buyers: $e");
    }
  }
}
