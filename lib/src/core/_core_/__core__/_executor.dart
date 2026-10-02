part of '../core.dart';

class _Executor {
  int __executionUnitCount = 0;
  int? __executingXModuleId;

  int get executionUnitCount => __executionUnitCount;

  int? get executingXModuleId => __executingXModuleId;

  final Map<_ExecutionProgressBuilderState, bool>
      _executionProgressViewWidgetStates = {};

  // ***************************************************************************
  // ***************************************************************************

  _Executor();

  // ***************************************************************************
  // ***************************************************************************

  bool get isBusy {
    if (__executingXModuleId == null) {
      return false;
    }
    final _ExecutionUnit? unit = FlutterArtist._rootQueue
        .getNextExecutionUnit(removeEmptyRootQuery: false);
    return unit != null;
  }

  bool get isFree => !isBusy;

  // ***************************************************************************
  // ***************************************************************************

  Future<void> _executeExecutionUnitQueue({bool showOverlay = true}) async {
    if (__executingXModuleId != null) {
      return;
    }
    bool applyShowOverlay = showOverlay;
    if (FlutterArtist.appConfig.debugOptions.showExecutionUnitQueue) {
      applyShowOverlay = false;
    }
    bool pendingEventProcessed = false;
    await FlutterArtist._executeExecutionUnit(
      showOverlay: applyShowOverlay,
      asyncFunction: () async {
        // Executed FeatureModule Map:
        final Map<String, FeatureModule> executedModuleMap = {};
        print("BEGIN executor: _rootQueue: ${FlutterArtist._rootQueue}");
        try {
          while (true) {
            _ExecutionUnit? executionUnit =
                FlutterArtist._rootQueue.getNextExecutionUnit(
              removeEmptyRootQuery: true,
            );
            //
            if (executionUnit == null) {
              if (pendingEventProcessed) {
                break;
              }
              pendingEventProcessed = true;
              final Set<String> excludeModuleNames =
                  executedModuleMap.keys.toSet();
              //
              FlutterArtist.desk._reactionProcessor.addReactionExecutionUnits(
                excludeModuleNames: excludeModuleNames,
              );
              executionUnit = FlutterArtist._rootQueue.getNextExecutionUnit(
                removeEmptyRootQuery: true,
              );
              if (executionUnit == null) {
                break;
              }
            }
            //
            if (FlutterArtist.appConfig.debugOptions.showExecutionUnitQueue) {
              BuildContext context = FlutterArtistCore.context;
              await DebugExecutorDialog.show(
                context: context,
              );
            }
            print("\n EXECUTE ExecutionUnit: $executionUnit \n");
            //
            await __executeExecutionUnit(
              executionUnit: executionUnit,
              executedModuleMap: executedModuleMap,
            );
          }
          //
          __executionUnitCount++;
          //
          _updateProgressViews(
            owner: null,
            executionUnitType: null,
          );
        }
        // May be AppError (FatalException).
        catch (e, _) {
          // FlutterArtist._rootQueue.clear();
          rethrow;
        } finally {
          for (FeatureModule module in executedModuleMap.values) {
            module.ui.refreshAllViews();
          }
          FlutterArtist.storage.ui.refreshAllViews();
          //
          __executingXModuleId = null;
          FlutterArtist.backstage._consumeSingleDeferral();
        }
      },
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  Future<void> __executeExecutionUnit({
    required _ExecutionUnit executionUnit,
    required Map<String, FeatureModule> executedModuleMap,
  }) async {
    if (executionUnit is _ShelfMemberExecutionUnit) {
      _updateProgressViews(
        owner: executionUnit.owner,
        executionUnitType: executionUnit.executionUnitType,
      );
      //
      __executingXModuleId = executionUnit.xModuleId;
      //
      executedModuleMap[executionUnit.shelf.name] = executionUnit.shelf;
    } else if (executionUnit is _ActivityMemberExecutionUnit) {
      _updateProgressViews(
        owner: executionUnit.owner,
        executionUnitType: executionUnit.executionUnitType,
      );
      //
      __executingXModuleId = executionUnit.xModuleId;
      //
      executedModuleMap[executionUnit.activity.name] = executionUnit.activity;
    } else {
      __executingXModuleId = -1000;
    }
    //
    final executionTrace = FlutterArtist.codeFlowLogger._addExecutionUnitCall(
      ownerClassInstance: executionUnit.owner,
      executionUnitType: executionUnit.executionUnitType,
    );
    //
    try {
      // _ActivityV1MemberExecutionUnit
      if (executionUnit is _DefaultActivityV1ExecutionUnit) {
        await executionUnit.xActivityV1.activityV1._unitExecuteActivity(
          executionTrace: executionTrace,
          executionUnitType: executionUnit.executionUnitType,
          thisXActivity: executionUnit.xActivityV1,
          executionIntent: executionUnit.executionIntent,
        );
      }
      // _StageSubmitExecutionUnit
      else if (executionUnit is _StageSubmitExecutionUnit) {
        await executionUnit.xStage.stage._unitSubmit(
          executionTrace: executionTrace,
          executionUnitType: executionUnit.executionUnitType,
          thisXStage: executionUnit.xStage,
          executionIntent: executionUnit.executionIntent,
        );
      }
      // _StageLoadInitDataExecutionUnit
      else if (executionUnit is _StageLoadInitDataExecutionUnit) {
        await executionUnit.xStage.stage._unitLoadInitData(
          executionTrace: executionTrace,
          executionUnitType: executionUnit.executionUnitType,
          thisXStage: executionUnit.xStage,
          executionIntent: executionUnit.executionIntent,
        );
      }
      // _StageFormModelLoadDataExecutionUnit
      else if (executionUnit is _StageFormModelLoadDataExecutionUnit) {
        await executionUnit.xStageFormModel.formModel._unitLoadFormData(
          executionTrace: executionTrace,
          executionUnitType: executionUnit.executionUnitType,
          thisXStageFormModel: executionUnit.xStageFormModel,
          executionIntent: executionUnit.executionIntent,
        );
      }
      // _StageFormViewChangeExecutionUnit
      else if (executionUnit is _StageFormViewChangeExecutionUnit) {
        await executionUnit.xStageFormModel.formModel._unitFormViewChanged(
          executionTrace: executionTrace,
          executionUnitType: executionUnit.executionUnitType,
          thisXStageFormModel: executionUnit.xStageFormModel,
          executionIntent: executionUnit.executionIntent,
        );
      }
      // _TaskFormModelPatchFormFieldsExecutionUnit
      else if (executionUnit is _TaskFormModelPatchFormFieldsExecutionUnit) {
        await executionUnit.xTaskFormModel.formModel._unitPatchFormFields(
          executionTrace: executionTrace,
          executionUnitType: executionUnit.executionUnitType,
          thisXTaskFormModel: executionUnit.xTaskFormModel,
          executionIntent: executionUnit.executionIntent,
        );
      }
      // _TaskSubmitExecutionUnit
      else if (executionUnit is _TaskSubmitExecutionUnit) {
        await executionUnit.xTask.task._unitSubmit(
          executionTrace: executionTrace,
          executionUnitType: executionUnit.executionUnitType,
          thisXTask: executionUnit.xTask,
          executionIntent: executionUnit.executionIntent,
        );
      }
      // _TaskLoadInitDataExecutionUnit
      else if (executionUnit is _TaskLoadInitDataExecutionUnit) {
        await executionUnit.xTask.task._unitLoadInitData(
          executionTrace: executionTrace,
          executionUnitType: executionUnit.executionUnitType,
          thisXTask: executionUnit.xTask,
          executionIntent: executionUnit.executionIntent,
        );
      }
      // _TaskFormModelLoadDataExecutionUnit
      else if (executionUnit is _TaskFormModelLoadDataExecutionUnit) {
        await executionUnit.xTaskFormModel.formModel._unitLoadFormData(
          executionTrace: executionTrace,
          executionUnitType: executionUnit.executionUnitType,
          thisXTaskFormModel: executionUnit.xTaskFormModel,
          executionIntent: executionUnit.executionIntent,
        );
      }
      // _TaskFormViewChangeExecutionUnit
      else if (executionUnit is _TaskFormViewChangeExecutionUnit) {
        await executionUnit.xTaskFormModel.formModel._unitFormViewChanged(
          executionTrace: executionTrace,
          executionUnitType: executionUnit.executionUnitType,
          thisXTaskFormModel: executionUnit.xTaskFormModel,
          executionIntent: executionUnit.executionIntent,
        );
      }
      // _StageFormModelPatchFormFieldsExecutionUnit
      else if (executionUnit is _StageFormModelPatchFormFieldsExecutionUnit) {
        await executionUnit.xStageFormModel.formModel._unitPatchFormFields(
          executionTrace: executionTrace,
          executionUnitType: executionUnit.executionUnitType,
          thisXStageFormModel: executionUnit.xStageFormModel,
          executionIntent: executionUnit.executionIntent,
        );
      }
      // Storage Backend Action ExecutionUnit:
      else if (executionUnit is _StorageBackendActionExecutionUnit) {
        await FlutterArtist.desk._unitBackendAction(
          executionTrace: executionTrace,
          executionUnitType: executionUnit.executionUnitType,
          executionIntent: executionUnit.executionIntent,
        );
      }
      // Filter FilterModel:
      else if (executionUnit is _FilterModelLoadDataExecutionUnit) {
        await executionUnit.xFilterModel.filterModel._unitLoadFilterData(
          executionTrace: executionTrace,
          executionUnitType: executionUnit.executionUnitType,
          thisXFilterModel: executionUnit.xFilterModel,
          executionIntent: executionUnit.executionIntent,
        );
      }
      // FilterPanel Change:
      else if (executionUnit is _FilterPanelChangeExecutionUnit) {
        await executionUnit.xFilterModel.filterModel._unitFilterPanelChanged(
          executionTrace: executionTrace,
          executionUnitType: executionUnit.executionUnitType,
          thisXFilterModel: executionUnit.xFilterModel,
          executionIntent: executionUnit.executionIntent,
        );
      }
      //
      else if (executionUnit is _BlockFormViewChangeExecutionUnit) {
        await executionUnit.xBlockFormModel.formModel._unitFormViewChanged(
          executionTrace: executionTrace,
          executionUnitType: executionUnit.executionUnitType,
          thisXBlockFormModel: executionUnit.xBlockFormModel,
          executionIntent: executionUnit.executionIntent,
        );
      }
      // Block Clear Current:
      else if (executionUnit is _BlockClearCurrentExecutionUnit) {
        await executionUnit.xBlock.block._unitClearCurrentItem(
          executionTrace: executionTrace,
          executionUnitType: executionUnit.executionUnitType,
          thisXBlock: executionUnit.xBlock,
          executionIntent: executionUnit.executionIntent,
        );
      }
      // Block Clear All Items:
      else if (executionUnit is _BlockClearItemsExecutionUnit) {
        await executionUnit.xBlock.block._unitClearItems(
          executionTrace: executionTrace,
          executionUnitType: executionUnit.executionUnitType,
          thisXBlock: executionUnit.xBlock,
          executionIntent: executionUnit.executionIntent,
        );
      }
      // Block Query:
      else if (executionUnit is _BlockQueryExecutionUnit) {
        await executionUnit.xBlock.block._unitQuery(
          executionTrace: executionTrace,
          executionUnitType: executionUnit.executionUnitType,
          thisXBlock: executionUnit.xBlock,
          executionIntent: executionUnit.executionIntent,
        );
      }
      // Block PrepareCreate:
      else if (executionUnit is _BlockPrepareFormToCreateItemExecutionUnit) {
        await executionUnit.xBlock.block._unitPrepareFormToCreateItem(
          executionTrace: executionTrace,
          executionUnitType: executionUnit.executionUnitType,
          thisXBlock: executionUnit.xBlock,
          executionIntent: executionUnit.executionIntent,
        );
      }
      // Block Select Item as Current:
      else if (executionUnit is _BlockSetItemAsCurrentExecutionUnit) {
        await executionUnit.xBlock.block._unitSetItemAsCurrent(
          executionTrace: executionTrace,
          executionUnitType: executionUnit.executionUnitType,
          thisXBlock: executionUnit.xBlock,
          executionIntent: executionUnit.executionIntent,
        );
      }
      // Block Delete Item:
      else if (executionUnit is _BlockItemDeletionExecutionUnit) {
        await executionUnit.xBlock.block._unitDeleteItem(
          executionTrace: executionTrace,
          executionUnitType: executionUnit.executionUnitType,
          thisXBlock: executionUnit.xBlock,
          executionIntent: executionUnit.executionIntent,
        );
      }
      // Block Delete Items:
      else if (executionUnit is _BlockMultiItemDeletionExecutionUnit) {
        await executionUnit.xBlock.block._unitDeleteItems(
          executionTrace: executionTrace,
          executionUnitType: executionUnit.executionUnitType,
          thisXBlock: executionUnit.xBlock,
          executionIntent: executionUnit.executionIntent,
        );
      }
      // Block QuickCreateItem:
      else if (executionUnit is _BlockQuickItemCreationExecutionUnit) {
        await executionUnit.xBlock.block._unitQuickCreateItem(
          executionTrace: executionTrace,
          executionUnitType: executionUnit.executionUnitType,
          thisXBlock: executionUnit.xBlock,
          executionIntent: executionUnit.executionIntent,
        );
      }
      // Block QuickUpdateItem:
      else if (executionUnit is _BlockQuickItemUpdateExecutionUnit) {
        await executionUnit.xBlock.block._unitQuickUpdateItem(
          executionTrace: executionTrace,
          executionUnitType: executionUnit.executionUnitType,
          thisXBlock: executionUnit.xBlock,
          executionIntent: executionUnit.executionIntent,
        );
      }
      // Block Quick Action:
      else if (executionUnit is _BlockBackendActionExecutionUnit) {
        await executionUnit.xBlock.block._unitBackendAction(
          executionTrace: executionTrace,
          executionUnitType: executionUnit.executionUnitType,
          thisXBlock: executionUnit.xBlock,
          executionIntent: executionUnit.executionIntent,
        );
      }
      // FormModel LoadForm:
      else if (executionUnit is _BlockFormModelLoadDataExecutionUnit) {
        await executionUnit.xBlockFormModel.formModel._unitLoadFormData(
          executionTrace: executionTrace,
          executionUnitType: executionUnit.executionUnitType,
          thisXBlockFormModel: executionUnit.xBlockFormModel,
          executionIntent: executionUnit.executionIntent,
        );
      }
      // _FormModelSaveFormExecutionUnit
      else if (executionUnit is _FormModelSaveFormExecutionUnit) {
        await executionUnit.xBlockFormModel.formModel._unitSaveForm(
          executionTrace: executionTrace,
          executionUnitType: executionUnit.executionUnitType,
          thisXBlockFormModel: executionUnit.xBlockFormModel,
          executionIntent: executionUnit.executionIntent,
        );
      }
      // _BlockFormModelPatchFormFieldsExecutionUnit
      else if (executionUnit is _BlockFormModelPatchFormFieldsExecutionUnit) {
        await executionUnit.xBlockFormModel.formModel._unitPatchFormFields(
          executionTrace: executionTrace,
          executionUnitType: executionUnit.executionUnitType,
          thisXBlockFormModel: executionUnit.xBlockFormModel,
          executionIntent: executionUnit.executionIntent,
        );
      }
      // _ScalarQueryExecutionUnit
      else if (executionUnit is _ScalarQueryExecutionUnit) {
        await executionUnit.xScalar.scalar._unitQuery(
          executionTrace: executionTrace,
          executionUnitType: executionUnit.executionUnitType,
          thisXScalar: executionUnit.xScalar,
          executionIntent: executionUnit.executionIntent,
        );
      }
      // Scalar Clear Value:
      else if (executionUnit is _ScalarClearExecutionUnit) {
        await executionUnit.xScalar.scalar._unitClear(
          executionTrace: executionTrace,
          executionUnitType: executionUnit.executionUnitType,
          thisXScalar: executionUnit.xScalar,
          executionIntent: executionUnit.executionIntent,
        );
      }
      // Scalar Quick Action:
      else if (executionUnit is _ScalarLoadExtraDataQuickActionExecutionUnit) {
        await executionUnit.xScalar.scalar._unitLoadExtraDataQuickAction(
          executionTrace: executionTrace,
          executionUnitType: executionUnit.executionUnitType,
          thisXScalar: executionUnit.xScalar,
          executionIntent: executionUnit.executionIntent,
        );
      }
    } finally {
      ExecutionIntent executionIntent = executionUnit.executionIntent;
      executionIntent.complete();
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  void _updateProgressViews({
    required Object? owner,
    required ExecutionUnitType? executionUnitType,
  }) {
    for (_ExecutionProgressBuilderState state in [
      ..._executionProgressViewWidgetStates.keys
    ]) {
      if (!state.mounted) {
        _executionProgressViewWidgetStates.remove(state);
        continue;
      }
      bool onProgress = owner == null || executionUnitType == null
          ? false
          : state.isMatches(
              owner: owner,
              executionUnitType: executionUnitType,
            );
      //
      state.onProgress = onProgress;
      state.refreshState(force: true);
    }
  }

  void _addExecutionProgressViewWidgetState({
    required _ExecutionProgressBuilderState widgetState,
    required bool isVisible,
  }) {
    _executionProgressViewWidgetStates[widgetState] = isVisible;
  }

  void _removeExecutionProgressViewWidgetState({
    required _ExecutionProgressBuilderState widgetState,
  }) {
    _executionProgressViewWidgetStates.remove(widgetState);
  }
}
