part of '../core.dart';

class _Executor {
  int __executionUnitCount = 0;
  int? __executingXShelfId;

  int get executionUnitCount => __executionUnitCount;

  int? get executingXShelfId => __executingXShelfId;

  final Map<_ExecutionProgressBuilderState, bool>
      _executionProgressViewWidgetStates = {};

  // ***************************************************************************
  // ***************************************************************************

  _Executor();

  // ***************************************************************************
  // ***************************************************************************

  bool get isBusy {
    if (__executingXShelfId == null) {
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
    if (__executingXShelfId != null) {
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
        // Executed Shelf Map:
        final Map<String, Shelf> executedShelfMap = {};
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
              final Set<String> excludeShelfNames =
                  executedShelfMap.keys.toSet();
              //
              FlutterArtist.desk._reactionProcessor.addReactionExecutionUnits(
                excludeShelfNames: excludeShelfNames,
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
              executedShelfMap: executedShelfMap,
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
          for (Shelf shelf in executedShelfMap.values) {
            shelf.ui.updateAllUiComponents();
          }
          FlutterArtist.storage.ui.updateAllUiComponents();
          //
          __executingXShelfId = null;
          FlutterArtist.backstage._consumeSingleDeferral();
        }
      },
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  Future<void> __executeExecutionUnit({
    required _ExecutionUnit executionUnit,
    required Map<String, Shelf> executedShelfMap,
  }) async {
    if (executionUnit is _ShelfMemberExecutionUnit) {
      _updateProgressViews(
        owner: executionUnit.owner,
        executionUnitType: executionUnit.executionUnitType,
      );
      //
      __executingXShelfId = executionUnit.xShelfId;
      //
      executedShelfMap[executionUnit.shelf.name] = executionUnit.shelf;
    } else {
      __executingXShelfId = -1000;
    }
    //
    final executionTrace = FlutterArtist.codeFlowLogger._addExecutionUnitCall(
      ownerClassInstance: executionUnit.owner,
      executionUnitType: executionUnit.executionUnitType,
    );
    //
    try {
      // _ActivityMemberExecutionUnit
      if (executionUnit is _DefaultActivityExecutionUnit) {
        await executionUnit.xActivity.activity._unitExecuteActivity(
          executionTrace: executionTrace,
          executionUnitType: executionUnit.executionUnitType,
          thisXActivity: executionUnit.xActivity,
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
      else if (executionUnit is _FormViewChangeExecutionUnit) {
        await executionUnit.xFormModel.formModel._unitFormViewChanged(
          executionTrace: executionTrace,
          executionUnitType: executionUnit.executionUnitType,
          thisXFormModel: executionUnit.xFormModel,
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
          executionIntent: executionUnit.executionIntent!,
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
      else if (executionUnit is _FormModelLoadDataExecutionUnit) {
        await executionUnit.xFormModel.formModel._unitLoadFormData(
          executionTrace: executionTrace,
          executionUnitType: executionUnit.executionUnitType,
          thisXFormModel: executionUnit.xFormModel,
          executionIntent: executionUnit.executionIntent,
        );
      }
      // FormModel Save:
      else if (executionUnit is _FormModelSaveFormExecutionUnit) {
        await executionUnit.xFormModel.formModel._unitSaveForm(
          executionTrace: executionTrace,
          executionUnitType: executionUnit.executionUnitType,
          thisXFormModel: executionUnit.xFormModel,
          executionIntent: executionUnit.executionIntent,
        );
      }
      // FormModel QuickFormInputAction:
      else if (executionUnit is _FormModelPatchFormFieldsExecutionUnit) {
        await executionUnit.xFormModel.formModel._unitPatchFormFields(
          executionTrace: executionTrace,
          executionUnitType: executionUnit.executionUnitType,
          thisXFormModel: executionUnit.xFormModel,
          executionIntent: executionUnit.executionIntent,
        );
      }
      // Scalar:
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
