part of '../core.dart';

class LineFlowItem {
  final bool showIconAndLabel;
  final LineFlowType lineFlowType;
  final String lineId;
  final String shortDesc;
  final TipDocument? tipDocument;
  final ErrorInfo? errorInfo;
  List<String>? _extraInfos;

  List<String>? get extraInfos => _extraInfos;

  LineFlowItem({
    required this.showIconAndLabel,
    this.lineFlowType = LineFlowType.line,
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
}
