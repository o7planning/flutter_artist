part of '../flutter_artist.dart';

class _Executor {
  int _taskUnitCount = 0;
  int? _executingXShelfId;

  // ***************************************************************************
  // ***************************************************************************

  _Executor();

  // ***************************************************************************
  // ***************************************************************************

  Future<void> _executeTaskUnitQueue() async {
    if (_executingXShelfId != null) {
      throw "Executor is busy";
    }

    await FlutterArtist.executeTask(asyncFunction: () async {
      Map<String, Shelf> shelfMap = {};
      while (FlutterArtist.taskUnitQueue.hasNext()) {
        _TaskUnit taskUnit = FlutterArtist.taskUnitQueue.getNextTaskUnit()!;
        _executingXShelfId = taskUnit.xShelfId;
        //
        shelfMap[taskUnit.shelf.name] = taskUnit.shelf;
        print("~~~~~~~~~~~~> xSid:$_executingXShelfId - Task Unit: $taskUnit");
        //
        if (taskUnit is _FilterViewChangeTaskUnit) {
          await taskUnit.xFilterModel.filterModel._unitFilterViewChanged(
            xFilterModel: taskUnit.xFilterModel,
          );
        }
        // Block Query:
        else if (taskUnit is _BlockQueryTaskUnit) {
          await taskUnit.xBlock.block._unitQuery(
            thisXBlock: taskUnit.xBlock,
          );
        }
        // Block Select Item as Current:
        else if (taskUnit is _BlockSelectAsCurrentTaskUnit) {
          await taskUnit.xBlock.block._unitSelectItemAsCurrent(
            currentItemSelectionType: taskUnit.currentItemSelectionType,
            candidateItem: taskUnit.candidateItem,
            thisXBlock: taskUnit.xBlock,
          );
        }
        // Block Delete Item:
        else if (taskUnit is _BlockDeleteItemTaskUnit) {
          await taskUnit.xBlock.block._unitDeleteItem(
            thisXBlock: taskUnit.xBlock,
            item: taskUnit.item,
          );
        }
        // Block QuickCreateItem:
        else if (taskUnit is _BlockQuickCreateItemTaskUnit) {
          await taskUnit.xBlock.block._unitQuickCreateItem(
            thisXBlock: taskUnit.xBlock,
            action: taskUnit.action,
          );
        }
        // Block QuickUpdateItem:
        else if (taskUnit is _BlockQuickUpdateItemTaskUnit) {
          await taskUnit.xBlock.block._unitQuickUpdateItem(
            thisXBlock: taskUnit.xBlock,
            action: taskUnit.action,
          );
        }
        // Block QuickAction:
        else if (taskUnit is _BlockQuickActionTaskUnit) {
          await taskUnit.xBlock.block._unitQuickAction(
            thisXBlock: taskUnit.xBlock,
            action: taskUnit.action,
            afterQuickAction: taskUnit.afterQuickAction,
          );
        }
        // Block QuickChildBlockItemsAction:
        else if (taskUnit is _BlockQuickChildBlockItemsTaskUnit) {
          await taskUnit.xBlock.block._unitQuickChildBlockItemsAction(
            thisXBlock: taskUnit.xBlock,
            action: taskUnit.action,
          );
        }
        // FormModel LoadForm:
        else if (taskUnit is _FormModelLoadFormTaskUnit) {
          await taskUnit.xFormModel.formModel._unitLoadForm(
            thisXFormModel: taskUnit.xFormModel,
          );
        }
        // FormModel Save:
        else if (taskUnit is _SaveFormSaveTaskUnit) {
          await taskUnit.xFormModel.formModel._unitSaveForm(
            thisXFormModel: taskUnit.xFormModel,
          );
        }
        // Scalar:
        else if (taskUnit is _ScalarQueryTaskUnit) {
          await taskUnit.xScalar.scalar._unitQuery(
            thisXScalar: taskUnit.xScalar,
          );
        }
        // Scalar QuickAction:
        else if (taskUnit is _ScalarQuickActionTaskUnit) {
          await taskUnit.xScalar.scalar._unitQuickAction(
            thisXScalar: taskUnit.xScalar,
            action: taskUnit.action,
            afterQuickAction: taskUnit.afterQuickAction,
          );
        }
      }
      //
      _taskUnitCount++;
      //
      for (Shelf shelf in shelfMap.values) {
        shelf.updateAllUIComponents();
      }
      //
      _executingXShelfId = null;
    });
  }
}
