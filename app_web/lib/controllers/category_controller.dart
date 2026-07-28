import 'dart:convert';

import 'package:app_web/models/caetgory.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:http/http.dart' as http;

import '../global_variables.dart';
import '../services/manage_http_response.dart';

class CategoryController {
  uploadCategory({
    required dynamic pickedImage,
    required dynamic pickedBanner,
    required String name,
    required context,
  }) async {
    try {
      // upload image

      CloudinaryResponse imageResponse = await cloudinary.uploadFile(
        CloudinaryFile.fromBytesData(
          pickedImage,
          identifier: "pickedImage",
          folder: "categoryImages",
        ),
      );

      String image = imageResponse.secureUrl;

      CloudinaryResponse bannerResponse = await cloudinary.uploadFile(
        CloudinaryFile.fromBytesData(
          pickedBanner,
          identifier: "pickedBanner",
          folder: "categoryImages",
        ),
      );

      String banner = bannerResponse.secureUrl;

      Category category = Category(
        id: "",
        name: name,
        image: image,
        banner: banner,
      );

      http.Response response = await http.post(
        Uri.parse("$uri/api/categories"),
        body: category.toJson(),
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
        },
      );

      print(response.statusCode);

      manageHttpResponse(
        response: response,
        context: context,
        onSuccess: () {
          showSnackBar(context, "Upload Category");
        },
      );
    } catch (e) {
      print("Error uploading to cloudinary: $e");
    }
  }

  Future<List<Category>> loadCategories() async {
    try {
      http.Response response = await http.get(
        Uri.parse("$uri/api/categories"),
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
        },
      );

      print(response.body);

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);

        List<Category> categories = data
            .map((category) => Category.fromJson(category))
            .toList();

        return categories;
      } else
        throw Exception("Failed to load Categories");
    } catch (e) {
      throw Exception("Error loading Categories: $e");
    }
  }
}
