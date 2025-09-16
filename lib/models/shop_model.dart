class ShopModel {
  final int id;
  final String name;
  final double lat;
  final double lng;
  final double deliveryRange;

  ShopModel({
    required this.id,
    required this.name,
    required this.lat,
    required this.lng,
    required this.deliveryRange,
  });

  factory ShopModel.fromJson(Map<String,dynamic> json){
    return ShopModel(
        id: json['id'],
        name: json['name'],
        lat: (json['lat'] as num).toDouble(),
        lng: (json['lng'] as num).toDouble(),
        deliveryRange: (json['deliveryRange'] as num).toDouble(),
    );
  }

}