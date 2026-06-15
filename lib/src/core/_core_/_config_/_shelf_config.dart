part of '../core.dart';

class ShelfConfig {
  final ShelfReleasePolicy releasePolicy;

  const ShelfConfig({
    this.releasePolicy = ShelfReleasePolicy.retain,
  });

  ShelfConfig copy() {
    return ShelfConfig(
      releasePolicy: releasePolicy,
    );
  }
}
