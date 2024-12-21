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
    required Object object,
    required StackTrace currentStackTrace,
    required Map<String, dynamic>? parameters,
  }) {
    __markDateTime();
    //
    _CodeFlowItem item;
    try {
      item = _CodeFlowItem._methodCallFromStackTrace(
        object: object,
        currentStackTrace: currentStackTrace,
        arguments: parameters,
        isLibCode: false,
      );
    } catch (e) {
      item = _CodeFlowItem._methodCall(
        object: object,
        methodName: "Something Error",
        arguments: parameters,
        isLibCode: false,
      );
    }
    _codeFlowItems.add(item);
  }

  void _addMethodCall({
    required Object object,
    required String methodName,
    required Map<String, dynamic>? parameters,
    required Function()? route,
    required bool isLibCode,
  }) {
    __markDateTime();
    //
    _CodeFlowItem log = _CodeFlowItem._methodCall(
      object: object,
      methodName: methodName,
      arguments: parameters,
      isLibCode: isLibCode,
    );
    _codeFlowItems.add(log);
  }

  // ===========================================================================
  // ===========================================================================

  void addInfo({
    required Object object,
    required String info,
  }) {
    return _addInfo(
      object: object,
      info: info,
      isLibCode: false,
    );
  }

  void _addInfo({
    required Object object,
    required String info,
    required bool isLibCode,
  }) {
    __markDateTime();
    //
    _CodeFlowItem log = _CodeFlowItem._info(
      object: object,
      info: info,
      isLibCode: isLibCode,
    );
    _codeFlowItems.add(log);
  }

  void _addEvent({
    required Object object,
    required String event,
    required bool isLibCode,
  }) {
    __markDateTime();
    //
    _CodeFlowItem log = _CodeFlowItem._info(
      object: object,
      info: event,
      isLibCode: isLibCode,
    );
    _codeFlowItems.add(log);
  }

  // ===========================================================================
  // ===========================================================================

  void addError({
    required Object object,
    required String error,
  }) {
    return _addError(
      object: object,
      error: error,
      isLibCode: false,
    );
  }

  void _addError({
    required Object object,
    required String error,
    required bool isLibCode,
  }) {
    __markDateTime();
    //
    _CodeFlowItem log = _CodeFlowItem._error(
      object: object,
      error: error,
      isLibCode: isLibCode,
    );
    _codeFlowItems.add(log);
  }
}
