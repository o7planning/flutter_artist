part of '../flutter_artist.dart';

mixin DebugMixin {
  void printFormDebug(String message) {
    if (true) {
      return;
    }
    if (this is Block) {
      Block blk = this as Block;
      print(
          "[FORM DEBUG] [${runtimeType.toString()} - ${blk.dataState.name}]: $message");
    } else if (this is BlockForm) {
      if (this is BlockForm) {
        BlockForm blkForm = this as BlockForm;
        print(
            "[FORM DEBUG] [${runtimeType.toString()} - ${blkForm.dataState.name}]: $message");
      }
    } else {
      if (this is BlockForm) {
        BlockForm blkForm = this as BlockForm;
        print("[FORM DEBUG] [${runtimeType.toString()}]: $message");
      }
    }
  }
}
