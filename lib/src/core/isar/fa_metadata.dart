import 'package:flutter_artist_theme/flutter_artist_theme.dart';
import 'package:hive/hive.dart';

class FaMetadata {
  int? id;
  String userId;
  String? encryptedUserJson;
  String localeCode = 'en-US';
  DateTime lastUpdated = DateTime.now();
  bool isPremium = false;
  String themeName = FaThemeHub.defaultThemeName;

  FaMetadata({required this.userId});

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'themeName': themeName,
        'encryptedUserJson': encryptedUserJson,
        'localeCode': localeCode,
        'lastUpdated': lastUpdated.millisecondsSinceEpoch,
        'isPremium': isPremium,
      };

  void debugPrint() {
    print("----- FaMetadata ------");
    print(" - id: $id");
    print(" - userId: $userId");
    print(" - themeName: $themeName");
    print(" - localeCode: $localeCode");
    print(" - isPremium: $isPremium");
    print("----------------------\n");
  }

  @override
  String toString() {
    return "FaMetadata($id, $userId, $themeName, $localeCode)\n";
  }
}

class FaMetadataAdapter extends TypeAdapter<FaMetadata> {
  @override
  final int typeId = 1;

  @override
  FaMetadata read(BinaryReader reader) {
    final obj = FaMetadata(
      userId: reader.readString(),
    );
    obj.id = reader.read() as int?;
    obj.encryptedUserJson = reader.read() as String?;
    obj.localeCode = reader.readString();
    obj.themeName = reader.readString();
    obj.lastUpdated = DateTime.fromMillisecondsSinceEpoch(reader.readInt());
    obj.isPremium = reader.readBool();
    print("FaMetadataAdapter.read() themeName: ${obj.themeName}");

    return obj;
  }

  @override
  void write(BinaryWriter writer, FaMetadata obj) {
    writer.writeString(obj.userId);
    writer.write(obj.id);
    writer.write(obj.encryptedUserJson);
    writer.writeString(obj.localeCode);
    writer.writeString(obj.themeName);
    writer.writeInt(obj.lastUpdated.millisecondsSinceEpoch);
    writer.writeBool(obj.isPremium);
  }
}
