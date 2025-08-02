part of '../core.dart';

///
/// Block example:
/// ```dart
/// class EmployeeBlock
///       extends Block<int, EmployeeInfo, EmployeeData,
///                     EmptyFilerInput, EmptyFilterCriteria, EmptyExtraFormInput> {
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
/// via the [FilterModel.toFilterCriteriaObject] method
/// and passed to the [Block.callApiQuery] or [Scalar.callApiQuery] method.
/// ```
/// class EmployeeFilterCriteria extends FilterCriteria {
///    String? searchText,
///    DepartmentInfo? department;
/// }
/// ```
///
/// [EXTRA_FORM_INPUT]: Additional form data are used to create a record in the Form.
/// For example: Create an employee with the specified department.
/// ```
/// class EmployeeExtraFormInput extends ExtraFormInput {
///    DepartmentInfo? department;
/// }
/// ```
///
abstract class Block<
    ID extends Object,
    ITEM extends Object,
    ITEM_DETAIL extends Object,
    FILTER_INPUT extends FilterInput, // EmptyFilterInput
    FILTER_CRITERIA extends FilterCriteria, // EmptyFilterCriteria
    EXTRA_FORM_INPUT extends ExtraFormInput // EmptyExtraFormInput
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
        "${getFilterInputType()}, ${getFilterCriteriaType()}, ${getExtraFormInputType()}>";
  }

  final String? description;

  ///
  /// FilterModel Name registered in [Shelf.registerStructure()] method.
  ///
  final String? registerFilterModelName;

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
  /// Returns a FilterModel declared in the [Shelf.registerStructure()] method.
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

  final FormModel<
      ID, //
      ITEM_DETAIL,
      FILTER_CRITERIA,
      EXTRA_FORM_INPUT>? formModel;

  final List<Block> _childBlocks;

  List<Block> get childBlocks => [..._childBlocks];

  List<Block> get descendantBlocks {
    List<Block> ret = [];
    for (Block childBlock in _childBlocks) {
      ret.add(childBlock);
      ret.addAll(childBlock.descendantBlocks);
    }
    return ret;
  }

  List<Block> get ancestorBlocks {
    return ascendingAncestorBlocks.reversed.toList();
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

  int __callApiLoadItemDetailByIdCount = 0;

  int get callApiLoadItemDetailByIdCount => __callApiLoadItemDetailByIdCount;

  int __callApiQueryCount = 0;

  int get callApiQueryCount => __callApiQueryCount;

  QueryType __lastQueryType = QueryType.realQuery;

  QueryType get lastQueryType => __lastQueryType;

  late final __blockData = _BlockData<
      ID, //
      ITEM,
      ITEM_DETAIL,
      FILTER_INPUT,
      FILTER_CRITERIA,
      EXTRA_FORM_INPUT>._(
    this,
    config.pageable,
  );

  BlockErrorInfo? _blockErrorInfo;

  BlockErrorInfo? get blockErrorInfo => _blockErrorInfo;

  late final _BlockUIComponents ui = _BlockUIComponents(block: this);

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

  DataState get queryDataState => __blockData._queryDataState;

  DataState get selectionDataState => __blockData._selectionDataState;

  // nearestAncestorNonNoneQueryDataState?
  DataState get ancestralNonNoneQueryDataState {
    if (parent == null) {
      return DataState.ready;
    }
    if (parent!.queryDataState != DataState.none) {
      return parent!.queryDataState;
    }
    return parent!.ancestralNonNoneQueryDataState;
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

  final ItemSortCriteria? _itemSortCriteria;

  ItemSortCriteria? get itemSortCriteria => _itemSortCriteria;

  FILTER_CRITERIA? get filterCriteria => __blockData._filterCriteria;

  int get filterCriteriaChangeCount => __blockData._filterCriteriaChangeCount;

  ///
  /// return a copied list of items.
  ///
  List<ITEM> get items {
    return [...__blockData._items];
  }

  int get itemCount => __blockData._items.length;

  PageableData? get pageable => __blockData._pageable;

  PageableData? get nextPageable {
    if (lastQueryType == QueryType.emptyQuery) {
      return __blockData._initialPageable;
    }
    PageableData? p = __blockData._pageable;
    return p?.next();
  }

  PaginationData? get pagination {
    return PaginationData.copy(__blockData._pagination);
  }

  void setToPending() {
    __blockData._setToPending();
  }

  // ***************************************************************************
  // ***************************************************************************

  Block({
    required this.name,
    required this.description,
    required BlockConfig config,
    required String? filterModelName,
    required this.formModel,
    required List<Block>? childBlocks,
    ItemSortCriteria<ITEM>? itemSortCriteria,
  })  : registerFilterModelName = filterModelName,
        config = config.copy(),
        _itemSortCriteria = itemSortCriteria,
        _childBlocks = childBlocks ?? [] {
    itemSortCriteria?.block = this;
    for (Block childBlock in _childBlocks) {
      childBlock.parent = this;
    }
    if (formModel != null) {
      formModel!.block = this;
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  List<Type> _getBroadcastDataTypes() {
    return config.outsideBroadcastEvents?.toSet().toList() ?? [];
  }

  List<Type> getOutsideDataTypesToListen() {
    List<Type> itemTypes = [];
    //
    itemTypes.addAll(config.refreshCurrItemByExternalShelfEvents ?? []);
    itemTypes.addAll(config.reQueryByExternalShelfEvents ?? []);
    //
    return itemTypes.toSet().toList();
  }

  // ***************************************************************************
  // ***************************************************************************

  void __clearItemsWithDataState({
    required _XBlock thisXBlock,
    required DataState queryDataState,
    required DataState formDataState,
    required bool errorInFilter,
  }) {
    __assertThisXBlock(thisXBlock);
    //
    __blockData._clearItemsWithDataState(
      qryDataState: queryDataState,
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
    required _XBlock thisXBlock,
    required DataState qryDataState,
    required DataState frmDataState,
    required bool errorInFilter,
  }) {
    __assertThisXBlock(thisXBlock);
    //
    __clearItemsWithDataState(
      thisXBlock: thisXBlock,
      queryDataState: qryDataState,
      formDataState: frmDataState,
      errorInFilter: errorInFilter,
    );
    //
    for (var childXBlock in thisXBlock.childXBlocks) {
      childXBlock.block.__clearWithDataStateAndChildrenToNonCascade(
        thisXBlock: childXBlock,
        qryDataState: DataState.none,
        frmDataState: DataState.none,
        errorInFilter: false,
      );
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  void __clearAllChildrenBlocksToReady({
    required _XBlock thisXBlock,
  }) {
    __assertThisXBlock(thisXBlock);
    //
    for (var childXBlock in thisXBlock.childXBlocks) {
      childXBlock.block.__clearWithDataStateAndChildrenToNonCascade(
        thisXBlock: childXBlock,
        qryDataState: DataState.ready,
        frmDataState: DataState.none,
        errorInFilter: false,
      );
    }
  }

  void __clearAllChildrenBlocksToNone({
    required _XBlock thisXBlock,
  }) {
    __assertThisXBlock(thisXBlock);
    //
    for (var childXBlock in thisXBlock.childXBlocks) {
      childXBlock.block.__clearWithDataStateAndChildrenToNonCascade(
        thisXBlock: childXBlock,
        qryDataState: DataState.none,
        frmDataState: DataState.none,
        errorInFilter: false,
      );
    }
  }

  void __clearAllChildrenBlocksToPending({
    required _XBlock thisXBlock,
  }) {
    __assertThisXBlock(thisXBlock);
    //
    for (var childXBlock in thisXBlock.childXBlocks) {
      childXBlock.block.__clearWithDataStateAndChildrenToNonCascade(
        thisXBlock: childXBlock,
        qryDataState: DataState.pending,
        frmDataState: DataState.pending,
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

  Type getExtraFormInputType() {
    return EXTRA_FORM_INPUT;
  }

  // ***************************************************************************
  // ************ Need to Query State ******************************************
  // ***************************************************************************

  bool _needToQuery() {
    if (queryDataState != DataState.ready) {
      return true;
    }
    //
    Object? parentInData = __blockData._currentParentItemId;
    Object? parentInBlock = parentItemId;
    if (parentInData != parentInBlock) {
      return true;
    }
    //
    if (filterModel != null) {
      FilterCriteria? criteriaInFilter = filterModel!.filterCriteria;
      FilterCriteria? criteriaInData = this.filterCriteria;
      if (criteriaInFilter != criteriaInData) {
        return true;
      }
    }
    //
    return false;
  }

  // ***************************************************************************
  // ***************************************************************************

  void _fireBlockHidden() {
    FlutterArtist.codeFlowLogger._addEvent(
      ownerClassInstance: this,
      event: "Block '${getClassName(this)}' just hides all UI Components!",
      isLibCode: true,
    );
    if (config.hiddenBehavior == BlockHiddenBehavior.clear) {
      Future.delayed(
        const Duration(seconds: 0),
        () {
          this.clear();
        },
      );
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  void _executeNavigation({Function()? navigate}) {
    try {
      if (navigate != null) {
        navigate();
      }
    } catch (e, stackTrace) {
      print(stackTrace);
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  @_TaskUnitMethodAnnotation()
  @_BlockClearCurrentAnnotation()
  Future<void> _unitClearCurrent({required _XBlock thisXBlock}) async {
    __assertThisXBlock(thisXBlock);
    //
    this.__setCurrentItem(item: null, itemDetail: null);
    if (formModel != null) {
      formModel!._clearDataWithDataState(formDataState: DataState.none);
    }
    // Test Case: [38b].
    this.__clearAllChildrenBlocksToNone(
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
  Future<BlockQueryResult> _unitQuery({required _XBlock thisXBlock}) async {
    __assertThisXBlock(thisXBlock);
    //
    bool hasActiveUI = this.ui.hasActiveUIComponent(alsoCheckChildren: true);
    bool forceQuery = thisXBlock.forceQuery;
    if (!forceQuery) {
      if (this.queryDataState != DataState.ready && hasActiveUI) {
        forceQuery = true;
      }
    }
    //
    thisXBlock._printParameters(hasActiveUI: hasActiveUI);
    //
    final callApiQueryMethod = BlockErrorMethod.callApiQuery;
    DataState newQueryDataState = this.queryDataState;
    PageData<ITEM>? pageData;
    final ITEM? candidateCurrentItem;
    if (forceQuery) {
      //
      // thisXBlock.forceQuery || (hasActiveUI && this.queryDataState != DataState.ready)
      //
      FILTER_CRITERIA? filterCriteriaOfFilterModel;
      try {
        final _XFilterModel xFilterModel = thisXBlock.xFilterModel;
        final FilterModel filterModel = xFilterModel.filterModel;
        //
        if (!xFilterModel.queried) {
          FILTER_INPUT? filterInput = xFilterModel.filterInput as FILTER_INPUT?;
          //
          filterCriteriaOfFilterModel =
              await filterModel._startNewFilterActivity(
            activityType: FilterActivityType.newFilt,
            filterInput: filterInput,
          ) as FILTER_CRITERIA?;
          //
          xFilterModel.queried = true;
        } else {
          filterCriteriaOfFilterModel =
              filterModel._filterCriteria! as FILTER_CRITERIA;
        }
      } catch (e, stackTrace) {
        // @@TODO@@ 12 Test.
        print("ERROR _unitQuery: $stackTrace");
        /* Never Error */
      }
      //
      // Has Error in FilterModel.
      //
      if (filterCriteriaOfFilterModel == null) {
        // Test Cases: [23a].
        // Set Block to error cascade.
        __clearWithDataStateAndChildrenToNonCascade(
          thisXBlock: thisXBlock,
          qryDataState: DataState.error,
          frmDataState: DataState.none,
          errorInFilter: true,
        );
        thisXBlock.queryResult._setFilterError();
        return thisXBlock.queryResult;
      }
      //
      // Ready FilterCriteria:
      //
      final bool parentOrCriteriaChanged =
          __blockData._isParentOrFilterCriteriaChanged(
        newCurrentParentItemId: parentItemId,
        newFilterCriteria: filterCriteriaOfFilterModel,
      );
      //
      ActionResultState queryResultState;
      AppError? appError;
      //
      ListBehavior realListBehavior;
      //
      final PageableData? callingPageable;
      //
      if (thisXBlock.queryType == QueryType.realQuery) {
        callingPageable = thisXBlock.pageable ?? config.pageable;
        final QueryType newQueryType = thisXBlock.queryType;
        final queryTypeChanged = __lastQueryType != newQueryType;
        __lastQueryType = newQueryType;
        //
        // Call Query API:
        //
        try {
          __clearBlockError();
          __refreshQueryingState(isQuerying: true);
          //
          FlutterArtist.codeFlowLogger._addMethodCall(
            isLibCode: false,
            navigate: null,
            ownerClassInstance: this,
            methodName: callApiQueryMethod.name,
            parameters: {},
          );
          //
          __callApiQueryCount++;
          ApiResult<PageData<ITEM>?> result = await callApiQuery(
            parentBlockCurrentItem: parent?.currentItem,
            filterCriteria: filterCriteriaOfFilterModel,
            pageable: callingPageable,
          );
          // Throw ApiError:
          result.throwIfError();
          //
          queryResultState = ActionResultState.success;
          pageData = result.data;
        } catch (e, stackTrace) {
          queryResultState = ActionResultState.fail;
          pageData = null;
          //
          final blockErrorInfo = BlockErrorInfo(
            queryDataState: queryDataState,
            blockErrorMethod: callApiQueryMethod,
            error: e, // AppError, ApiError or others.
            errorStackTrace: stackTrace,
          );
          __setBlockErrorInfo(blockErrorInfo);
          //
          appError = _handleError(
            shelf: shelf,
            methodName: callApiQueryMethod.name,
            // AppError, ApiError or others.
            error: e,
            stackTrace: stackTrace,
            showSnackBar: true,
          );
          thisXBlock.queryResult._setAppError(
            appError: appError,
            stackTrace: appError is ApiError ? null : stackTrace,
          );
        } finally {
          __refreshQueryingState(isQuerying: false);
        }
        //
        if (queryResultState == ActionResultState.fail) {
          // Query Error + Parent or Criteria changed.
          if (parentOrCriteriaChanged) {
            switch (queryDataState) {
              case DataState.ready:
                // @FaCode-002.
                // Test Case: [42a].
                // Replace by empty items.
                realListBehavior = ListBehavior.replace;
                newQueryDataState = DataState.error;
              case DataState.pending:
                // Replace by empty items.
                realListBehavior = ListBehavior.replace;
                newQueryDataState = DataState.error;
              case DataState.error:
                // @FaCode-003.
                // Test Case: [42a].
                // Replace by empty items.
                realListBehavior = ListBehavior.replace;
                newQueryDataState = DataState.error;
              case DataState.none:
                // Replace by empty items.
                realListBehavior = ListBehavior.replace;
                newQueryDataState = DataState.error;
            }
          }
          // Query Error + Parent not changed + Criteria not changed.
          // Test Case: [42a].
          else {
            switch (queryDataState) {
              case DataState.ready:
                // Append empty items (No items got from Server).
                // Test Case: [42a].
                // @FaCode-001.
                realListBehavior = ListBehavior.append;
                newQueryDataState = DataState.ready;
              case DataState.pending:
                // Replace by empty items.
                realListBehavior = ListBehavior.replace;
                newQueryDataState = DataState.error;
              case DataState.error:
                // @FaCode-004.
                // Replace by empty items.
                realListBehavior = ListBehavior.replace;
                newQueryDataState = DataState.error;
              case DataState.none:
                // Replace by empty items.
                realListBehavior = ListBehavior.replace;
                newQueryDataState = DataState.error;
            }
          }
        }
        // Query Successful:
        else {
          // Query Successful + Parent or Criteria changed.
          if (parentOrCriteriaChanged) {
            switch (queryDataState) {
              case DataState.ready:
                // Replace.
                realListBehavior = ListBehavior.replace;
                newQueryDataState = DataState.ready;
              case DataState.pending:
                // Replace.
                realListBehavior = ListBehavior.replace;
                newQueryDataState = DataState.ready;
              case DataState.error:
                // Replace.
                realListBehavior = ListBehavior.replace;
                newQueryDataState = DataState.ready;
              case DataState.none:
                // Replace.
                realListBehavior = ListBehavior.replace;
                newQueryDataState = DataState.ready;
            }
          }
          // Query Successful + Parent not changed + Criteria not changed.
          else {
            switch (queryDataState) {
              case DataState.ready:
                // Replace or Append:
                realListBehavior = thisXBlock.listBehavior;
                newQueryDataState = DataState.ready;
              case DataState.pending:
                // Replace.
                realListBehavior = ListBehavior.replace;
                newQueryDataState = DataState.ready;
              case DataState.error:
                // Replace.
                realListBehavior = ListBehavior.replace;
                newQueryDataState = DataState.ready;
              case DataState.none:
                // Replace.
                realListBehavior = ListBehavior.replace;
                newQueryDataState = DataState.ready;
            }
          }
        }
        if (queryTypeChanged) {
          // Replace:
          realListBehavior = ListBehavior.replace;
        }
      }
      // Query Empty:
      else {
        callingPageable = __blockData._emptyPageable;
        __lastQueryType = thisXBlock.queryType;
        realListBehavior = ListBehavior.replace;
        newQueryDataState = DataState.ready;
        pageData = PageData.empty<ITEM>();
        queryResultState = ActionResultState.success;
      }
      //
      //
      final ITEM? currentItem = this.currentItem;
      try {
        //
        // Update queried items to the List:
        //
        __blockData._updateFrom(
          forceListBehavior: realListBehavior,
          currentParentItemId: this.parentItemId,
          filterCriteria: filterCriteriaOfFilterModel,
          pageable: callingPageable,
          pageData: pageData,
          queryDataState: newQueryDataState,
          queryResultState: queryResultState,
        );
      } catch (e, stackTrace) {
        AppError appError = _handleError(
          shelf: shelf,
          methodName: '__blockData._updateFrom()',
          error: e,
          stackTrace: stackTrace,
          showSnackBar: true,
        );
        thisXBlock.queryResult._setAppError(
          appError: appError,
          stackTrace: stackTrace,
        );
        return thisXBlock.queryResult;
      }
      //
      final bool currentItemInList =
          currentItem != null && containsItem(item: currentItem);
      candidateCurrentItem = currentItemInList ? currentItem : null;
      //
      if (!currentItemInList) {
        __blockData._setCurrentItemOnly(
          refreshedItem: null,
          refreshedItemDetail: null,
        );
        //
        if (formModel != null) {
          formModel!._clearDataWithDataState(formDataState: DataState.none);
        }
        // (Currently, In _unitQuery && forceQuery).
        // Test Case: [42a].
        this.__clearAllChildrenBlocksToNone(
          thisXBlock: thisXBlock,
        );
      }
      // currentItemInList.
      else {
        switch (newQueryDataState) {
          case DataState.none:
            // @@TODO@@ 04.
            // Never run:
            this.__clearAllChildrenBlocksToNone(
              thisXBlock: thisXBlock,
            );
          case DataState.pending:
            // @@TODO@@ 05.
            // Never run:
            this.__clearAllChildrenBlocksToNone(
              thisXBlock: thisXBlock,
            );
          case DataState.error:
            // @@TODO@@ 06.
            this.__clearAllChildrenBlocksToNone(
              thisXBlock: thisXBlock,
            );
          case DataState.ready:
            break;
        }
      }
    }
    // forceQuery == false.
    else {
      print("        ~~~~~~~> IGNORED --> forceQuery: $forceQuery - [$name]");
      candidateCurrentItem = null;
    }
    //
    // Add TaskUnit:
    // - Find Item to Select as Current:
    //
    if (thisXBlock.postQueryBehavior == PostQueryBehavior.clearCurrentItem) {
      FlutterArtist.taskUnitQueue.addTaskUnit(
        _BlockClearCurrentTaskUnit<ITEM>(
          xBlock: thisXBlock,
        ),
      );
    } else if (thisXBlock.postQueryBehavior ==
        PostQueryBehavior.createNewItem) {
      FlutterArtist.taskUnitQueue.addTaskUnit(
        _BlockPrepareFormToCreateItemTaskUnit(
          xBlock: thisXBlock,
          initDirty: false,
          extraFormInput: null,
          navigate: null,
        ),
      );
    } else {
      // If "Lazy Load" is natural, and Form in "creation" mode
      //  ==> Do not "select an item as current".
      if (thisXBlock.xShelf.naturalMode && formMode == FormMode.creation) {
        // Do nothing.
        // Test Case: com-dept-emp38b.
      } else {
        final CurrentItemSelectionType currentItemSelectionType;
        switch (thisXBlock.postQueryBehavior) {
          case PostQueryBehavior.selectAnItemAsCurrentIfNeed:
            currentItemSelectionType =
                CurrentItemSelectionType.selectAnItemAsCurrentIfNeed;
          case PostQueryBehavior.selectAnItemAsCurrent:
            currentItemSelectionType =
                CurrentItemSelectionType.selectAnItemAsCurrent;
          case PostQueryBehavior.selectAnItemAsCurrentAndLoadForm:
            currentItemSelectionType =
                CurrentItemSelectionType.selectAnItemAsCurrentAndLoadForm;
          case PostQueryBehavior.clearCurrentItem:
            throw UnimplementedError("Never Run");
          case PostQueryBehavior.createNewItem:
            throw UnimplementedError("Never Run");
        }
        //
        FlutterArtist.taskUnitQueue.addTaskUnit(
          _BlockSelectAsCurrentTaskUnit<ITEM>(
            currentItemSelectionType: currentItemSelectionType,
            xBlock: thisXBlock,
            newQueriedList: pageData?.items ?? [],
            candidateItem: candidateCurrentItem,
            forceReloadItem: false,
            forceTypeForForm: null,
          ),
        );
      }
    }
    return thisXBlock.queryResult;
  }

  // ***************************************************************************
  // ***************************************************************************

  @_TaskUnitMethodAnnotation()
  @_FormModelLoadFormAnnotation()
  @_BlockRefreshCurrentItemAnnotation()
  @_BlockSelectItemAsCurrentAnnotation()
  @_BlockRefreshAndSelectNextItemAsCurrentAnnotation()
  @_BlockRefreshAndSelectFirstItemAsCurrentAnnotation()
  @_BlockRefreshAndSelectPreviousItemAsCurrentAnnotation()
  Future<void> _unitSelectItemAsCurrent({
    required _XBlock thisXBlock,
    required CurrentItemSelectionType currentItemSelectionType,
    required List<ITEM> newQueriedList,
    required ITEM? candidateItem,
    required BlockItemCurrSelectionResult<ITEM> currentItemSelectionResult,
  }) async {
    __assertThisXBlock(thisXBlock);
    //
    formModel?._formPropsStructure._setManualDirty(false);
    //
    // if (thisXBlock.currentItemSelectionResult == null) {
    //   thisXBlock.currentItemSelectionResult =
    //       BlockItemCurrSelectionResult<ITEM>(
    //     precheck: null,
    //     currentItemSelectionType: currentItemSelectionType,
    //     getItemId: getItemId,
    //     candidateItem: candidateItem,
    //     oldCurrentItem: this.currentItem,
    //     currentItem: this.currentItem,
    //   );
    // } else {
    //   thisXBlock.currentItemSelectionResult!._addCandidateItem(
    //     candidateItem,
    //   );
    // }
    // var result = thisXBlock.currentItemSelectionResult!;

    currentItemSelectionResult._addCandidateItem(
      candidateItem,
    );
    //
    if (queryDataState == DataState.pending) {
      this.__clearWithDataStateAndChildrenToNonCascade(
        thisXBlock: thisXBlock,
        qryDataState: queryDataState,
        frmDataState: DataState.none,
        errorInFilter: false,
      );
      return;
    }
    //
    if (this.queryDataState == DataState.error) {
      print(
          "        ~~~~~~~> IGNORED --> this.queryDataState == DataState.error - [$name]");
      this.__clearWithDataStateAndChildrenToNonCascade(
        thisXBlock: thisXBlock,
        qryDataState: DataState.error,
        frmDataState: DataState.none,
        errorInFilter: false,
      );
      return;
    }
    //
    if (this.itemCount == 0) {
      print("        ~~~~~~~> IGNORED --> this.itemCount == 0 - [$name]");
      // @@TODO@@ 07.
      this.__clearAllChildrenBlocksToNone(
        thisXBlock: thisXBlock,
      );
      return;
    }
    //
    ITEM? candidateCurrentItem = candidateItem;
    //
    if (candidateCurrentItem != null) {
      if (!containsItem(item: candidateCurrentItem)) {
        candidateCurrentItem = null;
      }
    }
    //
    final ITEM? currentItemOrigin = this.currentItem;
    final ITEM? currentItem;
    if (currentItemOrigin != null) {
      if (containsItem(item: currentItemOrigin)) {
        currentItem = currentItemOrigin;
      } else {
        currentItem = null;
      }
    } else {
      currentItem = null;
    }
    //
    final bool currentItemChanged;
    if (currentItem == null) {
      int? suggestIdx = specifyItemIndexToSelectAsCurrent();
      if (suggestIdx != null && suggestIdx >= 0 && suggestIdx < itemCount) {
        candidateCurrentItem = candidateCurrentItem ?? items[suggestIdx];
      }
      candidateCurrentItem = candidateCurrentItem ?? firstItem;
      currentItemChanged = candidateCurrentItem != null;
    }
    // currentItem != null
    else {
      if (candidateCurrentItem == null) {
        candidateCurrentItem = currentItem;
        currentItemChanged = false;
      } else {
        // candidateCurrentItem != null && currentItem != null
        if (getItemId(candidateCurrentItem) == getItemId(currentItem)) {
          currentItemChanged = false;
        } else {
          currentItemChanged = true;
        }
      }
    }
    //
    // If no item can be current.
    //
    if (candidateCurrentItem == null) {
      print("        ~~~~~~~> candidateCurrentItem == null - [$name]");
      this.__clearWithDataStateAndChildrenToNonCascade(
        thisXBlock: thisXBlock,
        qryDataState: DataState.ready,
        frmDataState: DataState.none,
        errorInFilter: false,
      );
      return;
    }
    //
    // Now candidateCurrentItem != null.
    //
    final bool isSameCandidateItem = isSame(
      item1: candidateItem,
      item2: candidateCurrentItem,
    );
    if (!isSameCandidateItem) {
      currentItemSelectionResult._addCandidateItem(candidateCurrentItem);
    }
    //
    final bool isCandidateCurrentItemInNewQueriedList =
        ItemsUtils.isListContainItem(
      targetList: newQueriedList,
      item: candidateCurrentItem,
      getItemId: getItemId,
    );
    //
    // This block has UI Active (Or child block has UI Active).
    //
    final bool hasXActiveUI = ui.hasActiveUIComponent(alsoCheckChildren: true);
    //
    thisXBlock._printParameters(hasActiveUI: hasXActiveUI); // ---> Debug
    bool originForceReloadItem = thisXBlock.forceReloadItem;
    bool forceReloadItem = thisXBlock.forceReloadItem;
    bool forceReloadForm = false;

    DebugPrint.printDebugState(DebugCat.dataLoad,
        "\n@~~~> ${getClassName(this)} ~~~~~> ITM - originForceReloadItem: $originForceReloadItem.\n");

    //
    if (!forceReloadItem) {
      _ForceReloadItemState blkState = _calculateBlockState(
        thisXBlock: thisXBlock,
        hasXActiveUI: hasXActiveUI,
        currentItemSelectionType: currentItemSelectionType,
        isCandidateCurrentItemInNewQueriedList:
            isCandidateCurrentItemInNewQueriedList,
        currentItemChanged: currentItemChanged,
      );
      //
      forceReloadItem = blkState.forceReloadItem;
    }
    //
    if (thisXBlock.xFormModel != null) {
      _ForceReloadFormState frmState = _calculateFormState(
        xFormModel: thisXBlock.xFormModel!,
        currentItemSelectionType: currentItemSelectionType,
        isCandidateCurrentItemInNewQueriedList:
            isCandidateCurrentItemInNewQueriedList,
        currentItemChanged: currentItemChanged,
        forceReloadItem: forceReloadItem,
      );
      //
      forceReloadItem = frmState.forceReloadItem;
      forceReloadForm = frmState.forceReloadForm;
      //
      if (forceReloadForm) {
        thisXBlock.xFormModel!.forceTypeForForm = ForceType.force;
      }
    }
    //
    DebugPrint.printDebugState(DebugCat.dataLoad,
        "\n@~~~> ${getClassName(this)} ~~~~~> ITM/FRM: forceReloadItem: $forceReloadItem");
    DebugPrint.printDebugState(DebugCat.dataLoad,
        "@~~~> ${getClassName(this)} ~~~~~> ITM/FRM: forceReloadForm: $forceReloadForm");
    //
    final bool isCandidateIsCurrent = isCurrentItem(
      item: candidateCurrentItem,
    );
    ITEM_DETAIL? refreshedCurrentItemDetail;
    if (forceReloadItem) {
      if (ITEM == ITEM_DETAIL &&
          config.itemRefreshmentMode == BlockItemRefreshmentMode.auto &&
          isCandidateCurrentItemInNewQueriedList) {
        final ITEM? candidateCurrentItemInNewQueriedList =
            ItemsUtils.findItemInList(
          item: candidateCurrentItem,
          targetList: newQueriedList,
          getItemId: getItemId,
        );
        //
        // No need to refresh Item.
        //
        refreshedCurrentItemDetail =
            candidateCurrentItemInNewQueriedList as ITEM_DETAIL;
      } else {
        bool isLoadItemError = false;
        try {
          __refreshRefreshingCurrentItemState(
            isRefreshingCurrentItem: true,
          );
          ID itemId = getItemId(candidateCurrentItem);
          //
          __callApiLoadItemDetailByIdCount++;
          ApiResult<ITEM_DETAIL> result = await callApiLoadItemDetailById(
            itemId: itemId,
          );
          // Throw ApiError:
          result.throwIfError();
          //
          refreshedCurrentItemDetail = result.data;
        } catch (e, stackTrace) {
          isLoadItemError = true;
          //
          AppError appError = _handleError(
            shelf: shelf,
            methodName: "callApiLoadItemDetailById",
            error: e,
            stackTrace: stackTrace,
            showSnackBar: true,
          );
          //
          currentItemSelectionResult._setAppError(
            appError: appError,
            stackTrace: appError is ApiError ? null : stackTrace,
          );
        } finally {
          __refreshRefreshingCurrentItemState(
            isRefreshingCurrentItem: false,
          );
        }
        if (isLoadItemError) {
          currentItemSelectionResult._apiError = true;
          // ???????????????????????????????
          // TODO: Them test case:
          // TODO: Alway return? Load ITEM Error
          //   ==> Chuyen Form sang trang thai NULL??
          //
          return;
        }
      }
      //
      // If candidate not found in database --> remove.
      //
      if (refreshedCurrentItemDetail == null) {
        final ITEM? siblingItem = findSiblingItem(
          item: candidateCurrentItem,
        );
        // #SAME-CODE-001
        if (!isCandidateIsCurrent) {
          await __removeItemFromList(
            removeItem: candidateCurrentItem,
          );
          //
          if (currentItem != null) {
            // TODO: Test case.
            return;
          }
          //
          if (siblingItem == null) {
            // TODO: Test case.
            return;
          }
          //
          var taskUnit = _BlockSelectAsCurrentTaskUnit(
            currentItemSelectionType: currentItemSelectionType,
            xBlock: thisXBlock,
            newQueriedList: newQueriedList,
            candidateItem: siblingItem,
            forceReloadItem: false,
            forceTypeForForm: null,
          );
          FlutterArtist.taskUnitQueue.addTaskUnit(taskUnit);
          return;
        }
        //
        // Candidate is current but not found in database.
        // Remove Item (Current Item)
        //
        await __removeItemFromList(
          removeItem: candidateCurrentItem,
        );
        // Test Case: [46a].
        __clearAllChildrenBlocksToNone(thisXBlock: thisXBlock);
        //
        if (siblingItem != null) {
          var taskUnit = _BlockSelectAsCurrentTaskUnit(
            currentItemSelectionType: currentItemSelectionType,
            xBlock: thisXBlock,
            newQueriedList: newQueriedList,
            candidateItem: siblingItem,
            forceReloadItem: false,
            forceTypeForForm: null,
          );
          FlutterArtist.taskUnitQueue.addTaskUnit(taskUnit);
          return;
        }
        return;
      }
      //
      // refreshedCurrentItemDetail != null
      //
      bool convertItemError = false;
      try {
        candidateCurrentItem = this.__convertItemDetailToItem(
          itemDetail: refreshedCurrentItemDetail,
        );
        convertItemError = false;
      } catch (e, stackTrace) {
        convertItemError = true;
        _handleError(
          shelf: shelf,
          methodName: "convertItemDetailToItem",
          error: e,
          stackTrace: stackTrace,
          showSnackBar: true,
        );
      }
      //
      if (convertItemError) {
        currentItemSelectionResult._convertError = true;
        // TODO Always return??
        // If currentItemChanged or not currentItemChanged
        // Always return. Nothing to do if has error!!
        return;
      }
      //
      __blockData._selectionDataState = DataState.ready;
      if (candidateCurrentItem != null) {
        __blockData._insertOrReplaceItem(item: candidateCurrentItem);
      }
      __blockData._setCurrentItemOnly(
        refreshedItem: candidateCurrentItem,
        refreshedItemDetail: refreshedCurrentItemDetail,
      );
      // (On _unitSelectItemAsCurrent method).
      // candidateCurrentItem != null.
      if (currentItemChanged) {
        currentItemSelectionResult._currentItem = candidateCurrentItem;
        // @@TODO@@ 10.
        this.__clearAllChildrenBlocksToPending(
          thisXBlock: thisXBlock,
        );
      }
    }
    //
    // FormModel:
    //
    if (thisXBlock.xFormModel != null) {
      if (forceReloadForm) {
        FlutterArtist.taskUnitQueue.addTaskUnit(
          _FormModelLoadFormTaskUnit(
            xFormModel: thisXBlock.xFormModel!,
          ),
        );
      } else {
        if (forceReloadItem) {
          formModel!._clearDataWithDataState(formDataState: DataState.pending);
        } else {
          // Do nothing.
        }
      }
    }

    //
    for (_XBlock childXBlock in thisXBlock.childXBlocks) {
      FlutterArtist.taskUnitQueue.addTaskUnit(
        _BlockQueryTaskUnit(
          xBlock: childXBlock,
        ),
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
    required _XBlock thisXBlock,
    required ITEM item,
    required BlockItemDeletionResult<ITEM> deletionResult,
  }) async {
    __assertThisXBlock(thisXBlock);
    //
    // No need to check again?
    //
    Actionable<BlockItemDeletionPrecheck> actionable = canDeleteItem(
      item: item,
      errorIfItemNotInTheBlock: true,
    );
    if (!actionable.yes) {
      return;
    }
    //
    // Candidate Item to delete.
    //
    deletionResult._setCandidateItem(candidateItem: item);
    //
    final bool isCurrent = isCurrentItem(item: item);
    //
    ApiResult<void> result;
    try {
      FlutterArtist.codeFlowLogger._addMethodCall(
        isLibCode: false,
        navigate: null,
        ownerClassInstance: this,
        methodName: "callApiDeleteItemById",
        parameters: {
          "item": item,
        },
      );
      //
      ID itemId = getItemId(item);
      __refreshDeletingState(isDeleting: true);
      //
      result = await callApiDeleteItemById(itemId: itemId);
      // Throw ApiError:
      result.throwIfError();
      // TODO: Chuyen di noi khac?
      FlutterArtist.storage._fireEventSourceChanged(
        eventBlock: this,
        itemIdString: null,
      );
    } catch (e, stackTrace) {
      AppError appError = _handleError(
        shelf: shelf,
        methodName: "callApiDeleteItemById",
        error: e,
        stackTrace: stackTrace,
        showSnackBar: true,
      );
      //
      deletionResult._setFailedItem(
        failedItem: item,
        appError: appError,
        stackTrace: appError is ApiError ? null : stackTrace,
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
      await __removeItemFromList(removeItem: item);
      return;
    }
    //
    // Deleted current item ==> find sibling.
    //
    final ITEM? siblingItem = findSiblingItem(item: item);
    // Remove Item (Current Item)
    await __removeItemFromList(removeItem: item);
    //
    __blockData._setCurrentItemOnly(
      refreshedItem: null,
      refreshedItemDetail: null,
    );
    //
    if (this.formModel != null) {
      // Clear Form:
      formModel!._clearDataWithDataState(
        formDataState: DataState.none,
      );
    }
    // @@TODO@@ 09.
    __clearAllChildrenBlocksToNone(
      thisXBlock: thisXBlock,
    );
    //
    _TaskUnit taskUnit = _BlockSelectAsCurrentTaskUnit<ITEM>(
      currentItemSelectionType:
          CurrentItemSelectionType.selectAnItemAsCurrentIfNeed,
      xBlock: thisXBlock,
      newQueriedList: <ITEM>[],
      candidateItem: siblingItem,
      forceReloadItem: false,
      forceTypeForForm: null,
    );
    FlutterArtist.taskUnitQueue.addTaskUnit(taskUnit);
  }

  // ***************************************************************************
  // ***************************************************************************

  @_TaskUnitMethodAnnotation()
  @_BlockDeleteItemsAnnotation()
  Future<void> _unitDeleteItems({
    required _XBlock thisXBlock,
    required List<ITEM> items,
    required BlockItemsDeletionResult<ITEM> deletionResult,
    required bool stopIfError,
  }) async {
    __assertThisXBlock(thisXBlock);
    //
    // Precheck: No need to check again!.
    // Candidate Items to delete.
    //
    deletionResult._setCandidateItems(candidateItems: items);
    //
    final ITEM? currItem = currentItem;
    ITEM? siblingItem;
    //
    bool currentItemDeleted = false;
    //
    for (ITEM item in [...items]) {
      ApiResult<void> result;
      try {
        FlutterArtist.codeFlowLogger._addMethodCall(
          isLibCode: false,
          navigate: null,
          ownerClassInstance: this,
          methodName: "callApiDeleteItemById",
          parameters: {
            "item": item,
          },
        );
        // TODO: Move to out of for loop (Need to catch error).
        final ID? currentItemId = currItem == null ? null : getItemId(currItem);
        final ID deletingItemId = getItemId(item);
        //
        siblingItem = findSiblingItem(item: item);
        __refreshDeletingState(isDeleting: true);
        //
        result = await callApiDeleteItemById(itemId: deletingItemId);
        // Throw ApiError:
        result.throwIfError();
        //
        deletionResult._addDeletedItem(deletedItem: item);
        //
        // Remove Item from the List.
        //
        await __removeItemFromList(removeItem: item);
        //
        // Current Item DELETED!
        //
        if (deletingItemId == currentItemId) {
          currentItemDeleted = true;
          //
          __blockData._setCurrentItemOnly(
            refreshedItem: null,
            refreshedItemDetail: null,
          );
          //
          // Clear Form:
          //
          formModel?._clearDataWithDataState(
            formDataState: DataState.none,
          );
          // @@TODO@@ 09.
          __clearAllChildrenBlocksToNone(
            thisXBlock: thisXBlock,
          );
        }
      } catch (e, stackTrace) {
        deletionResult._addFailedItem(
          failedItem: item,
          error: e,
          stackTrace: stackTrace,
        );
        //
        if (stopIfError) {
          break;
        }
      } finally {
        __refreshDeletingState(isDeleting: false);
      }
    }
    //
    if (deletionResult.deletedItems.isNotEmpty) {
      // TODO: Chuyen di noi khac?
      FlutterArtist.storage._fireEventSourceChanged(
        eventBlock: this,
        itemIdString: null,
      );
    }
    //
    showMessageSnackBar(
      message: 'Deletion Results',
      details: [
        "${items.length} Items",
        "${deletionResult.deletedItems.length} Deleted",
        "${deletionResult.failedItemDeletions.length} Failed",
      ],
    );
    //
    if (!currentItemDeleted) {
      return;
    }
    if (siblingItem == null) {
      return;
    }
    _TaskUnit taskUnit = _BlockSelectAsCurrentTaskUnit<ITEM>(
      currentItemSelectionType:
          CurrentItemSelectionType.selectAnItemAsCurrentIfNeed,
      xBlock: thisXBlock,
      newQueriedList: <ITEM>[],
      candidateItem: siblingItem,
      forceReloadItem: false,
      forceTypeForForm: null,
    );
    FlutterArtist.taskUnitQueue.addTaskUnit(taskUnit);
  }

  // ***************************************************************************
  // ***************************************************************************

  @_TaskUnitMethodAnnotation()
  @_BlockPrepareFormToCreateItemAnnotation()
  Future<bool> _unitPrepareFormToCreateItem({
    required _XBlock thisXBlock,
    required bool initDirty,
    required EXTRA_FORM_INPUT? extraFormInput,
    required Function()? navigate,
  }) async {
    __assertThisXBlock(thisXBlock);
    //
    const ITEM? nullItem = null;
    const ITEM_DETAIL? nullItemDetail = null;
    this.__setCurrentItem(
      itemDetail: nullItemDetail,
      item: nullItem,
    );
    // @@TODO@@ 01.
    this.__clearAllChildrenBlocksToNone(
      thisXBlock: thisXBlock,
    );
    //
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
      //
      success = await formModel!._startNewFormActivity(
        extraFormInput: extraFormInput,
        activityType: FormActivityType.itemFirstLoad,
      );
      if (success) {
        formModel!._formPropsStructure._setManualDirty(initDirty);
      }
    } finally {
      __refreshPreparingFormCreationState(
        isPreparingFormCreation: false,
      );
    }
    if (!success) {
      return false;
    }
    //
    if (success) {
      _executeNavigation(navigate: navigate);
    }
    return success;
  }

  // ***************************************************************************
  // ***************************************************************************

  @_TaskUnitMethodAnnotation()
  @_BlockQuickCreateItemActionAnnotation()
  Future<bool> _unitQuickCreateItem({
    required _XBlock thisXBlock,
    required BlockQuickCreateItemResult taskResult,
    required BlockQuickCreateItemAction<ID, ITEM, ITEM_DETAIL, FILTER_CRITERIA>
        action,
  }) async {
    __assertThisXBlock(thisXBlock);
    //
    // (No Precheck Again)
    //
    FILTER_CRITERIA blockCurrentFilterCriteria = filterCriteria!;
    //
    ApiResult<ITEM_DETAIL> result;
    final String methodName = "callApiQuickCreateItem";
    try {
      FlutterArtist.codeFlowLogger._addMethodCall(
        isLibCode: false,
        navigate: null,
        ownerClassInstance: action,
        methodName: methodName,
        parameters: {},
      );
      //
      result = await action.callApiQuickCreateItem(
        parentBlockItem: parent?.currentItem,
        filterCriteria: blockCurrentFilterCriteria,
      );
      //
    } catch (e, stackTrace) {
      // Test Cases: [90b].
      AppError appError = _handleError(
        shelf: shelf,
        methodName: '${getClassName(action)}.$methodName',
        error: e,
        stackTrace: stackTrace,
        showSnackBar: true,
      );
      //
      taskResult._setAppError(
        appError: appError,
        stackTrace: appError is ApiError ? null : stackTrace,
      );
      return false;
    }
    //
    try {
      return await _processSaveActionRestResult(
        thisXBlock: thisXBlock,
        isNew: true,
        calledMethodName: "${getClassName(action)}.$methodName",
        result: result,
      );
    } catch (e, stackTrace) {
      AppError appError = _handleError(
        shelf: shelf,
        methodName: "${getClassName(action)}.$methodName",
        error: e,
        stackTrace: stackTrace,
        showSnackBar: true,
      );
      //
      taskResult._setAppError(
        appError: appError,
        stackTrace: appError is ApiError ? null : stackTrace,
      );
      return false;
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  @_TaskUnitMethodAnnotation()
  @_BlockQuickCreateMultiItemsActionAnnotation()
  Future<bool> _unitQuickCreateMultiItems({
    required _XBlock thisXBlock,
    required BlockQuickCreateMultiItemsAction<ID, ITEM, ITEM_DETAIL,
            FILTER_CRITERIA>
        action,
  }) async {
    __assertThisXBlock(thisXBlock);
    //
    FILTER_CRITERIA blockCurrentFilterCriteria = filterCriteria!;
    //
    ApiResult<PageData<ITEM>> result;
    try {
      FlutterArtist.codeFlowLogger._addMethodCall(
        isLibCode: false,
        navigate: null,
        ownerClassInstance: action,
        methodName: "callApiQuickCreateMultiItems",
        parameters: {},
      );
      //
      result = await action.callApiQuickCreateMultiItems(
        parentBlockItem: parent?.currentItem,
        filterCriteria: blockCurrentFilterCriteria,
      );
      //
    } catch (e, stackTrace) {
      _handleError(
        shelf: shelf,
        methodName: '${getClassName(action)}.callApiQuickCreateMultiItems',
        error: e,
        stackTrace: stackTrace,
        showSnackBar: true,
      );
      //
      return false;
    }
    //
    try {
      return await _processCreateMultiItemsActionResult(
        thisXBlock: thisXBlock,
        blockCurrentFilterCriteria: blockCurrentFilterCriteria,
        calledMethodName:
            "${getClassName(action)}.callApiQuickCreateMultiItems",
        result: result,
      );
    } catch (e, stackTrace) {
      _handleError(
        shelf: shelf,
        methodName: "${getClassName(action)}.callApiQuickCreateMultiItems",
        error: e,
        stackTrace: stackTrace,
        showSnackBar: true,
      );
      //
      return false;
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  @_TaskUnitMethodAnnotation()
  @_BlockQuickUpdateItemActionAnnotation()
  Future<bool> _unitQuickUpdateItem({
    required _XBlock thisXBlock,
    required BlockQuickUpdateItemResult taskResult,
    required BlockQuickUpdateItemAction<ID, ITEM, ITEM_DETAIL, FILTER_CRITERIA>
        action,
  }) async {
    __assertThisXBlock(thisXBlock);
    //
    // No Need Precheck Again.
    //
    FILTER_CRITERIA blockCurrentFilterCriteria = filterCriteria!;
    //
    ApiResult<ITEM_DETAIL> result;
    final String methodName = "callApiQuickUpdateItem";
    try {
      FlutterArtist.codeFlowLogger._addMethodCall(
        isLibCode: false,
        navigate: null,
        ownerClassInstance: action,
        methodName: methodName,
        parameters: {},
      );
      //
      result = await action.callApiQuickUpdateItem(
        parentBlockItem: parent?.currentItem,
        filterCriteria: blockCurrentFilterCriteria,
      );
      //
    } catch (e, stackTrace) {
      // Test Cases: [90b].
      AppError appError = _handleError(
        shelf: shelf,
        methodName: '${getClassName(action)}.$methodName',
        error: e,
        stackTrace: stackTrace,
        showSnackBar: true,
      );
      //
      taskResult._setAppError(
        appError: appError,
        stackTrace: appError is ApiError ? null : stackTrace,
      );
      return false;
    }
    //
    try {
      return await _processSaveActionRestResult(
        thisXBlock: thisXBlock,
        isNew: false,
        calledMethodName: "${getClassName(action)}.$methodName",
        result: result,
      );
    } catch (e, stackTrace) {
      AppError appError = _handleError(
        shelf: shelf,
        methodName: "${getClassName(action)}.$methodName",
        error: e,
        stackTrace: stackTrace,
        showSnackBar: true,
      );
      //
      taskResult._setAppError(
        appError: appError,
        stackTrace: appError is ApiError ? null : stackTrace,
      );
      return false;
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  @_TaskUnitMethodAnnotation()
  @_BlockQuickActionAnnotation()
  Future<bool> _unitQuickAction({
    required _XBlock thisXBlock,
    required BlockQuickAction action,
    required BlockQuickActionResult taskResult,
  }) async {
    __assertThisXBlock(thisXBlock);
    //
    ApiResult<void>? result;
    try {
      FlutterArtist.codeFlowLogger._addMethodCall(
        ownerClassInstance: action,
        methodName: "callApi",
        parameters: null,
        navigate: null,
        isLibCode: false,
      );
      //
      result = await action.callApi();
      // Throw ApiError.
      result.throwIfError();
    } catch (e, stackTrace) {
      AppError appError = _handleError(
        shelf: shelf,
        methodName: '${getClassName(action)}.callApi',
        error: e,
        stackTrace: stackTrace,
        showSnackBar: true,
      );
      //
      taskResult._setAppError(
        appError: appError,
        stackTrace: appError is ApiError ? null : stackTrace,
      );
      return false;
    }
    //
    FlutterArtist.storage._fireEventToAffectedItemTypes(
      eventShelf: shelf,
      affectedItemTypes: action.config.affectedItemTypes,
    );
    //
    switch (action.config.afterQuickAction) {
      case AfterBlockQuickAction.none:
        break;
      case AfterBlockQuickAction.refreshCurrentItem:
        Actionable<BlockItemCurrSelectionPrecheck> actionable =
            canRefreshCurrentItem();
        if (!actionable.yes) {
          return true;
        }
        ITEM? currentItem = this.currentItem;
        if (currentItem != null) {
          var taskUnit = _BlockSelectAsCurrentTaskUnit<ITEM>(
            currentItemSelectionType: CurrentItemSelectionType.refresh,
            xBlock: thisXBlock,
            newQueriedList: [],
            candidateItem: currentItem,
            forceReloadItem: false,
            forceTypeForForm: null,
          );
          FlutterArtist.taskUnitQueue.addTaskUnit(taskUnit);
        }
      case AfterBlockQuickAction.query:
        var taskUnit = _BlockQueryTaskUnit(
          xBlock: thisXBlock,
        );
        FlutterArtist.taskUnitQueue.addTaskUnit(taskUnit);
    }
    return true;
  }

  // ***************************************************************************
  // ***************************************************************************

  @_TaskUnitMethodAnnotation()
  @_BlockQuickChildBlockItemsActionAnnotation()
  Future<bool> _unitQuickChildBlockItemsAction<DATA extends Object>({
    required _XBlock thisXBlock,
    required BlockQuickChildBlockItemsAction<ITEM, ITEM_DETAIL> action,
  }) async {
    __assertThisXBlock(thisXBlock);
    //
    ApiResult<ITEM_DETAIL> result;
    try {
      FlutterArtist.codeFlowLogger._addMethodCall(
        isLibCode: false,
        navigate: null,
        ownerClassInstance: action,
        methodName: "callApiChildBlockItems",
        parameters: {},
      );
      //
      result = await action.callApiChildBlockItems();
    } catch (e, stackTrace) {
      _handleError(
        shelf: shelf,
        methodName: '${getClassName(action)}.callApiChildBlockItems',
        error: e,
        stackTrace: stackTrace,
        showSnackBar: true,
      );
      return false;
    }
    //
    if (result.error != null) {
      _handleRestError(
        shelf: shelf,
        methodName: "callApiChildBlockItems",
        message: result.error!.errorMessage,
        errorDetails: result.error!.errorDetails,
        showSnackBar: true,
      );
      // TODO: Xem lai (Hanh dong neu Error).
      return false;
    }
    //
    return await _processSaveActionRestResult(
      thisXBlock: thisXBlock,
      isNew: true,
      calledMethodName: "${getClassName(action)}.callApiChildBlockItems",
      result: result,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  Future<bool> _processSaveActionRestResult({
    required _XBlock thisXBlock,
    required bool isNew,
    required String calledMethodName,
    required ApiResult<ITEM_DETAIL> result,
  }) async {
    if (result.error != null) {
      _handleRestError(
        shelf: shelf,
        methodName: calledMethodName,
        message: result.error!.errorMessage,
        errorDetails: result.error!.errorDetails,
        showSnackBar: true,
      );
      return false;
    }
    //
    showSavedSnackBar();
    //
    FILTER_CRITERIA? blockCurrentFilterCriteria = filterCriteria;
    if (blockCurrentFilterCriteria == null) {
      print("????????????? ${this.name} - filterCriteria is null");
      // TODO-Review.
      return true;
    }
    bool fireOutsideEvent = false;
    final ITEM_DETAIL? savedItemDetail = result.data;
    print(">>> savedItemDetail: $savedItemDetail");
    final bool keepInList;
    if (savedItemDetail == null) {
      keepInList = false;
      if (isNew) {
        fireOutsideEvent = false;
      } else {
        fireOutsideEvent = true;
      }
    } else {
      fireOutsideEvent = true;
      //
      keepInList = needToKeepItemInList(
        parentBlockCurrentItem: parent?.currentItem,
        filterCriteria: blockCurrentFilterCriteria,
        itemDetail: savedItemDetail,
      );
    }
    //
    if (fireOutsideEvent) {
      // TODO: Chuyen di noi khac.
      FlutterArtist.storage._fireEventSourceChanged(
        eventBlock: this,
        itemIdString: null,
      );
    } else {
      print(">>> fireOutsideEvent: false (keepInList: $keepInList)");
    }
    //
    if (savedItemDetail != null && keepInList) {
      // bool forceForm = false;
      ITEM refreshedItem = convertItemDetailToItem(
        itemDetail: savedItemDetail,
      );
      __blockData._insertOrReplaceItem(
        item: refreshedItem,
      );
      //
      Actionable<BlockItemEditPrecheck> actionable =
          canEditItemOnForm(item: refreshedItem);
      //
      FlutterArtist.codeFlowLogger._addInfo(
        ownerClassInstance: this,
        info: 'Allow Edit? ${actionable.yes}',
        isLibCode: true,
      );
      //
      this.__setCurrentItem(
        itemDetail: savedItemDetail,
        item: refreshedItem,
      );
      // New Code:
      if (isNew) {
        __clearAllChildrenBlocksToReady(
          thisXBlock: thisXBlock,
        );
      }
      //
      if (formModel != null) {
        formModel!._formPropsStructure._setFormMode_TODO_DELETE(
          formMode: FormMode.edit,
          formDataState: DataState.ready,
        );
        //
        // IMPORTANT:
        // After save successful, update [initialFormData].
        //
        formModel!._formPropsStructure._updateInitialFormDataAfterSaveSuccess();
        //
        bool success = await formModel!._startNewFormActivity(
          extraFormInput: null,
          activityType: FormActivityType.itemFirstLoad,
        );
        if (!success) {
          return false;
        }
      }
      return true;
    }
    // savedItemDetail = null or !keepInList
    else {
      ITEM? savedItem = __convertItemDetailToItem(
        itemDetail: savedItemDetail,
      );
      final ITEM? removeItem = savedItem ?? this.currentItem;
      if (removeItem == null) {
        // @@TODO@@ 11
        // TODO: Xem lai.
        return false;
      }
      //
      // removeItem != null
      //
      bool isCurrent = isCurrentItem(item: removeItem);
      if (!isCurrent) {
        await __removeItemFromList(removeItem: removeItem);
        return true;
      }
      //
      // Deleted current item ==> find sibling.
      //
      final ITEM? siblingItem = findSiblingItem(item: removeItem);
      // Remove Item (Current Item)
      await __removeItemFromList(removeItem: removeItem);
      __blockData._setCurrentItemOnly(
        refreshedItem: null,
        refreshedItemDetail: null,
      );
      //
      if (this.formModel != null) {
        // Clear Form:
        formModel!._clearDataWithDataState(
          formDataState: DataState.none,
        );
      }
      // @@TODO@@ 08.
      __clearAllChildrenBlocksToNone(
        thisXBlock: thisXBlock,
      );
      //
      _TaskUnit taskUnit = _BlockSelectAsCurrentTaskUnit<ITEM>(
        currentItemSelectionType:
            CurrentItemSelectionType.selectAnItemAsCurrentIfNeed,
        xBlock: thisXBlock,
        newQueriedList: [],
        candidateItem: siblingItem,
        forceReloadItem: false,
        forceTypeForForm: null,
      );
      FlutterArtist.taskUnitQueue.addTaskUnit(taskUnit);
      //
      return true;
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  Future<bool> _processCreateMultiItemsActionResult({
    required _XBlock thisXBlock,
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
      );
      return false;
    }
    // TODO: Chuyen di noi khac.
    FlutterArtist.storage._fireEventSourceChanged(
      eventBlock: this,
      itemIdString: null,
    );
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
    return true;
  }

  // ***************************************************************************
  // ***************************************************************************

  @_RootMethodAnnotation()
  void showBlockErrorViewerDialog(BuildContext context) {
    if (queryDataState != DataState.error ||
        _blockErrorInfo == null ||
        _blockErrorInfo!.blockErrorMethod != BlockErrorMethod.callApiQuery) {
      return;
    }
    BlockErrorViewerDialog.showBlockErrorViewerDialog(
      context: context,
      blockErrorInfo: _blockErrorInfo!,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  @_RootMethodAnnotation()
  @_BlockClearCurrentAnnotation()
  Future<void> clearCurrent() async {
    FlutterArtist.codeFlowLogger._addMethodCall(
      isLibCode: true,
      navigate: null,
      ownerClassInstance: this,
      methodName: "clearCurrent",
      parameters: {},
    );
    if (this.currentItem == null) {
      return;
    }
    //
    _XShelf xShelf = _XShelf(
      shelf: shelf,
      forceFilterModelOpt: null,
      forceQueryScalarOpts: [],
      forceQueryBlockOpts: [],
      forceQueryFormModelOpts: [],
    );
    //
    _XBlock thisXBlock = xShelf.findXBlockByName(this.name)!;
    //
    _TaskUnit taskUnit = _BlockClearCurrentTaskUnit(
      xBlock: thisXBlock,
    );
    FlutterArtist.taskUnitQueue.addTaskUnit(taskUnit);
    //
    await FlutterArtist.executor._executeTaskUnitQueue();
  }

  // ***************************************************************************
  // ***************************************************************************

  @_ReturnTaskResultMethodAnnotation()
  Future<BlockItemDeletionResult<ITEM>> __deleteItem({
    required String methodName,
    required ITEM? item,
    required ErrCodeIfItemIsNull errCodeIfItemIsNull,
    bool errorIfItemNotInTheBlock = true,
  }) async {
    FlutterArtist.codeFlowLogger._addMethodCall(
      isLibCode: true,
      navigate: null,
      ownerClassInstance: this,
      methodName: methodName,
      parameters: {
        "item": item,
      },
    );
    // @Same-Code-Precheck-01
    Actionable<BlockItemDeletionPrecheck> actionable = __canDeleteItem(
      checkBusy: true,
      item: item,
      errCodeIfItemIsNull: errCodeIfItemIsNull,
      errorIfItemNotInTheBlock: errorIfItemNotInTheBlock,
      checkAllow: true,
    );
    if (!actionable.yes) {
      _deletionErrorCount++;
      _addErrorLogActionable(
        shelf: shelf,
        actionableFalse: actionable,
        showErrSnackBar: true,
      );
      return BlockItemDeletionResult<ITEM>(
        candidateItem: item,
        precheck: actionable.errCode,
        stackTrace: actionable.stackTrace,
      );
    }
    //
    BuildContext context = FlutterArtist.adapter.getCurrentContext();
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
    _XShelf xShelf = _XShelf(
      shelf: shelf,
      forceFilterModelOpt: null,
      forceQueryScalarOpts: [],
      forceQueryBlockOpts: [],
      forceQueryFormModelOpts: [],
    );
    //
    _XBlock thisXBlock = xShelf.findXBlockByName(name)!;
    //
    final taskResult = _createEmptyItemDeletionResult();
    //
    _ResultedTaskUnit taskUnit = _BlockDeleteItemTaskUnit(
      xBlock: thisXBlock,
      item: item!,
      taskResult: taskResult,
    );
    //
    FlutterArtist.taskUnitQueue.addTaskUnit(taskUnit);
    //
    await FlutterArtist.executor._executeTaskUnitQueue();
    return taskResult;
  }

  // ***************************************************************************
  // ***************************************************************************

  @_ReturnTaskResultMethodAnnotation()
  Future<BlockItemsDeletionResult<ITEM>> __deleteItems({
    required String methodName,
    required List<ITEM> items,
    required bool stopIfError,
    bool errorIfItemNotInTheBlock = true,
  }) async {
    final List<ITEM> candidateDeleteItems =
        __blockData.moveCurrentItemToEndOfList(
      itemList: items,
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
      _addErrorLogActionable(
        shelf: shelf,
        actionableFalse: actionable,
        showErrSnackBar: true,
      );
      return BlockItemsDeletionResult<ITEM>(
        candidateItems: candidateDeleteItems,
        precheck: actionable.errCode,
        stackTrace: actionable.stackTrace,
      );
    }
    //
    BuildContext context = FlutterArtist.adapter.getCurrentContext();
    bool confirm = await showConfirmDeleteDialog(
      context: context,
      details: "Delete Multi Items",
    );
    if (!confirm) {
      return BlockItemsDeletionResult<ITEM>(
        candidateItems: candidateDeleteItems,
        precheck: BlockItemsDeletionPrecheck.cancelled,
      );
    }
    //
    _XShelf xShelf = _XShelf(
      shelf: shelf,
      forceFilterModelOpt: null,
      forceQueryScalarOpts: [],
      forceQueryBlockOpts: [],
      forceQueryFormModelOpts: [],
    );
    //
    _XBlock thisXBlock = xShelf.findXBlockByName(name)!;
    //
    final taskResult = _createEmptyItemsDeletionResult(
      candidateItems: candidateDeleteItems,
    );
    _ResultedTaskUnit taskUnit = _BlockDeleteItemsTaskUnit(
      xBlock: thisXBlock,
      items: candidateDeleteItems,
      stopIfError: stopIfError,
      taskResult: taskResult,
    );
    //
    FlutterArtist.taskUnitQueue.addTaskUnit(taskUnit);
    //
    await FlutterArtist.executor._executeTaskUnitQueue();
    return taskResult;
    //
    // _XBlock xBlock = xShelf.findXBlockByName(this.name)!;
    // xBlock.itemDeletionResult.candidateItems = deleteItems;
    //
    // for (ITEM item in deleteItems) {
    //   var taskUnit = _BlockDeleteItemTaskUnit(
    //     xBlock: xBlock,
    //     item: item,
    //     result: null, // ??????????/
    //   );
    //   FlutterArtist.taskUnitQueue.addTaskUnit(taskUnit);
    //   await FlutterArtist.executor._executeTaskUnitQueue();
    //   if (stopIfError) {
    //     ItemDeletionResult result = xBlock.itemDeletionResult;
    //     if (!result.success) {
    //       return result;
    //     }
    //   }
    // }
    // return xBlock.itemDeletionResult;
    // throw UnimplementedError();
  }

  // ***************************************************************************
  // ***************************************************************************

  @_BlockSelectItemAsCurrentAnnotation()
  @_ReturnTaskResultMethodAnnotation()
  Future<BlockItemCurrSelectionResult<ITEM>>
      __refreshToShowOrEditItemAsCurrent({
    required String methodName,
    required ITEM? item,
    required ErrCodeIfItemIsNull errCodeIfItemIsNull,
    required bool forceForm,
    required Function()? navigate,
  }) async {
    FlutterArtist.codeFlowLogger._addMethodCall(
      isLibCode: true,
      navigate: navigate,
      ownerClassInstance: this,
      methodName: methodName,
      parameters: {
        "item": item,
        "forceForm": forceForm,
      },
    );
    //
    final currentItemSelectionType = forceForm
        ? CurrentItemSelectionType.selectAnItemAsCurrentAndLoadForm
        : CurrentItemSelectionType.selectAnItemAsCurrent;
    //
    // @Same-Code-Precheck-01
    //
    Actionable<BlockItemCurrSelectionPrecheck> actionable =
        this.__canSelectItemAsCurrent(
      item: item,
      errCodeIfItemIsNull: errCodeIfItemIsNull,
      checkBusy: true,
    );
    //
    if (!actionable.yes) {
      // _refreshErrorCount++;
      _addErrorLogActionable(
        shelf: shelf,
        actionableFalse: actionable,
        showErrSnackBar: true,
      );
      //
      return BlockItemCurrSelectionResult<ITEM>(
        precheck: actionable.errCode,
        currentItemSelectionType: currentItemSelectionType,
        getItemId: getItemId,
        candidateItem: item,
        oldCurrentItem: currentItem,
        currentItem: currentItem,
      );
    }
    //
    _XShelf xShelf = _XShelf(
      shelf: shelf,
      forceFilterModelOpt: null,
      forceQueryScalarOpts: [],
      forceQueryBlockOpts: [],
      forceQueryFormModelOpts: [],
    );
    //
    _XBlock thisXBlock = xShelf.findXBlockByName(this.name)!;
    //
    _ResultedTaskUnit taskUnit = _BlockSelectAsCurrentTaskUnit<ITEM>(
      currentItemSelectionType: currentItemSelectionType,
      xBlock: thisXBlock,
      newQueriedList: [],
      candidateItem: item,
      forceReloadItem: true,
      forceTypeForForm: forceForm //
          ? ForceType.force
          : ForceType.decidedAtRuntime,
    );
    FlutterArtist.taskUnitQueue.addTaskUnit(taskUnit);
    //
    await FlutterArtist.executor._executeTaskUnitQueue();
    var result = taskUnit.taskResult as BlockItemCurrSelectionResult<ITEM>;
    if (result.success) {
      if (navigate != null) {
        navigate();
      }
    }
    return result;
  }

  // ***************************************************************************
  // ***************************************************************************

  @_RootMethodAnnotation()
  @_ReturnTaskResultMethodAnnotation()
  @_BlockSelectItemAsCurrentAnnotation()
  Future<BlockItemCurrSelectionResult<ITEM>> refreshAndSelectItemAsCurrent({
    required ITEM item,
    bool forceLoadForm = false,
    Function()? navigate,
  }) async {
    return await __refreshToShowOrEditItemAsCurrent(
      methodName: "refreshAndSelectItemAsCurrent",
      item: item,
      errCodeIfItemIsNull: ErrCodeIfItemIsNull.invalidTarget,
      forceForm: forceLoadForm,
      navigate: navigate,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  ///
  /// Clear and set block to "Pending State".
  ///
  @_RootMethodAnnotation()
  @_ReturnTaskResultMethodAnnotation()
  Future<BlockClearanceResult> clear({Function()? navigate}) async {
    FlutterArtist.codeFlowLogger._addMethodCall(
      isLibCode: true,
      navigate: navigate,
      ownerClassInstance: this,
      methodName: "clear",
      parameters: {},
    );
    // @Same-Code-Precheck-01
    Actionable<BlockClearancePrecheck> actionable = __canClearBlock(
      checkBusy: true,
    );
    //
    if (!actionable.yes) {
      // _createItemErrorCount++;
      _addErrorLogActionable(
        shelf: shelf,
        actionableFalse: actionable,
        showErrSnackBar: true,
      );
      return BlockClearanceResult(
        precheck: actionable.errCode,
      );
    }
    //
    _XShelf xShelf = _XShelf(
      shelf: shelf,
      forceFilterModelOpt: null,
      forceQueryScalarOpts: [],
      forceQueryBlockOpts: [],
      forceQueryFormModelOpts: [],
    );
    //
    _XBlock thisXBlock = xShelf.findXBlockByName(this.name)!;
    // @@TODO@@ 13
    // TODO: Need to check, if current is ready then allow to do like this, else throw exception.
    this.__clearWithDataStateAndChildrenToNonCascade(
      thisXBlock: thisXBlock,
      qryDataState: DataState.pending,
      frmDataState: DataState.none,
      errorInFilter: false,
    );
    //
    _executeNavigation(navigate: navigate);
    //
    return BlockClearanceResult();
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
    PostQueryBehavior postQueryBehavior =
        PostQueryBehavior.selectAnItemAsCurrent,
  }) async {
    FlutterArtist.codeFlowLogger._addMethodCall(
      isLibCode: true,
      navigate: null,
      ownerClassInstance: this,
      methodName: "queryNextPage",
      parameters: {"postQueryBehavior": postQueryBehavior},
    );
    //
    PageableData? currentPageable = __blockData.pageable;
    if (currentPageable == null) {
      return BlockQueryResult._noCurrentPagination();
    }
    PageableData pageable = currentPageable.next();
    //
    return await query(
      listBehavior: ListBehavior.replace,
      postQueryBehavior: postQueryBehavior,
      suggestedSelection: null,
      pageable: pageable,
      navigate: null,
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
    PostQueryBehavior postQueryBehavior =
        PostQueryBehavior.selectAnItemAsCurrent,
  }) async {
    FlutterArtist.codeFlowLogger._addMethodCall(
      isLibCode: true,
      navigate: null,
      ownerClassInstance: this,
      methodName: "queryPreviousPage",
      parameters: {"postQueryBehavior": postQueryBehavior},
    );
    //
    PageableData? currentPageable = __blockData.pageable;
    if (currentPageable == null) {
      return BlockQueryResult._noCurrentPagination();
    }
    PageableData? pageable = currentPageable.previous();
    if (pageable == null) {
      return BlockQueryResult._noPreviousPage();
    }
    //
    return await query(
      listBehavior: ListBehavior.replace,
      postQueryBehavior: postQueryBehavior,
      suggestedSelection: null,
      pageable: pageable,
      navigate: null,
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
    PostQueryBehavior postQueryBehavior =
        PostQueryBehavior.selectAnItemAsCurrent,
  }) async {
    FlutterArtist.codeFlowLogger._addMethodCall(
      isLibCode: true,
      navigate: null,
      ownerClassInstance: this,
      methodName: "queryMore",
      parameters: {"postQueryBehavior": postQueryBehavior},
    );
    //
    PageableData? nxtPageable = nextPageable;
    if (nxtPageable == null) {
      return BlockQueryResult._noNextPage();
    }
    //
    return await query(
      listBehavior: ListBehavior.append,
      postQueryBehavior: postQueryBehavior,
      suggestedSelection: null,
      pageable: nxtPageable,
      navigate: null,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  @_RootMethodAnnotation()
  @_ReturnTaskResultMethodAnnotation()
  Future<bool> queryEmptyAndPrepareToCreate({
    FILTER_INPUT? filterInput,
    Function()? navigate,
  }) async {
    return await queryEmpty(
      filterInput: filterInput,
      prepareFormToCreateItem: true,
      navigate: navigate,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  @_RootMethodAnnotation()
  @_ReturnTaskResultMethodAnnotation()
  Future<bool> queryEmpty({
    FILTER_INPUT? filterInput,
    bool prepareFormToCreateItem = false,
    Function()? navigate,
  }) async {
    if (filterModel != null && filterModel!._lockAddMoreQuery) {
      return false;
    }
    FlutterArtist.codeFlowLogger._addMethodCall(
      isLibCode: true,
      navigate: navigate,
      ownerClassInstance: this,
      methodName: "queryEmpty",
      parameters: {
        "filterInput": filterInput,
      },
    );
    //
    _XShelf xShelf = await shelf._queryAll(
      forceFilterModelOpt: _FilterModelOpt(
        filterModel: _registeredOrDefaultFilterModel,
        filterInput: filterInput,
      ),
      forceQueryScalarOpts: [],
      forceQueryBlockOpts: [
        _BlockOpt(
          block: this,
          forceQuery: true,
          forceReloadItem: false,
          queryType: QueryType.emptyQuery,
          pageable: pageable,
          listBehavior: ListBehavior.replace,
          postQueryBehavior: prepareFormToCreateItem
              ? PostQueryBehavior.createNewItem
              : PostQueryBehavior.selectAnItemAsCurrent,
          suggestedSelection: null,
        ),
      ],
      forceQueryFormModelOpts: [],
    );
    //
    _XBlock xBlock = xShelf.findXBlockByName(this.name)!;
    BlockQueryResult queryResult = xBlock.queryResult;
    if (queryResult.success) {
      _executeNavigation(navigate: navigate);
    }
    return queryResult.success;
  }

  ///
  ///
  ///
  @nonVirtual
  @_RootMethodAnnotation()
  @_BlockQueryAnnotation()
  @_ReturnTaskResultMethodAnnotation()
  Future<BlockQueryResult> query({
    ListBehavior listBehavior = ListBehavior.replace,
    PostQueryBehavior postQueryBehavior =
        PostQueryBehavior.selectAnItemAsCurrentIfNeed,
    FILTER_INPUT? filterInput,
    SuggestedSelection? suggestedSelection,
    PageableData? pageable,
    Function()? navigate,
  }) async {
    if (filterModel != null && filterModel!._lockAddMoreQuery) {
      return BlockQueryResult._queryBlockedTemporarily();
    }
    FlutterArtist.codeFlowLogger._addMethodCall(
      isLibCode: true,
      navigate: navigate,
      ownerClassInstance: this,
      methodName: "query",
      parameters: {
        "listBehavior": listBehavior,
        "postQueryBehavior": postQueryBehavior,
        "filterInput": filterInput,
        "suggestedSelection": suggestedSelection,
        "pageable": pageable,
      },
    );
    //
    _XShelf xShelf = await shelf._queryAll(
      forceFilterModelOpt: _FilterModelOpt(
        filterModel: _registeredOrDefaultFilterModel,
        filterInput: filterInput,
      ),
      forceQueryScalarOpts: [],
      forceQueryBlockOpts: [
        _BlockOpt(
          block: this,
          forceQuery: true,
          // Force Reload Item.
          forceReloadItem: false,
          // ????????????
          // Must reload after query.
          pageable: pageable,
          listBehavior: listBehavior,
          postQueryBehavior: postQueryBehavior,
          suggestedSelection: suggestedSelection,
        ),
      ],
      forceQueryFormModelOpts: [],
    );
    //
    _XBlock xBlock = xShelf.findXBlockByName(this.name)!;
    BlockQueryResult queryResult = xBlock.queryResult;
    if (queryResult.success) {
      _executeNavigation(navigate: navigate);
    }
    return queryResult;
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
    ListBehavior listBehavior = ListBehavior.replace,
    SuggestedSelection<ID>? suggestedSelection,
    PageableData? pageable,
    Function()? navigate,
  }) async {
    FlutterArtist.codeFlowLogger._addMethodCall(
      isLibCode: true,
      navigate: navigate,
      ownerClassInstance: this,
      methodName: "queryAndPrepareToEdit",
      parameters: {
        "filterInput": filterInput,
        "suggestedSelection": suggestedSelection,
        "pageable": pageable,
      },
    );
    //
    _XShelf xShelf = await shelf._queryAll(
      forceFilterModelOpt: _FilterModelOpt(
        filterModel: _registeredOrDefaultFilterModel,
        filterInput: filterInput,
      ),
      forceQueryScalarOpts: [],
      forceQueryBlockOpts: [
        _BlockOpt(
          block: this,
          forceQuery: true,
          forceReloadItem: false,
          pageable: pageable,
          listBehavior: listBehavior,
          suggestedSelection: suggestedSelection,
          postQueryBehavior: PostQueryBehavior.selectAnItemAsCurrentAndLoadForm,
        ),
      ],
      forceQueryFormModelOpts: [],
    );
    //
    _XBlock xBlock = xShelf.findXBlockByName(this.name)!;
    BlockQueryResult queryResult = xBlock.queryResult;
    if (queryResult.success) {
      _executeNavigation(navigate: navigate);
    }
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
    Function()? navigate,
  }) async {
    FlutterArtist.codeFlowLogger._addMethodCall(
      isLibCode: true,
      navigate: navigate,
      ownerClassInstance: this,
      methodName: "queryAndPrepareToCreate",
      parameters: {},
    );
    //
    _XShelf xShelf = await shelf._queryAll(
      forceFilterModelOpt: _FilterModelOpt(
        filterModel: this._registeredOrDefaultFilterModel,
        filterInput: filterInput,
      ),
      forceQueryScalarOpts: [],
      forceQueryBlockOpts: [
        _BlockOpt(
          block: this,
          forceQuery: true,
          forceReloadItem: false,
          pageable: null,
          listBehavior: ListBehavior.replace,
          suggestedSelection: null,
          postQueryBehavior: PostQueryBehavior.createNewItem,
        ),
      ],
      forceQueryFormModelOpts: [],
    );
    //
    _XBlock xBlock = xShelf.findXBlockByName(this.name)!;
    BlockQueryResult queryResult = xBlock.queryResult;
    if (queryResult.success) {
      _executeNavigation(navigate: navigate);
    }
    return queryResult;
  }

  // ***************************************************************************
  // ***************************************************************************
  // ***************************************************************************

  @_AbstractMethodAnnotation()
  ID getItemId(ITEM item);

  // ***************************************************************************
  // ***************************************************************************

  @_AbstractMethodAnnotation()
  ITEM convertItemDetailToItem({required ITEM_DETAIL itemDetail});

  // ***************************************************************************
  // ***************************************************************************

  // TODO: Them tham so ITEM.
  @_AbstractMethodAnnotation()
  bool needToKeepItemInList({
    required Object? parentBlockCurrentItem,
    required FILTER_CRITERIA filterCriteria,
    required ITEM_DETAIL itemDetail,
  });

  // ***************************************************************************
  // ************* API METHOD **************************************************
  // ***************************************************************************

  @_AbstractMethodAnnotation()
  int? specifyItemIndexToSelectAsCurrent() {
    return null;
  }

  @_AbstractMethodAnnotation()
  Future<ApiResult<PageData<ITEM>?>> callApiQuery({
    required Object? parentBlockCurrentItem,
    required FILTER_CRITERIA filterCriteria,
    required PageableData pageable,
  });

  // ***************************************************************************
  // ***************************************************************************

  @_AbstractMethodAnnotation()
  Future<ApiResult<void>> callApiDeleteItemById({
    required ID itemId,
  });

  // ***************************************************************************
  // ***************************************************************************

  @_AbstractMethodAnnotation()
  Future<ApiResult<ITEM_DETAIL>> callApiLoadItemDetailById({
    required ID itemId,
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

  ID? getCurrentItemId() {
    if (this.currentItemDetail == null) {
      return null;
    }
    ITEM item = convertItemDetailToItem(
      itemDetail: this.currentItemDetail!,
    );
    return getItemId(item);
  }

  // ***************************************************************************
  // ***************************************************************************

  ITEM? __convertItemDetailToItem({required ITEM_DETAIL? itemDetail}) {
    return itemDetail == null
        ? null
        : convertItemDetailToItem(itemDetail: itemDetail);
  }

  // ***************************************************************************
  // ***************************************************************************

  Object? get parentItemId {
    if (parent == null) {
      return null;
    } else {
      return parent!.getCurrentItemId();
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  @nonVirtual
  Block getRootBlock() {
    if (parent == null) {
      return this;
    }
    return parent!.getRootBlock();
  }

  // ***************************************************************************
  // ***************************************************************************

  void __setChildrenForParent() {
    try {
      Object? itemParent = parent?.currentItemDetail;
      if (itemParent != null && this.queryDataState == DataState.ready) {
        setChildrenForParent(
          currentItemOfParentBlock: itemParent,
          items: this.items,
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

  void __setCurrentItem({
    required ITEM? item,
    required ITEM_DETAIL? itemDetail,
  }) {
    __blockData._setCurrentItemOnly(
      refreshedItemDetail: itemDetail,
      refreshedItem: item,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  ///
  /// Remove this item from Interface because it no longer exists on the server
  ///
  Future<void> __removeItemFromList({required ITEM removeItem}) async {
    FlutterArtist.codeFlowLogger._addMethodCall(
      isLibCode: true,
      navigate: null,
      ownerClassInstance: this,
      methodName: "__removeItemFromList",
      parameters: {
        "removeItem": removeItem,
      },
    );
    //
    __blockData._removeItem(removeItem: removeItem);
    ui.updateItemsView();
  }

  // ***************************************************************************
  // ***************************************************************************

  bool hasCurrentItem() {
    return this.currentItemDetail != null;
  }

  // ***************************************************************************
  // ***************************************************************************

  @_RootMethodAnnotation()
  @_BlockQuickActionAnnotation()
  @_ReturnTaskResultMethodAnnotation()
  Future<BlockQuickActionResult> executeQuickAction({
    FILTER_INPUT? filterInput,
    SuggestedSelection? suggestedSelection,
    required ActionConfirmationType actionConfirmationType,
    required BlockQuickAction action,
    required Function(BuildContext context)? navigate,
  }) async {
    FlutterArtist.codeFlowLogger._addMethodCall(
      isLibCode: true,
      navigate: null,
      ownerClassInstance: this,
      methodName: "executeQuickAction",
      parameters: {
        "filterInput": filterInput,
        "suggestedSelection": suggestedSelection,
        "action": action,
      },
    );
    //
    // @Same-Code-Precheck-01
    //
    final Actionable<BlockQuickActionPrecheck> actionable = __canQuickAction(
      checkBusy: true,
    );
    //
    if (!actionable.yes) {
      // _createItemErrorCount++;
      _addErrorLogActionable(
        shelf: shelf,
        actionableFalse: actionable,
        showErrSnackBar: true,
      );
      return BlockQuickActionResult(
        precheck: actionable.errCode,
        stackTrace: actionable.stackTrace,
      );
    }
    //
    // Confirmation:
    //
    bool confirm = true;
    if (action.needToConfirm) {
      confirm = await __showActionConfirmation(
        shelf: shelf,
        defaultConfirmation: action.defaultConfirmation,
        customConfirmation: action.createCustomConfirmation(),
      );
    }
    //
    if (!confirm) {
      return BlockQuickActionResult(
        precheck: BlockQuickActionPrecheck.cancelled,
      );
    }
    //
    List<_BlockOpt> forceQueryBlockOpts = [];
    switch (action.config.afterQuickAction) {
      case AfterBlockQuickAction.none:
        forceQueryBlockOpts = [];
      case AfterBlockQuickAction.refreshCurrentItem:
        forceQueryBlockOpts = [];
      case AfterBlockQuickAction.query:
        forceQueryBlockOpts = [
          _BlockOpt(
            block: this,
            forceQuery: true,
            forceReloadItem: false,
            pageable: null,
            listBehavior: null,
            suggestedSelection: null,
            postQueryBehavior: null,
          ),
        ];
    }
    //
    _XShelf xShelf = _XShelf(
      shelf: shelf,
      forceFilterModelOpt: _FilterModelOpt(
        filterModel: _registeredOrDefaultFilterModel,
        filterInput: filterInput,
      ),
      forceQueryScalarOpts: [],
      forceQueryBlockOpts: forceQueryBlockOpts,
      forceQueryFormModelOpts: [],
    );
    //
    _XBlock thisXBlock = xShelf.findXBlockByName(this.name)!;
    //
    _ResultedTaskUnit taskUnit = _BlockQuickActionTaskUnit(
      xBlock: thisXBlock,
      action: action,
    );
    //
    FlutterArtist.taskUnitQueue.addTaskUnit(taskUnit);
    //
    await FlutterArtist.executor._executeTaskUnitQueue();
    return taskUnit.taskResult;
  }

  // ***************************************************************************
  // ***************************************************************************

  @_RootMethodAnnotation()
  @_ReturnTaskResultMethodAnnotation()
  @_BlockQuickCreateItemActionAnnotation()
  Future<BlockQuickCreateItemResult> executeQuickCreateItemAction({
    required BlockQuickCreateItemAction<ID, ITEM, ITEM_DETAIL, FILTER_CRITERIA>
        action,
  }) async {
    FlutterArtist.codeFlowLogger._addMethodCall(
      isLibCode: true,
      navigate: null,
      ownerClassInstance: this,
      methodName: "executeQuickCreateItemAction",
      parameters: {
        "action": action,
      },
    );
    //
    // @Same-Code-Precheck-01
    //
    final Actionable<BlockQuickItemCreationPrecheck> actionable =
        __canQuickCreateItem(
      checkBusy: true,
      checkAllow: true,
    );
    if (!actionable.yes) {
      // _refreshErrorCount++;
      _addErrorLogActionable(
        shelf: shelf,
        actionableFalse: actionable,
        showErrSnackBar: true,
      );
      return BlockQuickCreateItemResult(
        precheck: actionable.errCode,
        stackTrace: actionable.stackTrace,
      );
    }
    //
    // Confirmation:
    //
    bool confirm = true;
    if (action.needToConfirm) {
      confirm = await __showActionConfirmation(
        shelf: shelf,
        defaultConfirmation: action.defaultConfirmation,
        customConfirmation: action.createCustomConfirmation(),
      );
    }
    if (!confirm) {
      return BlockQuickCreateItemResult(
        precheck: BlockQuickItemCreationPrecheck.cancelled,
      );
    }
    //
    _XShelf xShelf = _XShelf(
      shelf: shelf,
      forceFilterModelOpt: null,
      forceQueryScalarOpts: [],
      forceQueryBlockOpts: [],
      forceQueryFormModelOpts: [],
    );
    //
    _XBlock thisXBlock = xShelf.findXBlockByName(this.name)!;
    //
    _ResultedTaskUnit taskUnit = _BlockQuickCreateItemTaskUnit(
      xBlock: thisXBlock,
      action: action,
    );
    //
    FlutterArtist.taskUnitQueue.addTaskUnit(taskUnit);
    //
    await FlutterArtist.executor._executeTaskUnitQueue();
    return taskUnit.taskResult;
  }

  // ***************************************************************************
  // ***************************************************************************

  @_RootMethodAnnotation()
  @_ReturnTaskResultMethodAnnotation()
  @_BlockQuickCreateMultiItemsActionAnnotation()
  Future<BlockQuickCreateMultiItemsResult> executeQuickCreateMultiItemsAction({
    required BlockQuickCreateMultiItemsAction<ID, ITEM, ITEM_DETAIL,
            FILTER_CRITERIA>
        action,
  }) async {
    FlutterArtist.codeFlowLogger._addMethodCall(
      isLibCode: true,
      navigate: null,
      ownerClassInstance: this,
      methodName: "executeQuickCreateMultiItemsAction",
      parameters: {
        "action": action,
      },
    );
    //
    // @Same-Code-Precheck-01
    //
    Actionable<BlockMultiItemsCreationPrecheck> actionable =
        __canCreateMultiItems(
      checkBusy: true,
      checkAllow: true,
    );
    if (!actionable.yes) {
      // _refreshErrorCount++;
      _addErrorLogActionable(
        shelf: shelf,
        actionableFalse: actionable,
        showErrSnackBar: true,
      );
      return BlockQuickCreateMultiItemsResult(
        precheck: actionable.errCode,
        stackTrace: actionable.stackTrace,
      );
    }
    //
    // Confirmation:
    //
    bool confirm = true;
    if (action.needToConfirm) {
      confirm = await __showActionConfirmation(
        shelf: shelf,
        defaultConfirmation: action.defaultConfirmation,
        customConfirmation: action.createCustomConfirmation(),
      );
    }
    if (!confirm) {
      return BlockQuickCreateMultiItemsResult(
        precheck: BlockMultiItemsCreationPrecheck.cancelled,
      );
    }
    //
    _XShelf xShelf = _XShelf(
      shelf: shelf,
      forceFilterModelOpt: null,
      forceQueryScalarOpts: [],
      forceQueryBlockOpts: [],
      forceQueryFormModelOpts: [],
    );
    //
    _XBlock thisXBlock = xShelf.findXBlockByName(this.name)!;
    //
    _ResultedTaskUnit taskUnit = _BlockQuickCreateMultiItemsTaskUnit(
      xBlock: thisXBlock,
      action: action,
    );
    //
    FlutterArtist.taskUnitQueue.addTaskUnit(taskUnit);
    //
    await FlutterArtist.executor._executeTaskUnitQueue();
    return taskUnit.taskResult;
  }

  // ***************************************************************************
  // ***************************************************************************

  @_RootMethodAnnotation()
  @_ReturnTaskResultMethodAnnotation()
  @_BlockQuickUpdateItemActionAnnotation()
  Future<BlockQuickUpdateItemResult> executeQuickUpdateItemAction({
    required BlockQuickUpdateItemAction<ID, ITEM, ITEM_DETAIL, FILTER_CRITERIA>
        action,
  }) async {
    FlutterArtist.codeFlowLogger._addMethodCall(
      isLibCode: true,
      navigate: null,
      ownerClassInstance: this,
      methodName: "executeQuickUpdateItemAction",
      parameters: {
        "action": action,
      },
    );
    // @Same-Code-Precheck-01
    final Actionable<BlockQuickItemUpdatePrecheck> actionable =
        __canQuickUpdateItem(
      item: action.item,
      checkBusy: true,
      checkAllow: true,
    );
    //
    if (!actionable.yes) {
      // _createItemErrorCount++;
      _addErrorLogActionable(
        shelf: shelf,
        actionableFalse: actionable,
        showErrSnackBar: true,
      );
      return BlockQuickUpdateItemResult(
        precheck: actionable.errCode,
        stackTrace: actionable.stackTrace,
      );
    }
    //
    // Confirmation:
    //
    bool confirm = true;
    if (action.needToConfirm) {
      confirm = await __showActionConfirmation(
        shelf: shelf,
        defaultConfirmation: action.defaultConfirmation,
        customConfirmation: action.createCustomConfirmation(),
      );
    }
    if (!confirm) {
      return BlockQuickUpdateItemResult(
        precheck: BlockQuickItemUpdatePrecheck.cancelled,
      );
    }
    //
    _XShelf xShelf = _XShelf(
      shelf: shelf,
      forceFilterModelOpt: null,
      forceQueryScalarOpts: [],
      forceQueryBlockOpts: [],
      forceQueryFormModelOpts: [],
    );
    //
    _XBlock thisXBlock = xShelf.findXBlockByName(this.name)!;
    //
    _ResultedTaskUnit taskUnit = _BlockQuickUpdateItemTaskUnit(
      xBlock: thisXBlock,
      action: action,
    );
    //
    FlutterArtist.taskUnitQueue.addTaskUnit(taskUnit);
    //
    await FlutterArtist.executor._executeTaskUnitQueue();
    return taskUnit.taskResult;
  }

  // ***************************************************************************
  // ***************************************************************************

  @_RootMethodAnnotation()
  @_ReturnTaskResultMethodAnnotation()
  @_BlockQuickChildBlockItemsActionAnnotation()
  Future<bool> executeQuickChildBlockItemsAction<
      A extends BlockQuickChildBlockItemsAction<ITEM, ITEM_DETAIL>>({
    required A action,
  }) async {
    FlutterArtist.codeFlowLogger._addMethodCall(
      isLibCode: true,
      navigate: null,
      ownerClassInstance: this,
      methodName: "executeQuickChildBlockItemsAction",
      parameters: {
        "action": action,
      },
    );
    //
    // Confirmation:
    //
    bool confirm = true;
    if (action.needToConfirm) {
      confirm = await __showActionConfirmation(
        shelf: shelf,
        defaultConfirmation: action.defaultConfirmation,
        customConfirmation: action.createCustomConfirmation(),
      );
    }
    if (!confirm) {
      return false;
    }
    //
    _XShelf xShelf = _XShelf(
      shelf: shelf,
      forceFilterModelOpt: null,
      forceQueryScalarOpts: [],
      forceQueryBlockOpts: [],
      forceQueryFormModelOpts: [],
    );
    //
    _XBlock thisXBlock = xShelf.findXBlockByName(this.name)!;
    //
    _TaskUnit taskUnit = _BlockQuickChildBlockItemsTaskUnit(
      xBlock: thisXBlock,
      action: action,
    );
    //
    FlutterArtist.taskUnitQueue.addTaskUnit(taskUnit);
    //
    await FlutterArtist.executor._executeTaskUnitQueue();
    //
    return true;
  }

  // ***************************************************************************
  // ***************************************************************************

  @_RootMethodAnnotation()
  @_ReturnTaskResultMethodAnnotation()
  @_BlockRefreshAndSelectFirstItemAsCurrentAnnotation()
  Future<BlockItemCurrSelectionResult<ITEM>>
      refreshAndSelectFirstItemAsCurrent({
    bool forceLoadForm = false,
    Function()? navigate,
  }) async {
    return __refreshToShowOrEditItemAsCurrent(
      methodName: "refreshAndSelectFirstItemAsCurrent",
      item: firstItem,
      errCodeIfItemIsNull: ErrCodeIfItemIsNull.noTarget,
      forceForm: forceLoadForm,
      navigate: navigate,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  @_RootMethodAnnotation()
  @_ReturnTaskResultMethodAnnotation()
  @_BlockRefreshAndSelectNextItemAsCurrentAnnotation()
  Future<BlockItemCurrSelectionResult<ITEM>> refreshAndSelectNextItemAsCurrent({
    bool forceLoadForm = false,
    Function()? navigate,
  }) async {
    ITEM? nextItem = nextSiblingItem;
    //
    return __refreshToShowOrEditItemAsCurrent(
      methodName: "refreshAndSelectNextItemAsCurrent",
      item: nextItem,
      errCodeIfItemIsNull: ErrCodeIfItemIsNull.noTarget,
      forceForm: forceLoadForm,
      navigate: navigate,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  @_RootMethodAnnotation()
  @_ReturnTaskResultMethodAnnotation()
  @_BlockRefreshAndSelectPreviousItemAsCurrentAnnotation()
  Future<BlockItemCurrSelectionResult<ITEM>>
      refreshAndSelectPreviousItemAsCurrent({
    bool forceLoadForm = false,
    Function()? navigate,
  }) async {
    ITEM? previousItem = previousSiblingItem;
    //
    return __refreshToShowOrEditItemAsCurrent(
      methodName: "refreshAndSelectPreviousItemAsCurrent",
      item: previousItem,
      errCodeIfItemIsNull: ErrCodeIfItemIsNull.noTarget,
      forceForm: forceLoadForm,
      navigate: navigate,
    );
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
    EXTRA_FORM_INPUT? extraFormInput,
    required Function()? navigate,
    bool initDirty = false,
  }) async {
    FlutterArtist.codeFlowLogger._addMethodCall(
      isLibCode: true,
      navigate: navigate,
      ownerClassInstance: this,
      methodName: "prepareFormToCreateItem",
      parameters: {"extraFormInput": extraFormInput},
    );
    // @Same-Code-Precheck-01
    Actionable<BlockItemCreationPrecheck> actionable = __canCreateItem(
      checkBusy: true,
      checkAllow: true,
      creationType: ItemCreationType.form,
    );
    if (!actionable.yes) {
      // _createItemErrorCount++;
      _addErrorLogActionable(
        shelf: shelf,
        actionableFalse: actionable,
        showErrSnackBar: true,
      );
      return PrepareItemCreationResult(
        precheck: actionable.errCode,
        stackTrace: actionable.stackTrace,
      );
    }
    //
    extraFormInput?.formAction = FormAction.create;
    //
    _XShelf xShelf = _XShelf(
      shelf: shelf,
      forceFilterModelOpt: null,
      forceQueryScalarOpts: [],
      forceQueryBlockOpts: [],
      forceQueryFormModelOpts: [],
    );
    _XBlock thisXBlock = xShelf.findXBlockByName(this.name)!;
    //
    _TaskUnit taskUnit = _BlockPrepareFormToCreateItemTaskUnit(
      xBlock: thisXBlock,
      initDirty: initDirty,
      extraFormInput: extraFormInput,
      navigate: navigate,
    );
    //
    FlutterArtist.taskUnitQueue.addTaskUnit(taskUnit);
    //
    await FlutterArtist.executor._executeTaskUnitQueue();
    return thisXBlock.itemCreationResult;
  }

  // ***************************************************************************
  // ***************************************************************************

  @_RootMethodAnnotation()
  @_ReturnTaskResultMethodAnnotation()
  @_BlockDeleteSelectedItemsAnnotation()
  Future<BlockItemsDeletionResult<ITEM>> deleteSelectedItems({
    required CurrentItemSelInclusion currentItemInclusion,
    required bool stopIfError,
  }) async {
    List<ITEM> selItems = __blockData.getSelectedItems(
      currentItemInclusion: currentItemInclusion,
    );
    //
    return await __deleteItems(
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
    required CurrentItemChkInclusion currentItemInclusion,
    required bool stopIfError,
  }) async {
    List<ITEM> chkItems = __blockData.getCheckedItems(
      currentItemInclusion: currentItemInclusion,
    );
    //
    return await __deleteItems(
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
    return await __deleteItems(
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
    ITEM? currItem = currentItem;
    //
    return __deleteItem(
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
    return __deleteItem(
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
  Future<BlockItemCurrSelectionResult<ITEM>> refreshCurrentItem({
    bool forceLoadForm = false,
  }) async {
    return await __refreshToShowOrEditItemAsCurrent(
      methodName: 'refreshCurrentItem',
      item: this.currentItem,
      errCodeIfItemIsNull: ErrCodeIfItemIsNull.noTarget,
      forceForm: forceLoadForm,
      navigate: null,
    );
  }

  // ***************************************************************************
  // *********** isAllowXXX() method *******************************************
  // ***************************************************************************

  ///
  /// Allows reset the Form or not according to the application logic.
  ///
  bool isAllowResetForm() {
    return true;
  }

  // ***************************************************************************
  // ***************************************************************************

  ///
  /// Allows querying the block or not according to the application logic.
  ///
  bool isAllowQuery() {
    return true;
  }

  // ***************************************************************************
  // ***************************************************************************

  ///
  /// Allows creating a new Item or not according to the application logic.
  ///
  bool isAllowCreateItem() {
    return true;
  }

  // ***************************************************************************
  // ***************************************************************************

  ///
  /// Allows edit an Item or not according to the application logic.
  ///
  // TODO: Rename to isAllowToEditItem()
  bool isAllowUpdateItem({required ITEM item}) {
    return true;
  }

  // ***************************************************************************
  // ***************************************************************************

  ///
  /// Allows deleting an Item or not according to the application logic.
  ///
  bool isAllowDeleteItem({required ITEM item}) {
    return true;
  }

  // ***************************************************************************
  // ***************************************************************************

  bool isAllowUpdateCurrentItem() {
    ITEM? currentItem = this.currentItem;
    if (currentItem == null) {
      return false;
    }
    return isAllowUpdateItem(item: currentItem);
  }

  // ***************************************************************************
  // ***************************************************************************

  bool isAllowDeleteCurrentItem() {
    ITEM? currentItem = this.currentItem;
    if (currentItem == null) {
      return false;
    }
    return isAllowDeleteItem(item: currentItem);
  }

  // ***************************************************************************
  // *********** __isAllowXXX() method *****************************************
  // ***************************************************************************

  ///
  /// Allows to Query the Block.
  ///
  @_IsAllowPrivateMethodAnnotation()
  CheckAllowResult __isAllowQuery() {
    try {
      bool allow = isAllowQuery();
      return allow ? CheckAllowResult.allow() : CheckAllowResult.notAllow();
    } catch (e, stackTrace) {
      return CheckAllowResult.error(
        stackTrace: stackTrace,
      );
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  ///
  /// Allows edit current item or not according to the application logic.
  ///
  @_IsAllowPrivateMethodAnnotation()
  CheckAllowResult __isAllowResetForm() {
    try {
      bool allow = isAllowResetForm();
      return allow ? CheckAllowResult.allow() : CheckAllowResult.notAllow();
    } catch (e, stackTrace) {
      return CheckAllowResult.error(
        stackTrace: stackTrace,
      );
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  ///
  /// Allows updating an Item or not according to the application logic.
  ///
  @_IsAllowPrivateMethodAnnotation()
  CheckAllowResult _isAllowUpdateItem({
    required ITEM item,
  }) {
    try {
      bool allow = isAllowUpdateItem(item: item);
      return allow ? CheckAllowResult.allow() : CheckAllowResult.notAllow();
    } catch (e, stackTrace) {
      return CheckAllowResult.error(stackTrace: stackTrace);
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  ///
  /// Allows creating a new Item or not according to the application logic.
  ///
  @_IsAllowPrivateMethodAnnotation()
  CheckAllowResult __isAllowCreateItem() {
    try {
      bool allow = isAllowCreateItem();
      return allow ? CheckAllowResult.allow() : CheckAllowResult.notAllow();
    } catch (e, stackTrace) {
      return CheckAllowResult.error(
        stackTrace: stackTrace,
      );
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  ///
  /// Allows deleting an Item or not according to the application logic.
  ///
  @_IsAllowPrivateMethodAnnotation()
  CheckAllowResult __isAllowDeleteItem({required ITEM item}) {
    try {
      bool allow = isAllowDeleteItem(item: item);
      return allow ? CheckAllowResult.allow() : CheckAllowResult.notAllow();
    } catch (e, stackTrace) {
      return CheckAllowResult.error(
        stackTrace: stackTrace,
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
      CheckAllowResult result = __isAllowQuery();
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
            stackTrace: result.stackTrace,
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
      CheckAllowResult result = __isAllowDeleteItem(item: item);
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
            stackTrace: result.stackTrace, // [03a]
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
    List<ITEM> rmvItems = ItemsUtils.removeDuplicatedItems(
      items: items,
      getItemId: getItemId,
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
          CheckAllowResult result = __isAllowDeleteItem(item: item);
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
                stackTrace: result.stackTrace,
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
  Actionable<BlockQuickActionPrecheck> __canQuickAction({
    required bool checkBusy,
  }) {
    if (checkBusy && FlutterArtist.executor.isBusy) {
      return Actionable<BlockQuickActionPrecheck>.no(
        errCode: BlockQuickActionPrecheck.busy,
      );
    }
    switch (queryDataState) {
      case DataState.pending:
        return Actionable<BlockQuickActionPrecheck>.no(
          errCode: BlockQuickActionPrecheck.blockInPendingState,
        );
      case DataState.error:
        return Actionable<BlockQuickActionPrecheck>.no(
          errCode: BlockQuickActionPrecheck.blockInErrorState,
        );
      case DataState.none:
        return Actionable<BlockQuickActionPrecheck>.no(
          errCode: BlockQuickActionPrecheck.blockInNoneState,
        );
      case DataState.ready:
        break;
    }
    //
    return Actionable<BlockQuickActionPrecheck>.yes();
  }

  // ***************************************************************************
  // ***************************************************************************

  @_PrecheckPrivateMethod()
  Actionable<BlockMultiItemsCreationPrecheck> __canCreateMultiItems({
    required bool checkBusy,
    required bool checkAllow,
  }) {
    if (checkBusy && FlutterArtist.executor.isBusy) {
      return Actionable<BlockMultiItemsCreationPrecheck>.no(
        errCode: BlockMultiItemsCreationPrecheck.busy,
      );
    }
    switch (queryDataState) {
      case DataState.pending:
        return Actionable<BlockMultiItemsCreationPrecheck>.no(
          errCode: BlockMultiItemsCreationPrecheck.blockInPendingState,
        );
      case DataState.error:
        return Actionable<BlockMultiItemsCreationPrecheck>.no(
          errCode: BlockMultiItemsCreationPrecheck.blockInErrorState,
        );
      case DataState.none:
        return Actionable<BlockMultiItemsCreationPrecheck>.no(
          errCode: BlockMultiItemsCreationPrecheck.blockInNoneState,
        );
      case DataState.ready:
        break;
    }
    //
    if (checkAllow) {
      CheckAllowResult result = __isAllowCreateItem();
      switch (result.result) {
        case CheckAllow.allow:
          return Actionable<BlockMultiItemsCreationPrecheck>.yes();
        case CheckAllow.notAllow:
          return Actionable<BlockMultiItemsCreationPrecheck>.no(
            errCode: BlockMultiItemsCreationPrecheck.notAllow,
          );
        case CheckAllow.error:
          return Actionable<BlockMultiItemsCreationPrecheck>.no(
            errCode: BlockMultiItemsCreationPrecheck.checkAllowMethodError,
            stackTrace: result.stackTrace,
          );
      }
    }
    //
    return Actionable<BlockMultiItemsCreationPrecheck>.yes();
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
    switch (queryDataState) {
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
      CheckAllowResult result = __isAllowCreateItem();
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
            stackTrace: result.stackTrace,
          );
      }
    }
    //
    return Actionable<BlockItemCreationPrecheck>.yes();
  }

  // ***************************************************************************
  // ***************************************************************************

  @_PrecheckPrivateMethod()
  Actionable<BlockClearancePrecheck> __canClearBlock({
    required bool checkBusy,
  }) {
    if (checkBusy && FlutterArtist.executor.isBusy) {
      return Actionable<BlockClearancePrecheck>.no(
        errCode: BlockClearancePrecheck.busy,
      );
    }
    bool hasActiveUI = ui.hasActiveUIComponent(alsoCheckChildren: true);
    if (hasActiveUI) {
      return Actionable<BlockClearancePrecheck>.no(
        errCode: BlockClearancePrecheck.hasActiveUI,
      );
    }
    return Actionable<BlockClearancePrecheck>.yes();
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
    switch (queryDataState) {
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
      CheckAllowResult result = _isAllowUpdateItem(item: item);
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
            stackTrace: result.stackTrace,
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
  }) {
    if (checkBusy && FlutterArtist.executor.isBusy) {
      return Actionable<BlockQuickItemUpdatePrecheck>.no(
        errCode: BlockQuickItemUpdatePrecheck.busy,
      );
    }
    switch (queryDataState) {
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
    if (internalItem == null) {
      return Actionable<BlockQuickItemUpdatePrecheck>.no(
        errCode: BlockQuickItemUpdatePrecheck.invalidTarget,
      );
    }
    //
    if (checkAllow) {
      CheckAllowResult result = _isAllowUpdateItem(item: item);
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
            stackTrace: result.stackTrace,
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
    switch (queryDataState) {
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
      CheckAllowResult result = __isAllowCreateItem();
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
            stackTrace: result.stackTrace,
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
      CheckAllowResult result = __isAllowResetForm();
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
            stackTrace: result.stackTrace,
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
    if (formModel!.formDataState == DataState.error) {
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
      CheckAllowResult result = _isAllowUpdateItem(item: item);
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
            stackTrace: result.stackTrace,
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
  Actionable<BlockItemCurrSelectionPrecheck> __canSelectItemAsCurrent({
    required ITEM? item,
    required bool checkBusy,
    required ErrCodeIfItemIsNull errCodeIfItemIsNull,
  }) {
    if (checkBusy && FlutterArtist.executor.isBusy) {
      return Actionable<BlockItemCurrSelectionPrecheck>.no(
        errCode: BlockItemCurrSelectionPrecheck.busy,
      );
    }
    ITEM? internalItem = item;
    if (item != null) {
      internalItem = findItemSameIdWith(item: item);
    }
    // Test Cases: [03b].
    if (internalItem == null) {
      if (errCodeIfItemIsNull == ErrCodeIfItemIsNull.noTarget) {
        return Actionable<BlockItemCurrSelectionPrecheck>.no(
          errCode: BlockItemCurrSelectionPrecheck.noTarget,
        );
      } else {
        return Actionable<BlockItemCurrSelectionPrecheck>.no(
          errCode: BlockItemCurrSelectionPrecheck.invalidTarget,
        );
      }
    }
    //
    return Actionable<BlockItemCurrSelectionPrecheck>.yes();
  }

  // ***************************************************************************

  @_PrecheckPrivateMethod()
  // @seeAlso: __canSelectItemAsCurrent()
  Actionable<BlockItemCurrSelectionPrecheck> __canRefreshCurrentItem({
    required bool checkBusy,
  }) {
    if (currentItem == null) {
      return Actionable<BlockItemCurrSelectionPrecheck>.no(
        errCode: BlockItemCurrSelectionPrecheck.noTarget,
      );
    }
    if (checkBusy && FlutterArtist.executor.isBusy) {
      return Actionable<BlockItemCurrSelectionPrecheck>.no(
        errCode: BlockItemCurrSelectionPrecheck.busy,
      );
    }
    //
    return Actionable<BlockItemCurrSelectionPrecheck>.yes();
  }

  // ***************************************************************************
  // ***************************************************************************

  ///
  /// Edit on edit-mode
  /// Edit on creation-mode
  ///
  @_PrecheckPrivateMethod()
  Actionable<BlockFormEnablementChkCode> __isEnableFormToModify({
    required bool checkAllow,
  }) {
    if (formModel == null) {
      return Actionable<BlockFormEnablementChkCode>.no(
        errCode: BlockFormEnablementChkCode.noForm,
      );
    }
    //
    switch (formModel!.formMode) {
      case FormMode.none:
        return Actionable<BlockFormEnablementChkCode>.no(
          errCode: BlockFormEnablementChkCode.formInNoneMode,
        );
      case FormMode.creation:
        if (formModel!.formDataState == DataState.error) {
          // TODO-XXX (Test case).
          if (!formModel!.formInitialDataReady) {
            return Actionable<BlockFormEnablementChkCode>.no(
              errCode: BlockFormEnablementChkCode.formInitialDataNotReady,
            );
          }
        }
        return Actionable<BlockFormEnablementChkCode>.yes();
      case FormMode.edit:
        if (checkAllow) {
          CheckAllowResult result = _isAllowUpdateItem(item: currentItem!);
          switch (result.result) {
            case CheckAllow.allow:
              return Actionable<BlockFormEnablementChkCode>.yes();
            case CheckAllow.notAllow:
              return Actionable<BlockFormEnablementChkCode>.no(
                errCode: BlockFormEnablementChkCode.notAllow,
              );
            case CheckAllow.error:
              return Actionable<BlockFormEnablementChkCode>.no(
                errCode: BlockFormEnablementChkCode.checkAllowMethodError,
                stackTrace: result.stackTrace,
              );
          }
        }
        return Actionable<BlockFormEnablementChkCode>.yes();
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
  Actionable<BlockQuickActionPrecheck> canQuickAction() {
    return __canQuickAction(
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
  Actionable<BlockClearancePrecheck> canClearBlock() {
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
  }) {
    return __canQuickUpdateItem(
      checkBusy: true,
      item: item,
      checkAllow: checkAllow,
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
  Actionable<BlockItemCurrSelectionPrecheck> canSelectItemAsCurrent({
    required ITEM item,
  }) {
    return __canSelectItemAsCurrent(
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
  // @seeAlso: canSelectItemAsCurrent()
  Actionable<BlockItemCurrSelectionPrecheck> canRefreshCurrentItem() {
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
  Actionable<BlockFormEnablementChkCode> isEnableFormToModify({
    bool checkAllow = true,
  }) {
    return __isEnableFormToModify(
      checkAllow: checkAllow,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  Actionable<BlockFormEnablementChkCode> _isEnableFormToModify() {
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
    if (this.currentItem == null) {
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

  void __updateUIComponentAfterCheckedOrSelected() {
    ui.updateAllUIComponents(
      withoutFilters: false,
      force: true,
    );
  }

  void sort({required bool refresh}) {
    __blockData._sortItems();
    if (refresh) {
      shelf.ui.updateAllUIComponents();
    }
  }

  // ***************************************************************************
  // ***** BLOCK DATA **********************************************************
  // ***************************************************************************

  int get currentItemChangeCount => __blockData._currentItemChangeCount;

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
    return [...__blockData._checkedItems];
  }

  ///
  /// return a copied list of selected items.
  ///
  List<ITEM> get selectedItems {
    return [...__blockData._selectedItems];
  }

  // ***************************************************************************
  // ***************************************************************************

  bool isCurrentItem({
    required ITEM item,
  }) {
    final ITEM? currIt = currentItem;
    return currIt != null && getItemId(item) == getItemId(currIt);
  }

  // ***************************************************************************
  // ***************************************************************************

  bool isCurrentIndex({required int index}) {
    ITEM? item = findItemByIndex(index);
    if (item == null) {
      return false;
    }
    return isCurrentItem(item: item);
  }

  // ***************************************************************************
  // ***************************************************************************

  bool isSelectedIndex({required int index}) {
    ITEM? item = findItemByIndex(index);
    if (item == null) {
      return false;
    }
    return isSelectedItem(item: item);
  }

  // ***************************************************************************
  // ***************************************************************************

  bool isSelectedItem({required ITEM item}) {
    return ItemsUtils.isListContainItem(
      targetList: __blockData._selectedItems,
      item: item,
      getItemId: getItemId,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  bool isCurrentAndSelectedItem({required ITEM item}) {
    bool c = isCurrentItem(item: item);
    if (c) {
      return isSelectedItem(item: item);
    }
    return false;
  }

  // ***************************************************************************
  // ***************************************************************************

  bool isCurrentAndCheckedItem({required ITEM item}) {
    bool c = isCurrentItem(item: item);
    if (c) {
      return isCheckedItem(item: item);
    }
    return false;
  }

  // ***************************************************************************
  // ***************************************************************************

  bool isCurrentItemSelected() {
    ITEM? c = currentItem;
    if (c == null) {
      return false;
    }
    return isSelectedItem(item: c);
  }

  // ***************************************************************************
  // ***************************************************************************

  bool isCurrentItemChecked() {
    ITEM? c = currentItem;
    if (c == null) {
      return false;
    }
    return isCheckedItem(item: c);
  }

  // ***************************************************************************
  // ***************************************************************************

  void __setSelectedItem({required ITEM item, required bool selected}) {
    if (selected) {
      ItemsUtils.insertOrReplaceItemInList(
        item: item,
        targetList: __blockData._selectedItems,
        getItemId: getItemId,
      );
    } else {
      ItemsUtils.removeItemFromList(
        removeItem: item,
        targetList: __blockData._selectedItems,
        getItemId: getItemId,
      );
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  void __toggleSelectItem({required ITEM item}) {
    bool selected = isSelectedItem(item: item);
    __setSelectedItem(item: item, selected: !selected);
  }

  // ***************************************************************************
  // ***************************************************************************

  void setSelectedItem({required ITEM item, required bool selected}) {
    __setSelectedItem(item: item, selected: selected);
    __updateUIComponentAfterCheckedOrSelected();
  }

  // ***************************************************************************
  // ***************************************************************************

  void toggleSelectItem({required ITEM item}) {
    __toggleSelectItem(item: item);
    __updateUIComponentAfterCheckedOrSelected();
  }

  // ***************************************************************************
  // ***************************************************************************

  void __setSelectedItems({required List<ITEM> items}) {
    ItemsUtils.insertOrReplaceItemsInList(
      items: items,
      targetList: __blockData._selectedItems,
      getItemId: getItemId,
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
      return getItemId(item1) == getItemId(item2);
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
  bool get isFirstItemCurrent {
    ITEM? first = firstItem;
    ITEM? current = currentItem;
    if (first == null || current == null) {
      return false;
    }
    return getItemId(first) == getItemId(current);
  }

  // ***************************************************************************
  // ***************************************************************************

  ///
  /// Check if the last item is current item.
  ///
  bool get isLastItemCurrent {
    ITEM? last = lastItem;
    ITEM? current = currentItem;
    if (last == null || current == null) {
      return false;
    }
    return getItemId(last) == getItemId(current);
  }

  // ***************************************************************************
  // ***************************************************************************

  ITEM? findNextSiblingItem({
    required ITEM item,
  }) {
    return ItemsUtils.findNextSiblingItemInList(
      item: item,
      targetList: __blockData._items,
      getItemId: getItemId,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  ITEM? findPreviousSiblingItem({
    required ITEM item,
  }) {
    return ItemsUtils.findPreviousSiblingItemInList(
      item: item,
      targetList: __blockData._items,
      getItemId: getItemId,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  ITEM? findSiblingItem({
    required ITEM item,
  }) {
    return ItemsUtils.findSiblingItemInList(
      item: item,
      targetList: __blockData._items,
      getItemId: getItemId,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  ITEM? findItemSameIdWith({
    required ITEM item,
  }) {
    ID id = getItemId(item);
    return findItemById(id);
  }

  // ***************************************************************************
  // ***************************************************************************

  ITEM? findItemById(ID itemId) {
    return ItemsUtils.findItemInListById(
      id: itemId,
      targetList: __blockData._items,
      getItemId: getItemId,
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

  bool containsItem({required ITEM item}) {
    return ItemsUtils.isListContainItem(
      targetList: __blockData._items,
      item: item,
      getItemId: getItemId,
    );
  }

  bool isCheckedItem({required ITEM item}) {
    return ItemsUtils.isListContainItem(
      targetList: __blockData._checkedItems,
      item: item,
      getItemId: getItemId,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  bool isCheckedIndex({required int index}) {
    ITEM? item = findItemByIndex(index);
    if (item == null) {
      return false;
    }
    return isCheckedItem(item: item);
  }

  // ***************************************************************************
  // ***************************************************************************

  void __setCheckedItem({required ITEM item, required bool checked}) {
    if (checked) {
      ItemsUtils.insertOrReplaceItemInList(
        item: item,
        targetList: __blockData._checkedItems,
        getItemId: getItemId,
      );
    } else {
      ItemsUtils.removeItemFromList(
        removeItem: item,
        targetList: __blockData._checkedItems,
        getItemId: getItemId,
      );
    }
  }

  void __toggleCheckItem({required ITEM item}) {
    bool checked = isCheckedItem(item: item);
    __setCheckedItem(item: item, checked: !checked);
  }

  void toggleCheckItem({required ITEM item}) {
    __toggleCheckItem(item: item);
    __updateUIComponentAfterCheckedOrSelected();
  }

  void setCheckedItem({required ITEM item, required bool checked}) {
    __setCheckedItem(item: item, checked: checked);
    __updateUIComponentAfterCheckedOrSelected();
  }

  // ***************************************************************************
  // ***************************************************************************

  void __setCheckedItems({required List<ITEM> items}) {
    ItemsUtils.insertOrReplaceItemsInList(
      items: items,
      targetList: __blockData._checkedItems,
      getItemId: getItemId,
    );
  }

  void setCheckedItems({required List<ITEM> items}) {
    __setCheckedItems(items: items);
    __updateUIComponentAfterCheckedOrSelected();
  }

  void checkAllItems() {
    __setCheckedItems(items: __blockData._items);
    __updateUIComponentAfterCheckedOrSelected();
  }

  // ***************************************************************************
  // ***************************************************************************

  void setSelectedItems({required List<ITEM> items}) {
    __setSelectedItems(items: items);
    __updateUIComponentAfterCheckedOrSelected();
  }

  // ***************************************************************************
  // ***************************************************************************

  void uncheckAllItems() {
    __blockData._checkedItems.clear();
    __updateUIComponentAfterCheckedOrSelected();
  }

  // ***************************************************************************
  // ***************************************************************************

  void __selectAllItems() {
    __setSelectedItems(items: __blockData._items);
  }

  void selectAllItems() {
    __selectAllItems();
    __updateUIComponentAfterCheckedOrSelected();
  }

  // ***************************************************************************
  // ***************************************************************************

  void deselectAllItems() {
    __blockData._selectedItems.clear();
    __updateUIComponentAfterCheckedOrSelected();
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

  // TODO: Allow change position??
  bool _checkForChangeItemPosition() {
    if (false) {
      showErrorSnackBar(message: "Can not change position", errorDetails: null);
      return false;
    }
    return true;
  }

  // bool swapItemsByIndexes({required int index1, required int index2}) {
  //   if (!_checkForChangeItemPosition()) {
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
    if (!_checkForChangeItemPosition()) {
      return false;
    }
    bool success = ItemsUtils.swapPositionsByIds(
      itemId1: getItemId(item1),
      itemId2: getItemId(item2),
      targetList: __blockData._items,
      getItemId: getItemId,
    );
    if (success) {
      ui.updateAllUIComponents(withoutFilters: true);
    }
    return success;
  }

  // ***************************************************************************
  // ***************************************************************************

  bool moveItemToNewIndexPosition({
    required ITEM item,
    required int newIndexPosition,
  }) {
    if (!_checkForChangeItemPosition()) {
      return false;
    }
    bool success = ItemsUtils.moveItemToNewIndexPosition(
      item: item,
      newIndexPosition: newIndexPosition,
      targetList: __blockData._items,
      getItemId: getItemId,
    );
    if (success) {
      ui.updateAllUIComponents(withoutFilters: true);
    }
    return success;
  }

  // ***************************************************************************
  // ***************************************************************************

  void __refreshQueryingState({required bool isQuerying}) {
    try {
      __isQuerying = isQuerying;
      ui.updateControlBarWidgets(force: true);
    } catch (e) {}
  }

  // ***************************************************************************
  // ***************************************************************************

  void __refreshDeletingState({required bool isDeleting}) {
    try {
      __isDeleting = isDeleting;
      ui.updateControlBarWidgets(force: true);
    } catch (e) {}
  }

  // ***************************************************************************
  // ***************************************************************************

  void _refreshSavingState({required bool isSaving}) {
    try {
      __isSaving = isSaving;
      ui.updateControlBarWidgets(force: true);
    } catch (e) {}
  }

  // ***************************************************************************
  // ***************************************************************************

  void __refreshRefreshingCurrentItemState({
    required bool isRefreshingCurrentItem,
  }) {
    try {
      __isRefreshingCurrentItem = isRefreshingCurrentItem;
      ui.updateControlBarWidgets(force: true);
    } catch (e) {}
  }

  // ***************************************************************************
  // ***************************************************************************

  void __refreshPreparingFormCreationState({
    required bool isPreparingFormCreation,
  }) {
    try {
      __isPreparingFormCreation = isPreparingFormCreation;
      ui.updateControlBarWidgets(force: true);
    } catch (e) {}
  }

  // ***************************************************************************
  // ***************************************************************************

  bool moveItemByIndexPosition({
    required int oldIndexPosition,
    required int newIndexPosition,
  }) {
    if (!_checkForChangeItemPosition()) {
      return false;
    }
    bool success = ItemsUtils.moveItemByIndexPosition(
      oldIndexPosition: oldIndexPosition,
      newIndexPosition: newIndexPosition,
      targetList: __blockData._items,
      getItemId: getItemId,
    );
    if (success) {
      ui.updateAllUIComponents(withoutFilters: true);
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

  void showFilterCriteriaDialog() {
    BuildContext context = FlutterArtist.adapter.getCurrentContext();
    //
    FilterCriteriaDialog.showBlockFilterCriteriaDialog(
      context: context,
      block: this,
    );
  }

  // ***************************************************************************
  // ***************************************************************************
  // ***************************************************************************

  void __assertThisXBlock(_XBlock thisXBlock) {
    if (thisXBlock.block != this || thisXBlock.name != name) {
      String message = "Error Assets block: ${thisXBlock.block} - $this";
      print("FATAL ERROR: $message");
      throw message;
    }
  }
}
