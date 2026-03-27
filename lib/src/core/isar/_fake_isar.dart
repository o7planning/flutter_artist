import 'package:hive/hive.dart';

import '_fake_collection.dart';
import 'fa_metadata.dart';
import 'fa_notification_message.dart';

class FakeIsar {
  final Map<Type, dynamic> _collections = {};

  static Future<FakeIsar> open({
    required String directory,
  }) async {
    final isar = FakeIsar();
    Hive.registerAdapter(FaNotificationMessageAdapter());
    Hive.registerAdapter(FaMetadataAdapter());
    //
    await isar._initCollection<FaMetadata>('__fa_metadata__');
    await isar._initCollection<FaNotificationMessage>('__fa_messages__');
    return isar;
  }

  Future<void> _initCollection<T>(String boxName) async {
    final box = await Hive.openBox<T>(boxName);
    _collections[T] = FakeCollection<T>(box);
  }

  FakeCollection<T> collection<T>() {
    return _collections[T] as FakeCollection<T>;
  }

  Future<T> writeTxn<T>(Future<T> Function() callback) async {
    return await callback();
  }
}
