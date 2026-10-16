part of '../core.dart';

abstract class ProzessInitData implements DataDebugable {
  //
}

class EmptyProzessInitData extends ProzessInitData {
  EmptyProzessInitData._();

  factory EmptyProzessInitData() => EmptyProzessInitData._();

  @override
  Map<String, dynamic> toDebugMap() {
    return {};
  }
}

abstract class ProzessContextData implements DataDebugable {
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

  @override
  Map<String, dynamic> toDebugMap() {
    return {};
  }
}
