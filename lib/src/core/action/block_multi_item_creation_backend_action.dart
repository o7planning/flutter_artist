import 'package:flutter_artist_core/flutter_artist_core.dart';

import '_action.dart';

@Deprecated("TODO: Delete")
abstract class BlockMultiItemCreationBackendAction<ID extends Object>
    extends Action {
  const BlockMultiItemCreationBackendAction({
    required super.needToConfirm,
    required super.actionInfo,
  });

  Future<ApiResult<ListData<ID>>> performCreateMultiItems({
    required Object? parentBlockItem,
  });
}
