part of '../core.dart';

abstract class TaskInitData {
  //
}

class EmptyTaskInitData extends TaskInitData {
  EmptyTaskInitData._();

  factory EmptyTaskInitData() => EmptyTaskInitData._();
}


class TaskResultData {

}

class EmptyTaskResultData extends TaskResultData {
  EmptyTaskResultData._();

  factory EmptyTaskResultData() => EmptyTaskResultData._();
}