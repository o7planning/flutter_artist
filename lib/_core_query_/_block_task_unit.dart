part of '../flutter_artist.dart';

class _BlockTaskUnit extends _TaskUnit {
  BlockTaskUnitName taskUnitName;
  _XBlock xBlock;

  _BlockTaskUnit({
    required this.xBlock,
    required this.taskUnitName,
  });

  void printInfo() {
    print(
        ">>>>> EXECUTE TaskUnit: $taskUnitName - Block: ${xBlock.block.name}");
  }
}
