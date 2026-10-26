part of '../../../core.dart';

class _XActivityProzessStart extends _XActivityBaseExec {
  _XActivityProzessStart({
    required Prozess prozess,
  }) : super(
          xActivityType: XActivityType.prozessStart,
          activity: prozess.activity,
        ) {
    //
  }
}
