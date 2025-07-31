import 'base_background_action.dart';

abstract class BackgroundDownloadAction extends BackgroundAction {
  BackgroundDownloadAction({
    required super.needToConfirm,
    required super.actionInfo,
  });
}
