part of '../flutter_artist.dart';

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
abstract class SingleItemBlock<I extends Object, D extends Object,
    S extends FilterSnapshot> extends Block<I, D, S> {
  SingleItemBlock({
    required super.name,
    required super.description,
    super.hiddenBehavior,
    required super.blockFilterName,
    required super.blockForm,
    required super.childBlocks,
    required super.listenForChangesFrom,
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
