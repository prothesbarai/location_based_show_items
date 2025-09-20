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

  late Map<String, List<ProductModel>> categoryWiseProducts;


  @override
  void initState() {
    super.initState();
    _groupProductsByCategory();
  }


  /// >>>  Create a Map And All Products Group By Category , If Category Exist in Map So Add Product But Not Exist Then Create New Empty Category
  void _groupProductsByCategory() {
    categoryWiseProducts = {};
    for (var product in widget.shop.products){
      final category = product.category;
      if(!categoryWiseProducts.containsKey(category)){
        categoryWiseProducts[category] = [];
      }
      categoryWiseProducts[category]!.add(product);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(pageTitle: "${widget.shop.name}"),
      body: widget.shop.products.isEmpty ? const Center(child: Text("No products found")) :
      SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
          /// >>> generate Function (length, (int index) )  Parameter Nay.....
            children: [
              Stack(
                children: [
                  /// >>> Shop Banner
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

              const SizedBox(height: 10),
              
              /// >>>  Show Product Category Wise >>>
              const SizedBox(height: 10),

              /// Category Wise Horizontal Section
              ...categoryWiseProducts.entries.map((entry) {
                final category = entry.key;
                final products = entry.value;
                final categoryShop = ShopModel(id: widget.shop.id, products: products,);

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Category Title
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
                      child: Text(category, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                    ),

                    /// HorizontalBuilder reuse
                    HorizontalBuilder(shop: categoryShop),

                    const SizedBox(height: 12),
                  ],
                );
              }),

              const SizedBox(height: 50),
            ]
        ),
      ),
    );
  }
}
