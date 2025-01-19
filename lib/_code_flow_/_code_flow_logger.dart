part of '../flutter_artist.dart';

class CodeFlowLogger {
  static const double resetSeconds = 10;

  final List<_CodeFlowItem> _codeFlowItems = [];

  DateTime __lastDateTime = DateTime.now();

  void __markDateTime() {
    DateTime now = DateTime.now();
    Duration duration = now.difference(__lastDateTime);
    if (duration.inSeconds > resetSeconds) {
      clear();
    }
    __lastDateTime = now;
  }

  void clear() {
    _codeFlowItems.clear();
  }

  // ===========================================================================
  // ===========================================================================

  void addMethodCall({
    required Object ownerClassInstance,
    required StackTrace currentStackTrace,
    required Map<String, dynamic>? parameters,
  }) {
    __markDateTime();
    //
    _CodeFlowItem item;
    try {
      item = _CodeFlowItem._methodCallFromStackTrace(
        ownerClassInstance: ownerClassInstance,
        currentStackTrace: currentStackTrace,
        arguments: parameters,
        isLibCode: false,
      );
    } catch (e) {
      item = _CodeFlowItem._methodCall(
        ownerClassInstance: ownerClassInstance,
        methodName: "Something Error",
        arguments: parameters,
        isLibCode: false,
      );
    }
    _codeFlowItems.add(item);
  }

  void _addMethodCall({
    required Object ownerClassInstance,
    required String methodName,
    required Map<String, dynamic>? parameters,
    required Function()? navigate,
    required bool isLibCode,
  }) {
    __markDateTime();
    //
    _CodeFlowItem log = _CodeFlowItem._methodCall(
      ownerClassInstance: ownerClassInstance,
      methodName: methodName,
      arguments: parameters,
      isLibCode: isLibCode,
    );
    _codeFlowItems.add(log);
  }

  // ===========================================================================
  // ===========================================================================

  void addInfo({
    required Object ownerClassInstance,
    required String info,
  }) {
    return _addInfo(
      ownerClassInstance: ownerClassInstance,
      info: info,
      isLibCode: false,
    );
  }

  void _addInfo({
    required Object ownerClassInstance,
    required String info,
    required bool isLibCode,
  }) {
    __markDateTime();
    //
    _CodeFlowItem log = _CodeFlowItem._info(
      ownerClassInstance: ownerClassInstance,
      info: info,
      isLibCode: isLibCode,
    );
    _codeFlowItems.add(log);
  }

  void _addEvent({
    required Object ownerClassInstance,
    required String event,
    required bool isLibCode,
  }) {
    __markDateTime();
    //
    _CodeFlowItem log = _CodeFlowItem._info(
      ownerClassInstance: ownerClassInstance,
      info: event,
      isLibCode: isLibCode,
    );
    _codeFlowItems.add(log);
  }

  // ===========================================================================
  // ===========================================================================

  void addError({
    required Object ownerClassInstance,
    required String error,
  }) {
    return _addError(
      ownerClassInstance: ownerClassInstance,
      error: error,
      isLibCode: false,
    );
  }

  void _addError({
    required Object ownerClassInstance,
    required String error,
    required bool isLibCode,
  }) {
    __markDateTime();
    //
    _CodeFlowItem log = _CodeFlowItem._error(
      ownerClassInstance: ownerClassInstance,
      error: error,
      isLibCode: isLibCode,
    );
    _codeFlowItems.add(log);
  }
}
