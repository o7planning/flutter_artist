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

  int get xModuleId => xShelf.xModuleId;

  FilterModelExecutionIntent? _executionIntent;

  FilterModelExecutionIntent? _stashedIntent;

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
    // 1. Phục hồi stashed intent nếu intent hiện tại đã rỗng
    if (_executionIntent == null && _stashedIntent != null) {
      _executionIntent = _stashedIntent;
      _stashedIntent = null;
    }

    final input = FilterNextUnitInput(
      loadedInSession: loadedInSession,
      committedDataState: filterModel.committedDataState,
      draftDataState: filterModel.draftDataState,
      currentIntent: _executionIntent,
      filterLoadHint: _filterLoadHint,
      modelName: getClassNameWithoutGenerics(filterModel),
    );

    final output = FilterExecutionCalculator.calculate(input);

    // 2. Bảo lưu Intent cũ nếu bị chèn ép tải dữ liệu
    if (output.preserveCurrentIntent) {
      _stashedIntent = _executionIntent;
    }

    String finalDebugInfo = output.debugInfo;

    // 3. Xử lý Side-effects: Bơm Missing Intent (Load) nếu cần thiết
    if (output.missingIntent == MissingIntentType.dataLoadOrQuery) {
      final intentToUse = _createAndSetFilterModelExecutionIntentLoad();
      finalDebugInfo = finalDebugInfo.replaceFirst(
          "_executionIntent: $_stashedIntent",
          "_executionIntent: $_stashedIntent --> $intentToUse");
    }

    // 4. Trả về Execution Unit tương ứng
    switch (output.action) {
      case FilterExecutionAction.loadData:
        return NxtExecutionUnit.yes(
          debug: debug,
          executionUnit: _FilterModelLoadDataExecutionUnit(
            xFilterModel: this,
            executionIntent: _executionIntent as FilterModelLoadIntent,
          ),
          info: finalDebugInfo,
        );
      case FilterExecutionAction.panelChange:
        return NxtExecutionUnit.yes(
          debug: debug,
          executionUnit: _FilterPanelChangeExecutionUnit(
            xFilterModel: this,
            executionIntent:
                _executionIntent as FilterModelFilterPanelChangeIntent,
          ),
          info: finalDebugInfo,
        );
      case FilterExecutionAction.none:
      default:
        return NxtExecutionUnit.no(
          debug: debug,
          info: finalDebugInfo,
        );
    }
  }

  // ***************************************************************************

  bool isVisibleNeedToQuery() {
    if (isDefaultFilterModel) {
      return false;
    }
    if (!filterModel.ui.hasVisibleViews()) {
      return false;
    }
    if (filterModel.committedDataState.isLoaded) {
      return false;
    }
    return true;
  }

  @override
  String toString() {
    return "${getClassName(filterModel)} - Queried: $loadedInSession >>> FILTER_INPUT: $filterInput";
  }
}
