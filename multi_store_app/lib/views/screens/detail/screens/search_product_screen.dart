import 'package:flutter/material.dart';
import 'package:multi_store_app/controllers/product_controller.dart';

import '../../../../models/product.dart';
import '../../nav_screens/widgets/product_item_widget.dart';

class SearchProductScreen extends StatefulWidget {
  const SearchProductScreen({super.key});

  @override
  State<SearchProductScreen> createState() => _SearchProductScreenState();
}

class _SearchProductScreenState extends State<SearchProductScreen> {
  final TextEditingController searchController = TextEditingController();
  final ProductController productController = ProductController();
  List<Product> searchProducts = [];
  bool isLoading = false;

  void searchProduct() async {
    setState(() {
      isLoading = true;
    });

    try {
      final query = searchController.text.trim();
      if (query.isNotEmpty) {
        final products = await productController.searchProducts(query);
        setState(() {
          searchProducts = products;
        });
      }
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final crossAxisCount = screenWidth < 600 ? 2 : 4;
    final childAspectRatio = screenWidth < 600 ? 3 / 4 : 4 / 5;
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: searchController,
          decoration: InputDecoration(
            labelText: "search products ...",
            suffixIcon: IconButton(
              onPressed: searchProduct,
              icon: Icon(Icons.search),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: 16),
          if (isLoading)
            Center(child: CircularProgressIndicator())
          else if (searchProducts.isEmpty)
            Center(child: Text("No Product Found"))
          else
            Expanded(
              child: GridView.builder(
                itemCount: searchProducts.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  childAspectRatio: childAspectRatio,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                ),
                itemBuilder: (context, index) {
                  return ProductItemWidget(product: searchProducts[index]);
                },
              ),
            ),
        ],
      ),
    );
  }
}
