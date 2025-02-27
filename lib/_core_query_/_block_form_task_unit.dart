part of '../flutter_artist.dart';

class _BlockFormTaskUnit extends _TaskUnit {
  BlockFormTaskUnitName taskUnitName;
  _XBlockForm xBlockForm;

  _BlockFormTaskUnit({
    required this.xBlockForm,
    required this.taskUnitName,
  });

  void printInfo() {
    print(
        ">>>>> EXECUTE TaskUnit: $taskUnitName - BlockForm: ${xBlockForm.blockForm.block.name}");
  }
}
