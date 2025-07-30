part of '../code.dart';

enum CoordinatorNavCondition {
  any,
  success,
  error;
}

class CoordinatorConfig {
  final CoordinatorNavCondition navCondition;

  const CoordinatorConfig({
    this.navCondition = CoordinatorNavCondition.success,
  });
}
