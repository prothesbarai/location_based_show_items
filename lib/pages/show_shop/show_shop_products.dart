import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:location_based_show_items/widgets/custom_appbar.dart';
import '../../config/config.dart';
import '../../models/shop_model.dart';

class ShowShopProducts extends StatefulWidget {
  final ShopModel shop;

  const ShowShopProducts({super.key, required this.shop});

  @override
  State<ShowShopProducts> createState() => _ShowShopProductsState();
}

class _ShowShopProductsState extends State<ShowShopProducts> {
  Map<int, bool> expandedMap = {};
  Map<int, int> countMap = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(pageTitle: widget.shop.name),
      body: widget.shop.products.isEmpty ? const Center(child: Text("No products found")) :
      SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: Config.horizontalPaddingProduct, vertical: 10),
        child: Column(
          /// >>> generate Function (length, (int index) )  Parameter Nay.....
            children: [
              ...List.generate((widget.shop.products.length / Config.verticalItemGridProduct).ceil(), (int index) {
                final int startIndex = index * Config.verticalItemGridProduct;
                final int endIndex = ((startIndex + Config.verticalItemGridProduct) > widget.shop.products.length) ? widget.shop.products.length : startIndex + Config.verticalItemGridProduct;
                final rowItems = widget.shop.products.sublist(startIndex, endIndex);
                final screenWidth = MediaQuery.of(context).size.width;
                /// >>>           => 360          - 2 *    5    = 350    -  ( 3 - 1 ) * 2  = 346 / 3 = 115.33px Every Item Width  => If ( screenWidth = 360 & rowItems.length = 3 & horizontalPadding = 5 & gap = 2 Hoy )
                /// >>> i.e. Full Screen Theke two side er Padding Margin Gap Sob Remove kore  then Screen Width ke row item er length deye divided korte hobe...
                final rowItemWidth = (screenWidth - (2 * Config.horizontalPaddingProduct) - ((rowItems.length - 1) * Config.gapProduct)) / rowItems.length;

                return Padding(
                  padding: EdgeInsets.only(bottom: Config.gapProduct),
                  child: Row(
                    children: rowItems.asMap().entries.map((entry) {
                      final i = entry.key;
                      final shop = entry.value;
                      final globalIndex = startIndex + i;
                      final isExpanded = expandedMap[globalIndex] ?? false;
                      final count = countMap[globalIndex] ?? 0;
                      final isLastItem = i == rowItems.length - 1;
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
                                Positioned(
                                  right: 1,
                                  bottom: 43,
                                  child: isExpanded
                                      ? Container(
                                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(30), boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 3)],),
                                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              int current = countMap[globalIndex] ?? 1;
                                              if (current > 1) {
                                                countMap[globalIndex] = current - 1;
                                              } else {
                                                expandedMap[globalIndex] = false;
                                                countMap[globalIndex] = 0;
                                              }
                                            });
                                          },
                                          child: Icon(Icons.remove, size: 22, color: Colors.red),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                          child: Text("${countMap[globalIndex] ?? 1}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              countMap[globalIndex] = (countMap[globalIndex] ?? 1) + 1;
                                            });
                                          },
                                          child: Icon(Icons.add, size: 22, color: Colors.green),
                                        ),
                                      ],
                                    ),
                                  )
                                      : GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        expandedMap[globalIndex] = true;
                                        countMap[globalIndex] = 1;
                                      });
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                        boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 3)],
                                      ),
                                      padding: EdgeInsets.all(6),
                                      child: Icon(Icons.add, size: 20, color: Colors.green),
                                    ),
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
