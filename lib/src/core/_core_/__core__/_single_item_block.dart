part of '../core.dart';

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
        ID extends Object, //
        ITEM_DETAIL extends Identifiable<ID>,
        FILTER_INPUT extends FilterInput,
        FILTER_CRITERIA extends FilterCriteria,
        FORM_RELATED_DATA extends FormRelatedData,
        FORM_INPUT extends FormInput> //
    extends Block<
        ID, //
        ITEM_DETAIL,
        ITEM_DETAIL,
        FILTER_INPUT,
        FILTER_CRITERIA,
        FORM_RELATED_DATA,
        FORM_INPUT> {
  SingleItemBlock({
    required super.name,
    required super.description,
    required super.config,
    required super.filterModelName,
    required super.formModel,
    required super.childBlocks,
  }) : super(sortModelBuilder: null);

  @override
  @nonVirtual
  Future<ApiResult<PageData<ITEM_DETAIL>?>> callApiQuery({
    required Object? parentBlockCurrentItem,
    required FILTER_CRITERIA filterCriteria,
    required SortableCriteria? sortableCriteria,
    required Pageable? pageable,
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

  @override
  ITEM_DETAIL convertItemDetailToItem({required ITEM_DETAIL itemDetail}) {
    return itemDetail;
  }
}
