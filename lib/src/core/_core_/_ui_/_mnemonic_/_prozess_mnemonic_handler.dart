part of '../../core.dart';

/// Handles keyboard [MnemonicShortcut] actions when focus resides inside a
/// [StageFormView] or [ProzessStageFormViewSwitcher].
class _ProzessMnemonicHandler {
  static KeyEventResult handleKeyEvent({
    required BuildContext context,
    required Prozess prozess,
    required ProzessScreenNavigationContext? screenNavigationContext,
    required KeyEvent event,
  }) {
    if (event is! KeyDownEvent) return KeyEventResult.ignored;

    final Stage? viewingStage = prozess.viewingStage;
    final List<MnemonicScope> scopes = [
      if (viewingStage?.formModel != null) viewingStage!.formModel!,
      prozess,
    ];
    if (_MnemonicDispatcher.tryTriggerRegisteredControl(
      event,
      scopes: scopes,
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

      case MnemonicShortcut.cancel:
        prozess.cancel();
        final NavigationIntent? intent =
            screenNavigationContext?.cancelNavigationIntent;
        if (intent != null) {
          prozess._processNavigationIntent(
            context,
            result: null,
            intent: intent,
          );
        } else if (Navigator.of(context).canPop()) {
          Navigator.of(context).maybePop();
        }
        return KeyEventResult.handled;

      case MnemonicShortcut.moveToPreviousStage:
        if (prozess.canMoveToPreviousStage()) {
          prozess.moveToPreviousStage();
          return KeyEventResult.handled;
        }
        return KeyEventResult.ignored;

      case MnemonicShortcut.moveToNextStage:
        if (prozess.canMoveToNextStage()) {
          prozess.moveToNextStage();
          return KeyEventResult.handled;
        }
        return KeyEventResult.ignored;

      case MnemonicShortcut.restartAll:
        prozess.restart();
        return KeyEventResult.handled;

      case MnemonicShortcut.restart:
      case MnemonicShortcut.refresh:
        if (prozess.checkBeforeViewingStageRestart().yes) {
          prozess.restartViewingStage();
          return KeyEventResult.handled;
        }
        return KeyEventResult.ignored;

      case MnemonicShortcut.submit:
      case MnemonicShortcut.save:
        if (!prozess.checkBeforeViewingStageSubmit(checkValidate: false).yes) {
          return KeyEventResult.ignored;
        }
        () async {
          final result = await prozess.submitViewingStage();
          final NavigationIntent? intent =
              screenNavigationContext?.submitViewingStageNavigationIntent;
          if (intent != null && context.mounted) {
            prozess._processNavigationIntent(
              context,
              result: result,
              intent: intent,
            );
          }
        }();
        return KeyEventResult.handled;

      case MnemonicShortcut.reset:
        final stageForm = prozess.viewingStage?.formModel;
        if (stageForm != null && stageForm.isDirty()) {
          stageForm.resetForm();
          return KeyEventResult.handled;
        }
        return KeyEventResult.ignored;

      case MnemonicShortcut.debugForm:
        if (prozess.checkBeforeShowFormInfo().yes) {
          prozess.showViewingStageFormModelInspectorDialog();
          return KeyEventResult.handled;
        }
        return KeyEventResult.ignored;

      case MnemonicShortcut.debugInspector:
        prozess.showDebugContextDataViewerDialog(context);
        return KeyEventResult.handled;

      default:
        return KeyEventResult.ignored;
    }
  }
}
