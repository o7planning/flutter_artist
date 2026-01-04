part of '../core.dart';

class _ClientSideSortModel<ITEM extends Object> extends SortModel<ITEM> {
  _ClientSideSortModel({
    required SortModelBuilder<ITEM> super.sortModelBuilder,
  }) : super._(sortingSide: SortingSide.client);
}
