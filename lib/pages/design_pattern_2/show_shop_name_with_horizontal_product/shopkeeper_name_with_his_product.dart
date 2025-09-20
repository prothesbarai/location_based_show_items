import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:location_based_show_items/widgets/custom_appbar.dart';
import 'package:provider/provider.dart';
import 'package:turf/turf.dart' as turf;
import 'package:turf/helpers.dart';
import '../../../constant/app_color.dart';
import '../../../models/shop_model.dart';
import '../../../provider/location_provider.dart';
import '../../../widgets/builder/horizontal_builder/horizontal_builder.dart';
import 'all_products.dart';

class ShopkeeperNameWithHisProduct extends StatefulWidget {
  const ShopkeeperNameWithHisProduct({super.key});

  @override
  State<ShopkeeperNameWithHisProduct> createState() => _ShopkeeperNameWithHisProductState();
}

class _ShopkeeperNameWithHisProductState extends State<ShopkeeperNameWithHisProduct> {



  List<ShopModel> _filterShops = [];
  bool isLoading = true;


  @override
  void initState() {
    super.initState();
    _loadShop();
  }


  Future<void> _loadShop() async{
    try{
      final provider = Provider.of<LocationProvider>(context, listen: false);
      final lat = provider.locationMap['userLat'];
      final lng = provider.locationMap['userLong'];


      final response = await http.get(Uri.parse("https://prothesbarai.github.io/collect/shopkeepers.json"));
      if(response.statusCode == 200){

        final List<dynamic> data = json.decode(response.body);
        final allShops = data.map((e)=>ShopModel.fromJson(e)).toList();

        final userPoint = turf.Point(coordinates: turf.Position(lng, lat));

        _filterShops = allShops.where((shop) {
          final shopPoint = turf.Point(coordinates: turf.Position(shop.lng!, shop.lat!));
          final distance = turf.distance(userPoint, shopPoint, Unit.meters);
          return distance <= shop.deliveryRange!;
        }).toList();

        setState(() {isLoading = false;});
      }else {
        debugPrint("Failed to fetch shops. Status: ${response.statusCode}");
      }

    }catch(e){
      debugPrint("Error loading shops: $e");
    }
  }




  @override
  Widget build(BuildContext context) {

    final provider = Provider.of<LocationProvider>(context, listen: false);

    return Scaffold(
      appBar: CustomAppbar(pageTitle: "Grocery"),
      body: isLoading ?
      Center(
        child: Container(
          decoration: BoxDecoration(color: AppColor.primaryColor,borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Your Location:\nLat: ${provider.locationMap['userLat']},\nLng: ${provider.locationMap['userLong']}", style: const TextStyle(fontSize: 16,color: Colors.white), textAlign: TextAlign.center,),
                SizedBox(height: 10,),
                CircularProgressIndicator(color: Colors.white,),
              ],
            ),
          ),
        ),
      ): _filterShops.isEmpty ? const Center(child: Text("কোনো নিকটবর্তী দোকান পাওয়া যায়নি")) :
      ListView.builder(
        itemCount: _filterShops.length,
        physics: BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          final shop = _filterShops[index];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 4.0,bottom:4.0, left: 10.0,right: 0.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(child: Text("${shop.name}", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold,),),),
                    TextButton(
                      onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (context) => AllProducts(shop: shop),),);}, 
                      child: Row(
                        children: [
                          const Text("All Products",style: TextStyle(fontSize: 14),),
                          const Icon(Icons.arrow_forward_ios_rounded,size: 14,)
                        ],
                      ),
                    )
                  ],
                ),
              ),
              /// Reusable Widget Call
              HorizontalBuilder(shop: shop),
            ],
          );
        },
      )
    );
  }
}

