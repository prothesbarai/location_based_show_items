import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../models/hive_model/add_to_cart_model.dart';
import '../../provider/cart_provider.dart';
import '../../widgets/custom_appbar.dart';
import '../product_details_page/product_details_page.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(pageTitle: "Cart Page", showCartIcon: false),
      body: Consumer<CartProvider>(
        builder: (context, cartProvider, child) {
          // quantity null-safe filter
          final List<AddToCartModel> cartItems = cartProvider.cartItems.where((e) => (e.quantity) > 0).toList();
          if (cartItems.isEmpty) {
            return const Center(child: Text("Your 🛒 cart is empty"));
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: cartItems.length,
                  itemBuilder: (context, index) {
                    final item = cartItems[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          ListTile(
                            leading: GestureDetector(
                              onTap :(){Navigator.push(context, MaterialPageRoute(builder: (context) => ProductDetailsPage(productId: item.productId, productName: item.name, shopKeeperName: "shopKeeperName", productImage: item.image, productDescription: item.description, productCategory: item.category, productPrice: item.price, productStock: item.stock),));},
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(5),
                                child: CachedNetworkImage(
                                  imageUrl: item.image,
                                  width: 60,
                                  height: 60,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                                  errorWidget: (context, url, error) => const Icon(Icons.error),
                                ),
                              ),
                            ),
                            title: Text(item.name),
                            subtitle: Text("৳ ${item.price.toStringAsFixed(2)}"),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.remove_circle, color: Colors.red),
                                  onPressed: () {cartProvider.removeFromCart(item.productId);},
                                ),
                                Text("${item.quantity}", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                IconButton(
                                  icon: const Icon(Icons.add_circle, color: Colors.green),
                                  onPressed: () {cartProvider.addToCart(item);},
                                ),
                              ],
                            ),
                          ),
                          /// >>> Positioned Delete Button
                          Positioned(
                            left: -12,
                            top: -12,
                            child: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {cartProvider.deleteItem(item.productId);},
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              /// >>>  Bottom Checkout Button
              Container(
                padding: const EdgeInsets.only(bottom: 46, left: 16, right: 16, top: 16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text("Total: ৳ ${cartItems.fold(0.0, (sum, e) => sum + (e.price * e.quantity)).toStringAsFixed(2)}", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Proceed to Checkout...")),);
                      },
                      style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14), backgroundColor: Colors.pink,),
                      child: const Text("Checkout", style: TextStyle(fontSize: 16, color: Colors.white)),
                    )
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
