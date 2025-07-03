part of '../../flutter_artist.dart';

// Future<void> _initBoxCollection() async {
//   // Create a box collection
//   final collection = await BoxCollection.open(
//     '_flutter_artist_datablocks_database_', // Name of your database
//     {'cats', 'dogs'}, // Names of your boxes
//     path:
//         './', // Path where to store your boxes (Only used in Flutter / Dart IO)
//     key:
//         HiveCipher(), // Key to encrypt your boxes (Only used in Flutter / Dart IO)
//   );
// }
class _HiveUtils {
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
