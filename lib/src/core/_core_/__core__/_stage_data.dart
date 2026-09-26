part of '../core.dart';

abstract class StageResultData {
  //
}

class EmptyStageResultData extends StageResultData {
  EmptyStageResultData._();

  factory EmptyStageResultData() => EmptyStageResultData._();
}

abstract class StageInitData {
  //
}

class EmptyStageInitData extends StageInitData {
  EmptyStageInitData._();

  factory EmptyStageInitData() => EmptyStageInitData._();
}
