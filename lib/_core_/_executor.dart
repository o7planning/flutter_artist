part of '../flutter_artist.dart';

class _Executor {
  int __taskUnitCount = 0;
  int? __executingXShelfId;

  int get taskUnitCount => __taskUnitCount;

  int? get executingXShelfId => __executingXShelfId;

  final Map<_TaskProgressBuilderState, bool> _taskProgressViewWidgetStates = {};

  // ***************************************************************************
  // ***************************************************************************

  _Executor();

  // ***************************************************************************
  // ***************************************************************************

  bool get isBusy {
    return __executingXShelfId != null &&
        FlutterArtist.taskUnitQueue.isNotEmpty;
  }

  bool get isFree => !isBusy;

  // ***************************************************************************
  // ***************************************************************************

  Future<void> _executeTaskUnitQueue({bool showOverlay = true}) async {
    if (__executingXShelfId != null) {
      return;
    }
    await FlutterArtist.executeTask(
      showOverlay: showOverlay,
      asyncFunction: () async {
        Map<String, Shelf> shelfMap = {};
        while (FlutterArtist.taskUnitQueue.hasNext()) {
          _TaskUnit taskUnit = FlutterArtist.taskUnitQueue.getNextTaskUnit()!;
          //
          _updateProgressViews(
            owner: taskUnit.owner,
            taskType: taskUnit.taskType,
          );
          //
          if (__executingXShelfId == null) {
            __executingXShelfId = taskUnit.xShelfId;
          } else {
            if (__executingXShelfId! > taskUnit.xShelfId) {
              // Ignore taskUnit.
              continue;
            } else {
              __executingXShelfId = taskUnit.xShelfId;
            }
          }
          print(
              "\n@~~~~~~> Execute xSid:$__executingXShelfId - Task: $taskUnit");
          //
          shelfMap[taskUnit.shelf.name] = taskUnit.shelf;
          //
          if (taskUnit is _FilterViewChangeTaskUnit) {
            await taskUnit.xFilterModel.filterModel._unitFilterViewChanged(
              xFilterModel: taskUnit.xFilterModel,
            );
          }
          //
          if (taskUnit is _FormViewChangeTaskUnit) {
            await taskUnit.xFormModel.formModel._unitFormViewChanged(
              xFormModel: taskUnit.xFormModel,
            );
          }
          // Block Clear Current:
          else if (taskUnit is _BlockClearCurrentTaskUnit) {
            await taskUnit.xBlock.block._unitClearCurrent(
              thisXBlock: taskUnit.xBlock,
            );
          }
          // Block Query:
          else if (taskUnit is _BlockQueryTaskUnit) {
            await taskUnit.xBlock.block._unitQuery(
              thisXBlock: taskUnit.xBlock,
            );
          }
          // Block PrepareCreate:
          else if (taskUnit is _BlockPrepareToCreateItemTaskUnit) {
            await taskUnit.xBlock.block._unitPrepareToCreateItem(
              thisXBlock: taskUnit.xBlock,
              initDirty: taskUnit.initDirty,
              extraFormInput: taskUnit.extraFormInput,
              navigate: taskUnit.navigate,
            );
          }
          // Block Select Item as Current:
          else if (taskUnit is _BlockSelectAsCurrentTaskUnit) {
            await taskUnit.xBlock.block._unitSelectItemAsCurrent(
              currentItemSelectionType: taskUnit.currentItemSelectionType,
              newQueriedList: taskUnit.newQueriedList,
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
          // Block QuickCreateMultiItems:
          else if (taskUnit is _BlockQuickCreateMultiItemsTaskUnit) {
            await taskUnit.xBlock.block._unitQuickCreateMultiItems(
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
          // FormModel QuickExtraFormInputAction:
          else if (taskUnit is _FormModelAutoEnterFormFieldsTaskUnit) {
            await taskUnit.xFormModel.formModel._unitQuickExtraFormInput(
              thisXFormModel: taskUnit.xFormModel,
              extraFormInput: taskUnit.extraFormInput,
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
        __taskUnitCount++;
        //
        _updateProgressViews(
          owner: null,
          taskType: null,
        );
        for (Shelf shelf in shelfMap.values) {
          shelf.updateAllUIComponents();
        }
        //
        __executingXShelfId = null;
      },
    );
  }

  void _updateProgressViews({
    required Object? owner,
    required TaskType? taskType,
  }) {
    for (_TaskProgressBuilderState state in [
      ..._taskProgressViewWidgetStates.keys
    ]) {
      if (!state.mounted) {
        _taskProgressViewWidgetStates.remove(state);
        continue;
      }
      bool onProgress = owner == null || taskType == null
          ? false
          : state.isMatches(
              owner: owner,
              taskType: taskType,
            );
      //
      state.onProgress = onProgress;
      state.refreshState(force: true);
    }
  }

  void _addTaskProgressViewWidgetState({
    required _TaskProgressBuilderState widgetState,
    required bool isShowing,
  }) {
    _taskProgressViewWidgetStates[widgetState] = isShowing;
  }

  void _removeTaskProgressViewWidgetState({
    required _TaskProgressBuilderState widgetState,
  }) {
    _taskProgressViewWidgetStates.remove(widgetState);
  }
}
