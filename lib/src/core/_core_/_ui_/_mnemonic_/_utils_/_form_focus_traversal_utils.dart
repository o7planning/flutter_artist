import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class FormFocusTraversalUtils {
  /// Xử lý logic xoay vòng focus (Circular Focus Traversal) bên trong một Form.
  /// Trả về [KeyEventResult.handled] nếu đã can thiệp vòng lặp, ngược lại trả về [KeyEventResult.ignored].
  static KeyEventResult handleFormTabTraversal({
    required BuildContext context,
    required FocusNode node,
    required KeyEvent event,
    required bool isCircular,
  }) {
    if (!isCircular) return KeyEventResult.ignored;

    // Chỉ bắt sự kiện KeyDown hoặc KeyRepeat của phím Tab
    if (event is! KeyDownEvent && event is! KeyRepeatEvent) {
      return KeyEventResult.ignored;
    }
    if (event.logicalKey != LogicalKeyboardKey.tab) {
      return KeyEventResult.ignored;
    }

    final HardwareKeyboard keyboard = HardwareKeyboard.instance;

    // Bỏ qua Ctrl+Tab / Alt+Tab / Meta+Tab để hệ điều hành hoặc MnemonicRegionDirection xử lý
    if (keyboard.isControlPressed ||
        keyboard.isAltPressed ||
        keyboard.isMetaPressed) {
      return KeyEventResult.ignored;
    }

    final FocusNode? primaryFocus = FocusManager.instance.primaryFocus;
    if (primaryFocus != null && primaryFocus != node) {
      final FocusTraversalPolicy policy =
          FocusTraversalGroup.maybeOf(context) ?? ReadingOrderTraversalPolicy();

      // Chỉ gom các focusable node nằm bên trong Node bọc ngoài của Form
      final List<FocusNode> formFocusNodes = policy
          .sortDescendants(node.traversalDescendants, primaryFocus)
          .toList();

      if (formFocusNodes.isNotEmpty) {
        final bool isShiftPressed = keyboard.isShiftPressed;
        // Đang ở phần tử đầu tiên mà ấn Shift+Tab -> Vòng xuống cuối
        if (isShiftPressed && primaryFocus == formFocusNodes.first) {
          formFocusNodes.last.requestFocus();
          return KeyEventResult.handled;
        }
        // Đang ở phần tử cuối cùng mà ấn Tab -> Vòng lên đầu
        else if (!isShiftPressed && primaryFocus == formFocusNodes.last) {
          formFocusNodes.first.requestFocus();
          return KeyEventResult.handled;
        }
      }
    }

    return KeyEventResult.ignored;
  }
}
