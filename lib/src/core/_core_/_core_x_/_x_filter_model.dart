part of '../core.dart';

int __xFilterModelSeq = 0;

class XFilterModel {
  final int _xFilterModelId;
  final XShelf xShelf;
  final FilterModel filterModel;

  final List<XBlock> xBlocks = [];
  final List<XScalar> xScalars = [];

  bool queried = false;
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

  NextExecutionUnit _getNextExecutionUnit({required bool debug}) {
    final filterDataState = filterModel.dataState;
    if (filterModel.isDefaultFilterModel) {
      return NextExecutionUnit.no(
        debug: debug,
        info: "FilterModel (1), ${getClassNameWithoutGenerics(filterModel)}, "
            "default?: ${filterModel.isDefaultFilterModel}",
      );
    }
    //
    if (_executionIntent == null) {
      // IN: `_executionIntent == null`
      if (filterDataState.isLoaded) {
        return NextExecutionUnit.no(
          debug: debug,
          info:
              "FilterModel (2.1), ${getClassNameWithoutGenerics(filterModel)}, "
              "default?: ${filterModel.isDefaultFilterModel}, "
              "dataState: $filterDataState, executionIntent: $_executionIntent",
        );
      }
      // IN: `_executionIntent == null`
      else if (filterDataState.isPending) {
        PrintUtils.debug(debug,
            " (**) FilterModel _executionIntent: null, create FilterModelLoadIntent.");
        _createAndSetFilterModelExecutionIntentLoad();
        //
        return NextExecutionUnit.yes(
          debug: debug,
          executionUnit: _FilterModelLoadDataExecutionUnit(
            xFilterModel: this,
            executionIntent: _executionIntent as FilterModelLoadIntent,
          ),
          info:
              "FilterModel (2.2), ${getClassNameWithoutGenerics(filterModel)}, "
              "default?: ${filterModel.isDefaultFilterModel}, "
              "dataState: $filterDataState, executionIntent: $_executionIntent",
        );
      }
      // IN: `_executionIntent == null`
      else if (filterDataState.isError) {
        PrintUtils.debug(debug,
            " (**) FilterModel _executionIntent: null, create ${debugObjHtml(FilterModelLoadIntent)}");
        _createAndSetFilterModelExecutionIntentLoad();
        //
        return NextExecutionUnit.yes(
          debug: debug,
          executionUnit: _FilterModelLoadDataExecutionUnit(
            xFilterModel: this,
            executionIntent: _executionIntent as FilterModelLoadIntent,
          ),
          info:
              "FilterModel (2.3), ${getClassNameWithoutGenerics(filterModel)}, "
              "default?: ${filterModel.isDefaultFilterModel}, "
              "dataState: $filterDataState, executionIntent: $_executionIntent",
        );
      }
      // IN: `_executionIntent == null`
      else {
        _createAndSetFilterModelExecutionIntentLoad();
        //
        return NextExecutionUnit.yes(
          debug: debug,
          executionUnit: _FilterModelLoadDataExecutionUnit(
            xFilterModel: this,
            executionIntent: _executionIntent as FilterModelLoadIntent,
          ),
          info:
              "FilterModel (2.4), ${getClassNameWithoutGenerics(filterModel)}, "
              "default?: ${filterModel.isDefaultFilterModel}, "
              "dataState: $filterDataState, executionIntent: $_executionIntent",
        );
      }
    }
    //
    // _executionIntent != null.
    //
    final executionIntent = _executionIntent!;
    // FilterModelDoneIntent
    if (executionIntent is FilterModelDoneIntent) {
      return NextExecutionUnit.no(
        debug: debug,
        info: "FilterModel (3), ${getClassNameWithoutGenerics(filterModel)}, "
            "default?: ${filterModel.isDefaultFilterModel}, "
            "dataState: $filterDataState, executionIntent: $executionIntent",
      );
    }
    // FilterModelFilterPanelChangeIntent
    else if (executionIntent is FilterModelFilterPanelChangeIntent) {
      return NextExecutionUnit.yes(
        debug: debug,
        executionUnit: _FilterPanelChangeExecutionUnit(
          xFilterModel: this,
          executionIntent: executionIntent,
        ),
        info: "FilterModel (4), ${getClassNameWithoutGenerics(filterModel)}, "
            "default?: ${filterModel.isDefaultFilterModel}, "
            "dataState: $filterDataState, executionIntent: $_executionIntent",
      );
    }
    // FilterModelLoadIntent
    else if (executionIntent is FilterModelLoadIntent) {
      return NextExecutionUnit.yes(
        debug: debug,
        executionUnit: _FilterModelLoadDataExecutionUnit(
          xFilterModel: this,
          executionIntent: executionIntent,
        ),
        info: "FilterModel (5), ${getClassNameWithoutGenerics(filterModel)}, "
            "default?: ${filterModel.isDefaultFilterModel}, "
            "dataState: $filterDataState, executionIntent: $_executionIntent",
      );
    }
    return NextExecutionUnit.no(
      debug: debug,
      info: "FilterModel (6), ${getClassNameWithoutGenerics(filterModel)}, "
          "default?: ${filterModel.isDefaultFilterModel}, "
          "dataState: $filterDataState, executionIntent: $_executionIntent  *** OTHER ***",
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
    if (filterModel.dataState.isLoaded) {
      return false;
    }
    return true;
  }

  @override
  String toString() {
    return "${getClassName(filterModel)} - Queried: $queried >>> FILTER_INPUT: $filterInput";
  }
}
