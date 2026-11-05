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
    print("\n\n\n KEY-EVENT: $event");

    final List<MnemonicScope> scopes = [
      if (block.formModel != null) block.formModel!,
      block,
    ];
    if (_MnemonicDispatcher.tryTriggerRegisteredControl(event,
        scopes: scopes)) {
      print("  1 ---> handled");
      return KeyEventResult.handled;
    }

    final MnemonicShortcut? shortcut =
        _MnemonicDispatcher.resolveShortcut(event);
    if (shortcut == null) {
      print("  2 ---> ignored");
      return KeyEventResult.ignored;
    }

    print("  3 ---> check busy");
    if (FlutterArtist.executor.isBusy) return KeyEventResult.handled;
    print("  4 ---> check busy");

    final bool isDataNav = DataGridNavigationUtils.handleBlockDataNavigation(
      context: context,
      block: block,
      shortcut: shortcut,
    );
    if (isDataNav) return KeyEventResult.handled;

    // Nếu không phải phím Data Navigation thì chạy tiếp logic CRUD cũ (Create, Edit, Save...)
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
        if (block.formModel == null) return false;
        final actionable = block.checkBeforeCreateItemWithForm();
        if (!actionable.yes) return false;

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
        if (block.formModel == null) return false;
        final actionable = block.checkBeforeEditCurrentItemWithForm();
        if (!actionable.yes) return false;

        () async {
          final result = await block._prepareFormToEditCurrentItem();
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
        final actionable = block.checkBeforeDeleteCurrentItem();
        if (!actionable.yes) return false;

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
        if (block.formModel == null) return false;
        final actionable = block.checkBeforeSaveForm(
          checkAllow: true,
          checkValidate: false,
        );
        if (!actionable.yes) return false;

        () async {
          final result = await block.formModel!.saveForm();
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
        final actionable = block.checkBeforeRefreshCurrentItem();
        if (!actionable.yes) return false;
        block.refreshCurrentItem();
        return true;

      case MnemonicShortcut.reset:
        if (block.formModel == null) return false;
        final actionable = block.checkBeforeResetForm();
        if (!actionable.yes) return false;
        block.formModel!.resetForm();
        return true;

      case MnemonicShortcut.query:
        final actionable = block.checkBeforeQuery();
        if (!actionable.yes) return false;
        block.query();
        return true;

      case MnemonicShortcut.debugFilter:
        if (!block.canShowFilterCriteria()) return false;
        DebugViewerDialog.openDebugFilterCriteriaInspector(
          context: context,
          locationInfo: '',
          filterModel: block.registeredOrDefaultFilterModel,
        );
        return true;

      case MnemonicShortcut.debugForm:
        if (!block.checkBeforeShowFormInfo().yes) return false;
        block.showDebugFormModelInspectorDialog();
        return true;

      default:
        return false;
    }
  }
}
