part of '../_fa_core.dart';

class ScalarControlTextButton extends ScalarControl {
  ScalarControlTextButton({
    super.key,
    required super.currentStackTrace,
    required super.ownerClassInstance,
    required super.scalar,
    required super.actionType,
    super.navigate,
    //
    ValueChanged<bool>? onHover,
    ValueChanged<bool>? onFocusChange,
    bool? isSemanticButton = true,
    ButtonStyle? style,
    FocusNode? focusNode,
    bool autofocus = false,
    Clip? clipBehavior = Clip.none,
    WidgetStatesController? statesController,
    required Widget child,
  }) : super(
          build: (VoidCallback? onPressed) {
            return TextButton(
              onPressed: onPressed,
              onHover: onHover,
              onFocusChange: onFocusChange,
              style: style,
              focusNode: focusNode,
              autofocus: autofocus,
              clipBehavior: clipBehavior,
              isSemanticButton: isSemanticButton,
              statesController: statesController,
              child: child,
            );
          },
        );

  ScalarControlTextButton.icon({
    super.key,
    required super.currentStackTrace,
    required super.ownerClassInstance,
    required super.scalar,
    required super.actionType,
    super.navigate,
    //
    ValueChanged<bool>? onHover,
    ValueChanged<bool>? onFocusChange,
    ButtonStyle? style,
    FocusNode? focusNode,
    bool autofocus = false,
    Clip? clipBehavior = Clip.none,
    WidgetStatesController? statesController,
    required Widget label,
    Widget? icon,
    IconAlignment iconAlignment = IconAlignment.start,
  }) : super(
          build: (VoidCallback? onPressed) {
            return TextButton.icon(
              onPressed: onPressed,
              onHover: onHover,
              onFocusChange: onFocusChange,
              style: style,
              focusNode: focusNode,
              autofocus: autofocus,
              clipBehavior: clipBehavior,
              statesController: statesController,
              iconAlignment: iconAlignment,
              label: label,
              icon: icon,
            );
          },
        );
}
