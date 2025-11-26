part of '../core.dart';

class LineFlowItem {
  final LineFlowType lineFlowType;
  final String lineId;
  final String shortDesc;
  final TipDocument? tipDocument;
  final ErrorInfo? errorInfo;

  LineFlowItem({
    this.lineFlowType = LineFlowType.line,
    required this.lineId,
    required this.shortDesc,
    required this.tipDocument,
    required this.errorInfo,
  });
}
