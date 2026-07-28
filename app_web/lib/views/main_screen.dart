import 'package:app_web/views/side_bar_screens/category_screen.dart';
import 'package:app_web/views/side_bar_screens/products_screen.dart';
import 'package:app_web/views/side_bar_screens/upload_banner_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';

import '../global_variables.dart';
import './side_bar_screens/buyers_screen.dart';
import './side_bar_screens/vendors_screen.dart';
import 'side_bar_screens/orders_screen.dart';
import 'side_bar_screens/subcategory_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  Widget selectedScreen = VendorsScreen();

  screenSelector(item) {
    switch (item.route) {
      case buyerScreenId:
        setState(() {
          selectedScreen = const BuyersScreen();
        });
        break;
      case vendorsScreenId:
        setState(() {
          selectedScreen = const VendorsScreen();
        });
        break;
      case ordersScreenId:
        setState(() {
          selectedScreen = const OrdersScreen();
        });
        break;
      case categoryScreenId:
        setState(() {
          selectedScreen = const CategoryScreen();
        });
        break;
      case subCategoryScreenId:
        setState(() {
          selectedScreen = const SubcategoryScreen();
        });
        break;
      case uploadBannerScreenId:
        setState(() {
          selectedScreen = const UploadBannerScreen();
        });
        break;
      case productsScreenId:
        setState(() {
          selectedScreen = const ProductScreen();
        });
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AdminScaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text("Management"),
      ),
      body: selectedScreen,
      sideBar: SideBar(
        header: Container(
          height: 50,
          width: double.infinity,
          decoration: BoxDecoration(color: Colors.black),
          child: Center(
            child: Text(
              "Multi Vendor Admin",
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.7,
              ),
            ),
          ),
        ),
        items: const [
          AdminMenuItem(
            title: "Vendors",
            route: vendorsScreenId,
            icon: CupertinoIcons.person_3,
          ),
          AdminMenuItem(
            title: "Buyers",
            route: buyerScreenId,
            icon: CupertinoIcons.person,
          ),
          AdminMenuItem(
            title: "Orders",
            route: ordersScreenId,
            icon: CupertinoIcons.shopping_cart,
          ),
          AdminMenuItem(
            title: "Categories",
            route: categoryScreenId,
            icon: Icons.category,
          ),
          AdminMenuItem(
            title: "Subcategories",
            route: subCategoryScreenId,
            icon: Icons.category_outlined,
          ),
          AdminMenuItem(
            title: "Upload Banner",
            route: uploadBannerScreenId,
            icon: Icons.upload,
          ),
          AdminMenuItem(
            title: "Products",
            route: productsScreenId,
            icon: Icons.store,
          ),
        ],
        selectedRoute: vendorsScreenId,
        onSelected: (item) {
          screenSelector(item);
        },
      ),
    );
  }
}
