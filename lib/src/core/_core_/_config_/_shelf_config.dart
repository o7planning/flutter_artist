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

class ShelfEffectiveConfig {
  final ShelfConfig _baselineConfig;

  ShelfEffectiveConfig._fromConfig(this._baselineConfig);

  factory ShelfEffectiveConfig.fromConfig(ShelfConfig config) =>
      ShelfEffectiveConfig._fromConfig(config);

  ShelfReleasePolicy get releasePolicy => _baselineConfig.releasePolicy;
}
