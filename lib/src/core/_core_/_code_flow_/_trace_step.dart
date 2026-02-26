part of '../core.dart';

class TraceStep {
  final bool showIconAndLabel;
  final LineFlowType lineFlowType;
  final bool isLibCall;
  final String lineId;
  final String shortDesc;
  final String? note;
  final TipDocument? tipDocument;
  final ErrorInfo? errorInfo;
  List<String>? _extraInfos;

  Map<String, dynamic>? parameters;
  Actionable? actionable;

  List<String>? get extraInfos => _extraInfos;

  TraceStep({
    required this.showIconAndLabel,
    this.lineFlowType = LineFlowType.line,
    required this.isLibCall,
    required this.lineId,
    required this.shortDesc,
    required this.note,
    required this.tipDocument,
    required this.errorInfo,
    required List<String>? extraInfos,
    required this.parameters,
    required this.actionable,
  }) : _extraInfos = extraInfos;

  bool needControlBar() {
    return errorInfo != null || tipDocument != null || hasExtraInfos();
  }

  bool hasExtraInfos() {
    return _extraInfos != null && _extraInfos!.isNotEmpty;
  }

  String getNoteAsHtmlString() {
    if (note == null || note!.isEmpty) {
      return "";
    }
    return "\n $note";
  }

  String getActionableAsHtmlString() {
    if (actionable == null) {
      return "";
    }
    String s = "";
    s += "\n  - <b>@actionable.message</b>: ${actionable!.message}";
    if (actionable!.details != null) {
      s += "\n  - <b>@actionable.details</b>:";
      for (String detail in actionable!.details!) {
        s += "\n    --> $detail";
      }
    }
    s += "\n  - <b>@actionable.errCode</b>: ${actionable!.errCode}";
    return s;
  }

  String getParametersAsHtmlString() {
    if (parameters == null) {
      return "";
    }
    String s = "";
    for (String key in parameters!.keys) {
      dynamic value = parameters![key];
      s += "\n  - @$key: ${debugObjHtml(value)}";
    }
    return s;
  }

  String getText() {
    String sd =
        HtmlUtils.removeTags("$shortDesc${getParametersAsHtmlString()}");
    String s = "$lineId: $sd";
    if (errorInfo != null) {
      s += "\n@errorMessage: ${errorInfo!.errorMessage}";
      if (errorInfo!.errorDetails != null &&
          errorInfo!.errorDetails!.isNotEmpty) {
        s += "\n@errorDetails: ${errorInfo!.errorDetails}";
      }
    }
    return s;
  }
}
