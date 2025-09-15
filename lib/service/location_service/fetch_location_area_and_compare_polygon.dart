import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:turf/along.dart' as turf;
import 'package:turf/boolean.dart' hide Position;
import '../../provider/location_provider.dart';
import 'map_polygon_list.dart';



class FetchLocationAreaAndComparePolygon {
  static Future<void> fetchLocation(BuildContext context) async{
    final provider = Provider.of<LocationProvider>(context, listen: false);
    try{
      Position position = await Geolocator.getCurrentPosition(locationSettings: LocationSettings(accuracy: LocationAccuracy.high,distanceFilter: 0));

      final userPosition = turf.Position(position.longitude, position.latitude);
      // final userPosition = turf.Position(90.373453,23.748220);
      final locationInfo = getLocationInfo(userPosition);

      final name = locationInfo["name"];
      final id = locationInfo["locationId"] as int;

      provider.setLocation({
        'name' : name,
        'id' : id,
      });

    }catch(e){
      debugPrint("Error fetching location: $e");
    }
  }

}




Map<String,dynamic> getLocationInfo(turf.Position userPosition){

  final polygons = [
    {"name": "Mirpur", "locationId" : 1, "polygon": mirpurPolygon},
    {"name": "Badda", "locationId" : 4, "polygon": baddaPolygon},
    {"name": "Dhanmondi", "locationId" : 8, "polygon": dhanmondiPolygon},
    {"name": "Banasree & Rampura", "locationId" : 14, "polygon": banasreeRampuraPolygon},
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