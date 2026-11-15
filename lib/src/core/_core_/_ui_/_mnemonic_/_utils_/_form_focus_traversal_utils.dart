import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class FormFocusTraversalUtils {
  /// Handles circular Tab / Shift+Tab focus traversal inside a Form or FilterPanel.
  ///
  /// Returns [KeyEventResult.handled] if the focus wrap-around was intercepted,
  /// otherwise returns [KeyEventResult.ignored].
  static KeyEventResult handleFormTabTraversal({
    required BuildContext context,
    required FocusNode node,
    required KeyEvent event,
    required bool isCircular,
  }) {
    if (!isCircular) return KeyEventResult.ignored;

    if (event is! KeyDownEvent && event is! KeyRepeatEvent) {
      return KeyEventResult.ignored;
    }
    if (event.logicalKey != LogicalKeyboardKey.tab) {
      return KeyEventResult.ignored;
    }

    final HardwareKeyboard keyboard = HardwareKeyboard.instance;

    // Ignore Ctrl+Tab / Alt+Tab / Meta+Tab so OS or region traversal shortcuts handle them.
    if (keyboard.isControlPressed ||
        keyboard.isAltPressed ||
        keyboard.isMetaPressed) {
      return KeyEventResult.ignored;
    }

    final FocusNode? primaryFocus = FocusManager.instance.primaryFocus;
    if (primaryFocus != null && primaryFocus != node) {
      final FocusTraversalPolicy policy =
          FocusTraversalGroup.maybeOf(context) ?? ReadingOrderTraversalPolicy();

      final List<FocusNode> formFocusNodes = policy
          .sortDescendants(node.traversalDescendants, primaryFocus)
          .toList();

      if (formFocusNodes.isNotEmpty) {
        final bool isShiftPressed = keyboard.isShiftPressed;
        if (isShiftPressed && primaryFocus == formFocusNodes.first) {
          formFocusNodes.last.requestFocus();
          return KeyEventResult.handled;
        } else if (!isShiftPressed && primaryFocus == formFocusNodes.last) {
          formFocusNodes.first.requestFocus();
          return KeyEventResult.handled;
        }
      }
    }

    return KeyEventResult.ignored;
  }

  /// Prevents single-line [TextField] widgets from triggering Flutter's default
  /// mobile-first `TextInputAction.done` (`unfocus()`) behavior on `Enter` when
  /// no custom `resolveNextFocus()` action was executed.
  ///
  /// Multi-line text inputs (`maxLines != 1`), dropdowns, checkboxes, and
  /// suffix icon buttons remain unaffected and handle `Enter` natively.
  static KeyEventResult preventSingleLineEnterUnfocus(KeyEvent event) {
    if (event is! KeyDownEvent && event is! KeyRepeatEvent) {
      return KeyEventResult.ignored;
    }

    if (event.logicalKey != LogicalKeyboardKey.enter &&
        event.logicalKey != LogicalKeyboardKey.numpadEnter) {
      return KeyEventResult.ignored;
    }

    final HardwareKeyboard keyboard = HardwareKeyboard.instance;
    if (keyboard.isControlPressed ||
        keyboard.isAltPressed ||
        keyboard.isMetaPressed ||
        keyboard.isShiftPressed) {
      return KeyEventResult.ignored;
    }

    if (_isSingleLineTextInput(FocusManager.instance.primaryFocus)) {
      return KeyEventResult.handled;
    }

    return KeyEventResult.ignored;
  }

  /// Inspects [focusNode] to verify whether it directly owns a single-line
  /// [EditableText] widget (`maxLines == 1`).
  static bool _isSingleLineTextInput(FocusNode? focusNode) {
    if (focusNode == null) return false;
    final BuildContext? ctx = focusNode.context;
    if (ctx == null || !ctx.mounted) return false;

    final EditableText? editable = ctx.widget is EditableText
        ? ctx.widget as EditableText
        : ctx.findAncestorWidgetOfExactType<EditableText>();

    if (editable == null) return false;

    // Ensure the FocusNode actually belongs to the EditableText itself
    // rather than a focusable suffix/prefix icon button inside InputDecoration.
    if (!identical(editable.focusNode, focusNode)) {
      return false;
    }

    return editable.maxLines == 1;
  }
}
