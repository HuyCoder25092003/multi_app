import 'package:flutter/material.dart';
import 'package:multi_store_app/views/screens/nav_screens/widgets/banner_widget.dart';
import 'package:multi_store_app/views/screens/nav_screens/widgets/category_item_widget.dart';
import 'package:multi_store_app/views/screens/nav_screens/widgets/popular_product_widget.dart';
import 'package:multi_store_app/views/screens/nav_screens/widgets/reusable_text_widget.dart';
import 'package:multi_store_app/views/screens/nav_screens/widgets/top_rated_widget.dart';

import 'widgets/header/header_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            HeaderWidget(),
            Transform.translate(
              offset: const Offset(0, -50),
              child: const BannerWidget(),
            ),
            Transform.translate(
              offset: const Offset(0, -50),
              child: CategoryItemWidget(),
            ),
            Transform.translate(
              offset: const Offset(0, -50),
              child: ReusableTextWidget(
                title: "Popular Products",
                subtitle: "view all",
              ),
            ),
            Transform.translate(
              offset: const Offset(0, -50),
              child: PopularProductWidget(),
            ),
            Transform.translate(
              offset: const Offset(0, -50),
              child: ReusableTextWidget(
                title: "Top Rated Products",
                subtitle: "view all",
              ),
            ),
            Transform.translate(
              offset: const Offset(0, -50),
              child: TopRatedWidget(),
            ),
          ],
        ),
      ),
    );
  }
}
