import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:multi_store_app/controllers/product_controller.dart';
import 'package:multi_store_app/provider/product_provider.dart';
import 'package:multi_store_app/provider/top_rated_product_provider.dart';
import 'package:multi_store_app/views/screens/nav_screens/widgets/product_item_widget.dart';

class TopRatedWidget extends ConsumerStatefulWidget {
  const TopRatedWidget({super.key});

  @override
  ConsumerState<TopRatedWidget> createState() => _TopRatedWidgetState();
}

class _TopRatedWidgetState extends ConsumerState<TopRatedWidget> {
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    final products = ref.read(productProvider);
    products.isEmpty
        ? fetchProducts()
        : setState(() {
            isLoading = false;
          });
    ;
  }

  Future<void> fetchProducts() async {
    final ProductController productController = ProductController();
    try {
      final products = await productController.loadTopRatedProduct();
      ref.read(topRatedProductProvider.notifier).setProducts(products);
    } catch (e) {
      print("$e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final products = ref.watch(topRatedProductProvider);
    return SizedBox(
      height: 250,
      child: isLoading
          ? Center(child: CircularProgressIndicator(color: Colors.blue))
          : ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: products.length,
              itemBuilder: (context, index) {
                return ProductItemWidget(product: products[index]);
              },
            ),
    );
  }
}
