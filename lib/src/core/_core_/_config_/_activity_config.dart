part of '../core.dart';

class ActivityConfig {
  /// Defines how this Activity is retained in memory or released when unmounted.
  final ActivityReleasePolicy releasePolicy;

  final ActivityHiddenAction onHideAction;

  const ActivityConfig({
    this.releasePolicy = ActivityReleasePolicy.retain,
    this.onHideAction = ActivityHiddenAction.none,
  });

  ActivityConfig copy() => ActivityConfig(
        onHideAction: onHideAction,
        releasePolicy: releasePolicy,
      );
}

class ActivityEffectiveConfig {
  final ActivityConfig _baselineConfig;

  ActivityEffectiveConfig._fromConfig(this._baselineConfig);

  factory ActivityEffectiveConfig.fromConfig(ActivityConfig config) =>
      ActivityEffectiveConfig._fromConfig(config);

  ActivityHiddenAction get onHideAction => _baselineConfig.onHideAction;

  ActivityReleasePolicy get releasePolicy => _baselineConfig.releasePolicy;
}
