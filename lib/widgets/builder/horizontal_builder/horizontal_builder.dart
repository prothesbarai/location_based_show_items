import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../config/config.dart';
import '../../../models/hive_model/add_to_cart_model.dart';
import '../../../models/shop_model.dart';
import '../../../provider/cart_provider.dart';

class HorizontalBuilder extends StatelessWidget {
  final ShopModel shop;
  const HorizontalBuilder({super.key,required this.shop});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double screenWidth = constraints.maxWidth;
        double visibleItems = 2.8;
        double itemWidth = screenWidth / visibleItems;
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              ...List.generate(shop.products.length, (prodIndex) {
                final product = shop.products[prodIndex];
                return Container(
                  width: itemWidth,
                  margin: EdgeInsets.only(left: prodIndex == 0 ? 8 : 0, right: prodIndex == shop.products.length - 1 ? 8 : 3,),
                  child: Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: Stack(
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.min, // auto height
                          children: [
                            AspectRatio(
                              aspectRatio: 1,
                              child: ClipRRect(
                                borderRadius: const BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
                                child: CachedNetworkImage(
                                  imageUrl: product.image.isNotEmpty ? product.image : "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTSLU5_eUUGBfxfxRd4IquPiEwLbt4E_6RYMw&s",
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                                  errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                                ),
                              ),
                            ),
                            const SizedBox(height: 5),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 5.0),
                              child: Column(
                                children: [
                                  Text(product.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14), maxLines: 1, overflow: TextOverflow.ellipsis,),
                                  Text("${Config.productPriceSymbol}${product.price}", style: const TextStyle(color: Colors.green),),
                                  SizedBox(height: 3,),
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
                  ),
                );
              }),
              SizedBox(height: 50,),
            ],
          ),
        );
      },
    );
  }
}
