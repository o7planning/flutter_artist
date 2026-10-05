part of '../core.dart';

/// Represents an atomic logged operation within an [ExecutionTrace].
class TraceStep {
  final bool showIconAndLabel;
  final TraceStepType traceStepType;
  final String lineId;
  final String shortDesc;
  final String? note;
  final TipDocument? tipDocument;
  final ErrorInfo? errorInfo;
  List<String>? _extraInfos;
  final Map<String, dynamic>? parameters;
  final Actionable? actionable;
  final BlockSyncDiagnosticSnapshot<Comparable>? blockSyncDiagnosticSnapshot;

  List<String>? get extraInfos => _extraInfos;

  TraceStep({
    required this.showIconAndLabel,
    required this.traceStepType,
    required this.lineId,
    required this.shortDesc,
    this.note,
    this.tipDocument,
    this.errorInfo,
    List<String>? extraInfos,
    this.parameters,
    this.actionable,
    this.blockSyncDiagnosticSnapshot,
  }) : _extraInfos = extraInfos;

  bool needControlBar() {
    return errorInfo != null ||
        tipDocument != null ||
        blockSyncDiagnosticSnapshot != null ||
        hasExtraInfos();
  }

  void setExtraInfo(List<String> extraInfos) {
    _extraInfos = extraInfos;
  }

  bool hasExtraInfos() => _extraInfos != null && _extraInfos!.isNotEmpty;

  String getNoteAsHtmlString() {
    if (note == null || note!.isEmpty) return "";
    return "\n $note";
  }

  String getActionableAsHtmlString() {
    if (actionable == null) return "";
    String s = "\n  - <b>@actionable.message</b>: ${actionable!.message}";
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
    if (parameters == null) return "";
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
