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

  FilterModelTodo? _filterModelTodo;

  FilterLoadHint _filterLoadHint = FilterLoadHint.auto;

  // ***************************************************************************

  XFilterModel._({
    required this.xShelf,
    required this.filterModel,
  }) : _xFilterModelId = __xFilterModelSeq++;

  // ***************************************************************************
  // ***************************************************************************

  FilterModelTodoPanelChange _createAndSetFilterModelTodoPanelChange({
    required Map<String, dynamic> formKeyInstantValuesInUI,
  }) {
    final filterModelTodo = FilterModelTodoPanelChange(
      formKeyInstantValuesInUI: formKeyInstantValuesInUI,
    );
    _filterModelTodo = filterModelTodo;
    return filterModelTodo;
  }

  // ***************************************************************************

  FilterModelTodoLoad _createAndSetFilterModelTodoLoad() {
    FilterModelTodoLoad filterModelTodo = FilterModelTodoLoad();
    _filterModelTodo = filterModelTodo;
    return filterModelTodo;
  }

  // ***************************************************************************

  FilterModelTodoDone _createAndSetFilterModelTodoDone() {
    FilterModelTodoDone filterModelTodo = FilterModelTodoDone();
    _filterModelTodo = filterModelTodo;
    return filterModelTodo;
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
    if (_filterModelTodo is FilterModelTodoDone) {
      return NextExecutionUnit.no(
        debug: debug,
        info: "FilterModel (2), ${getClassNameWithoutGenerics(filterModel)}, "
            "default?: ${filterModel.isDefaultFilterModel}, "
            "dataState: $filterDataState, executionTodo: $_filterModelTodo",
      );
    }
    //
    if (_filterModelTodo == null) {
      // IN: `_filterModelTodo == null`
      if (filterDataState.isLoaded) {
        return NextExecutionUnit.no(
          debug: debug,
          info:
              "FilterModel (3.1), ${getClassNameWithoutGenerics(filterModel)}, "
              "default?: ${filterModel.isDefaultFilterModel}, "
              "dataState: $filterDataState, executionTodo: $_filterModelTodo",
        );
      }
      // IN: `_filterModelTodo == null`
      else if (filterDataState.isPending) {
        PrintUtils.debug(debug,
            " (**) FilterModel _filterModelTodo: null, create FilterModelTodoLoad");
        _createAndSetFilterModelTodoLoad();
        //
        return NextExecutionUnit.yes(
          debug: debug,
          executionUnit: _FilterModelLoadDataExecutionUnit(
            xFilterModel: this,
            executionTodo: _filterModelTodo as FilterModelTodoLoad,
          ),
          info:
              "FilterModel (3.2), ${getClassNameWithoutGenerics(filterModel)}, "
              "default?: ${filterModel.isDefaultFilterModel}, "
              "dataState: $filterDataState, executionTodo: $_filterModelTodo",
        );
      }
      // IN: `_filterModelTodo == null`
      else if (filterDataState.isError) {
        PrintUtils.debug(debug,
            " (**) FilterModel _filterModelTodo: null, create FilterModelTodoLoad");
        _createAndSetFilterModelTodoLoad();
        //
        return NextExecutionUnit.yes(
          debug: debug,
          executionUnit: _FilterModelLoadDataExecutionUnit(
            xFilterModel: this,
            executionTodo: _filterModelTodo as FilterModelTodoLoad,
          ),
          info:
              "FilterModel (3.3), ${getClassNameWithoutGenerics(filterModel)}, "
              "default?: ${filterModel.isDefaultFilterModel}, "
              "dataState: $filterDataState, executionTodo: $_filterModelTodo",
        );
      }
      // IN: `_filterModelTodo == null`
      else {
        PrintUtils.debug(debug,
            " (**) FilterModel _filterModelTodo: null, create FilterModelTodoLoad");
        _createAndSetFilterModelTodoLoad();
        //
        return NextExecutionUnit.yes(
          debug: debug,
          executionUnit: _FilterModelLoadDataExecutionUnit(
            xFilterModel: this,
            executionTodo: _filterModelTodo as FilterModelTodoLoad,
          ),
          info:
              "FilterModel (3.4), ${getClassNameWithoutGenerics(filterModel)}, "
              "default?: ${filterModel.isDefaultFilterModel}, "
              "dataState: $filterDataState, executionTodo: $_filterModelTodo",
        );
      }
    }
    //
    final filterModelTodo = _filterModelTodo;
    // FilterModelTodoDone
    if (filterModelTodo is FilterModelTodoDone) {
      throw UnimplementedError("Never run, see above!");
    }
    // FilterModelTodoPanelChange
    else if (filterModelTodo is FilterModelTodoPanelChange) {
      return NextExecutionUnit.yes(
        debug: debug,
        executionUnit: _FilterPanelChangeExecutionUnit(
          xFilterModel: this,
          executionTodo: filterModelTodo,
        ),
        info: "FilterModel (4), ${getClassNameWithoutGenerics(filterModel)}, "
            "default?: ${filterModel.isDefaultFilterModel}, "
            "dataState: $filterDataState, executionTodo: $_filterModelTodo",
      );
    }
    // FilterModelTodoLoad
    else if (filterModelTodo is FilterModelTodoLoad) {
      return NextExecutionUnit.yes(
        debug: debug,
        executionUnit: _FilterModelLoadDataExecutionUnit(
          xFilterModel: this,
          executionTodo: filterModelTodo,
        ),
        info: "FilterModel (5), ${getClassNameWithoutGenerics(filterModel)}, "
            "default?: ${filterModel.isDefaultFilterModel}, "
            "dataState: $filterDataState, executionTodo: $_filterModelTodo",
      );
    }
    return NextExecutionUnit.no(
      debug: debug,
      info: "FilterModel (6), ${getClassNameWithoutGenerics(filterModel)}, "
          "default?: ${filterModel.isDefaultFilterModel}, "
          "dataState: $filterDataState, executionTodo: $_filterModelTodo  *** OTHER ***",
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
