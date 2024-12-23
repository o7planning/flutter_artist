part of '../flutter_artist.dart';

int __flowLogItemSEQ = 0;

class _CodeFlowItem {
  final int id;

  final String? info;
  final String? error;
  final FuncCallInfo? funcCallInfo;
  final bool isLibCode;

  bool get isDevCode => !isLibCode;

  CodeFlowType codeFlowType;
  final Object object;

  _CodeFlowItem._methodCallFromStackTrace({
    required this.object,
    required StackTrace currentStackTrace,
    required Map<String, dynamic>? arguments,
    required this.isLibCode,
  })  : codeFlowType = CodeFlowType.methodCalled,
        funcCallInfo = FuncCallInfo.fromCurrentStackTrace(
          currentStackTrace: currentStackTrace,
          arguments: arguments,
        ),
        info = null,
        error = null,
        id = __flowLogItemSEQ++;

  _CodeFlowItem._methodCall({
    required this.object,
    required String methodName,
    required Map<String, dynamic>? arguments,
    required this.isLibCode,
  })  : codeFlowType = CodeFlowType.methodCalled,
        funcCallInfo = FuncCallInfo(funcName: methodName, arguments: arguments),
        info = null,
        error = null,
        id = __flowLogItemSEQ++;

  _CodeFlowItem._info({
    required this.object,
    required this.info,
    required this.isLibCode,
  })  : codeFlowType = CodeFlowType.info,
        funcCallInfo = null,
        error = null,
        id = __flowLogItemSEQ++;

  _CodeFlowItem._error({
    required this.object,
    required this.error,
    required this.isLibCode,
  })  : codeFlowType = CodeFlowType.error,
        funcCallInfo = null,
        info = null,
        id = __flowLogItemSEQ++;

  bool get isLibPublicMethod {
    return isLibCode && isPublicMethodCall();
  }

  bool get isLibPrivateMethod {
    return isLibCode && isPrivateMethodCall();
  }

  bool isBlock() {
    return object is Block;
  }

  bool isBlockFilter() {
    return object is BlockFilter;
  }

  bool isBlockForm() {
    return object is BlockForm;
  }

  bool isOtherClass() {
    return !isBlock() && !isBlockFilter() && !isBlockForm();
  }

  bool isPrivateMethodCall() {
    return isMethodCall() && funcCallInfo!.isPrivateFunc();
  }

  bool isPublicMethodCall() {
    return isMethodCall() && funcCallInfo!.isPublicFunc();
  }

  bool isMethodCall() {
    return funcCallInfo != null && info == null && error == null;
  }

  bool isMethodCallWithTrace() {
    return info == null &&
        error == null &&
        funcCallInfo != null &&
        funcCallInfo!.hasTraceInfo();
  }

  bool isInfo() {
    return info != null;
  }

  bool isError() {
    return error != null;
  }

  Shelf? _getShelf() {
    if (object is Block) {
      return (object as Block).shelf;
    } else if (object is BlockFilter) {
      return (object as BlockFilter).shelf;
    } else if (object is BlockForm) {
      return (object as BlockForm).block.shelf;
    }
    return null;
  }
}
