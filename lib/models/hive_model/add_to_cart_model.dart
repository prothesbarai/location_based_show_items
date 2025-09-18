import 'package:hive/hive.dart';
part 'add_to_cart_model.g.dart';

@HiveType(typeId: 0)
class AddToCartModel extends HiveObject{
  @HiveField(0)
  final int productId;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String image;

  @HiveField(3)
  final double price;

  @HiveField(4)
  int quantity;

  AddToCartModel({
    required this.productId,
    required this.name,
    required this.image,
    required this.price,
    this.quantity = 0,
  });

}