part of '../core.dart';

///
/// Block example:
/// ```dart
/// class EmployeeBlock
///       extends Block<int, EmployeeInfo, EmployeeData,
///                     EmptyFilerInput, EmptyFilterCriteria,
///                     EmptyFormInput, AdditionalFormRelatedData> {
///
/// }
/// ```
/// [ID] is Id Type of Item. For Example: [int].
///
/// [ITEM] is item. For example:
/// ```dart
/// class EmployeeInfo {
///     int id;
///     String name;
///     ...
/// }
/// ```
///
/// [ITEM_DETAIL]: Item Detail.
/// You need to implement [convertItemDetailToItem] method to convert Item-Detail to Item.
/// ```dart
///  class EmployeeData  {
///     int id;
///     String name;
///     String email;
///     String phoneNumber;
/// }
///
/// class EmployeeBlock extends Block<...> {
///
///     EmployeeInfo convertItemDetailToItem({EmployeeData itemDetail}) {
///       return EmployeeInfo(itemDetail.id, itemDetail.name);
///     }
/// }
/// ```
///
/// [FILTER_INPUT]: Additional data to create or modify [FilterModel].
/// ```
/// class EmployeeFilterInput extends FilterInput {
///    String? searchText,
///    int? departmentId;
/// }
/// ```
///
/// [FILTER_CRITERIA]: These are the criteria for filtering the this.data.
///
/// When the [Block.query] or [Scalar.query] method is called,
/// this [FilterCriteria] is created automatically by the [FilterModel]
/// via the [FilterModel.createNewFilterCriteria] method
/// and passed to the [Block.performQuery] or [Scalar.performQuery] method.
/// ```
/// class EmployeeFilterCriteria extends FilterCriteria {
///    String? searchText,
///    DepartmentInfo? department;
/// }
/// ```
///
/// [ADDITIONAL_FORM_RELATED_DATA]: Ancestral Data used for Form.
/// ```
/// class EmployeeFormRelatedData  {
///    final int departmentId;
///    final String departmentName;
/// }
/// ```
///
/// [FORM_INPUT]: Form data are used to create a record in the Form.
/// For example: Create an employee with the specified name,...
/// ```
/// class EmployeeFormInput extends FormInput {
///    String? name;
/// }
/// ```
///
abstract class Block<
    ID extends Object,
    ITEM extends Identifiable<ID>,
    ITEM_DETAIL extends Identifiable<ID>,
    FILTER_INPUT extends FilterInput, // EmptyFilterInput
    FILTER_CRITERIA extends FilterCriteria, // EmptyFilterCriteria
    FORM_INPUT extends FormInput, // EmptyFormInput
    ADDITIONAL_FORM_RELATED_DATA extends AdditionalFormRelatedData // EmptyAdditionalFormRelatedData
    > extends _Core {
  late final Shelf shelf;

  int _deletionErrorCount = 0;

  int get deletionErrorCount => _deletionErrorCount;

  int _lazyLoadCount = 0;

  int get lazyLoadCount => _lazyLoadCount;

  bool __isQuerying = false;

  bool get isQuerying => __isQuerying;

  bool __isSaving = false;

  bool get isSaving => __isSaving;

  bool __isDeleting = false;

  bool get isDeleting => __isDeleting;

  bool __isRefreshingCurrentItem = false;

  bool get isRefreshingCurrentItem => __isRefreshingCurrentItem;

  bool __isPreparingFormCreation = false;

  bool get isPreparingFormCreation => __isPreparingFormCreation;

  final BlockConfig config;

  late final _internalEffectedShelfMembers = EffectedShelfMembers.ofBlock(
    eventBlock: this,
  );

  // TODO: LOGIC-01
  final bool _alwaysTrySelectAnItemAsCurrent = true;

  bool get alwayTrySelectAnItemAsCurrent => _alwaysTrySelectAnItemAsCurrent;

  ///
  /// Block name. It is unique in a Shelf.
  ///
  final String name;

  String get _shortPathName {
    return "${shelf.name} > $name";
  }

  String get pathInfo {
    return "block > ${shelf.name} > $name";
  }

  @DebugMethodAnnotation()
  String get debugClassDefinition {
    return "${getClassName(this)}$debugClassParametersDefinition";
  }

  @DebugMethodAnnotation()
  String get debugClassParametersDefinition {
    return "<${getItemIdType()}, ${getItemType()}, ${getItemDetailType()}, "
        "${getFilterInputType()}, ${getFilterCriteriaType()}, "
        "${getFormInputType()}, ${getFormRelatedDataType()}>";
  }

  final String? description;

  ///
  /// FilterModel Name registered in [Shelf.defineShelfStructure()] method.
  ///
  final String? registeredFilterModelName;

  ///
  /// This field is not null.
  /// If this block does not declare a [FilterModel], it will have the default [FilterModel].
  ///
  late final FilterModel<FILTER_INPUT, FILTER_CRITERIA>
      _registeredOrDefaultFilterModel;

  ///
  /// This field is not null.
  /// If this block does not declare a [FilterModel], it will have the default [FilterModel].
  ///
  FilterModel<FILTER_INPUT, FILTER_CRITERIA>
      get registeredOrDefaultFilterModel => _registeredOrDefaultFilterModel;

  ///
  /// Returns a FilterModel declared in the [Shelf.defineShelfStructure()] method.
  /// The return value may be null.
  ///
  FilterModel<FILTER_INPUT, FILTER_CRITERIA>? get filterModel {
    if (_registeredOrDefaultFilterModel is _DefaultFilterModel) {
      return null;
    } else {
      return _registeredOrDefaultFilterModel;
    }
  }

  late final Block? parent;

  String? get parentBlockName => parent?.name;

  bool get isRoot => parent == null;

  Block get rootBlock {
    if (parent == null) {
      return this;
    }
    return parent!.rootBlock;
  }

  bool isSameWith(Block other) {
    if (shelf.name != other.shelf.name) {
      return false;
    }
    if (name == other.name) {
      return true;
    }
    return false;
  }

  bool isAncestorOf(Block other) {
    if (shelf.name != other.shelf.name) {
      return false;
    }
    if (name == other.name) {
      return false;
    }
    Block b = other;
    while (true) {
      Block? p = b.parent;
      if (p == null) {
        return false;
      }
      if (p.name == name) {
        return true;
      }
      b = p;
    }
  }

  bool isDescendantOf(Block other) {
    return other.isAncestorOf(this);
  }

  final FormModel<
      ID, //
      ITEM_DETAIL,
      FORM_INPUT,
      ADDITIONAL_FORM_RELATED_DATA>? formModel;

  final List<Block> _childBlocks;

  List<Block> get childBlocks => List.unmodifiable(_childBlocks);

  List<Block> get descendantBlocks {
    List<Block> ret = [];
    for (Block childBlock in _childBlocks) {
      ret.add(childBlock);
      ret.addAll(childBlock.descendantBlocks);
    }
    return ret;
  }

  List<Block> get descendantBlocksWithSameFilterModel {
    if (filterModel == null) {
      return [];
    }
    List<Block> ret = [];
    for (Block childBlock in _childBlocks) {
      if (childBlock.filterModel != null) {
        if (filterModel!.name == childBlock.filterModel!.name) {
          ret.add(childBlock);
        }
      }
      ret.addAll(childBlock.descendantBlocksWithSameFilterModel);
    }
    return ret;
  }

  List<Block> get ancestorBlocks {
    return ascendingAncestorBlocks.reversed.toList();
  }

  ///
  /// Ancestor Blocks + this Block + descendant Blocks.
  ///
  List<Block> get lineageBlocks {
    return <Block>[...ancestorBlocks, this, ...descendantBlocks];
  }

  ///
  /// Ascending ancestor blocks.
  ///
  List<Block> get ascendingAncestorBlocks {
    List<Block> list = [];
    Block blk = this;
    while (true) {
      Block? p = blk.parent;
      if (p == null) {
        break;
      }
      list.add(p);
      blk = p;
    }
    return list;
  }

  ///
  /// Descending ancestor blocks.
  ///
  List<Block> get descendingAncestorBlocks {
    return ascendingAncestorBlocks.reversed.toList();
  }

  int __performLoadItemDetailByIdCount = 0;

  int get performLoadItemDetailByIdCount => __performLoadItemDetailByIdCount;

  int __performQueryCount = 0;

  int get performQueryCount => __performQueryCount;

  QueryType __lastQueryType = QueryType.realQuery;

  QueryType get lastQueryType => __lastQueryType;

  late final __blockData = _BlockData<
      ID, //
      ITEM,
      ITEM_DETAIL,
      FILTER_INPUT,
      FILTER_CRITERIA,
      ADDITIONAL_FORM_RELATED_DATA,
      FORM_INPUT>._(
    this,
    config.pageable,
  );

  BlockErrorInfo? _blockErrorInfo;

  BlockErrorInfo? get blockErrorInfo => _blockErrorInfo;

  late final ui = _BlockUiComponents(block: this);

  // ***************************************************************************
  // *** DATA STATE ************************************************************
  // ***************************************************************************

  ///
  /// ```dart
  /// if(thisBlock.lastQueryResult == null) {
  ///   ...
  /// } else if(thisBlock.lastQueryResult is YourType) {
  ///   ...
  /// } else {
  ///   // Empty PageData<I>.
  ///   // Occurs if there is no "Item" currently selected on the parent Block
  ///   // or this Block was previously in Lazy Query State.
  /// }
  /// ```
  ///
  PageData<ITEM>? get lastQueryResult => __blockData._lastQueryResult;

  ActionResultState? get lastQueryResultState =>
      __blockData._lastQueryResultState;

  DataState get dataState => __blockData._blockDataState;

  DataState get selectionDataState => __blockData._selectionDataState;

  // nearestAncestorNonNoneDataState?
  DataState get ancestralNonNoneDataState {
    if (parent == null) {
      return DataState.ready;
    }
    if (parent!.dataState != DataState.none) {
      return parent!.dataState;
    }
    return parent!.ancestralNonNoneDataState;
  }

  FormMode? get formMode {
    if (formModel == null) {
      return null;
    }
    return formModel!.formMode;
  }

  // FormMode? get nearestAncestorFormMode {
  //   Block? p = parent;
  //   while (true) {
  //     if (p == null) {
  //       return null;
  //     }
  //     FormMode? pfm = p.formMode;
  //     if (pfm != null) {
  //       return pfm;
  //     }
  //     p = p.parent;
  //   }
  // }

  late final SortModel<ITEM>? _clientSideSortModel;

  late final SortModel<ITEM>? _serverSideSortModel;

  SortModel<ITEM>? get clientSideSortModel => _clientSideSortModel;

  SortModel<ITEM>? get serverSideSortModel => _serverSideSortModel;

  FILTER_CRITERIA? get filterCriteria =>
      __blockData._xFilterCriteria?.filterCriteria;

  int get filterCriteriaChangeCount => __blockData._filterCriteriaChangeCount;

  XFilterCriteria<FILTER_CRITERIA>? get debugXFilterCriteria =>
      __blockData._xFilterCriteria;

  ///
  /// return a copied list of items.
  ///
  List<ITEM> get items {
    return [...__blockData._items];
  }

  int get itemCount => __blockData._items.length;

  Pageable? get pageable => __blockData._pageable;

  Pageable? get nextPageable {
    if (lastQueryType == QueryType.emptyQuery) {
      return __blockData._initialPageable;
    }
    Pageable? p = __blockData._pageable;
    return p?.next();
  }

  PaginationInfo? get paginationInfo {
    return PaginationInfo.copy(__blockData._paginationInfo);
  }

  void _setToPending() {
    __blockData._setToPending();
  }

  // ***************************************************************************
  // ***************************************************************************

  _BlockReQryCon? _blockReQryCondition;

  _BlockItemRefreshCon? _blockItemRefreshCondition;

  bool _hasReactionBookmark() {
    return _blockReQryCondition != null || _blockItemRefreshCondition != null;
  }

  bool _isMatchBlockReQryCon(_BlockReQryCon? blockReQryCon) {
    if (blockReQryCon == null) {
      return false;
    }
    return blockReQryCon.parentItemId == parentBlockCurrentItemId &&
        blockReQryCon.filterCriteria == filterCriteria;
  }

  bool _isMatchBlockItemRefreshCon(_BlockItemRefreshCon? blockItemRefreshCon) {
    if (blockItemRefreshCon == null) {
      return false;
    }
    return currentItemId != null && blockItemRefreshCon.itemId == currentItemId;
  }

  // ***************************************************************************
  // *** Constructor ***********************************************************
  // ***************************************************************************

  Block({
    required this.name,
    required this.description,
    required BlockConfig config,
    required String? filterModelName,
    required this.formModel,
    required List<Block>? childBlocks,
    SortModelBuilder<ITEM>? sortModelBuilder,
  })  : registeredFilterModelName = filterModelName,
        config = config.copy(),
        _childBlocks = childBlocks ?? [] {
    for (Block childBlock in _childBlocks) {
      childBlock.parent = this;
    }
    formModel?.block = this;
    //
    _serverSideSortModel = sortModelBuilder?.createServerSideSortModel();
    _clientSideSortModel =
        config.clientSideSortStrategy != SortStrategy.modelBased
            ? null
            : sortModelBuilder?.createClientSideSortModel();
    _serverSideSortModel?.block = this;
    _clientSideSortModel?.block = this;
  }

  // ***************************************************************************

  XBlock<ID, ITEM, ITEM_DETAIL> _createXBlock({
    required XFilterModel xFilterModel,
    required XFormModel? xFormModel,
  }) {
    return XBlock<ID, ITEM, ITEM_DETAIL>._(
      block: this,
      xFilterModel: xFilterModel,
      xFormModel: xFormModel,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  // TODO: Rename.
  List<Event> getOutsideDataTypesToListen() {
    List<Event> itemTypeEvents = [];
    //
    itemTypeEvents.addAll(config.onExternalShelfEvents.blockLevelReactionOn);
    //
    return itemTypeEvents.toSet().toList();
  }

  // ***************************************************************************
  // ***************************************************************************

  void __clearItemsWithDataState({
    required XBlock thisXBlock,
    required DataState blockDataState,
    required DataState formDataState,
    required bool errorInFilter,
  }) {
    __assertThisXBlock(thisXBlock);
    //
    __blockData._clearItemsWithDataState(
      qryDataState: blockDataState,
      errorInFilter: errorInFilter,
    );
    //
    if (formModel != null) {
      formModel!._clearDataWithDataState(formDataState: formDataState);
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  void __clearWithDataStateAndChildrenToNonCascade({
    required XBlock thisXBlock,
    required DataState blkDataState,
    required DataState frmDataState,
    required bool errorInFilter,
  }) {
    __assertThisXBlock(thisXBlock);
    //
    __clearItemsWithDataState(
      thisXBlock: thisXBlock,
      blockDataState: blkDataState,
      formDataState: frmDataState,
      errorInFilter: errorInFilter,
    );
    //
    for (var childXBlock in thisXBlock.childXBlocks) {
      childXBlock.block.__clearWithDataStateAndChildrenToNonCascade(
        thisXBlock: childXBlock,
        blkDataState: DataState.none,
        frmDataState: DataState.none,
        errorInFilter: false,
      );
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  void __clearAllChildrenBlocksToNone({
    required XBlock thisXBlock,
  }) {
    __assertThisXBlock(thisXBlock);
    //
    for (var childXBlock in thisXBlock.childXBlocks) {
      childXBlock.block.__clearWithDataStateAndChildrenToNonCascade(
        thisXBlock: childXBlock,
        blkDataState: DataState.none,
        frmDataState: DataState.none,
        errorInFilter: false,
      );
    }
  }

  void __clearAllChildrenBlocksToPending({
    required XBlock thisXBlock,
  }) {
    __assertThisXBlock(thisXBlock);
    //
    for (var childXBlock in thisXBlock.childXBlocks) {
      childXBlock.block.__clearWithDataStateAndChildrenToNonCascade(
        thisXBlock: childXBlock,
        blkDataState: DataState.pending,
        frmDataState: DataState.none,
        errorInFilter: false,
      );
    }
  }

  // ***************************************************************************
  // ************ TYPES ********************************************************
  // ***************************************************************************

  Type getItemIdType() {
    return ID;
  }

  Type getItemType() {
    return ITEM;
  }

  Type getItemDetailType() {
    return ITEM_DETAIL;
  }

  Type getFilterInputType() {
    return FILTER_INPUT;
  }

  Type getFilterCriteriaType() {
    return FILTER_CRITERIA;
  }

  Type getFormInputType() {
    return FORM_INPUT;
  }

  Type getFormRelatedDataType() {
    return ADDITIONAL_FORM_RELATED_DATA;
  }

  // ***************************************************************************
  // ************ Need to Query State ******************************************
  // ***************************************************************************

  bool _needToQuery() {
    if (dataState != DataState.ready) {
      return true;
    }
    //
    Object? parentInData = __blockData._parentBlockCurrentItemId;
    Object? parentInBlock = parentBlockCurrentItemId;
    if (parentInData != parentInBlock) {
      return true;
    }
    //
    if (filterModel != null) {
      FilterCriteria? criteriaInFilter = filterModel!.filterCriteria;
      FilterCriteria? criteriaInData = filterCriteria;
      if (criteriaInFilter != criteriaInData) {
        return true;
      }
    }
    //
    return false;
  }

  // ***************************************************************************
  // ***************************************************************************

  void _emitBlockHidden() {
    // FlutterArtist.codeFlowLogger._addEvent(
    //   ownerClassInstance: this,
    //   event: "Block '${getClassName(this)}' just hides all UI Components!",
    //   isLibCode: true,
    // );
    if (config.onHideAction == BlockHiddenAction.clear) {
      Future.delayed(
        const Duration(seconds: 0),
        () {
          clear();
        },
      );
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  @_TaskUnitMethodAnnotation()
  @_BlockClearAnnotation()
  Future<void> _unitClear({
    required ExecutionTrace executionTrace,
    required TaskType taskType,
    required XBlock thisXBlock,
  }) async {
    __assertThisXBlock(thisXBlock);
    //
    executionTrace._addTraceStep(
      codeId: "#07000",
      shortDesc: "Begin ${debugObjHtml(this)} > ${taskType.asDebugTaskUnit()}.",
      traceStepType: TraceStepType.debug,
    );
    executionTrace._addTraceStep(
      codeId: "#07020",
      shortDesc:
          "Clear all item of ${debugObjHtml(this)} and set to <b>pending</b>. "
          "Clear all data of child blocks and set them to <b>none</b>."
          "${_childBlocks.isEmpty ? '\n   ** No children -> Nothing to do!' : ''}",
    );
    __clearWithDataStateAndChildrenToNonCascade(
      thisXBlock: thisXBlock,
      blkDataState: DataState.pending,
      frmDataState: DataState.none,
      errorInFilter: false,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  @_TaskUnitMethodAnnotation()
  @_BlockClearCurrentItemAnnotation()
  Future<void> _unitClearCurrent({
    required ExecutionTrace executionTrace,
    required TaskType taskType,
    required XBlock thisXBlock,
  }) async {
    __assertThisXBlock(thisXBlock);
    //
    executionTrace._addTraceStep(
      codeId: "#13000",
      shortDesc: "${debugObjHtml(this)} -> Begin ${taskType.asDebugTaskUnit()}",
      traceStepType: TraceStepType.debug,
    );
    //
    executionTrace._addTraceStep(
      codeId: "#13100",
      shortDesc: "${debugObjHtml(this)} -> set currentItem to null.",
    );
    __setCurrentItemOnly(
      id: null,
      item: null,
      itemDetail: null,
    );
    if (formModel != null) {
      executionTrace._addTraceStep(
        codeId: "#13200",
        shortDesc:
            "${debugObjHtml(formModel)} clear data and set state to <b>none</b>.",
      );
      formModel!._clearDataWithDataState(formDataState: DataState.none);
    }
    //
    executionTrace._addTraceStep(
      codeId: "#13400",
      shortDesc: "Clear data of all child blocks and set them to <b>none</b>."
          "${_childBlocks.isEmpty ? '\n   ** No children -> Nothing to do!' : ''}",
    );
    // Test Case: [38b].
    __clearAllChildrenBlocksToNone(
      thisXBlock: thisXBlock,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  @_TaskUnitMethodAnnotation()
  @_BlockQueryAnnotation()
  @_BlockQueryMorePageAnnotation()
  @_BlockQueryNextPageAnnotation()
  @_BlockQueryPreviousPageAnnotation()
  @_BlockQueryAndPrepareToEditAnnotation()
  @_BlockQueryAndPrepareToCreateAnnotation()
  Future<void> _unitQuery({
    required ExecutionTrace executionTrace,
    required TaskType taskType,
    required XBlock thisXBlock,
  }) async {
    __assertThisXBlock(thisXBlock);
    //
    executionTrace._addTraceStep(
      codeId: "#03000",
      shortDesc:
          "${debugObjHtml(this)} -> Begin ${taskType.asDebugTaskUnit()}.",
      traceStepType: TraceStepType.debug,
    );
    //
    bool provideBlockContext = ui.hasActiveUiComponentBlockRepresentative(
      alsoCheckChildren: true,
    );
    //
    executionTrace._addTraceStep(
      codeId: "#03020",
      shortDesc: "@provideBlockContext: ${debugObjHtml(provideBlockContext)}.",
      traceStepType: TraceStepType.debug,
      tipDocument: TipDocument.blockActiveUiComponents,
    );
    //
    QryHint queryHint = thisXBlock.queryHint;
    if (queryHint != QryHint.force) {
      if (dataState != DataState.ready && provideBlockContext) {
        queryHint = QryHint.force;
      }
    }
    //
    executionTrace._addTraceStep(
      codeId: "#03040",
      shortDesc: "@queryHint: ${debugObjHtml(queryHint)}.",
      traceStepType: TraceStepType.debug,
    );
    //
    thisXBlock._printParameters(provideBlockContext: provideBlockContext);
    //
    final performQueryMethod = BlockErrorMethod.performQuery;
    DataState newBlockDataState = dataState;
    PageData<ITEM>? queriedPageData;
    final ITEM? candidateCurrItem;
    bool queried = false;

    if (queryHint == QryHint.none) {
      executionTrace._addTraceStep(
        codeId: "#03060",
        shortDesc: "@queryHint: ${debugObjHtml(queryHint)}.",
      );
      candidateCurrItem = null;
      //
      BlockSetCurrentItemDirective? setCurrentItemDirective;
      final defaultAfterQueryDirective = FlutterArtist.defaultAfterQueryDirective;
      final BlockSetCurrentItemDirective? defaultBlockSetCurrentItemDirective =
          defaultAfterQueryDirective.toSetCurrentItemDirective();
      //
      // If Natural Mode: Try to select an item as current if the Block has no current.
      //
      if (thisXBlock.xShelf.naturalMode) {
        executionTrace._addTraceStep(
          codeId: "#03080",
          shortDesc: "Currently, ${debugObjHtml(this)} query in naturalMode.",
        );
        // Test Cases: [38b] - test_companyCreationScreen_to_employeeScreen.
        // No need to select an Item as Current.
        if (formModel?.formMode == FormMode.creation) {
          executionTrace._addTraceStep(
            codeId: "#03100",
            shortDesc:
                "The ${debugObjHtml(this)} is in creation mode --> cancel query.",
          );
          return;
        }
        //
        setCurrentItemDirective = defaultBlockSetCurrentItemDirective;
      }
      // Not Natural Mode.
      else {
        if (thisXBlock.setCurrentItemDirective != null) {
          setCurrentItemDirective = thisXBlock.setCurrentItemDirective!;
        }
      }
      //
      // Test Cases: [63a] - __test_event_63a__external_product_event_in_productScreen_1
      //
      if (currentItem == null && setCurrentItemDirective == null) {
        executionTrace._addTraceStep(
          codeId: "#03120",
          shortDesc:
              "The block has no currentItem and @setCurrentItemDirective is null --> Cancel query.",
        );
        return;
      }
      //
      final taskUnit = _BlockSetItemAsCurrentTaskUnit<ID, ITEM>(
        setCurrentItemDirective: setCurrentItemDirective ??
            BlockSetCurrentItemDirective.setAnItemAsCurrentIfNeed,
        xBlock: thisXBlock,
        newQueriedList: [],
        candidateItem: candidateCurrItem,
        forceReloadItem: thisXBlock.forceReloadCurrItem,
        forceTypeForForm: null,
      );
      executionTrace._addTraceStep(
        codeId: "#03140",
        shortDesc: "Create ${taskUnit.asDebugTaskUnit()} and add to Queue.",
        traceStepType: TraceStepType.addTaskUnit,
      );
      thisXBlock.xShelf._addTaskUnit(
        taskUnit: taskUnit,
      );
      return;
    }
    //
    else if (queryHint == QryHint.markAsPending) {
      executionTrace._addTraceStep(
        codeId: "#03160",
        shortDesc: "@queryHint: $queryHint.",
      );
      executionTrace._addTraceStep(
        codeId: "#03180",
        shortDesc:
            "Clear all items of ${debugObjHtml(this)} and set to <b>pending</b>. "
            "Clear data of all child blocks and set them to <b>none</b>."
            "${_childBlocks.isEmpty ? '\n   ** No children -> Nothing to do!' : ''}",
      );
      __clearWithDataStateAndChildrenToNonCascade(
        thisXBlock: thisXBlock,
        blkDataState: DataState.pending,
        frmDataState: DataState.none,
        errorInFilter: false,
      );
      thisXBlock.setReQueryDone();
      return;
    }
    //
    else if (queryHint != QryHint.force) {
      throw "TODO"; // Never run.
    }
    //
    // FORCE QUERY:
    // thisXBlock.queryHint || (provideBlockContext && this.dataState != DataState.ready)
    //
    XFilterCriteria<FILTER_CRITERIA>? xFilterCriteriaOfFilterModel;
    try {
      final XFilterModel xFilterModel = thisXBlock.xFilterModel;
      final FilterModel filterModel = xFilterModel.filterModel;
      // SAME-AS: #0004
      if (!xFilterModel.queried) {
        if (filterModel is! _DefaultFilterModel) {
          executionTrace._addTraceStep(
            codeId: "#03200",
            shortDesc: "Need to load data for ${debugObjHtml(filterModel)}.",
          );
        }
        FILTER_INPUT? filterInput = xFilterModel.filterInput as FILTER_INPUT?;
        //
        xFilterCriteriaOfFilterModel =
            await filterModel._startNewFilterActivity(
          executionTrace: executionTrace,
          activityType: FilterActivityType.newFilt,
          filterInput: filterInput,
        ) as XFilterCriteria<FILTER_CRITERIA>?;
        //
        xFilterModel.queried = true;
      } else {
        if (filterModel is! _DefaultFilterModel) {
          executionTrace._addTraceStep(
            codeId: "#03220",
            shortDesc:
                "${debugObjHtml(filterModel)} data ready --> no need to load data.",
          );
        }
        xFilterCriteriaOfFilterModel =
            filterModel._xFilterCriteria! as XFilterCriteria<FILTER_CRITERIA>;
      }
    } catch (e, stackTrace) {
      executionTrace._addTraceStep(
        codeId: "#03240",
        shortDesc: "Load data for ${debugObjHtml(filterModel)} error!",
      );
      // @@TODO@@ 12 Test.
      print("ERROR _unitQuery: $stackTrace");
      /* Never Error */
    }
    //
    // Has Error in FilterModel.
    //
    if (xFilterCriteriaOfFilterModel == null) {
      executionTrace._addTraceStep(
        codeId: "#03260",
        shortDesc:
            "Clear all items of ${debugObjHtml(this)} and set dataState to <b>error</b>. "
            "Clear data of all child blocks and set them to <b>none</b>."
            "${_childBlocks.isEmpty ? '\n   ** No children -> Nothing to do!' : ''}",
      );
      // Test Cases: [23a].
      // Set Block to error cascade.
      __clearWithDataStateAndChildrenToNonCascade(
        thisXBlock: thisXBlock,
        blkDataState: DataState.error,
        frmDataState: DataState.none,
        errorInFilter: true,
      );
      thisXBlock.queryResult._setFilterError();
      return;
    }
    //
    // Ready FilterCriteria:
    //
    final bool parentOrCriteriaChanged =
        __blockData._isParentOrFilterCriteriaChanged(
      newCurrentParentItemId: parentBlockCurrentItemId,
      newXFilterCriteria: xFilterCriteriaOfFilterModel,
    );
    //
    ActionResultState queryResultState;
    //
    ListUpdateStrategy realListUpdateStrategy;
    //
    final Pageable? usedPageable;
    //
    if (thisXBlock.queryType == QueryType.realQuery) {
      executionTrace._addTraceStep(
        codeId: "#03280",
        shortDesc: "@queryType: ${debugObjHtml(thisXBlock.queryType)}.",
        traceStepType: TraceStepType.debug,
        tipDocument: TipDocument.blockQueryType,
      );
      usedPageable = thisXBlock.pageable ?? config.pageable;
      final QueryType newQueryType = thisXBlock.queryType;
      final queryTypeChanged = __lastQueryType != newQueryType;
      __lastQueryType = newQueryType;
      //
      // Call Query API:
      //
      try {
        __blockData._backupManualArrangementBeforeQueryIfNeed();
        __clearBlockError();
        __refreshQueryingState(isQuerying: true);
        //
        final SortableCriteria sortableCriteria;
        if (serverSideSortModel != null) {
          executionTrace._addTraceStep(
            codeId: "#03320",
            shortDesc:
                "Calling ${debugObjHtml(serverSideSortModel)}.getSortableCriteria():",
            traceStepType: TraceStepType.nonControllableCalling,
            tipDocument: TipDocument.sorting,
          );
          sortableCriteria = serverSideSortModel!.getSortableCriteria();
          executionTrace._addTraceStep(
            codeId: "#03324",
            shortDesc:
                "Got @sortableCriteria: ${debugObjHtml(sortableCriteria)}.",
            traceStepType: TraceStepType.debug,
          );
        } else {
          sortableCriteria = SortableCriteria._empty();
          executionTrace._addTraceStep(
            codeId: "#03330",
            shortDesc:
                "No <b>serverSideSortModel</b> --> @sortableCriteria: ${debugObjHtml(sortableCriteria)}.",
            traceStepType: TraceStepType.debug,
            tipDocument: TipDocument.sorting,
          );
        }
        //
        executionTrace._addTraceStep(
          codeId: "#03340",
          shortDesc: "Calling ${debugObjHtml(this)}.performQuery()...",
          parameters: {
            "parentBlockCurrentItem": parent?.currentItem,
            "filterCriteria": xFilterCriteriaOfFilterModel.filterCriteria,
            "sortableCriteria": sortableCriteria,
            "pageable": usedPageable,
          },
          traceStepType: TraceStepType.controllableCalling,
        );
        __performQueryCount++;
        final ApiResult<PageData<ITEM>?> result = await performQuery(
          parentBlockCurrentItem: parent?.currentItem,
          filterCriteria: xFilterCriteriaOfFilterModel.filterCriteria,
          sortableCriteria: sortableCriteria,
          pageable: usedPageable,
        );
        // Throw ApiError:
        result.throwIfError();
        //
        // Query DONE!
        //
        thisXBlock.setReQueryDone();
        queried = true;
        queryResultState = ActionResultState.success;
        queriedPageData = result.data;
        //
        executionTrace._addTraceStep(
          codeId: "#03360",
          shortDesc: "Got @queriedPageData: ${debugObjHtml(queriedPageData)}.",
          traceStepType: TraceStepType.debug,
          tipDocument: TipDocument.pageData,
        );
      } catch (e, stackTrace) {
        queryResultState = ActionResultState.fail;
        queriedPageData = null;
        //
        final blockErrorInfo = BlockErrorInfo(
          blockDataState: dataState,
          blockErrorMethod: performQueryMethod,
          error: e, // AppError, ApiError or others.
          errorStackTrace: stackTrace,
        );
        __setBlockErrorInfo(blockErrorInfo);
        //
        final errorInfo = _handleError(
          shelf: shelf,
          methodName: performQueryMethod.name,
          // AppError, ApiError or others.
          error: e,
          stackTrace: stackTrace,
          showSnackBar: true,
          tipDocument: TipDocument.blockPerformQuery,
        );
        thisXBlock.queryResult._setErrorInfo(
          errorInfo: errorInfo,
        );
        //
        executionTrace._addTraceStep(
          codeId: "#03400",
          shortDesc:
              "The ${debugObjHtml(this)}.performQuery() method was called with an error!",
          errorInfo: errorInfo,
        );
      } finally {
        __refreshQueryingState(isQuerying: false);
      }
      //
      if (queryResultState == ActionResultState.fail) {
        // Query Error + Parent or Criteria changed.
        if (parentOrCriteriaChanged) {
          switch (dataState) {
            case DataState.ready:
              // @FaCode-002.
              // Test Case: [42a].
              // Replace by empty items.
              realListUpdateStrategy = ListUpdateStrategy.replace;
              newBlockDataState = DataState.error;
            case DataState.pending:
              // Replace by empty items.
              realListUpdateStrategy = ListUpdateStrategy.replace;
              newBlockDataState = DataState.error;
            case DataState.error:
              // @FaCode-003.
              // Test Case: [42a].
              // Replace by empty items.
              realListUpdateStrategy = ListUpdateStrategy.replace;
              newBlockDataState = DataState.error;
            case DataState.none:
              // Replace by empty items.
              realListUpdateStrategy = ListUpdateStrategy.replace;
              newBlockDataState = DataState.error;
          }
        }
        // Query Error + Parent not changed + Criteria not changed.
        // Test Case: [42a].
        else {
          switch (dataState) {
            case DataState.ready:
              // Append empty items (No items got from Server).
              // Test Case: [42a].
              // @FaCode-001.
              realListUpdateStrategy = ListUpdateStrategy.merge;
              newBlockDataState = DataState.ready;
            case DataState.pending:
              // Replace by empty items.
              realListUpdateStrategy = ListUpdateStrategy.replace;
              newBlockDataState = DataState.error;
            case DataState.error:
              // @FaCode-004.
              // Replace by empty items.
              realListUpdateStrategy = ListUpdateStrategy.replace;
              newBlockDataState = DataState.error;
            case DataState.none:
              // Replace by empty items.
              realListUpdateStrategy = ListUpdateStrategy.replace;
              newBlockDataState = DataState.error;
          }
        }
      }
      // Query Successful:
      else {
        // Query Successful + Parent or Criteria changed.
        if (parentOrCriteriaChanged) {
          switch (dataState) {
            case DataState.ready:
              // Replace.
              realListUpdateStrategy = ListUpdateStrategy.replace;
              newBlockDataState = DataState.ready;
            case DataState.pending:
              // Replace.
              realListUpdateStrategy = ListUpdateStrategy.replace;
              newBlockDataState = DataState.ready;
            case DataState.error:
              // Replace.
              realListUpdateStrategy = ListUpdateStrategy.replace;
              newBlockDataState = DataState.ready;
            case DataState.none:
              // Replace.
              realListUpdateStrategy = ListUpdateStrategy.replace;
              newBlockDataState = DataState.ready;
          }
        }
        // Query Successful + Parent not changed + Criteria not changed.
        else {
          switch (dataState) {
            case DataState.ready:
              // Replace or Expand:
              realListUpdateStrategy = thisXBlock.listUpdateStrategy;
              newBlockDataState = DataState.ready;
            case DataState.pending:
              // Replace.
              realListUpdateStrategy = ListUpdateStrategy.replace;
              newBlockDataState = DataState.ready;
            case DataState.error:
              // Replace.
              realListUpdateStrategy = ListUpdateStrategy.replace;
              newBlockDataState = DataState.ready;
            case DataState.none:
              // Replace.
              realListUpdateStrategy = ListUpdateStrategy.replace;
              newBlockDataState = DataState.ready;
          }
        }
      }
      if (queryTypeChanged) {
        // Replace:
        realListUpdateStrategy = ListUpdateStrategy.replace;
      }
    }
    // Query Empty:
    else {
      executionTrace._addTraceStep(
        codeId: "#03500",
        shortDesc: "@queryType: ${thisXBlock.queryType}.",
      );
      usedPageable = __blockData._emptyPageable;
      __lastQueryType = thisXBlock.queryType;
      realListUpdateStrategy = ListUpdateStrategy.replace;
      newBlockDataState = DataState.ready;
      queriedPageData = PageData.empty();
      queryResultState = ActionResultState.success;
    }
    //
    executionTrace._addTraceStep(
      codeId: "#03520",
      shortDesc: "Calculated:",
      parameters: {
        "realListUpdateStrategy": realListUpdateStrategy,
      },
      traceStepType: TraceStepType.debug,
    );
    //
    //
    final ITEM? currItem = currentItem;
    try {
      executionTrace._addTraceStep(
        codeId: "#03540",
        shortDesc:
            "Calling ${debugObjHtml(this)}.__processQueryResult() to process queried data.",
        parameters: {
          "usedXFilterCriteria": xFilterCriteriaOfFilterModel,
          "usedPageable": usedPageable,
          "queriedPageData": queriedPageData,
          "newBlockDataState": newBlockDataState,
          "queryResultState": queryResultState,
        },
        traceStepType: TraceStepType.nonControllableCalling,
      );
      final processedQueryResult = __processQueryResult(
        usedXFilterCriteria: xFilterCriteriaOfFilterModel,
        usedPageable: usedPageable,
        queriedPageData: queriedPageData,
        newBlockDataState: newBlockDataState,
        queryResultState: queryResultState,
      );
      //
      // Update queried items to the List:
      //
      __blockData._updateData(
        executionTrace: executionTrace,
        forceListUpdateStrategy: realListUpdateStrategy,
        processedQueryResult: processedQueryResult,
      );
    } catch (e, stackTrace) {
      final ErrorInfo errorInfo = _handleError(
        shelf: shelf,
        methodName: '__blockData._updateData()',
        error: e,
        stackTrace: stackTrace,
        showSnackBar: true,
        tipDocument: null,
      );
      thisXBlock.queryResult._setErrorInfo(
        errorInfo: errorInfo,
      );
      executionTrace._addTraceStep(
        codeId: "#03560",
        shortDesc: "Update queried data to block --> error.",
        errorInfo: errorInfo,
      );
      return;
    }
    //
    final bool currentItemInList = currItem != null && containsItem(currItem);
    candidateCurrItem = currentItemInList ? currItem : null;
    //
    executionTrace._addTraceStep(
      codeId: "#03580",
      shortDesc: "@currentItemInList: ${debugObjHtml(currentItemInList)}.",
      traceStepType: TraceStepType.debug,
    );
    //
    if (!currentItemInList) {
      executionTrace._addTraceStep(
        codeId: "#03600",
        shortDesc: "Set currentItem to <b>null</b>.",
      );
      __blockData._setCurrentItemOnly(
        id: null,
        refreshedItem: null,
        refreshedItemDetail: null,
      );
      //
      if (formModel != null) {
        executionTrace._addTraceStep(
          codeId: "#03610",
          shortDesc:
              "Clear ${debugObjHtml(formModel)} data and set to <b>none</b>.",
          traceStepType: TraceStepType.info,
        );
        formModel!._clearDataWithDataState(formDataState: DataState.none);
      }
      executionTrace._addTraceStep(
        codeId: "#03620",
        shortDesc:
            "Clear data of all child blocks and set them to <b>none</b> state."
            "${_childBlocks.isEmpty ? '\n   ** No children -> Nothing to do!' : ''}",
        traceStepType: TraceStepType.info,
      );
      // (Currently, In _unitQuery && queryHint).
      // Test Case: [42a].
      __clearAllChildrenBlocksToNone(
        thisXBlock: thisXBlock,
      );
    }
    // currentItemInList.
    else {
      switch (newBlockDataState) {
        case DataState.none:
          // @@TODO@@ 04.
          // Never run:
          __clearAllChildrenBlocksToNone(
            thisXBlock: thisXBlock,
          );
        case DataState.pending:
          // @@TODO@@ 05.
          // Never run:
          __clearAllChildrenBlocksToNone(
            thisXBlock: thisXBlock,
          );
        case DataState.error:
          // TODO: Test Cases.
          executionTrace._addTraceStep(
            codeId: "#03640",
            shortDesc:
                "@newBlockDataState: $newBlockDataState --> Clear data of all child blocks and set them to <b>none</b> state."
                "${_childBlocks.isEmpty ? '\n   ** No children -> Nothing to do!' : ''}",
            traceStepType: TraceStepType.info,
          );
          __clearAllChildrenBlocksToNone(
            thisXBlock: thisXBlock,
          );
        case DataState.ready:
          break;
      }
    }
    if (thisXBlock.xShelf.naturalMode) {
      if (formMode == FormMode.creation) {
        executionTrace._addTraceStep(
          codeId: "#03660",
          shortDesc:
              "This query in naturalMode and formMode is creation --> do nothing.",
        );
        // Do nothing.
        // Test Case: [38b].
        return;
      }
    }
    //
    // TODO: LOGIC-01 (If not querying block --> No need to force select an item).
    BlockAfterQueryDirective afterQueryDirective = thisXBlock.afterQueryDirective;
    if (!thisXBlock.xShelf.naturalMode) {
      if (!queried) {
        return;
      }
    }
    executionTrace._addTraceStep(
      codeId: "#03700",
      shortDesc: "@afterQueryDirective: ${debugObjHtml(afterQueryDirective)}.",
      traceStepType: TraceStepType.debug,
    );
    //
    // Begin AfterQueryDirective
    //
    if (afterQueryDirective == BlockAfterQueryDirective.clearCurrentItem) {
      final taskUnit = _BlockClearCurrentTaskUnit<ITEM>(
        xBlock: thisXBlock,
      );
      executionTrace._addTraceStep(
        codeId: "#03720",
        shortDesc: "@afterQueryDirective: ${debugObjHtml(afterQueryDirective)} --> "
            "Create ${taskUnit.asDebugTaskUnit()} and add to queue.",
        traceStepType: TraceStepType.addTaskUnit,
      );
      thisXBlock.xShelf._addTaskUnit(
        taskUnit: taskUnit,
      );
      return;
    }
    // createNewItem
    else if (afterQueryDirective == BlockAfterQueryDirective.createNewItem) {
      final taskUnit = _BlockPrepareFormToCreateItemTaskUnit(
        xBlock: thisXBlock,
        initDirty: false,
        formInput: null,
      );
      executionTrace._addTraceStep(
        codeId: "#03740",
        shortDesc: "@afterQueryDirective: $afterQueryDirective --> "
            "Create ${taskUnit.asDebugTaskUnit()} and add to queue.",
        traceStepType: TraceStepType.addTaskUnit,
      );
      thisXBlock.xShelf._addTaskUnit(
        taskUnit: taskUnit,
      );
      return;
    }
    //
    final BlockSetCurrentItemDirective setCurrentItemDirective;
    switch (afterQueryDirective) {
      case BlockAfterQueryDirective.clearCurrentItem:
        throw UnimplementedError("Never ran. Handled above.");
      case BlockAfterQueryDirective.createNewItem:
        throw UnimplementedError("Never ran. Handled above.");
      case BlockAfterQueryDirective.setAnItemAsCurrentIfNeed:
        setCurrentItemDirective = BlockSetCurrentItemDirective.setAnItemAsCurrentIfNeed;
      case BlockAfterQueryDirective.setAnItemAsCurrent:
        setCurrentItemDirective = BlockSetCurrentItemDirective.setAnItemAsCurrent;
      case BlockAfterQueryDirective.setAnItemAsCurrentThenLoadForm:
        setCurrentItemDirective =
            BlockSetCurrentItemDirective.setAnItemAsCurrentThenLoadForm;
    }
    //
    executionTrace._addTraceStep(
      codeId: "#03780",
      shortDesc:
          "Calculated >> @setCurrentItemDirective: ${debugObjHtml(setCurrentItemDirective)}.",
      traceStepType: TraceStepType.debug,
    );
    //
    final taskUnit = _BlockSetItemAsCurrentTaskUnit<ID, ITEM>(
      setCurrentItemDirective: setCurrentItemDirective,
      xBlock: thisXBlock,
      newQueriedList: queriedPageData?.items ?? [],
      candidateItem: candidateCurrItem,
      forceReloadItem: false,
      forceTypeForForm: null,
    );
    executionTrace._addTraceStep(
      codeId: "#03800",
      shortDesc: "Create ${taskUnit.asDebugTaskUnit()} and add to Queue.",
      traceStepType: TraceStepType.addTaskUnit,
    );
    //
    thisXBlock.xShelf._addTaskUnit(
      taskUnit: taskUnit,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  @_TaskUnitMethodAnnotation()
  @_FormModelLoadDataAnnotation()
  @_BlockRefreshCurrentItemAnnotation()
  @_BlockSetItemAsCurrentAnnotation()
  @_BlockSelectNextItemAsCurrentAnnotation()
  @_BlockSelectFirstItemAsCurrentAnnotation()
  @_BlockSelectPreviousItemAsCurrentAnnotation()
  Future<void> _unitSetItemAsCurrent({
    required ExecutionTrace executionTrace,
    required TaskType taskType,
    required XBlock<ID, ITEM, ITEM_DETAIL> thisXBlock,
    required BlockSetCurrentItemDirective setCurrentItemDirective,
    required List<ITEM> newQueriedList,
    required ITEM? inputCandidateCurrItem,
    required BlockSetCurrentItemResult<ITEM> blockSetCurrentItemResult,
  }) async {
    __assertThisXBlock(thisXBlock);
    //
    executionTrace._addTraceStep(
      codeId: "#28000",
      shortDesc:
          "${debugObjHtml(this)} -> Begin ${taskType.asDebugTaskUnit()}.",
      parameters: {
        "inputCandidateCurrItem": inputCandidateCurrItem,
        "newQueriedList": newQueriedList,
        "setCurrentItemDirective": setCurrentItemDirective,
      },
      traceStepType: TraceStepType.debug,
    );
    //
    final bool manualDirty = false;
    if (formModel != null) {
      executionTrace._addTraceStep(
        codeId: "#28020",
        shortDesc:
            "${debugObjHtml(formModel)} -> set <b>manualDirty</b> to ${debugObjHtml(manualDirty)}.",
      );
      formModel?._formPropsStructure._setManualDirty(manualDirty);
    }
    //
    if (thisXBlock.candidateCurrItem != null) {
      executionTrace._addTraceStep(
        codeId: "#28030",
        shortDesc:
            "Candidate Item specified by XBlock: ${debugObjHtml(thisXBlock.candidateCurrItem)}",
      );
      //
      inputCandidateCurrItem ??= (thisXBlock.candidateCurrItem as ITEM);
    }
    if (inputCandidateCurrItem != null) {
      blockSetCurrentItemResult._addCandidateItem(inputCandidateCurrItem);
    }
    //
    if (dataState == DataState.pending) {
      executionTrace._addTraceStep(
        codeId: "#28040",
        shortDesc:
            "${debugObjHtml(this)} dataState is pending -> clear all data in child blocks and set them to <b>none</b>."
            "${_childBlocks.isEmpty ? '\n   ** No children -> Nothing to do!' : ''}",
        traceStepType: TraceStepType.info,
      );
      __clearWithDataStateAndChildrenToNonCascade(
        thisXBlock: thisXBlock,
        blkDataState: dataState,
        frmDataState: DataState.none,
        errorInFilter: false,
      );
      return;
    }
    //
    if (dataState == DataState.error) {
      executionTrace._addTraceStep(
        codeId: "#28060",
        shortDesc:
            "${debugObjHtml(this)} dataState is error -> clear all data in child blocks and set them to <b>none</b>."
            "${_childBlocks.isEmpty ? '\n   ** No children -> Nothing to do!' : ''}",
        traceStepType: TraceStepType.info,
      );
      __clearWithDataStateAndChildrenToNonCascade(
        thisXBlock: thisXBlock,
        blkDataState: DataState.error,
        frmDataState: DataState.none,
        errorInFilter: false,
      );
      return;
    }
    //
    if (itemCount == 0) {
      executionTrace._addTraceStep(
        codeId: "#28080",
        shortDesc:
            "${debugObjHtml(this)} has no item -> clear all data in child blocks and set them to <b>none</b>."
            "${_childBlocks.isEmpty ? '\n   ** No children -> Nothing to do!' : ''}",
        traceStepType: TraceStepType.info,
      );
      // TODO: Test Cases.
      __clearAllChildrenBlocksToNone(
        thisXBlock: thisXBlock,
      );
      return;
    }
    //
    ITEM? candidateCurrItem = inputCandidateCurrItem;
    //
    if (candidateCurrItem != null) {
      if (!containsItem(candidateCurrItem)) {
        executionTrace._addTraceStep(
          codeId: "#28120",
          shortDesc:
              "Candidate Item ${debugObjHtml(candidateCurrItem)} not in the list items of the block -> set candidate item to null.",
        );
        candidateCurrItem = null;
      }
    }
    //
    final ITEM? currItemOrigin = currentItem;
    final ITEM? currItem;
    if (currItemOrigin != null) {
      if (containsItem(currItemOrigin)) {
        currItem = currItemOrigin;
      } else {
        currItem = null;
      }
    } else {
      currItem = null;
    }
    //
    final bool currItemWillChanged;
    if (currItem == null) {
      executionTrace._addTraceStep(
        codeId: "#28160",
        shortDesc:
            "Currently, this block contains <b>$itemCount items</b> and has no <b>current item</b>.",
        traceStepType: TraceStepType.info,
      );
      if (candidateCurrItem == null) {
        // If UI Component Active need an ITEM-load.
        final String? itemContextComponent =
            ui.findActiveUiComponentByItemContext(
          alsoCheckChildren: true,
        );
        final bool hasItemRep = itemContextComponent != null;
        executionTrace._addTraceStep(
          codeId: "#28200",
          shortDesc: hasItemRep
              ? "Found a <b>UI-X-Component</b> that displays and represents the ITEM. So setting a currentItem is required."
              : "This block does not have any visible <b>UI-Component</b> but represents the ITEM.",
          parameters: {
            "itemContextComponent": itemContextComponent,
          },
          tipDocument: TipDocument.blockActiveUiComponents,
        );
        //
        ITEM? candidateCurrItem2;
        executionTrace._addTraceStep(
          codeId: "#28220",
          shortDesc:
              "Calling ${debugObjHtml(this)}.specifyItemIndexToSetAsCurrent() method "
              "to specify an <b>itemIndex</b> as the current one.",
          note:
              "You can override this method, otherwise the first ITEM will be the candidate. ",
          traceStepType: TraceStepType.controllableCalling,
        );
        int? suggestIdx = specifyItemIndexToSetAsCurrent();
        //
        executionTrace._addTraceStep(
          codeId: "#28240",
          shortDesc: "Got value: <b>$suggestIdx</b>.",
        );
        if (suggestIdx != null && suggestIdx >= 0 && suggestIdx < itemCount) {
          candidateCurrItem2 = candidateCurrItem2 ?? items[suggestIdx];
        }
        candidateCurrItem2 = candidateCurrItem2 ?? firstItem;
        executionTrace._addTraceStep(
          codeId: "#28260",
          shortDesc:
              "Found an ITEM that could be a candidate - ${debugObjHtml(candidateCurrItem2)}",
        );
        final bool isInNewQueryList2;
        if (candidateCurrItem2 == null) {
          isInNewQueryList2 = false;
        } else {
          isInNewQueryList2 = FaItemsUtils.isListContainItem(
            targetList: newQueriedList,
            item: candidateCurrItem2,
            getItemId: _getItemIdInternal,
          );
        }
        if (isInNewQueryList2) {
          executionTrace._addTraceStep(
            codeId: "#28280",
            shortDesc:
                "The ITEM ${debugObjHtml(candidateCurrItem2)} is in the list of ITEM(s) just queried.",
          );
        }
        //
        executionTrace._addTraceStep(
          codeId: "#28300",
          shortDesc: "State:"
              "\n - ITEM == ITEM_DETAIL?: <b>${ITEM == ITEM_DETAIL}</b>."
              "\n - @setCurrentItemDirective: <b>$setCurrentItemDirective</b>.",
          traceStepType: TraceStepType.debug,
        );
        //
        if (hasItemRep ||
            setCurrentItemDirective == BlockSetCurrentItemDirective.setAnItemAsCurrent ||
            setCurrentItemDirective ==
                BlockSetCurrentItemDirective.setAnItemAsCurrentThenLoadForm) {
          candidateCurrItem = candidateCurrItem2;
          currItemWillChanged = candidateCurrItem != null;
        } else if (setCurrentItemDirective ==
                BlockSetCurrentItemDirective.setAnItemAsCurrentIfNeed &&
            (ITEM == ITEM_DETAIL && isInNewQueryList2)) {
          candidateCurrItem = isInNewQueryList2 ? candidateCurrItem2 : null;
          currItemWillChanged = candidateCurrItem != null;
        } else {
          currItemWillChanged = false;
        }
      } else {
        currItemWillChanged = true;
      }
    }
    // currItem != null
    else {
      executionTrace._addTraceStep(
        codeId: "#28460",
        shortDesc:
            "Currently, this block contains <b>$itemCount items</b> and has a <b>currentItem</b> - ${debugObjHtml(currItem)}.",
      );
      if (candidateCurrItem == null) {
        candidateCurrItem = currItem;
        currItemWillChanged = false;
      } else {
        // candidateCurrItem != null && currItem != null
        final ID candidateCurrItemId = __getItemIdShowErr(
          candidateCurrItem,
          showErr: true,
        );
        final ID currItemId = __getItemIdShowErr(
          currItem,
          showErr: true,
        );
        //
        if (candidateCurrItemId == currItemId) {
          currItemWillChanged = false;
        } else {
          currItemWillChanged = true;
        }
      }
    }
    //
    executionTrace._addTraceStep(
      codeId: "#28560",
      shortDesc:
          "Finally, the candidate ITEM is ${debugObjHtml(candidateCurrItem)}. "
          "@currItemWillChanged: ${debugObjHtml(currItemWillChanged)}",
    );
    //
    // If no item can be current.
    //
    if (candidateCurrItem == null) {
      executionTrace._addTraceStep(
        codeId: "#28600",
        shortDesc:
            "No ITEM is determined to be the currentItem of ${debugObjHtml(this)} -> "
            "clear all data of the child blocks and set them to <b>none</b> state."
            "${_childBlocks.isEmpty ? '\n   ** No children -> Nothing to do!' : ''}",
        traceStepType: TraceStepType.info,
      );
      // Test Cases: [74a].
      __clearAllChildrenBlocksToNone(
        thisXBlock: thisXBlock,
      );
      return;
    }
    //
    // Now candidateCurrItem != null.
    //
    final bool isSameCandidateItem = isSame(
      item1: inputCandidateCurrItem,
      item2: candidateCurrItem,
    );
    if (!isSameCandidateItem) {
      blockSetCurrentItemResult._addCandidateItem(candidateCurrItem);
    }
    //
    final bool isCandidateCurrentItemInNewQueriedList =
        FaItemsUtils.isListContainItem(
      targetList: newQueriedList,
      item: candidateCurrItem,
      getItemId: _getItemIdInternal,
    );
    //
    // This block has UI Active (Or child block has UI Active).
    //
    final bool hasBlockXRepresentative =
        ui.hasActiveUiComponentBlockRepresentative(
      alsoCheckChildren: true,
    );
    final bool hasItemXRepresentative =
        ui.hasActiveUiComponentItemRepresentative(
      alsoCheckChildren: true,
    );
    final bool provideFormContext = ui.hasActiveUiComponentFormRepresentative();
    //
    final bool inputForceReloadItem = thisXBlock.forceReloadCurrItem;
    //
    executionTrace._addTraceStep(
      codeId: "#28640",
      shortDesc: "Debug:",
      parameters: {
        "hasBlockXRepresentative": hasBlockXRepresentative,
        "hasItemXRepresentative": hasItemXRepresentative,
        "provideFormContext": provideFormContext,
        "inputForceReloadItem": inputForceReloadItem,
      },
      traceStepType: TraceStepType.debug,
    );
    //
    executionTrace._addLineFlowSeparator();
    //
    executionTrace._addTraceStep(
      codeId: "#28660",
      shortDesc: "Calling <b>_calculateBlockState()</b>:",
      parameters: {
        "inputCandidateCurrItem": inputCandidateCurrItem,
        "inputForceReloadItem": inputForceReloadItem,
        "candidateCurrItem": candidateCurrItem,
        "hasBlockXRepresentative": hasBlockXRepresentative,
        "hasItemXRepresentative": hasItemXRepresentative,
        "provideFormContext": provideFormContext,
        "itemAbsentRepresentativePolicy": config.itemAbsentRepresentativePolicy,
        "unifiedItemRefreshPolicy": config.unifiedItemRefreshPolicy,
        "setCurrentItemDirective": setCurrentItemDirective,
        "isCandidateCurrentItemInNewQueriedList":
            isCandidateCurrentItemInNewQueriedList,
        "currentItemChanged": currItemWillChanged,
      },
      traceStepType: TraceStepType.nonControllableCalling,
    );
    //
    final _ForceReloadItemState blkState = _calculateBlockState(
      executionTrace: executionTrace,
      thisXBlock: thisXBlock,
      inputCandidateCurrItem: inputCandidateCurrItem,
      inputForceReloadItem: inputForceReloadItem,
      candidateCurrItem: candidateCurrItem,
      hasBlockXRepresentative: hasBlockXRepresentative,
      hasItemXRepresentative: hasItemXRepresentative,
      provideFormContext: provideFormContext,
      itemAbsentRepresentativePolicy: config.itemAbsentRepresentativePolicy,
      unifiedItemRefreshPolicy: config.unifiedItemRefreshPolicy,
      setCurrentItemDirective: setCurrentItemDirective,
      isCandidateCurrentItemInNewQueriedList:
          isCandidateCurrentItemInNewQueriedList,
      currentItemIdChanged: currItemWillChanged,
    );
    //
    executionTrace._addLineFlowSeparator();
    //
    final forceReloadItem = blkState.forceReloadItem;
    final forceReloadForm = blkState.forceReloadForm;
    final candidateItemAccepted = blkState.candidateAccepted;

    if (!candidateItemAccepted) {
      executionTrace._addTraceStep(
        codeId: "#28670",
        shortDesc:
            "@candidateItemAccepted: <b>false</b> --> Clean all data of child blocks and set them to none.",
        traceStepType: TraceStepType.info,
      );
      __clearAllChildrenBlocksToNone(
        thisXBlock: thisXBlock,
      );
      return;
    }
    //
    if (thisXBlock.xFormModel != null) {
      if (forceReloadForm) {
        thisXBlock.xFormModel!.setForceType(ForceType.force);
      }
    }
    //
    executionTrace._addTraceStep(
      codeId: "#28700",
      shortDesc: "Calculated:",
      parameters: {
        "forceReloadItem": forceReloadItem,
        "forceReloadForm": forceReloadForm,
      },
      traceStepType: TraceStepType.debug,
    );
    //
    final bool isCandidateIsCurrent = isCurrentItem(candidateCurrItem);
    //
    executionTrace._addTraceStep(
      codeId: "#28720",
      shortDesc: "Calculated:",
      parameters: {
        "ITEM == ITEM_DETAIL?": ITEM == ITEM_DETAIL,
        "candidateCurrItem": candidateCurrItem,
        "isCandidateIsCurrent": isCandidateIsCurrent,
        "isCandidateCurrentItemInNewQueriedList":
            isCandidateCurrentItemInNewQueriedList,
        "itemAbsentRepresentativePolicy": config.itemAbsentRepresentativePolicy,
      },
      traceStepType: TraceStepType.debug,
    );
    //
    final ID itemId = __getItemIdShowErr(
      candidateCurrItem,
      showErr: true,
    );
    ITEM_DETAIL? refreshedCurrentItemDetail = currentItemDetail;

    final bool itemRefreshed;
    if (!forceReloadItem) {
      itemRefreshed = false;
      //
      executionTrace._addTraceStep(
        codeId: "#28800",
        shortDesc:
            "The candidate ${debugObjHtml(candidateCurrItem)} will not need to be reloaded.",
      );
      // Test Cases: [13a], [42a]. (?????)
      final ITEM? candidateCurrItemInNewQueriedList =
          FaItemsUtils.findItemInList(
        item: candidateCurrItem,
        targetList: newQueriedList,
        getItemId: _getItemIdInternal,
      );
      if (ITEM == ITEM_DETAIL && isCandidateCurrentItemInNewQueriedList) {
        //
        // No need to refresh Item.
        //
        refreshedCurrentItemDetail =
            candidateCurrItemInNewQueriedList as ITEM_DETAIL;
      }
    }
    // forceReloadItem
    else {
      itemRefreshed = true;
      String? methodName;
      // Recent Loaded Item:
      _BlockItem2Wrap? loadedCoupleItem =
          thisXBlock._getRecentLoadedItem(itemId: itemId);
      refreshedCurrentItemDetail = loadedCoupleItem?._itemDetail;

      if (refreshedCurrentItemDetail == null) {
        methodName = "performLoadItemDetailById";
        try {
          __refreshRefreshingCurrentItemState(
            isRefreshingCurrentItem: true,
          );
          //
          executionTrace._addTraceStep(
            codeId: "#28900",
            shortDesc:
                "Calling ${debugObjHtml(this)}.$methodName() with parameters:",
            parameters: {
              "itemId": itemId,
            },
            traceStepType: TraceStepType.controllableCalling,
          );
          //
          __performLoadItemDetailByIdCount++;
          ApiResult<ITEM_DETAIL> result = await performLoadItemDetailById(
            itemId: itemId,
          );
          // Throw ApiError:
          result.throwIfError();
          //
          refreshedCurrentItemDetail = result.data;
          thisXBlock.setForceReloadCurrItemDone();
          //
          executionTrace._addTraceStep(
            codeId: "#28920",
            shortDesc:
                "Result --> @refreshedCurrentItemDetail: ${debugObjHtml(refreshedCurrentItemDetail)}.",
          );
        } catch (e, stackTrace) {
          final ErrorInfo errorInfo = _handleError(
            shelf: shelf,
            methodName: methodName,
            error: e,
            stackTrace: stackTrace,
            showSnackBar: true,
            tipDocument: TipDocument.blockPerformLoadItemDetailById,
          );
          //
          blockSetCurrentItemResult._setErrorInfo(
            errorInfo: errorInfo,
          );
          executionTrace._addTraceStep(
            codeId: "#29000",
            shortDesc:
                "The ${debugObjHtml(this)}.$methodName() method was called with an error!",
            errorInfo: errorInfo,
          );
          // TODO: Them test case:
          // TODO: Always return? Load ITEM Error
          return;
        } finally {
          __refreshRefreshingCurrentItemState(
            isRefreshingCurrentItem: false,
          );
        }
      }
    }
    //
    // If candidate not found in database --> remove.
    //
    if (refreshedCurrentItemDetail == null) {
      executionTrace._addTraceStep(
        codeId: "#29040",
        shortDesc:
            "Candidate ${debugObjHtml(candidateCurrItem)} seems to have been deleted from the system "
            "--> remove it from the block..",
      );
      //
      final ITEM? siblingItem = findSiblingItem(
        item: candidateCurrItem,
      );
      // #SAME-CODE-001
      if (!isCandidateIsCurrent) {
        executionTrace._addTraceStep(
          codeId: "#29060",
          shortDesc: "Remove ${debugObjHtml(candidateCurrItem)} from the list.",
        );
        await __removeItemFromList(
          executionTrace: executionTrace,
          removeItem: candidateCurrItem,
        );
        //
        if (currItem != null) {
          // TODO: Test case.
          return;
        }
        //
        if (siblingItem == null) {
          // TODO: Test case.
          return;
        }
        //
        executionTrace._addTraceStep(
          codeId: "#29100",
          shortDesc:
              "Found new candidate ${debugObjHtml(siblingItem)} --> set it as current.",
        );
        //
        thisXBlock.xShelf._addTaskUnit(
          taskUnit: _BlockSetItemAsCurrentTaskUnit(
            setCurrentItemDirective: setCurrentItemDirective,
            xBlock: thisXBlock,
            newQueriedList: newQueriedList,
            candidateItem: siblingItem,
            forceReloadItem: false,
            forceTypeForForm: null,
          ),
        );
        return;
      }
      //
      // Candidate is current but not found in database.
      // Remove Item (Current Item)
      //
      executionTrace._addTraceStep(
        codeId: "#29160",
        shortDesc:
            "Remove current item ${debugObjHtml(candidateCurrItem)} from the ${debugObjHtml(this)}.",
      );
      await __removeItemFromList(
        executionTrace: executionTrace,
        removeItem: candidateCurrItem,
      );
      //
      executionTrace._addTraceStep(
        codeId: "#29180",
        shortDesc: "Set current item to <b>null</b>.",
      );
      // Test Case: [36b] - _testEdit_withoutCoordinator_itemNotFoundON
      __setCurrentItemOnly(
        id: null,
        item: null,
        itemDetail: null,
      );
      if (formModel != null) {
        executionTrace._addTraceStep(
          codeId: "#29200",
          shortDesc:
              "Set ${debugObjHtml(formModel!)} dataState to <b>none</b>.",
        );
        formModel?._clearDataWithDataState(formDataState: DataState.none);
      }
      //
      executionTrace._addTraceStep(
        codeId: "#29220",
        shortDesc: "Clear all data in child blocks and set them to <b>none</b>."
            "${_childBlocks.isEmpty ? '\n   ** No children -> Nothing to do!' : ''}",
      );
      // Test Case: [46a].
      __clearAllChildrenBlocksToNone(thisXBlock: thisXBlock);
      //
      if (siblingItem != null) {
        executionTrace._addTraceStep(
          codeId: "#29240",
          shortDesc:
              "Found new candidate ${debugObjHtml(siblingItem)} --> set it as current.",
        );
        thisXBlock.xShelf._addTaskUnit(
          taskUnit: _BlockSetItemAsCurrentTaskUnit(
            setCurrentItemDirective: setCurrentItemDirective,
            xBlock: thisXBlock,
            newQueriedList: newQueriedList,
            candidateItem: siblingItem,
            forceReloadItem: false,
            forceTypeForForm: null,
          ),
        );
        return;
      }
      return;
    } // End if refreshedCurrentItemDetail == null.
    //
    if (currItemWillChanged || itemRefreshed) {
      executionTrace._addTraceStep(
        codeId: "#29400",
        shortDesc: "Debug",
        parameters: {
          "currItemWillChanged": currItemWillChanged,
          "itemRefreshed": itemRefreshed,
        },
        traceStepType: TraceStepType.debug,
      );
      //
      // NOW: refreshedCurrentItemDetail != null
      //
      final String methodName = "convertItemDetailToItem";
      //
      bool convertError = false;
      try {
        executionTrace._addTraceStep(
          codeId: "#29410",
          shortDesc:
              "Calling ${debugObjHtml(this)}.$methodName() method to convert <b>ITEM_DETAIL</b> to <b>ITEM</b>.\n"
              " ${debugObjHtml(refreshedCurrentItemDetail)} --> ${_debugItemTypeHtml()}.",
          traceStepType: TraceStepType.controllableCalling,
        );
        //
        candidateCurrItem = __convertItemDetailToItem(
          itemDetail: refreshedCurrentItemDetail,
        );
        executionTrace._addTraceStep(
          codeId: "#29420",
          shortDesc: "Got value: ${debugObjHtml(candidateCurrItem)}.",
          traceStepType: TraceStepType.debug,
        );
      } catch (e, stackTrace) {
        convertError = true;
        final ErrorInfo errorInfo = _handleError(
          shelf: shelf,
          methodName: "convertItemDetailToItem",
          error: e,
          stackTrace: stackTrace,
          showSnackBar: true,
          tipDocument: TipDocument.blockConvertItemDetailToItem,
        );
        executionTrace._addTraceStep(
          codeId: "#29440",
          shortDesc:
              "The ${debugObjHtml(this)}.$methodName() method was called with an error!",
          errorInfo: errorInfo,
        );
      }
      if (convertError) {
        blockSetCurrentItemResult._convertError = true;
        // TODO Always return??
        // If currentItemChanged or not currentItemChanged
        // Always return. Nothing to do if has error!!
        return;
      }
      //
      //
      __blockData._selectionDataState = DataState.ready;
      if (candidateCurrItem != null) {
        executionTrace._addTraceStep(
          codeId: "#29480",
          shortDesc: "Calling <b>__blockData._insertOrReplaceItem()</b> method "
              "to insert or replace ${debugObjHtml(candidateCurrItem)} into the list.",
          parameters: {
            "item": candidateCurrItem,
          },
          traceStepType: TraceStepType.nonControllableCalling,
        );
        __blockData._insertOrReplaceItem(item: candidateCurrItem);
      }

      executionTrace._addTraceStep(
        codeId: "#29500",
        shortDesc: "Set ${debugObjHtml(candidateCurrItem)} as current.",
      );
      __setCurrentItemOnly(
        id: itemId,
        item: candidateCurrItem,
        itemDetail: refreshedCurrentItemDetail,
      );
    }
    //
    // FormModel:
    //
    if (thisXBlock.xFormModel != null) {
      if (forceReloadForm) {
        final taskUnit = _FormModelLoadDataTaskUnit(
          xFormModel: thisXBlock.xFormModel!,
        );
        executionTrace._addTraceStep(
          codeId: "#29540",
          shortDesc: "@forceReloadForm: ${debugObjHtml(forceReloadForm)}.\n"
              "Create ${taskUnit.asDebugTaskUnit()} and add to Queue.",
          note:
              "This task unit will load data for ${debugObjHtml(thisXBlock.xFormModel!.formModel)}.",
          traceStepType: TraceStepType.addTaskUnit,
        );
        thisXBlock.xShelf._addTaskUnit(
          taskUnit: taskUnit,
        );
      }
      // !forceReloadForm
      else {
        if (forceReloadItem ||
            currItemWillChanged ||
            isCandidateCurrentItemInNewQueriedList) {
          executionTrace._addTraceStep(
            codeId: "#29560",
            shortDesc:
                "@forceReloadForm: $forceReloadForm, @forceReloadItem: $forceReloadItem, @currItemWillChanged: $currItemWillChanged --> "
                "Set FormModel ${debugObjHtml(thisXBlock.xFormModel!.formModel)} dataState to <b>pending</b>.",
          );
          // TODO: Test Cases.
          formModel!._clearDataWithDataState(formDataState: DataState.pending);
        } else {
          // Do nothing.
        }
      }
    }

    // (On _unitSetItemAsCurrent method).
    // candidateCurrItem != null.
    if (currItemWillChanged) {
      blockSetCurrentItemResult._currentItem = candidateCurrItem;
      //
      executionTrace._addTraceStep(
        codeId: "#29640",
        shortDesc:
            "The <b>currentItem</b> has changed --> clear all data in child blocks and set them to <b>pending</b>."
            "${_childBlocks.isEmpty ? '\n   ** No children -> Nothing to do!' : ''}",
        traceStepType: TraceStepType.info,
      );
      //
      // TODO: Test Cases!
      __clearAllChildrenBlocksToPending(
        thisXBlock: thisXBlock,
      );
    }
    //
    executionTrace._addTraceStep(
      codeId: "#29700",
      shortDesc: "Create ${TaskType.blockQuery.asDebugTaskUnit()}(s) "
          "for all child blocks of ${debugObjHtml(this)} and add to Queue."
          "${_childBlocks.isEmpty ? '\n   ** No children -> Nothing to do!' : ''}",
      traceStepType: TraceStepType.info,
    );
    for (XBlock childXBlock in thisXBlock.childXBlocks) {
      final taskUnit = _BlockQueryTaskUnit(
        xBlock: childXBlock,
      );
      executionTrace._addTraceStep(
        codeId: "#29740",
        shortDesc: "Create ${taskUnit.asDebugTaskUnit()} and add to Queue.",
        traceStepType: TraceStepType.addTaskUnit,
      );
      thisXBlock.xShelf._addTaskUnit(
        taskUnit: taskUnit,
      );
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  @_TaskUnitMethodAnnotation()
  @_BlockDeleteSelectedItemsAnnotation()
  @_BlockDeleteCheckedItemsAnnotation()
  @_BlockDeleteCurrentItemAnnotation()
  @_BlockDeleteItemAnnotation()
  Future<void> _unitDeleteItem({
    required ExecutionTrace executionTrace,
    required TaskType taskType,
    required XBlock<ID, ITEM, ITEM_DETAIL> thisXBlock,
    required ITEM item,
    required BlockItemDeletionResult<ITEM> deletionResult,
  }) async {
    __assertThisXBlock(thisXBlock);
    //
    executionTrace._addTraceStep(
      codeId: "#08000",
      shortDesc:
          "${debugObjHtml(this)} --> Begin ${taskType.asDebugTaskUnit()} for ${debugObjHtml(this)}.",
      traceStepType: TraceStepType.debug,
    );
    //
    final errorIfItemNotInTheBlock = true;
    //
    executionTrace._addTraceStep(
      codeId: "#08020",
      shortDesc: "Calling ${debugObjHtml(this)}.canDeleteItem().",
      parameters: {
        "item": item,
        "errorIfItemNotInTheBlock": errorIfItemNotInTheBlock,
      },
      note: "Call this method to check before deleting an item. "
          "(**) You can override ${debugObjHtml(this)}.isItemDeletionAllowed() method.",
      traceStepType: TraceStepType.nonControllableCalling,
    );
    //
    // No need to check again?
    //
    Actionable<BlockItemDeletionPrecheck> actionable = canDeleteItem(
      item: item,
      errorIfItemNotInTheBlock: errorIfItemNotInTheBlock,
    );
    if (!actionable.yes) {
      executionTrace._addTraceStep(
        codeId: "#08040",
        shortDesc:
            "Can not delete ${debugObjHtml(item)}. Cause: ${actionable.message}.",
      );
      return;
    }
    //
    // Candidate Item to delete.
    //
    deletionResult._setCandidateItem(candidateItem: item);
    //
    final bool isCurrent = isCurrentItem(item);
    //
    executionTrace._addTraceStep(
      codeId: "#08060",
      shortDesc: isCurrent
          ? "You are deleting the current item - ${debugObjHtml(item)}."
          : "You are deleting an item that is not the current item - ${debugObjHtml(item)}.",
      traceStepType: TraceStepType.info,
    );
    //
    final String methodName = "performDeleteItemById";
    ApiResult<void> result;
    try {
      final ID itemId = __getItemIdShowErr(item, showErr: true);
      __refreshDeletingState(isDeleting: true);
      //
      executionTrace._addTraceStep(
        codeId: "#08160",
        shortDesc:
            "Calling ${debugObjHtml(this)}.$methodName() with parameters:",
        parameters: {
          "itemId": itemId,
        },
        traceStepType: TraceStepType.controllableCalling,
      );
      //
      result = await performDeleteItemById(itemId: itemId);
      // Throw ApiError:
      result.throwIfError();
      //
      executionTrace._addTraceStep(
        codeId: "#08180",
        shortDesc:
            "${debugObjHtml(this)} > Fire event after deleting ${_debugItemTypeHtml()}($itemId).",
        traceStepType: TraceStepType.emitEvent,
      );
      //
      // External React:
      //
      __emitEventFromBlockToOtherShelves(
        executionTrace: executionTrace,
        eventType: EventType.deletion,
      );
    } catch (e, stackTrace) {
      final ErrorInfo errorInfo = _handleError(
        shelf: shelf,
        methodName: methodName,
        error: e,
        stackTrace: stackTrace,
        showSnackBar: true,
        tipDocument: TipDocument.blockPerformDeleteItemById,
      );
      //
      deletionResult._setFailedItem(
        failedItem: item,
        errorInfo: errorInfo,
      );
      //
      executionTrace._addTraceStep(
        codeId: "#08200",
        shortDesc:
            "The ${debugObjHtml(this)}.$methodName() method was called with an error!",
        errorInfo: errorInfo,
      );
      //
      return;
    } finally {
      __refreshDeletingState(isDeleting: false);
    }
    //
    // Delete Successful.
    //
    deletionResult._setDeletedItem(deletedItem: item);
    //
    showDeletedSnackBar();
    //
    // #SAME-CODE-001
    if (!isCurrent) {
      executionTrace._addTraceStep(
        codeId: "#08240",
        shortDesc:
            "Remove ${debugObjHtml(item)} from ${debugObjHtml(this)}. (*) This item was not current item.",
      );
      await __removeItemFromList(
        executionTrace: executionTrace,
        removeItem: item,
      );
      return;
    }
    //
    final String? itemContextComponent = ui.findActiveUiComponentByItemContext(
      alsoCheckChildren: true,
    );
    executionTrace._addTraceStep(
      codeId: "#08250",
      shortDesc: "Debug:",
      parameters: {
        "itemContextComponent": itemContextComponent,
      },
      traceStepType: TraceStepType.debug,
      tipDocument: TipDocument.blockActiveUiComponents,
    );
    final ITEM? siblingItem;
    if (itemContextComponent != null) {
      executionTrace._addTraceStep(
        codeId: "#08260",
        shortDesc: "Finding sibling item...",
      );
      //
      // Finding sibling.
      //
      siblingItem = findSiblingItem(item: item);
    } else {
      siblingItem = null;
    }
    executionTrace._addTraceStep(
      codeId: "#08270",
      shortDesc: "Found sibling item:",
      parameters: {
        "siblingItem": siblingItem,
      },
    );
    //
    executionTrace._addTraceStep(
      codeId: "#08280",
      shortDesc:
          "Remove ${debugObjHtml(item)} from ${debugObjHtml(this)}. (*) This item was current item.",
    );
    // Remove Item (Current Item)
    await __removeItemFromList(
      executionTrace: executionTrace,
      removeItem: item,
    );
    //
    executionTrace._addTraceStep(
      codeId: "#08300",
      shortDesc: "${debugObjHtml(this)} --> set current item to <b>null</b>.",
    );
    __blockData._setCurrentItemOnly(
      id: null,
      refreshedItem: null,
      refreshedItemDetail: null,
    );
    //
    if (formModel != null) {
      executionTrace._addTraceStep(
        codeId: "#08320",
        shortDesc:
            "${debugObjHtml(formModel)} --> clear formModel, set dataState to <b>none</b>.",
      );
      // Clear Form:
      formModel!._clearDataWithDataState(
        formDataState: DataState.none,
      );
    }
    // TODO Test Cases.
    executionTrace._addTraceStep(
      codeId: "#08340",
      shortDesc: "Clear data of all child blocks and set them to <b>none</b>."
          "${_childBlocks.isEmpty ? '\n   ** No children -> Nothing to do!' : ''}",
    );
    __clearAllChildrenBlocksToNone(
      thisXBlock: thisXBlock,
    );
    //
    executionTrace._addLineFlowSeparator();
    //
    executionTrace._addTraceStep(
      codeId: "#08400",
      shortDesc: "Deleted Successfully --> Process Internal Reaction.",
    );
    executionTrace._addTraceStep(
      codeId: "#08440",
      shortDesc: "Calling ${debugObjHtml(this)}._processInternalReaction()",
      parameters: {
        "candidateCurrItem": siblingItem,
      },
      traceStepType: TraceStepType.nonControllableCalling,
    );
    // This: _unitDeleteItem() method.
    // SAME-AS: #0013 (Same as _unitDeleteItems() method)
    await _processInternalReaction(
      executionTrace: executionTrace,
      thisXBlock: thisXBlock,
      candidateCurrItem: siblingItem,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  Future<void> _processInternalReaction({
    required ExecutionTrace executionTrace,
    required XBlock<ID, ITEM, ITEM_DETAIL> thisXBlock,
    bool forceReQuery = false,
    required ITEM? candidateCurrItem,
  }) async {
    __assertThisXBlock(thisXBlock);

    // @DEL-01
    thisXBlock.setCandidateCurrItem(candidateCurrItem);
    //
    // Fire Internal Event.
    //
    final setCurrentItemDirective = BlockSetCurrentItemDirective.setAnItemAsCurrentIfNeed;
    thisXBlock.setBlockSetCurrentItemDirective(setCurrentItemDirective);
    //
    final bool hasInternalReaction = _internalEffectedShelfMembers.hasMember();
    //
    // Has Effected Member outside of Lineage (Ancestors + this + Descendants).
    //
    final bool hasEffectedOutsideLineage =
        _internalEffectedShelfMembers._hasEffectedMemberOutsideLineageOfBlock(
      eventBlock: this,
    );
    final _EffBlock? effSelfInfo =
        _internalEffectedShelfMembers._getSelfEffectedBlockInfo(
      forEventBlock: this,
    );
    final _EffBlock? topEffBlockInfo =
        _internalEffectedShelfMembers._getTopEffectedAncestor(
      forEventBlock: this,
    );
    //
    executionTrace._addTraceStep(
      codeId: "#70260",
      shortDesc: "Processing INTERNAL EVENT [$name]...",
      parameters: {
        "hasInternalReaction": hasInternalReaction,
        "hasEffectedOutsideLineage": hasEffectedOutsideLineage,
        "effectedSelfBlock": effSelfInfo,
        "topEffBlockInfo": topEffBlockInfo,
      },
      traceStepType: TraceStepType.debug,
    );
    //
    if (!hasInternalReaction) {
      executionTrace._addTraceStep(
        codeId: "#70300",
        shortDesc: "Calculated:",
        parameters: {
          "hasInternalReaction": hasInternalReaction,
        },
        traceStepType: TraceStepType.debug,
      );
      // forceReQuery (In !hasInternalReaction).
      if (forceReQuery) {
        executionTrace._addTraceStep(
          codeId: "#70320",
          shortDesc: "Creating <b>_BlockQueryTaskUnit</b>.",
          traceStepType: TraceStepType.addTaskUnit,
        );
        // Test Cases: [72a].
        final _STaskUnit taskUnit = _BlockQueryTaskUnit(xBlock: thisXBlock);
        thisXBlock.xShelf._addTaskUnit(taskUnit: taskUnit);
      }
      // !forceReQuery (In !hasInternalReaction).
      else {
        executionTrace._addTraceStep(
          codeId: "#70380",
          shortDesc: "Creating <b>_BlockSetItemAsCurrentTaskUnit</b>.",
          parameters: {
            "setCurrentItemDirective": setCurrentItemDirective,
            "candidateItem": candidateCurrItem,
            "forceReloadItem": false,
            "forceTypeForForm": null,
          },
          traceStepType: TraceStepType.addTaskUnit,
        );
        //
        final _STaskUnit taskUnit =
            thisXBlock.createBlockSetItemAsCurrentTaskUnit(
          setCurrentItemDirective: setCurrentItemDirective,
          newQueriedList: [],
          candidateItem: candidateCurrItem,
          forceReloadItem: false,
          forceTypeForForm: null,
        );
        thisXBlock.xShelf._addTaskUnit(taskUnit: taskUnit);
      }
      return;
    } // End of !hasInternalReaction.
    //
    if (hasInternalReaction) {
      executionTrace._addTraceStep(
        codeId: "#70400",
        shortDesc: "Calling <b>xShelf._updateInternalReactionByEvtBlock()</b>.",
        parameters: {
          "forceReQuery": forceReQuery,
        },
        traceStepType: TraceStepType.nonControllableCalling,
      );
      //
      // Update only (No add to queue).
      //
      thisXBlock.xShelf._updateInternalReactionByEvtBlock(
        executionTrace: executionTrace,
        eventXBlock: thisXBlock,
        forceReQuery: forceReQuery,
      );
      //
      String debugHtmlString = thisXBlock.xShelf.toDebugXShelfStateAsHtml();
      executionTrace._addTraceStep(
        codeId: "#70440",
        shortDesc: debugHtmlString,
        traceStepType: TraceStepType.debug,
      );
    }
    //
    // IMPORTANT: If has effected member Outside Lineage ==> Init Query Tasks for Shelf.
    //
    if (hasEffectedOutsideLineage) {
      executionTrace._addTraceStep(
        codeId: "#70500",
        shortDesc: "Calculated:",
        parameters: {
          "hasEffectedOutsideLineage": hasEffectedOutsideLineage,
        },
        traceStepType: TraceStepType.debug,
      );
      // Test Case: [62a] - __test_event_62a_test_DELETE.
      // Test Case: [62b] - __test_event_62b_test_DELETE.
      // Add Query Tasks to the Queue of XShelf.
      thisXBlock.xShelf._initQueryTaskUnits(executionTrace: executionTrace);
      return;
    }
    //
    // The Internal Event effects to current branch only.
    //
    if (effSelfInfo == null && topEffBlockInfo == null) {
      executionTrace._addTraceStep(
        codeId: "#70600",
        shortDesc: "Calculated:",
        parameters: {
          "hasEffectedOutsideLineage": hasEffectedOutsideLineage, // true
          "effSelfInfo": effSelfInfo, // null
          "topEffBlockInfo": topEffBlockInfo?.getDebugInfo(), // null
        },
        traceStepType: TraceStepType.debug,
      );
      executionTrace._addTraceStep(
        codeId: "#70620",
        shortDesc:
            "Creating <b>_BlockSetItemAsCurrentTaskUnit</b> for <b>${thisXBlock.name}</b>:",
        parameters: {
          "newQueriedList": [],
          "candidateItem": candidateCurrItem,
          "forceReloadItem": false,
          "forceTypeForForm": null,
        },
        traceStepType: TraceStepType.addTaskUnit,
      );
      // Test Case:
      final _STaskUnit taskUnit =
          thisXBlock.createBlockSetItemAsCurrentTaskUnit(
        setCurrentItemDirective: setCurrentItemDirective,
        newQueriedList: [],
        candidateItem: candidateCurrItem,
        forceReloadItem: false,
        forceTypeForForm: null,
      );
      thisXBlock.xShelf._addTaskUnit(taskUnit: taskUnit);
    }
    // topEffBlockInfo is NOT NULL:
    else if (topEffBlockInfo != null) {
      executionTrace._addTraceStep(
        codeId: "#70640",
        shortDesc: "Calculated:",
        parameters: {
          "hasEffectedOutsideLineage": hasEffectedOutsideLineage, // true
          "topEffBlockInfo": topEffBlockInfo.getDebugInfo(), // Not null.
        },
        traceStepType: TraceStepType.debug,
      );
      if (topEffBlockInfo.reQuery) {
        final XBlock topXBlock = topEffBlockInfo.getXBlock(
          xShelf: thisXBlock.xShelf,
        );
        executionTrace._addTraceStep(
          codeId: "#70660",
          shortDesc:
              "Create <b>_BlockQueryTaskUnit</b> for <b>${topXBlock.name}</b>:",
          traceStepType: TraceStepType.addTaskUnit,
        );
        // Note: candidateCurrItem already set. (See @DEL-01)
        final _STaskUnit taskUnit = _BlockQueryTaskUnit(xBlock: topXBlock);
        thisXBlock.xShelf._addTaskUnit(taskUnit: taskUnit);
        // TODO: Test Case?
        if (topEffBlockInfo.refreshCurrItem) {
          //
        }
        return;
      } else if (topEffBlockInfo.refreshCurrItem) {
        executionTrace._addTraceStep(
          codeId: "#70700",
          shortDesc: "Calculated:",
          parameters: {
            "hasEffectedOutsideLineage": hasEffectedOutsideLineage, // true
            "refreshCurrItem": topEffBlockInfo.refreshCurrItem, // true
          },
          traceStepType: TraceStepType.debug,
        );
        final XBlock topXBlock = topEffBlockInfo.getXBlock(
          xShelf: thisXBlock.xShelf,
        );
        //
        executionTrace._addTraceStep(
          codeId: "#70740",
          shortDesc:
              "Create <b>_BlockSetItemAsCurrentTaskUnit</b> for <b>${topXBlock.name}</b>:",
          parameters: {
            "newQueriedList": [],
            "candidateItem": null,
            "setCurrentItemDirective": setCurrentItemDirective,
            "forceReloadItem": true,
            "forceTypeForForm": null,
          },
          traceStepType: TraceStepType.addTaskUnit,
        );
        //
        final _STaskUnit taskUnit =
            topXBlock.createBlockSetItemAsCurrentTaskUnit(
          setCurrentItemDirective: setCurrentItemDirective,
          newQueriedList: [],
          candidateItem: null,
          forceReloadItem: true,
          forceTypeForForm: null,
        );
        thisXBlock.xShelf._addTaskUnit(taskUnit: taskUnit);
        return;
      }
    }
    // effSelfInfo is NOT NULL:
    else if (effSelfInfo != null) {
      executionTrace._addTraceStep(
        codeId: "#70800",
        shortDesc: "Calculated:",
        parameters: {
          "hasEffectedOutsideLineage": hasEffectedOutsideLineage, // true
          "effSelfInfo": effSelfInfo, // Not null
        },
        traceStepType: TraceStepType.debug,
      );
      // Value is Updated:
      QryHint queryHint = thisXBlock.queryHint;
      if (queryHint == QryHint.force) {
        // effSelfInfo.reQuery
        executionTrace._addTraceStep(
          codeId: "#70840",
          shortDesc:
              "Creating <b>_BlockQueryTaskUnit</b> for <b>${thisXBlock.name}</b>.",
          traceStepType: TraceStepType.addTaskUnit,
        );
        // Note: candidateCurrItem already set. (See @DEL-01)
        _STaskUnit taskUnit = _BlockQueryTaskUnit(xBlock: thisXBlock);
        thisXBlock.xShelf._addTaskUnit(taskUnit: taskUnit);
      }
      // effSelfInfo.refreshCurrItem.
      else {
        // Current Item to Reload (INTERNAL EVENT).
        ITEM? currItemInternalEVT = thisXBlock.currItemInternalEVT;
        //
        bool isCurrInternalEV = currItemInternalEVT == null
            ? false // Will be decided laster.
            : isCurrentItem(currItemInternalEVT);
        final bool forceReloadItem = isCurrInternalEV;
        executionTrace._addTraceStep(
          codeId: "#70880",
          shortDesc:
              "Creating <b>_BlockSetItemAsCurrentTaskUnit</b> for <b>${thisXBlock.name}</b>.",
          traceStepType: TraceStepType.addTaskUnit,
        );
        //
        // Select an Item as Current.
        //
        final _STaskUnit taskUnit =
            thisXBlock.createBlockSetItemAsCurrentTaskUnit(
          setCurrentItemDirective: setCurrentItemDirective,
          newQueriedList: [],
          candidateItem: candidateCurrItem,
          forceReloadItem: forceReloadItem,
          forceTypeForForm: null,
        );
        thisXBlock.xShelf._addTaskUnit(taskUnit: taskUnit);
      }
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  @_TaskUnitMethodAnnotation()
  @_BlockDeleteItemsAnnotation()
  Future<void> _unitDeleteItems({
    required ExecutionTrace executionTrace,
    required TaskType taskType,
    required XBlock<ID, ITEM, ITEM_DETAIL> thisXBlock,
    required List<ITEM> items,
    required BlockItemsDeletionResult<ITEM> deletionResult,
    required bool stopIfError,
  }) async {
    __assertThisXBlock(thisXBlock);
    //
    executionTrace._addTraceStep(
      codeId: "#42000",
      shortDesc:
          "Begin ${debugObjHtml(this)} ->  ${taskType.asDebugTaskUnit()}.",
      parameters: {
        "items": items,
        "stopIfError": stopIfError,
      },
      traceStepType: TraceStepType.debug,
    );
    //
    // Precheck: No need to check again!.
    // Candidate Items to delete.
    //
    deletionResult._setCandidateItems(candidateItems: items);
    //
    final ID? currItemId = currentItemId;
    final ITEM? currItem = currentItem;
    ITEM? siblingItem;
    //
    bool currentItemDeleted = false;
    //
    final String methodName = "performDeleteItemById";
    //
    final String? itemContextComponent = ui.findActiveUiComponentByItemContext(
      alsoCheckChildren: true,
    );
    executionTrace._addTraceStep(
      codeId: "#42560",
      shortDesc: "Debug:",
      parameters: {
        "itemContextComponent": itemContextComponent,
      },
      traceStepType: TraceStepType.debug,
      tipDocument: TipDocument.blockActiveUiComponents,
    );
    for (ITEM delItem in [...items]) {
      ApiResult<void> result;
      try {
        // May be throw Error:
        final ID deletingItemId = __getItemIdShowErr(delItem, showErr: true);
        //
        if (itemContextComponent != null) {
          siblingItem = findSiblingItem(item: delItem);
        }
        __refreshDeletingState(isDeleting: true);
        //
        executionTrace._addTraceStep(
          codeId: "#42600",
          shortDesc:
              "Calling ${debugObjHtml(this)}.$methodName() method to delete the ${debugObjHtml(delItem)}.",
          note: currItemId == deletingItemId
              ? null
              : " * (Deleting the current item).",
          parameters: {
            "itemId": deletingItemId,
          },
          traceStepType: TraceStepType.controllableCalling,
        );
        //
        result = await performDeleteItemById(itemId: deletingItemId);
        // Throw ApiError:
        result.throwIfError();
        //
        executionTrace._addTraceStep(
          codeId: "#42660",
          shortDesc:
              "The ${debugObjHtml(delItem)} item has been successful deleted!",
          traceStepType: TraceStepType.info,
        );
        //
        deletionResult._addDeletedItem(deletedItem: delItem);
        //
        executionTrace._addTraceStep(
          codeId: "#42720",
          shortDesc: "Remove ${debugObjHtml(delItem)} from the list.",
          traceStepType: TraceStepType.info,
        );
        //
        // Remove Item from the List.
        //
        await __removeItemFromList(
          executionTrace: executionTrace,
          removeItem: delItem,
        );
        //
        // Current Item DELETED!
        //
        if (deletingItemId == currItemId) {
          executionTrace._addTraceStep(
            codeId: "#42760",
            shortDesc:
                "The current item has been deleted!. Set current item to <b>null</b>.",
            traceStepType: TraceStepType.debug,
          );
          currentItemDeleted = true;
          //
          __blockData._setCurrentItemOnly(
            id: null,
            refreshedItem: null,
            refreshedItemDetail: null,
          );
          //
          if (formModel != null) {
            executionTrace._addTraceStep(
              codeId: "#42780",
              shortDesc:
                  "Clear ${debugObjHtml(formModel)} and set to <b>none</b>.",
              traceStepType: TraceStepType.debug,
            );
            //
            // Clear Form:
            //
            formModel!._clearDataWithDataState(
              formDataState: DataState.none,
            );
          }
          executionTrace._addTraceStep(
            codeId: "#42800",
            shortDesc:
                "Clear all data of child blocks and set them to <b>none</b>."
                "${_childBlocks.isEmpty ? '\n   ** No children -> Nothing to do!' : ''}",
          );
          // TODO: Test cases.
          __clearAllChildrenBlocksToNone(
            thisXBlock: thisXBlock,
          );
        } // End of "Current Item DELETED!".
      } catch (e, stackTrace) {
        final ErrorInfo errorInfo = _handleError(
          shelf: shelf,
          methodName: methodName,
          error: e,
          stackTrace: stackTrace,
          showSnackBar: false,
          tipDocument: TipDocument.blockPerformDeleteItemById,
        );
        //
        deletionResult._addFailedItem(
          failedItem: delItem,
          error: errorInfo,
          stackTrace: stackTrace,
        );
        executionTrace._addTraceStep(
          codeId: "#42840",
          shortDesc: "Error",
          errorInfo: errorInfo,
        );
        //
        if (stopIfError) {
          executionTrace._addTraceStep(
            codeId: "#42860",
            shortDesc:
                "@stopIfError: ${debugObjHtml(stopIfError)} --> Stop deleting!",
            errorInfo: errorInfo,
          );
          break;
        }
      } finally {
        __refreshDeletingState(isDeleting: false);
      }
    }
    //
    // External React:
    //
    if (deletionResult.deletedItems.isNotEmpty) {
      executionTrace._addTraceStep(
        codeId: "#42900",
        shortDesc:
            "${debugObjHtml(this)} > Fire event after deleting. (${deletionResult.deletedItems.length} items deleted!).",
        traceStepType: TraceStepType.emitEvent,
      );
      //
      __emitEventFromBlockToOtherShelves(
        executionTrace: executionTrace,
        eventType: EventType.deletion,
      );
    }
    //
    if (deletionResult.failedItemDeletions.isEmpty) {
      showDeletedSnackBar(
        customMessage: "${deletionResult.deletedItems.length} Item Deleted!",
      );
    } else {
      showMessageSnackBar(
        message: 'Deletion Results',
        details: [
          "${items.length} Items",
          "${deletionResult.deletedItems.length} Deleted",
          "${deletionResult.failedItemDeletions.length} Failed",
        ],
      );
    }
    //
    executionTrace._addLineFlowSeparator();
    //
    executionTrace._addTraceStep(
      codeId: "#42920",
      shortDesc: "After Deleting --> Process Internal Reaction.",
    );
    executionTrace._addTraceStep(
      codeId: "#42940",
      shortDesc: "Calling ${debugObjHtml(this)}._processInternalReaction()",
      parameters: {
        "candidateCurrItem": siblingItem,
      },
      traceStepType: TraceStepType.nonControllableCalling,
    );
    // This: _unitDeleteItems() method.
    // SAME-AS: #0013 (Same as _unitDeleteItem() method)
    // Test Cases: [52a] (Multi Deletions with Internal Event).
    await _processInternalReaction(
      executionTrace: executionTrace,
      thisXBlock: thisXBlock,
      candidateCurrItem: siblingItem,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  @_TaskUnitMethodAnnotation()
  @_BlockPrepareFormToCreateItemAnnotation()
  Future<bool> _unitPrepareFormToCreateItem({
    required ExecutionTrace executionTrace,
    required TaskType taskType,
    required XBlock<ID, ITEM, ITEM_DETAIL> thisXBlock,
    required bool initDirty,
    required FORM_INPUT? formInput,
  }) async {
    __assertThisXBlock(thisXBlock);
    //
    executionTrace._addTraceStep(
      codeId: "#04000",
      shortDesc: "Begin ${taskType.asDebugTaskUnit()}.",
      parameters: {
        "formInput": formInput,
        "initDirty": initDirty,
      },
      traceStepType: TraceStepType.debug,
    );
    //
    executionTrace._addTraceStep(
      codeId: "#04020",
      shortDesc: "${debugObjHtml(this)} set currentItem to null.",
    );
    const ID? nullId = null;
    const ITEM? nullItem = null;
    const ITEM_DETAIL? nullItemDetail = null;
    __setCurrentItemOnly(
      id: nullId,
      item: nullItem,
      itemDetail: nullItemDetail,
    );
    //
    executionTrace._addTraceStep(
      codeId: "#04040",
      shortDesc: "Clear all data of child blocks and set them to <b>none</b>."
          "${_childBlocks.isEmpty ? '\n   ** No children -> Nothing to do!' : ''}",
    );
    __clearAllChildrenBlocksToNone(
      thisXBlock: thisXBlock,
    );
    //
    executionTrace._addTraceStep(
      codeId: "#04060",
      shortDesc: "${debugObjHtml(formModel)} set formMode to creation.",
    );
    formModel!._formPropsStructure._setFormMode_TODO_DELETE(
      formMode: FormMode.creation,
      formDataState: DataState.ready,
    );
    //
    bool success = false;
    try {
      __refreshPreparingFormCreationState(
        isPreparingFormCreation: true,
      );
      // TODO: Test Cases??
      executionTrace._addTraceStep(
        codeId: "#04080",
        shortDesc: "${debugObjHtml(formModel)} set formMode to creation.",
      );
      ADDITIONAL_FORM_RELATED_DATA? additionalFormRelatedData =
          await _performLoadAdditionalFormRelatedData(executionTrace);
      if (additionalFormRelatedData == null) {
        return false;
      }
      //
      final activityType = FormActivityType.startCreatingOrEditing;
      //
      executionTrace._addTraceStep(
        codeId: "#04100",
        shortDesc:
            "Calling ${debugObjHtml(formModel)}._startNewFormActivity() with parameters:",
        parameters: {
          "activityType": activityType,
          "formInput": formInput,
          "additionalFormRelatedData": additionalFormRelatedData,
        },
        traceStepType: TraceStepType.nonControllableCalling,
      );
      success = await formModel!._startNewFormActivity(
        executionTrace: executionTrace,
        additionalFormRelatedData: additionalFormRelatedData,
        formInput: formInput,
        activityType: activityType,
      );
      if (success) {
        executionTrace._addTraceStep(
          codeId: "#04120",
          shortDesc:
              "${debugObjHtml(formModel)} manually set dirty to $initDirty.",
        );
        formModel!._formPropsStructure._setManualDirty(initDirty);
      }
    } finally {
      __refreshPreparingFormCreationState(
        isPreparingFormCreation: false,
      );
    }
    return success;
  }

  // ***************************************************************************
  // ***************************************************************************

  @_TaskUnitMethodAnnotation()
  @_BlockQuickItemCreationActionAnnotation()
  Future<void> _unitQuickCreateItem({
    required ExecutionTrace executionTrace,
    required TaskType taskType,
    required XBlock<ID, ITEM, ITEM_DETAIL> thisXBlock,
    required BlockQuickItemCreationResult taskResult,
    required BlockQuickItemCreationAction<ID, ITEM, ITEM_DETAIL,
            FILTER_CRITERIA>
        action,
  }) async {
    __assertThisXBlock(thisXBlock);
    //
    executionTrace._addTraceStep(
      codeId: "#09000",
      shortDesc: "${debugObjHtml(this)} -> Begin ${taskType.asDebugTaskUnit()}",
      traceStepType: TraceStepType.debug,
    );
    //
    // (No Precheck Again)
    //
    FILTER_CRITERIA blockCurrentFilterCriteria = filterCriteria!;
    //
    ApiResult<ITEM_DETAIL> result;
    final String methodName = "performQuickCreateItem";
    try {
      executionTrace._addTraceStep(
        codeId: "#09100",
        shortDesc: "Calling ${debugObjHtml(action)}.$methodName()",
        traceStepType: TraceStepType.controllableCalling,
      );
      //
      result = await action.performQuickCreateItem(
        parentBlockItem: parent?.currentItem,
        filterCriteria: blockCurrentFilterCriteria,
      );
    } catch (e, stackTrace) {
      // Test Cases: [90b].
      final ErrorInfo errorInfo = _handleError(
        shelf: shelf,
        methodName: '${getClassName(action)}.$methodName',
        error: e,
        stackTrace: stackTrace,
        showSnackBar: true,
        tipDocument:
            TipDocument.blockQuickItemCreationActionPerformQuickCreateItem,
      );
      //
      taskResult._setErrorInfo(
        errorInfo: errorInfo,
      );
      //
      executionTrace._addTraceStep(
        codeId: "#09200",
        shortDesc:
            "The ${debugObjHtml(action)}.$methodName() method was called with an error!",
        errorInfo: errorInfo,
      );
      return;
    }
    //
    try {
      executionTrace._addTraceStep(
        codeId: "#09220",
        shortDesc:
            "Calling ${debugObjHtml(this)}._processSaveActionRestResult().",
        traceStepType: TraceStepType.nonControllableCalling,
      );
      await _processSaveActionRestResult(
        executionTrace: executionTrace,
        thisXBlock: thisXBlock,
        isNew: true,
        callingClassName: getClassNameWithoutGenerics(action),
        calledMethodName: methodName,
        result: result,
      );
      return;
    } catch (e, stackTrace) {
      final ErrorInfo errorInfo = _handleError(
        shelf: shelf,
        methodName: "${getClassName(action)}.$methodName",
        error: e,
        stackTrace: stackTrace,
        showSnackBar: true,
        tipDocument:
            TipDocument.blockQuickItemCreationActionPerformQuickCreateItem,
      );
      //
      taskResult._setErrorInfo(
        errorInfo: errorInfo,
      );
      //
      executionTrace._addTraceStep(
        codeId: "#09260",
        shortDesc:
            "The ${debugObjHtml(this)}._processSaveActionRestResult() method was called with an error!",
        errorInfo: errorInfo,
      );
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  @_TaskUnitMethodAnnotation()
  @_BlockQuickMultiItemCreationActionAnnotation()
  Future<bool> _unitQuickCreateMultiItem({
    required ExecutionTrace executionTrace,
    required TaskType taskType,
    required XBlock<ID, ITEM, ITEM_DETAIL> thisXBlock,
    required BlockQuickMultiItemCreationAction<ID, ITEM, ITEM_DETAIL,
            FILTER_CRITERIA>
        action,
  }) async {
    __assertThisXBlock(thisXBlock);
    //
    executionTrace._addTraceStep(
      codeId: "#44000",
      shortDesc: "${debugObjHtml(this)} -> Begin ${taskType.asDebugTaskUnit()}",
      traceStepType: TraceStepType.debug,
    );
    //
    FILTER_CRITERIA blockCurrentFilterCriteria = filterCriteria!;
    //
    ApiResult<PageData<ITEM>> result;
    try {
      executionTrace._addTraceStep(
        codeId: "#44100",
        shortDesc:
            "Calling ${debugObjHtml(action)}.performQuickCreateMultiItems().",
        parameters: {
          "parentBlockItem": parent?.currentItem,
          "filterCriteria": blockCurrentFilterCriteria,
        },
        traceStepType: TraceStepType.controllableCalling,
      );
      //
      result = await action.performQuickCreateMultiItems(
        parentBlockItem: parent?.currentItem,
        filterCriteria: blockCurrentFilterCriteria,
      );
      //
    } catch (e, stackTrace) {
      final ErrorInfo errorInfo = _handleError(
        shelf: shelf,
        methodName: '${getClassName(action)}.performQuickCreateMultiItems',
        error: e,
        stackTrace: stackTrace,
        showSnackBar: true,
        tipDocument:
            TipDocument.blockQuickMultiItemCreationActionPerformBulkCreateItems,
      );
      executionTrace._addTraceStep(
        codeId: "#44200",
        shortDesc:
            "The ${debugObjHtml(action)}.performQuickCreateMultiItems() method was called with an error!",
        errorInfo: errorInfo,
      );
      //
      return false;
    }
    //
    try {
      executionTrace._addTraceStep(
        codeId: "#44300",
        shortDesc:
            "Calling ${debugObjHtml(this)}._processCreateMultiItemActionResult()..",
        traceStepType: TraceStepType.nonControllableCalling,
      );
      return await _processCreateMultiItemActionResult(
        executionTrace: executionTrace,
        thisXBlock: thisXBlock,
        blockCurrentFilterCriteria: blockCurrentFilterCriteria,
        calledMethodName:
            "${getClassName(action)}.performQuickCreateMultiItems",
        result: result,
      );
    } catch (e, stackTrace) {
      final ErrorInfo errorInfo = _handleError(
        shelf: shelf,
        methodName: "${getClassName(action)}.performQuickCreateMultiItems",
        error: e,
        stackTrace: stackTrace,
        showSnackBar: true,
        tipDocument:
            TipDocument.blockQuickMultiItemCreationActionPerformBulkCreateItems,
      );
      executionTrace._addTraceStep(
        codeId: "#44400",
        shortDesc:
            "The ${debugObjHtml(this)}._processCreateMultiItemActionResult() method was called with an error!",
        errorInfo: errorInfo,
      );
      //
      return false;
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  @_TaskUnitMethodAnnotation()
  @_BlockQuickItemUpdateActionAnnotation()
  Future<void> _unitQuickUpdateItem({
    required ExecutionTrace executionTrace,
    required TaskType taskType,
    required XBlock<ID, ITEM, ITEM_DETAIL> thisXBlock,
    required BlockQuickItemUpdateResult taskResult,
    required BlockQuickItemUpdateAction<ID, ITEM, ITEM_DETAIL, FILTER_CRITERIA>
        action,
  }) async {
    __assertThisXBlock(thisXBlock);
    //
    executionTrace._addTraceStep(
      codeId: "#14000",
      shortDesc: "${debugObjHtml(this)} -> Begin ${taskType.asDebugTaskUnit()}",
      traceStepType: TraceStepType.debug,
    );
    //
    // No Need Precheck Again.
    //
    FILTER_CRITERIA blockCurrentFilterCriteria = filterCriteria!;
    //
    ApiResult<ITEM_DETAIL> result;
    final String methodName = "performQuickUpdateItem";
    try {
      executionTrace._addTraceStep(
        codeId: "#14020",
        shortDesc:
            "Calling ${debugObjHtml(action)}.performQuickUpdateItem()...",
        parameters: {
          "parentBlockItem": parent?.currentItem,
          "filterCriteria": blockCurrentFilterCriteria,
        },
        traceStepType: TraceStepType.controllableCalling,
      );
      //
      result = await action.performQuickUpdateItem(
        parentBlockItem: parent?.currentItem,
        filterCriteria: blockCurrentFilterCriteria,
      );
      //
    } catch (e, stackTrace) {
      // Test Cases: [90b].
      final ErrorInfo errorInfo = _handleError(
        shelf: shelf,
        methodName: '${getClassName(action)}.$methodName',
        error: e,
        stackTrace: stackTrace,
        showSnackBar: true,
        tipDocument:
            TipDocument.blockQuickItemUpdateActionPerformQuickUpdateItem,
      );
      //
      taskResult._setErrorInfo(
        errorInfo: errorInfo,
      );
      //
      executionTrace._addTraceStep(
        codeId: "#14060",
        shortDesc:
            "The ${debugObjHtml(action)}.performQuickUpdateItem() method was called with an error.",
        errorInfo: errorInfo,
      );
      return;
    }
    //
    try {
      executionTrace._addTraceStep(
        codeId: "#14100",
        shortDesc:
            "Calling ${debugObjHtml(this)}._processSaveActionRestResult()...",
        traceStepType: TraceStepType.nonControllableCalling,
      );
      await _processSaveActionRestResult(
        executionTrace: executionTrace,
        thisXBlock: thisXBlock,
        isNew: false,
        callingClassName: getClassNameWithoutGenerics(action),
        calledMethodName: methodName,
        result: result,
      );
      return;
    } catch (e, stackTrace) {
      final errorInfo = _handleError(
        shelf: shelf,
        methodName: "${getClassName(action)}.$methodName",
        error: e,
        stackTrace: stackTrace,
        showSnackBar: true,
        tipDocument:
            TipDocument.blockQuickItemUpdateActionPerformQuickUpdateItem,
      );
      //
      taskResult._setErrorInfo(
        errorInfo: errorInfo,
      );
      //
      executionTrace._addTraceStep(
        codeId: "#14100",
        shortDesc:
            "The ${debugObjHtml(this)}._processSaveActionRestResult() method was called with an error.",
        errorInfo: errorInfo,
      );
      return;
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  @_TaskUnitMethodAnnotation()
  @_BlockBackendActionAnnotation()
  Future<void> _unitBackendAction({
    required ExecutionTrace executionTrace,
    required TaskType taskType,
    required XBlock<ID, ITEM, ITEM_DETAIL> thisXBlock,
    required BlockBackendAction action,
    required BlockBackendActionResult taskResult,
  }) async {
    __assertThisXBlock(thisXBlock);
    //
    executionTrace._addTraceStep(
      codeId: "#45000",
      shortDesc:
          "Begin ${debugObjHtml(this)} ->  ${taskType.asDebugTaskUnit()}.",
      traceStepType: TraceStepType.debug,
    );
    //
    ApiResult<void>? result;
    try {
      executionTrace._addTraceStep(
        codeId: "#45100",
        shortDesc: "Calling ${debugObjHtml(action)}.performBackendOperation().",
        traceStepType: TraceStepType.controllableCalling,
      );
      //
      result = await action.performBackendOperation();
      // Throw ApiError.
      result.throwIfError();
    } catch (e, stackTrace) {
      final ErrorInfo errorInfo = _handleError(
        shelf: shelf,
        methodName: '${getClassName(action)}.performBackendOperation',
        error: e,
        stackTrace: stackTrace,
        showSnackBar: true,
        tipDocument: TipDocument.blockBackendActionPerformAction,
      );
      //
      taskResult._setErrorInfo(
        errorInfo: errorInfo,
      );
      executionTrace._addTraceStep(
        codeId: "#45200",
        shortDesc:
            "The ${debugObjHtml(action)}.performBackendOperation() method was called with an error!",
        errorInfo: errorInfo,
      );
      return;
    }
    //
    executionTrace._addTraceStep(
      codeId: "#45300",
      shortDesc:
          "${debugObjHtml(this)} > Fire event after execute backend action.",
      traceStepType: TraceStepType.emitEvent,
    );
    __emitEventFromBlockToOtherShelves(
      executionTrace: executionTrace,
      eventType: EventType.unknown,
    );
    //
    final ITEM? candidateCurrItem = null;
    executionTrace._addTraceStep(
      codeId: "#45400",
      shortDesc: "Calling ${debugObjHtml(this)}._processInternalReaction()..",
      parameters: {
        "forceReQuery": true,
        "candidateCurrItem": candidateCurrItem,
      },
      traceStepType: TraceStepType.nonControllableCalling,
    );
    //
    // Process Internal Reaction:
    //
    await _processInternalReaction(
      executionTrace: executionTrace,
      thisXBlock: thisXBlock,
      forceReQuery:
          action.config.afterBackendAction == AfterBlockBackendAction.query,
      candidateCurrItem: candidateCurrItem,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  Future<void> _processSaveActionRestResult({
    required ExecutionTrace executionTrace,
    required XBlock<ID, ITEM, ITEM_DETAIL> thisXBlock,
    required bool isNew,
    required String callingClassName,
    required String calledMethodName,
    required ApiResult<ITEM_DETAIL> result,
  }) async {
    if (result.error != null) {
      ErrorInfo errorInfo = _handleRestError(
        shelf: shelf,
        methodName: calledMethodName,
        message: result.error!.errorMessage,
        errorDetails: result.error!.errorDetails,
        showSnackBar: true,
        tipDocument: null,
      );
      executionTrace._addTraceStep(
        codeId: "#16000",
        shortDesc:
            "The <b>$callingClassName.$calledMethodName()</b> method was called with an error.",
        errorInfo: errorInfo,
      );
      return;
    }
    //
    showSavedSnackBar();
    //
    FILTER_CRITERIA? blockCurrentFilterCriteria = filterCriteria;
    if (blockCurrentFilterCriteria == null) {
      executionTrace._addTraceStep(
        codeId: "#16040",
        shortDesc: "Dev Error: TODO: @blockCurrentFilterCriteria is null!!",
      );
      // TODO-Review.
      return;
    }
    bool emitExternalShelfEvent = false;
    final ITEM_DETAIL? savedItemDetail = result.data;
    //
    executionTrace._addTraceStep(
      codeId: "#16100",
      shortDesc: "Got @savedItemDetail: ${debugObjHtml(savedItemDetail)}.",
      traceStepType: TraceStepType.debug,
    );
    //
    final bool keepInList;
    if (savedItemDetail == null) {
      keepInList = false;
      if (isNew) {
        emitExternalShelfEvent = false;
      } else {
        emitExternalShelfEvent = true;
      }
    } else {
      emitExternalShelfEvent = true;
      //
      executionTrace._addTraceStep(
        codeId: "#16140",
        shortDesc:
            "Calling: ${debugObjHtml(this)}.needToKeepItemInList() to decide "
            "whether to keep item ${debugObjHtml(savedItemDetail)} in the list or not..",
        parameters: {
          "parentBlockCurrentItem": parentBlockCurrentItemId,
          "filterCriteria": filterCriteria,
          "itemDetail": savedItemDetail,
        },
        traceStepType: TraceStepType.controllableCalling,
      );
      keepInList = needToKeepItemInList(
        parentBlockCurrentItemId: parentBlockCurrentItemId,
        filterCriteria: blockCurrentFilterCriteria,
        itemDetail: savedItemDetail,
      );
    }
    //
    if (emitExternalShelfEvent) {
      executionTrace._addLineFlowSeparator();
      //
      executionTrace._addTraceStep(
        codeId: "#16200",
        shortDesc:
            "${debugObjHtml(this)} > Save successful --> An event occurred --> checking if it should be emitted.",
        traceStepType: TraceStepType.emitEvent,
      );
      __emitEventFromBlockToOtherShelves(
        executionTrace: executionTrace,
        eventType: isNew ? EventType.creation : EventType.update,
      );
      //
      executionTrace._addLineFlowSeparator();
    } else {}
    ITEM? siblingItem;
    //
    if (savedItemDetail != null && keepInList) {
      executionTrace._addTraceStep(
        codeId: "#16220",
        shortDesc: "Debug:",
        parameters: {
          "savedItemDetail": savedItemDetail,
          "keepInList": keepInList,
        },
        traceStepType: TraceStepType.debug,
      );
      executionTrace._addTraceStep(
        codeId: "#16240",
        shortDesc: "Calling ${debugObjHtml(this)}.convertItemDetailToItem() "
            "to convert ${debugObjHtml(savedItemDetail)} to ${_debugItemTypeHtml()}.",
        traceStepType: TraceStepType.controllableCalling,
      );
      ITEM refreshedItem = __convertItemDetailToItem(
        itemDetail: savedItemDetail,
      );
      executionTrace._addTraceStep(
        codeId: "#16280",
        shortDesc:
            "Insert or replace ${debugObjHtml(refreshedItem)} into the list.",
      );
      __blockData._insertOrReplaceItem(
        item: refreshedItem,
      );
      //
      Actionable<BlockItemEditPrecheck> actionable =
          canEditItemOnForm(item: refreshedItem);
      //
      final ID itemId = __getItemIdShowErr(refreshedItem, showErr: true);
      thisXBlock._addRecentLoadedItem(
        itemId: itemId,
        item: refreshedItem,
        itemDetail: savedItemDetail,
      );
      executionTrace._addTraceStep(
        codeId: "#16320",
        shortDesc: "Set ${debugObjHtml(refreshedItem)} as current.",
      );
      __setCurrentItemOnly(
        id: itemId,
        itemDetail: savedItemDetail,
        item: refreshedItem,
      );
      // Test Case [01c]. New Code:
      // Test Case [02b] - __test_form_cat_product02b_newCat.
      if (isNew) {
        executionTrace._addTraceStep(
          codeId: "#16360",
          shortDesc:
              "Just created an item -> clear data of all child blocks and set them to <b>pending</b>."
              "${_childBlocks.isEmpty ? '\n   ** No children -> Nothing to do!' : ''}",
        );
        __clearAllChildrenBlocksToPending(
          thisXBlock: thisXBlock,
        );
      }
      //
      final newForceType = ForceType.force;
      //
      if (thisXBlock.xFormModel != null) {
        executionTrace._addTraceStep(
          codeId: "#16400",
          shortDesc:
              "${debugObjHtml(formModel)} -> set @forceType to ${debugObjHtml(newForceType)}",
        );
        thisXBlock.xFormModel!.setForceType(newForceType);
      }
    }
    // savedItemDetail = null or !keepInList
    else {
      executionTrace._addTraceStep(
        codeId: "#16500",
        shortDesc: "Debug:",
        parameters: {
          "savedItemDetail": savedItemDetail,
          "keepInList": keepInList,
        },
        traceStepType: TraceStepType.debug,
      );
      ITEM? savedItem;
      if (savedItemDetail != null) {
        executionTrace._addTraceStep(
          codeId: "#16520",
          shortDesc: "Calling ${debugObjHtml(this)}.convertItemDetailToItem() "
              "to convert ${debugObjHtml(savedItemDetail)} to ${_debugItemTypeHtml()}.",
          traceStepType: TraceStepType.controllableCalling,
        );
        savedItem = __convertItemDetailToItem(
          itemDetail: savedItemDetail,
        );
      } else {
        savedItem = null;
      }
      final ITEM? removeItem = savedItem ?? currentItem;
      if (removeItem != null) {
        //
        // removeItem != null
        //
        bool isCurrent = isCurrentItem(removeItem);
        if (!isCurrent) {
          executionTrace._addTraceStep(
            codeId: "#16560",
            shortDesc:
                "${debugObjHtml(this)} --> remove the ${debugObjHtml(removeItem)} from the list. "
                "(*) This item is not current item.",
          );
          await __removeItemFromList(
            executionTrace: executionTrace,
            removeItem: removeItem,
          );
          return;
        }
        //
        executionTrace._addTraceStep(
          codeId: "#16580",
          shortDesc:
              "Calling ${debugObjHtml(this)}.findSiblingItem() to find sibling item of ${debugObjHtml(removeItem)}.",
          parameters: {"item": removeItem},
          traceStepType: TraceStepType.controllableCalling,
        );
        //
        // Deleted current item ==> find sibling.
        //
        siblingItem = findSiblingItem(item: removeItem);
        //
        executionTrace._addTraceStep(
          codeId: "#16600",
          shortDesc:
              "${debugObjHtml(this)} --> remove the current item ${debugObjHtml(removeItem)}.",
        );
        // Remove Item (Current Item)
        await __removeItemFromList(
          executionTrace: executionTrace,
          removeItem: removeItem,
        );
        //
        executionTrace._addTraceStep(
          codeId: "#16620",
          shortDesc: "${debugObjHtml(this)} --> set current item to null.",
        );
        __blockData._setCurrentItemOnly(
          id: null,
          refreshedItem: null,
          refreshedItemDetail: null,
        );
        //
        if (formModel != null) {
          executionTrace._addTraceStep(
            codeId: "#16660",
            shortDesc:
                "${debugObjHtml(formModel)} clear form data and set to <b>none</b>.",
          );
          // Clear Form:
          formModel!._clearDataWithDataState(
            formDataState: DataState.none,
          );
        }
        //
        executionTrace._addTraceStep(
          codeId: "#16700",
          shortDesc:
              "Clear data of all child blocks and set them to <b>none</b>."
              "${_childBlocks.isEmpty ? '\n   ** No children -> Nothing to do!' : ''}",
        );
        // TODO: Test cases.
        __clearAllChildrenBlocksToNone(
          thisXBlock: thisXBlock,
        );
        // TODO-XXX: Add _BlockSetItemAsCurrentTaskUnit?
        //  xxx; Xoa di.
        // _TaskUnit taskUnit = _BlockSetItemAsCurrentTaskUnit<ITEM>(
        //   setCurrentItemDirective:
        //       BlockSetCurrentItemDirective.selectAnItemAsCurrentIfNeed,
        //   xBlock: thisXBlock,
        //   newQueriedList: [],
        //   candidateItem: siblingItem,
        //   forceReloadItem: false,
        //   forceTypeForForm: null,
        // );
        // thisXBlock.xShelf._addTaskUnit(taskUnit: taskUnit);
      }
    }
    //
    // Process Internal Reaction (If Need).
    //
    await _processInternalReaction(
      executionTrace: executionTrace,
      thisXBlock: thisXBlock,
      candidateCurrItem: siblingItem,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  Future<bool> _processCreateMultiItemActionResult({
    required ExecutionTrace executionTrace,
    required XBlock<ID, ITEM, ITEM_DETAIL> thisXBlock,
    required FILTER_CRITERIA blockCurrentFilterCriteria,
    required String calledMethodName,
    required ApiResult<PageData<ITEM>> result,
  }) async {
    if (result.error != null) {
      _handleRestError(
        shelf: shelf,
        methodName: calledMethodName,
        message: result.error!.errorMessage,
        errorDetails: result.error!.errorDetails,
        showSnackBar: true,
        tipDocument: null,
      );
      return false;
    }
    //
    // External React:
    //
    __emitEventFromBlockToOtherShelves(
      executionTrace: executionTrace,
      eventType: EventType.creation,
    );
    //
    final PageData<ITEM>? newItemsPage = result.data;

    final List<ITEM> keepInListItems = [];
    for (ITEM newItem in newItemsPage?.items ?? []) {
      // TODO: Keep in List:
      final bool keepInList = true;
      // needToKeepItemInList(
      //   parentBlockCurrentItem: parent?.currentItem,
      //   filterCriteria: blockCurrentFilterCriteria,
      //   itemDetail: savedItemDetail,
      // );
      if (!keepInList) {
        continue;
      }
      keepInListItems.add(newItem);
      //
      __blockData._insertOrReplaceItem(
        item: newItem,
      );
    }
    //
    // Internal Event:
    //
    await _processInternalReaction(
      executionTrace: executionTrace,
      thisXBlock: thisXBlock,
      candidateCurrItem: null,
    );
    return true;
  }

  // ***************************************************************************
  // ***************************************************************************

  @_RootMethodAnnotation()
  Future<void> showBlockErrorViewerDialog(BuildContext context) async {
    if (dataState == DataState.error) {
      if (_blockErrorInfo != null) {
        await BlockErrorViewerDialog.open(
          context: context,
          blockErrorInfo: _blockErrorInfo!,
        );
      } else if (filterModel != null) {
        if (filterModel!.dataState == DataState.error &&
            filterModel!._errorInfo != null) {
          await ErrorViewerDialog.open(
            context: context,
            errorInfo: filterModel!._errorInfo!,
          );
        }
      }
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  @_RootMethodAnnotation()
  @_BlockClearCurrentItemAnnotation()
  Future<void> clearCurrentItem() async {
    final executionTrace = FlutterArtist.codeFlowLogger._addMethodCall(
      ownerClassInstance: this,
      methodName: "clearCurrentItem",
      parameters: null,
      isLibMethod: true,
    );
    if (currentItem == null) {
      executionTrace._addTraceStep(
        codeId: "#63000",
        shortDesc: "No current item -> do nothing.",
      );
      return;
    }
    //
    executionTrace._addTraceStep(
      codeId: "#63100",
      shortDesc: "Creating <b>$_XShelfBlockClearCurrentItem</b>..",
    );
    final XShelf xShelf = _XShelfBlockClearCurrentItem(block: this);
    //
    final XBlock thisXBlock = xShelf.findXBlockByName(name)!;
    //
    _STaskUnit taskUnit = _BlockClearCurrentTaskUnit(
      xBlock: thisXBlock,
    );
    //
    xShelf._addTaskUnit(taskUnit: taskUnit);
    FlutterArtist._rootQueue._addXRootQueueItem(xRootQueueItem: xShelf);
    await FlutterArtist.executor._executeTaskUnitQueue();
  }

  // ***************************************************************************
  // ***************************************************************************

  @_ReturnTaskResultMethodAnnotation()
  Future<BlockItemDeletionResult<ITEM>> __deleteItem({
    required ExecutionTrace executionTrace,
    required String methodName,
    required ITEM? item,
    required ErrCodeIfItemIsNull errCodeIfItemIsNull,
    bool errorIfItemNotInTheBlock = true,
  }) async {
    final bool checkBusyTrue = true;
    final bool checkAllowTrue = true;
    //
    executionTrace._addTraceStep(
      codeId: "#76000",
      shortDesc:
          "Calling ${debugObjHtml(this)}.__canDeleteItem() to check before execute the action.",
      parameters: {
        "checkBusy": checkBusyTrue,
        "checkBusy": checkBusyTrue,
        "item": item,
        "errCodeIfItemIsNull": errCodeIfItemIsNull,
        "errorIfItemNotInTheBlock": errorIfItemNotInTheBlock,
      },
    );
    // @Same-Code-Precheck-01
    Actionable<BlockItemDeletionPrecheck> actionable = __canDeleteItem(
      checkBusy: checkBusyTrue,
      checkAllow: checkBusyTrue,
      item: item,
      errCodeIfItemIsNull: errCodeIfItemIsNull,
      errorIfItemNotInTheBlock: errorIfItemNotInTheBlock,
    );
    if (!actionable.yes) {
      executionTrace._addTraceStep(
        codeId: "#76040",
        shortDesc: "Got @actionable:",
        actionable: actionable,
        traceStepType: TraceStepType.debug,
      );
      //
      _deletionErrorCount++;
      _addErrorLogActionable(
        shelf: shelf,
        actionableFalse: actionable,
        showErrSnackBar: true,
        tipDocument: null,
      );
      return BlockItemDeletionResult<ITEM>(
        candidateItem: item,
        precheck: actionable.errCode,
        errorInfo: actionable.errorInfo,
      );
    }
    //
    BuildContext context = FlutterArtistCore.context;
    bool confirm = await showConfirmDeleteDialog(
      context: context,
      details: getClassName(item),
    );
    if (!confirm) {
      return BlockItemDeletionResult<ITEM>(
        candidateItem: item,
        precheck: BlockItemDeletionPrecheck.cancelled,
      );
    }
    //
    final XShelf xShelf = _XShelfBlockItemDeletion(block: this);
    //
    final XBlock thisXBlock = xShelf.findXBlockByName(name)!;
    //
    final taskResult = _createEmptyItemDeletionResult();
    //
    executionTrace._addTraceStep(
      codeId: "#76340",
      shortDesc: "Creating <b>_BlockItemDeletionTaskUnit</b>.",
      traceStepType: TraceStepType.addTaskUnit,
    );
    final _ResultedSTaskUnit taskUnit = _BlockItemDeletionTaskUnit(
      xBlock: thisXBlock,
      item: item!,
      taskResult: taskResult,
    );
    //
    xShelf._addTaskUnit(taskUnit: taskUnit);
    FlutterArtist._rootQueue._addXRootQueueItem(xRootQueueItem: xShelf);
    await FlutterArtist.executor._executeTaskUnitQueue();
    //
    return taskResult;
  }

  // ***************************************************************************
  // ***************************************************************************

  @_ReturnTaskResultMethodAnnotation()
  Future<BlockItemsDeletionResult<ITEM>> __deleteItems({
    required ExecutionTrace executionTrace,
    required String methodName,
    required List<ITEM> items,
    required bool stopIfError,
    bool errorIfItemNotInTheBlock = true,
  }) async {
    final List<ITEM> candidateDeleteItems =
        __blockData.moveCurrentItemToEndOfList(
      itemList: items,
    );
    executionTrace._addTraceStep(
      codeId: "#65000",
      shortDesc: "Check before deletion..",
    );
    // @Same-Code-Precheck-01
    Actionable<BlockItemsDeletionPrecheck> actionable = __canDeleteItems(
      checkBusy: true,
      checkAllow: true,
      errorIfItemNotInTheBlock: errorIfItemNotInTheBlock,
      items: candidateDeleteItems,
    );
    if (!actionable.yes) {
      _deletionErrorCount++;
      final ErrorInfo? errorInfo = _addErrorLogActionable(
        shelf: shelf,
        actionableFalse: actionable,
        showErrSnackBar: true,
        tipDocument: null,
      );
      executionTrace._addTraceStep(
        codeId: "#65100",
        shortDesc: "@actionable = ${debugObjHtml(actionable)}.",
        errorInfo: errorInfo,
      );
      return BlockItemsDeletionResult<ITEM>(
        candidateItems: candidateDeleteItems,
        precheck: actionable.errCode,
        errorInfo: actionable.errorInfo,
      );
    }
    //
    BuildContext context = FlutterArtistCore.context;
    bool confirm = await showConfirmDeleteDialog(
      context: context,
      details: "Delete Multi Items",
    );
    if (!confirm) {
      executionTrace._addTraceStep(
        codeId: "#65200",
        shortDesc: "@confirm = <b>false</b> --> Cancelled!",
      );
      return BlockItemsDeletionResult<ITEM>(
        candidateItems: candidateDeleteItems,
        precheck: BlockItemsDeletionPrecheck.cancelled,
      );
    }
    //
    executionTrace._addTraceStep(
      codeId: "#65300",
      shortDesc: "Creating <b>$_XShelfBlockMultiItemDeletion</b>..",
    );
    final XShelf xShelf = _XShelfBlockMultiItemDeletion(block: this);
    //
    final XBlock thisXBlock = xShelf.findXBlockByName(name)!;
    //
    final taskResult = _createEmptyItemsDeletionResult(
      candidateItems: candidateDeleteItems,
    );
    final _ResultedSTaskUnit taskUnit = _BlockMultiItemDeletionTaskUnit(
      xBlock: thisXBlock,
      items: candidateDeleteItems,
      stopIfError: stopIfError,
      taskResult: taskResult,
    );
    //
    xShelf._addTaskUnit(taskUnit: taskUnit);
    FlutterArtist._rootQueue._addXRootQueueItem(xRootQueueItem: xShelf);
    await FlutterArtist.executor._executeTaskUnitQueue();
    //
    return taskResult;
  }

  // ***************************************************************************
  // ***************************************************************************

  @_BlockSetItemAsCurrentAnnotation()
  @_ReturnTaskResultMethodAnnotation()
  Future<BlockSetCurrentItemResult<ITEM>> __refreshItemAndSetAsCurrent({
    required ExecutionTrace executionTrace,
    required String methodName,
    required ITEM? item,
    required ErrCodeIfItemIsNull errCodeIfItemIsNull,
    required bool forceLoadItem,
    required bool forceLoadForm,
  }) async {
    final setCurrentItemDirective = forceLoadForm
        ? BlockSetCurrentItemDirective.setAnItemAsCurrentThenLoadForm
        : BlockSetCurrentItemDirective.setAnItemAsCurrent;
    //
    executionTrace._addTraceStep(
      codeId: "#69000",
      shortDesc:
          "Calculated > @setCurrentItemDirective: ${debugObjHtml(setCurrentItemDirective)}",
      traceStepType: TraceStepType.debug,
    );
    executionTrace._addTraceStep(
      codeId: "#69100",
      shortDesc: "Calling ${debugObjHtml(this)}.__canSetItemAsCurrent()...",
      parameters: {
        "item": item,
        "errCodeIfItemIsNull": errCodeIfItemIsNull,
        "checkBusy": true,
      },
      traceStepType: TraceStepType.nonControllableCalling,
    );
    //
    // @Same-Code-Precheck-01
    //
    Actionable<BlockSetCurrentItemPrecheck> actionable = __canSetItemAsCurrent(
      item: item,
      errCodeIfItemIsNull: errCodeIfItemIsNull,
      checkBusy: true,
    );
    //
    if (!actionable.yes) {
      // _refreshErrorCount++
      final ErrorInfo? errorInfo = _addErrorLogActionable(
        shelf: shelf,
        actionableFalse: actionable,
        showErrSnackBar: true,
        tipDocument: null,
      );
      executionTrace._addTraceStep(
        codeId: "#69200",
        shortDesc: "Has error:",
        errorInfo: errorInfo,
      );
      //
      return BlockSetCurrentItemResult<ITEM>(
        precheck: actionable.errCode,
        setCurrentItemDirective: setCurrentItemDirective,
        getItemId: _getItemIdInternal,
        candidateItem: item,
        oldCurrentItem: currentItem,
        currentItem: currentItem,
      );
    }
    //
    executionTrace._addTraceStep(
      codeId: "#69300",
      shortDesc: "Creating <b>_XShelfBlockSetItemAsCurrent</b>...",
    );
    final XShelf xShelf = _XShelfBlockSetItemAsCurrent(block: this);
    //
    final XBlock thisXBlock = xShelf.findXBlockByName(name)!;
    //
    final taskUnit = _BlockSetItemAsCurrentTaskUnit<ID, ITEM>(
      setCurrentItemDirective: setCurrentItemDirective,
      xBlock: thisXBlock,
      newQueriedList: [],
      candidateItem: item,
      forceReloadItem: forceLoadItem,
      forceTypeForForm: forceLoadForm //
          ? ForceType.force
          : ForceType.decidedAtRuntime,
    );
    xShelf._addTaskUnit(taskUnit: taskUnit);
    FlutterArtist._rootQueue._addXRootQueueItem(xRootQueueItem: xShelf);
    await FlutterArtist.executor._executeTaskUnitQueue();
    //
    var result = taskUnit.taskResult as BlockSetCurrentItemResult<ITEM>;
    return result;
  }

  // ***************************************************************************
  // ***************************************************************************

  @_RootMethodAnnotation()
  @_ReturnTaskResultMethodAnnotation()
  @_BlockSetItemAsCurrentAnnotation()
  Future<BlockSetCurrentItemResult<ITEM>> refreshItemAndSetAsCurrent({
    required ITEM item,
    bool forceLoadForm = false,
  }) async {
    final executionTrace = FlutterArtist.codeFlowLogger._addMethodCall(
      ownerClassInstance: this,
      methodName: "refreshItemAndSetAsCurrent",
      parameters: {
        "item": item,
        "forceLoadForm": forceLoadForm,
      },
      isLibMethod: true,
    );
    return await __refreshItemAndSetAsCurrent(
      executionTrace: executionTrace,
      methodName: "refreshItemAndSetAsCurrent",
      item: item,
      errCodeIfItemIsNull: ErrCodeIfItemIsNull.invalidTarget,
      forceLoadItem: true,
      forceLoadForm: forceLoadForm,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  ///
  /// Clear and set block to "Pending State".
  ///
  @_RootMethodAnnotation()
  @_ReturnTaskResultMethodAnnotation()
  @_BlockClearAnnotation()
  Future<BlockClearResult> clear() async {
    final executionTrace = FlutterArtist.codeFlowLogger._addMethodCall(
      ownerClassInstance: this,
      methodName: "clear",
      parameters: {},
      isLibMethod: true,
    );
    executionTrace._addTraceStep(
      codeId: "#62000",
      shortDesc: "Check before clear the ${debugObjHtml(this)}...",
    );
    // @Same-Code-Precheck-01
    Actionable<BlockClearPrecheck> actionable = __canClearBlock(
      checkBusy: true,
    );
    //
    if (!actionable.yes) {
      // _createItemErrorCount++;
      final ErrorInfo? errorInfo = _addErrorLogActionable(
        shelf: shelf,
        actionableFalse: actionable,
        showErrSnackBar: true,
        tipDocument: null,
      );
      executionTrace._addTraceStep(
        codeId: "#62100",
        shortDesc: "@actionable --> ${debugObjHtml(actionable)}.",
        errorInfo: errorInfo,
      );
      return BlockClearResult(
        precheck: actionable.errCode,
      );
    }
    //
    executionTrace._addTraceStep(
      codeId: "#62200",
      shortDesc: "Creating <b>$_XShelfBlockClear</b>.",
    );
    final XShelf xShelf = _XShelfBlockClear(block: this);

    final XBlock thisXBlock = xShelf.findXBlockByName(name)!;
    final _ResultedSTaskUnit taskUnit = _BlockClearTaskUnit(
      xBlock: thisXBlock,
    );
    //
    xShelf._addTaskUnit(taskUnit: taskUnit);
    FlutterArtist._rootQueue._addXRootQueueItem(xRootQueueItem: xShelf);
    await FlutterArtist.executor._executeTaskUnitQueue();
    //
    return taskUnit.taskResult;
  }

  // ***************************************************************************
  // ***************************************************************************

  ///
  /// Query the next page and replace the current items in the list.
  ///
  @_RootMethodAnnotation()
  @_BlockQueryNextPageAnnotation()
  @_ReturnTaskResultMethodAnnotation()
  Future<BlockQueryResult> queryNextPage({
    BlockAfterQueryDirective afterQueryDirective =
        BlockAfterQueryDirective.setAnItemAsCurrentIfNeed,
  }) async {
    if (filterModel != null && filterModel!.lockAddMoreQuery) {
      return BlockQueryResult._queryBlockedTemporarily();
    }
    //
    var qryMethod = BlockQryMethodName.queryNextPage;
    //
    final executionTrace = FlutterArtist.codeFlowLogger._addMethodCall(
      ownerClassInstance: this,
      methodName: "queryNextPage",
      parameters: {
        "afterQueryDirective": afterQueryDirective,
      },
      isLibMethod: true,
    );
    //
    return await __queryBlock(
      executionTrace: executionTrace,
      qryMethod: qryMethod,
      suggestedListUpdateStrategy: ListUpdateStrategy.replace,
      filterInput: null,
      afterQueryDirective: afterQueryDirective,
      suggestedSelection: null,
      specifiedPageable: null,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  ///
  /// Query the previous page and replace the current items in the list.
  ///
  @_RootMethodAnnotation()
  @_ReturnTaskResultMethodAnnotation()
  @_BlockQueryPreviousPageAnnotation()
  Future<BlockQueryResult> queryPreviousPage({
    BlockAfterQueryDirective afterQueryDirective =
        BlockAfterQueryDirective.setAnItemAsCurrentIfNeed,
  }) async {
    if (filterModel != null && filterModel!.lockAddMoreQuery) {
      return BlockQueryResult._queryBlockedTemporarily();
    }
    //
    final qryMethod = BlockQryMethodName.queryPreviousPage;
    //
    final executionTrace = FlutterArtist.codeFlowLogger._addMethodCall(
      ownerClassInstance: this,
      methodName: "queryPreviousPage",
      parameters: {
        "afterQueryDirective": afterQueryDirective,
      },
      isLibMethod: true,
    );
    //
    return await __queryBlock(
      executionTrace: executionTrace,
      qryMethod: qryMethod,
      suggestedListUpdateStrategy: ListUpdateStrategy.replace,
      filterInput: null,
      afterQueryDirective: afterQueryDirective,
      suggestedSelection: null,
      specifiedPageable: null,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  ///
  /// Query the next page and append to the current list of items.
  ///
  @_RootMethodAnnotation()
  @_BlockQueryMorePageAnnotation()
  @_ReturnTaskResultMethodAnnotation()
  Future<BlockQueryResult> queryMore({
    BlockAfterQueryDirective afterQueryDirective =
        BlockAfterQueryDirective.setAnItemAsCurrentIfNeed,
  }) async {
    if (filterModel != null && filterModel!.lockAddMoreQuery) {
      return BlockQueryResult._queryBlockedTemporarily();
    }
    //
    final qryMethod = BlockQryMethodName.queryMore;
    //
    final executionTrace = FlutterArtist.codeFlowLogger._addMethodCall(
      ownerClassInstance: this,
      methodName: "queryMore",
      parameters: {
        "afterQueryDirective": afterQueryDirective,
      },
      isLibMethod: true,
    );
    //
    return await __queryBlock(
      executionTrace: executionTrace,
      qryMethod: qryMethod,
      suggestedListUpdateStrategy: ListUpdateStrategy.merge,
      afterQueryDirective: afterQueryDirective,
      filterInput: null,
      suggestedSelection: null,
      specifiedPageable: null,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  @_RootMethodAnnotation()
  @_ReturnTaskResultMethodAnnotation()
  Future<bool> queryEmptyAndPrepareToCreate({
    FILTER_INPUT? filterInput,
  }) async {
    if (filterModel != null && filterModel!.lockAddMoreQuery) {
      return false;
    }
    //
    final executionTrace = FlutterArtist.codeFlowLogger._addMethodCall(
      ownerClassInstance: this,
      methodName: "queryEmptyAndPrepareToCreate",
      parameters: {
        "filterInput": filterInput,
      },
      isLibMethod: true,
    );
    //
    return await __queryEmpty(
      executionTrace: executionTrace,
      filterInput: filterInput,
      prepareFormToCreateItem: true,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  @_RootMethodAnnotation()
  @_ReturnTaskResultMethodAnnotation()
  Future<bool> queryEmpty({
    FILTER_INPUT? filterInput,
    bool prepareFormToCreateItem = false,
  }) async {
    if (filterModel != null && filterModel!.lockAddMoreQuery) {
      return false;
    }
    //
    final executionTrace = FlutterArtist.codeFlowLogger._addMethodCall(
      ownerClassInstance: this,
      methodName: "queryEmpty",
      parameters: {
        "filterInput": filterInput,
        "prepareFormToCreateItem": prepareFormToCreateItem,
      },
      isLibMethod: true,
    );
    //
    return await __queryEmpty(
      executionTrace: executionTrace,
      filterInput: filterInput,
      prepareFormToCreateItem: prepareFormToCreateItem,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  ///
  ///
  /// Docs: [14739], [14811*].
  ///
  @nonVirtual
  @_RootMethodAnnotation()
  @_BlockQueryAnnotation()
  @_ReturnTaskResultMethodAnnotation()
  Future<BlockQueryResult> query({
    ListUpdateStrategy suggestedListUpdateStrategy = ListUpdateStrategy.replace,
    BlockAfterQueryDirective afterQueryDirective =
        BlockAfterQueryDirective.setAnItemAsCurrentIfNeed,
    FILTER_INPUT? filterInput,
    SuggestedSelection? suggestedSelection,
    Pageable? pageable,
  }) async {
    if (filterModel != null && filterModel!.lockAddMoreQuery) {
      return BlockQueryResult._queryBlockedTemporarily();
    }
    //
    final qryMethod = BlockQryMethodName.query;
    //
    final executionTrace = FlutterArtist.codeFlowLogger._addMethodCall(
      ownerClassInstance: this,
      methodName: "query",
      parameters: {
        "afterQueryDirective": afterQueryDirective,
        "suggestedListUpdateStrategy": suggestedListUpdateStrategy,
        "filterInput": filterInput,
        "suggestedSelection": suggestedSelection,
        "pageable": pageable,
      },
      isLibMethod: true,
    );
    //
    return await __queryBlock(
      executionTrace: executionTrace,
      qryMethod: qryMethod,
      suggestedListUpdateStrategy: suggestedListUpdateStrategy,
      afterQueryDirective: afterQueryDirective,
      filterInput: filterInput,
      suggestedSelection: suggestedSelection,
      specifiedPageable: pageable,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  ///
  ///
  ///
  @nonVirtual
  @_RootMethodAnnotation()
  @_ReturnTaskResultMethodAnnotation()
  @_ReturnTaskResultMethodAnnotation()
  @_BlockQueryAndPrepareToEditAnnotation()
  Future<BlockQueryResult> queryAndPrepareToEdit({
    FILTER_INPUT? filterInput,
    ListUpdateStrategy suggestedListUpdateStrategy = ListUpdateStrategy.replace,
    SuggestedSelection<ID>? suggestedSelection,
    Pageable? pageable,
  }) async {
    final executionTrace = FlutterArtist.codeFlowLogger._addMethodCall(
      ownerClassInstance: this,
      methodName: "queryAndPrepareToEdit",
      parameters: {
        "filterInput": filterInput,
        "suggestedListUpdateStrategy": suggestedListUpdateStrategy,
        "suggestedSelection": suggestedSelection,
        "pageable": pageable,
      },
      isLibMethod: true,
    );
    //
    final XShelf xShelf = _XShelfBlockQueryThenPrepareToEdit(
      block: this,
      filterInput: filterInput,
      pageable: null,
      suggestedListUpdateStrategy: suggestedListUpdateStrategy,
      afterQueryDirective: BlockAfterQueryDirective.setAnItemAsCurrentThenLoadForm,
      suggestedSelection: suggestedSelection,
    );
    //
    xShelf._initQueryTaskUnits(executionTrace: executionTrace);
    FlutterArtist._rootQueue._addXRootQueueItem(xRootQueueItem: xShelf);
    await FlutterArtist.executor._executeTaskUnitQueue();
    //
    XBlock xBlock = xShelf.findXBlockByName(name)!;
    BlockQueryResult queryResult = xBlock.queryResult;
    return queryResult;
  }

  // ***************************************************************************
  // ***************************************************************************

  ///
  /// Clear and prepare Form to create new record.
  /// If this block has a FormModel its data state set to "Ready", else its data state set to "Pending".
  ///
  @_RootMethodAnnotation()
  @_ReturnTaskResultMethodAnnotation()
  @_BlockQueryAndPrepareToCreateAnnotation()
  Future<BlockQueryResult> queryAndPrepareToCreate({
    FILTER_INPUT? filterInput,
  }) async {
    final executionTrace = FlutterArtist.codeFlowLogger._addMethodCall(
      ownerClassInstance: this,
      methodName: "queryAndPrepareToCreate",
      parameters: {
        "filterInput": filterInput,
      },
      isLibMethod: true,
    );
    executionTrace._addTraceStep(
      codeId: "#56000",
      shortDesc: "Creating <b>$_XShelfBlockQueryThenPrepareToCreate</b>..",
    );
    //
    final XShelf xShelf = _XShelfBlockQueryThenPrepareToCreate(
      block: this,
      filterInput: filterInput,
      pageable: null,
      listUpdateStrategy: ListUpdateStrategy.replace,
      afterQueryDirective: BlockAfterQueryDirective.createNewItem,
      suggestedSelection: null,
    );
    //
    executionTrace._addTraceStep(
      codeId: "#57000",
      shortDesc: "Calling ${debugObjHtml(xShelf)}._initQueryTaskUnits()...",
      traceStepType: TraceStepType.nonControllableCalling,
    );
    xShelf._initQueryTaskUnits(executionTrace: executionTrace);
    //
    FlutterArtist._rootQueue._addXRootQueueItem(xRootQueueItem: xShelf);
    await FlutterArtist.executor._executeTaskUnitQueue();
    //
    XBlock xBlock = xShelf.findXBlockByName(name)!;
    BlockQueryResult queryResult = xBlock.queryResult;
    return queryResult;
  }

  // ***************************************************************************
  // ***************************************************************************
  // ***************************************************************************

  ID __getItemIdShowErr(ITEM item, {required bool showErr}) {
    try {
      ID id = _getItemIdInternal(item);
      return id;
    } catch (e, stackTrace) {
      if (showErr) {
        _handleError(
          shelf: shelf,
          methodName: "performLoadItemDetailById",
          error: e,
          stackTrace: stackTrace,
          showSnackBar: true,
          tipDocument: null,
        );
      }
      rethrow;
    }
  }

  // ***************************************************************************
  // ***************************************************************************
  // ***************************************************************************

  ID _getItemIdInternal(ITEM item) {
    return item.id;
  }

  // ***************************************************************************
  // ***************************************************************************

  @_AbstractMethodAnnotation()
  Future<ApiResult<void>> performDeleteItemById({
    required ID itemId,
  });

  // ***************************************************************************
  // ***************************************************************************

  @_AbstractMethodAnnotation()
  Future<ApiResult<ITEM_DETAIL>> performLoadItemDetailById({
    required ID itemId,
  });

  // ***************************************************************************
  // ***************************************************************************

  @_AbstractMethodAnnotation()
  ITEM convertItemDetailToItem({required ITEM_DETAIL itemDetail});

  // ***************************************************************************
  // ***************************************************************************

  ///
  /// This method is called before calling a Form to create.
  ///
  @_AbstractMethodAnnotation()
  FORM_INPUT buildInputForCreationForm({
    required Object? parentBlockCurrentItem,
    required FILTER_CRITERIA filterCriteria,
  });

  // ***************************************************************************
  // ***************************************************************************

  @_AbstractMethodAnnotation()
  Future<ADDITIONAL_FORM_RELATED_DATA> performLoadAdditionalFormRelatedData({
    required Object? parentBlockCurrentItem,
    required ITEM_DETAIL? currentItemDetail,
    required FILTER_CRITERIA filterCriteria,
  });

  // ***************************************************************************
  // ***************************************************************************

  FORM_INPUT __buildInputForCreationForm(ExecutionTrace executionTrace) {
    final Object? parentBlockCurrentItem = parent?.currentItem;
    final FILTER_CRITERIA? currentFilterCriteria = filterCriteria;

    if (currentFilterCriteria == null) {
      // Test Case: [01c]
      // Make sure never get this error.
      throw AppError(errorMessage: "FilterCriteria is null");
    }
    executionTrace._addTraceStep(
      codeId: "#05100",
      shortDesc: "Calling ${debugObjHtml(this)}.buildInputForCreationForm().",
      parameters: {
        "parentBlockCurrentItem": parentBlockCurrentItem,
        "filterCriteria": currentFilterCriteria,
      },
      traceStepType: TraceStepType.controllableCalling,
    );
    return buildInputForCreationForm(
      parentBlockCurrentItem: parentBlockCurrentItem,
      filterCriteria: currentFilterCriteria,
    );
  }

  Future<ADDITIONAL_FORM_RELATED_DATA?> _performLoadAdditionalFormRelatedData(
    ExecutionTrace executionTrace,
  ) async {
    try {
      final Object? parentBlockCurrentItem = parent?.currentItem;
      final FILTER_CRITERIA? currentFilterCriteria = filterCriteria;

      if (currentFilterCriteria == null) {
        // TODO: Test Cases.
        // Make sure never get this error.
        throw AppError(errorMessage: "FilterCriteria is null");
      }
      executionTrace._addTraceStep(
        codeId: "#05000",
        shortDesc:
            "Calling ${debugObjHtml(this)}.performLoadAdditionalFormRelatedData()...",
        parameters: {
          "parentBlockCurrentItem": parentBlockCurrentItem,
          "currentItemDetail": currentItemDetail,
          "filterCriteria": filterCriteria,
        },
        traceStepType: TraceStepType.controllableCalling,
      );
      return await performLoadAdditionalFormRelatedData(
        parentBlockCurrentItem: parentBlockCurrentItem,
        currentItemDetail: currentItemDetail,
        filterCriteria: currentFilterCriteria,
      );
    } catch (e, stackTrace) {
      final ErrorInfo errorInfo = _handleError(
        shelf: shelf,
        methodName: "performLoadAdditionalFormRelatedData",
        error: e,
        stackTrace: stackTrace,
        showSnackBar: true,
        tipDocument: TipDocument.blockInitFormRelatedData,
      );
      executionTrace._addTraceStep(
        codeId: "#05020",
        shortDesc:
            "The ${debugObjHtml(this)}.performLoadAdditionalFormRelatedData() method was called with an error!",
        errorInfo: errorInfo,
      );
      return null;
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  // TODO: Rename to shouldRetainItem.
  @_AbstractMethodAnnotation()
  bool needToKeepItemInList({
    required Object? parentBlockCurrentItemId,
    required FILTER_CRITERIA filterCriteria,
    required ITEM_DETAIL itemDetail,
  });

  // ***************************************************************************
  // ***************************************************************************

  ///
  /// This method is called for each ITEM in the list you just queried
  /// to ensure that it actually matches the current item of the parent Block.
  /// If it doesn't match, it will be removed from this Block's list.
  ///
  /// If you don't care about this method, you can simply set BlockConfig.enforceParentLinkConstraint = true.
  ///
  @_AbstractMethodAnnotation()
  Object resolveParentBlockItemId({required ITEM item}) {
    throw UnimplementedError(
        'The resolveParentBlockItemId() method must be implemented when config.enforceParentLinkConstraint is true '
        'to determine the parent reference of each item.');
  }

  // ***************************************************************************
  // ***************************************************************************

  @_AbstractMethodAnnotation()
  int? specifyItemIndexToSetAsCurrent() {
    return null;
  }

  // ***************************************************************************
  // ************* API METHOD **************************************************
  // ***************************************************************************

  @_AbstractMethodAnnotation()
  Future<ApiResult<PageData<ITEM>?>> performQuery({
    required Object? parentBlockCurrentItem,
    required FILTER_CRITERIA filterCriteria,
    required SortableCriteria sortableCriteria,
    required Pageable pageable,
  });

  // ***************************************************************************
  // ***************************************************************************

  @_OverridableMethodAnnotation()
  void setChildrenForParent({
    required Object currentItemOfParentBlock,
    required List<ITEM> items,
  }) {
    // Override if need.
  }

  // ***************************************************************************
  // ***************************************************************************

  void __clearBlockError() {
    _blockErrorInfo = null;
  }

  void __setBlockErrorInfo(BlockErrorInfo errorInfo) {
    _blockErrorInfo = errorInfo;
  }

  // ***************************************************************************
  // ***************************************************************************

  ITEM __convertItemDetailToItem({required ITEM_DETAIL itemDetail}) {
    return convertItemDetailToItem(itemDetail: itemDetail);
  }

  // ***************************************************************************
  // ***************************************************************************

  void __setChildrenForParent() {
    try {
      Object? itemParent = parent?.currentItemDetail;
      if (itemParent != null && dataState == DataState.ready) {
        setChildrenForParent(
          currentItemOfParentBlock: itemParent,
          items: items,
        );
      }
    } catch (e, stackTrace) {
      print(stackTrace);
    }
    for (var childBlock in _childBlocks) {
      childBlock.__setChildrenForParent();
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  void __setCurrentItemOnly({
    required ID? id,
    required ITEM? item,
    required ITEM_DETAIL? itemDetail,
  }) {
    __blockData._setCurrentItemOnly(
      id: id,
      refreshedItem: item,
      refreshedItemDetail: itemDetail,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  ///
  /// Remove this item from Interface because it no longer exists on the server
  ///
  Future<void> __removeItemFromList({
    required ExecutionTrace executionTrace,
    required ITEM removeItem,
  }) async {
    __blockData._removeItem(removeItem: removeItem);
    //
    executionTrace._addTraceStep(
      codeId: "#43000",
      shortDesc: "Update <b>BlockItemsView</b>...",
      traceStepType: TraceStepType.info,
    );
    ui.updateItemsView();
  }

  // ***************************************************************************
  // ***************************************************************************

  bool hasCurrentItem() {
    return currentItemDetail != null;
  }

  // ***************************************************************************
  // ***************************************************************************

  @_RootMethodAnnotation()
  @_BlockBackendActionAnnotation()
  @_ReturnTaskResultMethodAnnotation()
  Future<BlockBackendActionResult> executeBackendAction({
    FILTER_INPUT? filterInput,
    SuggestedSelection? suggestedSelection,
    required ActionConfirmationType actionConfirmationType,
    required BlockBackendAction<ID, dynamic> action,
  }) async {
    final executionTrace = FlutterArtist.codeFlowLogger._addMethodCall(
      ownerClassInstance: this,
      methodName: "executeBackendAction",
      parameters: null,
      isLibMethod: true,
    );
    executionTrace._addTraceStep(
      codeId: "#71000",
      shortDesc: "Calling ${debugObjHtml(this)}.__canBackendAction()",
      parameters: {
        "checkBusy": true,
      },
      traceStepType: TraceStepType.nonControllableCalling,
      tipDocument: TipDocument.canDoAction,
    );
    //
    // @Same-Code-Precheck-01
    //
    final Actionable<BlockBackendActionPrecheck> actionable =
        __canBackendAction(
      checkBusy: true,
    );
    //
    if (!actionable.yes) {
      executionTrace._addTraceStep(
        codeId: "#71040",
        shortDesc: "Got @actionable:",
        actionable: actionable,
        traceStepType: TraceStepType.debug,
      );
      // _createItemErrorCount++;
      _addErrorLogActionable(
        shelf: shelf,
        actionableFalse: actionable,
        showErrSnackBar: true,
        tipDocument: null,
      );
      return BlockBackendActionResult(
        precheck: actionable.errCode,
        errorInfo: actionable.errorInfo,
      );
    }
    //
    // Confirmation:
    //
    bool confirm = true;
    if (action.needToConfirm) {
      confirm = await _showActionConfirmation(
        shelf: shelf,
        defaultConfirmation: action.defaultConfirmation,
        customConfirmation: action.createCustomConfirmation(),
      );
    }
    //
    if (!confirm) {
      return BlockBackendActionResult(
        precheck: BlockBackendActionPrecheck.cancelled,
      );
    }
    //
    //
    final XShelf xShelf = _XShelfBlockBackendActionExecution(
      block: this,
      filterInput: filterInput,
      afterBackendAction: action.config.afterBackendAction,
    );
    //
    final XBlock thisXBlock = xShelf.findXBlockByName(name)!;
    //
    executionTrace._addTraceStep(
      codeId: "#71340",
      shortDesc: "Creating <b>_BlockBackendActionTaskUnit</b>.",
      traceStepType: TraceStepType.addTaskUnit,
    );
    final _ResultedSTaskUnit taskUnit = _BlockBackendActionTaskUnit(
      xBlock: thisXBlock,
      action: action,
    );
    //
    xShelf._addTaskUnit(taskUnit: taskUnit);
    FlutterArtist._rootQueue._addXRootQueueItem(xRootQueueItem: xShelf);
    await FlutterArtist.executor._executeTaskUnitQueue();
    //
    return taskUnit.taskResult;
  }

  // ***************************************************************************
  // ***************************************************************************

  @_RootMethodAnnotation()
  @_ReturnTaskResultMethodAnnotation()
  @_BlockQuickItemCreationActionAnnotation()
  Future<BlockQuickItemCreationResult> executeQuickItemCreationAction({
    required BlockQuickItemCreationAction<
            ID, //
            ITEM,
            ITEM_DETAIL,
            FILTER_CRITERIA>
        action,
  }) async {
    final executionTrace = FlutterArtist.codeFlowLogger._addMethodCall(
      ownerClassInstance: this,
      methodName: "executeQuickItemCreationAction",
      parameters: {
        "action": action,
      },
      isLibMethod: true,
    );
    //
    final bool checkBusyTrue = true;
    final bool checkAllowTrue = true;
    //
    executionTrace._addTraceStep(
      codeId: "#73000",
      shortDesc:
          "Calling ${debugObjHtml(this)}.__canQuickCreateItem() to check before execute the action.",
      parameters: {
        "checkBusy": checkBusyTrue,
        "checkAllow": checkAllowTrue,
      },
    );
    //
    // @Same-Code-Precheck-01
    //
    final Actionable<BlockQuickItemCreationPrecheck> actionable =
        __canQuickCreateItem(
      checkBusy: checkBusyTrue,
      checkAllow: checkAllowTrue,
    );
    if (!actionable.yes) {
      executionTrace._addTraceStep(
        codeId: "#73040",
        shortDesc: "Got @actionable:",
        actionable: actionable,
        traceStepType: TraceStepType.debug,
      );
      // _refreshErrorCount++;
      _addErrorLogActionable(
        shelf: shelf,
        actionableFalse: actionable,
        showErrSnackBar: true,
        tipDocument: null,
      );
      return BlockQuickItemCreationResult(
        precheck: actionable.errCode,
        errorInfo: actionable.errorInfo,
      );
    }
    //
    // Confirmation:
    //
    bool confirm = true;
    if (action.needToConfirm) {
      confirm = await _showActionConfirmation(
        shelf: shelf,
        defaultConfirmation: action.defaultConfirmation,
        customConfirmation: action.createCustomConfirmation(),
      );
    }
    if (!confirm) {
      return BlockQuickItemCreationResult(
        precheck: BlockQuickItemCreationPrecheck.cancelled,
      );
    }
    //
    final XShelf xShelf = _XShelfBlockQuickItemCreation(block: this);
    //
    final XBlock thisXBlock = xShelf.findXBlockByName(name)!;
    //
    executionTrace._addTraceStep(
      codeId: "#73340",
      shortDesc: "Creating <b>_BlockQuickItemCreationTaskUnit</b>.",
      traceStepType: TraceStepType.addTaskUnit,
    );
    final _ResultedSTaskUnit taskUnit = _BlockQuickItemCreationTaskUnit(
      xBlock: thisXBlock,
      action: action,
    );
    //
    xShelf._addTaskUnit(taskUnit: taskUnit);
    FlutterArtist._rootQueue._addXRootQueueItem(xRootQueueItem: xShelf);
    await FlutterArtist.executor._executeTaskUnitQueue();
    //
    return taskUnit.taskResult;
  }

  // ***************************************************************************
  // ***************************************************************************

  @_RootMethodAnnotation()
  @_ReturnTaskResultMethodAnnotation()
  @_BlockQuickMultiItemCreationActionAnnotation()
  Future<BlockQuickMultiItemCreationResult>
      executeQuickMultiItemCreationAction({
    required BlockQuickMultiItemCreationAction<
            ID, //
            ITEM,
            ITEM_DETAIL,
            FILTER_CRITERIA>
        action,
  }) async {
    final executionTrace = FlutterArtist.codeFlowLogger._addMethodCall(
      ownerClassInstance: this,
      methodName: "executeQuickMultiItemCreationAction",
      parameters: {
        "action": action,
      },
      isLibMethod: true,
    );
    //
    final bool checkBusyTrue = true;
    final bool checkAllowTrue = true;
    //
    executionTrace._addTraceStep(
      codeId: "#74000",
      shortDesc:
          "Calling ${debugObjHtml(this)}.__canCreateMultiItem() to check before execute the action.",
      parameters: {
        "checkBusy": checkBusyTrue,
        "checkAllow": checkAllowTrue,
      },
    );
    //
    // @Same-Code-Precheck-01
    //
    Actionable<BlockQuickMultiItemCreationPrecheck> actionable =
        __canCreateMultiItem(
      checkBusy: checkBusyTrue,
      checkAllow: checkAllowTrue,
    );
    if (!actionable.yes) {
      executionTrace._addTraceStep(
        codeId: "#74040",
        shortDesc: "Got @actionable:",
        actionable: actionable,
        traceStepType: TraceStepType.debug,
      );
      // _refreshErrorCount++;
      _addErrorLogActionable(
        shelf: shelf,
        actionableFalse: actionable,
        showErrSnackBar: true,
        tipDocument: null,
      );
      return BlockQuickMultiItemCreationResult(
        precheck: actionable.errCode,
        errorInfo: actionable.errorInfo,
      );
    }
    //
    // Confirmation:
    //
    bool confirm = true;
    if (action.needToConfirm) {
      confirm = await _showActionConfirmation(
        shelf: shelf,
        defaultConfirmation: action.defaultConfirmation,
        customConfirmation: action.createCustomConfirmation(),
      );
    }
    if (!confirm) {
      return BlockQuickMultiItemCreationResult(
        precheck: BlockQuickMultiItemCreationPrecheck.cancelled,
      );
    }
    //
    final XShelf xShelf = _XShelfBlockQuickMultiItemCreationAction(block: this);
    //
    final XBlock thisXBlock = xShelf.findXBlockByName(name)!;
    //
    executionTrace._addTraceStep(
      codeId: "#74340",
      shortDesc: "Creating <b>_BlockQuickMultiItemCreationTaskUnit</b>.",
      traceStepType: TraceStepType.addTaskUnit,
    );
    final _ResultedSTaskUnit taskUnit = _BlockQuickMultiItemCreationTaskUnit(
      xBlock: thisXBlock,
      action: action,
    );
    //
    xShelf._addTaskUnit(taskUnit: taskUnit);
    FlutterArtist._rootQueue._addXRootQueueItem(xRootQueueItem: xShelf);
    await FlutterArtist.executor._executeTaskUnitQueue();
    //
    return taskUnit.taskResult;
  }

  // ***************************************************************************
  // ***************************************************************************

  @_RootMethodAnnotation()
  @_ReturnTaskResultMethodAnnotation()
  @_BlockQuickItemUpdateActionAnnotation()
  Future<BlockQuickItemUpdateResult> executeQuickItemUpdateAction({
    required BlockQuickItemUpdateAction<
            ID, //
            ITEM,
            ITEM_DETAIL,
            FILTER_CRITERIA>
        action,
  }) async {
    final executionTrace = FlutterArtist.codeFlowLogger._addMethodCall(
      ownerClassInstance: this,
      methodName: "executeQuickItemUpdateAction",
      parameters: {
        "action": action,
      },
      isLibMethod: true,
    );
    //
    final bool checkBusyTrue = true;
    final bool checkAllowTrue = true;
    //
    executionTrace._addTraceStep(
      codeId: "#72000",
      shortDesc:
          "Calling ${debugObjHtml(this)}.__canQuickUpdateItem() to check before execute the action.",
      parameters: {
        "item": action.item,
        "checkBusy": checkBusyTrue,
        "checkAllow": checkAllowTrue,
        "errorIfItemNotInTheBlock": action.config.errorIfItemNotInTheBlock,
      },
    );
    // @Same-Code-Precheck-01
    final Actionable<BlockQuickItemUpdatePrecheck> actionable =
        __canQuickUpdateItem(
      item: action.item,
      checkBusy: checkBusyTrue,
      checkAllow: checkAllowTrue,
      errorIfItemNotInTheBlock: action.config.errorIfItemNotInTheBlock,
    );
    //
    if (!actionable.yes) {
      executionTrace._addTraceStep(
        codeId: "#72040",
        shortDesc: "Got @actionable:",
        actionable: actionable,
        traceStepType: TraceStepType.debug,
      );
      // _createItemErrorCount++;
      _addErrorLogActionable(
        shelf: shelf,
        actionableFalse: actionable,
        showErrSnackBar: true,
        tipDocument: null,
      );
      return BlockQuickItemUpdateResult(
        precheck: actionable.errCode,
        errorInfo: actionable.errorInfo,
      );
    }
    //
    // Confirmation:
    //
    bool confirm = true;
    if (action.needToConfirm) {
      confirm = await _showActionConfirmation(
        shelf: shelf,
        defaultConfirmation: action.defaultConfirmation,
        customConfirmation: action.createCustomConfirmation(),
      );
    }
    if (!confirm) {
      return BlockQuickItemUpdateResult(
        precheck: BlockQuickItemUpdatePrecheck.cancelled,
      );
    }
    //
    final XShelf xShelf = _XShelfBlockQuickItemUpdate(block: this);
    //
    final XBlock thisXBlock = xShelf.findXBlockByName(name)!;
    //
    executionTrace._addTraceStep(
      codeId: "#72340",
      shortDesc: "Creating <b>_BlockQuickItemUpdateTaskUnit</b>.",
      traceStepType: TraceStepType.addTaskUnit,
    );
    final _ResultedSTaskUnit taskUnit = _BlockQuickItemUpdateTaskUnit(
      xBlock: thisXBlock,
      action: action,
    );
    //
    xShelf._addTaskUnit(taskUnit: taskUnit);
    FlutterArtist._rootQueue._addXRootQueueItem(xRootQueueItem: xShelf);
    await FlutterArtist.executor._executeTaskUnitQueue();
    //
    return taskUnit.taskResult;
  }

  // ***************************************************************************
  // ***************************************************************************

  @_RootMethodAnnotation()
  @_ReturnTaskResultMethodAnnotation()
  @_BlockSelectFirstItemAsCurrentAnnotation()
  Future<BlockSetCurrentItemResult<ITEM>> refreshFirstItemAndSetAsCurrent({
    bool forceLoadForm = false,
  }) async {
    final executionTrace = FlutterArtist.codeFlowLogger._addMethodCall(
      ownerClassInstance: this,
      methodName: "refreshFirstItemAndSetAsCurrent",
      parameters: {
        "forceLoadForm": forceLoadForm,
      },
      isLibMethod: true,
    );
    return __refreshItemAndSetAsCurrent(
      executionTrace: executionTrace,
      methodName: "refreshFirstItemAndSetAsCurrent",
      item: firstItem,
      errCodeIfItemIsNull: ErrCodeIfItemIsNull.noTarget,
      forceLoadItem: true,
      forceLoadForm: forceLoadForm,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  @_RootMethodAnnotation()
  @_ReturnTaskResultMethodAnnotation()
  @_BlockSelectNextItemAsCurrentAnnotation()
  Future<BlockSetCurrentItemResult<ITEM>> refreshNextItemAndSetAsCurrent({
    bool forceLoadForm = false,
  }) async {
    final executionTrace = FlutterArtist.codeFlowLogger._addMethodCall(
      ownerClassInstance: this,
      methodName: "refreshNextItemAndSetAsCurrent",
      parameters: {
        "forceLoadForm": forceLoadForm,
      },
      isLibMethod: true,
    );
    //
    ITEM? nextItem = nextSiblingItem;
    //
    return __refreshItemAndSetAsCurrent(
      executionTrace: executionTrace,
      methodName: "refreshNextItemAndSetAsCurrent",
      item: nextItem,
      errCodeIfItemIsNull: ErrCodeIfItemIsNull.noTarget,
      forceLoadItem: true,
      forceLoadForm: forceLoadForm,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  @_RootMethodAnnotation()
  @_ReturnTaskResultMethodAnnotation()
  @_BlockSelectPreviousItemAsCurrentAnnotation()
  Future<BlockSetCurrentItemResult<ITEM>> refreshPreviousItemAndSetAsCurrent({
    bool forceLoadForm = false,
  }) async {
    final executionTrace = FlutterArtist.codeFlowLogger._addMethodCall(
      ownerClassInstance: this,
      methodName: "refreshPreviousItemAndSetAsCurrent",
      parameters: {
        "forceLoadForm": forceLoadForm,
      },
      isLibMethod: true,
    );
    //
    ITEM? previousItem = previousSiblingItem;
    //
    return __refreshItemAndSetAsCurrent(
      executionTrace: executionTrace,
      methodName: "refreshPreviousItemAndSetAsCurrent",
      item: previousItem,
      errCodeIfItemIsNull: ErrCodeIfItemIsNull.noTarget,
      forceLoadItem: true,
      forceLoadForm: forceLoadForm,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  ///
  /// Prepare to edit an item in a Form.
  ///
  Future<BlockSetCurrentItemResult> _prepareFormToEditCurrentItem() async {
    final executionTrace = FlutterArtist.codeFlowLogger._addMethodCall(
      ownerClassInstance: this,
      methodName: "_prepareFormToEditItem",
      parameters: {},
      isLibMethod: true,
    );
    //
    return await refreshCurrentItem(forceLoadForm: true);
  }

  // ***************************************************************************
  // ***************************************************************************

  ///
  /// Prepare to create an item in a Form.
  ///
  @_RootMethodAnnotation()
  @_ReturnTaskResultMethodAnnotation()
  @_BlockPrepareFormToCreateItemAnnotation()
  Future<PrepareItemCreationResult> prepareFormToCreateItem({
    FORM_INPUT? formInput,
    bool initDirty = false,
  }) async {
    final executionTrace = FlutterArtist.codeFlowLogger._addMethodCall(
      ownerClassInstance: this,
      methodName: "prepareFormToCreateItem",
      parameters: {
        "formInput": formInput,
        "initDirty": initDirty,
      },
      isLibMethod: true,
    );
    //
    final bool checkBusyTrue = true;
    final bool checkAllowTrue = true;
    final creationTypeForm = ItemCreationType.form;
    //
    executionTrace._addTraceStep(
      codeId: "#77000",
      shortDesc:
          "Calling ${debugObjHtml(this)}.__canCreateItem() to check before execute the action.",
      parameters: {
        "checkBusy": checkBusyTrue,
        "checkAllow": checkAllowTrue,
        "creationType": creationTypeForm,
      },
    );
    // @Same-Code-Precheck-01
    Actionable<BlockItemCreationPrecheck> actionable = __canCreateItem(
      checkBusy: checkBusyTrue,
      checkAllow: checkAllowTrue,
      creationType: creationTypeForm,
    );
    if (!actionable.yes) {
      executionTrace._addTraceStep(
        codeId: "#77040",
        shortDesc: "Got @actionable:",
        actionable: actionable,
        traceStepType: TraceStepType.debug,
      );
      // _createItemErrorCount++;
      _addErrorLogActionable(
        shelf: shelf,
        actionableFalse: actionable,
        showErrSnackBar: true,
        tipDocument: null,
      );
      return PrepareItemCreationResult(
        precheck: actionable.errCode,
        errorInfo: actionable.errorInfo,
      );
    }
    //
    formInput?.formAction = FormAction.create;
    //
    final XShelf xShelf = _XShelfPrepareFormToCreateItem(block: this);
    final XBlock thisXBlock = xShelf.findXBlockByName(name)!;
    //
    executionTrace._addTraceStep(
      codeId: "#77340",
      shortDesc: "Creating <b>_BlockPrepareFormToCreateItemTaskUnit</b>.",
      traceStepType: TraceStepType.addTaskUnit,
    );
    _STaskUnit taskUnit = _BlockPrepareFormToCreateItemTaskUnit(
      xBlock: thisXBlock,
      initDirty: initDirty,
      formInput: formInput,
    );
    //
    xShelf._addTaskUnit(taskUnit: taskUnit);
    FlutterArtist._rootQueue._addXRootQueueItem(xRootQueueItem: xShelf);
    await FlutterArtist.executor._executeTaskUnitQueue();
    //
    return thisXBlock.itemCreationResult;
  }

  // ***************************************************************************
  // ***************************************************************************

  @_RootMethodAnnotation()
  @_ReturnTaskResultMethodAnnotation()
  @_BlockDeleteSelectedItemsAnnotation()
  Future<BlockItemsDeletionResult<ITEM>> deleteSelectedItems({
    required CurrentItemInclusion currentItemInclusion,
    required bool stopIfError,
  }) async {
    final executionTrace = FlutterArtist.codeFlowLogger._addMethodCall(
      ownerClassInstance: this,
      methodName: "deleteSelectedItems",
      parameters: {
        "currentItemInclusion": currentItemInclusion,
        "stopIfError": stopIfError,
      },
      isLibMethod: true,
    );
    List<ITEM> selItems = __blockData.getSelectedItems(
      currentItemInclusion: currentItemInclusion,
    );
    executionTrace._addTraceStep(
      codeId: "#66000",
      shortDesc: "Selected Items: ${debugObjHtml(selItems)}..",
    );
    //
    return await __deleteItems(
      executionTrace: executionTrace,
      methodName: "deleteSelectedItems",
      items: selItems,
      stopIfError: stopIfError,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  @_RootMethodAnnotation()
  @_ReturnTaskResultMethodAnnotation()
  @_BlockDeleteCheckedItemsAnnotation()
  Future<BlockItemsDeletionResult> deleteCheckedItems({
    required CurrentItemInclusion currentItemInclusion,
    required bool stopIfError,
  }) async {
    final executionTrace = FlutterArtist.codeFlowLogger._addMethodCall(
      ownerClassInstance: this,
      methodName: "deleteCheckedItems",
      parameters: {
        "currentItemInclusion": currentItemInclusion,
        "stopIfError": stopIfError,
      },
      isLibMethod: true,
    );
    List<ITEM> chkItems = __blockData.getCheckedItems(
      currentItemInclusion: currentItemInclusion,
    );
    executionTrace._addTraceStep(
      codeId: "#64000",
      shortDesc: "Checked Items: ${debugObjHtml(chkItems)}..",
    );
    //
    return await __deleteItems(
      executionTrace: executionTrace,
      methodName: "deleteCheckedItems",
      items: chkItems,
      stopIfError: stopIfError,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  @_RootMethodAnnotation()
  @_ReturnTaskResultMethodAnnotation()
  Future<BlockItemsDeletionResult<ITEM>> deleteItems({
    required List<ITEM> items,
    required bool stopIfError,
  }) async {
    final executionTrace = FlutterArtist.codeFlowLogger._addMethodCall(
      ownerClassInstance: this,
      methodName: "deleteItems",
      parameters: {
        "items": items,
        "stopIfError": stopIfError,
      },
      isLibMethod: true,
    );
    executionTrace._addTraceStep(
      codeId: "#67000",
      shortDesc: "Items: ${debugObjHtml(items)}..",
    );
    return await __deleteItems(
      executionTrace: executionTrace,
      methodName: "deleteItems",
      items: items,
      stopIfError: stopIfError,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  @_RootMethodAnnotation()
  @_ReturnTaskResultMethodAnnotation()
  @_BlockDeleteCurrentItemAnnotation()
  Future<BlockItemDeletionResult<ITEM>> deleteCurrentItem() async {
    final executionTrace = FlutterArtist.codeFlowLogger._addMethodCall(
      ownerClassInstance: this,
      methodName: "deleteCurrentItem",
      parameters: null,
      isLibMethod: true,
    );
    ITEM? currItem = currentItem;
    //
    return __deleteItem(
      executionTrace: executionTrace,
      methodName: "deleteCurrentItem",
      item: currItem,
      errCodeIfItemIsNull: ErrCodeIfItemIsNull.noTarget,
      errorIfItemNotInTheBlock: true,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  @_RootMethodAnnotation()
  @_BlockDeleteItemAnnotation()
  @_ReturnTaskResultMethodAnnotation()
  Future<BlockItemDeletionResult<ITEM>> deleteItem({
    required ITEM item,
    bool errorIfItemNotInTheBlock = true,
  }) async {
    final executionTrace = FlutterArtist.codeFlowLogger._addMethodCall(
      ownerClassInstance: this,
      methodName: "deleteItem",
      parameters: {
        "item": item,
        "errorIfItemNotInTheBlock": errorIfItemNotInTheBlock,
      },
      isLibMethod: true,
    );
    return __deleteItem(
      executionTrace: executionTrace,
      methodName: "deleteItem",
      item: item,
      errCodeIfItemIsNull: ErrCodeIfItemIsNull.invalidTarget,
      errorIfItemNotInTheBlock: errorIfItemNotInTheBlock,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  ///
  ///
  ///
  @_RootMethodAnnotation()
  @_ReturnTaskResultMethodAnnotation()
  @_BlockRefreshCurrentItemAnnotation()
  Future<BlockSetCurrentItemResult<ITEM>> refreshCurrentItem({
    bool forceLoadForm = false,
  }) async {
    final executionTrace = FlutterArtist.codeFlowLogger._addMethodCall(
      ownerClassInstance: this,
      methodName: "refreshCurrentItem",
      parameters: {
        "forceLoadForm": forceLoadForm,
      },
      isLibMethod: true,
    );
    //
    return await __refreshItemAndSetAsCurrent(
      executionTrace: executionTrace,
      methodName: 'refreshCurrentItem',
      item: currentItem,
      errCodeIfItemIsNull: ErrCodeIfItemIsNull.noTarget,
      forceLoadItem: true,
      forceLoadForm: forceLoadForm,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  void _processNavigationIntent({
    required BuildContext context,
    required TaskResult result,
    required NavigationIntent intent,
  }) {
    try {
      final executionTrace = FlutterArtist.codeFlowLogger._addNavigationIntent(
        ownerClassInstance: this,
        intent: intent,
      );
      final bool isActionSuccess = result.successForFirst;

      executionTrace._addTraceStep(
        codeId: "#81000",
        shortDesc: "Calling ${debugObjHtml(this)}._processNavigationIntent().",
        parameters: {
          "intent": intent,
        },
      );
      final List<RouteKey> stack = context.faRouter.stack;

      executionTrace._addTraceStep(
        codeId: "#81020",
        shortDesc: "Route Stack:",
        note: "Open Extra-Info Dialog for details",
        extraInfos: stack.map((rk) => rk.toString()).toList(),
      );

      if (!isActionSuccess && !intent.executeOnFailure) {
        return;
      }
      final router = context.faRouter;
      // to()
      if (intent is _NavigationToIntent) {
        executionTrace._addTraceStep(
          codeId: "#81040",
          shortDesc: "Calling router.to().",
          parameters: {
            "intent": intent,
          },
        );
        router.to(intent.path, builder: intent.builder, extra: intent.extra);
      }
      // off()
      else if (intent is _NavigationOffIntent) {
        executionTrace._addTraceStep(
          codeId: "#81080",
          shortDesc: "Calling router.off().",
          parameters: {
            "intent": intent,
          },
        );
        router.off(intent.path, builder: intent.builder, extra: intent.extra);
      }
      // offAll()
      else if (intent is _NavigationOffAllIntent) {
        executionTrace._addTraceStep(
          codeId: "#81120",
          shortDesc: "Calling router.offAll().",
          parameters: {
            "intent": intent,
          },
        );
        router.offAll(intent.path,
            builder: intent.builder, extra: intent.extra);
      }
      // pop()
      else if (intent is _NavigationPopIntent) {
        executionTrace._addTraceStep(
          codeId: "#81160",
          shortDesc: "Calling router.pop().",
          parameters: {
            "intent": intent,
          },
        );
        print("ROUTE STACK Before: ${router.stack}");
        router.pop();
        print("ROUTE STACK After: ${router.stack}");
      }
      // dialog()
      else if (intent is _NavigationShowDialogIntent) {
        executionTrace._addTraceStep(
          codeId: "#81200",
          shortDesc: "Calling router.showDialog().",
          parameters: {
            "intent": intent,
          },
        );
        router.showDialog(
          intent.path,
          builder: intent.builder,
          guards: intent.guards,
          extra: intent.extra,
          barrierDismissible: intent.barrierDismissible,
        );
      }
      // closeAllDialogs()
      else if (intent is _NavigationCloseAllDialogsIntent) {
        executionTrace._addTraceStep(
          codeId: "#81240",
          shortDesc: "Calling router.closeAllDialogs().",
          parameters: {
            "intent": intent,
          },
        );
        router.closeAllDialogs();
      }
      // endDrawer()
      else if (intent is _NavigationOpenEndDrawerIntent) {
        executionTrace._addTraceStep(
          codeId: "#81280",
          shortDesc: "Calling Scaffold.of(context).openEndDrawer().",
          parameters: {
            "intent": intent,
          },
        );
        Scaffold.of(context).openEndDrawer();
      }
      // drawer()
      else if (intent is _NavigationOpenDrawerIntent) {
        executionTrace._addTraceStep(
          codeId: "#81320",
          shortDesc: "Calling Scaffold.of(context).openDrawer().",
          parameters: {
            "intent": intent,
          },
        );
        Scaffold.of(context).openDrawer();
      }
      // Custom Intent.
      else if (intent is _NavigationCustomIntent) {
        executionTrace._addTraceStep(
          codeId: "#81360",
          shortDesc: "Calling intent.onExecute().",
          parameters: {
            "intent": intent,
          },
        );
        intent.onExecute(context, result);
      }
      // else.
      else {
        throw UnimplementedError("TODO _processNavigationIntent");
      }
    } catch (e, stackTrace) {
      final errorInfo = _handleError(
        shelf: shelf,
        methodName: "${getClassName(this)}._processNavigationIntent",
        error: e,
        stackTrace: stackTrace,
        showSnackBar: true,
        tipDocument: null,
      );
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  void __emitEventFromBlockToOtherShelves({
    required ExecutionTrace executionTrace,
    required EventType eventType,
  }) {
    // TODO: Chuyen di noi khac.
    FlutterArtist.storage.ev._emitEventFromBlockToOtherShelves(
      executionTrace: executionTrace,
      eventType: eventType,
      eventBlock: this,
      itemIdString: null,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  @_ReturnTaskResultMethodAnnotation()
  Future<BlockQueryResult> __queryBlock({
    required ExecutionTrace executionTrace,
    required BlockQryMethodName qryMethod,
    required ListUpdateStrategy suggestedListUpdateStrategy,
    required BlockAfterQueryDirective afterQueryDirective,
    required FILTER_INPUT? filterInput,
    required SuggestedSelection? suggestedSelection,
    required Pageable? specifiedPageable,
  }) async {
    Pageable? usedPageable;
    switch (qryMethod) {
      case BlockQryMethodName.query:
        usedPageable = specifiedPageable;
      case BlockQryMethodName.queryNextPage:
        Pageable? currentPageable = __blockData.pageable;
        if (currentPageable == null) {
          return BlockQueryResult._noCurrentPagination();
        }
        usedPageable = currentPageable.next();
      case BlockQryMethodName.queryPreviousPage:
        Pageable? currentPageable = __blockData.pageable;
        if (currentPageable == null) {
          return BlockQueryResult._noCurrentPagination();
        }
        usedPageable = currentPageable.previous();
        if (usedPageable == null) {
          return BlockQueryResult._noPreviousPage();
        }
      case BlockQryMethodName.queryMore:
        usedPageable = nextPageable;
        if (usedPageable == null) {
          return BlockQueryResult._noNextPage();
        }
    }
    //
    final XShelf xShelf = _XShelfBlockQuery(
      block: this,
      filterInput: filterInput,
      pageable: usedPageable,
      listUpdateStrategy: suggestedListUpdateStrategy,
      afterQueryDirective: afterQueryDirective,
      suggestedSelection: suggestedSelection,
    );
    //
    xShelf._initQueryTaskUnits(executionTrace: executionTrace);
    FlutterArtist._rootQueue._addXRootQueueItem(xRootQueueItem: xShelf);
    await FlutterArtist.executor._executeTaskUnitQueue();
    //
    XBlock xBlock = xShelf.findXBlockByName(name)!;
    BlockQueryResult queryResult = xBlock.queryResult;
    return queryResult;
  }

  // ***************************************************************************
  // ***************************************************************************

  Future<bool> __queryEmpty({
    required ExecutionTrace executionTrace,
    required FILTER_INPUT? filterInput,
    bool prepareFormToCreateItem = false,
  }) async {
    if (filterModel != null && filterModel!.lockAddMoreQuery) {
      return false;
    }
    //
    executionTrace._addTraceStep(
      codeId: "#53000",
      shortDesc: "Creating <b>$_XShelfBlockQueryEmpty</b>..",
    );
    //
    final XShelf xShelf = _XShelfBlockQueryEmpty(
      block: this,
      filterInput: filterInput,
      pageable: pageable,
      listUpdateStrategy: ListUpdateStrategy.replace,
      afterQueryDirective: prepareFormToCreateItem
          ? BlockAfterQueryDirective.createNewItem
          : BlockAfterQueryDirective.setAnItemAsCurrent,
      suggestedSelection: null,
    );
    //
    executionTrace._addTraceStep(
      codeId: "#53100",
      shortDesc: "Calling ${debugObjHtml(xShelf)}._initQueryTaskUnits()..",
      traceStepType: TraceStepType.nonControllableCalling,
    );
    xShelf._initQueryTaskUnits(executionTrace: executionTrace);
    FlutterArtist._rootQueue._addXRootQueueItem(xRootQueueItem: xShelf);
    await FlutterArtist.executor._executeTaskUnitQueue();
    //
    XBlock xBlock = xShelf.findXBlockByName(name)!;
    BlockQueryResult queryResult = xBlock.queryResult;
    return queryResult.successForAll;
  }

  // ***************************************************************************
  // *********** isAllowXXX() method *******************************************
  // ***************************************************************************

  ///
  /// Allows reset the Form or not according to the application logic.
  ///
  bool isFormResetAllowed() {
    return true;
  }

  // ***************************************************************************
  // ***************************************************************************

  ///
  /// Allows querying the block or not according to the application logic.
  ///
  bool isQueryAllowed() {
    return true;
  }

  // ***************************************************************************
  // ***************************************************************************

  ///
  /// Allows creating a new Item or not according to the application logic.
  ///
  bool isItemCreationAllowed() {
    return true;
  }

  // ***************************************************************************
  // ***************************************************************************

  ///
  /// Allows edit an Item or not according to the application logic.
  ///
  bool isItemUpdateAllowed({required ITEM item}) {
    return true;
  }

  // ***************************************************************************
  // ***************************************************************************

  ///
  /// Allows deleting an Item or not according to the application logic.
  ///
  bool isItemDeletionAllowed({required ITEM item}) {
    return true;
  }

  // ***************************************************************************
  // ***************************************************************************

  bool isCurrentItemUpdateAllowed() {
    ITEM? currentItem = this.currentItem;
    if (currentItem == null) {
      return false;
    }
    return isItemUpdateAllowed(item: currentItem);
  }

  // ***************************************************************************
  // ***************************************************************************

  bool isCurrentItemDeletionAllowed() {
    ITEM? currentItem = this.currentItem;
    if (currentItem == null) {
      return false;
    }
    return isItemDeletionAllowed(item: currentItem);
  }

  // ***************************************************************************
  // *********** __isAllowXXX() method *****************************************
  // ***************************************************************************

  ///
  /// Allows to Query the Block.
  ///
  @_IsAllowPrivateMethodAnnotation()
  CheckAllowResult __isQueryAllowed() {
    try {
      bool allow = isQueryAllowed();
      return allow ? CheckAllowResult.allow() : CheckAllowResult.notAllow();
    } catch (e, stackTrace) {
      return CheckAllowResult.error(
        errorInfo: ErrorInfo.fromError(error: e, stackTrace: stackTrace),
      );
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  ///
  /// Allows edit current item or not according to the application logic.
  ///
  @_IsAllowPrivateMethodAnnotation()
  CheckAllowResult __isFormResetAllowed() {
    try {
      bool allow = isFormResetAllowed();
      return allow ? CheckAllowResult.allow() : CheckAllowResult.notAllow();
    } catch (e, stackTrace) {
      return CheckAllowResult.error(
        errorInfo: ErrorInfo.fromError(
          error: e,
          stackTrace: stackTrace,
        ),
      );
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  ///
  /// Allows updating an Item or not according to the application logic.
  ///
  @_IsAllowPrivateMethodAnnotation()
  CheckAllowResult _isItemUpdateAllowed({
    required ITEM item,
  }) {
    try {
      bool allow = isItemUpdateAllowed(item: item);
      return allow ? CheckAllowResult.allow() : CheckAllowResult.notAllow();
    } catch (e, stackTrace) {
      return CheckAllowResult.error(
        errorInfo: ErrorInfo.fromError(
          error: e,
          stackTrace: stackTrace,
        ),
      );
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  ///
  /// Allows creating a new Item or not according to the application logic.
  ///
  @_IsAllowPrivateMethodAnnotation()
  CheckAllowResult __isItemCreationAllowed() {
    try {
      bool allow = isItemCreationAllowed();
      return allow ? CheckAllowResult.allow() : CheckAllowResult.notAllow();
    } catch (e, stackTrace) {
      return CheckAllowResult.error(
        errorInfo: ErrorInfo.fromError(
          error: e,
          stackTrace: stackTrace,
        ),
      );
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  ///
  /// Allows deleting an Item or not according to the application logic.
  ///
  @_IsAllowPrivateMethodAnnotation()
  CheckAllowResult __isItemDeletionAllowed({required ITEM item}) {
    try {
      bool allow = isItemDeletionAllowed(item: item);
      return allow ? CheckAllowResult.allow() : CheckAllowResult.notAllow();
    } catch (e, stackTrace) {
      return CheckAllowResult.error(
        errorInfo: ErrorInfo.fromError(
          error: e,
          stackTrace: stackTrace,
        ),
      );
    }
  }

  // ***************************************************************************
  // *********** __canXXX() method *********************************************
  // ***************************************************************************

  @_PrecheckPrivateMethod()
  Actionable<BlockItemDeletionPrecheck> __canDeleteCurrentItem({
    required bool checkBusy,
    required bool checkAllow,
  }) {
    return __canDeleteItem(
      checkBusy: checkBusy,
      item: currentItem,
      errCodeIfItemIsNull: ErrCodeIfItemIsNull.noTarget,
      checkAllow: checkAllow,
      errorIfItemNotInTheBlock: true,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  @_PrecheckPrivateMethod()
  Actionable<BlockQueryPrecheck> __canQuery({
    required bool checkBusy,
    required bool checkAllow,
  }) {
    if (checkBusy && FlutterArtist.executor.isBusy) {
      return Actionable<BlockQueryPrecheck>.no(
          errCode: BlockQueryPrecheck.busy);
    }
    //
    if (checkAllow) {
      CheckAllowResult result = __isQueryAllowed();
      switch (result.result) {
        case CheckAllow.allow:
          return Actionable<BlockQueryPrecheck>.yes();
        case CheckAllow.notAllow:
          return Actionable<BlockQueryPrecheck>.no(
            errCode: BlockQueryPrecheck.notAllow,
          );
        case CheckAllow.error:
          return Actionable<BlockQueryPrecheck>.no(
            errCode: BlockQueryPrecheck.checkAllowMethodError,
            errorInfo: result.errorInfo,
          );
      }
    }
    //
    return Actionable<BlockQueryPrecheck>.yes();
  }

  // ***************************************************************************

  @_PrecheckPrivateMethod()
  Actionable<BlockItemDeletionPrecheck> __canDeleteItem({
    required bool checkBusy,
    required bool errorIfItemNotInTheBlock,
    required ITEM? item,
    required ErrCodeIfItemIsNull errCodeIfItemIsNull,
    required bool checkAllow,
  }) {
    if (checkBusy && FlutterArtist.executor.isBusy) {
      return Actionable<BlockItemDeletionPrecheck>.no(
        errCode: BlockItemDeletionPrecheck.busy,
      );
    }
    //
    if (item == null) {
      if (errCodeIfItemIsNull == ErrCodeIfItemIsNull.noTarget) {
        return Actionable<BlockItemDeletionPrecheck>.no(
          errCode: BlockItemDeletionPrecheck.noTarget,
        );
      } else {
        return Actionable<BlockItemDeletionPrecheck>.no(
          errCode: BlockItemDeletionPrecheck.invalidTarget,
        );
      }
    }
    //
    if (errorIfItemNotInTheBlock) {
      ITEM? it = findItemSameIdWith(item: item);
      if (it == null) {
        return Actionable<BlockItemDeletionPrecheck>.no(
          errCode: BlockItemDeletionPrecheck.invalidTarget,
        );
      }
    }
    //
    if (checkAllow) {
      CheckAllowResult result = __isItemDeletionAllowed(item: item);
      switch (result.result) {
        case CheckAllow.allow:
          return Actionable<BlockItemDeletionPrecheck>.yes();
        case CheckAllow.notAllow:
          return Actionable<BlockItemDeletionPrecheck>.no(
            errCode: BlockItemDeletionPrecheck.notAllow,
          );
        case CheckAllow.error:
          return Actionable<BlockItemDeletionPrecheck>.no(
            errCode: BlockItemDeletionPrecheck.checkAllowMethodError,
            errorInfo: result.errorInfo, // [03a]
          );
      }
    }
    //
    return Actionable<BlockItemDeletionPrecheck>.yes();
  }

  // ***************************************************************************

  @_PrecheckPrivateMethod()
  Actionable<BlockItemsDeletionPrecheck> __canDeleteItems({
    required bool checkBusy,
    required bool checkAllow,
    required List<ITEM> items,
    required bool errorIfItemNotInTheBlock,
  }) {
    List<ITEM> rmvItems = FaItemsUtils.removeDuplicatedItems(
      items: items,
      getItemId: _getItemIdInternal,
    );
    //
    if (checkBusy && FlutterArtist.executor.isBusy) {
      return Actionable<BlockItemsDeletionPrecheck>.no(
        errCode: BlockItemsDeletionPrecheck.busy,
      );
    }
    //
    if (errorIfItemNotInTheBlock) {
      for (ITEM item in rmvItems) {
        ITEM? it = findItemSameIdWith(item: item);
        if (it == null) {
          return Actionable<BlockItemsDeletionPrecheck>.no(
            errCode: BlockItemsDeletionPrecheck.invalidTarget,
          );
        }
        //
        if (checkAllow) {
          CheckAllowResult result = __isItemDeletionAllowed(item: item);
          switch (result.result) {
            case CheckAllow.allow:
              continue;
            case CheckAllow.notAllow:
              return Actionable<BlockItemsDeletionPrecheck>.no(
                errCode: BlockItemsDeletionPrecheck.notAllow,
              );
            case CheckAllow.error:
              return Actionable<BlockItemsDeletionPrecheck>.no(
                errCode: BlockItemsDeletionPrecheck.checkAllowMethodError,
                errorInfo: result.errorInfo,
              );
          }
        }
      }
    }
    //
    return Actionable<BlockItemsDeletionPrecheck>.yes();
  }

  // ***************************************************************************
  // ***************************************************************************

  @_PrecheckPrivateMethod()
  Actionable<BlockBackendActionPrecheck> __canBackendAction({
    required bool checkBusy,
  }) {
    if (checkBusy && FlutterArtist.executor.isBusy) {
      return Actionable<BlockBackendActionPrecheck>.no(
        errCode: BlockBackendActionPrecheck.busy,
      );
    }
    switch (dataState) {
      case DataState.pending:
        return Actionable<BlockBackendActionPrecheck>.no(
          errCode: BlockBackendActionPrecheck.blockInPendingState,
        );
      case DataState.error:
        return Actionable<BlockBackendActionPrecheck>.no(
          errCode: BlockBackendActionPrecheck.blockInErrorState,
        );
      case DataState.none:
        return Actionable<BlockBackendActionPrecheck>.no(
          errCode: BlockBackendActionPrecheck.blockInNoneState,
        );
      case DataState.ready:
        break;
    }
    //
    return Actionable<BlockBackendActionPrecheck>.yes();
  }

  // ***************************************************************************
  // ***************************************************************************

  @_PrecheckPrivateMethod()
  Actionable<BlockQuickMultiItemCreationPrecheck> __canCreateMultiItem({
    required bool checkBusy,
    required bool checkAllow,
  }) {
    if (checkBusy && FlutterArtist.executor.isBusy) {
      return Actionable<BlockQuickMultiItemCreationPrecheck>.no(
        errCode: BlockQuickMultiItemCreationPrecheck.busy,
      );
    }
    switch (dataState) {
      case DataState.pending:
        return Actionable<BlockQuickMultiItemCreationPrecheck>.no(
          errCode: BlockQuickMultiItemCreationPrecheck.blockInPendingState,
        );
      case DataState.error:
        return Actionable<BlockQuickMultiItemCreationPrecheck>.no(
          errCode: BlockQuickMultiItemCreationPrecheck.blockInErrorState,
        );
      case DataState.none:
        return Actionable<BlockQuickMultiItemCreationPrecheck>.no(
          errCode: BlockQuickMultiItemCreationPrecheck.blockInNoneState,
        );
      case DataState.ready:
        break;
    }
    //
    if (checkAllow) {
      CheckAllowResult result = __isItemCreationAllowed();
      switch (result.result) {
        case CheckAllow.allow:
          return Actionable<BlockQuickMultiItemCreationPrecheck>.yes();
        case CheckAllow.notAllow:
          return Actionable<BlockQuickMultiItemCreationPrecheck>.no(
            errCode: BlockQuickMultiItemCreationPrecheck.notAllow,
          );
        case CheckAllow.error:
          return Actionable<BlockQuickMultiItemCreationPrecheck>.no(
            errCode: BlockQuickMultiItemCreationPrecheck.checkAllowMethodError,
            errorInfo: result.errorInfo,
          );
      }
    }
    //
    return Actionable<BlockQuickMultiItemCreationPrecheck>.yes();
  }

  // ***************************************************************************
  // ***************************************************************************

  @_PrecheckPrivateMethod()
  Actionable<BlockItemCreationPrecheck> __canCreateItem({
    required bool checkBusy,
    required ItemCreationType creationType,
    required bool checkAllow,
  }) {
    if (checkBusy && FlutterArtist.executor.isBusy) {
      return Actionable<BlockItemCreationPrecheck>.no(
        errCode: BlockItemCreationPrecheck.busy,
      );
    }
    if (creationType == ItemCreationType.form) {
      if (formModel == null) {
        return Actionable<BlockItemCreationPrecheck>.no(
          errCode: BlockItemCreationPrecheck.noForm,
        );
      }
    }
    switch (dataState) {
      case DataState.pending:
        return Actionable<BlockItemCreationPrecheck>.no(
          errCode: BlockItemCreationPrecheck.blockInPendingState,
        );
      case DataState.error:
        return Actionable<BlockItemCreationPrecheck>.no(
          errCode: BlockItemCreationPrecheck.blockInErrorState,
        );
      case DataState.none:
        return Actionable<BlockItemCreationPrecheck>.no(
          errCode: BlockItemCreationPrecheck.blockInNoneState,
        );
      case DataState.ready:
        break;
    }
    //
    if (checkAllow) {
      CheckAllowResult result = __isItemCreationAllowed();
      switch (result.result) {
        case CheckAllow.allow:
          return Actionable<BlockItemCreationPrecheck>.yes();
        case CheckAllow.notAllow:
          return Actionable<BlockItemCreationPrecheck>.no(
            errCode: BlockItemCreationPrecheck.notAllow,
          );
        case CheckAllow.error:
          return Actionable<BlockItemCreationPrecheck>.no(
            errCode: BlockItemCreationPrecheck.checkAllowMethodError,
            errorInfo: result.errorInfo,
          );
      }
    }
    //
    return Actionable<BlockItemCreationPrecheck>.yes();
  }

  // ***************************************************************************
  // ***************************************************************************

  @_PrecheckPrivateMethod()
  Actionable<BlockClearPrecheck> __canClearBlock({
    required bool checkBusy,
  }) {
    if (checkBusy && FlutterArtist.executor.isBusy) {
      return Actionable<BlockClearPrecheck>.no(
        errCode: BlockClearPrecheck.busy,
      );
    }
    bool hasBlockRep = ui.hasActiveUiComponentBlockRepresentative(
      alsoCheckChildren: true,
    );
    if (hasBlockRep) {
      return Actionable<BlockClearPrecheck>.no(
        errCode: BlockClearPrecheck.hasActiveUI,
      );
    }
    return Actionable<BlockClearPrecheck>.yes();
  }

  // ***************************************************************************
  // ***************************************************************************

  @_PrecheckPrivateMethod()
  Actionable<BlockItemEditPrecheck> __canUpdateItem({
    required ITEM item,
    required bool checkBusy,
    required ItemUpdateType updateType,
    required bool checkAllow,
  }) {
    if (checkBusy && FlutterArtist.executor.isBusy) {
      return Actionable<BlockItemEditPrecheck>.no(
        errCode: BlockItemEditPrecheck.busy,
      );
    }
    switch (dataState) {
      case DataState.pending:
        return Actionable<BlockItemEditPrecheck>.no(
          errCode: BlockItemEditPrecheck.inPendingState,
        );
      case DataState.error:
        return Actionable<BlockItemEditPrecheck>.no(
          errCode: BlockItemEditPrecheck.blockInErrorState,
        );
      case DataState.none:
        return Actionable<BlockItemEditPrecheck>.no(
          errCode: BlockItemEditPrecheck.blockInNoneState,
        );
      case DataState.ready:
        break;
    }
    //
    if (checkAllow) {
      CheckAllowResult result = _isItemUpdateAllowed(item: item);
      switch (result.result) {
        case CheckAllow.allow:
          return Actionable<BlockItemEditPrecheck>.yes();
        case CheckAllow.notAllow:
          return Actionable<BlockItemEditPrecheck>.no(
            errCode: BlockItemEditPrecheck.notAllow,
          );
        case CheckAllow.error:
          return Actionable<BlockItemEditPrecheck>.no(
            errCode: BlockItemEditPrecheck.checkAllowMethodError,
            errorInfo: result.errorInfo,
          );
      }
    }
    //
    return Actionable<BlockItemEditPrecheck>.yes();
  }

  // ***************************************************************************
  // ***************************************************************************

  @_PrecheckPrivateMethod()
  Actionable<BlockQuickItemUpdatePrecheck> __canQuickUpdateItem({
    required ITEM item,
    required bool checkBusy,
    required bool checkAllow,
    required bool errorIfItemNotInTheBlock,
  }) {
    if (checkBusy && FlutterArtist.executor.isBusy) {
      return Actionable<BlockQuickItemUpdatePrecheck>.no(
        errCode: BlockQuickItemUpdatePrecheck.busy,
      );
    }
    switch (dataState) {
      case DataState.pending:
        return Actionable<BlockQuickItemUpdatePrecheck>.no(
          errCode: BlockQuickItemUpdatePrecheck.blockInPendingState,
        );
      case DataState.error:
        return Actionable<BlockQuickItemUpdatePrecheck>.no(
          errCode: BlockQuickItemUpdatePrecheck.blockInErrorState,
        );
      case DataState.none:
        return Actionable<BlockQuickItemUpdatePrecheck>.no(
          errCode: BlockQuickItemUpdatePrecheck.blockInNoneState,
        );
      case DataState.ready:
        break;
    }
    //
    ITEM? internalItem = findItemSameIdWith(item: item);
    // Test Cases: [90b].
    if (errorIfItemNotInTheBlock && internalItem == null) {
      return Actionable<BlockQuickItemUpdatePrecheck>.no(
        errCode: BlockQuickItemUpdatePrecheck.invalidTarget,
      );
    }
    //
    if (checkAllow) {
      CheckAllowResult result = _isItemUpdateAllowed(item: item);
      switch (result.result) {
        case CheckAllow.allow:
          return Actionable<BlockQuickItemUpdatePrecheck>.yes();
        case CheckAllow.notAllow:
          return Actionable<BlockQuickItemUpdatePrecheck>.no(
            errCode: BlockQuickItemUpdatePrecheck.notAllow,
          );
        case CheckAllow.error:
          return Actionable<BlockQuickItemUpdatePrecheck>.no(
            errCode: BlockQuickItemUpdatePrecheck.checkAllowMethodError,
            errorInfo: result.errorInfo,
          );
      }
    }
    //
    return Actionable<BlockQuickItemUpdatePrecheck>.yes();
  }

  // ***************************************************************************
  // ***************************************************************************

  @_PrecheckPrivateMethod()
  Actionable<BlockQuickItemCreationPrecheck> __canQuickCreateItem({
    required bool checkBusy,
    required bool checkAllow,
  }) {
    if (checkBusy && FlutterArtist.executor.isBusy) {
      return Actionable<BlockQuickItemCreationPrecheck>.no(
        errCode: BlockQuickItemCreationPrecheck.busy,
      );
    }
    switch (dataState) {
      case DataState.pending:
        return Actionable<BlockQuickItemCreationPrecheck>.no(
          errCode: BlockQuickItemCreationPrecheck.blockInPendingState,
        );
      case DataState.error:
        return Actionable<BlockQuickItemCreationPrecheck>.no(
          errCode: BlockQuickItemCreationPrecheck.blockInErrorState,
        );
      case DataState.none:
        return Actionable<BlockQuickItemCreationPrecheck>.no(
          errCode: BlockQuickItemCreationPrecheck.blockInNoneState,
        );
      case DataState.ready:
        break;
    }
    //
    if (checkAllow) {
      CheckAllowResult result = __isItemCreationAllowed();
      switch (result.result) {
        case CheckAllow.allow:
          return Actionable<BlockQuickItemCreationPrecheck>.yes();
        case CheckAllow.notAllow:
          return Actionable<BlockQuickItemCreationPrecheck>.no(
            errCode: BlockQuickItemCreationPrecheck.notAllow,
          );
        case CheckAllow.error:
          return Actionable<BlockQuickItemCreationPrecheck>.no(
            errCode: BlockQuickItemCreationPrecheck.checkAllowMethodError,
            errorInfo: result.errorInfo,
          );
      }
    }
    //
    return Actionable<BlockQuickItemCreationPrecheck>.yes();
  }

  // ***************************************************************************
  // ***************************************************************************

  @_PrecheckPrivateMethod()
  Actionable<BlockFormResetPrecheck> __canResetForm({
    required bool checkBusy,
    required bool checkAllow,
  }) {
    if (formModel == null) {
      return Actionable<BlockFormResetPrecheck>.no(
        errCode: BlockFormResetPrecheck.noForm,
      );
    }
    if (checkBusy && FlutterArtist.executor.isBusy) {
      return Actionable<BlockFormResetPrecheck>.no(
        errCode: BlockFormResetPrecheck.busy,
      );
    }
    if (!formModel!.isDirty()) {
      return Actionable<BlockFormResetPrecheck>.no(
        errCode: BlockFormResetPrecheck.formIsNotDirty,
      );
    }
    if (!formModel!.formInitialDataReady) {
      return Actionable<BlockFormResetPrecheck>.no(
        errCode: BlockFormResetPrecheck.formInitialDataNotReady,
      );
    }
    switch (formModel!.formMode) {
      case FormMode.none:
        return Actionable<BlockFormResetPrecheck>.no(
          errCode: BlockFormResetPrecheck.formInNoneMode,
        );
      case FormMode.creation:
        break; // Do nothing.
      case FormMode.edit:
        break; // Do nothing.
    }
    if (checkAllow) {
      CheckAllowResult result = __isFormResetAllowed();
      switch (result.result) {
        case CheckAllow.allow:
          return Actionable<BlockFormResetPrecheck>.yes();
        case CheckAllow.notAllow:
          return Actionable<BlockFormResetPrecheck>.no(
            errCode: BlockFormResetPrecheck.notAllow,
          );
        case CheckAllow.error:
          return Actionable<BlockFormResetPrecheck>.no(
            errCode: BlockFormResetPrecheck.checkAllowMethodError,
            errorInfo: result.errorInfo,
          );
      }
    }
    //
    return Actionable<BlockFormResetPrecheck>.yes();
  }

  // ***************************************************************************
  // ***************************************************************************

  @_PrecheckPrivateMethod()
  Actionable<BlockFormSavePrecheck> __canSaveForm({
    required bool checkBusy,
    required bool checkAllow,
    required bool checkValidate,
  }) {
    if (checkBusy && FlutterArtist.executor.isBusy) {
      return Actionable<BlockFormSavePrecheck>.no(
        errCode: BlockFormSavePrecheck.busy,
      );
    }
    if (formModel == null) {
      return Actionable<BlockFormSavePrecheck>.no(
        errCode: BlockFormSavePrecheck.noForm,
      );
    }
    if (!formModel!.formInitialDataReady) {
      return Actionable<BlockFormSavePrecheck>.no(
        errCode: BlockFormSavePrecheck.formInitialDataNotReady,
      );
    }
    //
    if (!formModel!.isDirty()) {
      return Actionable<BlockFormSavePrecheck>.no(
        errCode: BlockFormSavePrecheck.formIsNotDirty,
      );
    }
    if (checkValidate) {
      if (!(formModel!._formKey.currentState?.validate() ?? false)) {
        return Actionable<BlockFormSavePrecheck>.no(
          errCode: BlockFormSavePrecheck.formInvalidated,
        );
      }
    }
    return Actionable<BlockFormSavePrecheck>.yes();
  }

  // ***************************************************************************
  // ***************************************************************************

  @_PrecheckPrivateMethod()
  Actionable<BlockItemEditPrecheck> __canEditItemOnForm({
    required bool checkBusy,
    required ITEM item,
    required bool checkAllow,
  }) {
    if (checkBusy && FlutterArtist.executor.isBusy) {
      return Actionable<BlockItemEditPrecheck>.no(
        errCode: BlockItemEditPrecheck.busy,
      );
    }
    if (formModel == null) {
      return Actionable<BlockItemEditPrecheck>.no(
        errCode: BlockItemEditPrecheck.noForm,
      );
    }
    if (formModel!.dataState == DataState.error) {
      // Test Case: TODO
      return Actionable<BlockItemEditPrecheck>.no(
        errCode: BlockItemEditPrecheck.formInErrorState,
      );
    }
    //
    switch (formModel!.formMode) {
      case FormMode.none:
        return Actionable<BlockItemEditPrecheck>.no(
          errCode: BlockItemEditPrecheck.formModeInNone,
        );
      case FormMode.creation:
        break; // Do nothing.
      case FormMode.edit:
        break; // Do nothing.
    }
    //
    if (checkAllow) {
      CheckAllowResult result = _isItemUpdateAllowed(item: item);
      switch (result.result) {
        case CheckAllow.allow:
          return Actionable<BlockItemEditPrecheck>.yes();
        case CheckAllow.notAllow:
          return Actionable<BlockItemEditPrecheck>.no(
            errCode: BlockItemEditPrecheck.notAllow,
          );
        case CheckAllow.error:
          return Actionable<BlockItemEditPrecheck>.no(
            errCode: BlockItemEditPrecheck.checkAllowMethodError,
            errorInfo: result.errorInfo,
          );
      }
    }
    //
    return Actionable<BlockItemEditPrecheck>.yes();
  }

  // ***************************************************************************
  // ***************************************************************************

  @_PrecheckPrivateMethod()
  Actionable<BlockItemEditPrecheck> __canEditCurrentItemOnForm({
    required bool checkBusy,
    required bool checkAllow,
  }) {
    if (checkBusy && FlutterArtist.executor.isBusy) {
      return Actionable<BlockItemEditPrecheck>.no(
        errCode: BlockItemEditPrecheck.busy,
      );
    }
    ITEM? curItem = currentItem;
    if (curItem == null) {
      return Actionable.no(errCode: BlockItemEditPrecheck.noTarget);
    }
    return __canEditItemOnForm(
      checkBusy: checkBusy,
      item: curItem,
      checkAllow: checkAllow,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  @_PrecheckPrivateMethod()
  // @seeAlso: __canRefreshCurrentItem()
  Actionable<BlockSetCurrentItemPrecheck> __canSetItemAsCurrent({
    required ITEM? item,
    required bool checkBusy,
    required ErrCodeIfItemIsNull errCodeIfItemIsNull,
  }) {
    if (checkBusy && FlutterArtist.executor.isBusy) {
      return Actionable<BlockSetCurrentItemPrecheck>.no(
        errCode: BlockSetCurrentItemPrecheck.busy,
      );
    }
    ITEM? internalItem = item;
    if (item != null) {
      internalItem = findItemSameIdWith(item: item);
    }
    // Test Cases: [03b].
    if (internalItem == null) {
      if (errCodeIfItemIsNull == ErrCodeIfItemIsNull.noTarget) {
        return Actionable<BlockSetCurrentItemPrecheck>.no(
          errCode: BlockSetCurrentItemPrecheck.noTarget,
        );
      } else {
        return Actionable<BlockSetCurrentItemPrecheck>.no(
          errCode: BlockSetCurrentItemPrecheck.invalidTarget,
        );
      }
    }
    //
    return Actionable<BlockSetCurrentItemPrecheck>.yes();
  }

  // ***************************************************************************

  @_PrecheckPrivateMethod()
  // @seeAlso: __canSetItemAsCurrent()
  Actionable<BlockSetCurrentItemPrecheck> __canRefreshCurrentItem({
    required bool checkBusy,
  }) {
    if (currentItem == null) {
      return Actionable<BlockSetCurrentItemPrecheck>.no(
        errCode: BlockSetCurrentItemPrecheck.noTarget,
      );
    }
    if (checkBusy && FlutterArtist.executor.isBusy) {
      return Actionable<BlockSetCurrentItemPrecheck>.no(
        errCode: BlockSetCurrentItemPrecheck.busy,
      );
    }
    //
    return Actionable<BlockSetCurrentItemPrecheck>.yes();
  }

  // ***************************************************************************
  // ***************************************************************************

  ///
  /// Edit on edit-mode
  /// Edit on creation-mode
  ///
  @_PrecheckPrivateMethod()
  Actionable<BlockFormEnablementPrecheck> __isEnableFormToModify({
    required bool checkAllow,
  }) {
    if (formModel == null) {
      return Actionable<BlockFormEnablementPrecheck>.no(
        errCode: BlockFormEnablementPrecheck.noForm,
      );
    }
    //
    switch (formModel!.formMode) {
      case FormMode.none:
        return Actionable<BlockFormEnablementPrecheck>.no(
          errCode: BlockFormEnablementPrecheck.formInNoneMode,
        );
      case FormMode.creation:
        if (formModel!.dataState == DataState.error) {
          // Test Cases: [16a].
          if (!formModel!.formInitialDataReady) {
            return Actionable<BlockFormEnablementPrecheck>.no(
              errCode: BlockFormEnablementPrecheck.formInitialDataNotReady,
            );
          }
        }
        return Actionable<BlockFormEnablementPrecheck>.yes();
      case FormMode.edit:
        if (formModel!.dataState == DataState.error) {
          // Test Cases: [16b].
          if (!formModel!.formInitialDataReady) {
            return Actionable<BlockFormEnablementPrecheck>.no(
              errCode: BlockFormEnablementPrecheck.formInitialDataNotReady,
            );
          }
        }
        if (checkAllow) {
          CheckAllowResult result = _isItemUpdateAllowed(item: currentItem!);
          switch (result.result) {
            case CheckAllow.allow:
              return Actionable<BlockFormEnablementPrecheck>.yes();
            case CheckAllow.notAllow:
              return Actionable<BlockFormEnablementPrecheck>.no(
                errCode: BlockFormEnablementPrecheck.notAllow,
              );
            case CheckAllow.error:
              return Actionable<BlockFormEnablementPrecheck>.no(
                errCode: BlockFormEnablementPrecheck.checkAllowMethodError,
                errorInfo: result.errorInfo,
              );
          }
        }
        return Actionable<BlockFormEnablementPrecheck>.yes();
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  @_PrecheckMethod()
  Actionable<BlockItemDeletionPrecheck> canDeleteCurrentItem({
    bool checkAllow = true,
  }) {
    return __canDeleteCurrentItem(
      checkBusy: true,
      checkAllow: checkAllow,
    );
  }

  // ***************************************************************************

  @_PrecheckMethod()
  Actionable<BlockQueryPrecheck> canQuery({
    bool checkAllow = true,
  }) {
    return __canQuery(checkBusy: true, checkAllow: checkAllow);
  }

  // ***************************************************************************

  @_PrecheckMethod()
  Actionable<BlockItemDeletionPrecheck> canDeleteItem({
    required ITEM item,
    bool errorIfItemNotInTheBlock = true,
    bool checkAllow = true,
  }) {
    return __canDeleteItem(
      checkBusy: true,
      checkAllow: checkAllow,
      item: item,
      errCodeIfItemIsNull: ErrCodeIfItemIsNull.invalidTarget,
      errorIfItemNotInTheBlock: errorIfItemNotInTheBlock,
    );
  }

  // ***************************************************************************

  @_PrecheckMethod()
  Actionable<BlockBackendActionPrecheck> canQuickAction() {
    return __canBackendAction(
      checkBusy: true,
    );
  }

  // ***************************************************************************

  // @_PrecheckMethod()
  // Actionable<BlockItemCreationPrecheck> canCreateItem({
  //   required ItemCreationType creationType,
  //   bool checkAllow = true,
  // }) {
  //   return __canCreateItem(
  //     checkBusy: true,
  //     creationType: creationType,
  //     checkAllow: checkAllow,
  //   );
  // }

  // ***************************************************************************

  @_PrecheckMethod()
  Actionable<BlockItemCreationPrecheck> canCreateItemWithForm() {
    return __canCreateItem(
      checkBusy: true,
      checkAllow: true,
      creationType: ItemCreationType.form,
    );
  }

  @_PrecheckMethod()
  Actionable<BlockSetCurrentItemPrecheck> canEditCurrentItemWithForm() {
    return __canRefreshCurrentItem(
      checkBusy: true,
    );
  }

  // ***************************************************************************

  @_PrecheckMethod()
  Actionable<BlockQuickItemCreationPrecheck> canQuickCreateItem({
    bool checkAllow = true,
  }) {
    return __canQuickCreateItem(
      checkBusy: true,
      checkAllow: checkAllow,
    );
  }

  // ***************************************************************************

  @_PrecheckMethod()
  Actionable<BlockClearPrecheck> canClearBlock() {
    return __canClearBlock(
      checkBusy: true,
    );
  }

  // ***************************************************************************

  @_PrecheckMethod()
  Actionable<BlockItemEditPrecheck> canUpdateItem({
    required ITEM item,
    required ItemUpdateType updateType,
    bool checkAllow = true,
  }) {
    return __canUpdateItem(
      checkBusy: true,
      item: item,
      updateType: updateType,
      checkAllow: checkAllow,
    );
  }

  // ***************************************************************************

  @_PrecheckMethod()
  Actionable<BlockQuickItemUpdatePrecheck> canQuickUpdateItem({
    required ITEM item,
    bool checkAllow = true,
    bool errorIfItemNotInTheBlock = true,
  }) {
    return __canQuickUpdateItem(
      checkBusy: true,
      item: item,
      checkAllow: checkAllow,
      errorIfItemNotInTheBlock: errorIfItemNotInTheBlock,
    );
  }

  // ***************************************************************************

  @_PrecheckMethod()
  Actionable<BlockFormResetPrecheck> canResetForm({
    bool checkAllow = true,
  }) {
    return __canResetForm(
      checkBusy: true,
      checkAllow: checkAllow,
    );
  }

  // ***************************************************************************

  @_PrecheckMethod()
  Actionable<BlockFormSavePrecheck> canSaveForm({
    bool checkAllow = true,
    bool checkValidate = false,
  }) {
    return __canSaveForm(
      checkBusy: true,
      checkAllow: checkAllow,
      checkValidate: checkValidate,
    );
  }

  // ***************************************************************************

  @_PrecheckMethod()
  Actionable<BlockItemEditPrecheck> canEditItemOnForm({
    required ITEM item,
    bool checkAllow = true,
  }) {
    return __canEditItemOnForm(
      checkBusy: true,
      item: item,
      checkAllow: checkAllow,
    );
  }

  // ***************************************************************************

  @_PrecheckMethod()
  Actionable<BlockItemEditPrecheck> canEditCurrentItemOnForm() {
    return __canEditCurrentItemOnForm(
      checkBusy: true,
      checkAllow: true,
    );
  }

  // ***************************************************************************

  @_PrecheckMethod()
  // @seeAlso: canRefreshCurrentItem()
  Actionable<BlockSetCurrentItemPrecheck> canSetItemAsCurrent({
    required ITEM item,
  }) {
    return __canSetItemAsCurrent(
      checkBusy: true,
      item: item,
      errCodeIfItemIsNull: ErrCodeIfItemIsNull.invalidTarget,
    );
  }

  // ***************************************************************************

  ///
  /// Checks whether the current item can be refreshed.
  ///
  @_PrecheckMethod()
  // @seeAlso: canSetItemAsCurrent()
  Actionable<BlockSetCurrentItemPrecheck> canRefreshCurrentItem() {
    return __canRefreshCurrentItem(
      checkBusy: true,
    );
  }

  // ***************************************************************************

  @_PrecheckMethod()
  Actionable<ShowFormInfoPrecheck> canShowFormInfo() {
    ILoggedInUser? loggedInUser = FlutterArtist.loggedInUser;
    if (formModel == null) {
      return Actionable<ShowFormInfoPrecheck>.no(
        errCode: ShowFormInfoPrecheck.noForm,
      );
    }
    if (loggedInUser == null) {
      return Actionable<ShowFormInfoPrecheck>.no(
        errCode: ShowFormInfoPrecheck.noLoggedInUser,
      );
    }
    if (!loggedInUser.isSystemUser) {
      return Actionable<ShowFormInfoPrecheck>.no(
        errCode: ShowFormInfoPrecheck.userIsNotSystemUser,
      );
    }
    return Actionable<ShowFormInfoPrecheck>.yes();
  }

  // ***************************************************************************

  ///
  /// Edit on edit-mode
  /// Edit on creation-mode
  ///
  @_PrecheckMethod()
  Actionable<BlockFormEnablementPrecheck> isEnableFormToModify({
    bool checkAllow = true,
  }) {
    return __isEnableFormToModify(
      checkAllow: checkAllow,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  Actionable<BlockFormEnablementPrecheck> _isEnableFormToModify() {
    return __isEnableFormToModify(checkAllow: true);
  }

  // ***************************************************************************
  // ***************************************************************************

  bool hasCurrentItemAndCanEditOnForm() {
    Actionable<BlockItemEditPrecheck> actionable = __canEditCurrentItemOnForm(
      checkBusy: true,
      checkAllow: true,
    );
    return actionable.yes;
  }

  // ***************************************************************************
  // ***************************************************************************

  bool hasCurrentItemAndCanDelete() {
    if (currentItem == null) {
      return false;
    }
    Actionable<BlockItemDeletionPrecheck> actionable = __canDeleteCurrentItem(
      checkBusy: true,
      checkAllow: true,
    );
    return actionable.yes;
  }

  // ***************************************************************************
  // ***************************************************************************

  bool canShowFilterCriteria() {
    ILoggedInUser? loggedInUser = FlutterArtist.loggedInUser;
    return filterModel != null &&
        loggedInUser != null &&
        loggedInUser.isSystemUser;
  }

  // ***************************************************************************
  // ************* ITEM SELECTION/CHECK METHOD *********************************
  // ***************************************************************************

  void __updateUiComponentAfterCheckedOrSelected() {
    ui.updateAllUiComponents(
      withoutFilters: false,
      force: true,
    );
  }

  void clientSideSort({required bool refresh}) {
    __blockData._clientSideSortItems();
    if (refresh) {
      shelf.ui.updateAllUiComponents();
    }
  }

  // ***************************************************************************
  // ***** BLOCK DATA **********************************************************
  // ***************************************************************************

  int get currentItemChangeCount => __blockData._currentItemChangeCount;

  Object? get parentBlockCurrentItemId {
    return parent?.currentItemId;
  }

  ID? get currentItemId {
    return __blockData.current._id;
  }

  ITEM? get currentItem => __blockData.current._item;

  ITEM_DETAIL? get currentItemDetail => __blockData.current._itemDetail;

  int get currentItemIndex {
    ITEM? ci = currentItem;
    if (ci == null) {
      return -1;
    }
    return items.indexWhere((it) => identical(it, ci));
  }

  // ***************************************************************************
  // ***************************************************************************

  bool get isEmpty => __blockData._items.isEmpty;

  bool get isNotEmpty => __blockData._items.isNotEmpty;

  // ***************************************************************************
  // ***************************************************************************

  ///
  /// return a copied list of checked items.
  ///
  List<ITEM> get checkedItems {
    return List.unmodifiable(__blockData._checkedItems);
  }

  ///
  /// return a copied list of selected items.
  ///
  List<ITEM> get selectedItems {
    return List.unmodifiable(__blockData._selectedItems);
  }

  List<ID> get selectedItemIds {
    return selectedItems.map((item) => item.id).toList();
  }

  List<ID> get checkedItemIds {
    return checkedItems.map((item) => item.id).toList();
  }

  List<int> get selectedItemIndexes {
    final allItems = items;
    final List<ITEM> sItems = selectedItems;
    final List<int> indexes = [];
    for (var item in sItems) {
      int idx = allItems.indexWhere((it) => identical(it, item));
      indexes.add(idx);
    }
    return indexes;
  }

  // ***************************************************************************
  // ***************************************************************************

  bool isCurrentItem(ITEM item) {
    final ID? currItemId = currentItemId;
    return _getItemIdInternal(item) == currItemId;
  }

  // ***************************************************************************
  // ***************************************************************************

  bool isCurrentIndex(int index) {
    ITEM? item = findItemByIndex(index);
    if (item == null) {
      return false;
    }
    return isCurrentItem(item);
  }

  // ***************************************************************************
  // ***************************************************************************

  bool isSelectedIndex(int index) {
    ITEM? item = findItemByIndex(index);
    if (item == null) {
      return false;
    }
    return isSelectedItem(item);
  }

  // ***************************************************************************
  // ***************************************************************************

  bool isSelectedItem(ITEM item) {
    return FaItemsUtils.isListContainItem(
      targetList: __blockData._selectedItems,
      item: item,
      getItemId: _getItemIdInternal,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  bool isCurrentAndSelectedItem(ITEM item) {
    bool c = isCurrentItem(item);
    if (c) {
      return isSelectedItem(item);
    }
    return false;
  }

  // ***************************************************************************
  // ***************************************************************************

  bool isCurrentAndCheckedItem(ITEM item) {
    bool c = isCurrentItem(item);
    if (c) {
      return isCheckedItem(item);
    }
    return false;
  }

  // ***************************************************************************
  // ***************************************************************************

  bool get isCurrentItemSelected {
    ITEM? c = currentItem;
    if (c == null) {
      return false;
    }
    return isSelectedItem(c);
  }

  // ***************************************************************************
  // ***************************************************************************

  bool get isCurrentItemChecked {
    ITEM? c = currentItem;
    if (c == null) {
      return false;
    }
    return isCheckedItem(c);
  }

  // ***************************************************************************
  // ***************************************************************************

  void __setSelectedItem(ITEM item, {required bool selected}) {
    if (selected) {
      FaItemsUtils.insertOrReplaceItemInList(
        item: item,
        targetList: __blockData._selectedItems,
        getItemId: _getItemIdInternal,
      );
    } else {
      FaItemsUtils.removeItemFromList(
        removeItem: item,
        targetList: __blockData._selectedItems,
        getItemId: _getItemIdInternal,
      );
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  void __toggleSelectItem(ITEM item) {
    bool selected = isSelectedItem(item);
    __setSelectedItem(item, selected: !selected);
  }

  // ***************************************************************************
  // ***************************************************************************

  void setSelectedItem(ITEM item, {required bool selected}) {
    __setSelectedItem(item, selected: selected);
    __updateUiComponentAfterCheckedOrSelected();
  }

  // ***************************************************************************
  // ***************************************************************************

  void toggleSelectItem(ITEM item) {
    __toggleSelectItem(item);
    __updateUiComponentAfterCheckedOrSelected();
  }

  // ***************************************************************************
  // ***************************************************************************

  void __setSelectedItems({required List<ITEM> items}) {
    FaItemsUtils.insertOrReplaceItemsInList(
      items: items,
      targetList: __blockData._selectedItems,
      getItemId: _getItemIdInternal,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  ITEM? findItemByIndex(int index) {
    if (index < 0 || index >= __blockData._items.length) {
      return null;
    }
    return __blockData._items[index];
  }

  // ***************************************************************************
  // ***************************************************************************

  bool isSame({
    required ITEM? item1,
    required ITEM? item2,
  }) {
    if (item1 == null && item2 == null) {
      return true;
    }
    if (item1 != null && item2 != null) {
      final ID? id1 = _getItemIdInternal(item1);
      final ID? id2 = _getItemIdInternal(item2);
      return id1 == id2;
    }
    return false;
  }

  // ***************************************************************************
  // ***************************************************************************

  ITEM? get firstItem {
    return __blockData._items.firstOrNull;
  }

  // ***************************************************************************
  // ***************************************************************************

  ITEM? get lastItem {
    return __blockData._items.lastOrNull;
  }

  // ***************************************************************************
  // ***************************************************************************

  ///
  /// Check if the first item is current item.
  ///
  bool get isCurrentItemAtStart {
    ITEM? first = firstItem;
    ITEM? current = currentItem;
    if (first == null || current == null) {
      return false;
    }
    return _getItemIdInternal(first) == _getItemIdInternal(current);
  }

  // ***************************************************************************
  // ***************************************************************************

  ///
  /// Check if the last item is current item.
  ///
  bool get isCurrentItemAtEnd {
    ITEM? last = lastItem;
    ITEM? current = currentItem;
    if (last == null || current == null) {
      return false;
    }
    return _getItemIdInternal(last) == _getItemIdInternal(current);
  }

  // ***************************************************************************
  // ***************************************************************************

  ITEM? findNextSiblingItem({
    required ITEM item,
  }) {
    return FaItemsUtils.findNextSiblingItemInList(
      item: item,
      targetList: __blockData._items,
      getItemId: _getItemIdInternal,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  ITEM? findPreviousSiblingItem({
    required ITEM item,
  }) {
    return FaItemsUtils.findPreviousSiblingItemInList(
      item: item,
      targetList: __blockData._items,
      getItemId: _getItemIdInternal,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  ITEM? findSiblingItem({
    required ITEM item,
  }) {
    return FaItemsUtils.findSiblingItemInList(
      item: item,
      targetList: __blockData._items,
      getItemId: _getItemIdInternal,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  ITEM? findItemSameIdWith({
    required ITEM item,
  }) {
    ID id = _getItemIdInternal(item);
    return findItemById(id);
  }

  // ***************************************************************************
  // ***************************************************************************

  ITEM? findItemById(ID itemId) {
    return FaItemsUtils.findItemInListById(
      id: itemId,
      targetList: __blockData._items,
      getItemId: _getItemIdInternal,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  ///
  /// The next item of the current item.
  /// Return null if no current item or the current item is the last item.
  ///
  ITEM? get nextSiblingItem {
    if (currentItem == null) {
      return null;
    }
    return findNextSiblingItem(item: currentItem!);
  }

  // ***************************************************************************
  // ***************************************************************************

  ///
  /// The previous item of the current item.
  /// Return null if no current item or the current item is the first item.
  ///
  ITEM? get previousSiblingItem {
    if (currentItem == null) {
      return null;
    }
    return findPreviousSiblingItem(item: currentItem!);
  }

  // ***************************************************************************
  // ***************************************************************************

  bool containsItem(ITEM item) {
    return FaItemsUtils.isListContainItem(
      targetList: __blockData._items,
      item: item,
      getItemId: _getItemIdInternal,
    );
  }

  bool isCheckedItem(ITEM item) {
    return FaItemsUtils.isListContainItem(
      targetList: __blockData._checkedItems,
      item: item,
      getItemId: _getItemIdInternal,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  bool isCheckedIndex(int index) {
    ITEM? item = findItemByIndex(index);
    if (item == null) {
      return false;
    }
    return isCheckedItem(item);
  }

  // ***************************************************************************
  // ***************************************************************************

  void __setCheckedItem(ITEM item, {required bool checked}) {
    if (checked) {
      FaItemsUtils.insertOrReplaceItemInList(
        item: item,
        targetList: __blockData._checkedItems,
        getItemId: _getItemIdInternal,
      );
    } else {
      FaItemsUtils.removeItemFromList(
        removeItem: item,
        targetList: __blockData._checkedItems,
        getItemId: _getItemIdInternal,
      );
    }
  }

  void __toggleCheckItem(ITEM item) {
    bool checked = isCheckedItem(item);
    __setCheckedItem(item, checked: !checked);
  }

  void toggleCheckItem(ITEM item) {
    __toggleCheckItem(item);
    __updateUiComponentAfterCheckedOrSelected();
  }

  void setCheckedItem(ITEM item, {required bool checked}) {
    __setCheckedItem(item, checked: checked);
    __updateUiComponentAfterCheckedOrSelected();
  }

  // ***************************************************************************
  // ***************************************************************************

  void __setCheckedItems(List<ITEM> items) {
    FaItemsUtils.insertOrReplaceItemsInList(
      items: items,
      targetList: __blockData._checkedItems,
      getItemId: _getItemIdInternal,
    );
  }

  void setCheckedItems(List<ITEM> items) {
    __setCheckedItems(items);
    __updateUiComponentAfterCheckedOrSelected();
  }

  void checkAllItems() {
    __setCheckedItems(__blockData._items);
    __updateUiComponentAfterCheckedOrSelected();
  }

  // ***************************************************************************
  // ***************************************************************************

  void setSelectedItems(List<ITEM> items) {
    __setSelectedItems(items: items);
    __updateUiComponentAfterCheckedOrSelected();
  }

  // ***************************************************************************
  // ***************************************************************************

  void uncheckAllItems() {
    __blockData._checkedItems.clear();
    __updateUiComponentAfterCheckedOrSelected();
  }

  // ***************************************************************************
  // ***************************************************************************

  void __selectAllItems() {
    __setSelectedItems(items: __blockData._items);
  }

  void selectAllItems() {
    __selectAllItems();
    __updateUiComponentAfterCheckedOrSelected();
  }

  // ***************************************************************************
  // ***************************************************************************

  void deselectAllItems() {
    __blockData._selectedItems.clear();
    __updateUiComponentAfterCheckedOrSelected();
  }

  // ***************************************************************************
  // ***************************************************************************

  bool get hasPreviousItem => previousSiblingItem != null;

  // ***************************************************************************
  // ***************************************************************************

  bool get hasNextItem => nextSiblingItem != null;

  // ***************************************************************************
  // ***************************************************************************
  // ***************************************************************************

  bool __checkBeforeChangeTheItemPositionManually() {
    if (config.clientSideSortStrategy != SortStrategy.manual) {
      showErrorSnackBar(
        message: "Can not change the position",
        errorDetails: [
          "You need to set block.config.clientSideSortStrategy to ${SortStrategy.manual}"
        ],
      );
      return false;
    }
    return true;
  }

  // bool swapItemsByIndexes({required int index1, required int index2}) {
  //   if (!__checkBeforeChangeTheItemPositionManually()) {
  //     return false;
  //   }
  //   if (index1 >= 0 &&
  //       index1 < itemCount &&
  //       index2 >= 0 &&
  //       index2 < itemCount) {
  //     ITEM it1 = __blockData._items[index1];
  //     ITEM it2 = __blockData._items[index2];
  //     //
  //     __blockData._items[index1] = it2;
  //     __blockData._items[index2] = it1;
  //     return true;
  //   }
  //   return false;
  // }

  // ***************************************************************************
  // ***************************************************************************

  bool swapPositions({required ITEM item1, required ITEM item2}) {
    if (!__checkBeforeChangeTheItemPositionManually()) {
      return false;
    }
    bool success = FaItemsUtils.swapPositionsByIds(
      itemId1: _getItemIdInternal(item1),
      itemId2: _getItemIdInternal(item2),
      targetList: __blockData._items,
      getItemId: _getItemIdInternal,
    );
    if (success) {
      ui.updateAllUiComponents(withoutFilters: true);
    }
    return success;
  }

  // ***************************************************************************
  // ***************************************************************************

  bool moveItemToNewIndexPosition({
    required ITEM item,
    required int newIndexPosition,
  }) {
    if (!__checkBeforeChangeTheItemPositionManually()) {
      return false;
    }
    bool success = FaItemsUtils.moveItemToNewIndexPosition(
      item: item,
      newIndexPosition: newIndexPosition,
      targetList: __blockData._items,
      getItemId: _getItemIdInternal,
    );
    if (success) {
      ui.updateAllUiComponents(withoutFilters: true);
    }
    return success;
  }

  // ***************************************************************************
  // ***************************************************************************

  _ProcessedQueryResult<ID, ITEM, FILTER_CRITERIA> __processQueryResult({
    required XFilterCriteria<FILTER_CRITERIA>? usedXFilterCriteria,
    required Pageable? usedPageable,
    //
    required PageData<ITEM>? queriedPageData,
    required DataState newBlockDataState,
    required ActionResultState queryResultState,
  }) {
    final PageData<ITEM> ap = queriedPageData ?? DefaultPageData<ITEM>.empty();
    final List<ITEM> queriedItems = ap.items;
    //
    final List<ITEM> validItems = [];
    final List<ITEM> invalidItems = [];
    final List<ITEM> errorItems = [];
    ErrorInfo? errorInfo;
    //
    final Object? parentBlkCurrItemId = parentBlockCurrentItemId;
    if (parentBlkCurrItemId == null) {
      validItems.addAll(queriedItems);
    } else {
      if (config.enforceParentLinkConstraint) {
        for (var item in queriedItems) {
          try {
            Object parentBlkItemId = resolveParentBlockItemId(item: item);
            if (parentBlkItemId == parentBlkCurrItemId) {
              validItems.add(item);
            } else {
              invalidItems.add(item);
            }
          } catch (e, stackTrace) {
            errorInfo ??= _handleError(
              shelf: shelf,
              methodName: "resolveParentBlockItemId",
              error: e,
              stackTrace: stackTrace,
              showSnackBar: true,
              tipDocument: TipDocument.blockResolveParentBlockItemId,
            );
            errorItems.add(item);
          }
        }
      } else {
        validItems.addAll(queriedItems);
      }
    }
    //
    if (errorInfo == null) {
      if (invalidItems.isNotEmpty) {
        _handleWarning(
          shelf: shelf,
          methodName: "resolveParentBlockItemId",
          warningMessage:
              '${queriedItems.length} items were just queried (${getClassNameWithoutGenerics(this)}). '
              '${errorItems.length} items failed during the validation process, '
              'and ${invalidItems.length} items did not match the current item of the parent block.',
          stackTrace: null,
          showSnackBar: true,
          tipDocument: TipDocument.blockResolveParentBlockItemId,
        );
      }
    }
    //
    return _ProcessedQueryResult(
      parentBlockCurrentItemId: parentBlockCurrentItemId,
      usedXFilterCriteria: usedXFilterCriteria,
      usedPageable: usedPageable,
      //
      queriedPageData: queriedPageData,
      queryResultState: queryResultState,
      newBlockDataState: newBlockDataState,
      //
      validItems: validItems,
      invalidItems: invalidItems,
      errorItems: errorItems,
      errorInfo: errorInfo,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  void __refreshQueryingState({required bool isQuerying}) {
    try {
      __isQuerying = isQuerying;
      ui.updateControlBars(force: true);
    } catch (e) {}
  }

  // ***************************************************************************
  // ***************************************************************************

  void __refreshDeletingState({required bool isDeleting}) {
    try {
      __isDeleting = isDeleting;
      ui.updateControlBars(force: true);
    } catch (e) {}
  }

  // ***************************************************************************
  // ***************************************************************************

  void _refreshSavingState({required bool isSaving}) {
    try {
      __isSaving = isSaving;
      ui.updateControlBars(force: true);
    } catch (e) {}
  }

  // ***************************************************************************
  // ***************************************************************************

  void __refreshRefreshingCurrentItemState({
    required bool isRefreshingCurrentItem,
  }) {
    try {
      __isRefreshingCurrentItem = isRefreshingCurrentItem;
      ui.updateControlBars(force: true);
    } catch (e) {}
  }

  // ***************************************************************************
  // ***************************************************************************

  void __refreshPreparingFormCreationState({
    required bool isPreparingFormCreation,
  }) {
    try {
      __isPreparingFormCreation = isPreparingFormCreation;
      ui.updateControlBars(force: true);
    } catch (e) {}
  }

  // ***************************************************************************
  // ***************************************************************************

  bool moveItemByIndexPosition({
    required int oldIndexPosition,
    required int newIndexPosition,
  }) {
    if (!__checkBeforeChangeTheItemPositionManually()) {
      return false;
    }
    bool success = FaItemsUtils.moveItemByIndexPosition(
      oldIndexPosition: oldIndexPosition,
      newIndexPosition: newIndexPosition,
      targetList: __blockData._items,
      getItemId: _getItemIdInternal,
    );
    if (success) {
      ui.updateAllUiComponents(withoutFilters: true);
    }
    return success;
  }

  // ***************************************************************************
  // ***************************************************************************

  BlockItemDeletionResult<ITEM> _createEmptyItemDeletionResult() {
    return BlockItemDeletionResult<ITEM>(candidateItem: null);
  }

  BlockItemsDeletionResult<ITEM> _createEmptyItemsDeletionResult({
    required List<ITEM> candidateItems,
  }) {
    return BlockItemsDeletionResult<ITEM>(candidateItems: candidateItems);
  }

  PrepareItemCreationResult _createEmptyItemCreationResult() {
    return PrepareItemCreationResult();
  }

  // ***************************************************************************
  // ***************************************************************************

  Future<void> showDebugFilterCriteriaViewerDialog() async {
    BuildContext context = FlutterArtistCore.context;
    //
    await DebugViewerDialog.openDebugFilterCriteriaInspector(
      context: context,
      locationInfo: '',
      filterModel: registeredOrDefaultFilterModel,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  String _debugItemTypeHtml() {
    return "<b>${getItemType()}</b>";
  }

  String _debugItemDetailTypeHtml() {
    return "<b>${getItemDetailType()}</b>";
  }

  // ***************************************************************************
  // ***************************************************************************
  // ***************************************************************************

  void __assertThisXBlock(XBlock thisXBlock) {
    if (thisXBlock.block != this || thisXBlock.name != name) {
      String message = "Error Assert block: ${thisXBlock.block} - $this";
      print("FATAL ERROR: $message");
      throw message;
    }
  }
}
