import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:turf/along.dart' as turf;
import 'package:turf/boolean.dart' hide Position;
import 'map_polygon_list.dart';



class FetchLocationAreaAndComparePolygon {
  static Future<void> fetchLocation(BuildContext context) async{
    try{
      Position position = await Geolocator.getCurrentPosition(locationSettings: LocationSettings(accuracy: LocationAccuracy.high,distanceFilter: 0));

      final userPosition = turf.Position(position.longitude, position.latitude);
      // final userPosition = turf.Position(90.373453,23.748220);
      final locationInfo = getLocationInfo(userPosition);

      final name = locationInfo["name"];
      final id = locationInfo["locationId"] as int;



    }catch(e){
      debugPrint("Error fetching location: $e");
    }
  }

}




Map<String,dynamic> getLocationInfo(turf.Position userPosition){

  final polygons = [
    {"name": "Mirpur", "locationId" : 1, "polygon": mirpurPolygon},
    {"name": "Wari & Gopibagh", "locationId" : 2, "polygon": wariGopiBaghPolygon},
    {"name": "Uttara & Khilkhet", "locationId" : 3, "polygon": uttaraPolygon},
    {"name": "Badda", "locationId" : 4, "polygon": baddaPolygon},
    {"name": "Dhanmondi", "locationId" : 8, "polygon": dhanmondiPolygon},
    {"name": "Gulshan, Banani, Mohakhali", "locationId" : 9, "polygon": gulshanBananiPolygon},
    {"name": "Khilgoan & Basabo", "locationId" : 10, "polygon": khilgoanBasaboPolygon},
    {"name": "Baridhara & Bashundhara", "locationId" : 11, "polygon": baridharaBashundharaPolygon},
    {"name": "Moghbazar & Palton", "locationId" : 12, "polygon": moghBazarPoltonPolygon},
    {"name": "Banasree & Rampura", "locationId" : 14, "polygon": banasreeRampurPolygon},
    {"name": "Mohammadpur", "locationId" : 15, "polygon": mohammadPurPolygon},
  ];

  for (final items in polygons) {
    final String name = items["name"] as String;
    final int locationId = items["locationId"] as int;
    final turf.GeoJSONObject polygon = items["polygon"] as turf.GeoJSONObject;

    if (booleanPointInPolygon(userPosition, polygon)) {
      return {"name": name, "locationId": locationId,};
    }

  }

  return {"name": "Outside Dhaka Metro", "locationId": 13,};

}