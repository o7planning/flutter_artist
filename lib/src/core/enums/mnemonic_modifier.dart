part of '_enums.dart';

/// Defines the modifier key combinations required to trigger a [MnemonicShortcut].
enum MnemonicModifier {
  /// `Alt` on Windows/Linux/Web, or `Option` (`⌥`) on macOS.
  alt,

  /// `Ctrl` on Windows/Linux/Web, or `Control` (`⌃`) / `Cmd` (`⌘`) on macOS.
  ctrl,

  /// `Alt + Shift` on Windows/Linux/Web, or `Option + Shift` on macOS.
  altShift,

  /// `Ctrl + Shift` on Windows/Linux/Web, or `Ctrl + Shift` on macOS.
  ctrlShift,

  /// `Ctrl + Alt` on Windows/Linux/Web, or `Ctrl + Option` on macOS.
  ctrlAlt;

  static bool get _isAppleOS =>
      defaultTargetPlatform == TargetPlatform.macOS ||
      defaultTargetPlatform == TargetPlatform.iOS;

  /// Returns the human-readable modifier prefix adapted to the active platform.
  String get label {
    switch (this) {
      case MnemonicModifier.alt:
        return _isAppleOS ? 'Option' : 'Alt';
      case MnemonicModifier.ctrl:
        return 'Ctrl';
      case MnemonicModifier.altShift:
        return _isAppleOS ? 'Option + Shift' : 'Alt + Shift';
      case MnemonicModifier.ctrlShift:
        return 'Ctrl + Shift';
      case MnemonicModifier.ctrlAlt:
        return _isAppleOS ? 'Ctrl + Option' : 'Ctrl + Alt';
    }
  }

  /// Checks whether the currently pressed hardware modifier keys match this modifier.
  bool isPressed(HardwareKeyboard keyboard) {
    final bool alt = keyboard.isAltPressed;
    final bool ctrl = keyboard.isControlPressed;
    final bool shift = keyboard.isShiftPressed;
    final bool meta = keyboard.isMetaPressed;

    // Ignore combinations if the OS Meta/Windows/Command key is held down.
    if (meta) return false;

    switch (this) {
      case MnemonicModifier.alt:
        return alt && !ctrl && !shift;
      case MnemonicModifier.ctrl:
        return !alt && ctrl && !shift;
      case MnemonicModifier.altShift:
        return alt && !ctrl && shift;
      case MnemonicModifier.ctrlShift:
        return !alt && ctrl && shift;
      case MnemonicModifier.ctrlAlt:
        return alt && ctrl && !shift;
    }
  }
}
