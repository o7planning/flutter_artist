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
        ITEM_DETAIL extends Object,
        FILTER_INPUT extends FilterInput,
        FILTER_CRITERIA extends FilterCriteria,
        EXTRA_INPUT extends ExtraInput>
    extends Block<ID, ITEM_DETAIL, ITEM_DETAIL, FILTER_INPUT, FILTER_CRITERIA,
        EXTRA_INPUT> {
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
  Future<ApiResult<PageData<ITEM_DETAIL>?>> callApiQuery({
    required FILTER_CRITERIA filterCriteria,
    required PageableData? pageable,
  }) async {
    ApiResult<ITEM_DETAIL>? result = await callApiQuerySingleItem(
      filterCriteria: filterCriteria,
    );
    return result.toPageDataResult();
  }

  Future<ApiResult<ITEM_DETAIL>> callApiQuerySingleItem({
    required FILTER_CRITERIA filterCriteria,
  });
}
