part of '../core.dart';

class _ServerSideSortModel<ITEM extends Object> extends SortModel<ITEM> {
  _ServerSideSortModel({
    required SortModelTemplate<ITEM>? sortModelTemplate,
  }) : super(
          sortingSide: SortingSide.server,
          sortModelTemplate: sortModelTemplate,
        );
}
