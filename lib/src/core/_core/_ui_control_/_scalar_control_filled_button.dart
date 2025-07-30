part of '../../_fa_core.dart';

class ScalarControlFilledButton extends ScalarControl {
  ScalarControlFilledButton({
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
    Widget? child,
  }) : super(
          build: (VoidCallback? onPressed) {
            return FilledButton(
              onPressed: onPressed,
              onHover: onHover,
              onFocusChange: onFocusChange,
              style: style,
              focusNode: focusNode,
              autofocus: autofocus,
              clipBehavior: clipBehavior,
              statesController: statesController,
              child: child,
            );
          },
        );

  ScalarControlFilledButton.icon({
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
    Clip? clipBehavior,
    WidgetStatesController? statesController,
    required Widget label,
    Widget? icon,
    IconAlignment iconAlignment = IconAlignment.start,
  }) : super(
          build: (VoidCallback? onPressed) {
            return FilledButton.icon(
              onPressed: onPressed,
              onHover: onHover,
              onFocusChange: onFocusChange,
              style: style,
              focusNode: focusNode,
              autofocus: autofocus,
              clipBehavior: clipBehavior = Clip.none,
              statesController: statesController,
              iconAlignment: iconAlignment,
              icon: icon,
              label: label,
            );
          },
        );

  ScalarControlFilledButton.tonal({
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
    Widget? child,
    IconAlignment iconAlignment = IconAlignment.start,
  }) : super(
          build: (VoidCallback? onPressed) {
            return FilledButton.tonal(
              onPressed: onPressed,
              onHover: onHover,
              onFocusChange: onFocusChange,
              style: style,
              focusNode: focusNode,
              autofocus: autofocus,
              clipBehavior: clipBehavior,
              statesController: statesController,
              child: child,
            );
          },
        );

  ScalarControlFilledButton.tonalIcon({
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
    Clip? clipBehavior,
    WidgetStatesController? statesController,
    required Widget label,
    Widget? icon,
    IconAlignment iconAlignment = IconAlignment.start,
  }) : super(
          build: (VoidCallback? onPressed) {
            return FilledButton.tonalIcon(
              onPressed: onPressed,
              onHover: onHover,
              onFocusChange: onFocusChange,
              style: style,
              focusNode: focusNode,
              autofocus: autofocus,
              clipBehavior: clipBehavior = Clip.none,
              statesController: statesController,
              iconAlignment: iconAlignment,
              icon: icon,
              label: label,
            );
          },
        );
}
