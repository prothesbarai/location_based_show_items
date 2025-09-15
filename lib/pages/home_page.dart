import 'package:flutter/material.dart';
import 'package:location_based_show_items/widgets/custom_appbar.dart';
import 'package:location_based_show_items/widgets/custom_drawer.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(pageTitle: "Home"),
      drawer: CustomDrawer(),
    );
  }
}
