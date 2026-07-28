import 'dart:convert';

import 'package:app_web/models/subcategory.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:http/http.dart' as http;

import '../global_variables.dart';
import '../services/manage_http_response.dart';

class SubcategoryController {
  uploadSubcategory({
    required String categoryId,
    required String categoryName,
    required context,
    required dynamic pickedImage,
    required String subCategoryName,
  }) async {
    try {
      // upload image

      CloudinaryResponse imageResponse = await cloudinary.uploadFile(
        CloudinaryFile.fromBytesData(
          pickedImage,
          identifier: "pickedImage",
          folder: "banners",
        ),
      );

      String image = imageResponse.secureUrl;

      Subcategory subcategory = Subcategory(
        id: "",
        categoryId: categoryId,
        categoryName: categoryName,
        image: image,
        subCategoryName: subCategoryName,
      );

      http.Response response = await http.post(
        Uri.parse("$uri/api/subcategories"),
        body: subcategory.toJson(),
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
        },
      );

      print(response.statusCode);

      manageHttpResponse(
        response: response,
        context: context,
        onSuccess: () {
          showSnackBar(context, "Subcategory Uploaded");
        },
      );
    } catch (e) {
      print("Error uploading to cloudinary: $e");
    }
  }

  Future<List<Subcategory>> loadSubcategories() async {
    try {
      http.Response response = await http.get(
        Uri.parse("$uri/api/subcategories"),
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
        },
      );

      print(response.body);

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);

        List<Subcategory> subCategories = data
            .map((subCategory) => Subcategory.fromJson(subCategory))
            .toList();

        return subCategories;
      } else
        throw Exception("Failed to load Subcategories");
    } catch (e) {
      throw Exception("Error loading Subcategories: $e");
    }
  }
}
