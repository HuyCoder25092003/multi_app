import 'package:flutter_riverpod/legacy.dart';

import '../models/product.dart';

final productProvider = StateNotifierProvider<ProductProvider, List<Product>>(
  (ref) => ProductProvider(),
);

class ProductProvider extends StateNotifier<List<Product>> {
  ProductProvider() : super([]);

  void setProducts(List<Product> products) => state = products;
}
