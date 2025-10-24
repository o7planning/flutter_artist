part of '../core.dart';

class _ClientSideSortModel<ITEM extends Object> extends SortModel<ITEM> {
  _ClientSideSortModel({
    required SortModelTemplate<ITEM> sortModelTemplate,
  }) : super._(
          sortingSide: SortingSide.client,
          sortModelTemplate: sortModelTemplate,
        );
}
