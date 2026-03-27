import 'package:hive/hive.dart';

class FaNotificationMessage {
  int? id;
  String? messageId;
  late String receiverId;
  String? title;
  String? body;
  String? rawDataPayload;
  bool isRead = false;
  DateTime createdAt = DateTime.now();

  FaNotificationMessage({required this.receiverId});

  Map<String, dynamic> toJson() => {
        'id': id,
        'messageId': messageId,
        'receiverId': receiverId,
        'title': title,
        'body': body,
        'rawDataPayload': rawDataPayload,
        'isRead': isRead,
        'createdAt': createdAt.millisecondsSinceEpoch,
      };
}

class FaNotificationMessageAdapter extends TypeAdapter<FaNotificationMessage> {
  @override
  final int typeId = 0;

  @override
  FaNotificationMessage read(BinaryReader reader) {
    final obj = FaNotificationMessage(
      receiverId: reader.readString(),
    );

    obj.id = reader.read() as int?;
    obj.messageId = reader.read() as String?;
    obj.title = reader.read() as String?;
    obj.body = reader.read() as String?;
    obj.rawDataPayload = reader.read() as String?;
    obj.isRead = reader.readBool();
    obj.createdAt = DateTime.fromMillisecondsSinceEpoch(reader.readInt());

    return obj;
  }

  @override
  void write(BinaryWriter writer, FaNotificationMessage obj) {
    writer.write(obj.receiverId);
    writer.write(obj.id);
    writer.write(obj.messageId);
    writer.write(obj.title);
    writer.write(obj.body);
    writer.write(obj.rawDataPayload);
    writer.writeBool(obj.isRead);
    writer.writeInt(obj.createdAt.millisecondsSinceEpoch);
  }
}
