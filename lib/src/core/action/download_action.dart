import 'package:flutter_artist_core/flutter_artist_core.dart';

import '../enums/after_quick_action.dart';
import 'base_background_action.dart';
import 'base_action.dart';

abstract class DownloadAction extends BackgroundAction {
  DownloadAction({
    required super.needToConfirm,
    required super.actionInfo,
  });
}
