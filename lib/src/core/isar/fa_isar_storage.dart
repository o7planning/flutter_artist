import 'dart:io';

import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

import '_fake_isar.dart';
import 'fa_metadata.dart';
import 'fa_notification_message.dart';

class FaIsarStorage {
  static late FakeIsar _isar;

  static final _key = encrypt.Key.fromUtf8(
      'my_super_secret_artist_key_32ch'.padRight(32).substring(0, 32));
  static final _iv = encrypt.IV.fromLength(16);

  static final _encrypter = encrypt.Encrypter(
    encrypt.AES(_key, mode: encrypt.AESMode.sic, padding: null),
  );

  static String _encrypt(String plainText) {
    return plainText;
  }

  static String? _safeDecrypt(String cipherText) {
    return cipherText;
  }

  static Future<String?> getDecryptedUserJson(String userId) async {
    final metadata = await getSettings(userId);

    final rawEncrypted = metadata?.encryptedUserJson;

    if (rawEncrypted == null || rawEncrypted.isEmpty) {
      return null;
    }

    final decrypted = _safeDecrypt(rawEncrypted);

    if (decrypted == null) {
      await removeUser(userId);
      return null;
    }

    return decrypted;
  }

  /// Initialize FakeIsar with platform-specific directory
  static Future<void> init() async {
    String dir = '';

    if (!kIsWeb) {
      final directory = await getApplicationDocumentsDirectory();
      final isarDir = Directory('${directory.path}/flutter_artist_db');
      if (!await isarDir.exists()) {
        await isarDir.create(recursive: true);
      }
      dir = isarDir.path;
      Hive.init(dir);
    }

    _isar = await FakeIsar.open(
      directory: dir,
    );

    _isar
        .collection<FaMetadata>()
        .createIndex('userId', (m) => m.userId, unique: true);

    _isar
        .collection<FaNotificationMessage>()
        .createIndex('messageId', (m) => m.messageId, unique: true);
  }

  // --- USER MANAGEMENT (Login/Logout/Metadata) ---

  static Future<FaMetadata?> getLatestMetadata() async {
    return await _isar
        .collection<FaMetadata>()
        .filter()
        .sortBy((m) => m.lastUpdated, desc: true)
        .findFirst();
  }

  static Future<void> removeUser(String userId) async {
    final metaCol = _isar.collection<FaMetadata>();
    final msgCol = _isar.collection<FaNotificationMessage>();

    await _isar.writeTxn(() async {
      final meta =
          await metaCol.filter().where((m) => m.userId == userId).findFirst();
      if (meta != null) await metaCol.delete(meta.id);

      final messages =
          await msgCol.filter().where((m) => m.receiverId == userId).findAll();
      for (var msg in messages) {
        await msgCol.delete(msg.id);
      }
    });
  }

  // --- USER MANAGEMENT ---

  static Future<void> saveSettings({
    required String userId,
    String? locale,
    String? themeName,
    String? userJson,
  }) async {
    final col = _isar.collection<FaMetadata>();
    var current = await col
        .filter()
        .where((m) => m.userId == userId)
        .sortBy((m) => m.lastUpdated, desc: true)
        .findFirst();
    if (current == null) {
      print("### Create default FaMetadata($userId)");
      current = FaMetadata(userId: userId);
    }

    if (locale != null) current.localeCode = locale;
    if (themeName != null) current.themeName = themeName;
    if (userJson != null) {
      current.encryptedUserJson = _encrypt(userJson);
    }
    current.lastUpdated = DateTime.now();
    current.debugPrint();
    await _isar.writeTxn(() => col.put(current!));
  }

  static Future<FaMetadata?> getSettings(String userId) async {
    return await _isar
        .collection<FaMetadata>()
        .filter()
        .where((m) => m.userId == userId)
        .findFirst();
  }

  // --- CAPACITY MANAGEMENT ---

  /// Remove notifications older than [daysOld]
  static Future<int> cleanOldMessages({int daysOld = 30}) async {
    final deathLine = DateTime.now().subtract(Duration(days: daysOld));
    final col = _isar.collection<FaNotificationMessage>();

    final targets = await col
        .filter()
        .where((m) => m.createdAt.isBefore(deathLine))
        .findAll();

    await _isar
        .writeTxn(() => col.deleteAll(targets.map((e) => e.id).toList()));
    return targets.length;
  }

  // --- NOTIFICATION MESSAGES ---

  static Future<void> saveNotificationMessage(FaNotificationMessage msg) async {
    await _isar
        .writeTxn(() => _isar.collection<FaNotificationMessage>().put(msg));
  }

  static Future<List<FaNotificationMessage>> getMessagesForUser(String userId) {
    return _isar
        .collection<FaNotificationMessage>()
        .filter()
        .where((m) => m.receiverId == userId)
        .sortBy((m) => m.createdAt, desc: true)
        .findAll();
  }
}
