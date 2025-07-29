part of '../_fa_core.dart';

int __flowLogItemSEQ = 0;

class _CodeFlowItem {
  final int id;

  final String? info;
  final AppErrorInfo? errorInfo;
  final FuncCallInfo? funcCallInfo;
  final bool isLibCode;

  bool get isDevCode => !isLibCode;

  CodeFlowType codeFlowType;
  final Object ownerClassInstance;

  _CodeFlowItem._methodCallFromStackTrace({
    required this.ownerClassInstance,
    required StackTrace currentStackTrace,
    required Map<String, dynamic>? arguments,
    required this.isLibCode,
  })  : codeFlowType = CodeFlowType.methodCalled,
        funcCallInfo = FuncCallInfo.fromCurrentStackTrace(
          currentStackTrace: currentStackTrace,
          arguments: arguments,
        ),
        info = null,
        errorInfo = null,
        id = __flowLogItemSEQ++;

  _CodeFlowItem._methodCall({
    required this.ownerClassInstance,
    required String methodName,
    required Map<String, dynamic>? arguments,
    required this.isLibCode,
  })  : codeFlowType = CodeFlowType.methodCalled,
        funcCallInfo = FuncCallInfo(funcName: methodName, arguments: arguments),
        info = null,
        errorInfo = null,
        id = __flowLogItemSEQ++;

  _CodeFlowItem._info({
    required this.ownerClassInstance,
    required this.info,
    required this.isLibCode,
  })  : codeFlowType = CodeFlowType.info,
        funcCallInfo = null,
        errorInfo = null,
        id = __flowLogItemSEQ++;

  _CodeFlowItem._error({
    required this.ownerClassInstance,
    required this.errorInfo,
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
    return ownerClassInstance is Block;
  }

  bool isFilterModel() {
    return ownerClassInstance is FilterModel;
  }

  bool isFormModel() {
    return ownerClassInstance is FormModel;
  }

  bool isOtherClass() {
    return !isBlock() && !isFilterModel() && !isFormModel();
  }

  bool isPrivateMethodCall() {
    return isMethodCall() && funcCallInfo!.isPrivateFunc();
  }

  bool isPublicMethodCall() {
    return isMethodCall() && funcCallInfo!.isPublicFunc();
  }

  bool isMethodCall() {
    return funcCallInfo != null && info == null && errorInfo == null;
  }

  bool isMethodCallWithTrace() {
    return info == null &&
        errorInfo == null &&
        funcCallInfo != null &&
        funcCallInfo!.hasTraceInfo();
  }

  bool isInfo() {
    return info != null;
  }

  bool isError() {
    return errorInfo != null;
  }

  Shelf? _getShelf() {
    if (ownerClassInstance is Block) {
      return (ownerClassInstance as Block).shelf;
    } else if (ownerClassInstance is FilterModel) {
      return (ownerClassInstance as FilterModel).shelf;
    } else if (ownerClassInstance is FormModel) {
      return (ownerClassInstance as FormModel).block.shelf;
    }
    return null;
  }
}
