import 'package:flutter_riverpod/legacy.dart';

import '../models/product.dart';

final topRatedProductProvider =
    StateNotifierProvider<TopRatedProductProvider, List<Product>>(
      (ref) => TopRatedProductProvider(),
    );

class TopRatedProductProvider extends StateNotifier<List<Product>> {
  TopRatedProductProvider() : super([]);

  void setProducts(List<Product> products) => state = products;
}
