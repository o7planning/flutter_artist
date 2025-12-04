part of '../core.dart';

class LineFlowItem {
  final bool showIconAndLabel;
  final LineFlowType lineFlowType;
  final bool isLibCall;
  final String lineId;
  final String shortDesc;
  final TipDocument? tipDocument;
  final ErrorInfo? errorInfo;
  List<String>? _extraInfos;

  List<String>? get extraInfos => _extraInfos;

  LineFlowItem({
    required this.showIconAndLabel,
    this.lineFlowType = LineFlowType.line,
    required this.isLibCall,
    required this.lineId,
    required this.shortDesc,
    required this.tipDocument,
    required this.errorInfo,
    required List<String>? extraInfos,
  }) : _extraInfos = extraInfos;

  bool needControlBar() {
    return errorInfo != null || tipDocument != null || hasExtraInfos();
  }

  bool hasExtraInfos() {
    return _extraInfos != null && _extraInfos!.isNotEmpty;
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
