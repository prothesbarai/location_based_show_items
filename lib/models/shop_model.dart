class ShopModel {
  final int id;
  final String name;
  final String? userImage;
  final double lat;
  final double lng;
  final double deliveryRange;
  final String description;
  final String phone;
  final double? rating;
  final String openingHours;
  final bool? isOpen;

  ShopModel({
    required this.id,
    required this.name,
    this.userImage,
    required this.lat,
    required this.lng,
    required this.deliveryRange,
    required this.description,
    required this.phone,
    this.rating,
    required this.openingHours,
    this.isOpen,
  });

  factory ShopModel.fromJson(Map<String,dynamic> json){
    return ShopModel(
        id: json['id'],
        name: json['name'],
        userImage: json['userImage'],
        lat: (json['lat'] as num).toDouble(),
        lng: (json['lng'] as num).toDouble(),
        deliveryRange: (json['deliveryRange'] as num).toDouble(),
        description: json['description'],
        phone: json['phone'],
        rating: (json['rating']as num).toDouble(),
        openingHours: json['openingHours'],
        isOpen: json['isOpen'],
    );
  }

}