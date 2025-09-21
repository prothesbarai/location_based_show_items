import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:location_based_show_items/config/config.dart';
import 'package:location_based_show_items/constant/app_color.dart';
import 'package:location_based_show_items/models/shop_model.dart';
import 'package:location_based_show_items/pages/design_pattern_1/show_shop/show_shop_products.dart';
import 'package:location_based_show_items/widgets/custom_appbar.dart';
import 'package:provider/provider.dart';
import 'package:turf/helpers.dart';
import 'package:turf/turf.dart' as turf;

import '../../../provider/location_provider.dart';

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
      extendBody: true,
      appBar: CustomAppbar(pageTitle: "Show Shop",showCartIcon: false,),
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
        padding: EdgeInsets.symmetric(horizontal: Config.horizontalPaddingShop, vertical: 10),
        child: Column(
          /// >>> generate Function (length, (int index) )  Parameter Nay.....
          children: [
            ...List.generate((_filterShops.length / Config.verticalItemGridShop).ceil(), (int index) {
              final int startIndex = index * Config.verticalItemGridShop;
              final int endIndex = ((startIndex + Config.verticalItemGridShop) > _filterShops.length) ? _filterShops.length : startIndex + Config.verticalItemGridShop;
              final rowItems = _filterShops.sublist(startIndex, endIndex);
              final screenWidth = MediaQuery.of(context).size.width;
              /// >>>           => 360          - 2 *    5    = 350    -  ( 3 - 1 ) * 2  = 346 / 3 = 115.33px Every Item Width  => If ( screenWidth = 360 & rowItems.length = 3 & horizontalPadding = 5 & gap = 2 Hoy )
              /// >>> i.e. Full Screen Theke two side er Padding Margin Gap Sob Remove kore  then Screen Width ke row item er length deye divided korte hobe...
              final rowItemWidth = (screenWidth - (2 * Config.horizontalPaddingShop) - ((rowItems.length - 1) * Config.gapShop)) / rowItems.length;

              return Padding(
                padding: EdgeInsets.only(bottom: Config.gapShop),
                child: Row(
                  children: rowItems.map((shop) {
                    final isLastItem = shop == rowItems.last;
                    return GestureDetector(
                      onTap: (){Navigator.push(context, MaterialPageRoute(builder: (context) => ShowShopProducts(shop: shop),));},
                      child: Container(
                        width: rowItemWidth,
                        margin: EdgeInsets.only(right: isLastItem ? 0 : Config.gapShop),
                        child: Card(
                          elevation: 2,
                          child: Stack(
                            children: [
                              ///  Open / Close Image - Top Right
                              Positioned(
                                top: 0,
                                right: 0,
                                child: Image.asset(shop.isOpen == true ? "assets/images/open.png" : "assets/images/closed.png", width: 40,),
                              ),

                              ///  Main Content Center Align
                              Align(
                                alignment: Alignment.center,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      shop.userImage != null && shop.userImage!.isNotEmpty ? CircleAvatar(radius: 40, backgroundImage: CachedNetworkImageProvider("${shop.userImage}"),) : CircleAvatar(radius: 40, backgroundImage: CachedNetworkImageProvider("https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTSLU5_eUUGBfxfxRd4IquPiEwLbt4E_6RYMw&s"),),
                                      SizedBox(height: 8),
                                      Text("${shop.name}", style: TextStyle(fontWeight: FontWeight.bold)),
                                      Text("${shop.phone}", style: TextStyle(fontWeight: FontWeight.bold)),
                                      Text("${shop.description}", textAlign: TextAlign.center),
                                      Text("${shop.openingHours}", textAlign: TextAlign.center),
                                      Text("Delivery: ${shop.deliveryRange}m"),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),


                      ),
                    );
                  }).toList(),
                ),
              );
            }),
          ]
        ),
      )



    );
  }
}


