part of '../core.dart';

class LineFlowItem {
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
 
  List<String>? get extraInfos => _extraInfos;

  LineFlowItem({
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

  String getParametersAsHtmlString() {
    if (parameters == null) {
      return "";
    }
    String s = "";
    for (String key in parameters!.keys) {
      dynamic value = parameters![key];
      s += "\n  - @$key: ${_debugObjHtml(value)}";
    }
    return s;
  }

  void printToConsole() {
    String sd = shortDesc
        .replaceAll("<b>", "")
        .replaceAll("</b>", "")
        .replaceAll("<i>", "")
        .replaceAll("</i>", "")
        .replaceAll("<u>", "")
        .replaceAll("</u>", "");
    print("\n$lineId: $sd");
    if (errorInfo != null) {
      print("@errorMessage: ${errorInfo!.errorMessage}");
      if (errorInfo!.errorDetails != null) {
        print("@errorDetails: ${errorInfo!.errorDetails}");
      }
    }
  }
}
