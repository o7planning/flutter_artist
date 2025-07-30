part of '../../_fa_core.dart';

class BlockControlElevatedButton extends BlockControl {
  BlockControlElevatedButton({
    super.key,
    required super.currentStackTrace,
    required super.ownerClassInstance,
    required super.block,
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
    Widget? child,
  }) : super(
          build: (VoidCallback? onPressed) {
            return ElevatedButton(
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

  BlockControlElevatedButton.icon({
    super.key,
    required super.currentStackTrace,
    required super.ownerClassInstance,
    required super.block,
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
            return ElevatedButton.icon(
              onPressed: onPressed,
              onHover: onHover,
              onFocusChange: onFocusChange,
              style: style,
              focusNode: focusNode,
              autofocus: autofocus,
              clipBehavior: clipBehavior,
              statesController: statesController,
              iconAlignment: iconAlignment,
              icon: icon,
              label: label,
            );
          },
        );
}
