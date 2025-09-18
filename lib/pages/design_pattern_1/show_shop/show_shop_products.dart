import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:location_based_show_items/models/hive_model/add_to_cart_model.dart';
import 'package:location_based_show_items/provider/cart_provider.dart';
import 'package:location_based_show_items/widgets/custom_appbar.dart';
import 'package:provider/provider.dart';
import '../../../config/config.dart';
import '../../../models/shop_model.dart';

class ShowShopProducts extends StatefulWidget {
  final ShopModel shop;

  const ShowShopProducts({super.key, required this.shop});

  @override
  State<ShowShopProducts> createState() => _ShowShopProductsState();
}

class _ShowShopProductsState extends State<ShowShopProducts> {

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
                                          Text("${Config.productPriceSymbol}${shop.price}", style: const TextStyle(color: Colors.green)),
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
                                      final qty = cartProvider.getQuantity(shop.id);
                                      return qty > 0 ?
                                      Container(
                                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(30),boxShadow: [BoxShadow(color: Colors.black26,blurRadius: 3)]),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            /// >>> Remove Button
                                            GestureDetector(
                                              onTap: ()=>cartProvider.removeFromCart(shop.id),
                                              child: const Icon(Icons.remove_circle_outline,size: 22, color: Colors.red),
                                            ),

                                            /// >>> Quantity Text
                                            Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                              child: Text("$qty", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
                                            ),

                                            /// >>> Add Button
                                            GestureDetector(
                                              onTap: () => cartProvider.addToCart(AddToCartModel(productId: shop.id, name: shop.name, image: shop.image, price: shop.price,),),
                                              child: const Icon(Icons.add_circle_outline, size: 22, color: Colors.green),
                                            ),
                                          ],
                                        ),
                                      ) :
                                      GestureDetector(
                                        onTap: ()=>cartProvider.addToCart(AddToCartModel(productId: shop.id, name: shop.name, image: shop.image, price: shop.price),),
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
