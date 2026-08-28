part of '../../core.dart';

class ActivityConfig {
  final ActivityHiddenAction onHideAction;

  const ActivityConfig({
    this.onHideAction = ActivityHiddenAction.none,
  });

  ActivityConfig copy() => ActivityConfig(onHideAction: onHideAction);
}

class ActivityEffectiveConfig {
  final ActivityConfig _baselineConfig;

  ActivityEffectiveConfig._fromConfig(this._baselineConfig);

  factory ActivityEffectiveConfig.fromConfig(ActivityConfig config) =>
      ActivityEffectiveConfig._fromConfig(config);

  ActivityHiddenAction get onHideAction => _baselineConfig.onHideAction;
}
