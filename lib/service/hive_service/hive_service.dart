import 'package:hive/hive.dart';
import 'package:location_based_show_items/models/hive_model/add_to_cart_model.dart';
import 'package:path_provider/path_provider.dart';

class HiveService {

  static Future<void> initHive() async{
    var dir = await getApplicationDocumentsDirectory();
    Hive.init(dir.path);
    Hive.registerAdapter(AddToCartModelAdapter());

    await Future.wait([
      Hive.openBox('LocationBox'),
      Hive.openBox<AddToCartModel>('CartBox'),
    ]);

  }

}