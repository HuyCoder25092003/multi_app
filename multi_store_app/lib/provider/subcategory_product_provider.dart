import 'package:flutter_riverpod/legacy.dart';

import '../models/product.dart';

final subcategoryProductProvider =
    StateNotifierProvider<SubcategoryProductProvider, List<Product>>(
      (ref) => SubcategoryProductProvider(),
    );

class SubcategoryProductProvider extends StateNotifier<List<Product>> {
  SubcategoryProductProvider() : super([]);

  void setProducts(List<Product> subcategories) => state = subcategories;
}
