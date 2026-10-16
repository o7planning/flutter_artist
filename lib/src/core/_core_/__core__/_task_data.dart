part of '../core.dart';

abstract class TaskInitData implements DataDebugable {
  //
}

class EmptyTaskInitData extends TaskInitData {
  EmptyTaskInitData._();

  factory EmptyTaskInitData() => EmptyTaskInitData._();

  @override
  Map<String, dynamic> toDebugMap() {
    return {};
  }
}

abstract class TaskResultData implements DataDebugable {
  //
}

class EmptyTaskResultData extends TaskResultData {
  EmptyTaskResultData._();

  factory EmptyTaskResultData() => EmptyTaskResultData._();

  @override
  Map<String, dynamic> toDebugMap() {
    return {};
  }
}
