part of '../../core.dart';

/// Wraps a button or interactive control to bind it to a single-character
/// keyboard mnemonic shortcut (e.g., `Alt + S` on Windows, `Ctrl + S` on macOS)
/// within a given [MnemonicScope].
///
/// [ControlMnemonic] automatically inspects its descendant widget tree to locate
/// and invoke the underlying button's action callback (`onPressed` or `onTap`)
/// without requiring the developer to pass the callback twice.
///
/// ### Example:
/// ```dart
/// ControlMnemonic(
///   charKey: "S",
///   scope: block,
///   child: TextElevatedButton(
///     onPressed: _supplier15xSave,
///     text: "Save Supplier",
///   ),
/// )
/// ```
class ControlMnemonic extends StatefulWidget {
  /// Single alphanumeric character (A-Z, 0-9) representing the shortcut key.
  final String charKey;

  /// Modifier key combination required to trigger this mnemonic.
  /// Defaults to [MnemonicModifier.mnemonic] (`Alt` on Windows/Linux, `Ctrl` on macOS).
  final MnemonicModifier modifier;

  /// Optional target scope (such as a [Block], [Scalar], [BaseFormModel], [FilterModel],
  /// [Task]) that disambiguates duplicate shortcuts across regions.
  final MnemonicScope? scope;

  /// Optional explicit callback override.
  ///
  /// If omitted, [ControlMnemonic] automatically traverses its [child] subtree
  /// to find and trigger the underlying button's `onPressed` or `onTap` callback.
  final VoidCallback? onTrigger;

  /// The button or interactive control widget wrapped by this mnemonic.
  final Widget child;

  ControlMnemonic({
    super.key,
    required String charKey,
    this.modifier = MnemonicModifier.mnemonic,
    this.scope,
    this.onTrigger,
    required this.child,
  }) : charKey = charKey.trim().toUpperCase() {
    assert(
    this.charKey.length == 1,
    'charKey must be a single character (e.g., "A", "S", "1"), but got "$charKey".',
    );
  }

  @override
  State<ControlMnemonic> createState() => ControlMnemonicState();
}

// *****************************************************************************

class ControlMnemonicState extends State<ControlMnemonic> {
  /// Normalized uppercase character key (e.g., `"S"`).
  String get charKey => widget.charKey;

  /// The modifier required to activate this control.
  MnemonicModifier get modifier => widget.modifier;

  /// The explicit scope assigned to this control, if any.
  MnemonicScope? get scope => widget.scope;

  @override
  void initState() {
    super.initState();
    _MnemonicDispatcher.register(this);
  }

  @override
  void didUpdateWidget(covariant ControlMnemonic oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.charKey != widget.charKey ||
        oldWidget.modifier != widget.modifier ||
        oldWidget.scope != widget.scope) {
      _MnemonicDispatcher.register(this);
    }
  }

  @override
  void dispose() {
    _MnemonicDispatcher.unregister(this);
    super.dispose();
  }

  /// Checks whether the underlying button is currently mounted and enabled.
  bool get isActionEnabled {
    if (!mounted) return false;
    if (widget.onTrigger != null) return true;
    return _resolveDescendantCallback() != null;
  }

  /// Invokes the underlying button's action if mounted and enabled.
  ///
  /// Returns `true` if an enabled callback was found and executed;
  /// returns `false` if the control is disabled or no callback could be resolved.
  bool trigger() {
    if (!mounted) return false;

    if (widget.onTrigger != null) {
      widget.onTrigger!();
      return true;
    }

    final VoidCallback? callback = _resolveDescendantCallback();
    if (callback != null) {
      callback();
      return true;
    }

    // Fallback: Attempt to invoke Flutter's standard ActivateIntent on a descendant focus node.
    return _tryInvokeActivateIntent();
  }

  /// Traverses the descendant [Element] tree to extract the active callback
  /// from standard Flutter buttons or interactive widgets.
  VoidCallback? _resolveDescendantCallback() {
    VoidCallback? resolvedCallback;
    bool buttonFound = false;

    void visit(Element element) {
      if (buttonFound) return;

      final Widget currentWidget = element.widget;

      // 1. Standard Material 3 / Material 2 Buttons:
      // Covers ElevatedButton, FilledButton, OutlinedButton, TextButton,
      // and any custom wrapper (like TextElevatedButton) that builds them.
      if (currentWidget is ButtonStyleButton) {
        buttonFound = true;
        if (currentWidget.enabled && currentWidget.onPressed != null) {
          resolvedCallback = currentWidget.onPressed;
        }
        return; // Stop descending into the button's internal InkWell
      }

      // 2. IconButton
      if (currentWidget is IconButton) {
        buttonFound = true;
        if (currentWidget.onPressed != null) {
          resolvedCallback = currentWidget.onPressed;
        }
        return;
      }

      // 3. FloatingActionButton
      if (currentWidget is FloatingActionButton) {
        buttonFound = true;
        if (currentWidget.onPressed != null) {
          resolvedCallback = currentWidget.onPressed;
        }
        return;
      }

      // 4. Legacy / RawMaterialButton
      if (currentWidget is RawMaterialButton) {
        buttonFound = true;
        if (currentWidget.enabled && currentWidget.onPressed != null) {
          resolvedCallback = currentWidget.onPressed;
        }
        return;
      }

      // 5. CupertinoButton
      if (currentWidget is CupertinoButton) {
        buttonFound = true;
        if (currentWidget.enabled && currentWidget.onPressed != null) {
          resolvedCallback = currentWidget.onPressed;
        }
        return;
      }

      // 6. Custom interactive controls built with InkWell / InkResponse
      if (currentWidget is InkResponse) {
        buttonFound = true;
        if (currentWidget.onTap != null) {
          resolvedCallback = currentWidget.onTap;
        }
        return;
      }

      // 7. Custom interactive controls built with GestureDetector
      if (currentWidget is GestureDetector) {
        buttonFound = true;
        if (currentWidget.onTap != null) {
          resolvedCallback = currentWidget.onTap;
        }
        return;
      }

      // Continue traversing deeper through wrappers (Tooltip, Padding, SizedBox, etc.)
      element.visitChildren(visit);
    }

    context.visitChildElements(visit);
    return resolvedCallback;
  }

  /// Fallback mechanism using Flutter's [ActivateIntent] if a custom control
  /// handles keyboard activation via [Actions] instead of standard button callbacks.
  bool _tryInvokeActivateIntent() {
    BuildContext? actionableContext;

    void visit(Element element) {
      if (actionableContext != null) return;
      if (element.widget is Actions) {
        final material.Action<ActivateIntent>? action =
        material.Actions.maybeFind<ActivateIntent>(element);
        if (action != null && action.isActionEnabled) {
          actionableContext = element;
          return;
        }
      }
      element.visitChildren(visit);
    }

    context.visitChildElements(visit);

    if (actionableContext != null) {
      Actions.maybeInvoke<ActivateIntent>(
        actionableContext!,
        const ActivateIntent(),
      );
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}