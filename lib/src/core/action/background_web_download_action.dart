import 'dart:js_interop';
import 'dart:typed_data';

import 'package:flutter_artist_core/flutter_artist_core.dart';
import 'package:web/web.dart' as web;

import 'base_background_action.dart';

abstract class BackgroundWebDownloadAction extends BackgroundAction {
  final String fileName;

  BackgroundWebDownloadAction({
    required this.fileName,
    required super.needToConfirm,
    required super.actionInfo,
  });

  Future<ApiResult<List<int>?>> callApiDownload();

  @override
  Future<ApiResult<void>> run() async {
    ApiResult<List<int>?> result = await callApiDownload();
    if (result.isError()) {
      return result;
    }
    List<int>? data = result.data;

    final JSArray<web.BlobPart> jsArray = JSArray();
    // Convert int to Uint8List (a common BlobPart type)
    jsArray.add(Uint8List.fromList(data ?? []).toJS as web.BlobPart);

    // Create a Blob from the received bytes
    final blob = web.Blob(jsArray);

    final url = web.URL.createObjectURL(blob);
    final anchor = web.HTMLAnchorElement()
      ..href = url
      ..setAttribute('download', fileName)
      ..click(); // Programmatically clicks the anchor to trigger download

    web.URL.revokeObjectURL(anchor.href!); // Clean up.
    return result;
  }
}
