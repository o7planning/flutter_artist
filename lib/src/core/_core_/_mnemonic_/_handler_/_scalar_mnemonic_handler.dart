part of '../../core.dart';

/// Handles keyboard [MnemonicShortcut] actions when focus resides inside a
/// [ScalarValueView].
class _ScalarMnemonicHandler {
  static KeyEventResult handleKeyEvent({
    required BuildContext context,
    required Scalar scalar,
    required KeyEvent event,
  }) {
    if (event is! KeyDownEvent) return KeyEventResult.ignored;

    final List<MnemonicScope> scopes = [
      if (scalar.filterModel != null) scalar.filterModel!,
      scalar,
    ];
    if (_MnemonicDispatcher.tryTriggerRegisteredControl(
      event,
      scopes: scopes,
    )) {
      return KeyEventResult.handled;
    }

    final MnemonicShortcut? shortcut =
        _MnemonicDispatcher.resolveShortcut(event);
    if (shortcut == null) {
      return KeyEventResult.ignored;
    }

    if (FlutterArtist.executor.isBusy) return KeyEventResult.handled;

    final bool handled = _executeScalarShortcut(
      context: context,
      scalar: scalar,
      shortcut: shortcut,
    );

    return handled ? KeyEventResult.handled : KeyEventResult.ignored;
  }

  static bool _executeScalarShortcut({
    required BuildContext context,
    required Scalar scalar,
    required MnemonicShortcut shortcut,
  }) {
    switch (shortcut) {
      case MnemonicShortcut.back:
        if (Navigator.of(context).canPop()) {
          Navigator.of(context).maybePop();
          return true;
        }
        return false;

      case MnemonicShortcut.query:
      case MnemonicShortcut.refresh:
        scalar.query();
        return true;

      case MnemonicShortcut.debugFilterCriteria:
        scalar.showDebugFilterCriteriaViewerDialog();
        return true;

      case MnemonicShortcut.debugFilterModel:
        scalar.showDebugFilterModelViewerDialog();
        return true;

      default:
        return false;
    }
  }
}
