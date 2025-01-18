part of '../flutter_artist.dart';

///
/// [ID] is Id type of Item. For example: [String].
///
/// [ITEM] is item. For example:
/// ```dart
/// class EmployeeInfo {
///     int id;
///     String name;
/// }
/// ```
/// [D]: Item Detail. For example:
/// ```dart
///  class EmployeeData  {
///     int id;
///     String name;
///     String email;
///     String phoneNumber;
/// }
/// ```
///
abstract class SingleItemBlock<
        ID extends Object,
        ITEM extends Object,
        ITEM_DETAIL extends Object,
        FILTER_SNAPSHOT extends FilterSnapshot,
        SUGGESTED_FILTER_DATA extends SuggestedFilterData,
        SUGGESTED_FORM_DATA extends SuggestedFormData>
    extends Block<ID, ITEM, ITEM_DETAIL, SUGGESTED_FILTER_DATA, FILTER_SNAPSHOT,
        SUGGESTED_FORM_DATA> {
  SingleItemBlock({
    required super.name,
    required super.description,
    super.hiddenBehavior,
    required super.fireEvent,
    required super.listenItemTypes,
    required super.dataFilterName,
    required super.blockForm,
    required super.childBlocks,
  });

  @override
  @nonVirtual
  Future<ApiResult<PageData<ITEM>?>> callApiQuery({
    required FILTER_SNAPSHOT filterSnapshot,
    required PageableData? pageable,
  }) async {
    ApiResult<ITEM>? result = await callApiSingleItemQuery(
      filterSnapshot: filterSnapshot,
    );
    return result.toPageDataResult();
  }

  Future<ApiResult<ITEM>> callApiSingleItemQuery({
    required FILTER_SNAPSHOT filterSnapshot,
  });
}
