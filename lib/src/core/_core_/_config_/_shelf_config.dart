part of '../core.dart';

class ShelfConfig {
  final ShelfHiddenBehavior hiddenBehavior;

  const ShelfConfig({
    this.hiddenBehavior = ShelfHiddenBehavior.none,
  });

  ShelfConfig copy() {
    return ShelfConfig(
      hiddenBehavior: hiddenBehavior,
    );
  }
}
