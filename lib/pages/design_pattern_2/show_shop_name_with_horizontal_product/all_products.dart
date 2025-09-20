import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../models/shop_model.dart';
import '../../../widgets/builder/horizontal_builder/horizontal_builder.dart';
import '../../../widgets/custom_appbar.dart';

class AllProducts extends StatefulWidget {
  final ShopModel shop;
  const AllProducts({required this.shop, super.key});

  @override
  State<AllProducts> createState() => _AllProductsState();
}

class _AllProductsState extends State<AllProducts> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(pageTitle: widget.shop.name),
      body: widget.shop.products.isEmpty ? const Center(child: Text("No products found")) :
      SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          /// >>> generate Function (length, (int index) )  Parameter Nay.....
            children: [
              Stack(
                children: [
                  CachedNetworkImage(
                    imageUrl: "https://placehold.co/600x200.png",
                    fit: BoxFit.cover,
                    placeholder: (context, url) =>
                    const Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) => const Icon(Icons.error),
                  ),
                  Positioned(left: 5, top: 5, child: CircleAvatar(radius: 30,backgroundColor: Color(0xff808080),)),
                  Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        height: 20,
                        width: 50,
                        decoration: BoxDecoration(color: widget.shop.isOpen == true ?Colors.green:Colors.pink,shape: BoxShape.rectangle,borderRadius: BorderRadius.only(bottomLeft: Radius.circular(8))),
                        child: Text(widget.shop.isOpen == true ?"Open":"Closed",style: TextStyle(color: Colors.white),textAlign: TextAlign.center,),
                      )
                  ),
                ],
              ),

              /// Reusable Widget Call
              HorizontalBuilder(shop: widget.shop),

              SizedBox(height: 50,)
            ]
        ),
      ),
    );
  }
}
