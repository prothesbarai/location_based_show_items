import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:location_based_show_items/config/config.dart';
import 'package:location_based_show_items/widgets/custom_appbar.dart';
import 'package:lottie/lottie.dart';

class ProductDetailsPage extends StatefulWidget {
  final int productId;
  final String productName;
  final String shopKeeperName;
  final String productImage;
  final String productDescription;
  final String productCategory;
  final double productPrice;
  final int productStock;

  const ProductDetailsPage({
    super.key,
    required this.productId,
    required this.productName,
    required this.shopKeeperName,
    required this.productImage,
    required this.productDescription,
    required this.productCategory,
    required this.productPrice,
    required this.productStock,
  });

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {

  bool _showZoomHint = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: CustomAppbar(pageTitle: widget.shopKeeperName),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            /*ClipRRect(
              borderRadius: BorderRadius.circular(0.0),
              child: InteractiveViewer(
                panEnabled: true,
                minScale: 1,
                maxScale: 4,
                child: CachedNetworkImage(
                  imageUrl: widget.productImage,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
            ),*/



        // Product Image with Lottie zoom hint
        ClipRRect(
        borderRadius: BorderRadius.circular(0.0),
        child: Stack(
          alignment: Alignment.center,
          children: [
            InteractiveViewer(
              panEnabled: true,
              minScale: 1,
              maxScale: 4,
              onInteractionUpdate: (details) {
                if (details.scale > 1.0 && _showZoomHint) {
                  setState(() {_showZoomHint = false;});
                }
              },
              child: CachedNetworkImage(
                width: double.infinity,
                imageUrl: widget.productImage,
                fit: BoxFit.cover,
                placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            ),

            // Lottie overlay, but ignores gestures so zoom still works
            if (_showZoomHint)
              Positioned.fill(
                child: IgnorePointer(
                  child: Container(
                    color: Colors.black.withValues(alpha: 0.5),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [Lottie.asset("assets/lottie/hintzoom.json", height: 100, width: 100, repeat: true,),],
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),








        const SizedBox(height: 16),


            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // Name + Price Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(child: Text(widget.productName, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold,),),),
                      Text("${Config.productPriceSymbol} ${widget.productPrice.toStringAsFixed(2)}", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green,)),
                    ],
                  ),

                  const SizedBox(height: 8),

                  // Category
                  Text("Category: ${widget.productCategory}", style: TextStyle(fontSize: 14, color: Colors.grey.shade600),),
                  const SizedBox(height: 8),

                  // Stock Info
                  Text(widget.productStock > 0 ? "In Stock (${widget.productStock} available)" : "Out of Stock", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: widget.productStock > 0 ? Colors.blue : Colors.red,),),
                  const SizedBox(height: 16),

                  // Description
                  const Text("Description", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,),),
                  const SizedBox(height: 6),
                  Text(widget.productDescription, style: const TextStyle(fontSize: 15, height: 1.4),),
                  const SizedBox(height: 80),

                ],
              ),
            )
          ],
        ),
      ),


      // Bottom Buy Add to Cart Button
      bottomNavigationBar: Container(
        padding: const EdgeInsets.only(bottom: 46,left: 16,right: 16,top: 16),
        decoration: BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.5), blurRadius: 8, offset: const Offset(0, -2),),],),
        child: ElevatedButton(
          onPressed: widget.productStock > 0 ? () {} : null,
          style: ElevatedButton.styleFrom(backgroundColor: Colors.green, padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12),),),
          child: Text(widget.productStock > 0 ? "Add to Cart" : "Out of Stock", style: const TextStyle(fontSize: 18, color: Colors.white),),
        ),
      ),
    );
  }
}
