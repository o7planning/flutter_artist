part of '../../flutter_artist.dart';

enum CoordinatorNavigationCondition {
  any,
  success,
  error;
}

class CoordinatorConfig {
  final CoordinatorNavigationCondition navigationCondition;

  const CoordinatorConfig({
    this.navigationCondition = CoordinatorNavigationCondition.success,
  });
}
