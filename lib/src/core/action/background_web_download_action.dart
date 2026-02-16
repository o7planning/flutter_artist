import 'dart:js_interop';
import 'dart:typed_data';

import 'package:flutter_artist_core/flutter_artist_core.dart';
import 'package:web/web.dart' as web;

import '_background_action.dart';

abstract class BackgroundWebDownloadAction extends BackgroundAction {
  final String fileName;

  BackgroundWebDownloadAction({
    required this.fileName,
    required super.needToConfirm,
    required super.actionInfo,
  });

  Future<ApiResult<List<int>?>> performDownload();

  @override
  Future<ApiResult<void>> run() async {
    ApiResult<List<int>?> result = await performDownload();
    if (result.isError()) {
      return result;
    }
    List<int>? data = result.data;

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

    web.URL.revokeObjectURL(anchor.href); // Clean up.
    return result;
  }
}
