part of '../../core.dart';

/// Handles keyboard [MnemonicShortcut] actions when focus resides inside a
/// [BlockItemsView] or [BlockFormView].
class _BlockMnemonicHandler {
  static KeyEventResult handleKeyEvent({
    required BuildContext context,
    required Block block,
    required BlockScreenNavigationContext? screenNavigationContext,
    required KeyEvent event,
  }) {
    if (event is! KeyDownEvent) return KeyEventResult.ignored;

    final List<MnemonicScope> scopes = [
      if (block.formModel != null) block.formModel!,
      block,
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

    final bool isDataNav = DataGridNavigationUtils.handleBlockDataNavigation(
      context: context,
      block: block,
      shortcut: shortcut,
    );
    if (isDataNav) return KeyEventResult.handled;

    final bool handled = _executeBlockShortcut(
      context: context,
      block: block,
      screenNavigationContext: screenNavigationContext,
      shortcut: shortcut,
    );

    return handled ? KeyEventResult.handled : KeyEventResult.ignored;
  }

  static bool _executeBlockShortcut({
    required BuildContext context,
    required Block block,
    required BlockScreenNavigationContext? screenNavigationContext,
    required MnemonicShortcut shortcut,
  }) {
    switch (shortcut) {
      case MnemonicShortcut.back:
        if (Navigator.of(context).canPop()) {
          Navigator.of(context).maybePop();
          return true;
        }
        return false;

      case MnemonicShortcut.create:
        () async {
          final result = await block.prepareFormToCreateItem();
          final NavigationIntent? intent =
              screenNavigationContext?.createNavigationIntent;
          if (intent != null && context.mounted) {
            block._processNavigationIntent(
              context,
              result: result,
              intent: intent,
            );
          }
        }();
        return true;

      case MnemonicShortcut.edit:
        () async {
          final result = await block.prepareFormToEditCurrentItem();
          final NavigationIntent? intent =
              screenNavigationContext?.editNavigationIntent;
          if (intent != null && context.mounted) {
            block._processNavigationIntent(
              context,
              result: result,
              intent: intent,
            );
          }
        }();
        return true;

      case MnemonicShortcut.delete:
        () async {
          final result = await block.deleteCurrentItem();
          final NavigationIntent? intent =
              screenNavigationContext?.deleteNavigationIntent;
          if (intent != null && context.mounted) {
            block._processNavigationIntent(
              context,
              result: result,
              intent: intent,
            );
          }
        }();
        return true;

      case MnemonicShortcut.save:
        () async {
          final result = await block.saveForm();
          final NavigationIntent? intent =
              screenNavigationContext?.saveNavigationIntent;
          if (intent != null && context.mounted) {
            block._processNavigationIntent(
              context,
              result: result,
              intent: intent,
            );
          }
        }();
        return true;

      case MnemonicShortcut.refresh:
        block.refreshCurrentItem();
        return true;

      case MnemonicShortcut.reset:
        block.resetForm();
        return true;

      case MnemonicShortcut.query:
        block.query();
        return true;

      case MnemonicShortcut.debugFilterCriteria:
        block.showDebugFilterCriteriaInspector();
        return true;

      case MnemonicShortcut.debugFilterModel:
        block.showDebugFilterModelInspector();
        return true;

      case MnemonicShortcut.debugFormModel:
        block.showDebugFormModelInspector();
        return true;

      default:
        return false;
    }
  }
}
