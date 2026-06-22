import 'dart:js_interop';
import 'dart:typed_data';

import 'package:web/web.dart' as web;

import 'download_helper.dart';

class DownloadHelperImpl implements DownloadHelper {
  @override
  Future<void> download(Uint8List? data, String fileName) async {
    Uint8List uint8List = Uint8List.fromList(data ?? []);
    final dataBuffer = uint8List.buffer.toJS;

    web.Blob blobData = web.Blob(
      [dataBuffer].toJS,
      web.BlobPropertyBag(type: 'application/octet-stream'),
    );

    final url = web.URL.createObjectURL(blobData);
    final anchor = web.HTMLAnchorElement()
      ..href = url
      ..setAttribute('download', fileName)
      // Programmatically clicks the anchor to trigger download
      ..click();

    web.URL.revokeObjectURL(anchor.href);
  }
}
