part of '../core.dart';

class _ServerSideSortModel<ITEM extends Object> extends SortModel<ITEM> {
  _ServerSideSortModel({
    required super.sortModelBuilder,
  }) : super._(sortingSide: SortingSide.server);
}
