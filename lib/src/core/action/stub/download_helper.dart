import 'dart:typed_data';

abstract interface class DownloadHelper {
  Future<void> download(Uint8List data, String fileName);
}
