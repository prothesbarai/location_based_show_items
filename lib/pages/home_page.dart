import 'package:flutter/material.dart';
import 'package:location_based_show_items/widgets/custom_appbar.dart';
import 'package:location_based_show_items/widgets/custom_drawer.dart';
import 'package:provider/provider.dart';
import '../provider/location_provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {

    final provider = Provider.of<LocationProvider>(context, listen: false);

    return Scaffold(
      appBar: CustomAppbar(pageTitle: "Home"),
      drawer: CustomDrawer(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("${provider.locationMap['id']}"),
            Text("${provider.locationMap['name']}"),
          ],
        ),
      ),
    );
  }
}
