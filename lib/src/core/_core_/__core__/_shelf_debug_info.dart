part of '../core.dart';

class _ShelfDebugInfo {
  final Shelf _shelf;

  int _initQueryExecutionUnitsCount = 0;

  int get initQueryExecutionCount => _initQueryExecutionUnitsCount;

  _ShelfDebugInfo({required Shelf shelf}) : _shelf = shelf;
}
