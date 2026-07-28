import 'package:flutter_riverpod/legacy.dart';

import '../models/product.dart';

final relatedProductProvider =
    StateNotifierProvider<RelatedProductProvider, List<Product>>(
      (ref) => RelatedProductProvider(),
    );

class RelatedProductProvider extends StateNotifier<List<Product>> {
  RelatedProductProvider() : super([]);

  void setProducts(List<Product> products) => state = products;
}
