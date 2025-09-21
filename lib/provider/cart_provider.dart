import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import '../models/hive_model/add_to_cart_model.dart';

class CartProvider with ChangeNotifier{
  final Box<AddToCartModel> _cartBox = Hive.box<AddToCartModel>('CartBox');

  List<AddToCartModel> get cartItems => _cartBox.values.toList();


  /// >>> Firstly Check if any product is in the cart .. [ Check Kore Product Id deye je oi Product Cart e ase kina ?]
  bool isInCart(int productId){
    return _cartBox.values.any((item)=> item.productId == productId && item.quantity > 0);
  }
  
  
  /// >>>  Kono Product er Quantity Ber korar Jonno 
  int getQuantity(int productId){
    final item = _cartBox.values.firstWhere((e)=> e.productId == productId, orElse: ()=> AddToCartModel(productId: productId, name: "", image: "", price: 0, quantity: 0),);
    return item.quantity;
  }



  /// >>> Item Add To Cart Korar Jonno & Quantity Baranor Jonno
  void addToCart(AddToCartModel product){
    // indexWhere Jode Index Match na pay tobe -1 Return kore...
    final existingIndex = _cartBox.values.toList().indexWhere((e)=> e.productId == product.productId);

    if(existingIndex != -1){ // Product Match Paice So update Koro
      final existingItem = _cartBox.getAt(existingIndex)!;
      existingItem.quantity += 1;
      existingItem.save();
    }else{ // Product Match Pay Nai So New Add Koro
      _cartBox.add(product..quantity = 1);
    }
    notifyListeners();
  }



  /// >>> Item Decrease Korar Jonno & Quantity Decrease Jonno
  void removeFromCart(int productId){
    final existingIndex = _cartBox.values.toList().indexWhere((e)=> e.productId == productId);
    if(existingIndex != -1){
      final existingItem = _cartBox.getAt(existingIndex)!;
      if(existingItem.quantity > 1){
        existingItem.quantity -= 1;
        existingItem.save();
      }else{
        existingItem.quantity = 0;
        existingItem.save();
      }
      notifyListeners();
    }
  }


  /// >>> Cart e total koyta item (quantity soho) ache seta ber korar jonno
  int get totalItems => _cartBox.values.fold(0, (sum, item) => sum + item.quantity);


  /// >>> Cart e alada koyta product add holo (unique product count)
  int get uniqueProductsCount => _cartBox.values.where((item) => item.quantity > 0).length;

}