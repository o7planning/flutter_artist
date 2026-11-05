part of '../../core.dart';

/// Central registry and dispatcher for [ControlMnemonic] widgets and view-level
/// [MnemonicShortcut] actions.
class _MnemonicDispatcher {
  static final Set<ControlMnemonicState> _registeredControls = {};

  static void register(ControlMnemonicState control) {
    _registeredControls.add(control);
  }

  static void unregister(ControlMnemonicState control) {
    _registeredControls.remove(control);
  }

  /// Extract key characters based on PhysicalKey to bypass OS interference
  /// (such as Dead Keys on macOS or Vietnamese input methods).
  static String _extractCharKey(KeyEvent event) {
    final String? physicalName = event.physicalKey.debugName;
    if (physicalName != null) {
      // physicalName typically takes the form "Key U", "Key S", "Key C", etc.
      if (physicalName.startsWith("Key ") && physicalName.length == 5) {
        return physicalName.substring(4, 5).toUpperCase();
      }
      // Or numbers: "Digit 1", "Digit 2"...
      if (physicalName.startsWith("Digit ") && physicalName.length == 7) {
        return physicalName.substring(6, 7);
      }
    }
    // Safe fallback if PhysicalKey cannot be parsed
    final String fallback = event.logicalKey.keyLabel.trim().toUpperCase();
    return fallback.length == 1 ? fallback : '';
  }

  /// Resolves the active [MnemonicShortcut] matching the given hardware [event], if any.
  static MnemonicShortcut? resolveShortcut(KeyEvent event) {
    // Không cần check chữ cái A-Z nữa
    final HardwareKeyboard keyboard = HardwareKeyboard.instance;

    for (final MnemonicShortcut shortcut in MnemonicShortcut.values) {
      // Nhường toàn quyền kiểm tra cho hàm matches của ông giáo
      if (shortcut.matches(event, keyboard)) {
        return shortcut;
      }
    }
    return null;
  }

  /// Attempts to trigger a registered [ControlMnemonic] widget matching the
  /// pressed key combination within the given [scopes].
  static bool tryTriggerRegisteredControl(
    KeyEvent event, {
    required List<MnemonicScope> scopes,
  }) {
    if (event is! KeyDownEvent) return false;

    final String keyLabel = _extractCharKey(event);
    if (keyLabel.isEmpty) return false;

    final HardwareKeyboard keyboard = HardwareKeyboard.instance;

    final List<ControlMnemonicState> candidates = _registeredControls
        .where((c) =>
            c.mounted &&
            c.charKey == keyLabel &&
            c.modifier.isPressed(keyboard) &&
            c.isActionEnabled)
        .toList();

    if (candidates.isEmpty) return false;

    // 1. Match explicit scope in priority order
    for (final MnemonicScope targetScope in scopes) {
      for (final ControlMnemonicState control in candidates) {
        if (identical(control.scope, targetScope)) {
          if (control.trigger()) return true;
        }
      }
    }

    // 2. Fallback to unscoped ControlMnemonic if any
    for (final ControlMnemonicState control in candidates) {
      if (control.scope == null) {
        if (control.trigger()) return true;
      }
    }

    return false;
  }
}
