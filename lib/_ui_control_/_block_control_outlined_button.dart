part of '../flutter_artist.dart';

class BlockControlOutlinedButton extends BlockControl {
  BlockControlOutlinedButton({
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
    IconAlignment iconAlignment = IconAlignment.start,
  }) : super(
          build: (VoidCallback? onPressed) {
            return OutlinedButton(
              onPressed: onPressed,
              onHover: onHover,
              onFocusChange: onFocusChange,
              style: style,
              focusNode: focusNode,
              autofocus: autofocus,
              clipBehavior: clipBehavior,
              statesController: statesController,
              iconAlignment: iconAlignment,
              child: child,
            );
          },
        );

  BlockControlOutlinedButton.icon({
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
    required Widget label,
    Widget? icon,
    IconAlignment iconAlignment = IconAlignment.start,
  }) : super(
          build: (VoidCallback? onPressed) {
            return OutlinedButton.icon(
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
