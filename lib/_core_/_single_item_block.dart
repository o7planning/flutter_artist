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
        SUGGESTED_CRITERIA extends SuggestedCriteria,
        FILTER_CRITERIA extends FilterCriteria,
        SUGGESTED_FORM_DATA extends SuggestedFormData>
    extends Block<ID, ITEM, ITEM_DETAIL, SUGGESTED_CRITERIA, FILTER_CRITERIA,
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
    required FILTER_CRITERIA filterCriteria,
    required PageableData? pageable,
  }) async {
    ApiResult<ITEM>? result = await callApiSingleItemQuery(
      filterCriteria: filterCriteria,
    );
    return result.toPageDataResult();
  }

  Future<ApiResult<ITEM>> callApiSingleItemQuery({
    required FILTER_CRITERIA filterCriteria,
  });
}
