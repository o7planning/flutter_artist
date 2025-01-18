part of '../flutter_artist.dart';

///
/// [ID] is Id type of Item. For example: [String].
///
/// [I] is item. For example:
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
    I extends Object,
    D extends Object,
    S extends FilterSnapshot,
    SF extends SuggestedFormData> extends Block<ID, I, D, S, SF> {
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
  Future<ApiResult<PageData<I>?>> callApiQuery({
    required S filterSnapshot,
    required PageableData? pageable,
  }) async {
    ApiResult<I>? result = await callApiSingleItemQuery(
      filterSnapshot: filterSnapshot,
    );
    return result.toPageDataResult();
  }

  Future<ApiResult<I>> callApiSingleItemQuery({
    required S filterSnapshot,
  });
}
