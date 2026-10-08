part of '../core.dart';

abstract class ProzessInitData {
  //
}

class EmptyProzessInitData extends ProzessInitData {
  EmptyProzessInitData._();

  factory EmptyProzessInitData() => EmptyProzessInitData._();
}

abstract class ProzessContextData {
  void _updateFromActiveStages(List<Stage> activeStages) {
    for (Stage activeStage in activeStages) {
      updateFromActiveStage(activeStage: activeStage);
    }
  }

  void updateFromActiveStage({required Stage activeStage});

  void reset();
}

class EmptyProzessContextData extends ProzessContextData {
  EmptyProzessContextData._();

  factory EmptyProzessContextData() => EmptyProzessContextData._();

  @override
  void reset() {}

  @override
  void updateFromActiveStage({
    required Stage activeStage,
  }) {}
}
