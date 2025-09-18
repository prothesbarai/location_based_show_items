import 'package:flutter/material.dart';
import 'package:location_based_show_items/widgets/custom_appbar.dart';

class ShopkeeperNameWithHisProduct extends StatefulWidget {
  const ShopkeeperNameWithHisProduct({super.key});

  @override
  State<ShopkeeperNameWithHisProduct> createState() => _ShopkeeperNameWithHisProductState();
}

class _ShopkeeperNameWithHisProductState extends State<ShopkeeperNameWithHisProduct> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(pageTitle: "PaiFast"),
      body: SingleChildScrollView(),
    );
  }
}

