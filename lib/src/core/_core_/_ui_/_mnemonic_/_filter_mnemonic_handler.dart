part of '../../core.dart';

/// Handles keyboard [MnemonicShortcut] actions when focus resides inside a [FilterPanel].
class _FilterMnemonicHandler {
  static KeyEventResult handleKeyEvent({
    required BuildContext context,
    required FilterModel filterModel,
    required FilterScreenNavigationContext? screenNavigationContext,
    required KeyEvent event,
  }) {
    if (event is! KeyDownEvent) return KeyEventResult.ignored;

    if (_MnemonicDispatcher.tryTriggerRegisteredControl(
      event,
      scopes: [filterModel],
    )) {
      return KeyEventResult.handled;
    }

    final MnemonicShortcut? shortcut =
        _MnemonicDispatcher.resolveShortcut(event);
    if (shortcut == null) return KeyEventResult.ignored;

    if (FlutterArtist.executor.isBusy) return KeyEventResult.handled;

    switch (shortcut) {
      case MnemonicShortcut.back:
        if (Navigator.of(context).canPop()) {
          Navigator.of(context).maybePop();
          return KeyEventResult.handled;
        }
        return KeyEventResult.ignored;

      case MnemonicShortcut.debugFilter:
        DebugViewerDialog.openDebugFilterModelInspector(
          context: context,
          locationInfo: '',
          filterModel: filterModel,
        );
        return KeyEventResult.handled;

      default:
        return KeyEventResult.ignored;
    }
  }
}
