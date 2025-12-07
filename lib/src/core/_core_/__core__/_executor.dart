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
          while (true) {
            bool hasNext = FlutterArtist._rootQueue.hasNext();
            if (!hasNext) {
              FlutterArtist.storage._queuedEventManager
                  .addTaskUnitForQueuedEvents();
              hasNext = FlutterArtist._rootQueue.hasNext();
              if (!hasNext) {
                break;
              }
            }
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
      shelfMap[taskUnit.shelf.name] = taskUnit.shelf;
    } else {
      __executingXShelfId = -1000;
    }
    //
    final masterFlowItem = FlutterArtist.codeFlowLogger._addTaskCall(
      ownerClassInstance: taskUnit.owner,
      taskType: taskUnit.taskType,
    );
    //
    if (taskUnit is _ActivityTaskUnit) {
      // TODO: Remove in next version.
      taskUnit.xActivity.activity._masterFlowItem = masterFlowItem;
      //
      await taskUnit.xActivity.activity._unitExecuteActivity(
        taskType: taskUnit.taskType,
        thisXActivity: taskUnit.xActivity,
      );
    }
    // Storage Silent Action TaskUnit:
    else if (taskUnit is _StorageSilentActionTaskUnit) {
      await FlutterArtist.storage._unitSilentAction(
        masterFlowItem: masterFlowItem,
        taskType: taskUnit.taskType,
        action: taskUnit.action,
        taskResult: taskUnit.taskResult,
      );
    }
    // Filter FilterModel:
    else if (taskUnit is _FilterModelLoadDataTaskUnit) {
      await taskUnit.xFilterModel.filterModel._unitLoadFilterData(
        masterFlowItem: masterFlowItem,
        taskType: taskUnit.taskType,
        thisXFilterModel: taskUnit.xFilterModel,
        taskResult: taskUnit.taskResult as FilterModelDataLoadResult,
      );
    }
    // FilterPanel Change:
    else if (taskUnit is _FilterPanelChangeTaskUnit) {
      await taskUnit.xFilterModel.filterModel._unitFilterPanelChanged(
        masterFlowItem: masterFlowItem,
        taskType: taskUnit.taskType,
        xFilterModel: taskUnit.xFilterModel,
      );
    }
    //
    else if (taskUnit is _FormViewChangeTaskUnit) {
      await taskUnit.xFormModel.formModel._unitFormViewChanged(
        masterFlowItem: masterFlowItem,
        taskType: taskUnit.taskType,
        xFormModel: taskUnit.xFormModel,
      );
    }
    // Block Clear Current:
    else if (taskUnit is _BlockClearCurrentTaskUnit) {
      await taskUnit.xBlock.block._unitClearCurrent(
        masterFlowItem: masterFlowItem,
        taskType: taskUnit.taskType,
        thisXBlock: taskUnit.xBlock,
      );
    }
    // Block Clear All Items:
    else if (taskUnit is _BlockClearanceTaskUnit) {
      await taskUnit.xBlock.block._unitClearance(
        masterFlowItem: masterFlowItem,
        taskType: taskUnit.taskType,
        thisXBlock: taskUnit.xBlock,
      );
    }
    // Block Query:
    else if (taskUnit is _BlockQueryTaskUnit) {
      await taskUnit.xBlock.block._unitQuery(
        masterFlowItem: masterFlowItem,
        taskType: taskUnit.taskType,
        thisXBlock: taskUnit.xBlock,
      );
    }
    // Block PrepareCreate:
    else if (taskUnit is _BlockPrepareFormToCreateItemTaskUnit) {
      await taskUnit.xBlock.block._unitPrepareFormToCreateItem(
        masterFlowItem: masterFlowItem,
        taskType: taskUnit.taskType,
        thisXBlock: taskUnit.xBlock,
        initDirty: taskUnit.initDirty,
        formInput: taskUnit.formInput,
        navigate: taskUnit.navigate,
      );
    }
    // Block Select Item as Current:
    else if (taskUnit is _BlockSelectAsCurrentTaskUnit) {
      await taskUnit.xBlock.block._unitSetItemAsCurrent(
        masterFlowItem: masterFlowItem,
        taskType: taskUnit.taskType,
        currentItemSelectionType: taskUnit.currentItemSelectionType,
        newQueriedList: taskUnit.newQueriedList,
        candidateItem: taskUnit.candidateItem,
        thisXBlock: taskUnit.xBlock,
        currentItemSelectionResult:
            taskUnit.taskResult as BlockItemCurrSelectionResult<Identifiable>,
      );
    }
    // Block Delete Item:
    else if (taskUnit is _BlockItemDeletionTaskUnit) {
      await taskUnit.xBlock.block._unitDeleteItem(
        masterFlowItem: masterFlowItem,
        taskType: taskUnit.taskType,
        thisXBlock: taskUnit.xBlock,
        item: taskUnit.item,
        deletionResult:
            taskUnit.taskResult as BlockItemDeletionResult<Identifiable>,
      );
    }
    // Block Delete Items:
    else if (taskUnit is _BlockMultiItemsDeletionTaskUnit) {
      await taskUnit.xBlock.block._unitDeleteItems(
        masterFlowItem: masterFlowItem,
        taskType: taskUnit.taskType,
        thisXBlock: taskUnit.xBlock,
        items: taskUnit.items,
        stopIfError: taskUnit.stopIfError,
        deletionResult:
            taskUnit.taskResult as BlockItemsDeletionResult<Identifiable>,
      );
    }
    // Block QuickCreateItem:
    else if (taskUnit is _BlockQuickItemCreationTaskUnit) {
      await taskUnit.xBlock.block._unitQuickCreateItem(
        masterFlowItem: masterFlowItem,
        taskType: taskUnit.taskType,
        thisXBlock: taskUnit.xBlock,
        action: taskUnit.action,
        taskResult: taskUnit.taskResult as BlockQuickItemCreationResult,
      );
    }
    // Block SilentCreateItem:
    else if (taskUnit is _BlockSilentItemCreationTaskUnit) {
      await taskUnit.xBlock.block._unitSilentCreateItem(
        masterFlowItem: masterFlowItem,
        taskType: taskUnit.taskType,
        thisXBlock: taskUnit.xBlock,
        action: taskUnit.action,
        taskResult: taskUnit.taskResult as BlockSilentItemCreationResult,
      );
    }
    // Block QuickCreateMultiItems:
    else if (taskUnit is _BlockQuickMultiItemsCreationTaskUnit) {
      await taskUnit.xBlock.block._unitQuickCreateMultiItems(
        masterFlowItem: masterFlowItem,
        taskType: taskUnit.taskType,
        thisXBlock: taskUnit.xBlock,
        action: taskUnit.action,
      );
    }
    // Block QuickUpdateItem:
    else if (taskUnit is _BlockQuickItemUpdateTaskUnit) {
      await taskUnit.xBlock.block._unitQuickUpdateItem(
        masterFlowItem: masterFlowItem,
        taskType: taskUnit.taskType,
        thisXBlock: taskUnit.xBlock,
        action: taskUnit.action,
        taskResult: taskUnit.taskResult as BlockQuickItemUpdateResult,
      );
    }
    // Block SilentUpdateItem:
    else if (taskUnit is _BlockSilentItemUpdateTaskUnit) {
      await taskUnit.xBlock.block._unitSilentUpdateItem(
        masterFlowItem: masterFlowItem,
        taskType: taskUnit.taskType,
        thisXBlock: taskUnit.xBlock,
        action: taskUnit.action,
        taskResult: taskUnit.taskResult as BlockSilentItemUpdateResult,
      );
    }
    // Block Quick Action:
    else if (taskUnit is _BlockSilentActionTaskUnit) {
      await taskUnit.xBlock.block._unitSilentAction(
        masterFlowItem: masterFlowItem,
        taskType: taskUnit.taskType,
        thisXBlock: taskUnit.xBlock,
        action: taskUnit.action,
        taskResult: taskUnit.taskResult as BlockSilentActionResult,
      );
    }
    // FormModel LoadForm:
    else if (taskUnit is _FormModelLoadDataTaskUnit) {
      await taskUnit.xFormModel.formModel._unitLoadFormData(
        masterFlowItem: masterFlowItem,
        taskType: taskUnit.taskType,
        thisXFormModel: taskUnit.xFormModel,
        taskResult: taskUnit.taskResult as FormModelDataLoadResult,
      );
    }
    // FormModel Save:
    else if (taskUnit is _FormModelSaveFormTaskUnit) {
      await taskUnit.xFormModel.formModel._unitSaveForm(
        masterFlowItem: masterFlowItem,
        taskType: taskUnit.taskType,
        thisXFormModel: taskUnit.xFormModel,
        taskResult: taskUnit.taskResult as FormSaveResult,
      );
    }
    // FormModel QuickFormInputAction:
    else if (taskUnit is _FormModelAutoEnterFormFieldsTaskUnit) {
      await taskUnit.xFormModel.formModel._unitEnterFormFields(
        masterFlowItem: masterFlowItem,
        taskType: taskUnit.taskType,
        thisXFormModel: taskUnit.xFormModel,
        formInput: taskUnit.formInput,
      );
    }
    // Scalar:
    else if (taskUnit is _ScalarQueryTaskUnit) {
      await taskUnit.xScalar.scalar._unitQuery(
        masterFlowItem: masterFlowItem,
        taskType: taskUnit.taskType,
        thisXScalar: taskUnit.xScalar,
      );
    }
    // Scalar Clear Value:
    else if (taskUnit is _ScalarClearanceTaskUnit) {
      await taskUnit.xScalar.scalar._unitClearance(
        masterFlowItem: masterFlowItem,
        taskType: taskUnit.taskType,
        thisXScalar: taskUnit.xScalar,
      );
    }
    // Scalar Quick Action:
    else if (taskUnit is _ScalarLoadExtraDataQuickActionTaskUnit) {
      await taskUnit.xScalar.scalar._unitLoadExtraDataQuickAction(
        masterFlowItem: masterFlowItem,
        taskType: taskUnit.taskType,
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
