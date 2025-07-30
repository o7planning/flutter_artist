part of '../../_fa_core.dart';

class ActivityConfig {
  final ActivityHiddenBehavior hiddenBehavior;

  const ActivityConfig({
    this.hiddenBehavior = ActivityHiddenBehavior.none,
  });

  ActivityConfig copy() {
    return ActivityConfig(hiddenBehavior: hiddenBehavior);
  }
}
