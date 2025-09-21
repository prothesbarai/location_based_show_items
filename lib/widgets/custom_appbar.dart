import 'package:flutter/material.dart';
import 'package:location_based_show_items/constant/app_color.dart';
import 'package:location_based_show_items/provider/cart_provider.dart';
import 'package:provider/provider.dart';

import '../pages/cart_page/cart_page.dart';

class CustomAppbar extends StatefulWidget implements PreferredSizeWidget{
  final String pageTitle;
  final bool showCartIcon;
  const CustomAppbar({super.key,required this.pageTitle,required this.showCartIcon});

  @override
  State<CustomAppbar> createState() => _CustomAppbarState();

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class _CustomAppbarState extends State<CustomAppbar> {
  @override
  Widget build(BuildContext context) {

    final totalItem = Provider.of<CartProvider>(context);
    //final itemsQuantity = totalItem.totalItems;
    final itemsUniqueItem = totalItem.uniqueProductsCount;


    return AppBar(
      elevation: 0,
      title: Text(widget.pageTitle),
      backgroundColor: AppColor.primaryColor,
      centerTitle: true,
      actions: [

        /// >>> Add To Cart Icon
        if(widget.showCartIcon == true)...[
          Transform.scale(
            scale: 1,
            child: Badge(
              label: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder: (child, animation) => ScaleTransition(scale: animation, child: child),
                  child:Text('$itemsUniqueItem', key: ValueKey('$itemsUniqueItem'), style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white))),
              alignment: Alignment.topRight,
              backgroundColor: Colors.pink,
              isLabelVisible: true,
              offset: Offset(-5, 5),
              padding: EdgeInsets.symmetric(horizontal: 3, vertical: 1),
              child: IconButton(
                  onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (_) => const CartPage()),);},
                  tooltip: 'Cart', icon: Icon(Icons.shopping_cart,size: 26,)
              ),
            ),
          ),
        ]
      ],
    );
  }
}
