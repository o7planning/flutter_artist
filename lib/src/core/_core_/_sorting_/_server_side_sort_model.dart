part of '../core.dart';

class _ServerSideSortModel<ITEM extends Object> extends SortModel<ITEM> {
  _ServerSideSortModel({
    required SortModelTemplate<ITEM>? sortModelTemplate,
  }) : super._(
          sortingSide: SortingSide.server,
          sortModelTemplate: sortModelTemplate,
        );
}
