part of '../flutter_artist.dart';

// Future<void> _initBoxCollection() async {
//   // Create a box collection
//   final collection = await BoxCollection.open(
//     '_flu_datablocks_database_', // Name of your database
//     {'cats', 'dogs'}, // Names of your boxes
//     path:
//         './', // Path where to store your boxes (Only used in Flutter / Dart IO)
//     key:
//         HiveCipher(), // Key to encrypt your boxes (Only used in Flutter / Dart IO)
//   );
// }

Future<Box<DateTime>> _openHiveBoxDateTime() async {
  var box = await Hive.openBox<DateTime>('_flu_hive_box_datetime_');
  return box;
}

Future<Box<String>> _openHiveBoxNotification() async {
  var box = await Hive.openBox<String>('_flu_hive_notification_box_');
  return box;
}

Future<Box<String>> _openHiveBoxLoggedInUser() async {
  var box = await Hive.openBox<String>('_flu_hive_logged_in_user_box_');
  return box;
}
