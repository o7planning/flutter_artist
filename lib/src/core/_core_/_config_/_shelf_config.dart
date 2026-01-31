part of '../core.dart';

class ShelfConfig {
  final ShelfHiddenAction onHideAction;

  const ShelfConfig({
    this.onHideAction = ShelfHiddenAction.none,
  });

  ShelfConfig copy() {
    return ShelfConfig(
      onHideAction: onHideAction,
    );
  }
}
