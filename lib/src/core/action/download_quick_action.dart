import 'package:flutter_artist_core/flutter_artist_core.dart';

import '../enums/after_quick_action.dart';
import 'base_async_action.dart';
import 'base_action.dart';

abstract class DownloadQuickAction extends BaseAsyncAction {
  DownloadQuickAction({
    required super.needToConfirm,
    required super.actionInfo,
  });
}
