part of '../core.dart';

abstract class FilterModel<
    FILTER_INPUT extends FilterInput, // EmptyFilterInput
    FILTER_CRITERIA extends FilterCriteria // EmptyFilterCriteria
    > extends _Core {
  bool _filterCriteriaPrechecked = false;

  late final Shelf shelf;

  late final String name;

  final FilterModelConfig config;

  final FilterModelEffectiveConfig effectiveConfig;

  String get pathInfo {
    return "filter-model > ${shelf.name} > $name";
  }

  final List<Block> _blocks = [];

  List<Block> get blocks => List.unmodifiable(_blocks);

  final List<Scalar> _scalars = [];

  List<Scalar> get scalars => List.unmodifiable(_scalars);

  // ===========================================================================
  // DRAFT REALM (Workspace / Input / Pending changes)
  // ===========================================================================

  /// Holds the current active draft criteria and raw map values from the UI workspace.
  FilterCriteriaSnapshot<FILTER_CRITERIA>? _draftFilterCriteriaSnapshot;

  /// The active draft criteria reflecting instant inputs in the FilterPanel workspace.
  FILTER_CRITERIA? get draftFilterCriteria =>
      _draftFilterCriteriaSnapshot?.criteriaOrNull;

  /// Diagnostic access to the draft criteria and map value wrapper.
  FilterCriteriaSnapshot<FILTER_CRITERIA>?
      get debugDraftFilterCriteriaSnapshot => _draftFilterCriteriaSnapshot;

  /// The active data state of the draft workspace (Pending, Loaded, or Error during cascade loading).
  FilterDataState get draftDataState =>
      _filterModelStructure._draftFilterDataState;

  // ===========================================================================
  // APPLIED REALM (Committed snapshot consumed by bound Blocks and Scalars)
  // ===========================================================================

  /// Holds the committed criteria snapshot that bound Blocks and Scalars actively query against.
  FilterCriteriaSnapshot<FILTER_CRITERIA>? _committedFilterCriteriaSnapshot;

  /// The committed criteria snapshot consumed by bound Blocks and Scalars.
  FILTER_CRITERIA? get committedFilterCriteria =>
      _committedFilterCriteriaSnapshot?.criteriaOrNull;

  /// Diagnostic access to the committed criteria wrapper object.
  FilterCriteriaSnapshot<FILTER_CRITERIA>?
      get debugAppliedFilterCriteriaSnapshot =>
          _committedFilterCriteriaSnapshot;

  /// The committed data state snapshot reflecting the readiness of the committed criteria.
  FilterDataState _committedDataState = FilterDataStatePending();

  /// The committed data state snapshot consumed by bound Blocks and Scalars.
  FilterDataState get committedDataState => _committedDataState;

  // ===========================================================================
  // BACKWARD COMPATIBILITY ALIASES & CRITERIA COMPARISONS
  // ===========================================================================

  /// Alias for [debugAppliedFilterCriteriaSnapshot].
  FilterCriteriaSnapshot<FILTER_CRITERIA>? get debugFilterCriteriaSnapshot =>
      _committedFilterCriteriaSnapshot;

  /// Indicates whether the draft workspace holds criteria different from the committed snapshot.
  bool get hasUncommittedCriteriaChanges {
    return draftFilterCriteria != committedFilterCriteria;
  }

  /// Indicates whether either the criteria or the data state in draft differs from committed.
  bool get hasUncommittedChanges {
    return draftFilterCriteria != committedFilterCriteria ||
        draftDataState != committedDataState;
  }

  late final _FilterModelDebugInfo debug = _FilterModelDebugInfo();

  bool __initiatedAtLeastOnce = false;

  bool get initiatedAtLeastOnce => __initiatedAtLeastOnce;

  bool __lockAddMoreQuery = false;

  bool get lockAddMoreQuery => __lockAddMoreQuery;

  bool _isDefaultFilterModel = false;

  bool get isDefaultFilterModel => _isDefaultFilterModel;

  late final FilterModelStructure _filterModelStructure;

  FilterModelStructure get filterModelStructure => _filterModelStructure;

  /// Error information resolved from the committed committed state.
  ErrorInfo? get errorInfo {
    return switch (committedDataState) {
      FilterDataStateError(:final errorInfo) => errorInfo,
      _ => null
    };
  }

  /// True if the committed committed state holds an error.
  bool get hasError {
    return committedDataState.isError;
  }

  /// Error information resolved from the draft workspace state.
  ErrorInfo? get draftErrorInfo {
    return switch (draftDataState) {
      FilterDataStateError(:final errorInfo) => errorInfo,
      _ => null
    };
  }

  /// True if the draft workspace state holds an error.
  bool get hasDraftError {
    return draftDataState.isError;
  }

  late final ui = _FilterUiComponents(filterModel: this);

  // ***************************************************************************
  // ***************************************************************************

  FilterModel({
    FilterModelConfig config = const FilterModelConfig(),
  })  : config = config.copy(),
        effectiveConfig = FilterModelEffectiveConfig._fromConfig(config) {
    __defineFilterModelStructure();
  }

  // ***************************************************************************
  // ***************************************************************************

  XFilterModel _createXFilterModel({required XShelf xShelf}) {
    return XFilterModel._(
      xShelf: xShelf,
      filterModel: this,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  ///
  /// ```dart
  /// @override
  /// FilterModelStructure defineFilterModelStructure() {
  ///   return FilterModelStructure(
  ///     criteriaStructure: FilterCriteriaStructure(
  ///       simpleCriterionDefs: [
  ///         SimpleFilterCriterionDef<String>(criterionBaseName: "searchText"),
  ///       ],
  ///       multiOptCriterionDefs: [
  ///         // Multi Options Single Selection Criterion.
  ///         MultiOptFilterCriterionDef<AlbumInfo>.singleSelection(
  ///           criterionBaseName: "album",
  ///           fieldName: 'albumId',
  ///           toFieldValue: (AlbumInfo? rawValue) {
  ///             return SimpleVal.ofInt(rawValue?.id);
  ///           },
  ///         ),
  ///       ],
  ///     ),
  ///     conditionStructure: FilterConditionStructure(
  ///       connector: FilterConnector.and,
  ///       conditionDefs: [
  ///         FilterConditionDef.simple(
  ///           tildeCriterionName: "searchText~",
  ///           operator: FilterOperator.containsIgnoreCase,
  ///         ),
  ///         FilterConditionDef.simple(
  ///           tildeCriterionName: "album~",
  ///           operator: FilterOperator.equalTo,
  ///         ),
  ///       ],
  ///     ),
  ///   );
  /// }
  /// ```
  ///
  @_AbstractMethodAnnotation()
  FilterModelStructure defineFilterModelStructure();

  // ***************************************************************************
  // ***************************************************************************

  ///
  /// Abstract method:
  ///
  @_AbstractMethodAnnotation()
  Future<XData?> performLoadMultiOptTildeCriterionXData({
    required String multiOptTildeCriterionName,
    required String multiOptCriterionBaseName,
    required Object? parentMultiOptTildeCriterionValue,
    required SelectionType selectionType,
    required FILTER_INPUT? filterInput,
  });

  // ***************************************************************************
  // ABSTRACT METHOD:
  // ***************************************************************************

  @_AbstractMethodAnnotation()
  OptValueWrap? specifyDefaultValueForMultiOptTildeCriterion({
    required String multiOptTildeCriterionName,
    required String multiOptCriterionBaseName,
    required Object? parentMultiOptTildeCriterionValue,
    required XData multiOptTildeCriterionXData,
    required SelectionType selectionType,
  });

  // ***************************************************************************
  // ABSTRACT METHOD:
  // ***************************************************************************

  // SAME-AS: #0011 (form - specifyDefaultValuesForSimpleProps)
  @_AbstractMethodAnnotation()
  Map<String, dynamic>? specifyDefaultValuesForSimpleTildeCriteria();

  // ***************************************************************************
  // ABSTRACT METHOD:
  // ***************************************************************************

  ///
  /// ```dart
  /// @override
  /// ValueWrap? extractUpdateValueForMultiOptTildeCriterion({
  ///     required String multiOptTildeCriterionName,
  ///     required String multiOptCriterionBaseName,
  ///     required Object? parentMultiOptTildeCriterionValue,
  ///     required SelectionType selectionType,
  ///     required ExampleFilterInput filterInput,
  ///     required XData multiOptTildeCriterionXData,
  /// }) {
  ///    if(multiOptTildeCriterionName == "company") {
  ///       int inputCompanyId = filterInput.filterInput;
  ///       CompanyInfo? inputCompany = materPropData?.getItemById(inputCompanyId);
  ///       return ValueWrap.single(inputCompany)
  ///    }
  ///    return null;
  /// }
  /// ```
  ///
  @_AbstractMethodAnnotation()
  OptValueWrap? extractUpdateValueForMultiOptTildeCriterion({
    required String multiOptTildeCriterionName,
    required String multiOptCriterionBaseName,
    required Object? parentMultiOptTildeCriterionValue,
    required SelectionType selectionType,
    required XData multiOptTildeCriterionXData,
    required FILTER_INPUT filterInput,
  });

  // ***************************************************************************
  // ABSTRACT METHOD:
  // ***************************************************************************

  // OLD: getSimpleCriterionValuesFromFilterInput.
  // SAME-AS: #0010 (form - extractUpdateValuesForSimpleProps)
  @_AbstractMethodAnnotation()
  Map<String, SimpleValueWrap?>? extractUpdateValuesForSimpleTildeCriteria({
    required FILTER_INPUT filterInput,
  });

  // ***************************************************************************
  // ***************************************************************************

  ///
  /// This method is called immediately after
  /// calling [performLoadMultiOptTildeCriterionXData]
  /// methods if there are no errors.
  ///
  /// ```dart
  ///  MyFilterCriteria createNewFilterCriteria({
  ///     required Map<String, dynamic> tildeCriteriaMap,
  ///  }) {
  ///      return MyFilterCriteria(
  ///         company: tildeCriteriaMap["company"],
  ///         department: tildeCriteriaMap["department"],
  ///      );
  ///  }
  /// ```
  ///
  @_AbstractMethodAnnotation()
  FILTER_CRITERIA createNewFilterCriteria({
    required Map<String, dynamic> tildeCriteriaMap,
  });

  // ***************************************************************************
  // SNAPSHOT SYNCHRONIZATION
  // ***************************************************************************

  /// Applies the specified [FilterSyncDirective] to reconcile the draft workspace
  /// with the committed snapshot realm.
  ///
  /// **CRITICAL ARCHITECTURAL CONTRACT**:
  /// Calling this method mutates the committed snapshot state of this [FilterModel]
  /// and **MUST ALWAYS** be coupled with an immediate, actual query execution pipeline
  /// (e.g. within [Block.query], [Scalar.query], or [Block.queryEmpty]).
  ///
  /// **Why standalone calls are strictly prohibited**:
  /// 1. **Visual State Desynchronization**: If this method commits a new criteria snapshot
  ///    (e.g. switching keyword from "Samsung" to "Apple") without immediately executing
  ///    a query on active consumers, visible blocks will continue displaying stale records
  ///    while the filter panel reflects the new criteria, severely confusing the user.
  /// 2. **Broken Reactive Contracts**: Mutating [committedFilterCriteria] and [committedDataState]
  ///    without dispatching an execution unit causes bound consumer blocks to calculate invalid
  ///    freshness flags (such as [hasUnappliedFilter]) while remaining unqueried.
  /// 3. **Cascade Multi-Block Inconsistency**: In multi-block setups sharing this [FilterModel],
  ///    committing snapshot state without executing a query pipeline leaves sibling blocks
  ///    in an uncoordinated and desynchronized lifecycle.
  /// Applies the specified [FilterSyncDirective] to reconcile the draft workspace
  /// with the committed snapshot realm.
  ///
  /// If a programmatic [filterInput] is supplied, it takes strict precedence over
  /// the directive and automatically commits the resulting snapshot to the committed realm.
  void _applyFilterSyncDirective({
    required FilterSyncDirective filterSyncDirective,
    required FILTER_INPUT? filterInput,
  }) {
    // 1. Programmatic Input Override:
    // When code explicitly injects a filterInput, it is an authoritative command
    // that must be committed into the committed realm immediately.
    if (filterInput != null) {
      _commitDraftSnapshotToCommitted();
      return;
    }

    // 2. Error Recovery Van: If committed is broken but draft has been fixed,
    // auto-commit the valid draft to escape the error trap.
    if (committedDataState.isError && draftDataState.isLoaded) {
      _commitDraftSnapshotToCommitted();
      return;
    }

    // 3. Interactive Workspace Reconciliation:
    switch (filterSyncDirective) {
      case FilterSyncDirective.useCommitted:
        // Preserve committed realm; do not modify draft workspace.
        break;

      case FilterSyncDirective.forceCommitDraft:
        // Unconditionally mirror draft workspace snapshot to committed realm.
        _commitDraftSnapshotToCommitted();
        break;

      case FilterSyncDirective.commitDraftIfValid:
        // Commit draft workspace snapshot only if free of validation or cascade errors.
        if (draftDataState.isLoaded) {
          _commitDraftSnapshotToCommitted();
        }
        break;

      case FilterSyncDirective.discardDraftToCommitted:
        // Roll back draft workspace and UI controls back to committed snapshot.
        discardDraftToCommitted();
        break;
    }
  }

  /// Copies the current draft workspace state and criteria to the committed snapshot.
  ///
  /// This method faithfully mirrors whatever state the draft realm currently holds
  /// (Loaded, Pending, or Error) to the committed realm.
  void _commitDraftSnapshotToCommitted() {
    final bool dataStateChanged = _committedDataState != draftDataState;
    final bool criteriaChanged =
        _committedFilterCriteriaSnapshot != _draftFilterCriteriaSnapshot;
    final bool anyChanged = dataStateChanged || criteriaChanged;
    //
    _committedFilterCriteriaSnapshot = _draftFilterCriteriaSnapshot;
    _committedDataState = draftDataState;
    // Notify..
    if (anyChanged) {
      for (Block block in _blocks) {
        final BlockDataState blockDataState = block.dataState;
        if (blockDataState is BlockDataStatePending) {
          final BlockPendingReason reason = blockDataState.reason;
          if (reason.isFailed) {
            block._blockData._setBlockDataState(
              newBlockDataState: BlockDataStatePending(
                reason: BlockPendingReasonFilterChanged(),
              ),
            );
          }
        } else if (blockDataState is BlockDataStateLoadedStale) {
          final BlockLoadedStateStaleReason reason = blockDataState.reason;
          if (reason.isFailed) {
            block._blockData._setBlockDataState(
              newBlockDataState: BlockDataStateLoadedStale(
                reason: BlockLoadedStateStaleReasonFilterChanged(),
              ),
            );
          }
        } else if (blockDataState is BlockDataStateLoadedFresh) {
          block._blockData._setBlockDataState(
            newBlockDataState: BlockDataStateLoadedStale(
              reason: BlockLoadedStateStaleReasonFilterChanged(),
            ),
          );
        }
      }
      for (Scalar scalar in _scalars) {
        final ScalarDataState scalarDataState = scalar.dataState;
        if (scalarDataState is ScalarDataStatePending) {
          final ScalarPendingReason reason = scalarDataState.reason;
          if (reason.isFailed) {
            scalar._scalarData._setScalarDataState(
              newScalarDataState: ScalarDataStatePending(
                reason: ScalarPendingReasonFilterChanged(),
              ),
            );
          }
        } else if (scalarDataState is ScalarDataStateLoadedStale) {
          final ScalarLoadedStateStaleReason reason = scalarDataState.reason;
          if (reason.isFailed) {
            scalar._scalarData._setScalarDataState(
              newScalarDataState: ScalarDataStateLoadedStale(
                reason: ScalarLoadedStateStaleReasonFilterChanged(),
              ),
            );
          }
        } else if (scalarDataState is ScalarDataStateLoadedFresh) {
          scalar._scalarData._setScalarDataState(
            newScalarDataState: ScalarDataStateLoadedStale(
              reason: ScalarLoadedStateStaleReasonFilterChanged(),
            ),
          );
        }
      }
    }
  }

  /// Discards uncommitted draft workspace changes and restores the committed snapshot.
  void discardDraftToCommitted() {
    _draftFilterCriteriaSnapshot = _committedFilterCriteriaSnapshot;
    _filterModelStructure._setDraftFilterDataState(_committedDataState);

    switch (_committedFilterCriteriaSnapshot) {
      case FilterCriteriaSnapshotSuccess(:final filterCriteriaMap):
        // 1. Update values into temporary workspace with cascade awareness
        _filterModelStructure._updateCriteriaTempValues(filterCriteriaMap);

        // 2. Commit temporary values to real current values
        _filterModelStructure._updateTempToReal();

        // 3. Patch UI Form controls back to committed criteria values
        _formKeyPatchValue(
          newCurrentValue: _filterModelStructure._currentCriteriaValues,
        );
        break;

      case FilterCriteriaSnapshotError():
      case null:
        // Committed realm is either uninitialized or in an error state.
        // No valid form map exists to patch into UI controls.
        break;
    }
  }

  FilterCriteriaSnapshot<FILTER_CRITERIA> __createFilterCriteriaSnapshot({
    required Map<String, dynamic> tildeCriteriaMap,
    required FilterConditionGroupVal baseCriteria,
    required bool isPrecheck,
  }) {
    FILTER_CRITERIA filterCriteria = createNewFilterCriteria(
      tildeCriteriaMap: tildeCriteriaMap,
    );
    filterCriteria._initFilterCriteria(
      baseCriteria: baseCriteria,
      isPrecheck: isPrecheck,
    );
    return FilterCriteriaSnapshotSuccess<FILTER_CRITERIA>(
      filterCriteria: filterCriteria,
      filterCriteriaMap: tildeCriteriaMap,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  void __filterCriteriaPrecheck() {
    if (_filterCriteriaPrechecked) {
      return;
    }
    try {
      final filterCriteriaSnapshot = __createFilterCriteriaSnapshot(
        tildeCriteriaMap: {},
        baseCriteria: FilterConditionGroupVal.empty(),
        isPrecheck: true,
      );
    } on FilterModelRegisterError catch (_) {
      rethrow;
    }
    // IMPORTANT: If can not initial FilterCriteria,..
    catch (e) {
      // Do nothing.
    }
    _filterCriteriaPrechecked = true;
  }

  // ***************************************************************************
  // ***************************************************************************

  @_ExecutionUnitMethodAnnotation()
  @_FilterModelLoadDataAnnotation()
  Future<bool> _unitLoadFilterData({
    required ExecutionTrace executionTrace,
    required ExecutionUnitType executionUnitType,
    required XFilterModel thisXFilterModel,
    required FilterModelLoadIntent executionIntent,
  }) async {
    __assertThisXFilterModel(thisXFilterModel);
    thisXFilterModel._createAndSetFilterModelExecutionIntentDone();
    //
    executionTrace.addInfo(
      codeId: "#24000",
      shortDesc: "Begin ${executionUnitType.asDebugExecutionUnit()}.",
    );
    //
    final executionResult = executionIntent.resultWrapper._setResult(
      EmptyExecutionUnitResult(),
      objectCaller: this,
      methodName: '_unitLoadFilterData',
    );
    executionTrace.addInfo(
      codeId: "#24100",
      shortDesc: "Debug",
      parameters: {
        "thisXFilterModel.loadedInSession": thisXFilterModel.loadedInSession,
      },
    );
    //
    try {
      // SAME-AS: #0004
      if (!thisXFilterModel.loadedInSession) {
        final filterInput = thisXFilterModel.filterInput as FILTER_INPUT?;
        //
        final bool isFirstTime = !__initiatedAtLeastOnce;
        executionTrace.addInfo(
          codeId: "#24200",
          shortDesc: "Debug",
          parameters: {
            "isFirstTime": isFirstTime,
            "effectiveConfig.applyPolicy": effectiveConfig.applyPolicy,
          },
        );
        // Auto-commit on first run, instant policy, OR when recovering from an error state
        final bool recoveringFromCommittedError = committedDataState.isError;
        //
        _draftFilterCriteriaSnapshot = await _startNewFilterActivity(
          executionTrace: executionTrace,
          activityType: FilterActivityType.newFilt,
          filterInput: filterInput,
          formKeyInstantValuesInUI: null,
        );
        executionTrace.addInfo(
          codeId: "#24400",
          shortDesc: "Debug:",
          parameters: {
            "committedFilterCriteriaSnapshot.isError":
                _committedFilterCriteriaSnapshot?.isError,
            "draftFilterCriteriaSnapshot.isError":
                _draftFilterCriteriaSnapshot?.isError,
          },
        );
        //
        if (isFirstTime ||
            recoveringFromCommittedError ||
            effectiveConfig.applyPolicy == FilterApplyPolicy.instant ||
            thisXFilterModel.filterApplyPolicy == FilterApplyPolicy.instant) {
          executionTrace.addNonControllableCall(
            codeId: "#24300",
            caller: this,
            methodName: "_commitDraftSnapshotToCommitted",
            suffixShortDesc: "",
          );
          //
          _commitDraftSnapshotToCommitted();
        }
      }
      return true;
    } catch (e, stackTrace) {
      // TODO: Test case.
      // Never Run.
      print("ERROR _unitQuery: $stackTrace");
    } finally {
      thisXFilterModel.resetExecutionHints();
      thisXFilterModel.loadedInSession = true;
    }
    return false;
  }

  // ***************************************************************************
  // ***************************************************************************

  @_ExecutionUnitMethodAnnotation()
  @_FilterPanelChangeAnnotation()
  Future<bool> _unitFilterPanelChanged({
    required ExecutionTrace executionTrace,
    required ExecutionUnitType executionUnitType,
    required XFilterModel thisXFilterModel,
    required FilterModelFilterPanelChangeIntent executionIntent,
  }) async {
    __assertThisXFilterModel(thisXFilterModel);
    thisXFilterModel._createAndSetFilterModelExecutionIntentDone();
    //
    executionTrace.addInfo(
      codeId: "#30000",
      shortDesc:
          "${debugObjHtml(this)} -> Begin ${executionUnitType.asDebugExecutionUnit()}.",
    );
    final executionResult = executionIntent.resultWrapper._setResult(
      EmptyExecutionUnitResult(),
      objectCaller: this,
      methodName: '_unitFilterPanelChanged',
    );
    //
    try {
      FilterCriteriaSnapshot<FILTER_CRITERIA>? xFilterCriteria =
          await _startNewFilterActivity(
        executionTrace: executionTrace,
        activityType: FilterActivityType.updateFromFilterPanel,
        filterInput: null,
        formKeyInstantValuesInUI: executionIntent.formKeyInstantValuesInUI,
      );
      // Under instant policy, auto-commit draft snapshot to committed realm.
      if (effectiveConfig.applyPolicy == FilterApplyPolicy.instant) {
        _commitDraftSnapshotToCommitted();
      }
      return xFilterCriteria != null;
    } finally {
      // Do nothing.
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  void __defineFilterModelStructure() {
    try {
      _filterModelStructure = defineFilterModelStructure();
      _filterModelStructure.filterModel = this;
      __filterCriteriaPrecheck();
    }
    // criterionBaseName is not valid:
    on FilterCriterionInvalidBaseNameError catch (e) {
      String message = "Invalid criterionBaseName '${e.criterionBaseName}'.\n"
          "@see the '${getClassNameWithoutGenerics(this)}.defineFilterModelStructure()' method for details.";
      throw _createFatalAppError(message);
    }
    // fieldName is not valid:
    on FilterCriterionFieldNameInvalidError catch (e) {
      String message = "Invalid fieldName '${e.fieldName}'.\n"
          "@see the '${getClassNameWithoutGenerics(this)}.defineFilterModelStructure()' method for details.";
      throw _createFatalAppError(message);
    }
    // No Field Converter:
    on FilterCriterionNoFieldValueConverterError catch (e) {
      String message =
          "Data type of '${e.criterionBaseName}' is '${e.dataType}' (Not simple data type).\n"
          "So you need to provide toFieldValue() function.\n"
          "@see the '${getClassNameWithoutGenerics(this)}.defineFilterModelStructure()' method for details.";
      throw _createFatalAppError(message);
    }
    // tildeCriterionName is not valid:
    on TildeFilterCriterionNameInvalidError catch (e) {
      String message = "Invalid tildeCriterionName '${e.tildeCriterionName}'.\n"
          "@see the '${getClassNameWithoutGenerics(this)}.defineFilterModelStructure()' method for details.";
      throw _createFatalAppError(message);
    }
    // parentMatchSuffix is not valid:
    on TildeFilterCriterionSuffixInvalidError catch (e) {
      String message =
          "Invalid parentMatchSuffix '${e.tildeSuffix}' (The correct examples: '~', '~1', '~min').\n"
          "@see the '${getClassNameWithoutGenerics(this)}.defineFilterModelStructure()' method for details.";
      throw _createFatalAppError(message);
    }
    // criterionBaseName not found:
    on TildeFilterCriterionBaseCriterionNotFoundError catch (e) {
      String message =
          "There is no criterionBaseName '${e.criterionBaseName}' corresponding to tildeCriterionName '${e.tildeCriterionName}'.\n"
          "@see the '${getClassNameWithoutGenerics(this)}.defineFilterModelStructure()' method for details.";
      throw _createFatalAppError(message);
    }
    // Duplicate criterionBaseName
    on FilterCriterionDuplicateNameError catch (e) {
      String message = "Duplicate criterionBaseName '${e.criterionBaseName}'.\n"
          "@see the '${getClassNameWithoutGenerics(this)}.defineFilterModelStructure()' method for details.";
      throw _createFatalAppError(message);
    }
    // Duplicate fieldName
    on FilterCriterionDuplicateFieldNameError catch (e) {
      String message =
          "Duplicate fieldName '${e.fieldName}' (criterionBaseName: ${e.criterionBaseName}).\n"
          "@see the '${getClassNameWithoutGenerics(this)}.defineFilterModelStructure()' method for details.";
      throw _createFatalAppError(message);
    }
    // TildeCriterionConfig - Invalid Suffix.
    on TildeCriterionConfigInvalidSuffixError catch (e) {
      String message =
          "Invalid TildeCriterionConfig(suffix: '${e.tildeSuffix}') (criterionBaseName: ${e.criterionBaseName}).\n"
          "The correct examples: '~', '~1', '~min'.\n"
          "@see the '${getClassNameWithoutGenerics(this)}.defineFilterModelStructure()' method for details.";
      throw _createFatalAppError(message);
    }
    // TildeCriterionConfig - Duplicate Suffix.
    on TildeCriterionConfigDuplicationSuffixError catch (e) {
      String message =
          "Duplicate TildeCriterionConfig(suffix: '${e.tildeSuffix}') (criterionBaseName: ${e.criterionBaseName}).\n"
          "@see the '${getClassNameWithoutGenerics(this)}.defineFilterModelStructure()' method for details.";
      throw _createFatalAppError(message);
    }
    // Duplicate tildeCriterionName in a Group:
    on FilterConditionGroupDuplicateTildeError catch (e) {
      String message =
          "Duplicate tildeCriterionName '${e.tildeCriterionName}' in '${e.groupName}' group.\n"
          "@see the '${getClassNameWithoutGenerics(this)}.defineFilterModelStructure()' method for details.";
      throw _createFatalAppError(message);
    }
    // Duplicate groupName:
    on FilterConditionGroupDuplicateNameError catch (e) {
      String message = "Duplicate groupName '${e.groupName}'.\n"
          "@see the '${getClassNameWithoutGenerics(this)}.defineFilterModelStructure()' method for details.";
      throw _createFatalAppError(message);
    }
    // FilterCriteria class: Duplicate criterionName.
    on FilterCriteriaDuplicateCriterionError catch (e) {
      String message = "Duplicate criterionBaseName '${e.criterionBaseName}'.\n"
          "@see the '${e.filterCriteriaClassName}.registerSupportedCriteria()' method for details.";
      throw _createFatalAppError(message);
    }
    // FilterCriteria class: Duplicate Field.
    on FilterCriteriaDuplicateFieldError catch (e) {
      String message = "Duplicate field '${e.field}'.\n"
          "@see the '${e.filterCriteriaClassName}.registerSupportedCriteria()' method for details.";
      throw _createFatalAppError(message);
    }
    // Other Error:
    catch (e, stackTrace) {
      print(stackTrace);
      String message =
          "Unknown Error $e in ${getClassNameWithoutGenerics(this)}";
      throw _createFatalAppError(message);
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  // TODO: Rename?
  Map<String, dynamic> get initialCriteriaValues {
    return _filterModelStructure._initialCriteriaValues;
  }

  // TODO: Rename?
  Map<String, dynamic> get criteriaValues {
    return _filterModelStructure._currentCriteriaValues;
  }

  // ***************************************************************************
  // ***************************************************************************

  bool isDirty() {
    return _filterModelStructure._isDirty();
  }

  // ***************************************************************************
  // ***************************************************************************

  dynamic getTildeCriterionValue(String tildeCriterionName) {
    return _filterModelStructure._getCurrentCriterionValue(
      tildeCriterionName: tildeCriterionName,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  XData? getMultiOptTildeCriterionXData(String multiOptTildeCriterionName) {
    return _filterModelStructure._getMultiOptTildeCriterionXData(
      multiOptTildeCriterionName,
    );
  }

  dynamic getMultiOptTildeCriterionData(String multiOptTildeCriterionName) {
    XData? multiOptTildeCriterionXData = getMultiOptTildeCriterionXData(
      multiOptTildeCriterionName,
    );
    //
    dynamic data = multiOptTildeCriterionXData?.data;
    if (data != null) {
      return data;
    } else {
      return data;
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  void _printStructureAndTempData(String prefix) {
    _filterModelStructure._printTemporaryInfo(prefix);
  }

  // ***************************************************************************
  // ***************************************************************************

  // void _formKeyPatchValue({required Map<String, dynamic> newCurrentValue}) {
  //   try {
  //     FlutterArtist._lockAddMoreQuery = true;
  //     __lockAddMoreQuery = true;
  //     _formKey.currentState?.patchValue(newCurrentValue);
  //   } finally {
  //     FlutterArtist._lockAddMoreQuery = false;
  //     __lockAddMoreQuery = false;
  //   }
  // }

  void _formKeyPatchValue({required Map<String, dynamic> newCurrentValue}) {
    try {
      FlutterArtist._lockAddMoreQuery = true;
      __lockAddMoreQuery = true;
      final List<FormBuilderState> activeForms = ui._visibleFormBuilderStates;

      for (FormBuilderState formState in activeForms) {
        // Only patch fields that this Form actually owns or allows
        // flutter_form_builder supports safe patchValue for maps containing multiple fields
        formState.patchValue(newCurrentValue);
      }
    } finally {
      FlutterArtist._lockAddMoreQuery = false;
      __lockAddMoreQuery = false;
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  ///
  /// Return null is error.
  ///
  @_ImportantMethodAnnotation(
      "Called after changing in FilterPanel or Querying in Block or Scalar.")
  Future<FilterCriteriaSnapshot<FILTER_CRITERIA>?> _startNewFilterActivity({
    required ExecutionTrace executionTrace,
    required FILTER_INPUT? filterInput,
    required FilterActivityType activityType,
    required Map<String, dynamic>? formKeyInstantValuesInUI,
  }) async {
    debug._filterActivityCount++;
    //
    if (activityType == FilterActivityType.newFilt) {
      debug._loadCount++;
    }

    final Map<String, dynamic> formKeyInstantValues =
        formKeyInstantValuesInUI ??
            _filterModelStructure._currentCriteriaValues;
    //
    if (this is! _DefaultFilterModel) {
      executionTrace.addNonControllableCall(
        codeId: "#31020",
        caller: _filterModelStructure,
        methodName: "_setupTemporaryStateForNewActivity",
        suffixShortDesc: "",
      );
    }
    try {
      _filterModelStructure._setupTemporaryStateForNewActivity(
        activityType: activityType,
        formKeyInstantValues: formKeyInstantValues,
        filterInput: filterInput,
      );
    } catch (e, stackTrace) {
      dynamic error = e;
      if (e is FilterCriterionTypeMismatchError) {
        // Bug: #Bug#002
        error = e.toAppError(
          filterModelName: getClassNameWithoutGenerics(this),
        );
      } else if (e is FilterMultiOptMsMismatchError) {
        // Bug: #Bug#003
        error = e.toAppError(
          filterModelName: getClassNameWithoutGenerics(this),
        );
      }
      final ErrorInfo errorInfo = _handleError(
        shelf: shelf,
        methodName: "_setupTemporaryStateForNewActivity",
        error: error,
        stackTrace: stackTrace,
        showSnackBar: true,
        tipDocument: null,
      );
      executionTrace.addInfo(
        codeId: "#31030",
        shortDesc:
            "The ${debugObjHtml(this)}._loadMultiOptCriterionDataCascade() was called with an error.",
        errorInfo: errorInfo,
      );
      //
      final dataStateError = FilterDataStateError(errorInfo: errorInfo);
      _filterModelStructure._setDraftFilterDataState(dataStateError);
      _draftFilterCriteriaSnapshot =
          FilterCriteriaSnapshotError<FILTER_CRITERIA>(
        errorInfo: errorInfo,
      );
      return _draftFilterCriteriaSnapshot;
    }
    //
    // Load OptProp Data:
    //
    try {
      for (MultiOptTildeFilterCriterionModel multiOptCriterion
          in _filterModelStructure._rootOptCriterionModels) {
        executionTrace.addNonControllableCall(
          codeId: "#31040",
          caller: this,
          methodName: "_loadMultiOptCriterionDataCascade",
          suffixShortDesc:
              "To load data for ${debugObjHtml(multiOptCriterion)} and its descendants.",
          parameters: {
            "activityType": activityType,
            "filterInput": filterInput,
            "parentMultiOptTildeCriterionValue": null,
            "multiOptCriterion": multiOptCriterion,
            "formKeyInstantValues": formKeyInstantValues,
          },
        );
        //
        // Load OptCriterion Data and set default and selected.
        //
        // May throw ApiError.
        //
        await _loadMultiOptCriterionDataCascade(
          executionTrace: executionTrace,
          filterInput: filterInput,
          parentMultiOptTildeCriterionValue: null,
          multiOptCriterion: multiOptCriterion,
          formKeyInstantValues: formKeyInstantValues,
          activityType: activityType,
        );
      }
    } catch (e, stackTrace) {
      final FilterErrorInfo filterErrorInfo;

      if (e is FilterCriterionTypeMismatchError) {
        // Bug: #Bug#001
        filterErrorInfo = FilterErrorInfo(
          filterErrorMethod: FilterErrorMethod.unknown,
          activityType: activityType,
          tildeCriterionName: null,
          error: e.toAppError(
            filterModelName: getClassNameWithoutGenerics(this),
          ),
          errorStackTrace: stackTrace,
        );
      } else if (e is FilterMethodError) {
        // TODO-xxx
        filterErrorInfo = FilterErrorInfo(
          filterErrorMethod: e.filterErrorMethod,
          activityType: activityType,
          tildeCriterionName: e.tildeCriterionName,
          error: e.error,
          errorStackTrace: e.errorStackTrace,
        );
      } else {
        filterErrorInfo = FilterErrorInfo(
          filterErrorMethod: FilterErrorMethod.unknown,
          activityType: activityType,
          tildeCriterionName: null,
          error: e,
          errorStackTrace: stackTrace,
        );
      }
      final ErrorInfo errorInfo = _handleError(
        shelf: shelf,
        methodName: filterErrorInfo.methodName,
        error: filterErrorInfo.error,
        stackTrace: filterErrorInfo.errorStackTrace,
        showSnackBar: true,
        tipDocument: TipDocument.filterModelPerformLoadMultiOptCriterionXData,
      );
      executionTrace.addInfo(
        codeId: "#31080",
        shortDesc:
            "The ${debugObjHtml(this)}._loadMultiOptCriterionDataCascade() was called with an error.",
        errorInfo: errorInfo,
      );
      //
      final dataStateError = FilterDataStateError(errorInfo: errorInfo);
      _filterModelStructure._setDraftFilterDataState(dataStateError);
      _draftFilterCriteriaSnapshot =
          FilterCriteriaSnapshotError<FILTER_CRITERIA>(
        errorInfo: errorInfo,
      );
      return _draftFilterCriteriaSnapshot;
    }
    //
    if (filterInput != null) {
      try {
        executionTrace.addControllableCall(
          codeId: "#31140",
          caller: this,
          methodName: "updatedSimpleCriterionValues",
          suffixShortDesc:
              "To get values from filterInput to update for simpleCriteria",
          parameters: {
            "filterInput": filterInput,
          },
        );
        final Map<String, SimpleValueWrap?> updatedSimpleCriterionValues =
            extractUpdateValuesForSimpleTildeCriteria(
                  filterInput: filterInput,
                ) ??
                {};
        for (String tildeCriterionName in updatedSimpleCriterionValues.keys) {
          // Check and throw error if 'tildeCriterionName' is not a SimpleFilterCriterion:
          __throwErrorIfNotASimpleCriterionName(
            tildeCriterionName: tildeCriterionName,
            filterErrorMethod:
                FilterErrorMethod.extractUpdateValuesForSimpleTildeCriteria,
          );
          SimpleValueWrap? valueWrap =
              updatedSimpleCriterionValues[tildeCriterionName];
          // SAME-AS: #0012 (formModel)
          if (valueWrap != null && valueWrap.use) {
            _filterModelStructure._setTempSimpleCriterionValue(
              tildeCriterionName: tildeCriterionName,
              value: valueWrap.value,
            );
          }
        }
      } catch (e, stackTrace) {
        final ErrorInfo errorInfo = _handleError(
          shelf: shelf,
          methodName: "extractUpdateValuesForSimpleTildeCriteria",
          error: e,
          stackTrace: stackTrace,
          showSnackBar: true,
          tipDocument: null,
        );
        //
        executionTrace.addInfo(
          codeId: "#31200",
          shortDesc:
              "The ${debugObjHtml(this)}.updatedSimpleCriterionValues() method was called with an error.",
          errorInfo: errorInfo,
        );
        //
        final dataStateError = FilterDataStateError(errorInfo: errorInfo);
        _filterModelStructure._setDraftFilterDataState(dataStateError);
        _draftFilterCriteriaSnapshot =
            FilterCriteriaSnapshotError<FILTER_CRITERIA>(
          errorInfo: errorInfo,
        );
        return _draftFilterCriteriaSnapshot;
      }
    }
    // filterInput is null
    else {
      try {
        if (!__initiatedAtLeastOnce) {
          if (this is! _DefaultFilterModel) {
            executionTrace.addControllableCall(
              codeId: "#31300",
              caller: this,
              methodName: "specifyDefaultValuesForSimpleTildeCriteria",
              suffixShortDesc:
                  "To get default values for <b>simple criteria</b>.",
            );
          }
          final Map<String, dynamic> defaultSimpleCriterionValues =
              specifyDefaultValuesForSimpleTildeCriteria() ?? {};

          for (String tildeCriterionName in defaultSimpleCriterionValues.keys) {
            // Check and throw error if 'tildeCriterionName' is not a SimpleFilterCriterion:
            __throwErrorIfNotASimpleCriterionName(
              tildeCriterionName: tildeCriterionName,
              filterErrorMethod:
                  FilterErrorMethod.specifyDefaultValuesForSimpleTildeCriteria,
            );
            //
            dynamic value = defaultSimpleCriterionValues[tildeCriterionName];
            _filterModelStructure._setTempSimpleCriterionValue(
              tildeCriterionName: tildeCriterionName,
              value: value,
            );
          }
        }
      } catch (e, stackTrace) {
        final ErrorInfo errorInfo = _handleError(
          shelf: shelf,
          methodName: "specifyDefaultValuesForSimpleTildeCriteria",
          error: e,
          stackTrace: stackTrace,
          showSnackBar: true,
          tipDocument: null,
        );
        executionTrace.addInfo(
          codeId: "#31380",
          shortDesc:
              "The ${debugObjHtml(this)}.specifyDefaultValuesForSimpleTildeCriteria() method was called with an error.",
          errorInfo: errorInfo,
        );
        //
        final dataStateError = FilterDataStateError(errorInfo: errorInfo);
        _filterModelStructure._setDraftFilterDataState(dataStateError);
        _draftFilterCriteriaSnapshot =
            FilterCriteriaSnapshotError<FILTER_CRITERIA>(
          errorInfo: errorInfo,
        );
        return _draftFilterCriteriaSnapshot;
      }
    }
    //
    try {
      if (this is! _DefaultFilterModel) {
        executionTrace.addControllableCall(
          codeId: "#31420",
          caller: this,
          methodName: "createNewFilterCriteria",
          suffixShortDesc:
              "To convert criteria in type of Map to a Dart object.",
          parameters: {
            "dataMap": _filterModelStructure._tempCriteriaValues,
          },
          tipDocument: TipDocument.filterCriteria,
        );
      }
      //
      // Update Real FromData from Temporary FormData:
      //
      _filterModelStructure._updateTempToReal();
      //
      // IMPORTANT:
      //
      _formKeyPatchValue(
        newCurrentValue: _filterModelStructure._currentCriteriaValues,
      );
      //
      final Map<String, dynamic> newTildeCriteriaMap = {
        ..._filterModelStructure._tempCriteriaValues
      };

      FilterConditionGroupVal baseCriteria = _filterModelStructure
          .rootConditionGroupModel
          .toFilterCriteriaGroupVal();

      // Convert Map Data to FilterCriteria Object.
      final FilterCriteriaSnapshot<FILTER_CRITERIA> newFilterCriteriaSnapshot =
          __createFilterCriteriaSnapshot(
        tildeCriteriaMap: newTildeCriteriaMap,
        baseCriteria: baseCriteria,
        isPrecheck: false,
      );
      //
      if (this is! _DefaultFilterModel) {
        executionTrace.addInfo(
          codeId: "#31460",
          shortDesc:
              "Got an instance of ${debugObjHtml(newFilterCriteriaSnapshot)} (Dart object).\n"
              "This object will be passed to the <b>@filterCriteria</b> parameter "
              "of the <b>Block.query()</b> or <b>Scalar.query()</b> method.",
          tipDocument: TipDocument.filterCriteria,
        );
      }
      //
      _draftFilterCriteriaSnapshot = newFilterCriteriaSnapshot;
      //
      __initiatedAtLeastOnce = true;
      _filterModelStructure._setDraftFilterDataState(FilterDataStateLoaded());
      //
      return _draftFilterCriteriaSnapshot;
    } catch (e, stackTrace) {
      print(stackTrace);
      final ErrorInfo errorInfo = _handleError(
        shelf: shelf,
        methodName: "createNewFilterCriteria",
        error: e,
        stackTrace: stackTrace,
        showSnackBar: true,
        tipDocument: null,
      );
      //
      final newDataState = FilterDataStateError(errorInfo: errorInfo);
      _filterModelStructure._setDraftFilterDataState(newDataState);
      //
      // IMPORTANT:
      //
      _formKeyPatchValue(
        newCurrentValue: _filterModelStructure._currentCriteriaValues,
      );
      //
      _draftFilterCriteriaSnapshot =
          FilterCriteriaSnapshotError<FILTER_CRITERIA>(
        errorInfo: errorInfo,
      );
      executionTrace.addInfo(
        codeId: "#31500",
        shortDesc:
            "The ${debugObjHtml(this)}.createNewFilterCriteria() method was called with an error!",
        errorInfo: errorInfo,
      );
      return _draftFilterCriteriaSnapshot;
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  Future<void> _loadMultiOptCriterionDataCascade({
    required ExecutionTrace executionTrace,
    required FILTER_INPUT? filterInput,
    required Object? parentMultiOptTildeCriterionValue,
    required MultiOptTildeFilterCriterionModel multiOptCriterion,
    required Map<String, dynamic> formKeyInstantValues,
    required FilterActivityType activityType,
  }) async {
    final String multiOptTildeCriterionName =
        multiOptCriterion.tildeCriterionName;
    final String multiOptCriterionBaseName = multiOptCriterion.criterionName;
    final SelectionType selectionType = multiOptCriterion.selectionType;

    executionTrace.addInfo(
      codeId: "#82000",
      shortDesc:
          "Begin of ${debugObjHtml(this)}._loadMultiOptCriterionDataCascade() method.",
      parameters: {
        "filterInput": filterInput,
        "parentMultiOptTildeCriterionValue": parentMultiOptTildeCriterionValue,
        "multiOptCriterion": multiOptCriterion,
        "activityType": activityType,
      },
    );

    final MultiOptTildeFilterCriterionModel? multiOptCriterionParent =
        multiOptCriterion.parent;
    // Get current OptCriterion data:
    XData? tempMultiOptCriterionXData =
        _filterModelStructure._getTempMultiOptCriterionXData(
      multiOptTildeCriterionName,
    );
    final dynamic tempCurrentMultiOptValue =
        _filterModelStructure._getTempCurrentCriterionValue(
            tildeCriterionName: multiOptTildeCriterionName);
    //
    dynamic newSelectedValue =
        _filterModelStructure._getTempCurrentCriterionValue(
      tildeCriterionName: multiOptTildeCriterionName,
    );
    if (activityType == FilterActivityType.updateFromFilterPanel) {
      if (formKeyInstantValues.containsKey(multiOptTildeCriterionName)) {
        newSelectedValue = formKeyInstantValues[multiOptTildeCriterionName];
      }
    }
    //
    final bool valueChanged;
    if (tempMultiOptCriterionXData == null) {
      valueChanged = false;
    } else {
      valueChanged = !tempMultiOptCriterionXData.isSameItemOrItemList(
        itemOrItemList1: tempCurrentMultiOptValue,
        itemOrItemList2: newSelectedValue,
      );
    }
    executionTrace.addInfo(
      codeId: "#82100",
      shortDesc: "Debug:",
      parameters: {
        "tempCurrentMultiOptValue": tempCurrentMultiOptValue,
        "newSelectedValue": newSelectedValue,
        "valueChanged": valueChanged,
      },
    );
    // May throw Type error here!
    multiOptCriterion._tempCurrentValue = newSelectedValue;
    //
    if (valueChanged) {
      _filterModelStructure._updateChildrenMultiOptValueToNullCascade(
        multiOptCriterion: multiOptCriterion,
      );
    }
    //
    if (multiOptCriterionParent != null) {
      XData? tempMultiOptXDataParent =
          _filterModelStructure._getTempMultiOptCriterionXData(
        multiOptCriterionParent.tildeCriterionName,
      );
      //
      if (tempMultiOptXDataParent != null) {
        // Item or Item List (Multi Selection):
        Object? parentOptCriterionValueOLD =
            _filterModelStructure._getCurrentCriterionValue(
          tildeCriterionName: multiOptCriterionParent.tildeCriterionName,
        );
        // Parent Value change?
        bool isSame = tempMultiOptXDataParent.isSameItemOrItemList(
          itemOrItemList1: parentOptCriterionValueOLD,
          itemOrItemList2: parentMultiOptTildeCriterionValue,
        );
        if (!isSame) {
          tempMultiOptCriterionXData = null;
        }
      } else {
        tempMultiOptCriterionXData = null;
      }
    }
    //
    if (tempMultiOptCriterionXData == null) {
      _filterModelStructure._setTempMultiOptCriterionXData(
        multiOptTildeCriterionName: multiOptTildeCriterionName,
        multiOptXData: null,
      );
      // IMPORTANT:
      //  - Update from ROOTs to LEAVES
      //  - And make sure children-OptCriterion to null if parent-Value is null or not selected.
      _filterModelStructure._updateCriteriaTempValues({
        multiOptTildeCriterionName: null,
      });
    }
    bool newLoaded = false;
    if (tempMultiOptCriterionXData == null) {
      // Always increase "_loadCount" value regardless of error.
      multiOptCriterion._loadCount++;
      newLoaded = true;
      //
      try {
        executionTrace.addInfo(
          codeId: "#82300",
          shortDesc:
              "Calling ${debugObjHtml(this)}.performLoadMultiOptTildeCriterionXData():",
          parameters: {
            "filterInput": filterInput,
            "parentMultiOptTildeCriterionValue":
                parentMultiOptTildeCriterionValue,
            "multiOptCriterionBaseName": multiOptCriterionBaseName,
            "multiOptTildeCriterionName": multiOptTildeCriterionName,
            "selectionType": selectionType,
          },
        );
        // May throw AppError, ApiError or others.
        //
        // Load OptCriterion data from Rest API.
        // May throw ApiError.
        //
        tempMultiOptCriterionXData =
            await performLoadMultiOptTildeCriterionXData(
          filterInput: filterInput,
          parentMultiOptTildeCriterionValue: parentMultiOptTildeCriterionValue,
          multiOptCriterionBaseName: multiOptCriterionBaseName,
          multiOptTildeCriterionName: multiOptTildeCriterionName,
          selectionType: selectionType,
        );
        executionTrace.addInfo(
          codeId: "#82400",
          shortDesc: "Debug. Return value: ",
          parameters: {
            "tempMultiOptCriterionXData": tempMultiOptCriterionXData,
          },
        );
      } catch (e, stackTrace) {
        // TODO: Test Case??
        throw FilterMethodError(
          tildeCriterionName: multiOptTildeCriterionName,
          filterErrorMethod:
              FilterErrorMethod.performLoadMultiOptTildeCriterionXData,
          error: e, // May be AppError, ApiError or others.
          errorStackTrace: stackTrace,
        );
      }
    }
    //
    // IMPORTANT: Do not use empty list here
    // to avoid cast Error (List<dynamic> to List<ITEM>)
    //
    List? currentSelectedItems; // will be null or not empty.
    // Candidate Selected Items:
    List? candidateSelectedItems;
    if (tempMultiOptCriterionXData != null) {
      OptValueWrap? inputValueWrap;
      if (filterInput != null) {
        // Test Case: [20c], [20d].
        inputValueWrap = __extractUpdateValueForMultiOptTildeCriterion(
          filterInput: filterInput,
          parentMultiOptTildeCriterionValue: parentMultiOptTildeCriterionValue,
          multiOptTildeCriterionXData: tempMultiOptCriterionXData,
          multiOptCriterionBaseName: multiOptCriterionBaseName,
          multiOptTildeCriterionName: multiOptTildeCriterionName,
          selectionType: selectionType,
        );
      } else {
        final parentMatchSuffix = multiOptCriterion.parentMatchSuffix;
        final defaultSettingPolicy = multiOptCriterion.defaultSettingPolicy;
        if ((!__initiatedAtLeastOnce &&
                defaultSettingPolicy == DefaultSettingPolicy.onInitialOnly) ||
            (newLoaded &&
                multiOptCriterion._tempCurrentValue == null &&
                defaultSettingPolicy == DefaultSettingPolicy.onEveryLoad)) {
          executionTrace.addNonControllableCall(
            codeId: "#82460",
            caller: this,
            methodName: "__specifyDefaultValueForMultiOptTildeCriterion",
            suffixShortDesc: "",
            parameters: {
              "parentMultiOptTildeCriterionValue":
                  parentMultiOptTildeCriterionValue,
              "multiOptCriterionBaseName": multiOptCriterionBaseName,
              "multiOptTildeCriterionName": multiOptTildeCriterionName,
              "selectionType": selectionType,
            },
          );
          inputValueWrap = __specifyDefaultValueForMultiOptTildeCriterion(
            multiOptCriterionBaseName: multiOptCriterionBaseName,
            multiOptTildeCriterionName: multiOptTildeCriterionName,
            parentMultiOptTildeCriterionValue:
                parentMultiOptTildeCriterionValue,
            multiOptTildeCriterionXData: tempMultiOptCriterionXData,
            selectionType: selectionType,
          );
          executionTrace.addInfo(
            codeId: "#82470",
            shortDesc: "Debug",
            parameters: {
              "inputValueWrap": inputValueWrap,
            },
          );
        }
      }
      //
      // Current selected value:
      // It can be a single value or a List.
      //
      final dynamic tempCurrentValue =
          _filterModelStructure._getTempCurrentCriterionValue(
        tildeCriterionName: multiOptTildeCriterionName,
      );
      //
      if (tempCurrentValue != null) {
        if (tempCurrentValue is List) {
          currentSelectedItems =
              tempCurrentValue.isEmpty ? null : tempCurrentValue;
        } else {
          currentSelectedItems = [tempCurrentValue];
        }
      }
      if (currentSelectedItems != null) {
        currentSelectedItems =
            tempMultiOptCriterionXData._resolveItemsFromRawData(
          dynamicValues: currentSelectedItems,
          clearOrphanItems: true,
          addOrphan: false,
        );
      }
      // Candidate Selected Items:
      candidateSelectedItems = inputValueWrap?.values;

      if (candidateSelectedItems == null || candidateSelectedItems.isEmpty) {
        candidateSelectedItems = currentSelectedItems;
      }
    } else {
      currentSelectedItems = null;
      candidateSelectedItems = null;
    }
    //
    executionTrace.addNonControllableCall(
      codeId: "#82600",
      caller: this,
      methodName: "_setTempMultiOptCriterionXData",
      suffixShortDesc: "",
      parameters: {
        "multiOptTildeCriterionName": multiOptTildeCriterionName,
        "multiOptXData": tempMultiOptCriterionXData,
      },
    );
    _filterModelStructure._setTempMultiOptCriterionXData(
      multiOptTildeCriterionName: multiOptTildeCriterionName,
      multiOptXData: tempMultiOptCriterionXData,
    );
    //
    // TODO: Double check this code:
    //
    if (candidateSelectedItems != null && candidateSelectedItems.isNotEmpty) {
      if (multiOptCriterion.selectionType == SelectionType.single) {
        // IMPORTANT:
        //  - Update from ROOTs to LEAVES
        //  - And make sure children-OptCriterion to null if parent-Value is null or not selected.
        Object? candidateSelectedItem = candidateSelectedItems.first;
        _filterModelStructure._updateCriteriaTempValues({
          multiOptTildeCriterionName: candidateSelectedItem,
        });
      } else {
        // IMPORTANT:
        //  - Update from ROOTs to LEAVES
        //  - And make sure children-OptCriterion to null if parent-Value is null or not selected.
        // Try MULTI SELECTED ITEMS:
        _filterModelStructure._updateCriteriaTempValues({
          multiOptTildeCriterionName: candidateSelectedItems,
        });
      }
    } else {
      // IMPORTANT:
      //  - Update from ROOTs to LEAVES
      //  - And make sure children-OptCriterion to null if parent-Value is null or not selected.
      _filterModelStructure._updateCriteriaTempValues({
        multiOptTildeCriterionName: null,
      });
    }
    //
    Object? tempSelectedCriterionValue =
        _filterModelStructure._getTempCurrentCriterionValue(
      tildeCriterionName: multiOptTildeCriterionName,
    );
    executionTrace.addInfo(
      codeId: "#82800",
      shortDesc: "Debug:",
      parameters: {
        "tildeCriterionName": multiOptTildeCriterionName,
        "tempSelectedCriterionValue": tempSelectedCriterionValue,
      },
    );

    if (tempSelectedCriterionValue != null) {
      for (MultiOptTildeFilterCriterionModel child
          in multiOptCriterion.children) {
        await _loadMultiOptCriterionDataCascade(
          executionTrace: executionTrace,
          filterInput: filterInput,
          parentMultiOptTildeCriterionValue: tempSelectedCriterionValue,
          multiOptCriterion: child,
          activityType: activityType,
          formKeyInstantValues: formKeyInstantValues,
        );
      }
    } else {
      // Do nothing.
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  void __createNullValueWrapAppError({
    required String methodName,
    required String multiOptTildeCriterionName,
  }) {
    MultiOptTildeFilterCriterionModel? multiOptCriterion = _filterModelStructure
        ._getMultiOptFilterCriterion(multiOptTildeCriterionName);
    if (multiOptCriterion == null) {
      throw "The '$multiOptTildeCriterionName' is not $MultiOptTildeFilterCriterionModel";
    }
    String message =
        "The ${getClassName(this)}.$methodName() method must return a non-null $OptValueWrap for the multiOptTildeCriterionName '$multiOptTildeCriterionName'. ";
    if (multiOptCriterion.selectionType == SelectionType.single) {
      message += "$OptValueWrap.single(null) or $OptValueWrap.single(value). ";
    } else {
      message +=
          "$OptValueWrap.multi([null]) or $OptValueWrap.multi([value]). ";
    }
    message +=
        "And return null for not $MultiOptTildeFilterCriterionModel. See the specification of this method for more information.";
    // throw AppError(errorMessage: message);
  }

  // ***************************************************************************
  // ***************************************************************************

  void __throwErrorIfNotASimpleCriterionName({
    required String tildeCriterionName,
    required FilterErrorMethod filterErrorMethod,
  }) {
    if (_filterModelStructure._isMultiOptFilterCriterion(tildeCriterionName)) {
      throw DevError(
        errorMessage:
            '$tildeCriterionName is not a ${getTypeNameWithoutGenerics(SimpleTildeFilterCriterionModel)}',
        errorDetails: [
          "See ${getClassNameWithoutGenerics(this)}.${getClassNameWithoutGenerics(filterErrorMethod)}() method."
        ],
      );
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  OptValueWrap? __extractUpdateValueForMultiOptTildeCriterion({
    required String multiOptTildeCriterionName,
    required String multiOptCriterionBaseName,
    required Object? parentMultiOptTildeCriterionValue,
    required SelectionType selectionType,
    required XData multiOptTildeCriterionXData,
    required FILTER_INPUT filterInput,
  }) {
    OptValueWrap? valueWrap = extractUpdateValueForMultiOptTildeCriterion(
      filterInput: filterInput,
      parentMultiOptTildeCriterionValue: parentMultiOptTildeCriterionValue,
      multiOptTildeCriterionXData: multiOptTildeCriterionXData,
      multiOptCriterionBaseName: multiOptCriterionBaseName,
      multiOptTildeCriterionName: multiOptTildeCriterionName,
      selectionType: selectionType,
    );
    if (valueWrap == null) {
      __createNullValueWrapAppError(
        methodName: "extractUpdateValueForMultiOptTildeCriterion",
        multiOptTildeCriterionName: multiOptTildeCriterionName,
      );
      return null;
    }
    List? value = valueWrap.values;
    return OptValueWrap.multi(
      multiOptTildeCriterionXData._resolveItemsFromRawData(
        dynamicValues: value,
        addOrphan: false,
        clearOrphanItems: true,
      ),
    );
  }

  OptValueWrap? __specifyDefaultValueForMultiOptTildeCriterion({
    required String multiOptTildeCriterionName,
    required String multiOptCriterionBaseName,
    required Object? parentMultiOptTildeCriterionValue,
    required SelectionType selectionType,
    required XData multiOptTildeCriterionXData,
  }) {
    OptValueWrap? valueWrap = specifyDefaultValueForMultiOptTildeCriterion(
      multiOptCriterionBaseName: multiOptCriterionBaseName,
      multiOptTildeCriterionName: multiOptTildeCriterionName,
      parentMultiOptTildeCriterionValue: parentMultiOptTildeCriterionValue,
      multiOptTildeCriterionXData: multiOptTildeCriterionXData,
      selectionType: selectionType,
    );
    if (valueWrap == null) {
      __createNullValueWrapAppError(
        methodName: "specifyDefaultValueForMultiOptTildeCriterion",
        multiOptTildeCriterionName: multiOptTildeCriterionName,
      );
    }
    List? value = valueWrap?.values ?? [];
    return OptValueWrap.multi(
      multiOptTildeCriterionXData._resolveItemsFromRawData(
        dynamicValues: value,
        addOrphan: false,
        clearOrphanItems: true,
      ),
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  ///
  /// Used for FilterPanel.
  ///
  Map<String, dynamic> _initialValuesForFilterPanel() {
    return _filterModelStructure._currentCriteriaValues;
  }

  // ***************************************************************************
  // ***************************************************************************

  // Change Event from GUI.
  @_ImportantMethodAnnotation(
      "Called when the user makes a change on the FilterPanel")
  @_FilterPanelChangeAnnotation()
  Future<void> _onChangeFromFilterPanel({
    required Map<String, dynamic> formKeyInstantValuesInUI,
  }) async {
    final XShelf xShelf = _XShelfFilterPanelChange(filterModel: this);
    //
    final XFilterModel thisXFilterModel = xShelf.findXFilterModelByName(name)!;
    // Add
    thisXFilterModel._createAndSetFilterModelExecutionIntentPanelChange(
      formKeyInstantValuesInUI: formKeyInstantValuesInUI,
    );
    FlutterArtist._rootQueue._addXRootQueueItem(xRootQueueItem: xShelf);
    await FlutterArtist.executor._executeExecutionUnitQueue();
  }

  // ***************************************************************************
  // ***************************************************************************

  void _afterBuildFilterPanel() {
    //
  }

  // ***************************************************************************
  // ***************************************************************************

  bool isEnabled() {
    return true;
  }

  // ***************************************************************************
  // ***************************************************************************

  @DebugMethodAnnotation()
  String get debugClassDefinition {
    return "${getClassName(this)}$debugClassParametersDefinition";
  }

  @DebugMethodAnnotation()
  String get debugClassParametersDefinition {
    return "<${getFilterInputType()}, ${getFilterCriteriaType()}>";
  }

  Type getFilterCriteriaType() {
    return FILTER_CRITERIA;
  }

  Type getFilterInputType() {
    return FILTER_INPUT;
  }

  // ***************************************************************************
  // ***************************************************************************

  ///
  /// Query all Scalars and Blocks of this FilterModel.
  ///
  @_RootMethodAnnotation()
  Future<bool> queryAll({
    FILTER_INPUT? filterInput,
  }) async {
    if (__lockAddMoreQuery) {
      return false;
    }
    print("\n FILTER MODEL queryAll() \n");
    final executionTrace = FlutterArtist.codeFlowLogger._addMethodCall(
      ownerClassInstance: this,
      methodName: "queryAll",
      parameters: {
        "filterInput": filterInput,
      },
      isLibMethod: true,
    );

    executionTrace.addInfo(
      codeId: "#89100",
      shortDesc: "Debug",
      parameters: {
        "committedFilterCriteriaSnapshot.isError":
            _committedFilterCriteriaSnapshot?.isError,
        "draftFilterCriteriaSnapshot.isError":
            _draftFilterCriteriaSnapshot?.isError,
      },
    );

    // Test Cases: [48b] - query() & queryAll() - Block.
    // Test Cases: [80b] - query() & queryAll() - Scalar.
    return await __query(
      executionTrace: executionTrace,
      methodName: "queryAll",
      filterInput: filterInput,
      forceQueryAll: true,
    );
  }

  ///
  /// Query all Scalars and Blocks of this FilterModel if they are visible on the UI.
  ///
  /// Any Scalar or Block that is not queried will be set to LAZY state.
  ///
  @_RootMethodAnnotation()
  Future<bool> query({
    FILTER_INPUT? filterInput,
  }) async {
    if (__lockAddMoreQuery) {
      return false;
    }
    final executionTrace = FlutterArtist.codeFlowLogger._addMethodCall(
      ownerClassInstance: this,
      methodName: "query",
      parameters: {
        "filterInput": filterInput,
      },
      isLibMethod: true,
    );

    // Commit current draft snapshot to committed realm before query dispatch.
    _commitDraftSnapshotToCommitted();

    // Test Cases: [48b] - query() & queryAll().
    return await __query(
      executionTrace: executionTrace,
      methodName: "query",
      filterInput: filterInput,
      forceQueryAll: false,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  Future<bool> __query({
    required ExecutionTrace executionTrace,
    FILTER_INPUT? filterInput,
    required String methodName,
    required bool forceQueryAll,
  }) async {
    if (__lockAddMoreQuery) {
      return false;
    }
    executionTrace.addInfo(
      codeId: "#55000",
      shortDesc: "Creating <b>$_XShelfFilterModelQuery</b>..",
    );
    //
    final XShelf xShelf = _XShelfFilterModelQuery(
      filterModel: this,
      filterInput: filterInput,
      forceQueryAll: forceQueryAll,
    );
    //
    FlutterArtist._rootQueue._addXRootQueueItem(xRootQueueItem: xShelf);
    await FlutterArtist.executor._executeExecutionUnitQueue();
    return true;
  }

  // ***************************************************************************
  // ***************************************************************************

  Future<void> showDebugFilterModelViewerDialog() async {
    BuildContext context = FlutterArtistCore.context;
    //
    await DebugViewerDialog.openDebugFilterModelInspector(
      context: context,
      locationInfo: "locationInfo", // TODO: Remove.
      filterModel: this,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  Future<void> showDebugFilterCriteriaViewerDialog() async {
    BuildContext context = FlutterArtistCore.context;
    //
    await DebugViewerDialog.openDebugFilterCriteriaInspector(
      context: context,
      locationInfo: '',
      filterModel: this,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  // SAME-AS: #0009 (form)
  MultiOptTildeFilterCriterionModel? findMultiOptFilterCriterion({
    required String multiOptTildeCriterionName,
  }) {
    return _filterModelStructure._findMultiOptFilterCriterion(
      multiOptTildeCriterionName: multiOptTildeCriterionName,
    );
  }

  // SAME-AS: #0008 (formModel.debugGetMultiOptPropLoadCount())
  int debugGetMultiOptCriteriaLoadCount(String multiOptTildeCriterionName) {
    return _filterModelStructure._debugGetMultiOptCriterionLoadCount(
      multiOptTildeCriterionName: multiOptTildeCriterionName,
    );
  }

  // ***************************************************************************
  // ***************************************************************************
  // ***************************************************************************

  void __assertThisXFilterModel(XFilterModel thisXFilterModel) {
    if (!identical(thisXFilterModel.filterModel, this)) {
      String message =
          "Error Assert filter model: ${thisXFilterModel.filterModel} - $this";
      print("FATAL ERROR: $message");
      throw message;
    }
  }
}
