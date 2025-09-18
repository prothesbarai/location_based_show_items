import 'package:flutter/material.dart';
import 'package:location_based_show_items/widgets/custom_appbar.dart';
import 'package:location_based_show_items/widgets/custom_drawer.dart';
import 'package:provider/provider.dart';
import '../provider/location_provider.dart';
import 'design_pattern_1/show_shop/show_location_based_shop.dart';
import 'design_pattern_2/show_shop_name_with_horizontal_product/shopkeeper_name_with_his_product.dart';

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
            //Text("Location-ID : ${provider.locationMap['id']},\nLocation-Name : ${provider.locationMap['name']}"),
            Text("User-Longitude : ${provider.locationMap['userLong']},\nUser-Latitude : ${provider.locationMap['userLat']}"),
            ElevatedButton(
                onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context) => ShowLocationBasedShop(),));},
                child: Text("Show Shop Based On Location")
            ),
            ElevatedButton(
                onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context) => ShopkeeperNameWithHisProduct(),));},
                child: Text("Show Shop Name & Product Horizontally")
            )
          ],
        ),
      ),
    );
  }
}
