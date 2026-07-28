import 'dart:convert';

import 'package:http/http.dart' as http;

import '../global_variables.dart';
import '../models/subcategory.dart';

class SubcategoryController {
  Future<List<Subcategory>> getSubCategoriesByCategoryName(
    String categoryName,
  ) async {
    try {
      http.Response response = await http.get(
        Uri.parse("$uri/api/category/$categoryName/subcategories"),
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
        },
      );

      print('URL: $uri');
      print('Status: ${response.statusCode}');
      print('Body: ${response.body}');

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);

        print(data);

        if (data.isNotEmpty) {
          return data
              .map((subCategory) => Subcategory.fromJson(subCategory))
              .toList();
        } else {
          print("subcategories not found");
          return [];
        }
      } else if (response.statusCode == 404) {
        print("subcategories not found");
        return [];
      } else {
        print("failed to fetch subcategories");
        return [];
      }
    } catch (e) {
      print("Error fetching categories: $e");
      return [];
    }
  }
}
