import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:location_based_show_items/constant/app_color.dart';
import 'package:location_based_show_items/models/shop_model.dart';
import 'package:location_based_show_items/widgets/custom_appbar.dart';
import 'package:provider/provider.dart';
import 'package:turf/helpers.dart';
import 'package:turf/turf.dart' as turf;
import '../provider/location_provider.dart';

class ShowLocationBasedShop extends StatefulWidget {
  const ShowLocationBasedShop({super.key});

  @override
  State<ShowLocationBasedShop> createState() => _ShowLocationBasedShopState();
}

class _ShowLocationBasedShopState extends State<ShowLocationBasedShop> {

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
          final shopPoint = turf.Point(coordinates: turf.Position(shop.lng, shop.lat));
          final distance = turf.distance(userPoint, shopPoint, Unit.meters);
          return distance <= shop.deliveryRange;
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

    final int verticalItemGrid =2;
    final double horizontalPadding = 5;
    final double gap = 2;


    return Scaffold(
      extendBody: true,
      appBar: CustomAppbar(pageTitle: "Show Shop"),
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
      SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 10),
        child: Column(
          children: List.generate((_filterShops.length / verticalItemGrid).ceil(), (rowIndex) {
            final int startIndex = rowIndex * verticalItemGrid;
            final int endIndex = ((startIndex + verticalItemGrid) > _filterShops.length) ? _filterShops.length : startIndex + verticalItemGrid;
            final rowItems = _filterShops.sublist(startIndex, endIndex);
            final screenWidth = MediaQuery.of(context).size.width;

            /// >>>           => 360          - 2 *    5    = 350    -  ( 3 - 1 ) * 2  = 346 / 3 = 115.33px Every Item Width  => If ( screenWidth = 360 & rowItems.length = 3 & horizontalPadding = 5 & gap = 2 Hoy )
            /// >>> i.e. Full Screen Theke two side er Padding Margin Gap Sob Remove kore  then Screen Width ke row item er length deye divided korte hobe...
            final rowItemWidth = (screenWidth - (2 * horizontalPadding) - ((rowItems.length - 1) * gap)) / rowItems.length;

            return Padding(
              padding: EdgeInsets.only(bottom: gap),
              child: Row(
                children: rowItems.map((shop) {
                  final isLastItem = shop == rowItems.last;
                  return Container(
                    width: rowItemWidth,
                    margin: EdgeInsets.only(right: isLastItem ? 0 : gap),
                    child: Card(
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.store, color: Colors.blue, size: 40),
                            SizedBox(height: 8),
                            Text(shop.name, style: TextStyle(fontWeight: FontWeight.bold)),
                            Text("Delivery: ${shop.deliveryRange}m"),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            );
          }),
        ),
      )



    );
  }
}
