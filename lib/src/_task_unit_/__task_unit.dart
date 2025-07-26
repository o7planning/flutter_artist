part of '../../flutter_artist.dart';

@_TaskUnitClassAnnotation()
abstract class _TaskUnit<RESULT> {
  final TaskType taskType;
  final RESULT? result;

  _TaskUnit({
    required this.taskType,
    this.result,
  });

  String getTaskUnitId() {
    return "${getClassName(this)}/${getObjectName()}";
  }

  int get xShelfId;

  String getObjectName();

  Shelf get shelf;

  Object get owner;

  @override
  String toString() {
    return "${getClassName(this)}(${getObjectName()})";
  }
}
