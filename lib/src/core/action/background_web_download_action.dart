import 'dart:typed_data';

import 'package:flutter_artist_core/flutter_artist_core.dart';

import '_background_action.dart';
import 'stub/download_helper.dart';
import 'stub/download_helper_stub.dart'
    if (dart.library.html) 'stub/download_helper_web.dart';

abstract class BackgroundWebDownloadAction extends BackgroundAction {
  final String fileName;
  final DownloadHelper _helper = DownloadHelperImpl();

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
    _helper.download(uint8List, fileName);
    return result;
  }
}
