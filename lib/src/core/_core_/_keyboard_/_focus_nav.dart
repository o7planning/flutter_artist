part of '../core.dart';

/// Defines the types of focus navigation actions when pressing the TAB key.
enum FocusNavType {
  /// Lets Flutter's default focus traversal handle moving to the next widget.
  moveNext,

  /// Jumps directly to a specific target field specified by [FocusNavAction.targetName].
  moveTo,

  /// Keeps focus on the current field and consumes the TAB key event silently.
  stay,

  /// Rejects leaving the current field, keeps focus, and optionally displays a message.
  reject,
}

// *****************************************************************************

/// Represents the focus navigation decision returned by `resolveNextFocus`.
class FocusNavAction {
  final FocusNavType type;
  final String? targetName;
  final String? message;

  const FocusNavAction._({
    required this.type,
    this.targetName,
    this.message,
  });

  /// Follows standard Flutter TAB focus traversal.
  factory FocusNavAction.moveNext() =>
      const FocusNavAction._(type: FocusNavType.moveNext);

  /// Jumps directly to [targetName] (`propName` in Form, or `tildeCriterionName` in Filter).
  factory FocusNavAction.moveTo(String targetName) {
    assert(targetName.trim().isNotEmpty, 'targetName must not be empty.');
    return FocusNavAction._(
      type: FocusNavType.moveTo,
      targetName: targetName,
    );
  }

  /// Keeps focus at the current field silently.
  factory FocusNavAction.stay() =>
      const FocusNavAction._(type: FocusNavType.stay);

  /// Rejects moving to the next field and optionally displays a [message].
  factory FocusNavAction.reject([String? message]) =>
      FocusNavAction._(type: FocusNavType.reject, message: message);

  @override
  String toString() {
    return 'FocusNavAction(type: $type, targetName: $targetName, message: $message)';
  }
}

// *****************************************************************************

/// Internal signatures used by [_FocusNavDispatcher] to decouple FormModel and FilterModel.
typedef _FallbackValueGetter = dynamic Function(String targetName);

typedef _NextFocusResolver = FocusNavAction? Function({
required String currentFocusTargetName,
required dynamic currentValue,
required bool isCurrentFieldValid,
});

// *****************************************************************************

/// Central dispatcher that intercepts TAB key events on FormView and FilterPanel
/// and executes custom focus navigation rules.
class _FocusNavDispatcher {
  /// Entry point for [BaseFormViewBuilder].
  static KeyEventResult handleFormKeyEvent({
    required FocusNode node,
    required KeyEvent event,
    required BaseFormModel formModel,
    required FormBuilderState? formState,
  }) {
    return _handleKeyEventCommon(
      node: node,
      event: event,
      formState: formState,
      getFallbackValue: (propName) => formModel.getPropValue(propName),
      resolveNextFocus: ({
        required String currentFocusTargetName,
        required dynamic currentValue,
        required bool isCurrentFieldValid,
      }) {
        return formModel.resolveNextFocus(
          currentPropName: currentFocusTargetName,
          currentValue: currentValue,
          isCurrentFieldValid: isCurrentFieldValid,
        );
      },
    );
  }

  /// Entry point for [FilterPanelBuilder].
  static KeyEventResult handleFilterKeyEvent({
    required FocusNode node,
    required KeyEvent event,
    required FilterModel filterModel,
    required FormBuilderState? formState,
  }) {
    return _handleKeyEventCommon(
      node: node,
      event: event,
      formState: formState,
      getFallbackValue: (tildeCriterionName) =>
          filterModel.getTildeCriterionValue(tildeCriterionName),
      resolveNextFocus: ({
        required String currentFocusTargetName,
        required dynamic currentValue,
        required bool isCurrentFieldValid,
      }) {
        return filterModel.resolveNextFocus(
          currentTildeCriterionName: currentFocusTargetName,
          currentValue: currentValue,
          isCurrentFieldValid: isCurrentFieldValid,
        );
      },
    );
  }

