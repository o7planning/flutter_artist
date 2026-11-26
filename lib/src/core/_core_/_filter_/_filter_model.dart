part of '../core.dart';

abstract class FilterModel<
    FILTER_PATCH extends FilterPatch, // EmptyFilterPatch
    FILTER_CRITERIA extends FilterCriteria // EmptyFilterCriteria
    > extends _Core implements MnemonicScope, ClassDefViewable {
  @override
  Map<String, Type> getGenericsInfoMap() {
    return {
      "FILTER_PATCH": FILTER_PATCH,
      "FILTER_CRITERIA": FILTER_CRITERIA,
    };
  }

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

  /// Error information resolved from the committed state.
  ErrorInfo? get errorInfo {
    return switch (committedDataState) {
      FilterDataStateError(:final errorInfo) => errorInfo,
      _ => null
    };
  }

  /// True if the committed state holds an error.
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
  ///       plainCriterionDefs: [
  ///         PlainFilterCriterionDef<String>(criterionBaseName: "searchText"),
  ///       ],
  ///       managedOptCriterionDefs: [
  ///         // Managed Options Single Selection Criterion.
  ///         ManagedOptFilterCriterionDef<AlbumInfo>.singleSelection(
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
  @AbstractMethodAnnotation()
  FilterModelStructure defineFilterModelStructure();

  // ***************************************************************************
  // ***************************************************************************

  ///
  /// Abstract method:
  ///
  @AbstractMethodAnnotation()
  Future<XData?> performLoadManagedOptTildeCriterionXData({
    required String managedOptTildeCriterionName,
    required String managedOptCriterionBaseName,
    required Object? parentManagedOptTildeCriterionValue,
    required ManagedOptSelectionMode managedOptSelectionMode,
  });

  // ***************************************************************************
  // ABSTRACT METHOD:
  // ***************************************************************************

  @AbstractMethodAnnotation()
  OptValueWrap? specifyDefaultValueForManagedOptTildeCriterion({
    required String managedOptTildeCriterionName,
    required String managedOptCriterionBaseName,
    required Object? parentManagedOptTildeCriterionValue,
    required XData managedOptTildeCriterionXData,
    required ManagedOptSelectionMode managedOptSelectionMode,
  });

  // ***************************************************************************
  // ABSTRACT METHOD:
  // ***************************************************************************

  // SAME-AS: #0011 (form - specifyDefaultValuesForPlainProps)
  @AbstractMethodAnnotation()
  Map<String, dynamic>? specifyDefaultValuesForPlainTildeCriteria();

  // ***************************************************************************
  // ABSTRACT METHOD:
  // ***************************************************************************

  ///
  /// ```dart
  /// @override
  /// OptValueWrap? extractPatchValueForManagedOptTildeCriterion({
  ///     required String managedOptTildeCriterionName,
  ///     required String managedOptCriterionBaseName,
  ///     required Object? parentManagedOptTildeCriterionValue,
  ///     required ManagedOptSelectionMode managedOptSelectionMode,
  ///     required ExampleFilterPatch filterPatch,
  ///     required XData managedOptTildeCriterionXData,
  /// }) {
  ///    if(managedOptTildeCriterionName == "company") {
  ///       int inputCompanyId = filterPatch.companyId;
  ///       CompanyInfo? inputCompany = managedOptTildeCriterionXData?.getItemById(inputCompanyId);
  ///       return OptValueWrap.single(inputCompany)
  ///    }
  ///    return null;
  /// }
  /// ```
  ///
  @AbstractMethodAnnotation()
  OptValueWrap? extractPatchValueForManagedOptTildeCriterion({
    required String managedOptTildeCriterionName,
    required String managedOptCriterionBaseName,
    required Object? parentManagedOptTildeCriterionValue,
    required ManagedOptSelectionMode managedOptSelectionMode,
    required XData managedOptTildeCriterionXData,
    required FILTER_PATCH filterPatch,
  });

  // ***************************************************************************
  // ABSTRACT METHOD:
  // ***************************************************************************

  // OLD: getPlainCriterionValuesFromFilterPatch.
  // SAME-AS: #0010 (form - extractPatchValuesForPlainProps)
  @AbstractMethodAnnotation()
  Map<String, PlainValueWrap?>? extractPatchValuesForPlainTildeCriteria({
    required FILTER_PATCH filterPatch,
  });

  // ***************************************************************************
  // ***************************************************************************

  ///
  /// Example:
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
  @AbstractMethodAnnotation()
  FILTER_CRITERIA createNewFilterCriteria({
    required Map<String, dynamic> tildeCriteriaMap,
  });

  /// Override this method to customize TAB focus navigation between filter criteria on the UI.
  /// Return `null` or [FocusNavAction.moveNext] to use default focus traversal.
  @AbstractMethodAnnotation()
  FocusNavAction? resolveNextFocus({
    required String currentTildeCriterionName,
    required dynamic currentValue,
    required bool isCurrentFieldValid,
  });

  // ***************************************************************************
  // SNAPSHOT SYNCHRONIZATION
  // ***************************************************************************

  /// **CRITICAL ARCHITECTURAL CONTRACT**:
  /// Calling this method mutates the committed snapshot state of this [FilterModel]
  /// and **MUST ALWAYS** be coupled with an immediate, actual query execution process
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
  ///    committing snapshot state without executing a query process leaves sibling blocks
  ///    in an uncoordinated and desynchronized lifecycle.
  /// Applies the specified [FilterSyncDirective] to reconcile the draft workspace
  /// with the committed snapshot realm.
  ///
  /// If a programmatic [filterPatch] is supplied, it takes strict precedence over
  /// the directive and automatically commits the resulting snapshot to the committed realm.
  void _applyFilterSyncDirective({
    required FilterSyncDirective filterSyncDirective,
    required FILTER_PATCH? filterPatch,
  }) {
    // 1. Programmatic Input Override:
    // When code explicitly injects a filterPatch, it is an authoritative command
    // that must be committed into the committed realm immediately.
    if (filterPatch != null) {
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
            scalar._setScalarDataState(
              newScalarDataState: ScalarDataStatePending(
                reason: ScalarPendingReasonFilterChanged(),
              ),
            );
          }
        } else if (scalarDataState is ScalarDataStateLoadedStale) {
          final ScalarLoadedStateStaleReason reason = scalarDataState.reason;
          if (reason.isFailed) {
            scalar._setScalarDataState(
              newScalarDataState: ScalarDataStateLoadedStale(
                reason: ScalarLoadedStateStaleReasonFilterChanged(),
              ),
            );
          }
        } else if (scalarDataState is ScalarDataStateLoadedFresh) {
          scalar._setScalarDataState(
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
      codeId: "#024000",
      shortDesc: "Begin ${executionUnitType.asDebugExecutionUnit()}.",
    );
    //
    final executionResult = executionIntent.resultWrapper._setResult(
      EmptyExecutionUnitResult(),
      objectCaller: this,
      methodName: '_unitLoadFilterData',
    );
    executionTrace.addInfo(
      codeId: "#024100",
      shortDesc: "Debug",
      parameters: {
        "thisXFilterModel.loadedInSession": thisXFilterModel.loadedInSession,
      },
    );
    //
    try {
      // SAME-AS: #0004
      if (!thisXFilterModel.loadedInSession) {
        final filterPatch = thisXFilterModel.filterPatch as FILTER_PATCH?;
        //
        final bool isFirstTime = !__initiatedAtLeastOnce;
        executionTrace.addInfo(
          codeId: "#024200",
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
          filterPatch: filterPatch,
          formKeyInstantValuesInUI: null,
        );
        executionTrace.addInfo(
          codeId: "#024400",
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
            codeId: "#024300",
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
      codeId: "#030000",
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
        filterPatch: null,
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
      throw AppFatalErrorUtils._createFatalAppError(message);
    }
    // fieldName is not valid:
    on FilterCriterionFieldNameInvalidError catch (e) {
      String message = "Invalid fieldName '${e.fieldName}'.\n"
          "@see the '${getClassNameWithoutGenerics(this)}.defineFilterModelStructure()' method for details.";
      throw AppFatalErrorUtils._createFatalAppError(message);
    }
    // No Field Converter:
    on FilterCriterionNoFieldValueConverterError catch (e) {
      String message =
          "Data type of '${e.criterionBaseName}' is '${e.dataType}' (Not simple data type).\n"
          "So you need to provide toFieldValue() function.\n"
          "@see the '${getClassNameWithoutGenerics(this)}.defineFilterModelStructure()' method for details.";
      throw AppFatalErrorUtils._createFatalAppError(message);
    }
    // tildeCriterionName is not valid:
    on TildeFilterCriterionNameInvalidError catch (e) {
      String message = "Invalid tildeCriterionName '${e.tildeCriterionName}'.\n"
          "@see the '${getClassNameWithoutGenerics(this)}.defineFilterModelStructure()' method for details.";
      throw AppFatalErrorUtils._createFatalAppError(message);
    }
    // parentMatchSuffix is not valid:
    on TildeFilterCriterionSuffixInvalidError catch (e) {
      String message =
          "Invalid parentMatchSuffix '${e.tildeSuffix}' (The correct examples: '~', '~1', '~min').\n"
          "@see the '${getClassNameWithoutGenerics(this)}.defineFilterModelStructure()' method for details.";
      throw AppFatalErrorUtils._createFatalAppError(message);
    }
    // criterionBaseName not found:
    on TildeFilterCriterionBaseCriterionNotFoundError catch (e) {
      String message =
          "There is no criterionBaseName '${e.criterionBaseName}' corresponding to tildeCriterionName '${e.tildeCriterionName}'.\n"
          "@see the '${getClassNameWithoutGenerics(this)}.defineFilterModelStructure()' method for details.";
      throw AppFatalErrorUtils._createFatalAppError(message);
    }
    // Duplicate criterionBaseName
    on FilterCriterionDuplicateNameError catch (e) {
      String message = "Duplicate criterionBaseName '${e.criterionBaseName}'.\n"
          "@see the '${getClassNameWithoutGenerics(this)}.defineFilterModelStructure()' method for details.";
      throw AppFatalErrorUtils._createFatalAppError(message);
    }
    // Duplicate fieldName
    on FilterCriterionDuplicateFieldNameError catch (e) {
      String message =
          "Duplicate fieldName '${e.fieldName}' (criterionBaseName: ${e.criterionBaseName}).\n"
          "@see the '${getClassNameWithoutGenerics(this)}.defineFilterModelStructure()' method for details.";
      throw AppFatalErrorUtils._createFatalAppError(message);
    }
    // TildeCriterionConfig - Invalid Suffix.
    on TildeCriterionConfigInvalidSuffixError catch (e) {
      String message =
          "Invalid TildeCriterionConfig(suffix: '${e.tildeSuffix}') (criterionBaseName: ${e.criterionBaseName}).\n"
          "The correct examples: '~', '~1', '~min'.\n"
          "@see the '${getClassNameWithoutGenerics(this)}.defineFilterModelStructure()' method for details.";
      throw AppFatalErrorUtils._createFatalAppError(message);
    }
    // TildeCriterionConfig - Duplicate Suffix.
    on TildeCriterionConfigDuplicationSuffixError catch (e) {
      String message =
          "Duplicate TildeCriterionConfig(suffix: '${e.tildeSuffix}') (criterionBaseName: ${e.criterionBaseName}).\n"
          "@see the '${getClassNameWithoutGenerics(this)}.defineFilterModelStructure()' method for details.";
      throw AppFatalErrorUtils._createFatalAppError(message);
    }
    // Duplicate tildeCriterionName in a Group:
    on FilterConditionGroupDuplicateTildeError catch (e) {
      String message =
          "Duplicate tildeCriterionName '${e.tildeCriterionName}' in '${e.groupName}' group.\n"
          "@see the '${getClassNameWithoutGenerics(this)}.defineFilterModelStructure()' method for details.";
      throw AppFatalErrorUtils._createFatalAppError(message);
    }
    // Duplicate groupName:
    on FilterConditionGroupDuplicateNameError catch (e) {
      String message = "Duplicate groupName '${e.groupName}'.\n"
          "@see the '${getClassNameWithoutGenerics(this)}.defineFilterModelStructure()' method for details.";
      throw AppFatalErrorUtils._createFatalAppError(message);
    }
    // FilterCriteria class: Duplicate criterionName.
    on FilterCriteriaDuplicateCriterionError catch (e) {
      String message = "Duplicate criterionBaseName '${e.criterionBaseName}'.\n"
          "@see the '${e.filterCriteriaClassName}.registerSupportedCriteria()' method for details.";
      throw AppFatalErrorUtils._createFatalAppError(message);
    }
    // FilterCriteria class: Duplicate Field.
    on FilterCriteriaDuplicateFieldError catch (e) {
      String message = "Duplicate field '${e.field}'.\n"
          "@see the '${e.filterCriteriaClassName}.registerSupportedCriteria()' method for details.";
      throw AppFatalErrorUtils._createFatalAppError(message);
    }
    // Other Error:
    catch (e, stackTrace) {
      print(stackTrace);
      String message =
          "Unknown Error $e in ${getClassNameWithoutGenerics(this)}";
      throw AppFatalErrorUtils._createFatalAppError(message);
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

  XData? getManagedOptTildeCriterionXData(String managedOptTildeCriterionName) {
    return _filterModelStructure._getManagedOptTildeCriterionXData(
      managedOptTildeCriterionName,
    );
  }

  dynamic getManagedOptTildeCriterionData(String managedOptTildeCriterionName) {
    XData? managedOptTildeCriterionXData = getManagedOptTildeCriterionXData(
      managedOptTildeCriterionName,
    );
    //
    return managedOptTildeCriterionXData?.data;
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
    required FILTER_PATCH? filterPatch,
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
        codeId: "#031020",
        caller: _filterModelStructure,
        methodName: "_setupTemporaryStateForNewActivity",
        suffixShortDesc: "",
      );
    }
    try {
      _filterModelStructure._setupTemporaryStateForNewActivity(
        activityType: activityType,
        formKeyInstantValues: formKeyInstantValues,
        filterPatch: filterPatch,
      );
    } catch (e, stackTrace) {
      dynamic error = e;
      if (e is FilterCriterionTypeMismatchError) {
        // Bug: #Bug#002
        error = e.toAppError(
          filterModelName: getClassNameWithoutGenerics(this),
        );
      } else if (e is FilterManagedOptMsMismatchError) {
        // Bug: #Bug#003
        error = e.toAppError(
          filterModelName: getClassNameWithoutGenerics(this),
        );
      }
      final ErrorInfo errorInfo = _handleError(
        module: shelf,
        methodName: "_setupTemporaryStateForNewActivity",
        error: error,
        stackTrace: stackTrace,
        showSnackBar: true,
        tipDocument: null,
      );
      executionTrace.addInfo(
        codeId: "#031030",
        shortDesc:
            "The ${debugObjHtml(this)}._loadManagedOptCriterionDataCascade() was called with an error.",
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
      for (ManagedOptTildeFilterCriterionModel managedOptCriterion
          in _filterModelStructure._rootManagedOptCriterionModels) {
        executionTrace.addNonControllableCall(
          codeId: "#031040",
          caller: this,
          methodName: "_loadManagedOptCriterionDataCascade",
          suffixShortDesc:
              "To load data for ${debugObjHtml(managedOptCriterion)} and its descendants.",
          parameters: {
            "activityType": activityType,
            "filterPatch": filterPatch,
            "parentManagedOptTildeCriterionValue": null,
            "managedOptCriterion": managedOptCriterion,
            "formKeyInstantValues": formKeyInstantValues,
          },
        );
        //
        // Load OptCriterion Data and set default and selected.
        //
        // May throw ApiError.
        //
        await _loadManagedOptCriterionDataCascade(
          executionTrace: executionTrace,
          filterPatch: filterPatch,
          parentManagedOptTildeCriterionValue: null,
          managedOptCriterion: managedOptCriterion,
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
        module: shelf,
        methodName: filterErrorInfo.methodName,
        error: filterErrorInfo.error,
        stackTrace: filterErrorInfo.errorStackTrace,
        showSnackBar: true,
        tipDocument: TipDocument.filterModelPerformLoadManagedOptCriterionXData,
      );
      executionTrace.addInfo(
        codeId: "#031080",
        shortDesc:
            "The ${debugObjHtml(this)}._loadManagedOptCriterionDataCascade() was called with an error.",
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
    if (filterPatch != null) {
      try {
        executionTrace.addControllableCall(
          codeId: "#031140",
          caller: this,
          methodName: "extractPatchValuesForPlainTildeCriteria",
          suffixShortDesc:
              "To get values from filterPatch to update for plainCriteria",
          parameters: {
            "filterPatch": filterPatch,
          },
        );
        final Map<String, PlainValueWrap?> updatedPlainCriterionValues =
            extractPatchValuesForPlainTildeCriteria(
                  filterPatch: filterPatch,
                ) ??
                {};
        for (String tildeCriterionName in updatedPlainCriterionValues.keys) {
          // Check and throw error if 'tildeCriterionName' is not a PlainFilterCriterion:
          __throwErrorIfNotAPlainCriterionName(
            tildeCriterionName: tildeCriterionName,
            filterErrorMethod:
                FilterErrorMethod.extractPatchValuesForPlainTildeCriteria,
          );
          PlainValueWrap? valueWrap =
              updatedPlainCriterionValues[tildeCriterionName];
          // SAME-AS: #0012 (formModel)
          if (valueWrap != null && valueWrap.use) {
            _filterModelStructure._setTempPlainCriterionValue(
              tildeCriterionName: tildeCriterionName,
              value: valueWrap.value,
            );
          }
        }
      } catch (e, stackTrace) {
        final ErrorInfo errorInfo = _handleError(
          module: shelf,
          methodName: "extractPatchValuesForPlainTildeCriteria",
          error: e,
          stackTrace: stackTrace,
          showSnackBar: true,
          tipDocument: null,
        );
        //
        executionTrace.addInfo(
          codeId: "#031200",
          shortDesc:
              "The ${debugObjHtml(this)}.extractPatchValuesForPlainTildeCriteria() method was called with an error.",
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
    // filterPatch is null
    else {
      try {
        if (!__initiatedAtLeastOnce) {
          if (this is! _DefaultFilterModel) {
            executionTrace.addControllableCall(
              codeId: "#031300",
              caller: this,
              methodName: "specifyDefaultValuesForPlainTildeCriteria",
              suffixShortDesc:
                  "To get default values for <b>plain criteria</b>.",
            );
          }
          final Map<String, dynamic> defaultPlainCriterionValues =
              specifyDefaultValuesForPlainTildeCriteria() ?? {};

          for (String tildeCriterionName in defaultPlainCriterionValues.keys) {
            // Check and throw error if 'tildeCriterionName' is not a PlainFilterCriterion:
            __throwErrorIfNotAPlainCriterionName(
              tildeCriterionName: tildeCriterionName,
              filterErrorMethod:
                  FilterErrorMethod.specifyDefaultValuesForPlainTildeCriteria,
            );
            //
            dynamic value = defaultPlainCriterionValues[tildeCriterionName];
            _filterModelStructure._setTempPlainCriterionValue(
              tildeCriterionName: tildeCriterionName,
              value: value,
            );
          }
        }
      } catch (e, stackTrace) {
        final ErrorInfo errorInfo = _handleError(
          module: shelf,
          methodName: "specifyDefaultValuesForPlainTildeCriteria",
          error: e,
          stackTrace: stackTrace,
          showSnackBar: true,
          tipDocument: null,
        );
        executionTrace.addInfo(
          codeId: "#031380",
          shortDesc:
              "The ${debugObjHtml(this)}.specifyDefaultValuesForPlainTildeCriteria() method was called with an error.",
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
          codeId: "#031420",
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
          codeId: "#031460",
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
        module: shelf,
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
        codeId: "#031500",
        shortDesc:
            "The ${debugObjHtml(this)}.createNewFilterCriteria() method was called with an error!",
        errorInfo: errorInfo,
      );
      return _draftFilterCriteriaSnapshot;
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  Future<void> _loadManagedOptCriterionDataCascade({
    required ExecutionTrace executionTrace,
    required FILTER_PATCH? filterPatch,
    required Object? parentManagedOptTildeCriterionValue,
    required ManagedOptTildeFilterCriterionModel managedOptCriterion,
    required Map<String, dynamic> formKeyInstantValues,
    required FilterActivityType activityType,
  }) async {
    final String managedOptTildeCriterionName =
        managedOptCriterion.tildeCriterionName;
    final String managedOptCriterionBaseName =
        managedOptCriterion.criterionName;
    final ManagedOptSelectionMode managedOptSelectionMode =
        managedOptCriterion.selectionMode;

    executionTrace.addInfo(
      codeId: "#082000",
      shortDesc:
          "Begin of ${debugObjHtml(this)}._loadManagedOptCriterionDataCascade() method.",
      parameters: {
        "filterPatch": filterPatch,
        "parentManagedOptTildeCriterionValue":
            parentManagedOptTildeCriterionValue,
        "managedOptCriterion": managedOptCriterion,
        "activityType": activityType,
      },
    );

    final ManagedOptTildeFilterCriterionModel? managedOptCriterionParent =
        managedOptCriterion.parent;
    // Get current OptCriterion data:
    XData? tempManagedOptCriterionXData =
        _filterModelStructure._getTempManagedOptCriterionXData(
      managedOptTildeCriterionName,
    );
    final dynamic tempCurrentManagedOptValue =
        _filterModelStructure._getTempCurrentCriterionValue(
            tildeCriterionName: managedOptTildeCriterionName);
    //
    dynamic newSelectedValue =
        _filterModelStructure._getTempCurrentCriterionValue(
      tildeCriterionName: managedOptTildeCriterionName,
    );
    if (activityType == FilterActivityType.updateFromFilterPanel) {
      if (formKeyInstantValues.containsKey(managedOptTildeCriterionName)) {
        newSelectedValue = formKeyInstantValues[managedOptTildeCriterionName];
      }
    }
    //
    final bool valueChanged;
    if (tempManagedOptCriterionXData == null) {
      valueChanged = false;
    } else {
      valueChanged = !tempManagedOptCriterionXData.isSameItemOrItemList(
        itemOrItemList1: tempCurrentManagedOptValue,
        itemOrItemList2: newSelectedValue,
      );
    }
    executionTrace.addInfo(
      codeId: "#082100",
      shortDesc: "Debug:",
      parameters: {
        "tempCurrentManagedOptValue": tempCurrentManagedOptValue,
        "newSelectedValue": newSelectedValue,
        "valueChanged": valueChanged,
      },
    );
    // May throw Type error here!
    managedOptCriterion._tempCurrentValue = newSelectedValue;
    //
    if (valueChanged) {
      _filterModelStructure._updateChildrenManagedOptValueToNullCascade(
        managedOptCriterion: managedOptCriterion,
      );
    }
    //
    if (managedOptCriterionParent != null) {
      XData? tempManagedOptXDataParent =
          _filterModelStructure._getTempManagedOptCriterionXData(
        managedOptCriterionParent.tildeCriterionName,
      );
      //
      if (tempManagedOptXDataParent != null) {
        // Item or Item List (Multi Selection):
        Object? parentOptCriterionValueOLD =
            _filterModelStructure._getCurrentCriterionValue(
          tildeCriterionName: managedOptCriterionParent.tildeCriterionName,
        );
        // Parent Value change?
        bool isSame = tempManagedOptXDataParent.isSameItemOrItemList(
          itemOrItemList1: parentOptCriterionValueOLD,
          itemOrItemList2: parentManagedOptTildeCriterionValue,
        );
        if (!isSame) {
          tempManagedOptCriterionXData = null;
        }
      } else {
        tempManagedOptCriterionXData = null;
      }
    }
    //
    if (tempManagedOptCriterionXData == null) {
      _filterModelStructure._setTempManagedOptCriterionXData(
        managedOptTildeCriterionName: managedOptTildeCriterionName,
        managedOptXData: null,
      );
      // IMPORTANT:
      //  - Update from ROOTs to LEAVES
      //  - And make sure children-OptCriterion to null if parent-Value is null or not selected.
      _filterModelStructure._updateCriteriaTempValues({
        managedOptTildeCriterionName: null,
      });
    }
    bool newLoaded = false;
    if (tempManagedOptCriterionXData == null) {
      // Always increase "_loadCount" value regardless of error.
      managedOptCriterion._loadCount++;
      newLoaded = true;
      //
      try {
        executionTrace.addInfo(
          codeId: "#082300",
          shortDesc:
              "Calling ${debugObjHtml(this)}.performLoadManagedOptTildeCriterionXData():",
          parameters: {
            "filterPatch": filterPatch,
            "parentManagedOptTildeCriterionValue":
                parentManagedOptTildeCriterionValue,
            "managedOptCriterionBaseName": managedOptCriterionBaseName,
            "managedOptTildeCriterionName": managedOptTildeCriterionName,
            "managedOptSelectionMode": managedOptSelectionMode,
          },
        );
        // May throw AppError, ApiError or others.
        //
        // Load OptCriterion data from Rest API.
        // May throw ApiError.
        //
        tempManagedOptCriterionXData =
            await performLoadManagedOptTildeCriterionXData(
          parentManagedOptTildeCriterionValue:
              parentManagedOptTildeCriterionValue,
          managedOptCriterionBaseName: managedOptCriterionBaseName,
          managedOptTildeCriterionName: managedOptTildeCriterionName,
          managedOptSelectionMode: managedOptSelectionMode,
        );
        executionTrace.addInfo(
          codeId: "#082400",
          shortDesc: "Debug. Return value: ",
          parameters: {
            "tempManagedOptCriterionXData": tempManagedOptCriterionXData,
          },
        );
      } catch (e, stackTrace) {
        // TODO: Test Case??
        throw FilterMethodError(
          tildeCriterionName: managedOptTildeCriterionName,
          filterErrorMethod:
              FilterErrorMethod.performLoadManagedOptTildeCriterionXData,
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
    if (tempManagedOptCriterionXData != null) {
      OptValueWrap? inputValueWrap;
      if (filterPatch != null) {
        // Test Case: [20c], [20d].
        inputValueWrap = __extractPatchValueForManagedOptTildeCriterion(
          filterPatch: filterPatch,
          parentManagedOptTildeCriterionValue:
              parentManagedOptTildeCriterionValue,
          managedOptTildeCriterionXData: tempManagedOptCriterionXData,
          managedOptCriterionBaseName: managedOptCriterionBaseName,
          managedOptTildeCriterionName: managedOptTildeCriterionName,
          managedOptSelectionMode: managedOptSelectionMode,
        );
      } else {
        final parentMatchSuffix = managedOptCriterion.parentMatchSuffix;
        final defaultSettingPolicy = managedOptCriterion.defaultSettingPolicy;
        if ((!__initiatedAtLeastOnce &&
                defaultSettingPolicy == DefaultSettingPolicy.onInitialOnly) ||
            (newLoaded &&
                managedOptCriterion._tempCurrentValue == null &&
                defaultSettingPolicy == DefaultSettingPolicy.onEveryLoad)) {
          executionTrace.addNonControllableCall(
            codeId: "#082460",
            caller: this,
            methodName: "__specifyDefaultValueForManagedOptTildeCriterion",
            suffixShortDesc: "",
            parameters: {
              "parentManagedOptTildeCriterionValue":
                  parentManagedOptTildeCriterionValue,
              "managedOptCriterionBaseName": managedOptCriterionBaseName,
              "managedOptTildeCriterionName": managedOptTildeCriterionName,
              "managedOptSelectionMode": managedOptSelectionMode,
            },
          );
          inputValueWrap = __specifyDefaultValueForManagedOptTildeCriterion(
            managedOptCriterionBaseName: managedOptCriterionBaseName,
            managedOptTildeCriterionName: managedOptTildeCriterionName,
            parentManagedOptTildeCriterionValue:
                parentManagedOptTildeCriterionValue,
            managedOptTildeCriterionXData: tempManagedOptCriterionXData,
            managedOptSelectionMode: managedOptSelectionMode,
          );
          executionTrace.addInfo(
            codeId: "#082470",
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
        tildeCriterionName: managedOptTildeCriterionName,
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
            tempManagedOptCriterionXData._resolveItemsFromRawData(
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
      codeId: "#082600",
      caller: this,
      methodName: "_setTempManagedOptCriterionXData",
      suffixShortDesc: "",
      parameters: {
        "managedOptTildeCriterionName": managedOptTildeCriterionName,
        "managedOptXData": tempManagedOptCriterionXData,
      },
    );
    _filterModelStructure._setTempManagedOptCriterionXData(
      managedOptTildeCriterionName: managedOptTildeCriterionName,
      managedOptXData: tempManagedOptCriterionXData,
    );
    //
    // TODO: Double check this code:
    //
    if (candidateSelectedItems != null && candidateSelectedItems.isNotEmpty) {
      if (managedOptCriterion.selectionMode == ManagedOptSelectionMode.single) {
        // IMPORTANT:
        //  - Update from ROOTs to LEAVES
        //  - And make sure children-OptCriterion to null if parent-Value is null or not selected.
        Object? candidateSelectedItem = candidateSelectedItems.first;
        _filterModelStructure._updateCriteriaTempValues({
          managedOptTildeCriterionName: candidateSelectedItem,
        });
      } else {
        // IMPORTANT:
        //  - Update from ROOTs to LEAVES
        //  - And make sure children-OptCriterion to null if parent-Value is null or not selected.
        // Try MULTI SELECTED ITEMS:
        _filterModelStructure._updateCriteriaTempValues({
          managedOptTildeCriterionName: candidateSelectedItems,
        });
      }
    } else {
      // IMPORTANT:
      //  - Update from ROOTs to LEAVES
      //  - And make sure children-OptCriterion to null if parent-Value is null or not selected.
      _filterModelStructure._updateCriteriaTempValues({
        managedOptTildeCriterionName: null,
      });
    }
    //
    Object? tempSelectedCriterionValue =
        _filterModelStructure._getTempCurrentCriterionValue(
      tildeCriterionName: managedOptTildeCriterionName,
    );
    executionTrace.addInfo(
      codeId: "#082800",
      shortDesc: "Debug:",
      parameters: {
        "tildeCriterionName": managedOptTildeCriterionName,
        "tempSelectedCriterionValue": tempSelectedCriterionValue,
      },
    );

    if (tempSelectedCriterionValue != null) {
      for (ManagedOptTildeFilterCriterionModel child
          in managedOptCriterion.children) {
        await _loadManagedOptCriterionDataCascade(
          executionTrace: executionTrace,
          filterPatch: filterPatch,
          parentManagedOptTildeCriterionValue: tempSelectedCriterionValue,
          managedOptCriterion: child,
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
    required String managedOptTildeCriterionName,
  }) {
    ManagedOptTildeFilterCriterionModel? managedOptCriterion =
        _filterModelStructure
            ._getManagedOptFilterCriterion(managedOptTildeCriterionName);
    if (managedOptCriterion == null) {
      throw "The '$managedOptTildeCriterionName' is not $ManagedOptTildeFilterCriterionModel";
    }
    String message =
        "The ${getClassName(this)}.$methodName() method must return a non-null $OptValueWrap for the managedOptTildeCriterionName '$managedOptTildeCriterionName'. ";
    if (managedOptCriterion.selectionMode == ManagedOptSelectionMode.single) {
      message += "$OptValueWrap.single(null) or $OptValueWrap.single(value). ";
    } else {
      message +=
          "$OptValueWrap.multi([null]) or $OptValueWrap.multi([value]). ";
    }
    message +=
        "And return null for not $ManagedOptTildeFilterCriterionModel. See the specification of this method for more information.";
    // throw AppError(errorMessage: message);
  }

  // ***************************************************************************
  // ***************************************************************************

  void __throwErrorIfNotAPlainCriterionName({
    required String tildeCriterionName,
    required FilterErrorMethod filterErrorMethod,
  }) {
    if (_filterModelStructure
        ._isManagedOptFilterCriterion(tildeCriterionName)) {
      throw DevError(
        errorMessage:
            '$tildeCriterionName is not a ${getTypeNameWithoutGenerics(PlainTildeFilterCriterionModel)}',
        errorDetails: [
          "See ${getClassNameWithoutGenerics(this)}.${getClassNameWithoutGenerics(filterErrorMethod)}() method."
        ],
      );
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  OptValueWrap? __extractPatchValueForManagedOptTildeCriterion({
    required String managedOptTildeCriterionName,
    required String managedOptCriterionBaseName,
    required Object? parentManagedOptTildeCriterionValue,
    required ManagedOptSelectionMode managedOptSelectionMode,
    required XData managedOptTildeCriterionXData,
    required FILTER_PATCH filterPatch,
  }) {
    OptValueWrap? valueWrap = extractPatchValueForManagedOptTildeCriterion(
      filterPatch: filterPatch,
      parentManagedOptTildeCriterionValue: parentManagedOptTildeCriterionValue,
      managedOptTildeCriterionXData: managedOptTildeCriterionXData,
      managedOptCriterionBaseName: managedOptCriterionBaseName,
      managedOptTildeCriterionName: managedOptTildeCriterionName,
      managedOptSelectionMode: managedOptSelectionMode,
    );
    if (valueWrap == null) {
      __createNullValueWrapAppError(
        methodName: "extractPatchValueForManagedOptTildeCriterion",
        managedOptTildeCriterionName: managedOptTildeCriterionName,
      );
      return null;
    }
    List? value = valueWrap.values;
    return OptValueWrap.multi(
      managedOptTildeCriterionXData._resolveItemsFromRawData(
        dynamicValues: value,
        addOrphan: false,
        clearOrphanItems: true,
      ),
    );
  }

  OptValueWrap? __specifyDefaultValueForManagedOptTildeCriterion({
    required String managedOptTildeCriterionName,
    required String managedOptCriterionBaseName,
    required Object? parentManagedOptTildeCriterionValue,
    required ManagedOptSelectionMode managedOptSelectionMode,
    required XData managedOptTildeCriterionXData,
  }) {
    OptValueWrap? valueWrap = specifyDefaultValueForManagedOptTildeCriterion(
      managedOptCriterionBaseName: managedOptCriterionBaseName,
      managedOptTildeCriterionName: managedOptTildeCriterionName,
      parentManagedOptTildeCriterionValue: parentManagedOptTildeCriterionValue,
      managedOptTildeCriterionXData: managedOptTildeCriterionXData,
      managedOptSelectionMode: managedOptSelectionMode,
    );
    if (valueWrap == null) {
      __createNullValueWrapAppError(
        methodName: "specifyDefaultValueForManagedOptTildeCriterion",
        managedOptTildeCriterionName: managedOptTildeCriterionName,
      );
    }
    List? value = valueWrap?.values ?? [];
    return OptValueWrap.multi(
      managedOptTildeCriterionXData._resolveItemsFromRawData(
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
    return "${getClassName(this)}${debugClassParametersDefinition()}";
  }

  Type getFilterCriteriaType() {
    return FILTER_CRITERIA;
  }

  Type getFilterPatchType() {
    return FILTER_PATCH;
  }

  // ***************************************************************************
  // ***************************************************************************

  // ***************************************************************************
  // ***************************************************************************

  /// Queries all [Scalar]s and [Block]s bound to this [FilterModel],
  /// regardless of whether they are currently visible on the UI.
  @_RootMethodAnnotation()
  @_ReturnExecutionUnitResultMethodAnnotation()
  Future<FilterModelQueryResult> queryAll({
    FILTER_PATCH? filterPatch,
  }) async {
    if (__lockAddMoreQuery) {
      // IMPORTANT: Silently ignored as a no-op success.
      // Intentionally placed before CodeFlowLogger to suppress spurious
      // onChanged callbacks triggered during programmatic patchValue().
      return FilterModelQueryResult();
    }
    final executionTrace = FlutterArtist.codeFlowLogger._addMethodCall(
      ownerClassInstance: this,
      methodName: "queryAll",
      parameters: {
        "filterPatch": filterPatch,
      },
      isLibMethod: true,
    );

    executionTrace.addInfo(
      codeId: "#089100",
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
      filterPatch: filterPatch,
      forceQueryAll: true,
    );
  }

  /// Queries all [Scalar]s and [Block]s bound to this [FilterModel]
  /// that are currently visible on the UI.
  ///
  /// Any bound [Scalar] or [Block] that is not visible will transition to a lazy state.
  @_RootMethodAnnotation()
  @_ReturnExecutionUnitResultMethodAnnotation()
  Future<FilterModelQueryResult> query({
    FILTER_PATCH? filterPatch,
  }) async {
    if (__lockAddMoreQuery) {
      // IMPORTANT: Silently ignored as a no-op success.
      // Intentionally placed before CodeFlowLogger to suppress spurious
      // onChanged callbacks triggered during programmatic patchValue().
      return FilterModelQueryResult();
    }
    final executionTrace = FlutterArtist.codeFlowLogger._addMethodCall(
      ownerClassInstance: this,
      methodName: "query",
      parameters: {
        "filterPatch": filterPatch,
      },
      isLibMethod: true,
    );

    // Test Cases: [48b] - query() & queryAll().
    return await __query(
      executionTrace: executionTrace,
      methodName: "query",
      filterPatch: filterPatch,
      forceQueryAll: false,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  Future<FilterModelQueryResult> __query({
    required ExecutionTrace executionTrace,
    FILTER_PATCH? filterPatch,
    required String methodName,
    required bool forceQueryAll,
  }) async {
    executionTrace.addNonControllableCall(
      codeId: "#055000",
      caller: this,
      methodName: "checkBeforeQuery",
      suffixShortDesc: "",
      parameters: {},
    );

    final Actionable<FilterModelQueryPrecheck> actionable = checkBeforeQuery();
    if (!actionable.yes) {
      _addErrorLogActionable(
        executionTrace: executionTrace,
        traceStepCodeId: "#055200",
        prefixShortDesc: 'checkBeforeQuery()',
        module: shelf,
        actionableFalse: actionable,
        showErrSnackBar: true,
        tipDocument: null,
      );
      return FilterModelQueryResult(
        precheck: actionable.errCode,
      );
    }

    // Commit current draft snapshot to committed realm before query dispatch.
    _commitDraftSnapshotToCommitted();

    executionTrace.addInfo(
      codeId: "#055600",
      shortDesc: "Creating <b>$_XShelfFilterModelQuery</b>..",
    );

    final XShelf xShelf = _XShelfFilterModelQuery(
      filterModel: this,
      filterPatch: filterPatch,
      forceQueryAll: forceQueryAll,
    );

    FlutterArtist._rootQueue._addXRootQueueItem(xRootQueueItem: xShelf);
    await FlutterArtist.executor._executeExecutionUnitQueue();

    return FilterModelQueryResult(
      precheck: null,
      errorInfo: errorInfo,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  /// Evaluates whether [query] or [queryAll] is permitted on this [FilterModel].
  @_PrecheckMethod()
  Actionable<FilterModelQueryPrecheck> checkBeforeQuery() {
    return __checkBeforeQuery(checkBusy: true);
  }

  @_PrecheckPrivateMethod()
  Actionable<FilterModelQueryPrecheck> __checkBeforeQuery({
    required bool checkBusy,
  }) {
    // Remove condition: __lockAddMoreQuery
    final bool isBusy = FlutterArtist.executor.isBusy;

    return FilterModelQueryPrecheckUtils.checkBeforeQuery(
      checkBusy: checkBusy,
      isBusy: isBusy,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  /// Checks whether the full FilterModel debug inspector dialog can be opened.
  @_PrecheckMethod()
  Actionable<ShowFilterModelInspectorPrecheck>
      checkBeforeShowFilterModelInspector() {
    return ShowFilterModelInspectorPrecheckUtils
        .checkBeforeShowFilterModelInspector(
      hasFilterModel: this is! _DefaultFilterModel,
      loggedInUser: FlutterArtist.loggedInUser,
    );
  }

  /// Opens the full FilterModel debug inspector dialog if permitted.
  ///
  /// Displays an error snackbar using the precheck's [message] and [details]
  /// if the precheck fails and [showErrorSnackBar] is `true`.
  @_RootMethodAnnotation()
  Future<Actionable<ShowFilterModelInspectorPrecheck>>
      showDebugFilterModelInspector({
    String locationInfo = '',
    bool showErrorSnackBar = true,
  }) async {
    final Actionable<ShowFilterModelInspectorPrecheck> actionable =
        checkBeforeShowFilterModelInspector();

    if (!actionable.yes) {
      if (showErrorSnackBar) {
        final ShowFilterModelInspectorPrecheck err = actionable.errCode!;
        this.showErrorSnackBar(
          message: err.message,
          errorDetails: err.details,
        );
      }
      return actionable;
    }

    final BuildContext context = FlutterArtistCore.context;
    await DebugViewerDialog.openDebugFilterModelInspector(
      context: context,
      locationInfo: locationInfo,
      filterModel: this,
    );
    return actionable;
  }

  // ***************************************************************************
  // ***************************************************************************

  /// Checks whether the debug filter criteria / filter model inspector dialog can be opened.
  @_PrecheckMethod()
  Actionable<ShowFilterCriteriaInspectorPrecheck>
      checkBeforeShowFilterCriteriaInspector() {
    return ShowFilterCriteriaInspectorPrecheckUtils
        .checkBeforeShowFilterCriteriaInspector(
      hasFilterModel: this is! _DefaultFilterModel,
      loggedInUser: FlutterArtist.loggedInUser,
    );
  }

  /// Opens the debug filter criteria / filter model inspector dialog if permitted.
  ///
  /// Displays an error snackbar using the precheck's [message] and [details]
  /// if the precheck fails and [showErrorSnackBar] is `true`.
  @_RootMethodAnnotation()
  Future<Actionable<ShowFilterCriteriaInspectorPrecheck>>
      showDebugFilterCriteriaInspector({
    String locationInfo = '',
    bool showErrorSnackBar = true,
  }) async {
    final Actionable<ShowFilterCriteriaInspectorPrecheck> actionable =
        checkBeforeShowFilterCriteriaInspector();

    if (!actionable.yes) {
      if (showErrorSnackBar) {
        final ShowFilterCriteriaInspectorPrecheck err = actionable.errCode!;
        this.showErrorSnackBar(
          message: err.message,
          errorDetails: err.details,
        );
      }
      return actionable;
    }

    final BuildContext context = FlutterArtistCore.context;
    await DebugViewerDialog.openDebugFilterCriteriaInspector(
      context: context,
      locationInfo: locationInfo,
      filterModel: this,
    );
    return actionable;
  }

  // ***************************************************************************
  // ***************************************************************************

  // SAME-AS: #0009 (form)
  ManagedOptTildeFilterCriterionModel? findManagedOptFilterCriterion({
    required String managedOptTildeCriterionName,
  }) {
    return _filterModelStructure._findManagedOptFilterCriterion(
      managedOptTildeCriterionName: managedOptTildeCriterionName,
    );
  }

  // SAME-AS: #0008 (formModel.debugGetManagedOptPropLoadCount())
  int debugGetManagedOptCriteriaLoadCount(String managedOptTildeCriterionName) {
    return _filterModelStructure._debugGetManagedOptCriterionLoadCount(
      managedOptTildeCriterionName: managedOptTildeCriterionName,
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
