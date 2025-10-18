part of '../core.dart';

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
    return __executingXShelfId != null && FlutterArtist._rootQueue.isNotEmpty;
  }

  bool get isFree => !isBusy;

  // ***************************************************************************
  // ***************************************************************************

  Future<void> _executeTaskUnitQueue({bool showOverlay = true}) async {
    if (__executingXShelfId != null) {
      // (This code causes an Error in FilterPanel).
      // print("\n\nDevelopment Error - Illegal status - @@ executingXShelfId: $__executingXShelfId");
      // throw FatalAppError(errorMessage: "Development Error - Illegal status.");
      return;
    }
    bool showOverlay2 = showOverlay;
    if (FlutterArtist.debugOptions.showTaskUnitQueue) {
      showOverlay2 = false;
    }
    await FlutterArtist._executeTask(
      showOverlay: showOverlay2,
      asyncFunction: () async {
        final Map<String, Shelf> shelfMap = {};
        try {
          while (FlutterArtist._rootQueue.hasNext()) {
            if (FlutterArtist.debugOptions.showTaskUnitQueue) {
              BuildContext context = FlutterArtist.adapter.getCurrentContext();
              await DebugExecutorDialog.showDebugExecutorDialog(
                context: context,
              );
            }
            //
            _TaskUnit taskUnit = FlutterArtist._rootQueue.getNextTaskUnit()!;
            //
            await __executeTaskUnit(taskUnit: taskUnit, shelfMap: shelfMap);
          }
          //
          __taskUnitCount++;
          //
          _updateProgressViews(
            owner: null,
            taskType: null,
          );
        }
        // May be AppError (FatalException).
        catch (e, stackTrace) {
          FlutterArtist._rootQueue.clear();
          rethrow;
        } finally {
          for (Shelf shelf in shelfMap.values) {
            shelf.ui.updateAllUIComponents();
          }
          //
          __executingXShelfId = null;
          FlutterArtist.storage.__freeze._resetFreezeTemporarilyOnce();
        }
      },
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  Future<void> __executeTaskUnit({
    required _TaskUnit taskUnit,
    required Map<String, Shelf> shelfMap,
  }) async {
    if (taskUnit is _STaskUnit) {
      _updateProgressViews(
        owner: taskUnit.owner,
        taskType: taskUnit.taskType,
      );
      //
      __executingXShelfId = taskUnit.xShelfId;
      //
      print("\n@~~~~~~> Executing xShelfId:$__executingXShelfId"
          " - [${taskUnit.xShelf.xShelfType.name}]"
          " - Task: ${taskUnit.taskType.name}"
          " - ${taskUnit.getObjectName()}");
      //
      shelfMap[taskUnit.shelf.name] = taskUnit.shelf;
    } else {
      __executingXShelfId = -1000;
    }
    // Storage Silent Action TaskUnit:
    if (taskUnit is _StorageSilentActionTaskUnit) {
      await FlutterArtist.storage._unitSilentAction(
        action: taskUnit.action,
        taskResult: taskUnit.taskResult as StorageSilentActionResult,
      );
    }
    // FilterPanel Change:
    else if (taskUnit is _FilterPanelChangeTaskUnit) {
      await taskUnit.xFilterModel.filterModel._unitFilterPanelChanged(
        xFilterModel: taskUnit.xFilterModel,
      );
    }
    //
    else if (taskUnit is _FormViewChangeTaskUnit) {
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
    // Block Clear All Items:
    else if (taskUnit is _BlockClearanceTaskUnit) {
      await taskUnit.xBlock.block._unitClearance(
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
    else if (taskUnit is _BlockPrepareFormToCreateItemTaskUnit) {
      await taskUnit.xBlock.block._unitPrepareFormToCreateItem(
        thisXBlock: taskUnit.xBlock,
        initDirty: taskUnit.initDirty,
        extraFormInput: taskUnit.extraFormInput,
        navigate: taskUnit.navigate,
      );
    }
    // Block Select Item as Current:
    else if (taskUnit is _BlockSelectAsCurrentTaskUnit) {
      await taskUnit.xBlock.block._unitSetItemAsCurrent(
        currentItemSelectionType: taskUnit.currentItemSelectionType,
        newQueriedList: taskUnit.newQueriedList,
        candidateItem: taskUnit.candidateItem,
        thisXBlock: taskUnit.xBlock,
        currentItemSelectionResult:
            taskUnit.taskResult as BlockItemCurrSelectionResult<Object>,
      );
    }
    // Block Delete Item:
    else if (taskUnit is _BlockItemDeletionTaskUnit) {
      await taskUnit.xBlock.block._unitDeleteItem(
        thisXBlock: taskUnit.xBlock,
        item: taskUnit.item,
        deletionResult: taskUnit.taskResult as BlockItemDeletionResult<Object>,
      );
    }
    // Block Delete Items:
    else if (taskUnit is _BlockMultiItemsDeletionTaskUnit) {
      await taskUnit.xBlock.block._unitDeleteItems(
        thisXBlock: taskUnit.xBlock,
        items: taskUnit.items,
        stopIfError: taskUnit.stopIfError,
        deletionResult: taskUnit.taskResult as BlockItemsDeletionResult<Object>,
      );
    }
    // Block QuickCreateItem:
    else if (taskUnit is _BlockQuickItemCreationTaskUnit) {
      await taskUnit.xBlock.block._unitQuickCreateItem(
        thisXBlock: taskUnit.xBlock,
        action: taskUnit.action,
        taskResult: taskUnit.taskResult as BlockQuickItemCreationResult,
      );
    }
    // Block SilentCreateItem:
    else if (taskUnit is _BlockSilentItemCreationTaskUnit) {
      await taskUnit.xBlock.block._unitSilentCreateItem(
        thisXBlock: taskUnit.xBlock,
        action: taskUnit.action,
        taskResult: taskUnit.taskResult as BlockSilentItemCreationResult,
      );
    }
    // Block QuickCreateMultiItems:
    else if (taskUnit is _BlockQuickMultiItemsCreationTaskUnit) {
      await taskUnit.xBlock.block._unitQuickCreateMultiItems(
        thisXBlock: taskUnit.xBlock,
        action: taskUnit.action,
      );
    }
    // Block QuickUpdateItem:
    else if (taskUnit is _BlockQuickItemUpdateTaskUnit) {
      await taskUnit.xBlock.block._unitQuickUpdateItem(
        thisXBlock: taskUnit.xBlock,
        action: taskUnit.action,
        taskResult: taskUnit.taskResult as BlockQuickItemUpdateResult,
      );
    }
    // Block SilentUpdateItem:
    else if (taskUnit is _BlockSilentItemUpdateTaskUnit) {
      await taskUnit.xBlock.block._unitSilentUpdateItem(
        thisXBlock: taskUnit.xBlock,
        action: taskUnit.action,
        taskResult: taskUnit.taskResult as BlockSilentItemUpdateResult,
      );
    }
    // Block Quick Action:
    else if (taskUnit is _BlockSilentActionTaskUnit) {
      await taskUnit.xBlock.block._unitSilentAction(
        thisXBlock: taskUnit.xBlock,
        action: taskUnit.action,
        taskResult: taskUnit.taskResult as BlockSilentActionResult,
      );
    }
    // FormModel LoadForm:
    else if (taskUnit is _FormModelLoadFormTaskUnit) {
      await taskUnit.xFormModel.formModel._unitLoadFormData(
        thisXFormModel: taskUnit.xFormModel,
        taskResult: taskUnit.taskResult as FormModelDataLoadResult,
      );
    }
    // FormModel Save:
    else if (taskUnit is _FormModelSaveFormTaskUnit) {
      await taskUnit.xFormModel.formModel._unitSaveForm(
        thisXFormModel: taskUnit.xFormModel,
        taskResult: taskUnit.taskResult as FormSaveResult,
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
    // Scalar Clear Value:
    else if (taskUnit is _ScalarClearanceTaskUnit) {
      await taskUnit.xScalar.scalar._unitClearance(
        thisXScalar: taskUnit.xScalar,
      );
    }
    // Scalar Quick Action:
    else if (taskUnit is _ScalarLoadExtraDataQuickActionTaskUnit) {
      await taskUnit.xScalar.scalar._unitLoadExtraDataQuickAction(
        thisXScalar: taskUnit.xScalar,
        action: taskUnit.action,
        afterQuickAction: taskUnit.afterQuickAction,
      );
    }
  }

  // ***************************************************************************
  // ***************************************************************************

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