  static KeyEventResult _handleKeyEventCommon({
    required FocusNode node,
    required KeyEvent event,
    required FormBuilderState? formState,
    required _FallbackValueGetter getFallbackValue,
    required _NextFocusResolver resolveNextFocus,
  }) {
    if (formState == null) {
      return KeyEventResult.ignored;
    }

    if ((event is KeyDownEvent || event is KeyRepeatEvent) &&
        event.logicalKey == LogicalKeyboardKey.tab) {
      // Allow Shift + TAB to perform standard backward focus traversal.
      if (HardwareKeyboard.instance.isShiftPressed) {
        return KeyEventResult.ignored;
      }

      final String? currentFocusTargetName = _resolveActiveTargetName(formState);
      if (currentFocusTargetName == null) {
        return KeyEventResult.ignored;
      }

      final bool handled = _dispatchFocusFlow(
        formState: formState,
        currentFocusTargetName: currentFocusTargetName,
        getFallbackValue: getFallbackValue,
        resolveNextFocus: resolveNextFocus,
      );

      return handled ? KeyEventResult.handled : KeyEventResult.ignored;
    }
    return KeyEventResult.ignored;
  }

  /// Identifies which FormBuilderField currently owns the primary focus.
  static String? _resolveActiveTargetName(FormBuilderState formState) {
    final FocusNode? primaryFocus = FocusManager.instance.primaryFocus;
    if (primaryFocus == null) return null;

    for (final entry in formState.fields.entries) {
      final String targetName = entry.key;
      final fieldState = entry.value;
      if (!fieldState.mounted) continue;

      final FocusNode fieldNode = fieldState.effectiveFocusNode;

      // 1. Direct focus match
      if (fieldNode == primaryFocus || fieldNode.hasFocus) {
        return targetName;
      }

      // 2. Subtree match (for composite fields that create internal FocusNodes)
      final BuildContext? focusContext = primaryFocus.context;
      if (focusContext != null) {
        bool isInsideField = false;
        focusContext.visitAncestorElements((ancestor) {
          if (ancestor == fieldState.context) {
            isInsideField = true;
            return false;
          }
          return true;
        });
        if (isInsideField) {
          return targetName;
        }
      }
    }
    return null;
  }

  /// Executes custom focus navigation and automatically hops over disabled/unmounted
  /// target fields if chained rules are defined in `resolveNextFocus`.
  static bool _dispatchFocusFlow({
    required FormBuilderState formState,
    required String currentFocusTargetName,
    required _FallbackValueGetter getFallbackValue,
    required _NextFocusResolver resolveNextFocus,
  }) {
    final Set<String> visitedTargets = {currentFocusTargetName};
    String inspectingFocusTargetName = currentFocusTargetName;

    while (true) {
      final inspectingFieldState = formState.fields[inspectingFocusTargetName];
      final currentValue =
          formState.instantValue[inspectingFocusTargetName] ??
              getFallbackValue(inspectingFocusTargetName);
      final bool isCurrentFieldValid = inspectingFieldState?.isValid ?? true;

      final FocusNavAction? action = resolveNextFocus(
        currentFocusTargetName: inspectingFocusTargetName,
        currentValue: currentValue,
        isCurrentFieldValid: isCurrentFieldValid,
      );

      if (action == null) {
        return false;
      }

      String? nextFocusTargetName;

      switch (action.type) {
        case FocusNavType.moveNext:
        // Delegate to Flutter's default focus traversal
          return false;
        case FocusNavType.moveTo:
          nextFocusTargetName = action.targetName;
          break;
        case FocusNavType.stay:
        // Only stay if this is the actively focused field; otherwise abort chain
          return inspectingFocusTargetName == currentFocusTargetName;
        case FocusNavType.reject:
          if (inspectingFocusTargetName == currentFocusTargetName) {
            if (action.message != null && action.message!.isNotEmpty) {
              // TODO: Trigger toast/snackbar via FlutterArtist UI manager
              print("[FocusNavDispatcher] Rejected: ${action.message}");
            }
            return true;
          }
          return false;
      }

      if (nextFocusTargetName == null || nextFocusTargetName.isEmpty) {
        return false;
      }

      final targetField = formState.fields[nextFocusTargetName];

      if (targetField != null && targetField.mounted && targetField.enabled) {
        targetField.focus();

        // Ensure the screen scrolls to the target widget if inside a ScrollView
        SchedulerBinding.instance.addPostFrameCallback((_) {
          if (targetField.mounted) {
            Scrollable.ensureVisible(
              targetField.context,
              duration: const Duration(milliseconds: 150),
              curve: Curves.easeInOut,
              alignmentPolicy: ScrollPositionAlignmentPolicy.keepVisibleAtEnd,
            );
          }
        });
        return true;
      }

      // Handle skipping over disabled/hidden fields (with loop protection)
      if (visitedTargets.contains(nextFocusTargetName)) {
        return false;
      }
      visitedTargets.add(nextFocusTargetName);
      inspectingFocusTargetName = nextFocusTargetName;
    }
  }
}