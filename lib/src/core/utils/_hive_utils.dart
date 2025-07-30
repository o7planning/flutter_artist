import 'package:hive/hive.dart';

class HiveUtils {
  static Future<Box<DateTime>> openHiveBoxDateTime() async {
    var box =
        await Hive.openBox<DateTime>('_flutter_artist_hive_box_datetime_');
    return box;
  }

  static Future<Box<String>> openHiveBoxNotification() async {
    var box =
        await Hive.openBox<String>('_flutter_artist_hive_notification_box_');
    return box;
  }

  static Future<Box<String>> openHiveBoxLoggedInUser() async {
    var box =
        await Hive.openBox<String>('_flutter_artist_hive_logged_in_user_box_');
    return box;
  }

  static Future<Box<String>> openHiveBoxExtraGlobalPropNames() async {
    var box = await Hive.openBox<String>(
        '_flutter_artist_hive_extra_global_prop_names_box_');
    return box;
  }

  static Future<Box<dynamic>> openHiveBoxExtraGlobalProp() async {
    var box = await Hive.openBox<dynamic>(
        '_flutter_artist_hive_extra_global_prop_box_');
    return box;
  }
}
