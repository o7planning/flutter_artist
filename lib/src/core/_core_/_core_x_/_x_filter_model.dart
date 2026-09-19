part of '../core.dart';

int __xFilterModelSeq = 0;

class XFilterModel {
  final int _xFilterModelId;
  final XShelf xShelf;
  final FilterModel filterModel;

  final List<XBlock> xBlocks = [];
  final List<XScalar> xScalars = [];

  FilterApplyPolicy _filterApplyPolicy = FilterApplyPolicy.explicit;

  FilterApplyPolicy get filterApplyPolicy => _filterApplyPolicy;

  void _setFilterApplyPolicy(FilterApplyPolicy filterApplyPolicy) {
    _filterApplyPolicy = filterApplyPolicy;
  }

  bool loadedInSession = false;
  FilterInput? filterInput;

  bool get isDefaultFilterModel => filterModel.isDefaultFilterModel;

  bool get isCustomFilterModel => !filterModel.isDefaultFilterModel;

  String get name => filterModel.name;

  int get xShelfId => xShelf.xShelfId;

  FilterModelExecutionIntent? _executionIntent;

  FilterLoadHint _filterLoadHint = FilterLoadHint.auto;

  // ***************************************************************************

  XFilterModel._({
    required this.xShelf,
    required this.filterModel,
  }) : _xFilterModelId = __xFilterModelSeq++;

  // ***************************************************************************

  /// Resets query status and load hints for this filter session.
  void resetExecutionHints() {
    _filterLoadHint = FilterLoadHint.auto;
  }

  // ***************************************************************************
  // ***************************************************************************

  FilterModelFilterPanelChangeIntent
  _createAndSetFilterModelExecutionIntentPanelChange({
    required Map<String, dynamic> formKeyInstantValuesInUI,
  }) {
    final executionIntent = FilterModelFilterPanelChangeIntent(
      formKeyInstantValuesInUI: formKeyInstantValuesInUI,
    );
    _executionIntent = executionIntent;
    return executionIntent;
  }

  // ***************************************************************************

  FilterModelLoadIntent _createAndSetFilterModelExecutionIntentLoad() {
    FilterModelLoadIntent executionIntent = FilterModelLoadIntent();
    _executionIntent = executionIntent;
    return executionIntent;
  }

  // ***************************************************************************

  FilterModelDoneIntent _createAndSetFilterModelExecutionIntentDone() {
    FilterModelDoneIntent executionIntent = FilterModelDoneIntent();
    _executionIntent = executionIntent;
    return executionIntent;
  }

  // ***************************************************************************

