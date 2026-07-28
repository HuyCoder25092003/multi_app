import 'dart:convert';

import 'package:flutter_riverpod/legacy.dart';
import 'package:multi_store_app/models/favorite.dart';
import 'package:shared_preferences/shared_preferences.dart';

final favoriteProvider =
    StateNotifierProvider<FavoriteProvider, Map<String, Favorite>>(
      (ref) => FavoriteProvider(),
    );

class FavoriteProvider extends StateNotifier<Map<String, Favorite>> {
  FavoriteProvider() : super({}){
    loadFavorites();
  }

  Future<void> loadFavorites()async{
    final prefs = await SharedPreferences.getInstance();
    final favoriteString = prefs.getString("favorites");
    if(favoriteString!=null){
      final Map<String,dynamic> favoriteMap = jsonDecode(favoriteString);
      final favorites = favoriteMap.map((key,value)=>MapEntry(key, Favorite.fromJson(value)));
      state = favorites;
    }
  }

  Future<void> saveFavorites()async{
    final prefs = await SharedPreferences.getInstance();
    final favoriteString = jsonEncode(state);
    await prefs.setString("favorites", favoriteString);
  }

  void addProductToFavorite({
    required String productName,
    required int productPrice,
    required String category,
    required List<String> image,
    required String vendorId,
    required int productQuantity,
    required int quantity,
    required String productId,
    required String description,
    required String fullName,
  }) {
    state[productId] = Favorite(
      productName: productName,
      productPrice: productPrice,
      category: category,
      image: image,
      vendorId: vendorId,
      productQuantity: productQuantity,
      quantity: quantity,
      productId: productId,
      description: description,
      fullName: fullName,
    );
    state = {...state};
    saveFavorites();
  }

  void removeFavoriteItem(String productId) {
    state.remove(productId);
    state = {...state};
    saveFavorites();
  }

  Map<String, Favorite> get getFavoriteItems => state;
}
