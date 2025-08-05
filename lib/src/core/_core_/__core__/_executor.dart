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
    await FlutterArtist._executeTask(
      showOverlay: showOverlay,
      asyncFunction: () async {
        final Map<String, Shelf> shelfMap = {};
        try {
          while (FlutterArtist.taskUnitQueue.hasNext()) {
            _TaskUnit taskUnit = FlutterArtist.taskUnitQueue.getNextTaskUnit()!;
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
          FlutterArtist.taskUnitQueue.clear();
          rethrow;
        } finally {
          for (Shelf shelf in shelfMap.values) {
            shelf.ui.updateAllUIComponents();
          }
          //
          __executingXShelfId = null;
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
        return;
      } else {
        __executingXShelfId = taskUnit.xShelfId;
      }
    }
    print(
        "\n@~~~~~~> Execute xSid:$__executingXShelfId - Task: ${taskUnit.taskType.name} - ${taskUnit.getObjectName()}");
    //
    shelfMap[taskUnit.shelf.name] = taskUnit.shelf;
    //
    if (taskUnit is _FilterViewChangeTaskUnit) {
      await taskUnit.xFilterModel.filterModel._unitFilterViewChanged(
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
      await taskUnit.xBlock.block._unitSelectItemAsCurrent(
        currentItemSelectionType: taskUnit.currentItemSelectionType,
        newQueriedList: taskUnit.newQueriedList,
        candidateItem: taskUnit.candidateItem,
        thisXBlock: taskUnit.xBlock,
        currentItemSelectionResult:
            taskUnit.taskResult as BlockItemCurrSelectionResult<Object>,
      );
    }
    // Block Delete Item:
    else if (taskUnit is _BlockDeleteItemTaskUnit) {
      await taskUnit.xBlock.block._unitDeleteItem(
        thisXBlock: taskUnit.xBlock,
        item: taskUnit.item,
        deletionResult: taskUnit.taskResult as BlockItemDeletionResult<Object>,
      );
    }
    // Block Delete Items:
    else if (taskUnit is _BlockDeleteItemsTaskUnit) {
      await taskUnit.xBlock.block._unitDeleteItems(
        thisXBlock: taskUnit.xBlock,
        items: taskUnit.items,
        stopIfError: taskUnit.stopIfError,
        deletionResult: taskUnit.taskResult as BlockItemsDeletionResult<Object>,
      );
    }
    // Block QuickCreateItem:
    else if (taskUnit is _BlockQuickCreateItemTaskUnit) {
      await taskUnit.xBlock.block._unitQuickCreateItem(
        thisXBlock: taskUnit.xBlock,
        action: taskUnit.action,
        taskResult: taskUnit.taskResult as BlockQuickItemCreationResult,
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
        taskResult: taskUnit.taskResult as BlockQuickItemUpdateResult,
      );
    }
    // Block Quick Action:
    else if (taskUnit is _BlockQuickActionTaskUnit) {
      await taskUnit.xBlock.block._unitQuickAction(
        thisXBlock: taskUnit.xBlock,
        action: taskUnit.action,
        taskResult: taskUnit.taskResult as BlockQuickActionResult,
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
    // Scalar Quick Action:
    else if (taskUnit is _ScalarQuickActionTaskUnit) {
      await taskUnit.xScalar.scalar._unitQuickAction(
        thisXScalar: taskUnit.xScalar,
        action: taskUnit.action,
        taskResult: taskUnit.taskResult as ScalarQuickActionResult,
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
