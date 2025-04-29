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
/// [ITEM_DETAIL]: Item Detail. For example:
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
        EXTRA_FORM_INPUT extends ExtraFormInput>
    extends Block<ID, ITEM_DETAIL, ITEM_DETAIL, FILTER_INPUT, FILTER_CRITERIA,
        EXTRA_FORM_INPUT> {
  SingleItemBlock({
    required super.name,
    required super.description,
    super.hiddenBehavior,
    super.leaveTheFormSafely,
    required super.outsideBroadcast,
    required super.outsideEventReaction,
    required super.filterModelName,
    required super.formModel,
    required super.childBlocks,
  });

  @override
  @nonVirtual
  Future<ApiResult<PageData<ITEM_DETAIL>?>> callApiQuery({
    required Object? parentBlockCurrentItem,
    required FILTER_CRITERIA filterCriteria,
    required PageableData? pageable,
  }) async {
    ApiResult<ITEM_DETAIL>? result = await callApiQuerySingleItem(
      parentBlockCurrentItem: parentBlockCurrentItem,
      filterCriteria: filterCriteria,
    );
    return result.toPageDataResult();
  }

  ///
  /// The query return zero or single Item. For Example:
  ///
  /// ```dart
  /// Future<ApiResult<DepartmentData>> callApiQuerySingleItem({
  ///     required DepartmentIdCriteria filterCriteria,
  /// }) {
  ///    if(filterCriteria.id == null) {
  ///       return ApiResult<DepartmentData>.data(null);
  ///    }
  ///    return departmentApi.findDepartment(filterCriteria.id!);
  /// }
  /// ```
  ///
  Future<ApiResult<ITEM_DETAIL>> callApiQuerySingleItem({
    required Object? parentBlockCurrentItem,
    required FILTER_CRITERIA filterCriteria,
  });
}
