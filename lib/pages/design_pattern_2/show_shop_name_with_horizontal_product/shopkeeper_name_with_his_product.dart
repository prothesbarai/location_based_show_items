import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:location_based_show_items/widgets/custom_appbar.dart';
import 'package:provider/provider.dart';
import 'package:turf/turf.dart' as turf;
import 'package:turf/helpers.dart';
import '../../../config/config.dart';
import '../../../constant/app_color.dart';
import '../../../models/hive_model/add_to_cart_model.dart';
import '../../../models/shop_model.dart';
import '../../../provider/cart_provider.dart';
import '../../../provider/location_provider.dart';
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

    return Scaffold(
      appBar: CustomAppbar(pageTitle: "PaiFast"),
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
        padding: const EdgeInsets.all(8),
        itemBuilder: (context, index) {
          final shop = _filterShops[index];

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(child: Text(shop.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold,),),),
                  TextButton(onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (context) => AllProducts(shop: shop),),);}, child: const Text("All Products"),)
                ],
              ),
              const SizedBox(height: 8),

              SizedBox(
                height: 190,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: shop.products.length,
                  itemBuilder: (context, prodIndex) {
                    final product = shop.products[prodIndex];
                    return Container(
                        width: 120,
                        margin: EdgeInsets.only(right: 10),
                        child: Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12),),
                          child: Stack(
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  AspectRatio(
                                    aspectRatio: 1,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.only(topLeft:Radius.circular(12),topRight: Radius.circular(12)),
                                      child: CachedNetworkImage(
                                        imageUrl: product.image.isNotEmpty ? product.image : "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTSLU5_eUUGBfxfxRd4IquPiEwLbt4E_6RYMw&s",
                                        fit: BoxFit.cover,
                                        placeholder: (context, url) =>
                                        const Center(child: CircularProgressIndicator()),
                                        errorWidget: (context, url, error) => const Icon(Icons.error),
                                      ),
                                    ),
                                  ),

                                  const SizedBox(height: 5),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                                    child: Column(
                                      children: [
                                        Text(shop.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),maxLines: 1,overflow: TextOverflow.ellipsis,),
                                        Text("${Config.productPriceSymbol}${product.price}", style: const TextStyle(color: Colors.green)),
                                      ],
                                    ),
                                  )
                                ],
                              ),


                              /// >>> Add To Cart And Remove Item From cart UI And Fucntion Start Here [Here Use Consumer => Cause A Short Part Tree Rebuild And Update UI Not Rebuild Full Tree]

                              Positioned(
                                  right: 1,
                                  bottom: 43,
                                  child: Consumer<CartProvider>(builder: (context, cartProvider, child) {
                                    final qty = cartProvider.getQuantity(product.id);
                                    return qty > 0 ?
                                    Container(
                                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(30),boxShadow: [BoxShadow(color: Colors.black26,blurRadius: 3)]),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          /// >>> Remove Button
                                          GestureDetector(
                                            onTap: ()=>cartProvider.removeFromCart(product.id),
                                            child: const Icon(Icons.remove_circle_outline,size: 22, color: Colors.red),
                                          ),

                                          /// >>> Quantity Text
                                          Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                            child: Text("$qty", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
                                          ),

                                          /// >>> Add Button
                                          GestureDetector(
                                            onTap: () => cartProvider.addToCart(AddToCartModel(productId: product.id, name: product.name, image: product.image, price: product.price,),),
                                            child: const Icon(Icons.add_circle_outline, size: 22, color: Colors.green),
                                          ),
                                        ],
                                      ),
                                    ) :
                                    GestureDetector(
                                      onTap: ()=>cartProvider.addToCart(AddToCartModel(productId: product.id, name: product.name, image: product.image, price: product.price),),
                                      child: Container(
                                        decoration: BoxDecoration(color: Colors.white,shape: BoxShape.circle,boxShadow: [BoxShadow(color: Colors.black26,blurRadius: 3)]),
                                        padding: const EdgeInsets.all(6),
                                        child: const Icon(Icons.add_circle_outline,size: 20,color: Colors.green,),
                                      ),
                                    );
                                  },)
                              ),

                              /// <<< Add To Cart And Remove Item From cart UI And Fucntion End Here


                            ],
                          ),
                        )
                    );
                  },
                ),
              ),
            ],
          );
        },
      )
    );
  }
}

