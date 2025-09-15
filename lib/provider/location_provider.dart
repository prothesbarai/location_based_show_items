import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';

class LocationProvider with ChangeNotifier{
  final Box _box = Hive.box('LocationBox');
  
  bool get isFirstTime => _box.get('check_hive', defaultValue: true);
  String get permissionFlag => _box.get('permission_flag', defaultValue: 'denied');


  Future<void> setFirstTime(bool value) async {
    await _box.put('check_hive', value);
    notifyListeners();
  }


  Future<void> setPermissionFlag(String flag) async {
    await _box.put('permission_flag', flag);
    notifyListeners();
  }


}