  NxtExecutionUnit _getNextExecutionUnit({required bool debug}) {
    if (loadedInSession) {
      return NxtExecutionUnit.no(
        debug: debug,
        info:
        "FilterModel (1.1), ${getClassNameWithoutGenerics(
            filterModel)}, loadedInSession: $loadedInSession.",
      );
    }
    final draftDataState = filterModel.draftDataState;
    final committedDataState = filterModel.committedDataState;
    final executionIntent = _executionIntent;

    // =========================================================================
    // 2. DATA STATE = PENDING.
    // =========================================================================
    if (committedDataState.isPending) {
      // Must load filter data first before allowing panel mutations or consumption
      if (executionIntent is! FilterModelLoadIntent) {
        _createAndSetFilterModelExecutionIntentLoad();
      }

      return NxtExecutionUnit.yes(
        debug: debug,
        executionUnit: _FilterModelLoadDataExecutionUnit(
          xFilterModel: this,
          executionIntent: _executionIntent as FilterModelLoadIntent,
        ),
        info:
        "FilterModel 2.1, ${getClassNameWithoutGenerics(
            filterModel)}, _executionIntent: $_executionIntent, "
            "committedDataState**: ${committedDataState
            .toBriefInfo()}, draftDataState: ${draftDataState.toBriefInfo()}, "
            "filterLoadHint: $_filterLoadHint, xFilterModel.loadedInSession: $loadedInSession.",
      );
    }

    // =========================================================================
    // 3. DATA STATE = ERROR (Data is missing or broken)
    // =========================================================================
    if (committedDataState.isError) {
      // IN: filterDataState.isLoaded
      // 3.0. Intercept terminal Done intent to prevent duplicate scheduler cycles
      if (executionIntent is FilterModelDoneIntent) {
        return NxtExecutionUnit.no(
          debug: debug,
          info:
          "FilterModel (3.0), ${getClassNameWithoutGenerics(
              filterModel)}, _executionIntent: $executionIntent, "
              "committedDataState**: ${committedDataState
              .toBriefInfo()}, draftDataState: ${draftDataState
              .toBriefInfo()}, "
              "filterLoadHint: $_filterLoadHint, xFilterModel.loadedInSession: $loadedInSession.",
        );
      }
      // IN: committedDataState.isError.
      if (executionIntent == null) {
        _createAndSetFilterModelExecutionIntentLoad();

        return NxtExecutionUnit.yes(
          debug: debug,
          executionUnit: _FilterModelLoadDataExecutionUnit(
            xFilterModel: this,
            executionIntent: _executionIntent as FilterModelLoadIntent,
          ),
          info:
          "FilterModel 3.1, ${getClassNameWithoutGenerics(
              filterModel)}, _executionIntent: $_executionIntent, "
              "committedDataState**: ${committedDataState
              .toBriefInfo()}, draftDataState: ${draftDataState
              .toBriefInfo()}, "
              "filterLoadHint: $_filterLoadHint, xFilterModel.loadedInSession: $loadedInSession.",
        );
      }
      if (executionIntent is FilterModelLoadIntent) {
        return NxtExecutionUnit.yes(
          debug: debug,
          executionUnit: _FilterModelLoadDataExecutionUnit(
            xFilterModel: this,
            executionIntent: _executionIntent as FilterModelLoadIntent,
          ),
          info:
          "FilterModel 3.2, ${getClassNameWithoutGenerics(
              filterModel)}, _executionIntent: $_executionIntent, "
              "committedDataState**: ${committedDataState
              .toBriefInfo()}, draftDataState: ${draftDataState
              .toBriefInfo()}, "
              "filterLoadHint: $_filterLoadHint, xFilterModel.loadedInSession: $loadedInSession.",
        );
      } else if (executionIntent is FilterModelFilterPanelChangeIntent) {
        return NxtExecutionUnit.yes(
          debug: debug,
          executionUnit: _FilterPanelChangeExecutionUnit(
            xFilterModel: this,
            executionIntent:
            _executionIntent as FilterModelFilterPanelChangeIntent,
          ),
          info:
          "FilterModel 3.3, ${getClassNameWithoutGenerics(
              filterModel)}, _executionIntent: $_executionIntent, "
              "committedDataState**: ${committedDataState
              .toBriefInfo()}, draftDataState: ${draftDataState
              .toBriefInfo()}, "
              "filterLoadHint: $_filterLoadHint, xFilterModel.loadedInSession: $loadedInSession.",
        );
      } else {
        return NxtExecutionUnit.no(
          debug: debug,
          info:
          "FilterModel 3.4, ${getClassNameWithoutGenerics(
              filterModel)}, _executionIntent: $_executionIntent, "
              "committedDataState**: ${committedDataState
              .toBriefInfo()}, draftDataState: ${draftDataState
              .toBriefInfo()}, "
              "filterLoadHint: $_filterLoadHint, xFilterModel.loadedInSession: $loadedInSession.",
        );
      }
    }

    // =========================================================================
    // 4. DATA STATE = LOADED (Data is ready)
    // =========================================================================
    else if (committedDataState.isLoaded) {
      // IN: filterDataState.isLoaded
      // 4.0. Intercept terminal Done intent to prevent duplicate scheduler cycles
      if (executionIntent is FilterModelDoneIntent) {
        return NxtExecutionUnit.no(
          debug: debug,
          info:
          "FilterModel (4.0), ${getClassNameWithoutGenerics(
              filterModel)}, _executionIntent: $executionIntent, "
              "committedDataState**: ${committedDataState
              .toBriefInfo()}, draftDataState: ${draftDataState
              .toBriefInfo()}, "
              "filterLoadHint: $_filterLoadHint, xFilterModel.loadedInSession: $loadedInSession.",
        );
      }

      // 4.1. Force reload explicitly requested
      if (_filterLoadHint == FilterLoadHint.force) {
        // Reuse caller-provided LoadIntent if already attached to preserve completer hooks
        if (executionIntent is! FilterModelLoadIntent) {
          _createAndSetFilterModelExecutionIntentLoad();
        }
        return NxtExecutionUnit.yes(
          debug: debug,
          executionUnit: _FilterModelLoadDataExecutionUnit(
            xFilterModel: this,
            executionIntent: _executionIntent as FilterModelLoadIntent,
          ),
          info:
          "FilterModel (4.1), ${getClassNameWithoutGenerics(
              filterModel)}, _executionIntent: $_executionIntent, "
              "committedDataState**: ${committedDataState
              .toBriefInfo()}, draftDataState: ${draftDataState
              .toBriefInfo()}, "
              "filterLoadHint: $_filterLoadHint, xFilterModel.loadedInSession: $loadedInSession.",
        );
      }

      // 4.2. Handle active execution intents
      if (executionIntent != null) {
        if (executionIntent is FilterModelDoneIntent) {
          return NxtExecutionUnit.no(
            debug: debug,
            info:
            "FilterModel (4.2.1), ${getClassNameWithoutGenerics(
                filterModel)}, _executionIntent: $executionIntent, "
                "committedDataState**: ${committedDataState
                .toBriefInfo()}, draftDataState: ${draftDataState
                .toBriefInfo()}, "
                "filterLoadHint: $_filterLoadHint, xFilterModel.loadedInSession: $loadedInSession.",
          );
        } else if (executionIntent is FilterModelFilterPanelChangeIntent) {
          return NxtExecutionUnit.yes(
            debug: debug,
            executionUnit: _FilterPanelChangeExecutionUnit(
              xFilterModel: this,
              executionIntent: executionIntent,
            ),
            info:
            "FilterModel (4.2.2), ${getClassNameWithoutGenerics(
                filterModel)}, _executionIntent: $executionIntent, "
                "committedDataState**: ${committedDataState
                .toBriefInfo()}, draftDataState: ${draftDataState
                .toBriefInfo()}, "
                "filterLoadHint: $_filterLoadHint, xFilterModel.loadedInSession: $loadedInSession.",
          );
        } else if (executionIntent is FilterModelLoadIntent) {
          return NxtExecutionUnit.yes(
            debug: debug,
            executionUnit: _FilterModelLoadDataExecutionUnit(
              xFilterModel: this,
              executionIntent: executionIntent,
            ),
            info:
            "FilterModel (4.2.3), ${getClassNameWithoutGenerics(
                filterModel)}, _executionIntent: $executionIntent, "
                "committedDataState**: ${committedDataState
                .toBriefInfo()}, draftDataState: ${draftDataState
                .toBriefInfo()}, "
                "filterLoadHint: $_filterLoadHint, xFilterModel.loadedInSession: $loadedInSession.",
          );
        } else {
          return NxtExecutionUnit.no(
            debug: debug,
            info:
            "FilterModel (4.2.4), ${getClassNameWithoutGenerics(
                filterModel)}, _executionIntent: $executionIntent, "
                "committedDataState**: ${committedDataState
                .toBriefInfo()}, draftDataState: ${draftDataState
                .toBriefInfo()}, "
                "filterLoadHint: $_filterLoadHint, xFilterModel.loadedInSession: $loadedInSession.",
          );
        }
      }

      // 4.3. Idle state when filter is fully loaded and no intent is pending
      return NxtExecutionUnit.no(
        debug: debug,
        info:
        "FilterModel (4.3), ${getClassNameWithoutGenerics(
            filterModel)}, _executionIntent: null, "
            "committedDataState**: ${committedDataState
            .toBriefInfo()}, draftDataState: ${draftDataState.toBriefInfo()}, "
            "filterLoadHint: $_filterLoadHint, xFilterModel.loadedInSession: $loadedInSession.",
      );
    }

    // =========================================================================
    // 4. UNHANDLED / FALLTHROUGH STATE
    // =========================================================================
    return NxtExecutionUnit.no(
      debug: debug,
      info:
      "FilterModel (5.1), ${getClassNameWithoutGenerics(
          filterModel)}, _executionIntent: $executionIntent, "
          "committedDataState**: ${committedDataState
          .toBriefInfo()}, draftDataState: ${draftDataState.toBriefInfo()}, "
          "filterLoadHint: $_filterLoadHint, xFilterModel.loadedInSession: $loadedInSession.",
    );
  }

  // ***************************************************************************

  bool isVisibleNeedToQuery() {
    if (isDefaultFilterModel) {
      return false;
    }
    if (!filterModel.ui.hasActiveUiComponent()) {
      return false;
    }
    if (filterModel.committedDataState.isLoaded) {
      return false;
    }
    return true;
  }

  @override
  String toString() {
    return "${getClassName(
        filterModel)} - Queried: $loadedInSession >>> FILTER_INPUT: $filterInput";
  }
}
