import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:location_based_show_items/widgets/custom_appbar.dart';
import '../../config/config.dart';
import '../../models/shop_model.dart';

class ShowShopProducts extends StatelessWidget {
  final ShopModel shop;

  const ShowShopProducts({super.key, required this.shop});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(pageTitle: shop.name),
      body: shop.products.isEmpty ? const Center(child: Text("No products found")) :
      SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: Config.horizontalPaddingProduct, vertical: 10),
        child: Column(
          /// >>> generate Function (length, (int index) )  Parameter Nay.....
            children: [
              ...List.generate((shop.products.length / Config.verticalItemGridProduct).ceil(), (int index) {
                final int startIndex = index * Config.verticalItemGridProduct;
                final int endIndex = ((startIndex + Config.verticalItemGridProduct) > shop.products.length) ? shop.products.length : startIndex + Config.verticalItemGridProduct;
                final rowItems = shop.products.sublist(startIndex, endIndex);
                final screenWidth = MediaQuery.of(context).size.width;
                /// >>>           => 360          - 2 *    5    = 350    -  ( 3 - 1 ) * 2  = 346 / 3 = 115.33px Every Item Width  => If ( screenWidth = 360 & rowItems.length = 3 & horizontalPadding = 5 & gap = 2 Hoy )
                /// >>> i.e. Full Screen Theke two side er Padding Margin Gap Sob Remove kore  then Screen Width ke row item er length deye divided korte hobe...
                final rowItemWidth = (screenWidth - (2 * Config.horizontalPaddingProduct) - ((rowItems.length - 1) * Config.gapProduct)) / rowItems.length;

                return Padding(
                  padding: EdgeInsets.only(bottom: Config.gapProduct),
                  child: Row(
                    children: rowItems.map((shop) {
                      final isLastItem = shop == rowItems.last;
                      return GestureDetector(
                        onTap: (){
                          if(kDebugMode){
                            print(shop.name);
                          }
                        },
                        child: Container(
                          width: rowItemWidth,
                          margin: EdgeInsets.only(right: isLastItem ? 0 : Config.gapProduct),
                          child: Card(
                            elevation: 2,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12),),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                AspectRatio(
                                  aspectRatio: 1,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.only(topLeft:Radius.circular(12),topRight: Radius.circular(12)),
                                    child: CachedNetworkImage(
                                      imageUrl: shop.image.isNotEmpty ? shop.image : "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTSLU5_eUUGBfxfxRd4IquPiEwLbt4E_6RYMw&s",
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
                                      Text("৳${shop.price}", style: const TextStyle(color: Colors.green)),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          )
                        ),
                      );
                    }).toList(),
                  ),
                );
              }),
            ]
        ),
      ),
    );
  }
}
