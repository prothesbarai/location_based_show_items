import 'package:flutter/material.dart';
import 'package:location_based_show_items/widgets/custom_appbar.dart';
import '../../../config/config.dart';
import '../../../models/shop_model.dart';
import '../../../widgets/builder/vertical_builder/vertical_builder.dart';

class ShowShopProducts extends StatefulWidget {
  final ShopModel shop;

  const ShowShopProducts({super.key, required this.shop});

  @override
  State<ShowShopProducts> createState() => _ShowShopProductsState();
}

class _ShowShopProductsState extends State<ShowShopProducts> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(pageTitle: widget.shop.name),
      body: widget.shop.products.isEmpty ? const Center(child: Text("No products found")) :
      SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: Config.horizontalPaddingProduct, vertical: 10),
        child: Column(
            children: [
              /// >>> Vertically Reusable Product Items
              ...buildVerticallyProductItems(context, widget.shop.products),
            ]
        ),
      ),
    );
  }
}
