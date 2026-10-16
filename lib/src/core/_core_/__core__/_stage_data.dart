part of '../core.dart';

abstract class StageResultData implements DataDebugable {
  //
}

class EmptyStageResultData extends StageResultData {
  EmptyStageResultData._();

  factory EmptyStageResultData() => EmptyStageResultData._();

  @override
  Map<String, dynamic> toDebugMap() {
    return {};
  }
}

abstract class StageInitData implements DataDebugable {
  //
}

class EmptyStageInitData extends StageInitData {
  EmptyStageInitData._();

  factory EmptyStageInitData() => EmptyStageInitData._();

  @override
  Map<String, dynamic> toDebugMap() {
    return {};
  }
}
