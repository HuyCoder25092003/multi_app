import 'package:flutter_riverpod/legacy.dart';

import '../models/category.dart';

final categoryProvider =
    StateNotifierProvider<CategoryProvider, List<Category>>(
      (ref) => CategoryProvider(),
    );

class CategoryProvider extends StateNotifier<List<Category>> {
  CategoryProvider() : super([]);

  void setCategories(List<Category> categories) => state = categories;
}
