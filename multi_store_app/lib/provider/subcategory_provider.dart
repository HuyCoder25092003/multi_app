import 'package:flutter_riverpod/legacy.dart';
import 'package:multi_store_app/models/subcategory.dart';

final subcategoryProvider =
    StateNotifierProvider<SubcategoryProvider, List<Subcategory>>(
      (ref) => SubcategoryProvider(),
    );

class SubcategoryProvider extends StateNotifier<List<Subcategory>> {
  SubcategoryProvider() : super([]);

  void setSubcategories(List<Subcategory> subcategories) =>
      state = subcategories;
}
