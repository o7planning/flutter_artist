part of '../flutter_artist.dart';

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
/// via the [FilterModel.createFilterCriteria] method
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
    > extends _XBase {
  late final Shelf shelf;

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

  final bool leaveTheFormSafely;

  ///
  /// Block name. It is unique in a Shelf.
  ///
  final String name;

  String get _shortPathName {
    return "${shelf.name} > $name";
  }

  String get id {
    return "block > ${shelf.name} > $name";
  }

  String get _classDefinition {
    return "${getClassName(this)}$_classParametersDefinition";
  }

  String get _classParametersDefinition {
    return "<${getItemIdTypeAsString()}, ${getItemTypeAsString()}, ${getItemDetailTypeAsString()}, "
        "${getFilterInputTypeAsString()}, ${getFilterCriteriaTypeAsString()}, ${getExtraFormInputTypeAsString()}>";
  }

  final String? description;

  final BlockHiddenBehavior hiddenBehavior;

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

  int __callApiRefreshItemCount = 0;

  int get callApiRefreshItemCount => __callApiRefreshItemCount;

  int __callApiQueryCount = 0;

  int get callApiQueryCount => __callApiQueryCount;

  final int? __pageSize;

  final bool fireEvent;

  final List<Type> __listenItemTypes;

  List<Type> get listenItemTypes => [...__listenItemTypes];

  PageableData? get __pageable => __pageSize == null
      ? null
      : PageableData(
          page: 1,
          pageSize: __pageSize,
        );

  late final data = BlockData<
      ID, //
      ITEM,
      ITEM_DETAIL,
      FILTER_INPUT,
      FILTER_CRITERIA,
      EXTRA_FORM_INPUT>._(
    this,
    __pageable,
  );

  DataState get queryDataState => this.data._queryDataState;

  DataState get selectionDataState => this.data._selectionDataState;

  final ItemSortCriteria? _itemSortCriteria;

  ItemSortCriteria? get itemSortCriteria => _itemSortCriteria;

  final Map<_RefreshableWidgetState, _XState> _blockFragmentWidgetStates = {};
  final Map<_RefreshableWidgetState, _XState> _controlBarWidgetStates = {};
  final Map<_RefreshableWidgetState, _XState> _controlWidgetStates = {};
  final Map<_RefreshableWidgetState, _XState> _paginationWidgetStates = {};

  // ***************************************************************************
  // ***************************************************************************

  Block({
    required this.name,
    required this.description,
    int pageSize = 20,
    this.hiddenBehavior = BlockHiddenBehavior.none,
    this.leaveTheFormSafely = true,
    required String? filterModelName,
    required this.formModel,
    required this.fireEvent,
    required List<Type> listenItemTypes,
    required List<Block>? childBlocks,
    ItemSortCriteria<ITEM>? itemSortCriteria,
  })  : registerFilterModelName = filterModelName,
        __pageSize = pageSize,
        __listenItemTypes = listenItemTypes,
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

  void __clearWithDataState({
    required _XBlock thisXBlock,
    required DataState queryDataState,
    required DataState formDataState,
  }) {
    __assertThisXBlock(thisXBlock);
    //
    this.data._clearWithDataState(queryDataState: queryDataState);
    if (formModel != null) {
      formModel!._clearWithDataState(formDataState: formDataState);
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  void __clearWithDataStateCascade({
    required _XBlock thisXBlock,
    required DataState queryDataState,
    required DataState formDataState,
  }) {
    __assertThisXBlock(thisXBlock);
    //
    __clearWithDataState(
      thisXBlock: thisXBlock,
      queryDataState: queryDataState,
      formDataState: formDataState,
    );
    //
    for (var childXBlock in thisXBlock.childXBlocks) {
      childXBlock.block.__clearWithDataStateCascade(
        thisXBlock: childXBlock,
        queryDataState: queryDataState,
        formDataState: formDataState,
      );
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  void __clearChildrenWithDataStateCascade({
    required _XBlock thisXBlock,
    required DataState queryDataState,
    required DataState formDataState,
  }) {
    __assertThisXBlock(thisXBlock);
    //
    for (var childXBlock in thisXBlock.childXBlocks) {
      childXBlock.block.__clearWithDataStateCascade(
        thisXBlock: childXBlock,
        queryDataState: queryDataState,
        formDataState: formDataState,
      );
    }
  }

  // ***************************************************************************
  // ************ TYPES ********************************************************
  // ***************************************************************************

  Type getItemType() {
    return ITEM;
  }

  Type getItemDetailType() {
    return ITEM_DETAIL;
  }

  Type getFilterCriteriaType() {
    return FILTER_CRITERIA;
  }

  String getItemIdTypeAsString() {
    return ID.toString();
  }

  String getItemTypeAsString() {
    return ITEM.toString();
  }

  String getItemDetailTypeAsString() {
    return ITEM_DETAIL.toString();
  }

  String getFilterInputTypeAsString() {
    return FILTER_INPUT.toString();
  }

  String getFilterCriteriaTypeAsString() {
    return FILTER_CRITERIA.toString();
  }

  String getExtraFormInputTypeAsString() {
    return EXTRA_FORM_INPUT.toString();
  }

  // ***************************************************************************
  // ************ Need to Query State ******************************************
  // ***************************************************************************

  bool _needToQuery() {
    if (queryDataState != DataState.ready) {
      return true;
    }
    //
    Object? parentInData = this.data._currentParentItemId;
    Object? parentInBlock = parentItemId;
    if (parentInData != parentInBlock) {
      return true;
    }
    //
    if (filterModel != null) {
      FilterCriteria? criteriaInFilter = filterModel!.filterCriteria;
      FilterCriteria? criteriaInData = this.data.filterCriteria;
      if (criteriaInFilter != criteriaInData) {
        return true;
      }
    }
    //
    return false;
  }

  // ***************************************************************************
  // ***************************************************************************

  void __refreshQueryingState({required bool isQuerying}) {
    try {
      __isQuerying = isQuerying;
      this.updateControlBarWidgets(force: true);
    } catch (e) {}
  }

  // ***************************************************************************
  // ***************************************************************************

  void __refreshDeletingState({required bool isDeleting}) {
    try {
      __isDeleting = isDeleting;
      this.updateControlBarWidgets(force: true);
    } catch (e) {}
  }

  // ***************************************************************************
  // ***************************************************************************

  void _refreshSavingState({required bool isSaving}) {
    try {
      __isSaving = isSaving;
      this.updateControlBarWidgets(force: true);
    } catch (e) {}
  }

  // ***************************************************************************
  // ***************************************************************************

  void __refreshRefreshingCurrentItemState({
    required bool isRefreshingCurrentItem,
  }) {
    try {
      __isRefreshingCurrentItem = isRefreshingCurrentItem;
      this.updateControlBarWidgets(force: true);
    } catch (e) {}
  }

  // ***************************************************************************
  // ***************************************************************************

  void __refreshPreparingFormCreationState({
    required bool isPreparingFormCreation,
  }) {
    try {
      __isPreparingFormCreation = isPreparingFormCreation;
      this.updateControlBarWidgets(force: true);
    } catch (e) {}
  }

  // ***************************************************************************
  // ***************************************************************************

  void _addPaginationWidgetState({
    required _RefreshableWidgetState widgetState,
    required bool isShowing,
  }) {
    _paginationWidgetStates.update(
      widgetState,
      (xState) => xState..isShowing = isShowing,
      ifAbsent: () => _XState()..isShowing = isShowing,
    );
    //
    if (isShowing) {
      FlutterArtist.storage._addRecentShelf(shelf);
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  void _removePaginationWidgetState({
    required _RefreshableWidgetState widgetState,
  }) {
    _paginationWidgetStates.remove(widgetState);
  }

  // ***************************************************************************
  // ***************************************************************************

  void _addControlBarWidgetState({
    required _RefreshableWidgetState widgetState,
    required bool isShowing,
  }) {
    bool activeOLD = hasActiveUIComponent();
    _controlBarWidgetStates.update(
      widgetState,
      (xState) => xState..isShowing = isShowing,
      ifAbsent: () => _XState()..isShowing = isShowing,
    );
    bool activeCURRENT = hasActiveUIComponent();
    //
    if (isShowing) {
      FlutterArtist.storage._addRecentShelf(shelf);
    }
    //
    if (!activeOLD && activeCURRENT) {
      // Fire event:
      shelf._startNewLazyQueryTransactionIfNeed();
    } else if (activeOLD && !activeCURRENT) {
      _fireBlockHidden();
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  void _removeControlBarWidgetState({
    required _RefreshableWidgetState widgetState,
  }) {
    _controlBarWidgetStates.remove(widgetState);
  }

  // ***************************************************************************
  // ***************************************************************************

  void _addControlWidgetState({
    required _RefreshableWidgetState widgetState,
    required bool isShowing,
  }) {
    bool activeOLD = hasActiveUIComponent();
    _controlWidgetStates.update(
      widgetState,
      (xState) => xState..isShowing = isShowing,
      ifAbsent: () => _XState()..isShowing = isShowing,
    );
    bool activeCURRENT = hasActiveUIComponent();
    //
    if (isShowing) {
      FlutterArtist.storage._addRecentShelf(shelf);
    }
    //
    if (!activeOLD && activeCURRENT) {
      // Fire event:
      shelf._startNewLazyQueryTransactionIfNeed();
    } else if (activeOLD && !activeCURRENT) {
      _fireBlockHidden();
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  void _removeControlWidgetState({
    required _RefreshableWidgetState widgetState,
  }) {
    _controlWidgetStates.remove(widgetState);
  }

  // ***************************************************************************
  // ***************************************************************************

  void _addBlockFragmentWidgetState({
    required _RefreshableWidgetState widgetState,
    required bool isShowing,
  }) {
    bool activeOLD = hasActiveUIComponent();
    _blockFragmentWidgetStates.update(
      widgetState,
      (xState) => xState..isShowing = isShowing,
      ifAbsent: () => _XState()..isShowing = isShowing,
    );
    bool activeCURRENT = hasActiveUIComponent();
    //
    if (isShowing) {
      FlutterArtist.storage._addRecentShelf(shelf);
    }
    //
    if (!activeOLD && activeCURRENT) {
      // Fire event:
      shelf._startNewLazyQueryTransactionIfNeed();
    } else if (activeOLD && !activeCURRENT) {
      _fireBlockHidden();
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  void _removeBlockFragmentWidgetState({required State widgetState}) {
    bool activeOLD = hasActiveUIComponent();
    _blockFragmentWidgetStates.remove(widgetState);
    bool activeCURRENT = hasActiveUIComponent();
    //
    if (activeOLD && !activeCURRENT) {
      _fireBlockHidden();
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  void _fireBlockHidden() {
    FlutterArtist.codeFlowLogger._addEvent(
      ownerClassInstance: this,
      event: "Block '${getClassName(this)}' just hides all UI Components!",
      isLibCode: true,
    );
    if (hiddenBehavior == BlockHiddenBehavior.clear) {
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

  Map<_RefreshableWidgetState, _XState> _findMountedWidgetStates({
    required bool withPagination,
    required bool withBlockFragment,
    required bool withFilter,
    required bool withForm,
    required bool withControl,
    required bool withControlBar,
    required bool activeOnly,
  }) {
    Map<_RefreshableWidgetState, _XState> ret = {};
    //
    if (withFilter) {
      ret.addAll(_registeredOrDefaultFilterModel._filterFragmentWidgetStates);
    }
    //
    if (withBlockFragment) {
      ret.addAll(_blockFragmentWidgetStates);
    }
    //
    if (withPagination) {
      ret.addAll(_paginationWidgetStates);
    }
    //
    if (withControlBar) {
      ret.addAll(_controlBarWidgetStates);
    }
    if (withControl) {
      ret.addAll(_controlWidgetStates);
    }
    //
    if (withForm && formModel != null) {
      ret.addAll(formModel!._formWidgetStates);
    }
    return ret;
  }

  // ***************************************************************************
  // ***************************************************************************

  bool hasMountedUIComponent() {
    return (filterModel?.hasMountedUIComponent() ?? false) ||
        _blockFragmentWidgetStates.isNotEmpty ||
        _controlBarWidgetStates.isNotEmpty ||
        _controlWidgetStates.isNotEmpty ||
        _paginationWidgetStates.isNotEmpty ||
        (formModel?.hasMountedUIComponent() ?? false);
  }

  // ***************************************************************************
  // ***************************************************************************

  bool hasActiveUIComponent() {
    bool active = false;
    // Filter
    if (filterModel != null) {
      active = filterModel!.hasActiveUIComponent();
      if (active) {
        return true;
      }
    }
    // Form
    active = formModel != null && formModel!.hasActiveUIComponent();
    if (active) {
      return true;
    }
    // Block Fragment:
    active = hasActiveBlockFragmentWidget(alsoCheckChildren: false);
    if (active) {
      return true;
    }
    // ControlBar:
    active = hasActiveControlBarWidget();
    if (active) {
      return true;
    }
    // Control
    active = hasActiveControlWidget();
    if (active) {
      return true;
    }
    // Pagination
    active = hasActivePaginationWidget();
    //
    return active;
  }

  // ***************************************************************************
  // ***************************************************************************

  bool hasActiveBlockFragmentWidget({required bool alsoCheckChildren}) {
    var map = {..._blockFragmentWidgetStates};
    for (State widgetState in map.keys) {
      if (widgetState.mounted) {
        bool isShowing = map[widgetState]?.isShowing ?? false;
        if (isShowing) {
          return true;
        }
      }
    }
    if (alsoCheckChildren) {
      for (Block childBlock in _childBlocks) {
        bool active =
            childBlock.hasActiveBlockFragmentWidget(alsoCheckChildren: true);
        if (active) {
          return true;
        }
      }
    }
    return false;
  }

  // ***************************************************************************
  // ***************************************************************************

  bool hasActiveControlBarWidget() {
    for (_RefreshableWidgetState controlBarState
        in _controlBarWidgetStates.keys) {
      bool visible =
          _controlBarWidgetStates[controlBarState]?.isShowing ?? false;
      if (visible && controlBarState.mounted) {
        return true;
      }
    }
    return false;
  }

  // ***************************************************************************
  // ***************************************************************************

  bool hasActiveControlWidget() {
    for (_RefreshableWidgetState controlState in _controlWidgetStates.keys) {
      bool visible = _controlWidgetStates[controlState]?.isShowing ?? false;
      if (visible && controlState.mounted) {
        return true;
      }
    }
    return false;
  }

  // ***************************************************************************
  // ***************************************************************************

  bool hasActivePaginationWidget() {
    for (_RefreshableWidgetState paginationState
        in _paginationWidgetStates.keys) {
      bool visible =
          _paginationWidgetStates[paginationState]?.isShowing ?? false;
      if (visible && paginationState.mounted) {
        return true;
      }
    }
    return false;
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

  Future<void> _unitClearCurrent({required _XBlock thisXBlock}) async {
    __assertThisXBlock(thisXBlock);
    //
    this.__setCurrentItem(item: null, itemDetail: null);
    this.__clearChildrenWithDataStateCascade(
      thisXBlock: thisXBlock,
      queryDataState: DataState.none,
      formDataState: DataState.none,
    );
    if (formModel != null) {
      formModel!._clearWithDataState(formDataState: DataState.none);
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  Future<BlockQueryResult> _unitQuery({required _XBlock thisXBlock}) async {
    __assertThisXBlock(thisXBlock);
    //
    bool hasActiveUI = this.hasActiveUIComponent();
    bool forceQuery = thisXBlock.forceQuery;
    if (!forceQuery) {
      if (this.queryDataState != DataState.ready && hasActiveUI) {
        forceQuery = true;
      }
    }
    //
    print(
        "\n\n>> ${getClassName(this)}._unitQuery - queryState: $queryDataState, REAL QUERY --> $forceQuery");
    //
    thisXBlock._printParameters(hasActiveUI: hasActiveUI);
    //
    if (!forceQuery) {
      FlutterArtist.taskUnitQueue.addTaskUnit(
        _BlockSelectAsCurrentTaskUnit<ITEM>(
          currentItemSelectionType:
              CurrentItemSelectionType.selectAsCurrentForDefault,
          xBlock: thisXBlock,
          newQueriedList: [],
          candidateItem: null,
          forceForm: null,
        ),
      );
      return thisXBlock.queryResult;
    }
    //
    // thisXBlock.forceQuery || (hasActiveUI && this.queryDataState != DataState.ready)
    //
    DataState newQueryDataState = this.queryDataState;
    //
    FILTER_CRITERIA? filterCriteria;
    try {
      final _XFilterModel xFilterModel = thisXBlock.xFilterModel;
      final FilterModel filterModel = xFilterModel.filterModel;
      //
      if (!xFilterModel.queried) {
        FILTER_INPUT? filterInput = xFilterModel.filterInput as FILTER_INPUT?;
        //
        filterCriteria = await filterModel._startNewFilterTransaction(
          filterInput: filterInput,
        ) as FILTER_CRITERIA?;
        //
        xFilterModel.queried = true;
      } else {
        filterCriteria = filterModel._filterCriteria! as FILTER_CRITERIA;
      }
    } catch (e, stackTrace) {
      /* Never Error */
    }
    //
    // Has Error in FilterModel.
    //
    if (filterCriteria == null) {
      // Set Block to error cascade.
      __clearWithDataStateCascade(
        thisXBlock: thisXBlock,
        queryDataState: DataState.error,
        formDataState: DataState.error,
      );
      thisXBlock.queryResult._filterError = true;
      return thisXBlock.queryResult;
    }
    //
    // Ready FilterCriteria:
    //
    final bool xCriteriaChanged = this.data._isXCriteriaChanged(
          newCurrentParentItemId: parentItemId,
          newFilterCriteria: filterCriteria,
        );
    //
    final PageableData callingPageable = thisXBlock.pageable ??
        __pageable ??
        const PageableData(page: 1, pageSize: null);
    //
    final ListBehavior realListBehavior;
    final int currentItemCount = this.data.itemCount;
    //
    if (xCriteriaChanged) {
      //
      // IMPORTANT:
      //
      realListBehavior = ListBehavior.replace;
    } else {
      realListBehavior = thisXBlock.listBehavior;
    }
    bool isQueryError = false;
    List<ITEM> newQueriedList = [];
    PageData<ITEM>? pageData;
    //
    // Call Query API:
    //
    try {
      __refreshQueryingState(isQuerying: true);
      //
      FlutterArtist.codeFlowLogger._addMethodCall(
        isLibCode: false,
        navigate: null,
        ownerClassInstance: this,
        methodName: "callApiQuery",
        parameters: {},
      );
      //
      __callApiQueryCount++;
      ApiResult<PageData<ITEM>?> result = await callApiQuery(
        filterCriteria: filterCriteria,
        pageable: callingPageable,
      );
      //
      if (result.isError()) {
        _handleRestError(
          shelf: shelf,
          methodName: "callApiQuery",
          message: result.errorMessage!,
          errorDetails: result.errorDetails,
          showSnackBar: true,
        );
        isQueryError = true;
      } else {
        pageData = result.data;
        newQueriedList = pageData?.items ?? [];
      }
    } catch (e, stackTrace) {
      _handleError(
        shelf: shelf,
        methodName: 'callApiQuery',
        error: "Error callApiQuery: $e",
        stackTrace: stackTrace,
        showSnackBar: true,
      );
      isQueryError = true;
    } finally {
      __refreshQueryingState(isQuerying: false);
    }
    //
    if (isQueryError) {
      thisXBlock.queryResult._apiError = true;
      //
      switch (realListBehavior) {
        case ListBehavior.replace:
          newQueryDataState = xCriteriaChanged //
              ? DataState.error
              : DataState.ready;
        case ListBehavior.append:
          //
          // (For Sure: xCriteriaChanged = false)
          //
          newQueryDataState = currentItemCount > 0 //
              ? DataState.ready
              : DataState.error;
      }
    } else {
      thisXBlock.queryResult._apiError = false;
      //
      newQueryDataState = DataState.ready;
    }
    //
    final ITEM? currentItem = this.data.currentItem;
    //
    // Update queried items to the List:
    //
    this.data._updateFrom(
          forceListBehavior: realListBehavior,
          currentParentItemId: this.parentItemId,
          filterCriteria: filterCriteria,
          pageable: callingPageable,
          pageData: pageData,
          queryDataState: newQueryDataState,
        );
    //
    final bool currentItemInList =
        currentItem != null && this.data.containsItem(item: currentItem);
    final ITEM? candidateCurrentItem = currentItemInList ? currentItem : null;
    //
    if (formModel != null) {
      if (!currentItemInList) {
        formModel!._clearWithDataState(
          formDataState: DataState.none,
        );
      }
    }
    switch (queryDataState) {
      case DataState.ready:
        if (!currentItemInList) {
          this.__clearChildrenWithDataStateCascade(
            thisXBlock: thisXBlock,
            queryDataState: DataState.none,
            formDataState: DataState.none,
          );
        }
      case DataState.none:
        this.__clearChildrenWithDataStateCascade(
          thisXBlock: thisXBlock,
          queryDataState: DataState.none,
          formDataState: DataState.none,
        );
      case DataState.pending:
        this.__clearChildrenWithDataStateCascade(
          thisXBlock: thisXBlock,
          queryDataState: DataState.pending,
          formDataState: DataState.none,
        );
      case DataState.error:
        this.__clearChildrenWithDataStateCascade(
          thisXBlock: thisXBlock,
          queryDataState: DataState.none,
          formDataState: DataState.none,
        );
    }
    //
    // Add TaskUnit:
    // - Find Item to Select as Current:
    //
    if (newQueryDataState == DataState.ready) {
      FlutterArtist.taskUnitQueue.addTaskUnit(
        _BlockSelectAsCurrentTaskUnit<ITEM>(
          currentItemSelectionType:
              CurrentItemSelectionType.selectAsCurrentForDefault,
          xBlock: thisXBlock,
          newQueriedList: newQueriedList,
          candidateItem: candidateCurrentItem,
          forceForm: null,
        ),
      );
    }
    return thisXBlock.queryResult;
  }

  // ***************************************************************************
  // ***************************************************************************

  Future<void> _unitSelectItemAsCurrent({
    required _XBlock thisXBlock,
    required CurrentItemSelectionType currentItemSelectionType,
    required List<ITEM> newQueriedList,
    required ITEM? candidateItem,
  }) async {
    __assertThisXBlock(thisXBlock);
    //
    if (thisXBlock.currentItemSelectionResult == null) {
      thisXBlock.currentItemSelectionResult = CurrentItemSelectionResult<ITEM>(
        currentItemSelectionType: currentItemSelectionType,
        getItemId: getItemId,
        candidateItem: candidateItem,
        oldCurrentItem: this.data.currentItem,
        currentItem: this.data.currentItem,
      );
    } else {
      thisXBlock.currentItemSelectionResult!._addCandidateItem(
        candidateItem,
      );
    }
    var result = thisXBlock.currentItemSelectionResult!;
    //
    if (this.queryDataState == DataState.pending) {
      this.__clearWithDataStateCascade(
        thisXBlock: thisXBlock,
        queryDataState: queryDataState,
        formDataState: DataState.none,
      );
      return;
    }
    //
    if (this.queryDataState == DataState.error) {
      this.__clearWithDataStateCascade(
        thisXBlock: thisXBlock,
        queryDataState: DataState.error,
        formDataState: DataState.error,
      );
      return;
    }
    //
    if (this.data.itemCount == 0) {
      this.__clearWithDataStateCascade(
        thisXBlock: thisXBlock,
        queryDataState: DataState.ready,
        formDataState: DataState.none,
      );
      return;
    }
    //
    bool hasActiveUI = hasActiveUIComponent();
    thisXBlock._printParameters(hasActiveUI: hasActiveUI); // ---> Debug

    if (!thisXBlock.forceQuery || !thisXBlock.forceReloadItem) {
      // return;
    }
    //
    ITEM? candidateCurrentItem = candidateItem;
    ITEM? currentItem = this.data.currentItem;
    //
    if (candidateCurrentItem != null) {
      if (!this.data.containsItem(item: candidateCurrentItem)) {
        candidateCurrentItem = null;
      }
    }
    if (currentItem != null) {
      if (!this.data.containsItem(item: currentItem)) {
        currentItem = null;
      }
    }
    //
    final bool newCurrent;
    if (currentItem == null) {
      candidateCurrentItem = candidateCurrentItem ?? this.data.firstItem;
      newCurrent = candidateCurrentItem != null;
    } else {
      // currentItem != null
      if (candidateCurrentItem == null) {
        candidateCurrentItem = currentItem;
        newCurrent = false;
      } else {
        // candidateCurrentItem != null && currentItem != null
        if (getItemId(candidateCurrentItem) == getItemId(currentItem)) {
          newCurrent = false;
        } else {
          newCurrent = true;
        }
      }
    }
    //
    if (!this.data.isSame(
          item1: candidateItem,
          item2: candidateCurrentItem,
        )) {
      result._addCandidateItem(candidateCurrentItem);
    }
    //
    if (!newCurrent && !thisXBlock.forceReloadItem) {
      for (_XBlock childXBlock in thisXBlock.childXBlocks) {
        FlutterArtist.taskUnitQueue.addTaskUnit(
          _BlockQueryTaskUnit(
            xBlock: childXBlock,
          ),
        );
      }
      return;
    }
    //
    // newCurrent || forceReloadItem
    //
    //
    // If no item can be current.
    //
    if (candidateCurrentItem == null) {
      this.__clearWithDataStateCascade(
        thisXBlock: thisXBlock,
        queryDataState: DataState.ready,
        formDataState: DataState.none,
      );
      return;
    }
    //
    // (newCurrent || forceReloadItem) && candidateCurrentItem !=null
    //
    final bool isCandidateIsCurrent = this.data.isCurrentItem(
          item: candidateCurrentItem,
        );
    final ITEM? candidateCurrentItemInNewQueriedList =
        ItemsUtils.findItemInList(
      item: candidateCurrentItem,
      targetList: newQueriedList,
      getItemId: getItemId,
    );
    //
    ITEM_DETAIL? candidateCurrentItemDetail;

    if (ITEM == ITEM_DETAIL && candidateCurrentItemInNewQueriedList != null) {
      // No need to refresh Item.
      candidateCurrentItemDetail =
          candidateCurrentItemInNewQueriedList as ITEM_DETAIL;
    } else {
      bool isLoadItemError = false;
      try {
        __refreshRefreshingCurrentItemState(
          isRefreshingCurrentItem: true,
        );
        //
        __callApiRefreshItemCount++;
        ApiResult<ITEM_DETAIL> result = await callApiRefreshItem(
          item: candidateCurrentItem, // Not null.
        );
        //
        if (result.isError()) {
          isLoadItemError = true;
          //
          _handleRestError(
            shelf: shelf,
            methodName: "callApiRefreshItem",
            message: result.errorMessage!,
            errorDetails: result.errorDetails,
            showSnackBar: true,
          );
        } else {
          isLoadItemError = false;
          //
          candidateCurrentItemDetail = result.data;
        }
      } catch (e, stackTrace) {
        isLoadItemError = true;
        //
        _handleError(
          shelf: shelf,
          methodName: "callApiRefreshItem",
          error: "Error callApiRefreshItem: $e",
          stackTrace: stackTrace,
          showSnackBar: true,
        );
      } finally {
        __refreshRefreshingCurrentItemState(
          isRefreshingCurrentItem: false,
        );
      }
      if (isLoadItemError) {
        result._apiError = true;
        // TODO: Alway return?
        // If newCurrent or not newCurrent
        // Always return. Nothing to do if has error!!
        return;
      }
    }
    //
    // If candidate not found in database --> remove.
    //
    if (candidateCurrentItemDetail == null) {
      final ITEM? siblingItem = this.data.findSiblingItem(
            item: candidateCurrentItem,
          );
      // #SAME-CODE-001
      if (!isCandidateIsCurrent) {
        await __removeItemFromList(
          removeItem: candidateCurrentItem,
        );
        //
        if (currentItem != null) {
          return;
        }
        //
        if (siblingItem == null) {
          return;
        }
        //
        var taskUnit = _BlockSelectAsCurrentTaskUnit(
          currentItemSelectionType: currentItemSelectionType,
          xBlock: thisXBlock,
          newQueriedList: newQueriedList,
          candidateItem: siblingItem,
          forceForm: null,
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
      //
      this.__clearWithDataStateCascade(
        thisXBlock: thisXBlock,
        queryDataState: DataState.ready,
        formDataState: DataState.none,
      );
      //
      if (siblingItem != null) {
        var taskUnit = _BlockSelectAsCurrentTaskUnit(
          currentItemSelectionType: currentItemSelectionType,
          xBlock: thisXBlock,
          newQueriedList: newQueriedList,
          candidateItem: siblingItem,
          forceForm: null,
        );
        FlutterArtist.taskUnitQueue.addTaskUnit(taskUnit);
        return;
      }
      return;
    }
    //
    // candidateCurrentItemDetail != null
    //
    bool convertItemError = false;
    try {
      candidateCurrentItem = this.__convertItemDetailToItem(
        itemDetail: candidateCurrentItemDetail,
      );
      convertItemError = false;
    } catch (e, stackTrace) {
      convertItemError = true;
      _handleError(
        shelf: shelf,
        methodName: "convertItemDetailToItem",
        error: "Error convertItemDetailToItem: $e",
        stackTrace: stackTrace,
        showSnackBar: true,
      );
    }
    //
    if (convertItemError) {
      result._convertError = true;
      // TODO Always return??
      // If newCurrent or not newCurrent
      // Always return. Nothing to do if has error!!
      return;
    }
    //
    this.data._selectionDataState = DataState.ready;
    this.data._setCurrentItemOnly(
          refreshedItem: candidateCurrentItem,
          refreshedItemDetail: candidateCurrentItemDetail,
        );
    //
    if (newCurrent) {
      result._currentItem = candidateCurrentItem;
      //
      this.__clearChildrenWithDataStateCascade(
        thisXBlock: thisXBlock,
        queryDataState: DataState.pending,
        formDataState: DataState.pending,
      );
    }
    //
    // FormModel:
    //
    if (thisXBlock.xFormModel != null) {
      // (newCurrent)
      thisXBlock.xFormModel!.formModel._clearWithDataState(
        formDataState: DataState.pending,
      );
      FlutterArtist.taskUnitQueue.addTaskUnit(
        _FormModelLoadFormTaskUnit(
          xFormModel: thisXBlock.xFormModel!,
        ),
      );
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

  Future<void> _unitDeleteItem({
    required _XBlock thisXBlock,
    required ITEM item,
  }) async {
    __assertThisXBlock(thisXBlock);
    //
    // No need to check again?
    //
    Actionable actionable = canDeleteItem(item: item);
    if (!actionable.yes) {
      return;
    }
    //
    // Candidate Item to delete.
    //
    thisXBlock.itemDeletionResult.addCandidateItem(item);
    //
    final bool isCurrent = this.data.isCurrentItem(item: item);
    //
    ApiResult<void> result;
    try {
      FlutterArtist.codeFlowLogger._addMethodCall(
        isLibCode: false,
        navigate: null,
        ownerClassInstance: this,
        methodName: "callApiDeleteItem",
        parameters: {
          "item": item,
        },
      );
      //
      __refreshDeletingState(isDeleting: true);
      //
      result = await callApiDeleteItem(item: item);
      // TODO: Chuyen di noi khac?
      FlutterArtist.storage._fireEventSourceChanged(
        eventBlock: this,
        itemIdString: null,
      );
    } catch (e, stackTrace) {
      _handleError(
        shelf: shelf,
        methodName: "callApiDeleteItem",
        error: e,
        stackTrace: stackTrace,
        showSnackBar: true,
      );
      //
      thisXBlock.itemDeletionResult.addDFailedItem(item);
      //
      return;
    } finally {
      __refreshDeletingState(isDeleting: false);
    }
    if (result.errorMessage != null) {
      _handleRestError(
        shelf: shelf,
        methodName: "callApiDeleteItem",
        message: result.errorMessage!,
        errorDetails: result.errorDetails,
        showSnackBar: true,
      );
      //
      thisXBlock.itemDeletionResult.addDFailedItem(item);
      //
      return;
    }
    //
    // Delete Successful.
    //
    thisXBlock.itemDeletionResult.addDeletedItem(item);
    //
    // #SAME-CODE-001
    if (!isCurrent) {
      await __removeItemFromList(removeItem: item);
      return;
    }
    //
    // Deleted current item ==> find sibling.
    //
    final ITEM? siblingItem = this.data.findSiblingItem(item: item);
    // Remove Item (Current Item)
    await __removeItemFromList(removeItem: item);
    this.data._setCurrentItemOnly(
          refreshedItem: null,
          refreshedItemDetail: null,
        );
    //
    if (this.formModel != null) {
      // Clear Form:
      this.formModel!._clearWithDataState(
            formDataState: DataState.ready,
          );
    }
    //
    __clearChildrenWithDataStateCascade(
      thisXBlock: thisXBlock,
      queryDataState: DataState.ready,
      formDataState: DataState.ready,
    );
    //
    _TaskUnit taskUnit = _BlockSelectAsCurrentTaskUnit<ITEM>(
      currentItemSelectionType:
          CurrentItemSelectionType.selectAsCurrentForDefault,
      xBlock: thisXBlock,
      newQueriedList: <ITEM>[],
      candidateItem: siblingItem,
      forceForm: null,
    );
    FlutterArtist.taskUnitQueue.addTaskUnit(taskUnit);
  }

  // ***************************************************************************
  // ***************************************************************************

  Future<bool> _unitPrepareToCreateItem({
    required _XBlock thisXBlock,
    required EXTRA_FORM_INPUT? extraFormInput,
    required Function()? navigate,
  }) async {
    __assertThisXBlock(thisXBlock);
    //
    const ITEM? nullItem = null;
    const ITEM_DETAIL? nullItemDetail = null;
    __setCurrentItem(
      itemDetail: nullItemDetail,
      item: nullItem,
    );
    //
    this.__clearChildrenWithDataStateCascade(
      thisXBlock: thisXBlock,
      queryDataState: DataState.none,
      formDataState: DataState.none,
    );
    formModel!.data._setCurrentItem(
      refreshedItemDetail: nullItemDetail,
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
      success = await formModel!._startNewFormTransaction(
        filterCriteria: data.filterCriteria,
        extraFormInput: extraFormInput,
        isItemFirstLoad: true,
      );
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

  Future<bool> _unitQuickCreateItem({
    required _XBlock thisXBlock,
    required QuickCreateItemAction<ITEM_DETAIL> action,
  }) async {
    __assertThisXBlock(thisXBlock);
    //
    ApiResult<ITEM_DETAIL> result;
    try {
      FlutterArtist.codeFlowLogger._addMethodCall(
        isLibCode: false,
        navigate: null,
        ownerClassInstance: action,
        methodName: "callApiQuickCreateItem",
        parameters: {},
      );
      //
      result = await action.callApiQuickCreateItem();
      //
    } catch (e, stackTrace) {
      _handleError(
        shelf: shelf,
        methodName: '${getClassName(action)}.callApiQuickCreateItem',
        error: e,
        stackTrace: stackTrace,
        showSnackBar: true,
      );
      //
      return false;
    }
    //
    try {
      return await _processSaveActionRestResult(
        thisXBlock: thisXBlock,
        calledMethodName: "${getClassName(action)}.callApiQuickCreateItem",
        result: result,
      );
    } catch (e, stackTrace) {
      _handleError(
        shelf: shelf,
        methodName: "_processSaveActionRestResult",
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

  Future<bool> _unitQuickUpdateItem({
    required _XBlock thisXBlock,
    required QuickUpdateItemAction<ITEM, ITEM_DETAIL> action,
  }) async {
    __assertThisXBlock(thisXBlock);
    //
    ApiResult<ITEM_DETAIL> result;
    try {
      FlutterArtist.codeFlowLogger._addMethodCall(
        isLibCode: false,
        navigate: null,
        ownerClassInstance: action,
        methodName: "callApiQuickUpdateItem",
        parameters: {},
      );
      //
      result = await action.callApiQuickUpdateItem();
      //
    } catch (e, stackTrace) {
      _handleError(
        shelf: shelf,
        methodName: '${getClassName(action)}.callApiQuickUpdateItem',
        error: e,
        stackTrace: stackTrace,
        showSnackBar: true,
      );
      //
      return false;
    }
    //
    try {
      return await _processSaveActionRestResult(
        thisXBlock: thisXBlock,
        calledMethodName: "${getClassName(action)}.callApiQuickUpdateItem",
        result: result,
      );
    } catch (e, stackTrace) {
      _handleError(
        shelf: shelf,
        methodName: "_processSaveActionRestResult",
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

  Future<bool> _unitQuickAction<DATA extends Object>({
    required _XBlock thisXBlock,
    required QuickAction<DATA> action,
    required AfterBlockQuickAction afterQuickAction,
  }) async {
    __assertThisXBlock(thisXBlock);
    //
    ApiResult<DATA>? result;
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
    } catch (e, stackTrace) {
      _handleError(
        shelf: shelf,
        methodName: '${getClassName(action)}.callApi',
        error: e,
        stackTrace: stackTrace,
        showSnackBar: true,
      );
      return false;
    }
    //
    bool success = true;
    if (result != null && result.errorMessage != null) {
      success = false;
      //
      _handleRestError(
        shelf: shelf,
        methodName: "${getClassName(action)}.callApi",
        message: result.errorMessage!,
        errorDetails: result.errorDetails,
        showSnackBar: true,
      );
    }
    //
    try {
      DATA? apiData = result?.data;
      await action.doAfterCallApi(success: success, apiData: apiData);
      //
      if (success) {
        FlutterArtist.storage._fireEventToAffectedItemTypes(
          affectedItemTypes: action.affectedItemTypes,
        );
      }
    } catch (e, stackTrace) {
      _handleError(
        shelf: shelf,
        methodName: '${getClassName(action)}.callApi',
        error: e,
        stackTrace: stackTrace,
        showSnackBar: true,
      );
      return false;
    }
    //
    switch (afterQuickAction) {
      case AfterBlockQuickAction.none:
        break;
      case AfterBlockQuickAction.refreshCurrentItem:
        Actionable actionable = canRefreshCurrentItem();
        if (!actionable.yes) {
          return true;
        }
        ITEM? currentItem = this.data.currentItem;
        if (currentItem != null) {
          var taskUnit = _BlockSelectAsCurrentTaskUnit<ITEM>(
            currentItemSelectionType: CurrentItemSelectionType.refresh,
            xBlock: thisXBlock,
            newQueriedList: [],
            candidateItem: currentItem,
            forceForm: null,
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

  Future<bool> _unitQuickChildBlockItemsAction<DATA extends Object>({
    required _XBlock thisXBlock,
    required QuickChildBlockItemsAction<ITEM, ITEM_DETAIL> action,
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
    if (result.isError()) {
      _handleRestError(
        shelf: shelf,
        methodName: "callApiChildBlockItems",
        message: result.errorMessage!,
        errorDetails: result.errorDetails,
        showSnackBar: true,
      );
      // TODO: Xem lai (Hanh dong neu Error).
      return false;
    }
    //
    return await _processSaveActionRestResult(
      thisXBlock: thisXBlock,
      calledMethodName: "${getClassName(action)}.callApiChildBlockItems",
      result: result,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  Future<bool> _processSaveActionRestResult({
    required _XBlock thisXBlock,
    required String calledMethodName,
    required ApiResult<ITEM_DETAIL> result,
  }) async {
    if (result.errorMessage != null) {
      _handleRestError(
        shelf: shelf,
        methodName: calledMethodName,
        message: result.errorMessage!,
        errorDetails: result.errorDetails,
        showSnackBar: true,
      );
      return false;
    }
    // TODO: Chuyen di noi khac.
    FlutterArtist.storage._fireEventSourceChanged(
      eventBlock: this,
      itemIdString: null,
    );
    final ITEM_DETAIL? savedItemDetail = result.data;
    final bool keepInList;
    if (savedItemDetail == null) {
      keepInList = false;
    } else {
      keepInList = needToKeepItemInList(
        filterCriteria: this.data.filterCriteria,
        savedItem: savedItemDetail,
      );
    }
    //
    if (savedItemDetail != null && keepInList) {
      bool forceForm = false;
      ITEM refreshedItem = convertItemDetailToItem(
        itemDetail: savedItemDetail,
      );
      this.data._insertOrReplaceItem(
            item: refreshedItem,
            itemDetail: savedItemDetail,
          );
      //
      Actionable actionable = canEditItemOnForm(item: refreshedItem);
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
      //
      if (formModel != null) {
        formModel!.data._setCurrentItem(
          refreshedItemDetail: savedItemDetail,
          formMode: FormMode.edit,
          formDataState: DataState.pending,
        );
        //
        bool success = await formModel!._startNewFormTransaction(
          filterCriteria: data.filterCriteria,
          extraFormInput: null,
          isItemFirstLoad: true,
        );
        if (!success) {
          return false;
        }
      }
      return true;
    }
    // savedItem = null or !keepInList
    else {
      ITEM? savedItem = __convertItemDetailToItem(
        itemDetail: savedItemDetail,
      );
      final ITEM? removeItem = savedItem ?? this.data.currentItem;
      if (removeItem == null) {
        // TODO: Xem lai.
        return false;
      }
      //
      // removeItem != null
      //
      bool isCurrent = this.data.isCurrentItem(item: removeItem);
      if (!isCurrent) {
        await __removeItemFromList(removeItem: removeItem);
        return true;
      }
      //
      // Deleted current item ==> find sibling.
      //
      final ITEM? siblingItem = this.data.findSiblingItem(item: removeItem);
      // Remove Item (Current Item)
      await __removeItemFromList(removeItem: removeItem);
      this.data._setCurrentItemOnly(
            refreshedItem: null,
            refreshedItemDetail: null,
          );
      //
      if (this.formModel != null) {
        // Clear Form:
        this.formModel!._clearWithDataState(
              formDataState: DataState.ready,
            );
      }
      //
      __clearChildrenWithDataStateCascade(
        thisXBlock: thisXBlock,
        queryDataState: DataState.ready,
        formDataState: DataState.ready,
      );
      //
      _TaskUnit taskUnit = _BlockSelectAsCurrentTaskUnit<ITEM>(
        currentItemSelectionType:
            CurrentItemSelectionType.selectAsCurrentForDefault,
        xBlock: thisXBlock,
        newQueriedList: [],
        candidateItem: siblingItem,
        forceForm: null,
      );
      FlutterArtist.taskUnitQueue.addTaskUnit(taskUnit);
      //
      return true;
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  @RootMethodAnnotation()
  Future<void> clearCurrent() async {
    FlutterArtist.codeFlowLogger._addMethodCall(
      isLibCode: true,
      navigate: null,
      ownerClassInstance: this,
      methodName: "clearCurrent",
      parameters: {},
    );
    if (data.currentItem == null) {
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

  @RootMethodAnnotation()
  Future<CurrentItemSelectionResult<ITEM>?> _prepareToShowOrEditItem({
    required ITEM item,
    required bool forceForm,
    required Function()? navigate,
  }) async {
    FlutterArtist.codeFlowLogger._addMethodCall(
      isLibCode: true,
      navigate: navigate,
      ownerClassInstance: this,
      methodName: "_prepareToShowOrEditItem",
      parameters: {
        "item": item,
        "forceForm": forceForm,
      },
    );
    //
    if (!this.canSelectItem()) {
      return null;
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
    _TaskUnit taskUnit = _BlockSelectAsCurrentTaskUnit<ITEM>(
      currentItemSelectionType: forceForm
          ? CurrentItemSelectionType.selectAsCurrentToEdit
          : CurrentItemSelectionType.selectAsCurrentToShow,
      xBlock: thisXBlock,
      newQueriedList: [],
      candidateItem: item,
      forceForm: forceForm,
    );
    FlutterArtist.taskUnitQueue.addTaskUnit(taskUnit);
    //
    await FlutterArtist.executor._executeTaskUnitQueue();
    var result = thisXBlock.currentItemSelectionResult
        as CurrentItemSelectionResult<ITEM>?;
    if (result != null && result.success) {
      if (navigate != null) {
        navigate();
      }
    }
    return result;
  }

  // ***************************************************************************
  // ***************************************************************************

  @RootMethodAnnotation()
  Future<CurrentItemSelectionResult<ITEM>?> prepareToShowItem({
    required ITEM item,
    Function()? navigate,
  }) async {
    FlutterArtist.codeFlowLogger._addMethodCall(
      isLibCode: true,
      navigate: navigate,
      ownerClassInstance: this,
      methodName: "prepareToShowItem",
      parameters: {
        "item": item,
      },
    );
    //
    return await _prepareToShowOrEditItem(
      item: item,
      forceForm: false,
      navigate: navigate,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  ///
  /// Clear and set block to "Pending State".
  ///
  @RootMethodAnnotation()
  Future<bool> clear({Function()? navigate}) async {
    FlutterArtist.codeFlowLogger._addMethodCall(
      isLibCode: true,
      navigate: navigate,
      ownerClassInstance: this,
      methodName: "clear",
      parameters: {},
    );
    bool hasActive = this.hasActiveUIComponent();
    if (hasActive) {
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
    this.__clearWithDataStateCascade(
      thisXBlock: thisXBlock,
      queryDataState: DataState.pending,
      formDataState: DataState.pending,
    );
    //
    _executeNavigation(navigate: navigate);
    //
    return true;
  }

  // ***************************************************************************
  // ***************************************************************************

  ///
  /// Query the next page and replace the current items in the list.
  ///
  @RootMethodAnnotation()
  Future<bool> queryNextPage({
    PostQueryBehavior postQueryBehavior = PostQueryBehavior.selectAvailableItem,
  }) async {
    FlutterArtist.codeFlowLogger._addMethodCall(
      isLibCode: true,
      navigate: null,
      ownerClassInstance: this,
      methodName: "queryNextPage",
      parameters: {"postQueryBehavior": postQueryBehavior},
    );
    //
    PageableData? currentPageable = this.data.pageable;
    if (currentPageable == null) {
      return false;
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
  @RootMethodAnnotation()
  Future<bool> queryPreviousPage({
    PostQueryBehavior postQueryBehavior = PostQueryBehavior.selectAvailableItem,
  }) async {
    FlutterArtist.codeFlowLogger._addMethodCall(
      isLibCode: true,
      navigate: null,
      ownerClassInstance: this,
      methodName: "queryPreviousPage",
      parameters: {"postQueryBehavior": postQueryBehavior},
    );
    //
    PageableData? currentPageable = this.data.pageable;
    if (currentPageable == null) {
      return false;
    }
    PageableData? pageable = currentPageable.previous();
    if (pageable == null) {
      return false;
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
  @RootMethodAnnotation()
  Future<bool> queryMore({
    PostQueryBehavior postQueryBehavior = PostQueryBehavior.selectAvailableItem,
  }) async {
    FlutterArtist.codeFlowLogger._addMethodCall(
      isLibCode: true,
      navigate: null,
      ownerClassInstance: this,
      methodName: "queryMore",
      parameters: {"postQueryBehavior": postQueryBehavior},
    );
    //
    PageableData? currentPageable = this.data.pageable;
    if (currentPageable == null) {
      return false;
    }
    PageableData pageable = currentPageable.next();
    //
    return await query(
      listBehavior: ListBehavior.append,
      postQueryBehavior: postQueryBehavior,
      suggestedSelection: null,
      pageable: pageable,
      navigate: null,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  ///
  ///
  ///
  @nonVirtual
  @RootMethodAnnotation()
  Future<bool> query({
    ListBehavior listBehavior = ListBehavior.replace,
    PostQueryBehavior postQueryBehavior = PostQueryBehavior.selectAvailableItem,
    FILTER_INPUT? filterInput,
    SuggestedSelection? suggestedSelection,
    PageableData? pageable,
    Function()? navigate,
  }) async {
    if (filterModel != null && filterModel!._lockAddMoreQuery) {
      return false;
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
          queryType: null,
          block: this,
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
    return queryResult.success;
  }

  // ***************************************************************************
  // ***************************************************************************

  ///
  ///
  ///
  @nonVirtual
  @RootMethodAnnotation()
  Future<BlockQueryResult?> queryAndPrepareToEdit({
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
    printLog("\n\n${getClassName(this)} ~~~~~~~~~~~~> queryAndPrepareToEdit()");
    //
    _XShelf xShelf = await shelf._queryAll(
      forceFilterModelOpt: _FilterModelOpt(
        filterModel: _registeredOrDefaultFilterModel,
        filterInput: filterInput,
      ),
      forceQueryScalarOpts: [],
      forceQueryBlockOpts: [
        _BlockOpt(
          queryType: QueryType.forceQuery,
          block: this,
          pageable: pageable,
          listBehavior: listBehavior,
          suggestedSelection: suggestedSelection,
          postQueryBehavior: PostQueryBehavior.selectAvailableItemToEdit,
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
  @RootMethodAnnotation()
  Future<BlockQueryResult?> queryAndPrepareToCreate({
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
          queryType: QueryType.forceQuery,
          block: this,
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

  ID getItemId(ITEM item);

  // ***************************************************************************
  // ***************************************************************************

  ITEM convertItemDetailToItem({required ITEM_DETAIL itemDetail});

  // ***************************************************************************
  // ***************************************************************************

  ID? getCurrentItemId() {
    if (this.data.currentItemDetail == null) {
      return null;
    }
    ITEM item =
        convertItemDetailToItem(itemDetail: this.data.currentItemDetail!);
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
      Object? itemParent = parent?.data.currentItemDetail;
      if (itemParent != null && this.data.queryDataState == DataState.ready) {
        setChildrenForParent(
          currentItemOfParentBlock: itemParent,
          items: this.data.items,
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

  // @canOverride
  void setChildrenForParent({
    required Object currentItemOfParentBlock,
    required List<ITEM> items,
  }) {
    // Override if need.
  }

  // ***************************************************************************
  // ***************************************************************************

  void __setCurrentItem({
    required ITEM? item,
    required ITEM_DETAIL? itemDetail,
  }) {
    this.data._setCurrentItemOnly(
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
    this.data._removeItem(removeItem: removeItem);
    this.updateItemsView();
    // TODO: Disable delay in test mode:
    // await Future.delayed(Duration(seconds: 1));
  }

  // ***************************************************************************
  // ***************************************************************************

  bool hasCurrentItem() {
    return this.data.currentItemDetail != null;
  }

  // ***************************************************************************
  // ***************************************************************************

  // TODO: Xem lai phuong thuc nay. No da duoc goi o dau.
  bool hasCurrentItemAndAllowUpdate() {
    if (this.data.currentItem == null) {
      return false;
    }
    Actionable actionable = __isAllowDeleteItem(
      item: this.data.currentItem!,
    );
    return actionable.yes;
  }

  // ***************************************************************************
  // ***************************************************************************

  // TODO: Xem lai phuong thuc nay. No da duoc goi o dau.
  bool hasCurrentItemAndAllowDelete() {
    if (this.data.currentItem == null) {
      return false;
    }
    Actionable actionable = __isAllowDeleteItem(
      item: this.data.currentItem!,
    );
    return actionable.yes;
  }

  // ***************************************************************************
  // ***************************************************************************

  // TODO: Them tham so ITEM.
  bool needToKeepItemInList({
    required FILTER_CRITERIA? filterCriteria,
    required ITEM_DETAIL savedItem,
  });

  // ***************************************************************************
  // ***************************************************************************

  @RootMethodAnnotation()
  Future<bool> executeQuickAction<DATA extends Object>({
    FILTER_INPUT? filterInput,
    SuggestedSelection? suggestedSelection,
    required ActionConfirmationType actionConfirmationType,
    required QuickAction<DATA> action,
    required AfterBlockQuickAction afterQuickAction,
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
    // Confirmation:
    //
    bool confirm = true;
    if (action.needToConfirm) {
      confirm = await __showActionConfirmation(
        shelf: shelf,
        defaultConfirmation: action._defaultConfirmation,
        customConfirmation: action.createCustomConfirmation(),
      );
    }
    //
    if (!confirm) {
      return false;
    }
    //
    List<_BlockOpt> forceQueryBlockOpts = [];
    switch (afterQuickAction) {
      case AfterBlockQuickAction.none:
        forceQueryBlockOpts = [];
      case AfterBlockQuickAction.refreshCurrentItem:
        forceQueryBlockOpts = [];
      case AfterBlockQuickAction.query:
        forceQueryBlockOpts = [
          _BlockOpt(
            block: this,
            queryType: QueryType.forceQuery,
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
    _TaskUnit taskUnit = _BlockQuickActionTaskUnit(
      xBlock: thisXBlock,
      action: action,
      afterQuickAction: afterQuickAction,
    );
    //
    FlutterArtist.taskUnitQueue.addTaskUnit(taskUnit);
    //
    await FlutterArtist.executor._executeTaskUnitQueue();
    return true;
  }

  // ***************************************************************************
  // ***************************************************************************

  @RootMethodAnnotation()
  Future<bool> executeQuickActionCreateItem<
      A extends QuickCreateItemAction<ITEM_DETAIL>>({
    required A action,
  }) async {
    FlutterArtist.codeFlowLogger._addMethodCall(
      isLibCode: true,
      navigate: null,
      ownerClassInstance: this,
      methodName: "executeQuickActionCreateItem",
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
        defaultConfirmation: action._defaultConfirmation,
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
    _TaskUnit taskUnit = _BlockQuickCreateItemTaskUnit(
      xBlock: thisXBlock,
      action: action,
    );
    //
    FlutterArtist.taskUnitQueue.addTaskUnit(taskUnit);
    //
    await FlutterArtist.executor._executeTaskUnitQueue();
    return true;
  }

  // ***************************************************************************
  // ***************************************************************************

  @RootMethodAnnotation()
  Future<bool> executeQuickActionUpdateItem<
      A extends QuickUpdateItemAction<ITEM, ITEM_DETAIL>>({
    required A action,
  }) async {
    FlutterArtist.codeFlowLogger._addMethodCall(
      isLibCode: true,
      navigate: null,
      ownerClassInstance: this,
      methodName: "executeQuickActionUpdateItem",
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
        defaultConfirmation: action._defaultConfirmation,
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
    _TaskUnit taskUnit = _BlockQuickUpdateItemTaskUnit(
      xBlock: thisXBlock,
      action: action,
    );
    //
    FlutterArtist.taskUnitQueue.addTaskUnit(taskUnit);
    //
    await FlutterArtist.executor._executeTaskUnitQueue();
    return true;
  }

  // ***************************************************************************
  // ***************************************************************************

  @RootMethodAnnotation()
  Future<bool> executeQuickChildBlockItems<
      A extends QuickChildBlockItemsAction<ITEM, ITEM_DETAIL>>({
    required A action,
  }) async {
    FlutterArtist.codeFlowLogger._addMethodCall(
      isLibCode: true,
      navigate: null,
      ownerClassInstance: this,
      methodName: "executeQuickChildBlockItems",
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
        defaultConfirmation: action._defaultConfirmation,
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

  @RootMethodAnnotation()
  Future<CurrentItemSelectionResult<ITEM>?> prepareToEditFirstItem({
    Function()? navigate,
  }) async {
    ITEM? nextItem = this.data.firstItem;
    if (nextItem == null) {
      return null;
    }
    return await prepareToEditItem(
      item: nextItem,
      navigate: navigate,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  @RootMethodAnnotation()
  Future<CurrentItemSelectionResult<ITEM>?> prepareToEditNextItem({
    Function()? navigate,
  }) async {
    if (!this.data.hasNextItem) {
      return null;
    }
    ITEM? nextItem = this.data.nextSiblingItem;
    if (nextItem == null) {
      return null;
    }
    return await prepareToEditItem(
      item: nextItem,
      navigate: navigate,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  @RootMethodAnnotation()
  Future<CurrentItemSelectionResult<ITEM>?> prepareToEditPreviousItem({
    Function()? navigate,
  }) async {
    if (!this.data.hasPreviousItem) {
      return null;
    }
    ITEM? previousItem = this.data.previousSiblingItem;
    if (previousItem == null) {
      return null;
    }
    return await prepareToEditItem(
      item: previousItem,
      navigate: navigate,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  @RootMethodAnnotation()
  Future<CurrentItemSelectionResult<ITEM>?> prepareToEditItem({
    required ITEM item,
    Function()? navigate,
  }) async {
    FlutterArtist.codeFlowLogger._addMethodCall(
      isLibCode: true,
      navigate: navigate,
      ownerClassInstance: this,
      methodName: "prepareToEditItem",
      parameters: {
        "item": item,
      },
    );
    //
    return await _prepareToShowOrEditItem(
      item: item,
      forceForm: true,
      navigate: navigate,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  @RootMethodAnnotation()
  Future<CurrentItemSelectionResult<ITEM>?> prepareToShowFirstItem({
    Function()? navigate,
  }) async {
    ITEM? nextItem = this.data.firstItem;
    if (nextItem == null) {
      return null;
    }
    return await prepareToShowItem(
      item: nextItem,
      navigate: navigate,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  @RootMethodAnnotation()
  Future<CurrentItemSelectionResult<ITEM>?> prepareToShowNextItem({
    Function()? navigate,
  }) async {
    if (!this.data.hasNextItem) {
      return null;
    }
    ITEM? nextItem = this.data.nextSiblingItem;
    if (nextItem == null) {
      return null;
    }
    return await prepareToShowItem(
      item: nextItem,
      navigate: navigate,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  @RootMethodAnnotation()
  Future<CurrentItemSelectionResult<ITEM>?> prepareToShowPreviousItem({
    Function()? navigate,
  }) async {
    if (!this.data.hasPreviousItem) {
      return null;
    }
    ITEM? previousItem = this.data.previousSiblingItem;
    if (previousItem == null) {
      return null;
    }
    return await prepareToShowItem(
      item: previousItem,
      navigate: navigate,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  bool __checkBeforeFormCreation({required bool showErrorMessage}) {
    Actionable createActionable = canCreateItem();
    if (!createActionable.yes) {
      if (showErrorMessage) {
        showErrorSnackBar(
          message: createActionable.message!,
          errorDetails: ["Block: ${getClassName(this)}"],
        );
      }
      return false;
    }
    return true;
  }

  // ***************************************************************************
  // ***************************************************************************

  ///
  /// Prepare to create an item in a Form.
  ///
  @RootMethodAnnotation()
  Future<bool> prepareToCreate({
    EXTRA_FORM_INPUT? extraFormInput,
    required Function()? navigate,
  }) async {
    FlutterArtist.codeFlowLogger._addMethodCall(
      isLibCode: true,
      navigate: navigate,
      ownerClassInstance: this,
      methodName: "prepareToCreate",
      parameters: {"extraFormInput": extraFormInput},
    );
    //
    if (!__checkBeforeFormCreation(showErrorMessage: true)) {
      return false;
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
    _TaskUnit taskUnit = _BlockPrepareToCreateItemTaskUnit(
      xBlock: thisXBlock,
      extraFormInput: extraFormInput,
      navigate: navigate,
    );
    //
    FlutterArtist.taskUnitQueue.addTaskUnit(taskUnit);
    //
    await FlutterArtist.executor._executeTaskUnitQueue();
    return true;
  }

  // ***************************************************************************
  // ***************************************************************************

  @RootMethodAnnotation()
  Future<ItemDeletionResult?> deleteSelectedItems({
    required CurrentItemSelInclusion currentItemInclusion,
    required bool stopIfError,
  }) async {
    FlutterArtist.codeFlowLogger._addMethodCall(
      isLibCode: true,
      navigate: null,
      ownerClassInstance: this,
      methodName: "deleteSelectedItems",
      parameters: null,
    );
    //
    List<ITEM> selItems = this.data.getSelectedItems(
          currentItemInclusion: currentItemInclusion,
        );
    if (selItems.isEmpty) {
      return null;
    }
    return await deleteItems(
      items: selItems,
      stopIfError: stopIfError,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  @RootMethodAnnotation()
  Future<ItemDeletionResult?> deleteCheckedItems({
    required CurrentItemChkInclusion currentItemInclusion,
    required bool stopIfError,
  }) async {
    FlutterArtist.codeFlowLogger._addMethodCall(
      isLibCode: true,
      navigate: null,
      ownerClassInstance: this,
      methodName: "deleteCheckedItems",
      parameters: null,
    );
    //
    List<ITEM> chkItems = this.data.getCheckedItems(
          currentItemInclusion: currentItemInclusion,
        );
    if (chkItems.isEmpty) {
      return null;
    }
    return await deleteItems(
      items: chkItems,
      stopIfError: stopIfError,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  Future<ItemDeletionResult?> deleteItems({
    required List<ITEM> items,
    required bool stopIfError,
  }) async {
    _XShelf xShelf = _XShelf(
        shelf: shelf,
        forceFilterModelOpt: null,
        forceQueryScalarOpts: [],
        forceQueryBlockOpts: [],
        forceQueryFormModelOpts: []);
    _XBlock xBlock = xShelf.findXBlockByName(this.name)!;
    List<ITEM> deleteItems = this.data.moveCurrentItemToEndOfList(
          itemList: items,
        );
    //
    // xBlock.itemDeletionResult.candidateItems = deleteItems;
    //
    for (ITEM item in deleteItems) {
      var taskUnit = _BlockDeleteItemTaskUnit(xBlock: xBlock, item: item);
      FlutterArtist.taskUnitQueue.addTaskUnit(taskUnit);
      await FlutterArtist.executor._executeTaskUnitQueue();
      if (stopIfError) {
        ItemDeletionResult result = xBlock.itemDeletionResult;
        if (!result.success) {
          return result;
        }
      }
    }
    return xBlock.itemDeletionResult;
  }

  // ***************************************************************************
  // ***************************************************************************

  @RootMethodAnnotation()
  Future<bool> deleteItemById({
    required ID itemId,
    required bool ignoreIfItemNotInList,
  }) async {
    FlutterArtist.codeFlowLogger._addMethodCall(
      isLibCode: true,
      navigate: null,
      ownerClassInstance: this,
      methodName: "deleteItemById",
      parameters: {
        "itemId": itemId,
      },
    );
    //
    ITEM? item = this.data.findItemById(itemId);
    //
    if (item == null) {
      if (ignoreIfItemNotInList) {
        showErrorSnackBar(
          message: "Ignore deletion because this item is not in the list.",
          errorDetails: ["ignoreIfItemNotInList: true"],
        );
        return false;
      }
      ApiResult<ITEM_DETAIL> result;
      try {
        result = await FlutterArtist.executeTask(
          asyncFunction: () async {
            return await callApiFindItemById(itemId: itemId);
          },
        );
      } catch (e, stackTrace) {
        _handleError(
          shelf: shelf,
          methodName: "callApiFindItemById",
          error: e,
          stackTrace: stackTrace,
          showSnackBar: true,
        );
        //
        return false;
      }
      //
      if (result.isError()) {
        _handleRestError(
          shelf: shelf,
          methodName: "callApiFindItemById",
          message: result.errorMessage!,
          errorDetails: result.errorDetails,
          showSnackBar: true,
        );
        return false;
      }
      ITEM_DETAIL? itemDetail = result.data;
      if (itemDetail == null) {
        return true;
      }
      try {
        item = this.convertItemDetailToItem(itemDetail: itemDetail);
      } catch (e, stackTrace) {
        _handleError(
          shelf: shelf,
          methodName: "convertItemDetailToItem",
          error: e,
          stackTrace: stackTrace,
          showSnackBar: true,
        );
        //
        return false;
      }
    }
    //
    Actionable actionable = canDeleteItem(item: item);
    if (!actionable.yes) {
      return false;
    }
    bool confirm = await showConfirmDeleteDialog(details: getClassName(item));
    if (!confirm) {
      return false;
    }
    return true;
  }

  // ***************************************************************************
  // ***************************************************************************

  @RootMethodAnnotation()
  Future<ItemDeletionResult?> deleteCurrentItem() async {
    FlutterArtist.codeFlowLogger._addMethodCall(
      isLibCode: true,
      navigate: null,
      ownerClassInstance: this,
      methodName: "deleteCurrentItem",
      parameters: {},
    );
    //

    ITEM? currentItem = this.data.currentItem;
    if (currentItem != null) {
      return deleteItem(item: currentItem);
    }
    return null;
  }

  // ***************************************************************************
  // ***************************************************************************

  @RootMethodAnnotation()
  Future<ItemDeletionResult?> deleteItem({
    required ITEM item,
    bool ignoreIfItemNotInList = true,
  }) async {
    FlutterArtist.codeFlowLogger._addMethodCall(
      isLibCode: true,
      navigate: null,
      ownerClassInstance: this,
      methodName: "deleteItem",
      parameters: {
        "item": item,
      },
    );
    //
    Actionable actionable = canDeleteItem(item: item);
    if (!actionable.yes) {
      return null;
    }
    if (ignoreIfItemNotInList) {
      ITEM? it = this.data.findItemSameIdWith(item: item);
      if (it == null) {
        showErrorSnackBar(
          message: "Ignore deletion because this item is not in the list.",
          errorDetails: ["ignoreIfItemNotInList: true"],
        );
        return null;
      }
    }
    bool confirm = await showConfirmDeleteDialog(details: getClassName(item));
    if (!confirm) {
      return null;
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
    _TaskUnit taskUnit = _BlockDeleteItemTaskUnit(
      xBlock: thisXBlock,
      item: item,
    );
    //
    FlutterArtist.taskUnitQueue.addTaskUnit(taskUnit);
    //
    await FlutterArtist.executor._executeTaskUnitQueue();
    return thisXBlock.itemDeletionResult;
  }

  // ***************************************************************************
  // ***************************************************************************

  ///
  ///
  ///
  @RootMethodAnnotation()
  Future<CurrentItemSelectionResult<ITEM>?> refreshCurrentItem() async {
    FlutterArtist.codeFlowLogger._addMethodCall(
      isLibCode: true,
      navigate: null,
      ownerClassInstance: this,
      methodName: "refreshCurrentItem",
      parameters: {},
    );
    //
    Actionable actionable = canRefreshCurrentItem();
    if (!actionable.yes) {
      return null;
    }
    //
    return await prepareToShowItem(
      item: this.data.currentItem!,
    );
  }

  // ***************************************************************************
  // ************* ITEM SELECTION/CHECK METHOD *********************************
  // ***************************************************************************

  void __updateUIComponentAfterCheckedOrSelected() {
    updateAllUIComponents(
      withoutFilters: false,
      force: true,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  void toggleCheckItem({
    required ITEM item,
  }) {
    this.data._toggleCheckItem(item: item);
    __updateUIComponentAfterCheckedOrSelected();
  }

  // ***************************************************************************
  // ***************************************************************************

  void toggleSelectItem({
    required ITEM item,
  }) {
    this.data._toggleSelectItem(item: item);
    __updateUIComponentAfterCheckedOrSelected();
  }

  // ***************************************************************************
  // ***************************************************************************

  void setCheckedItem({
    required ITEM item,
    required bool checked,
  }) {
    this.data._setCheckedItem(item: item, checked: checked);
    __updateUIComponentAfterCheckedOrSelected();
  }

  // ***************************************************************************
  // ***************************************************************************

  void setSelectedItem({
    required ITEM item,
    required bool selected,
  }) {
    this.data._setSelectedItem(item: item, selected: selected);
    __updateUIComponentAfterCheckedOrSelected();
  }

  // ***************************************************************************
  // ***************************************************************************

  void setCheckedItems({required List<ITEM> items}) {
    this.data._setCheckedItems(items: items);
    __updateUIComponentAfterCheckedOrSelected();
  }

  // ***************************************************************************
  // ***************************************************************************

  void setSelectedItems({required List<ITEM> items}) {
    this.data._setSelectedItems(items: items);
    __updateUIComponentAfterCheckedOrSelected();
  }

  // ***************************************************************************
  // ***************************************************************************

  void uncheckAllItems() {
    this.data._uncheckAllItems();
    __updateUIComponentAfterCheckedOrSelected();
  }

  // ***************************************************************************
  // ***************************************************************************

  void checkAllItems() {
    this.data._checkAllItems();
    __updateUIComponentAfterCheckedOrSelected();
  }

  // ***************************************************************************
  // ***************************************************************************

  void selectAllItems() {
    this.data._selectAllItems();
    __updateUIComponentAfterCheckedOrSelected();
  }

  // ***************************************************************************
  // ***************************************************************************

  void deselectAllItems() {
    this.data._deselectAllItems();
    __updateUIComponentAfterCheckedOrSelected();
  }

  // ***************************************************************************
  // ************* API METHOD **************************************************
  // ***************************************************************************

  Future<ApiResult<PageData<ITEM>?>> callApiQuery({
    required FILTER_CRITERIA filterCriteria,
    required PageableData pageable,
  });

  // ---------------------------------------------------------------------------

  Future<ApiResult<void>> callApiDeleteItem({required ITEM item});

  // ---------------------------------------------------------------------------

  Future<ApiResult<ITEM_DETAIL>> callApiRefreshItem({required ITEM item});

  // ---------------------------------------------------------------------------

  Future<ApiResult<ITEM_DETAIL>> callApiFindItemById({required ID itemId});

  // ***************************************************************************
  // ****** UPDATE UI COMPONENTS ***********************************************
  // ***************************************************************************

  void updateAllUIComponents({
    required bool withoutFilters,
    bool force = true,
  }) {
    if (!withoutFilters) {
      filterModel?.updateAllUIComponents();
    }
    //
    updateBlockFragmentWidgets(force: force);
    updatePaginationWidgets(force: force);
    updateControlBarWidgets(force: force);
    updateControlWidgets(force: force);
    //
    formModel?.updateAllUIComponents(force: force);
  }

  // ***************************************************************************
  // ***************************************************************************

  void updateItemsView() {
    // TODO: Sua lai cho nay.
    for (_RefreshableWidgetState widgetState
        in _blockFragmentWidgetStates.keys) {
      if (widgetState.mounted) {
        widgetState.refreshState();
      }
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  void updateBlockFragmentWidgets({bool force = false}) {
    for (_RefreshableWidgetState widgetState
        in _blockFragmentWidgetStates.keys) {
      if (widgetState.mounted) {
        widgetState.refreshState(force: force);
      }
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  void updateControlBarWidgets({bool force = false}) {
    for (_RefreshableWidgetState widgetState in _controlBarWidgetStates.keys) {
      if (widgetState.mounted) {
        widgetState.refreshState(force: force);
      }
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  void updateControlWidgets({bool force = false}) {
    for (_RefreshableWidgetState widgetState in _controlWidgetStates.keys) {
      if (widgetState.mounted) {
        widgetState.refreshState(force: force);
      }
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  void updatePaginationWidgets({bool force = false}) {
    for (_RefreshableWidgetState widgetState in _paginationWidgetStates.keys) {
      if (widgetState.mounted) {
        widgetState.refreshState(force: force);
      }
    }
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
    ITEM? currentItem = this.data.currentItem;
    if (currentItem == null) {
      return false;
    }
    return isAllowUpdateItem(item: currentItem);
  }

  // ***************************************************************************
  // ***************************************************************************

  bool isAllowDeleteCurrentItem() {
    ITEM? currentItem = this.data.currentItem;
    if (currentItem == null) {
      return false;
    }
    return isAllowDeleteItem(item: currentItem);
  }

  // ***************************************************************************
  // *********** __isAllowXXX() method *****************************************
  // ***************************************************************************

  ///
  /// Allows deleting an Item or not according to the application logic.
  ///
  Actionable __isAllowQuery() {
    try {
      bool allow = isAllowQuery();
      return allow
          ? Actionable.yes()
          : Actionable.no(
              message: "The application logic does not allow query this block.",
            );
    } catch (e, stackTrace) {
      _handleError(
        shelf: shelf,
        methodName: "isAllowQuery",
        error: e,
        stackTrace: stackTrace,
        showSnackBar: false,
      );
      return Actionable.no(
        message: "The ${getClassName(this)}.isAllowQuery() error.",
      );
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  ///
  /// Allows edit current item or not according to the application logic.
  ///
  Actionable __isAllowResetForm() {
    bool allow = isAllowResetForm();
    return allow
        ? Actionable.yes()
        : Actionable.no(
            message: "The application logic does not allow to reset the form.");
  }

  // ***************************************************************************
  // ***************************************************************************

  ///
  /// Allows edit current item or not according to the application logic.
  ///
  Actionable __isAllowUpdateItemCurrentItem() {
    ITEM? currentItem = this.data.currentItem;
    if (currentItem == null) {
      return Actionable.no(message: "The current item is not available.");
    }
    return _isAllowUpdateItem(item: currentItem);
  }

  // ***************************************************************************
  // ***************************************************************************

  ///
  /// Allows deleting an Item or not according to the application logic.
  ///
  Actionable _isAllowUpdateItem({required ITEM item}) {
    try {
      bool allow = isAllowUpdateItem(item: item);
      return allow
          ? Actionable.yes()
          : Actionable.no(
              message:
                  "The application logic does not allow this item to be updated.");
    } catch (e, stackTrace) {
      _handleError(
        shelf: shelf,
        methodName: "isAllowUpdateItem",
        error: e,
        stackTrace: stackTrace,
        showSnackBar: false,
      );
      return Actionable.no(
          message: "The ${getClassName(this)}.isAllowUpdateItem() error.");
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  ///
  /// Allows creating a new Item or not according to the application logic.
  ///
  Actionable __isAllowCreateItem() {
    try {
      bool allow = isAllowCreateItem();
      return allow
          ? Actionable.yes()
          : Actionable.no(
              message:
                  "The application logic does not allow to create a new item.");
    } catch (e, stackTrace) {
      _handleError(
        shelf: shelf,
        methodName: "isAllowCreateItem",
        error: e,
        stackTrace: stackTrace,
        showSnackBar: false,
      );
      return Actionable.no(
          message: "The ${getClassName(this)}.isAllowCreateItem() error.");
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  ///
  /// Allows deleting an Item or not according to the application logic.
  ///
  Actionable __isAllowDeleteItem({required ITEM item}) {
    try {
      bool allow = isAllowDeleteItem(item: item);
      return allow
          ? Actionable.yes()
          : Actionable.no(
              message:
                  "The application logic does not allow this item to be deleted.");
    } catch (e, stackTrace) {
      _handleError(
        shelf: shelf,
        methodName: "isAllowDeleteItem",
        error: e,
        stackTrace: stackTrace,
        showSnackBar: false,
      );
      return Actionable.no(
          message: "The ${getClassName(this)}.isAllowDeleteItem() error.");
    }
  }

  // ***************************************************************************
  // *********** __checkAncestorsSafeXXX() method ******************************
  // ***************************************************************************

  // TODO: Viet chi tiet hon:
  ///
  /// Check if Ancestor Blocks in Safe State to Query in current Block.
  ///
  Actionable __checkAncestorsSafeToQuery() {
    if (parent == null) {
      return Actionable.yes();
    }
    //
    if (!parent!.hasCurrentItem()) {
      return Actionable.no(
        message:
            "The query is disabled because the parent block has no current item.",
      );
    }
    //
    if (parent!.formModel != null) {
      switch (parent!.formModel!.formMode) {
        case FormMode.none:
          return Actionable.no(
            message:
                "Query is disabled because the parent block's form is in 'none' mode",
          );
        case FormMode.creation:
          return Actionable.no(
            message:
                "Query is disabled because the parent block's form is in 'creation' mode",
          );
        case FormMode.edit:
          break; // Do nothing
      }
    }
    //
    return parent!.__checkAncestorsSafeToQuery();
  }

  // ***************************************************************************
  // ***************************************************************************

  // TODO: Viet chi tiet hon:
  ///
  /// Check if Ancestor Blocks in Safe State to Delete item in current Block.
  ///
  Actionable __checkAncestorsSafeToDelete(ITEM? item) {
    if (parent == null) {
      return Actionable.yes();
    }
    // TODO: Kiểm tra nếu item là current thì mới cần đk này:
    if (parent!.formModel != null) {
      switch (parent!.formModel!.formMode) {
        case FormMode.none:
          return Actionable.no(
            message:
                "Disallow deleting items when the ancestor block form is in 'none' mode.",
          );
        case FormMode.creation:
          return Actionable.no(
            message:
                "Disallow deleting items when the ancestor block form is in 'creation' mode.",
          );
        case FormMode.edit:
          break; // Do nothing
      }
    }
    //
    return parent!.__checkAncestorsSafeToDelete(null);
  }

  // ***************************************************************************
  // ***************************************************************************

  // TODO: Viet chi tiet hon:
  ///
  /// Check if Ancestor Blocks in Safe State to Create item in current Block.
  ///
  Actionable __checkAncestorsSafeToCreate({
    required ItemCreationType creationType,
  }) {
    if (parent == null) {
      return Actionable.yes();
    }
    //
    if (parent!.formModel != null) {
      switch (parent!.formModel!.formMode) {
        case FormMode.none:
          return Actionable.no(
            message:
                "New item creation is disabled because the ancestor block's form is in 'none' mode",
          );
        case FormMode.creation:
          return Actionable.no(
            message:
                "New item creation is disabled because the ancestor block's form is in 'creation' mode",
          );
        case FormMode.edit:
          break; // Do nothing
      }
    }
    if (parent!.data.currentItem == null) {
      return Actionable.no(
        message:
            "New item creation is disabled because the parent block has no current element.",
      );
    }
    //
    return parent!.__checkAncestorsSafeToCreate(creationType: creationType);
  }

  // ***************************************************************************
  // ***************************************************************************

  // TODO: Viet chi tiet hon:
  ///
  /// Check if Ancestor Blocks in Safe State to Edit item in current Block.
  ///
  Actionable __checkAncestorsSafeToEditItem({required ITEM? item}) {
    if (parent == null) {
      return Actionable.yes();
    }
    if (parent!.formModel != null) {
      switch (parent!.formModel!.formMode) {
        case FormMode.none:
          return Actionable.no(
            message:
                "Disallow editing items when the ancestor block form is in 'none' mode.",
          );
        case FormMode.creation:
          return Actionable.no(
            message:
                "Disallow editing items when the ancestor block form is in 'creation' mode.",
          );
        case FormMode.edit:
          break; // Do nothing
      }
    }
    return parent!.__checkAncestorsSafeToEditItem(item: null);
  }

  // ***************************************************************************
  // *********** __canXXX() method *********************************************
  // ***************************************************************************

  Actionable __canDeleteItem({required ITEM item, required bool checkAllow}) {
    if (__isDeleting) {
      return Actionable.no(
        message:
            "Cannot delete another item while the previous delete action is in progress",
      );
    }
    //
    Actionable ancestorsSafe = __checkAncestorsSafeToDelete(item);
    if (!ancestorsSafe.yes) {
      return ancestorsSafe;
    }
    //
    return checkAllow ? __isAllowDeleteItem(item: item) : Actionable.yes();
  }

  // ***************************************************************************
  // ***************************************************************************

  Actionable __canCreateItem({
    required ItemCreationType creationType,
    required bool checkAllow,
  }) {
    if (FlutterArtist.executor.isBusy) {
      return Actionable.no(
        message: "New item creation is disabled because the executor is busy.",
      );
    }
    if (creationType == ItemCreationType.form && formModel == null) {
      return Actionable.no(
        message: "New item creation is disabled because the block has no form.",
      );
    }
    switch (queryDataState) {
      case DataState.pending:
        return Actionable.no(
          message:
              "New item creation is disabled because the block is in a 'pending' state.",
        );
      case DataState.error:
        return Actionable.no(
          message:
              "New item creation is disabled because the block is in an 'error' state.",
        );
      case DataState.none:
        return Actionable.no(
          message:
              "New item creation is disabled because the block is in a 'none' state.",
        );
      case DataState.ready:
        break;
    }
    // if (data.queryDataState == DataState.ready) {}
    // Actionable ancestorSafe = __checkAncestorsSafeToCreate(
    //   creationType: creationType,
    // );
    // if (ancestorSafe.no) {
    //   return ancestorSafe;
    // }
    return checkAllow ? __isAllowCreateItem() : Actionable.yes();
  }

  // ***************************************************************************
  // ***************************************************************************

  Actionable __canResetForm({required bool checkAllow}) {
    if (formModel == null) {
      return Actionable.no(
        message:
            "Form reset is not allowed because this block does not have a form.",
      );
    }
    if (!formModel!.isDirty()) {
      return Actionable.no(
        message:
            "Form reset is not allowed because the form is not in dirty state.",
      );
    }
    if (this.__isSaving) {
      return Actionable.no(
        message:
            "Form reset is not allowed because the form is in saving state.",
      );
    }
    switch (formModel!.data._formMode) {
      case FormMode.none:
        return Actionable.no(
          message:
              "Form reset is not allowed because the form is in 'none' mode.",
        );
      case FormMode.creation:
        break; // Do nothing.
      case FormMode.edit:
        break; // Do nothing.
    }
    //
    return checkAllow ? __isAllowResetForm() : Actionable.yes();
  }

  // ***************************************************************************
  // ***************************************************************************

  Actionable __canSaveForm({required bool checkAllow}) {
    if (formModel == null) {
      return Actionable.no(
        message: "Cannot save form because this block does not have a form.",
      );
    }
    if (this.__isSaving) {
      return Actionable.no(
        message: "Cannot save form because form is in saving state.",
      );
    }
    // Actionable actionable;
    // switch (formModel!.data._formMode) {
    //   case FormMode.none:
    //     return Actionable.no(
    //       message: "Cannot save form because form is in 'none' mode",
    //     );
    //   case FormMode.creation:
    //     actionable = checkAllow ? __isAllowCreateItem() : Actionable.yes();
    //     break;
    //   case FormMode.edit:
    //     actionable = checkAllow ? __isAllowUpdateItemCurrentItem() :  Actionable.yes();
    //     break;
    // }
    if (!formModel!.isDirty()) {
      return Actionable.no(
        message: "Cannot save form because form is not dirty.",
      );
    }
    return Actionable.yes();
  }

  // ***************************************************************************
  // ***************************************************************************

  Actionable __canEditItemOnForm({
    required ITEM item,
    required bool checkAllow,
  }) {
    if (formModel == null) {
      return Actionable.no(
          message:
              "This item cannot be edited on the form because this block does not have a form.");
    }
    if (__isSaving) {
      return Actionable.no(
          message:
              "This item cannot be edited on the form because the block is in a data-saving state.");
    }
    //
    Actionable ancestorsSafe = __checkAncestorsSafeToEditItem(item: item);
    if (!ancestorsSafe.yes) {
      return ancestorsSafe;
    }
    switch (formModel!.data._formMode) {
      case FormMode.none:
        return Actionable.no(
          message:
              "Disallow editing items when the block form is in 'none' mode.",
        );
      case FormMode.creation:
        break; // Do nothing.
      case FormMode.edit:
        break; // Do nothing.
    }
    return checkAllow ? _isAllowUpdateItem(item: item) : Actionable.yes();
  }

  // ***************************************************************************
  // ***************************************************************************

  ///
  /// Edit on edit-mode
  /// Edit on creation-mode
  ///
  Actionable __isEnableFormToModify({required bool checkAllow}) {
    if (formModel != null) {
      switch (formModel!.data._formMode) {
        case FormMode.creation:
          return Actionable.yes();
        case FormMode.edit:
          break; // Continue check below.
        case FormMode.none:
          return Actionable.no(
              message: "Form disabled because it in 'none' mode");
      }
    }
    if (this.data.currentItemDetail == null) {
      return Actionable.no(
          message: "Form disabled because the block has no current item");
    }
    if (__isRefreshingCurrentItem) {
      return Actionable.no(
          message: "Form disabled because the block in refreshing state");
    }
    //
    return __canEditItemOnForm(
      item: this.data.currentItem!,
      checkAllow: checkAllow,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  Actionable __canRefreshCurrentItem() {
    if (this.data.currentItemDetail == null) {
      return Actionable.no(
        message: "Cannot refresh the current item because it is not available.",
      );
    }
    if (__isRefreshingCurrentItem) {
      return Actionable.no(
        message: "The current item is being refreshed.",
      );
    }
    //
    if (formModel != null) {
      switch (formModel!.data._formMode) {
        case FormMode.none:
          return Actionable.no(
            message:
                "Cannot refresh current item because form is in 'none' mode.",
          );
        case FormMode.creation:
          return Actionable.no(
            message:
                "Cannot refresh current item because form is in 'creation' mode.",
          );
        case FormMode.edit:
          break; // Do nothing
      }
    }
    //
    return Actionable.yes();
  }

  // ***************************************************************************
  // *********** canXXX() method ***********************************************
  // ***************************************************************************

  // bool isValidState() {
  //   switch (queryDataState) {
  //     case DataState.pending:
  //       return false;
  //     case DataState.error:
  //       return false;
  //     case DataState.none:
  //       return false;
  //     case DataState.ready:
  //       break; // Continue checking.
  //   }
  //   return true;
  // }

  // ***************************************************************************
  // ***************************************************************************

  Actionable canCreateItem() {
    return __canCreateItem(
      checkAllow: true,
      creationType: ItemCreationType.form,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  Actionable canResetForm() {
    return __canResetForm(checkAllow: true);
  }

  // ***************************************************************************
  // ***************************************************************************

  Actionable canSaveForm() {
    return __canSaveForm(checkAllow: true);
  }

  // ***************************************************************************
  // ***************************************************************************

  bool canSelectItem() {
    return this.queryDataState == DataState.ready;
  }

  // ***************************************************************************
  // ***************************************************************************

  Actionable canDeleteCurrentItem() {
    ITEM? currentItem = this.data.currentItem;
    if (currentItem == null) {
      return Actionable.no(
        message: "Cannot delete the current item because it is not available.",
      );
    }
    return canDeleteItem(item: currentItem);
  }

  // ***************************************************************************
  // ***************************************************************************

  Actionable canDeleteItem({required ITEM item}) {
    return __canDeleteItem(item: item, checkAllow: true);
  }

  // ***************************************************************************
  // ***************************************************************************

  Actionable canEditItemOnForm({required ITEM item}) {
    return __canEditItemOnForm(item: item, checkAllow: true);
  }

  // ***************************************************************************
  // ***************************************************************************

  Actionable _isEnableFormToModify() {
    return __isEnableFormToModify(checkAllow: true);
  }

  // ***************************************************************************
  // ***************************************************************************

  Actionable canEditCurrentItemOnForm() {
    return __isEnableFormToModify(checkAllow: true);
  }

  // ***************************************************************************
  // ***************************************************************************

  ///
  /// Checks whether the current item can be refreshed.
  ///
  /// This method will return [true] if all the usual conditions are met.
  ///
  Actionable canRefreshCurrentItem() {
    return __canRefreshCurrentItem();
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
  // ***************************************************************************

  Actionable canShowFormInfo() {
    ILoggedInUser? loggedInUser = FlutterArtist.loggedInUser;
    if (formModel == null) {
      return Actionable.no(
        message:
            "Cannot display 'FormInfoDialog' because this block does not have a form.",
      );
    }
    if (loggedInUser == null) {
      return Actionable.no(
        message:
            "Cannot display 'FormInfoDialog' because the user is not logged in.",
      );
    }
    if (!loggedInUser.isSystemUser) {
      return Actionable.no(
        message:
            "Cannot display 'FormInfoDialog' because the user is not a system user..",
      );
    }
    return Actionable.yes();
  }

  // ***************************************************************************
  // ***************************************************************************

  Actionable __canQuery({required bool checkAllow}) {
    if (__isQuerying) {
      return Actionable.no(message: "The bock is in querying state");
    }
    Actionable ancestorsSafe = __checkAncestorsSafeToQuery();
    if (!ancestorsSafe.yes) {
      return ancestorsSafe;
    }
    return checkAllow ? __isAllowQuery() : Actionable.yes();
  }

  // ***************************************************************************
  // ***************************************************************************

  Actionable canQuery() {
    return __canQuery(checkAllow: true);
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
