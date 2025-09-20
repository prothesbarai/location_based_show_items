class ShopModel {
  final int id;
  final String? name;
  final String? userImage;
  final double? lat;
  final double? lng;
  final double? deliveryRange;
  final String? description;
  final String? phone;
  final double? rating;
  final String? openingHours;
  final bool? isOpen;
  final List<ProductModel> products;

  ShopModel({
    required this.id,
    this.name,
    this.userImage,
    this.lat,
    this.lng,
    this.deliveryRange,
    this.description,
    this.phone,
    this.rating,
    this.openingHours,
    this.isOpen,
    required this.products,
  });

  factory ShopModel.fromJson(Map<String,dynamic> json){
    return ShopModel(
        id: json['id'],
      name: json['name'] as String? ?? '',
      userImage: json['userImage'] as String? ?? '',
      lat: (json['lat'] != null) ? (json['lat'] as num).toDouble() : 0.0,
      lng: (json['lng'] != null) ? (json['lng'] as num).toDouble() : 0.0,
      deliveryRange: (json['deliveryRange'] != null) ? (json['deliveryRange'] as num).toDouble() : 0.0,
      description: json['description'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      rating: (json['rating'] != null) ? (json['rating'] as num).toDouble() : 0.0,
      openingHours: json['openingHours'] as String? ?? '',
      isOpen: json['isOpen'] as bool? ?? false,
      products: (json['products'] != null && json['products'] is List) ? (json['products'] as List).map((e) => ProductModel.fromJson(e)).toList() : [],
    );
  }

}




class ProductModel {
  final int id;
  final String name;
  final double price;
  final String category;
  final int stock;
  final String image;

  ProductModel({
    required this.id,
    required this.name,
    required this.price,
    required this.category,
    required this.stock,
    required this.image,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      name: json['name'],
      price: (json['price'] as num).toDouble(),
      category: json['category'],
      stock: json['stock'],
      image: json['image'],
    );
  }
}
