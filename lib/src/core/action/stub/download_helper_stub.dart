import 'dart:typed_data';

import 'download_helper.dart';

class DownloadHelperImpl implements DownloadHelper {
  @override
  Future<void> download(Uint8List data, String fileName) async {
    throw UnsupportedError('Download not supported on this platform');
  }
}
