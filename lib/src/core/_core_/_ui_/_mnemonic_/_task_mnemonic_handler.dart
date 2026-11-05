part of '../../core.dart';

/// Handles keyboard [MnemonicShortcut] actions when focus resides inside a
/// [TaskFormView] or [TaskView].
class _TaskMnemonicHandler {
  static KeyEventResult handleKeyEvent({
    required BuildContext context,
    required Task task,
    required TaskScreenNavigationContext? screenNavigationContext,
    required KeyEvent event,
  }) {
    if (event is! KeyDownEvent) return KeyEventResult.ignored;

    final List<MnemonicScope> scopes = [
      if (task.formModel != null) task.formModel!,
      task,
    ];
    if (_MnemonicDispatcher.tryTriggerRegisteredControl(event,
        scopes: scopes)) {
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

      case MnemonicShortcut.submit:
      case MnemonicShortcut.save:
        final actionable = task.checkBeforeSubmit(
          checkAllow: true,
          checkValidate: false,
        );
        if (!actionable.yes) return KeyEventResult.ignored;

        () async {
          final result = await task.submit();
          final NavigationIntent? intent =
              screenNavigationContext?.submitNavigationIntent;
          if (intent != null && context.mounted) {
            task._processNavigationIntent(
              context,
              result: result,
              intent: intent,
            );
          }
        }();
        return KeyEventResult.handled;

      case MnemonicShortcut.restart:
      case MnemonicShortcut.refresh:
        final actionable = task.checkBeforeRestart(checkAllow: true);
        if (!actionable.yes) return KeyEventResult.ignored;

        () async {
          final result = await task.restart();
          final NavigationIntent? intent =
              screenNavigationContext?.restartNavigationIntent;
          if (intent != null && context.mounted) {
            task._processNavigationIntent(
              context,
              result: result,
              intent: intent,
            );
          }
        }();
        return KeyEventResult.handled;

      case MnemonicShortcut.reset:
        if (task.formModel != null && task.formModel!.isDirty()) {
          task.formModel!.resetForm();
          return KeyEventResult.handled;
        }
        return KeyEventResult.ignored;

      case MnemonicShortcut.debugForm:
        if (task.checkBeforeShowFormInfo().yes) {
          task.showDebugFormModelInspectorDialog();
          return KeyEventResult.handled;
        }
        return KeyEventResult.ignored;

      default:
        return KeyEventResult.ignored;
    }
  }
}
