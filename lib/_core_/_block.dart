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
/// [FILTER_INPUT]: Additional data to create or modify [DataFilter].
/// ```
/// class EmployeeFilterInput extends FilterInput {
///    String? searchText,
///    int? departmentId;
/// }
/// ```
///
/// [FILTER_CRITERIA]: These are the criteria for filtering the data.
///
/// When the [Block.query] or [Scalar.query] method is called,
/// this [FilterCriteria] is created automatically by the [DataFilter]
/// via the [DataFilter.createFilterCriteria] method
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
  /// DataFilter Name registered in [Shelf.registerStructure()] method.
  ///
  final String? registerDataFilterName;

  ///
  /// This field is not null.
  /// If this block does not declare a [DataFilter], it will have the default [DataFilter].
  ///
  late final DataFilter<FILTER_INPUT, FILTER_CRITERIA>
      _registeredOrDefaultDataFilter;

  ///
  /// Returns a DataFilter declared in the [Shelf.registerStructure()] method.
  /// The return value may be null.
  ///
  DataFilter<FILTER_INPUT, FILTER_CRITERIA>? get dataFilter {
    if (_registeredOrDefaultDataFilter is _DefaultDataFilter) {
      return null;
    } else {
      return _registeredOrDefaultDataFilter;
    }
  }

  late final Block? parent;

  String? get parentBlockName => parent?.name;

  final BlockForm<
      ID, //
      ITEM_DETAIL,
      FILTER_CRITERIA,
      EXTRA_FORM_INPUT>? blockForm;

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

  late final BlockData<
          ID, //
          ITEM,
          ITEM_DETAIL,
          FILTER_INPUT,
          FILTER_CRITERIA,
          EXTRA_FORM_INPUT> data //
      = _InternalBlockData<
          ID, //
          ITEM,
          ITEM_DETAIL,
          FILTER_INPUT,
          FILTER_CRITERIA,
          EXTRA_FORM_INPUT>.empty(
    this,
    __pageable,
  );

  DataState get queryDataState => data._queryDataState;

  DataState get selectionDataState => data._selectionDataState;

  final ItemSortCriteria? _itemSortCriteria;

  ItemSortCriteria? get itemSortCriteria => _itemSortCriteria;

  final Map<_RefreshableWidgetState, bool> _blockFragmentWidgetStates = {};
  final Map<_RefreshableWidgetState, bool> _controlBarWidgetStates = {};
  final Map<_RefreshableWidgetState, bool> _controlWidgetStates = {};
  final Map<_RefreshableWidgetState, bool> _paginationWidgetStates = {};

  Block({
    required this.name,
    required this.description,
    int pageSize = 20,
    this.hiddenBehavior = BlockHiddenBehavior.none,
    this.leaveTheFormSafely = true,
    required String? dataFilterName,
    required this.blockForm,
    required this.fireEvent,
    required List<Type> listenItemTypes,
    required List<Block>? childBlocks,
    ItemSortCriteria<ITEM>? itemSortCriteria,
  })  : registerDataFilterName = dataFilterName,
        __pageSize = pageSize,
        __listenItemTypes = listenItemTypes,
        _itemSortCriteria = itemSortCriteria,
        _childBlocks = childBlocks ?? [] {
    itemSortCriteria?.block = this;
    for (Block childBlock in _childBlocks) {
      childBlock.parent = this;
    }
    if (blockForm != null) {
      blockForm!.block = this;
    }
  }

  // ***************************************************************************

  void __clearWithDataState({
    required _XBlock thisXBlock,
    required DataState queryDataState,
    required DataState formDataState,
  }) {
    __assertThisXBlock(thisXBlock);
    //
    data._clearWithDataState(queryDataState: queryDataState);
    if (blockForm != null) {
      blockForm!._clearWithDataState(dataState: formDataState);
    }
  }

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

  //
  void __setQueryDataWithStateCascade({
    required _XBlock thisXBlock,
    required FILTER_CRITERIA? filterCriteria,
    required ListBehavior listBehavior,
    required PageableData? pageable,
    required PageData<ID, ITEM>? pageData,
    required ITEM? candidateCurrentItem,
    required DataState dataState,
    required DataState formDataState,
  }) {
    __assertThisXBlock(thisXBlock);
    //
    data._updateFrom(
      forceListBehavior: listBehavior,
      currentParentItemId: this.parentItemId,
      filterCriteria: filterCriteria,
      pageable: pageable,
      pageData: pageData,
      dataState: dataState,
    );
    if (blockForm != null) {
      // TODO: ??????????????????????????????????????????????????????
      // Update formDataState ???????
      // blockForm!.data._updateFormData(formData);
    }
    switch (dataState) {
      case DataState.ready:
        // TODO: Tạm thời cứ clear all Child Block ITEMS:
        this.__clearChildrenWithDataStateCascade(
          thisXBlock: thisXBlock,
          queryDataState: DataState.pending,
          formDataState: DataState.pending,
        );
      case DataState.pending:
        // TODO: Tạm thời cứ clear all Child Block ITEMS:
        this.__clearChildrenWithDataStateCascade(
          thisXBlock: thisXBlock,
          queryDataState: DataState.pending,
          formDataState: DataState.pending,
        );
      case DataState.error:
        // TODO: Tạm thời cứ clear all Child Block ITEMS:
        this.__clearChildrenWithDataStateCascade(
          thisXBlock: thisXBlock,
          queryDataState: DataState.error,
          formDataState: DataState.error,
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
    Object? parentInData = data._currentParentItemId;
    Object? parentInBlock = parentItemId;
    if (parentInData != parentInBlock) {
      return true;
    }
    //
    if (dataFilter != null) {
      FilterCriteria? criteriaInFilter = dataFilter!.filterCriteria;
      FilterCriteria? criteriaInData = data.filterCriteria;
      if (criteriaInFilter != criteriaInData) {
        return true;
      }
    }
    //
    return false;
  }

  void __refreshQueryingState({required bool isQuerying}) {
    try {
      __isQuerying = isQuerying;
      this.updateControlBarWidgets();
    } catch (e) {}
  }

  void __refreshDeletingState({required bool isDeleting}) {
    try {
      __isDeleting = isDeleting;
      this.updateControlBarWidgets();
    } catch (e) {}
  }

  void _refreshSavingState({required bool isSaving}) {
    try {
      __isSaving = isSaving;
      this.updateControlBarWidgets();
    } catch (e) {}
  }

  void __refreshRefreshingCurrentItemState({
    required bool isRefreshingCurrentItem,
  }) {
    try {
      __isRefreshingCurrentItem = isRefreshingCurrentItem;
      this.updateControlBarWidgets();
    } catch (e) {}
  }

  void __refreshPreparingFormCreationState({
    required bool isPreparingFormCreation,
  }) {
    try {
      __isPreparingFormCreation = isPreparingFormCreation;
      this.updateControlBarWidgets();
    } catch (e) {}
  }

  void _addPaginationWidgetState({
    required _RefreshableWidgetState widgetState,
    required bool isShowing,
  }) {
    _paginationWidgetStates[widgetState] = isShowing;
    if (isShowing) {
      FlutterArtist.storage._addRecentShelf(shelf);
    }
  }

  void _removePaginationWidgetState({
    required _RefreshableWidgetState widgetState,
  }) {
    _paginationWidgetStates.remove(widgetState);
  }

  void _addControlBarWidgetState({
    required _RefreshableWidgetState widgetState,
    required bool isShowing,
  }) {
    bool activeOLD = hasActiveUIComponent();
    _controlBarWidgetStates[widgetState] = isShowing;
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

  void _removeControlBarWidgetState({
    required _RefreshableWidgetState widgetState,
  }) {
    _controlBarWidgetStates.remove(widgetState);
  }

  void _addControlWidgetState({
    required _RefreshableWidgetState widgetState,
    required bool isShowing,
  }) {
    bool activeOLD = hasActiveUIComponent();
    _controlWidgetStates[widgetState] = isShowing;
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

  void _removeControlWidgetState({
    required _RefreshableWidgetState widgetState,
  }) {
    _controlWidgetStates.remove(widgetState);
  }

  void _addBlockFragmentWidgetState({
    required _RefreshableWidgetState widgetState,
    required bool isShowing,
  }) {
    bool activeOLD = hasActiveUIComponent();
    _blockFragmentWidgetStates[widgetState] = isShowing;
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

  void _removeBlockFragmentWidgetState({required State widgetState}) {
    bool activeOLD = hasActiveUIComponent();
    _blockFragmentWidgetStates.remove(widgetState);
    bool activeCURRENT = hasActiveUIComponent();
    //
    if (activeOLD && !activeCURRENT) {
      _fireBlockHidden();
    }
  }

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

  Map<_RefreshableWidgetState, bool> _findMountedWidgetStates({
    required bool withPagination,
    required bool withBlockFragment,
    required bool withFilter,
    required bool withForm,
    required bool withControl,
    required bool withControlBar,
    required bool activeOnly,
  }) {
    Map<_RefreshableWidgetState, bool> ret = {};
    //
    if (withFilter) {
      ret.addAll(_registeredOrDefaultDataFilter._filterFragmentWidgetStates);
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
    if (withForm && blockForm != null) {
      ret.addAll(blockForm!._formWidgetStates);
    }
    return ret;
  }

  bool hasMountedUIComponent() {
    return (dataFilter?.hasMountedUIComponent() ?? false) ||
        _blockFragmentWidgetStates.isNotEmpty ||
        _controlBarWidgetStates.isNotEmpty ||
        _controlWidgetStates.isNotEmpty ||
        _paginationWidgetStates.isNotEmpty ||
        (blockForm?.hasMountedUIComponent() ?? false);
  }

  bool hasActiveUIComponent() {
    bool active = false;
    // Filter
    if (dataFilter != null) {
      active = dataFilter!.hasActiveUIComponent();
      if (active) {
        return true;
      }
    }
    // Form
    active = blockForm != null && blockForm!.hasActiveUIComponent();
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

  bool hasActiveBlockFragmentWidget({required bool alsoCheckChildren}) {
    var map = {..._blockFragmentWidgetStates};
    for (State widgetState in map.keys) {
      if (widgetState.mounted) {
        bool isShowing = map[widgetState] ?? false;
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

  bool hasActiveControlBarWidget() {
    for (_RefreshableWidgetState controlBarState
        in _controlBarWidgetStates.keys) {
      bool visible = _controlBarWidgetStates[controlBarState] ?? false;
      if (visible && controlBarState.mounted) {
        return true;
      }
    }
    return false;
  }

  bool hasActiveControlWidget() {
    for (_RefreshableWidgetState controlState in _controlWidgetStates.keys) {
      bool visible = _controlWidgetStates[controlState] ?? false;
      if (visible && controlState.mounted) {
        return true;
      }
    }
    return false;
  }

  bool hasActivePaginationWidget() {
    for (_RefreshableWidgetState paginationState
        in _paginationWidgetStates.keys) {
      bool visible = _paginationWidgetStates[paginationState] ?? false;
      if (visible && paginationState.mounted) {
        return true;
      }
    }
    return false;
  }

  void _executeNavigation({Function()? navigate}) {
    try {
      if (navigate != null) {
        printLog("  ~~~~~~~~~~~~~~~~~~> navigate");
        navigate();
      }
    } catch (e, stackTrace) {
      print(stackTrace);
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  Future<void> _executeTaskUnit(_BlockTaskUnit taskUnit) async {
    switch (taskUnit.taskUnitName) {
      case BlockTaskUnitName.query:
        await taskUnit.xBlock.block._unitQuery(
          thisXBlock: taskUnit.xBlock,
        );
      case BlockTaskUnitName.select:
        await taskUnit.xBlock.block._unitPrepareToShow(
          thisXBlock: taskUnit.xBlock,
        );
    }
  }

  Future<void> _executeDeleteItemTaskUnit(
      _BlockDeleteItemTaskUnit taskUnit) async {
    await taskUnit.xBlock.block._unitDeleteItem(
      thisXBlock: taskUnit.xBlock,
      item: taskUnit.item,
    );
  }

  Future<void> _executeQuickCreateItemTaskUnit(
      _BlockQuickCreateItemTaskUnit taskUnit) async {
    await taskUnit.xBlock.block._unitQuickCreateItem(
      thisXBlock: taskUnit.xBlock,
      action: taskUnit.action,
    );
  }

  Future<void> _executeQuickUpdateItemTaskUnit(
      _BlockQuickUpdateItemTaskUnit taskUnit) async {
    await taskUnit.xBlock.block._unitQuickUpdateItem(
      thisXBlock: taskUnit.xBlock,
      action: taskUnit.action,
    );
  }

  // ***************************************************************************
  // ***************************************************************************

  Future<bool> _unitQuery({required _XBlock thisXBlock}) async {
    __assertThisXBlock(thisXBlock);
    //
    print(
        ">> ${getClassName(this)}._unitQuery - queryState: $queryDataState, forceQuery: ${thisXBlock.forceQuery}");
    if (this.queryDataState == DataState.ready && !thisXBlock.forceQuery) {
      _taskUnitQueue.addTaskUnit(
        _BlockTaskUnit(
          xBlock: thisXBlock,
          taskUnitName: BlockTaskUnitName.select,
        ),
      );
      return true;
    }
    //
    // this.queryDataState != DataState.ready || thisXBlock.forceQuery
    //
    DataState newQueryDataState = this.queryDataState;
    //
    FlutterArtist.codeFlowLogger._addMethodCall(
      isLibCode: false,
      navigate: null,
      ownerClassInstance: this,
      methodName: "callApiQuery",
      parameters: {},
    );
    //
    FILTER_CRITERIA? filterCriteria;
    try {
      final _XDataFilter xDataFilter = thisXBlock.xDataFilter;
      final DataFilter dataFilter = xDataFilter.dataFilter;
      //
      if (!xDataFilter.queried) {
        FILTER_INPUT? filterInput = xDataFilter.filterInput as FILTER_INPUT?;
        //
        filterCriteria = await dataFilter._prepareData(
          filterInput: filterInput,
        ) as FILTER_CRITERIA?;
        //
        xDataFilter.queried = true;
      } else {
        filterCriteria = dataFilter._filterCriteria! as FILTER_CRITERIA;
      }
    } catch (e, stackTrace) {
      /* Never Error */
    }
    //
    // Has Error in DataFilter.
    //
    if (filterCriteria == null) {
      // Set Block to error cascade.
      __clearWithDataStateCascade(
        thisXBlock: thisXBlock,
        queryDataState: DataState.error,
        formDataState: DataState.error,
      );
      return false;
    }
    //
    // Ready FilterCriteria:
    //
    bool xCriteriaChanged = data._isXCriteriaChanged(
      newCurrentParentItemId: parentItemId,
      newFilterCriteria: filterCriteria,
    );
    //
    final PageableData callingPageable = thisXBlock.pageable ??
        __pageable ??
        const PageableData(page: 1, pageSize: null);
    //
    final ITEM? candidateCurrentItem;
    final ListBehavior newListBehavior;
    final int currentItemCount = data.itemCount;
    //
    if (xCriteriaChanged) {
      newListBehavior = ListBehavior.replace;
      candidateCurrentItem = null;
    } else {
      newListBehavior = thisXBlock.listBehavior;
      candidateCurrentItem = data.currentItem;
    }
    bool isQueryError = false;
    PageData<ID, ITEM>? pageData;
    try {
      __refreshQueryingState(isQuerying: true);
      //
      ApiResult<PageData<ID, ITEM>?> result = await callApiQuery(
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
      switch (newListBehavior) {
        case ListBehavior.replace:
          newQueryDataState = DataState.error;
        case ListBehavior.append:
          if (currentItemCount > 0) {
            newQueryDataState = DataState.ready;
          } else {
            newQueryDataState = DataState.error;
          }
      }
    } else {
      newQueryDataState = DataState.ready;
    }
    //
    thisXBlock.setState(
      candidateCurrentItem: candidateCurrentItem,
      stateCurrentItem: data.currentItem,
      stateCurrentItemDetail: data.currentItemDetail,
      stateSelectedItems: data._selectedItems,
      stateCheckedItems: data._checkedItems,
    );
    //
    __setQueryDataWithStateCascade(
      thisXBlock: thisXBlock,
      filterCriteria: filterCriteria,
      listBehavior: newListBehavior,
      pageable: callingPageable,
      pageData: pageData,
      candidateCurrentItem: candidateCurrentItem,
      dataState: newQueryDataState,
      // TODO XEM LAI ?????????????????????????????
      formDataState: DataState.pending,
    );

    //
    // Add TaskUnit
    //
    if (newQueryDataState == DataState.ready) {
      _taskUnitQueue.addTaskUnit(
        _BlockTaskUnit(
          xBlock: thisXBlock,
          taskUnitName: BlockTaskUnitName.select,
        ),
      );
    }
    //
    return true;
  }

  // ***************************************************************************
  // ***************************************************************************

  Future<void> _unitPrepareToShow({required _XBlock thisXBlock}) async {
    __assertThisXBlock(thisXBlock);
    //
    if (this.queryDataState == DataState.error) {
      return;
    }
    if (this.queryDataState == DataState.pending) {
      throw Exception("Illegal Query State");
    }
    //
    if (this.data.itemCount == 0) {
      return;
    }
    print(
        ">>>>>>>>>>> ${getClassName(this)}._unitPrepareToShow - forceReloadItem: ${thisXBlock.forceReloadItem}");
    if (!thisXBlock.forceQuery || !thisXBlock.forceReloadItem) {
      // return;
    }
    //
    ITEM? candidateCurrentItem = thisXBlock._candidateCurrentItem as ITEM?;
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
    if (!newCurrent && !thisXBlock.forceReloadItem) {
      for (_XBlock childXBlock in thisXBlock.childXBlocks) {
        _taskUnitQueue.addTaskUnit(
          _BlockTaskUnit(
            xBlock: childXBlock,
            taskUnitName: BlockTaskUnitName.query,
          ),
        );
      }
      return;
    }
    // No item can be current.
    if (candidateCurrentItem == null) {
      this.__clearWithDataState(
        thisXBlock: thisXBlock,
        queryDataState: DataState.ready,
        formDataState: DataState.ready, // TODO: Xem lai...
      );
      return;
    }
    //
    // (newCurrent || forceReloadItem) && candidateCurrentItem !=null
    //
    bool isLoadItemError = false;
    //
    ITEM_DETAIL? candidateCurrentItemDetail;
    try {
      ApiResult<ITEM_DETAIL> result = await callApiRefreshItem(
        item: candidateCurrentItem,
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
    }
    // TODO: ???????????????????
    if (isLoadItemError) {
      if (newCurrent) {
        return;
      }
      return;
    }
    //
    this.data._selectionDataState = DataState.pending;

    // Item not found in database --> remove.
    if (candidateCurrentItemDetail == null) {
      ITEM? siblingItem = this.data.findSiblingItem(
            item: candidateCurrentItem,
          );
      // Remove item from List.
      this.data._removeItem(removeItem: candidateCurrentItem);
      if (!newCurrent) {
        this.data._setCurrentItemOnly(
              refreshedItem: null,
              refreshedItemDetail: null,
            );
      }
      // TODO: Update List only??
      // TODO: Them hieu ung trong qua trinh lua chon va xoa.
      this.updateAllUIComponents(withoutFilters: true);
      await Future.delayed(Duration(seconds: 1));
      //
      if (siblingItem != null) {
        thisXBlock._candidateCurrentItem = siblingItem;
        await _unitPrepareToShow(thisXBlock: thisXBlock);
      } else {
        this.data._selectionDataState = DataState.ready;
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
      // TODO
      return;
    }
    //
    this.data._selectionDataState = DataState.ready;
    this.data._setCurrentItemOnly(
          refreshedItem: candidateCurrentItem,
          refreshedItemDetail: candidateCurrentItemDetail,
        );
    if (newCurrent) {
      this.__clearChildrenWithDataStateCascade(
        thisXBlock: thisXBlock,
        queryDataState: DataState.pending,
        formDataState: DataState.pending,
      );
    }
    //
    // BlockForm:
    //
    if (thisXBlock.xBlockForm != null) {
      _taskUnitQueue.addTaskUnit(
        _BlockFormLoadFormTaskUnit(
          xBlockForm: thisXBlock.xBlockForm!,
        ),
      );
    }
    //
    for (_XBlock childXBlock in thisXBlock.childXBlocks) {
      _taskUnitQueue.addTaskUnit(
        _BlockTaskUnit(
          xBlock: childXBlock,
          taskUnitName: BlockTaskUnitName.query,
        ),
      );
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  Future<bool> _unitDeleteItem({
    required _XBlock thisXBlock,
    required ITEM item,
  }) async {
    __assertThisXBlock(thisXBlock);
    //
    try {
      // No need check again?
      bool canDelete = canDeleteItem(item: item);
      if (!canDelete) {
        return false;
      }
      final bool isCurrent = data.isCurrentItem(item: item);
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
        FlutterArtist.storage._fireEventSourceChanged(
          eventBlock: this,
          itemIdString: null,
        );
        //
        __refreshDeletingState(isDeleting: false);
      } catch (e, stackTrace) {
        __refreshDeletingState(isDeleting: false);
        //
        _handleError(
          shelf: shelf,
          methodName: "callApiDeleteItem",
          error: e,
          stackTrace: stackTrace,
          showSnackBar: true,
        );
        //
        return false;
      }
      if (result.errorMessage != null) {
        _handleRestError(
          shelf: shelf,
          methodName: "callApiDeleteItem",
          message: result.errorMessage!,
          errorDetails: result.errorDetails,
          showSnackBar: true,
        );
        return false;
      } else {
        if (!isCurrent) {
          __removeItemFromList(removeItem: item);
        } else {
          // Deleted current item ==> find sibling.
          final ITEM? sibling = data.findSiblingItem(item: item);
          // Remove Item
          __removeItemFromList(removeItem: item);

          //
          if (sibling != null) {
            bool success = await __prepareToShowOrEdit(
              thisXBlock: thisXBlock,
              item: sibling,
              justQueried: false,
              forceForm: false,
            );
            if (!success) {
              return false;
            }
          } else {
            bool success = await _switchThisAndChildrenToNoneMode(
              thisXBlock: thisXBlock,
              clearListForThis: false,
              dataState: DataState.ready,
            );
            if (!success) {
              return false;
            }
          }
        }
      }
      return true;
    } catch (e, stackTrace) {
      _handleError(
        shelf: shelf,
        methodName: "__delete",
        error: e,
        stackTrace: stackTrace,
        showSnackBar: true,
      );
      return false;
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  Future<bool> _unitQuickCreateItem({
    required _XBlock thisXBlock,
    required QuickCreateItemAction<ITEM_DETAIL> action,
  }) async {
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
        filterCriteria: data.filterCriteria,
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
      bool editable = canEditItemOnForm(item: refreshedItem);
      //
      FlutterArtist.codeFlowLogger._addInfo(
        ownerClassInstance: this,
        info: 'Allow Edit? $editable',
        isLibCode: true,
      );
      //
      this.__setCurrentItem(
        itemDetail: savedItemDetail,
        item: refreshedItem,
      );
      //
      if (blockForm != null) {
        blockForm!.data._setCurrentItem(
          refreshedItemDetail: savedItemDetail,
          formMode: FormMode.edit,
          dataState: DataState.pending,
        );
        bool success = await blockForm!._prepareMasterDataAndFormData(
          extraFormInput: null,
          filterCriteria: data.filterCriteria,
          refreshedItemDetail: savedItemDetail,
          isNew: false,
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
      final ITEM? removeItem = savedItem ?? data.currentItem;

      if (removeItem != null) {
        bool success = await __removeNotFoundItemAndSelectSibling(
          thisXBlock: thisXBlock,
          notFoundItem: removeItem,
        );
        if (!success) {
          return false;
        }
      }
      return true;
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  Future<bool> prepareToShowItem({
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
    _XShelf xShelf = _XShelf(
      shelf: shelf,
      forceDataFilterOpt: null,
      forceQueryScalarOpts: [],
      forceQueryBlockOpts: [],
      forceQueryBlockFormOpts: [],
    );
    //
    _XBlock thisXBlock = xShelf.findXBlockByName(this.name)!;
    thisXBlock.setState(
      candidateCurrentItem: item,
      stateCurrentItem: this.data.currentItem,
      stateCurrentItemDetail: this.data.currentItemDetail,
      stateSelectedItems: this.data.selectedItems,
      stateCheckedItems: this.data.checkedItems,
    );
    thisXBlock.setForceReloadItem();
    //
    await shelf._executeQueryXShelf(xShelf: xShelf);
    return true;
  }

  // ***************************************************************************
  // ***************************************************************************

  ///
  /// Clear and set block to "Pending State".
  ///
  Future<bool> clear({Function()? navigate}) async {
    FlutterArtist.codeFlowLogger._addMethodCall(
      isLibCode: true,
      navigate: navigate,
      ownerClassInstance: this,
      methodName: "clear",
      parameters: {},
    );
    //
    bool success = await shelf._queryAllWithOverlayAndRestorable(
      forceDataFilterOpt: null,
      forceQueryScalarOpts: [],
      forceQueryBlockOpts: [
        _BlockOpt(
          queryType: QueryType.clear,
          block: this,
          pageable: null,
          listBehavior: ListBehavior.replace,
          suggestedSelection: null,
          postQueryBehavior: PostQueryBehavior.selectAvailableItem,
        ),
      ],
      forceQueryBlockFormOpts: [],
    );
    //
    if (success) {
      _executeNavigation(navigate: navigate);
    }
    return success;
  }

  ///
  /// Query the next page and replace the current items in the list.
  ///
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

  ///
  /// Query the previous page and replace the current items in the list.
  ///
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

  ///
  /// Query the next page and append to the current list of items.
  ///
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

  ///
  ///
  ///
  @nonVirtual
  Future<bool> query({
    ListBehavior listBehavior = ListBehavior.replace,
    PostQueryBehavior postQueryBehavior = PostQueryBehavior.selectAvailableItem,
    FILTER_INPUT? filterInput,
    SuggestedSelection? suggestedSelection,
    PageableData? pageable,
    Function()? navigate,
  }) async {
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
    bool success = await shelf._queryAllWithOverlayAndRestorable(
      forceDataFilterOpt: _DataFilterOpt(
        dataFilter: _registeredOrDefaultDataFilter,
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
      forceQueryBlockFormOpts: [],
    );
    //
    if (success) {
      _executeNavigation(navigate: navigate);
    }
    return success;
  }

  ///
  ///
  ///
  @nonVirtual
  Future<bool> queryAndPrepareToEdit({
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
    bool success = await shelf._queryAllWithOverlayAndRestorable(
      forceDataFilterOpt: _DataFilterOpt(
        dataFilter: _registeredOrDefaultDataFilter,
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
      forceQueryBlockFormOpts: [],
    );
    //
    printLog("Success: $success");
    if (success) {
      _executeNavigation(navigate: navigate);
    }
    return success;
  }

  ///
  /// Clear and prepare Form to create new record.
  /// If this block has a BlockForm its data state set to "Ready", else its data state set to "Pending".
  ///
  Future<bool> clearAndPrepareToCreate({
    FILTER_INPUT? filterInput,
    Function()? navigate,
  }) async {
    FlutterArtist.codeFlowLogger._addMethodCall(
      isLibCode: true,
      navigate: navigate,
      ownerClassInstance: this,
      methodName: "clearAndPrepareToCreate",
      parameters: {},
    );
    //
    bool success = await shelf._queryAllWithOverlayAndRestorable(
      forceDataFilterOpt: _DataFilterOpt(
        dataFilter: this._registeredOrDefaultDataFilter,
        filterInput: filterInput,
      ),
      forceQueryScalarOpts: [],
      forceQueryBlockOpts: [
        _BlockOpt(
          queryType: QueryType.clear,
          block: this,
          pageable: null,
          listBehavior: ListBehavior.replace,
          suggestedSelection: null,
          postQueryBehavior: PostQueryBehavior.createNewItem,
        ),
      ],
      forceQueryBlockFormOpts: [],
    );
    //
    if (success) {
      _executeNavigation(navigate: navigate);
    }
    return success;
  }

  // Cascade query:
  // Private method (Only for use in this class)
  @Deprecated("Khong su dung nua, xoa di")
  Future<bool> _queryThisAndChildren({
    required _XBlock thisXBlock,
  }) async {
    __assertThisXBlock(thisXBlock);
    //
    bool needToQry = thisXBlock.forceQuery;
    if (!needToQry) {
      needToQry = thisXBlock.block._needToQuery();
    }
    if (!needToQry) {
      // Query child blocks:
      for (_XBlock childXBlock in thisXBlock.childXBlocks) {
        bool success = await childXBlock.block._queryThisAndChildren(
          thisXBlock: childXBlock,
        );
        if (!success) {
          return false;
        }
      }
      return true;
    }
    // Force Query this Block:
    final _XDataFilter xDataFilter = thisXBlock.xDataFilter;
    final DataFilter dataFilter = xDataFilter.dataFilter;
    //
    final FILTER_CRITERIA filterCriteria;
    //
    printLog(
        "\n${getClassName(this)} ~~~~~~~~~~~~> dataFilter: ${xDataFilter}");
    if (!xDataFilter.queried) {
      printLog(
          "${getClassName(this)} ~~~~~~~~~~~~> execute dataFilter: ${getClassName(xDataFilter.dataFilter)}");

      FILTER_INPUT? filterInput = xDataFilter.filterInput as FILTER_INPUT?;
      printLog(
          "${getClassName(this)} ~~~~~~~~~~~~> filterInput: ${filterInput}");
      //
      FILTER_CRITERIA? newCriteria = await dataFilter._prepareData(
        filterInput: filterInput,
      ) as FILTER_CRITERIA?;

      if (newCriteria == null) {
        return false;
      }
      filterCriteria = newCriteria;
      xDataFilter.queried = true;
    } else {
      filterCriteria = dataFilter._filterCriteria! as FILTER_CRITERIA;
    }
    //
    final QueryType queryType = thisXBlock.queryType;
    final ListBehavior listBehavior = thisXBlock.listBehavior;
    final PostQueryBehavior postQueryBehavior = thisXBlock.postQueryBehavior;
    final SuggestedSelection? suggestedSelection =
        thisXBlock.suggestedSelection;

    final PageableData? pageable = thisXBlock.pageable;
    //
    printLog(
        "${getClassName(this)} ~~~~~~~~~~~~> needQuery: ${thisXBlock.forceQuery} - queryType: ${queryType}");
    //
    bool needRealQuery = false;
    ListBehavior forceListBehavior = listBehavior;
    switch (queryType) {
      case QueryType.clear:
        {
          needRealQuery = false;
          forceListBehavior = ListBehavior.replace;
        }
      case QueryType.forceQuery:
        {
          needRealQuery = true;
        }
      case QueryType.queryIfNeed:
        {
          bool guiActive = hasActiveUIComponent();
          if (guiActive) {
            needRealQuery = true;
          } else {
            needRealQuery = false;
          }
        }
    }
    //
    printLog(
        "${getClassName(this)} ~~~~~~~~~~~~> needRealQuery: ${needRealQuery}");
    //
    PageData<ID, ITEM>? pageData;
    DataState dataState = DataState.pending;
    //
    PageableData callingPageable;
    if (needRealQuery) {
      callingPageable =
          pageable ?? __pageable ?? const PageableData(page: 1, pageSize: null);
      //
      ApiResult<PageData<ID, ITEM>?> result;
      try {
        FlutterArtist.codeFlowLogger._addMethodCall(
          isLibCode: false,
          navigate: null,
          ownerClassInstance: this,
          methodName: "callApiQuery",
          parameters: {},
        );
        //
        __refreshQueryingState(isQuerying: true);
        //
        printLog("${getClassName(this)} ~~~~~~~~~~~~> callApiQuery");
        result = await callApiQuery(
          filterCriteria: filterCriteria,
          pageable: callingPageable,
        );
        //
        __refreshQueryingState(isQuerying: false);
      } catch (e, stackTrace) {
        __refreshQueryingState(isQuerying: false);
        //
        _handleError(
          shelf: shelf,
          methodName: "callApiQuery",
          error: e,
          stackTrace: stackTrace,
          showSnackBar: true,
        );
        //
        return false;
      }
      if (result.errorMessage != null) {
        _handleRestError(
          shelf: shelf,
          methodName: "callApiQuery",
          message: result.errorMessage!,
          errorDetails: result.errorDetails,
          showSnackBar: true,
        );
        return false;
      }
      pageData = result.data;
      dataState = DataState.ready;

      printLog(
          "${getClassName(this)} ~~~~~~~~~~~~> callApiQuery/itemCount = ${pageData?.items.length}");
    }
    // needRealQuery = false
    else {
      forceListBehavior = ListBehavior.replace;
      callingPageable = __pageable ??
          const PageableData(
            page: 1,
            pageSize: null,
          );
      pageData = DefaultPageData<ID, ITEM>.empty(
        getItemId: getItemId,
      );
      dataState = DataState.pending;
    }
    //
    Object? currentParentItem = parentItemId;
    data._updateFrom(
      forceListBehavior: forceListBehavior,
      currentParentItemId: currentParentItem,
      filterCriteria: filterCriteria,
      pageable: callingPageable,
      pageData: pageData,
      dataState: dataState,
    );
    //
    printLog(
        "${getClassName(this)} ~~~~~~~~~~~~> postQueryBehavior: ${postQueryBehavior}");
    printLog(
        "${getClassName(this)} ~~~~~~~~~~~~> suggestedSelection: ${suggestedSelection}");
    //
    switch (postQueryBehavior) {
      case PostQueryBehavior.selectAvailableItem:
      case PostQueryBehavior.selectAvailableItemToEdit:
        // OLD Current Item
        ITEM? suggestedCurrentItem = data.currentItem;
        if (suggestedSelection != null &&
            suggestedSelection.itemIdToSetAsCurrent != null) {
          suggestedCurrentItem = data.findItemById(
            suggestedSelection.itemIdToSetAsCurrent!,
          );
        }

        ITEM? itemWithSameId = suggestedCurrentItem == null
            ? null
            : data.findItemSameIdWith(item: suggestedCurrentItem);

        //
        printLog(
            "${getClassName(this)} ~~~~~~~~~~~~> itemWithSameId: ${itemWithSameId}");

        if (itemWithSameId == null) {
          // Find first Item...
          ITEM? firstItem = data.firstItem;
          printLog(
              "${getClassName(this)} ~~~~~~~~~~~~> firstItem: ${firstItem}");
          if (firstItem != null) {
            bool success = await __prepareToShowOrEdit(
              thisXBlock: thisXBlock,
              item: firstItem,
              justQueried: true,
              forceForm: postQueryBehavior ==
                  PostQueryBehavior.selectAvailableItemToEdit,
            );
            if (!success) {
              return false;
            }
          } else {
            bool success = await _switchThisAndChildrenToNoneMode(
              thisXBlock: thisXBlock,
              clearListForThis: false,
              dataState: dataState,
            );
            if (!success) {
              return false;
            }
          }
          //
          return true;
        } else {
          printLog(
              "${getClassName(this)} ~~~~~~~~~~~~> __prepareToShowOrEdit($itemWithSameId)");
          bool success = await __prepareToShowOrEdit(
            thisXBlock: thisXBlock,
            item: itemWithSameId,
            justQueried: true,
            forceForm: postQueryBehavior ==
                PostQueryBehavior.selectAvailableItemToEdit,
          );
          if (!success) {
            return false;
          }
          return true;
        }
      case PostQueryBehavior.createNewItem:
        data._queryDataState = DataState.ready;
        // Create New Item
        bool success = await __prepareToCreate(
          thisXBlock: thisXBlock,
          extraFormInput: null,
        );
        if (!success) {
          return false;
        }
        return true;
    }
  }

  // ---------------------------------------------------------------------------
  // ---------------------------------------------------------------------------
  // ---------------------------------------------------------------------------

  ID getItemId(ITEM item);

  ITEM convertItemDetailToItem({required ITEM_DETAIL itemDetail});

  ID? getCurrentItemId() {
    if (data.currentItemDetail == null) {
      return null;
    }
    ITEM item = convertItemDetailToItem(itemDetail: data.currentItemDetail!);
    return getItemId(item);
  }

  ITEM? __convertItemDetailToItem({required ITEM_DETAIL? itemDetail}) {
    return itemDetail == null
        ? null
        : convertItemDetailToItem(itemDetail: itemDetail);
  }

  Object? get parentItemId {
    if (parent == null) {
      return null;
    } else {
      return parent!.getCurrentItemId();
    }
  }

  @nonVirtual
  Block getRootBlock() {
    if (parent == null) {
      return this;
    }
    return parent!.getRootBlock();
  }

  // =============== @@@@@@@@@@@@@@@@@@ ========================================
  // =============== @@@@@@@@@@@@@@@@@@ ========================================
  // =============== @@@@@@@@@@@@@@@@@@ ========================================

  void _backupAllFromRoot() {
    Block rootBlock = getRootBlock();
    rootBlock.__backupThisAndChildren();
  }

  void _restoreAllFromRoot() {
    Block rootBlock = getRootBlock();
    rootBlock.__restoreThisAndChildren();
  }

  void _applyNewStateAllFromRoot() {
    Block rootBlock = getRootBlock();
    rootBlock.__applyNewStateThisAndChildren();
    rootBlock.__setChildrenForParent();
  }

  void __backupThisAndChildren() {
    this.data._backup();
    for (var childBlock in _childBlocks) {
      childBlock.__backupThisAndChildren();
    }
  }

  void __restoreThisAndChildren() {
    this.data._restore();
    this._registeredOrDefaultDataFilter._restore();
    for (var childBlock in _childBlocks) {
      childBlock.__restoreThisAndChildren();
      childBlock._registeredOrDefaultDataFilter._restore();
    }
  }

  void __applyNewStateThisAndChildren() {
    this.data._applyNewState();
    this._registeredOrDefaultDataFilter._applyNewState();
    for (var childBlock in _childBlocks) {
      childBlock.__applyNewStateThisAndChildren();
      childBlock._registeredOrDefaultDataFilter._applyNewState();
    }
  }

  // =============== @@@@@@@@@@@@@@@@@@ ========================================
  // =============== @@@@@@@@@@@@@@@@@@ ========================================
  // =============== @@@@@@@@@@@@@@@@@@ ========================================

  void __setChildrenForParent() {
    try {
      Object? itemParent = parent?.data.currentItemDetail;
      if (itemParent != null && data.queryDataState == DataState.ready) {
        setChildrenForParent(
          currentItemOfParentBlock: itemParent,
          items: data.items,
        );
      }
    } catch (e, stackTrace) {
      print(stackTrace);
    }
    for (var childBlock in _childBlocks) {
      childBlock.__setChildrenForParent();
    }
  }

  // @canOverride
  void setChildrenForParent({
    required Object currentItemOfParentBlock,
    required List<ITEM> items,
  }) {
    // Override if need.
  }

// =============== @@@@@@@@@@@@@@@@@@ ========================================
// =============== @@@@@@@@@@@@@@@@@@ ========================================
// =============== @@@@@@@@@@@@@@@@@@ ========================================

  void __setCurrentItem({
    required ITEM? item,
    required ITEM_DETAIL? itemDetail,
  }) {
    data._setCurrentItemOnly(
      refreshedItemDetail: itemDetail,
      refreshedItem: item,
    );
  }

  ///
  /// Remove this item from Interface because it no longer exists on the server
  ///
  void __removeItemFromList({required ITEM removeItem}) {
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
    data._removeItem(
      removeItem: removeItem,
    );
    this.updateBlockFragmentWidgets();
  }

  // Private Method. Only for use in this class.
  @Deprecated("Xoa di, khong su dung nua")
  Future<bool> __removeNotFoundItemAndSelectSibling({
    required _XBlock thisXBlock,
    SuggestedSelection? suggestedSelection,
    required ITEM notFoundItem,
  }) async {
    FlutterArtist.codeFlowLogger._addMethodCall(
      isLibCode: true,
      navigate: null,
      ownerClassInstance: this,
      methodName: "__removeNotFoundItemAndRefreshChildren",
      parameters: {
        "suggestedSelection": suggestedSelection,
        "notFoundItem": notFoundItem,
      },
    );
    //
    final ITEM? siblingItem = data.findSiblingItem(
      item: notFoundItem,
    );
    //
    __removeItemFromList(removeItem: notFoundItem);
    //
    if (siblingItem != null) {
      FlutterArtist.codeFlowLogger._addInfo(
        isLibCode: true,
        ownerClassInstance: this,
        info: "Selecting sibling item",
      );
      //
      bool success = await __prepareToShowOrEdit(
        thisXBlock: thisXBlock,
        justQueried: false,
        item: siblingItem,
        forceForm: false,
      );
      if (!success) {
        return false;
      }
    } else {
      FlutterArtist.codeFlowLogger._addInfo(
        isLibCode: true,
        ownerClassInstance: this,
        info: "Switching block to none-mode",
      );
      //
      bool success = await _switchThisAndChildrenToNoneMode(
        thisXBlock: thisXBlock,
        clearListForThis: false,
        dataState: DataState.ready,
      );
      if (!success) {
        return false;
      }
    }
    //
    return true;
  }

  @Deprecated("Khong su dung nua")
  Future<bool> __insertOrReplaceItemInListAndRefreshChildren({
    required _XBlock thisXBlock,
    required ITEM_DETAIL refreshedItemDetail,
    required bool forceForm,
  }) async {
    __assertThisXBlock(thisXBlock);
    //
    FlutterArtist.codeFlowLogger._addMethodCall(
      isLibCode: true,
      navigate: null,
      ownerClassInstance: this,
      methodName: "__insertOrReplaceItemInListAndRefreshChildren",
      parameters: {
        "refreshedItemDetail": refreshedItemDetail,
        "forceForm": forceForm,
      },
    );
    //
    ITEM refreshedItem = convertItemDetailToItem(
      itemDetail: refreshedItemDetail,
    );
    data._insertOrReplaceItem(
      item: refreshedItem,
      itemDetail: refreshedItemDetail,
    );
    //
    bool editable = canEditItemOnForm(item: refreshedItem);
    //
    FlutterArtist.codeFlowLogger._addInfo(
      ownerClassInstance: this,
      info: 'Allow Edit? $editable',
      isLibCode: true,
    );
    //
    this.__setCurrentItem(
      itemDetail: refreshedItemDetail,
      item: refreshedItem,
    );
    //
    if (blockForm != null) {
      blockForm!.data._setCurrentItem(
        refreshedItemDetail: refreshedItemDetail,
        formMode: FormMode.edit,
        dataState: DataState.pending,
      );
      bool success = await blockForm!._prepareForm_OLD(
        extraFormInput: null,
        refreshedItem: refreshedItemDetail,
        isNew: false,
        forceForm: forceForm,
      );
      if (!success) {
        return false;
      }
    }
    //
    for (_XBlock childXBlock in thisXBlock.childXBlocks) {
      SuggestedSelection? childSelectionDirective = childXBlock
          .suggestedSelection
          ?.findChildDirective(childXBlock.block.name);
      childXBlock.suggestedSelection = childSelectionDirective; //(@@@)
      //
      bool success = await childXBlock.block._queryThisAndChildren(
        thisXBlock: childXBlock,
      );
      if (!success) {
        return false;
      }
    }
    //
    return true;
  }

  Future<bool> _switchThisAndChildrenToNoneMode({
    required _XBlock thisXBlock,
    required bool clearListForThis,
    required DataState dataState,
  }) async {
    FlutterArtist.codeFlowLogger._addMethodCall(
      isLibCode: true,
      navigate: null,
      ownerClassInstance: this,
      methodName: "_switchThisAndChildrenToNoneMode",
      parameters: {
        "clearListForThis": clearListForThis,
        "dataState": dataState,
      },
    );
    printLog(
        "${getClassName(this)} ~~~~~~~~~~~~> _switchThisAndChildrenToNoneMode");
    //
    if (clearListForThis) {
      //
      // Apply "DataFilter._filterCriteria" for this Block.
      //
      final FILTER_CRITERIA? criteriaOfThisDataFilter =
          this._registeredOrDefaultDataFilter._filterCriteria;
      //
      PageData<ID, ITEM> emptyAppPage =
          DefaultPageData.empty(getItemId: getItemId);
      Object? currentParentItem = parentItemId;

      data._updateFrom(
        currentParentItemId: currentParentItem,
        filterCriteria: criteriaOfThisDataFilter,
        forceListBehavior: ListBehavior.replace,
        pageable: __pageable,
        pageData: emptyAppPage,
        dataState: dataState,
      );
    }

    const ITEM? nullItem = null;
    const ITEM_DETAIL? nullItemDetail = null;
    __setCurrentItem(
      itemDetail: nullItemDetail,
      item: nullItem,
    );
    //
    if (blockForm != null) {
      blockForm!.data._setCurrentItem(
        refreshedItemDetail: nullItemDetail,
        formMode: FormMode.none,
        dataState: DataState.ready,
      );
      bool success = await blockForm!._prepareFormNull();
      if (!success) {
        return false;
      }
    }
    //
    for (_XBlock childXBlock in thisXBlock.childXBlocks) {
      final Block childBlock = childXBlock.block;
      bool success = await childBlock._switchThisAndChildrenToNoneMode(
        thisXBlock: childXBlock,
        clearListForThis: true,
        dataState: dataState,
      );
      if (!success) {
        return false;
      }
    }
    return true;
  }

  // =============== @@@@@@@@@@@@@@@@@@ ========================================
  // =============== @@@@@@@@@@@@@@@@@@ ========================================
  // =============== @@@@@@@@@@@@@@@@@@ ========================================

  Future<bool> _executeQuickChildBlockItemsWithOverlayAndRestorable({
    required QuickChildBlockItemsAction<ITEM, ITEM_DETAIL> action,
  }) async {
    return await FlutterArtist.executeTask(
      asyncFunction: () async {
        return await __executeQuickChildBlockItemsActionWithRestorable(
          action: action,
        );
      },
    );
  }

  @Deprecated("Xoa di, khong su dung nua")
  Future<bool> __executeQuickChildBlockItemsActionWithRestorable({
    required QuickChildBlockItemsAction<ITEM, ITEM_DETAIL> action,
  }) async {
    _XShelf xShelf = _XShelf(
      shelf: shelf,
      forceDataFilterOpt: null,
      forceQueryScalarOpts: [],
      forceQueryBlockOpts: [],
      forceQueryBlockFormOpts: [],
    );
    //
    _XBlock thisXBlock = xShelf.findXBlockByName(name)!;
    //
    try {
      shelf._backupAll();
      bool success = await __executeQuickChildBlockItemsAction(
        thisXBlock: thisXBlock,
        action: action,
      );
      if (success) {
        shelf._applyNewStateAll();
      } else {
        shelf._restoreAll();
      }
      return success;
    } catch (e, stackTrace) {
      shelf._restoreAll();
      //
      _handleError(
        shelf: shelf,
        methodName: "__executeQuickActionUpdateItemWithRestorable",
        error: e,
        stackTrace: stackTrace,
        showSnackBar: true,
      );
      //
      return false;
    }
  }

  Future<bool> __executeQuickChildBlockItemsAction({
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
      //
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
    try {
      return await _processSaveActionRestResult_OLD(
        thisXBlock: thisXBlock,
        calledMethodName: "${getClassName(action)}.callApiQuickUpdateItem",
        result: result,
      );
    } catch (e, stackTrace) {
      _handleError(
        shelf: shelf,
        methodName: '_processSaveActionRestResult',
        error: e,
        stackTrace: stackTrace,
        showSnackBar: true,
      );
      //
      return false;
    }
  }

  Future<bool>
      _executeQuickActionWithOverlayAndRestorable<DATA extends Object>({
    required FILTER_INPUT? filterInput,
    required SuggestedSelection? suggestedSelection,
    required QuickAction<DATA> action,
    required AfterBlockQuickAction? afterQuickAction,
    required Function(BuildContext context)? navigate,
  }) async {
    return await FlutterArtist.executeTask(
      asyncFunction: () async {
        bool success = await __executeQuickActionWithRestorable(
          filterInput: filterInput,
          suggestedSelection: suggestedSelection,
          action: action,
          afterQuickAction: afterQuickAction,
        );
        if (success) {
          try {
            BuildContext context = FlutterArtist.adapter.getCurrentContext();
            if (navigate != null && context.mounted) {
              navigate(context);
            }
          } catch (e, stackTrace) {
            print("Error: $e");
            print(stackTrace);
          }
        }
        return success;
      },
    );
  }

  Future<bool> __executeQuickActionWithRestorable<DATA extends Object>({
    required FILTER_INPUT? filterInput,
    required SuggestedSelection? suggestedSelection,
    required QuickAction<DATA> action,
    required AfterBlockQuickAction? afterQuickAction,
  }) async {
    List<_BlockOpt> forceQueryBlockOpts = [];
    switch (afterQuickAction) {
      case null:
      case AfterBlockQuickAction.refreshCurrentItem:
        break;
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
    _XShelf xShelf = _XShelf(
      shelf: shelf,
      forceDataFilterOpt: _DataFilterOpt(
        dataFilter: _registeredOrDefaultDataFilter,
        filterInput: filterInput,
      ),
      forceQueryScalarOpts: [],
      forceQueryBlockOpts: forceQueryBlockOpts,
      forceQueryBlockFormOpts: [],
    );
    //
    try {
      shelf._backupAll();
      //
      _XBlock thisXBlock = xShelf.findXBlockByName(name)!;
      //
      bool success = await __executeQuickAction(
        thisXBlock: thisXBlock,
        action: action,
        afterQuickAction: afterQuickAction,
      );
      if (!success) {
        shelf._restoreAll();
      } else {
        shelf._applyNewStateAll();
      }
      return success;
    } catch (e, stackTrace) {
      shelf._restoreAll();
      //
      _handleError(
        shelf: shelf,
        methodName: "__executeQuickAction",
        error: e,
        stackTrace: stackTrace,
        showSnackBar: true,
      );
      return false;
    }
  }

  Future<bool> __executeQuickAction<DATA extends Object>({
    required _XBlock thisXBlock,
    required QuickAction<DATA> action,
    required AfterBlockQuickAction? afterQuickAction,
  }) async {
    __assertThisXBlock(thisXBlock);
    //
    ApiResult<DATA>? result;
    bool success = false;
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
      //
      if (result != null && result.errorMessage != null) {
        _handleRestError(
          shelf: shelf,
          methodName: "${getClassName(action)}.callApi",
          message: result.errorMessage!,
          errorDetails: result.errorDetails,
          showSnackBar: true,
        );
        success = false;
      } else {
        success = true;
      }
    } catch (e, stackTrace) {
      _handleError(
        shelf: shelf,
        methodName: '${getClassName(action)}.callApi',
        error: e,
        stackTrace: stackTrace,
        showSnackBar: true,
      );
      success = false;
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
      success = false;
    }
    print("Chay vao day 3 - afterQuickAction: $afterQuickAction");
    //
    if (afterQuickAction != null) {
      String methodName = "";
      try {
        bool success = false;
        switch (afterQuickAction) {
          case AfterBlockQuickAction.refreshCurrentItem:
            methodName = "refreshCurrentItem";
            if (!canRefreshCurrentItem()) {
              return true;
            }
            success = await __prepareToShowOrEdit(
              thisXBlock: thisXBlock,
              item: this.data.currentItem!,
              justQueried: false,
              forceForm: false,
            );
          case AfterBlockQuickAction.query:
            methodName = "query";
            thisXBlock.setForceQuery();
            //
            print("Chay vao day 4: $thisXBlock");
            success = await _queryThisAndChildren(
              thisXBlock: thisXBlock,
            );
        }
        return success;
      } catch (e, stackTrace) {
        _handleError(
          shelf: shelf,
          methodName: methodName,
          error: e,
          stackTrace: stackTrace,
          showSnackBar: true,
        );
        return false;
      }
    }
    return true;
  }

  bool hasCurrentItem() {
    return data.currentItemDetail != null;
  }

  // TODO: Xem lai phuong thuc nay. No da duoc goi o dau.
  bool hasCurrentItemAndAllowUpdate() {
    return data.currentItem != null &&
        __isAllowDeleteItem(
          item: data.currentItem!,
        );
  }

  // TODO: Xem lai phuong thuc nay. No da duoc goi o dau.
  bool hasCurrentItemAndAllowDelete() {
    return data.currentItem != null &&
        __isAllowDeleteItem(
          item: data.currentItem!,
        );
  }

  // TODO: Them tham so ITEM.
  bool needToKeepItemInList({
    required FILTER_CRITERIA? filterCriteria,
    required ITEM_DETAIL savedItem,
  });

  @Deprecated("Khong su dung nua")
  Future<bool> _processSaveActionRestResult_OLD({
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
    //
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
        filterCriteria: data.filterCriteria,
        savedItem: savedItemDetail,
      );
    }
    //
    if (savedItemDetail != null && keepInList) {
      bool success = await __insertOrReplaceItemInListAndRefreshChildren(
        thisXBlock: thisXBlock,
        refreshedItemDetail: savedItemDetail,
        forceForm: false,
      );
      if (!success) {
        return false;
      }
      return true;
    }
    // savedItem = null or !keepInList
    else {
      ITEM? savedItem = __convertItemDetailToItem(itemDetail: savedItemDetail);
      final ITEM? removeItem = savedItem ?? data.currentItem;

      if (removeItem != null) {
        bool success = await __removeNotFoundItemAndSelectSibling(
          thisXBlock: thisXBlock,
          notFoundItem: removeItem,
        );
        if (!success) {
          return false;
        }
      }
      return true;
    }
  }

  // =============== @@@@@@@@@@@@@@@@@@ ========================================
  // =============== @@@@@@@@@@@@@@@@@@ ========================================
  // =============== @@@@@@@@@@@@@@@@@@ ========================================

  Future<bool> executeQuickAction<DATA extends Object>({
    FILTER_INPUT? filterInput,
    SuggestedSelection? suggestedSelection,
    required ActionConfirmationType actionConfirmationType,
    required QuickAction<DATA> action,
    required AfterBlockQuickAction? afterQuickAction,
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
        "afterQuickAction": afterQuickAction,
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
    try {
      bool success = await _executeQuickActionWithOverlayAndRestorable(
        filterInput: filterInput,
        suggestedSelection: suggestedSelection,
        action: action,
        afterQuickAction: afterQuickAction,
        navigate: navigate,
      );
      return success;
    } catch (e, stackTrace) {
      _handleError(
        shelf: shelf,
        methodName: "executeQuickAction",
        error: e,
        stackTrace: stackTrace,
        showSnackBar: true,
      );
      //
      shelf.updateAllUIComponents();
      return false;
    }
  }

  // ***************************************************************************
  // ***************************************************************************

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
      forceDataFilterOpt: null,
      forceQueryScalarOpts: [],
      forceQueryBlockOpts: [],
      forceQueryBlockFormOpts: [],
    );
    //
    _XBlock thisXBlock = xShelf.findXBlockByName(this.name)!;
    //
    _TaskUnit taskUnit = _BlockQuickCreateItemTaskUnit(
      xBlock: thisXBlock,
      action: action,
    );
    //
    _taskUnitQueue.addTaskUnit(taskUnit);
    //
    await this.shelf._executeTaskUnitQueue();
    return true;
  }

  // ***************************************************************************
  // ***************************************************************************

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
      forceDataFilterOpt: null,
      forceQueryScalarOpts: [],
      forceQueryBlockOpts: [],
      forceQueryBlockFormOpts: [],
    );
    //
    _XBlock thisXBlock = xShelf.findXBlockByName(this.name)!;
    //
    _TaskUnit taskUnit = _BlockQuickUpdateItemTaskUnit(
      xBlock: thisXBlock,
      action: action,
    );
    //
    _taskUnitQueue.addTaskUnit(taskUnit);
    //
    await this.shelf._executeTaskUnitQueue();
    return true;
  }

  // ***************************************************************************
  // ***************************************************************************

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
    try {
      bool success = await _executeQuickChildBlockItemsWithOverlayAndRestorable(
        action: action,
      );
      return success;
    } catch (e, stackTrace) {
      _handleError(
        shelf: shelf,
        methodName: "executeQuickChildBlockItems",
        error: e,
        stackTrace: stackTrace,
        showSnackBar: true,
      );
      //
      shelf.updateAllUIComponents();
      return false;
    }
  }

  Future<bool> prepareToEditFirstItem({
    Function()? navigate,
  }) async {
    ITEM? nextItem = data.firstItem;
    if (nextItem == null) {
      return false;
    }
    return await prepareToEditItem(
      item: nextItem,
      navigate: navigate,
    );
  }

  Future<bool> prepareToEditNextItem({
    Function()? navigate,
  }) async {
    if (!data.hasNextItem) {
      return false;
    }
    ITEM? nextItem = data.nextSiblingItem;
    if (nextItem == null) {
      return false;
    }
    return await prepareToEditItem(
      item: nextItem,
      navigate: navigate,
    );
  }

  Future<bool> prepareToEditPreviousItem({
    Function()? navigate,
  }) async {
    if (!data.hasPreviousItem) {
      return false;
    }
    ITEM? previousItem = data.previousSiblingItem;
    if (previousItem == null) {
      return false;
    }
    return await prepareToEditItem(
      item: previousItem,
      navigate: navigate,
    );
  }

  Future<bool> prepareToEditItem({
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
    // Allow to prepareForm but disable Form.
    // bool canEdit = __checkBeforeEditItem(item: item, showErrorMessage: true);
    // if (!canEdit) {
    //   return false;
    // }
    //
    bool success = await __prepareToShowOrEditWithOverlayAndRestorable(
      item: item,
      justQueried: false,
      suggestedSelection: null,
      forceForm: true,
    );
    if (success) {
      _executeNavigation(navigate: navigate);
      return true;
    }
    return false;
  }

  Future<bool> prepareToShowFirstItem({
    Function()? navigate,
  }) async {
    ITEM? nextItem = data.firstItem;
    if (nextItem == null) {
      return false;
    }
    return await prepareToShowItem_OLD(
      item: nextItem,
      navigate: navigate,
    );
  }

  Future<bool> prepareToShowNextItem({
    Function()? navigate,
  }) async {
    if (!data.hasNextItem) {
      return false;
    }
    ITEM? nextItem = data.nextSiblingItem;
    if (nextItem == null) {
      return false;
    }
    return await prepareToShowItem_OLD(
      item: nextItem,
      navigate: navigate,
    );
  }

  Future<bool> prepareToShowPreviousItem({
    Function()? navigate,
  }) async {
    if (!data.hasPreviousItem) {
      return false;
    }
    ITEM? previousItem = data.previousSiblingItem;
    if (previousItem == null) {
      return false;
    }
    return await prepareToShowItem_OLD(
      item: previousItem,
      navigate: navigate,
    );
  }

  @Deprecated("Khong su dung nua, xoa di")
  Future<bool> prepareToShowItem_OLD({
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
    bool success = await __prepareToShowOrEditWithOverlayAndRestorable(
      item: item,
      justQueried: false,
      suggestedSelection: null,
      forceForm: false,
    );
    if (success) {
      _executeNavigation(navigate: navigate);
      return true;
    }
    return false;
  }

  Future<bool> __prepareToShowOrEditWithOverlayAndRestorable({
    required SuggestedSelection? suggestedSelection,
    required ITEM item,
    required bool forceForm,
    required bool justQueried,
  }) async {
    return await FlutterArtist.executeTask(
      asyncFunction: () async {
        return await __prepareToShowOrEditWithRestorable(
          suggestedSelection: suggestedSelection,
          item: item,
          forceForm: forceForm,
          justQueried: justQueried,
        );
      },
    );
  }

  Future<bool> __prepareToShowOrEditWithRestorable({
    required SuggestedSelection? suggestedSelection,
    required ITEM item,
    required bool forceForm,
    required bool justQueried,
  }) async {
    _XShelf xShelf = _XShelf(
      shelf: shelf,
      forceDataFilterOpt: null,
      forceQueryScalarOpts: [],
      forceQueryBlockOpts: [],
      forceQueryBlockFormOpts: [],
    );
    //
    _XBlock thisXBlock = xShelf.findXBlockByName(name)!;
    thisXBlock.suggestedSelection = suggestedSelection;
    //
    try {
      shelf._backupAll();
      //
      _XBlock thisXBlock = xShelf.findXBlockByName(name)!;
      bool success = await __prepareToShowOrEdit(
        thisXBlock: thisXBlock,
        item: item,
        justQueried: justQueried,
        forceForm: forceForm,
      );

      if (!success) {
        shelf._restoreAll();
        return false;
      } else {
        shelf._applyNewStateAll();
        //
        return true;
      }
    } catch (e, stackTrace) {
      _handleError(
        shelf: shelf,
        methodName: "prepareToEditItem",
        error: e,
        stackTrace: stackTrace,
        showSnackBar: true,
      );
      //
      shelf._restoreAll();
      return false;
    }
  }

  // Private method (Only for use in this class)
  Future<bool> __prepareToShowOrEdit({
    required _XBlock thisXBlock,
    required ITEM item,
    required bool forceForm,
    required bool justQueried,
  }) async {
    __assertThisXBlock(thisXBlock);

    //
    FlutterArtist.codeFlowLogger._addMethodCall(
      isLibCode: true,
      navigate: null,
      ownerClassInstance: this,
      methodName: "__prepareToShowOrEdit",
      parameters: {
        "item": item,
        "forceForm": forceForm,
        "justQueried": justQueried,
      },
    );
    //
    ITEM_DETAIL refreshedItemDetail;
    if (item is ITEM_DETAIL && justQueried) {
      refreshedItemDetail = item;
    } else {
      ApiResult<ITEM_DETAIL> result;
      try {
        FlutterArtist.codeFlowLogger._addMethodCall(
          isLibCode: false,
          navigate: null,
          ownerClassInstance: this,
          methodName: "callApiRefreshItem",
          parameters: {
            "item": item,
          },
        );
        //
        __refreshRefreshingCurrentItemState(isRefreshingCurrentItem: true);
        //
        result = await callApiRefreshItem(item: item);
        //
        __refreshRefreshingCurrentItemState(isRefreshingCurrentItem: false);
      } catch (e, stackTrace) {
        __refreshRefreshingCurrentItemState(isRefreshingCurrentItem: false);
        //
        _handleError(
          shelf: shelf,
          methodName: "callApiRefreshItem",
          error: e,
          stackTrace: stackTrace,
          showSnackBar: true,
        );
        //
        return false;
      }
      if (result.errorMessage != null) {
        _handleRestError(
          shelf: shelf,
          methodName: "callApiRefreshItem",
          message: result.errorMessage!,
          errorDetails: result.errorDetails,
          showSnackBar: true,
        );
        return false;
      } else {
        if (result.data == null) {
          bool success = await __removeNotFoundItemAndSelectSibling(
            thisXBlock: thisXBlock,
            notFoundItem: item,
          );
          if (!success) {
            return false;
          }
          return true;
        } else {
          refreshedItemDetail = result.data!;
        }
      }
    }
    //
    printLog(
        "${getClassName(this)} ~~~~~~~~~~~~> refreshedItem: $refreshedItemDetail");
    //
    bool success = await __insertOrReplaceItemInListAndRefreshChildren(
      thisXBlock: thisXBlock,
      refreshedItemDetail: refreshedItemDetail,
      forceForm: forceForm,
    );
    printLog("${getClassName(this)} ~~~~~~~~~~~~> success: $success");
    if (!success) {
      return false;
    }
    return true;
  }

  bool __checkBeforeFormCreation({required bool showErrorMessage}) {
    bool canCrete = canCreateItem();
    if (!canCrete) {
      if (showErrorMessage) {
        showErrorSnackBar(
          message:
              "Cannot create new Item on form because some conditions are not met.",
          errorDetails: ["Block: ${getClassName(this)}"],
        );
      }
      return false;
    }
    return true;
  }

  ///
  /// Prepare to create an item in a Form.
  ///
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
      forceDataFilterOpt: null,
      forceQueryScalarOpts: [],
      forceQueryBlockOpts: [],
      forceQueryBlockFormOpts: [],
    );
    _XBlock thisXBlock = xShelf.findXBlockByName(this.name)!;
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
      queryDataState: DataState.ready,
      formDataState: DataState.pending, // ?????
    );
    blockForm!.data._setCurrentItem(
      refreshedItemDetail: nullItemDetail,
      formMode: FormMode.creation,
      dataState: DataState.pending,
    );
    //
    bool success = false;
    try {
      __refreshPreparingFormCreationState(isPreparingFormCreation: true);
      //
      success = await blockForm!._prepareMasterDataAndFormData(
        extraFormInput: extraFormInput,
        filterCriteria: this.data.filterCriteria,
        refreshedItemDetail: nullItemDetail,
        isNew: true,
      );
    } finally {
      __refreshPreparingFormCreationState(isPreparingFormCreation: false);
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

  // Private method. Only for use in this class.
  @Deprecated("Xoa di, khong su dung nua")
  Future<bool> __prepareToCreate({
    required _XBlock thisXBlock,
    required EXTRA_FORM_INPUT? extraFormInput,
  }) async {
    FlutterArtist.codeFlowLogger._addMethodCall(
      isLibCode: true,
      navigate: null,
      ownerClassInstance: this,
      methodName: "__prepareToCreate",
      parameters: {"extraFormInput": extraFormInput},
    );
    //
    if (!__checkBeforeFormCreation(showErrorMessage: false)) {
      return false;
    }
    const ITEM? nullItem = null;
    const ITEM_DETAIL? nullItemDetail = null;
    __setCurrentItem(
      itemDetail: nullItemDetail,
      item: nullItem,
    );
    //
    blockForm!.data._setCurrentItem(
      refreshedItemDetail: nullItemDetail,
      formMode: FormMode.creation,
      dataState: DataState.pending,
    );
    //
    bool success = false;
    try {
      __refreshPreparingFormCreationState(isPreparingFormCreation: true);
      //
      success = await blockForm!._prepareForm_OLD(
        extraFormInput: extraFormInput,
        refreshedItem: nullItemDetail,
        isNew: true,
        forceForm: true,
      );
    } finally {
      __refreshPreparingFormCreationState(isPreparingFormCreation: false);
    }
    if (!success) {
      return false;
    }
    //
    for (_XBlock childXBlock in thisXBlock.childXBlocks) {
      final Block childBlock = childXBlock.block;
      bool success = await childBlock._switchThisAndChildrenToNoneMode(
        thisXBlock: childXBlock,
        clearListForThis: true,
        dataState: DataState.ready,
      );
      if (!success) {
        return false;
      }
    }
    //
    return true;
  }

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
    ITEM? item = data.findItemById(itemId);
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
    if (!canDeleteItem(item: item)) {
      return false;
    }
    bool confirm = await showConfirmDeleteDialog(details: getClassName(item));
    if (!confirm) {
      return false;
    }
    // bool success = await _deleteWithOverlayAndRestorable(item);
    // return success;
    return true;
  }

  // ***************************************************************************
  // ***************************************************************************

  Future<bool> deleteCurrentItem() async {
    FlutterArtist.codeFlowLogger._addMethodCall(
      isLibCode: true,
      navigate: null,
      ownerClassInstance: this,
      methodName: "deleteCurrentItem",
      parameters: {},
    );
    //

    ITEM? currentItem = data.currentItem;
    if (currentItem != null) {
      return deleteItem(item: currentItem);
    }
    return false;
  }

  // ***************************************************************************
  // ***************************************************************************

  Future<bool> deleteItem({
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
    if (!canDeleteItem(item: item)) {
      return false;
    }
    if (ignoreIfItemNotInList) {
      ITEM? it = data.findItemSameIdWith(item: item);
      if (it == null) {
        showErrorSnackBar(
          message: "Ignore deletion because this item is not in the list.",
          errorDetails: ["ignoreIfItemNotInList: true"],
        );
        return false;
      }
    }
    bool confirm = await showConfirmDeleteDialog(details: getClassName(item));
    if (!confirm) {
      return false;
    }
    _XShelf xShelf = _XShelf(
      shelf: shelf,
      forceDataFilterOpt: null,
      forceQueryScalarOpts: [],
      forceQueryBlockOpts: [],
      forceQueryBlockFormOpts: [],
    );
    //
    _XBlock thisXBlock = xShelf.findXBlockByName(name)!;
    _TaskUnit taskUnit = _BlockDeleteItemTaskUnit(
      xBlock: thisXBlock,
      item: item,
    );
    //
    _taskUnitQueue.addTaskUnit(taskUnit);
    //
    await this.shelf._executeTaskUnitQueue();

    return true;
  }

  // ***************************************************************************
  // ***************************************************************************

  ///
  /// Phương thức này được gọi để refresh "currentItem".
  ///
  Future<bool> refreshCurrentItem() async {
    FlutterArtist.codeFlowLogger._addMethodCall(
      isLibCode: true,
      navigate: null,
      ownerClassInstance: this,
      methodName: "refreshCurrentItem",
      parameters: {},
    );
    //
    if (!canRefreshCurrentItem()) {
      return false;
    }
    bool success = await __prepareToShowOrEditWithOverlayAndRestorable(
      item: data.currentItem!,
      justQueried: false,
      suggestedSelection: null,
      forceForm: false,
    );
    return success;
  }

  // ***************************************************************************
  // ************* ITEM SELECTION/CHECK METHOD *********************************
  // ***************************************************************************

  void __updateUIComponentAfterCheckedOrSelected() {
    updateAllUIComponents(withoutFilters: false);
  }

  void toggleCheckItem({
    required ITEM item,
  }) {
    data._toggleCheckItem(item: item);
    __updateUIComponentAfterCheckedOrSelected();
  }

  void toggleSelectItem({
    required ITEM item,
  }) {
    data._toggleSelectItem(item: item);
    __updateUIComponentAfterCheckedOrSelected();
  }

  void setCheckedItem({
    required ITEM item,
    required bool checked,
  }) {
    data._setCheckedItem(item: item, checked: checked);
    __updateUIComponentAfterCheckedOrSelected();
  }

  void setSelectedItem({
    required ITEM item,
    required bool selected,
  }) {
    data._setSelectedItem(item: item, selected: selected);
    __updateUIComponentAfterCheckedOrSelected();
  }

  // -------

  void setCheckedItems({required List<ITEM> items}) {
    data._setCheckedItems(items: items);
    __updateUIComponentAfterCheckedOrSelected();
  }

  void setSelectedItems({required List<ITEM> items}) {
    data._setSelectedItems(items: items);
    __updateUIComponentAfterCheckedOrSelected();
  }

  // -------

  void uncheckAllItems() {
    data._uncheckAllItems();
    __updateUIComponentAfterCheckedOrSelected();
  }

  void checkAllItems() {
    data._checkAllItems();
    __updateUIComponentAfterCheckedOrSelected();
  }

  // -------

  void selectAllItems() {
    data._selectAllItems();
    __updateUIComponentAfterCheckedOrSelected();
  }

  void deselectAllItems() {
    data._deselectAllItems();
    __updateUIComponentAfterCheckedOrSelected();
  }

  // ***************************************************************************
  // ************* API METHOD **************************************************
  // ***************************************************************************

  Future<ApiResult<PageData<ID, ITEM>?>> callApiQuery({
    required FILTER_CRITERIA filterCriteria,
    required PageableData pageable,
  });

  // Developer do not call this method!
  // Call delete instead of
  Future<ApiResult<void>> callApiDeleteItem({required ITEM item});

  Future<ApiResult<ITEM_DETAIL>> callApiRefreshItem({required ITEM item});

  Future<ApiResult<ITEM_DETAIL>> callApiFindItemById({required ID itemId});

  // ***************************************************************************
  // ****** UPDATE UI COMPONENTS ***********************************************
  // ***************************************************************************

  void updateAllUIComponents({required bool withoutFilters}) {
    if (!withoutFilters) {
      dataFilter?.updateAllUIComponents();
    }
    //
    updateBlockFragmentWidgets();
    updatePaginationWidgets();
    updateControlBarWidgets();
    updateControlWidgets();
    //
    blockForm?.updateAllUIComponents();
  }

  void updateBlockFragmentWidgets() {
    for (_RefreshableWidgetState widgetState
        in _blockFragmentWidgetStates.keys) {
      if (widgetState.mounted) {
        widgetState.refreshState();
      }
    }
  }

  void updateControlBarWidgets() {
    for (_RefreshableWidgetState widgetState in _controlBarWidgetStates.keys) {
      if (widgetState.mounted) {
        widgetState.refreshState();
      }
    }
  }

  void updateControlWidgets() {
    for (_RefreshableWidgetState widgetState in _controlWidgetStates.keys) {
      if (widgetState.mounted) {
        widgetState.refreshState();
      }
    }
  }

  void updatePaginationWidgets() {
    for (_RefreshableWidgetState widgetState in _paginationWidgetStates.keys) {
      if (widgetState.mounted) {
        widgetState.refreshState();
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

  ///
  /// Allows querying the block or not according to the application logic.
  ///
  bool isAllowQuery() {
    return true;
  }

  ///
  /// Allows creating a new Item or not according to the application logic.
  ///
  bool isAllowCreateItem() {
    return true;
  }

  ///
  /// Allows edit an Item or not according to the application logic.
  ///
  bool isAllowUpdateItem({required ITEM item}) {
    return true;
  }

  ///
  /// Allows deleting an Item or not according to the application logic.
  ///
  bool isAllowDeleteItem({required ITEM item}) {
    return true;
  }

  bool isAllowUpdateCurrentItem() {
    ITEM? currentItem = data.currentItem;
    if (currentItem == null) {
      return false;
    }
    return isAllowUpdateItem(item: currentItem);
  }

  bool isAllowDeleteCurrentItem() {
    ITEM? currentItem = data.currentItem;
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
  bool __isAllowQuery() {
    try {
      return isAllowQuery();
    } catch (e, stackTrace) {
      _handleError(
        shelf: shelf,
        methodName: "isAllowUpdateItem",
        error: e,
        stackTrace: stackTrace,
        showSnackBar: false,
      );
      return false;
    }
  }

  ///
  /// Allows edit current item or not according to the application logic.
  ///
  bool __isAllowResetForm() {
    return isAllowResetForm();
  }

  ///
  /// Allows edit current item or not according to the application logic.
  ///
  bool __isAllowUpdateItemCurrentItem() {
    ITEM? currentItem = data.currentItem;
    if (currentItem == null) {
      return false;
    }
    return _isAllowUpdateItem(item: currentItem);
  }

  ///
  /// Allows deleting an Item or not according to the application logic.
  ///
  bool _isAllowUpdateItem({required ITEM item}) {
    try {
      return isAllowUpdateItem(item: item);
    } catch (e, stackTrace) {
      _handleError(
        shelf: shelf,
        methodName: "isAllowUpdateItem",
        error: e,
        stackTrace: stackTrace,
        showSnackBar: false,
      );
      return false;
    }
  }

  ///
  /// Allows creating a new Item or not according to the application logic.
  ///
  bool __isAllowCreateItem() {
    try {
      return isAllowCreateItem();
    } catch (e, stackTrace) {
      _handleError(
        shelf: shelf,
        methodName: "isAllowCreateItem",
        error: e,
        stackTrace: stackTrace,
        showSnackBar: false,
      );
      return false;
    }
  }

  ///
  /// Allows deleting an Item or not according to the application logic.
  ///
  bool __isAllowDeleteItem({required ITEM item}) {
    try {
      return isAllowDeleteItem(item: item);
    } catch (e, stackTrace) {
      _handleError(
        shelf: shelf,
        methodName: "isAllowDeleteItem",
        error: e,
        stackTrace: stackTrace,
        showSnackBar: false,
      );
      return false;
    }
  }

  // ***************************************************************************
  // *********** __checkAncestorsSafeXXX() method ******************************
  // ***************************************************************************

  // TODO: Viet chi tiet hon:
  ///
  /// Check if Ancestor Blocks in Safe State to Query in current Block.
  ///
  bool __checkAncestorsSafeToQuery() {
    if (parent == null) {
      return true;
    }
    //
    if (!parent!.hasCurrentItem()) {
      return false;
    }
    //
    if (parent!.blockForm != null) {
      switch (parent!.blockForm!.formMode) {
        case FormMode.none:
        case FormMode.creation:
          return false;
        case FormMode.edit:
          break; // Do nothing
      }
    }
    //
    return parent!.__checkAncestorsSafeToQuery();
  }

  // TODO: Viet chi tiet hon:
  ///
  /// Check if Ancestor Blocks in Safe State to Delete item in current Block.
  ///
  bool __checkAncestorsSafeToDelete(ITEM? item) {
    if (parent == null) {
      return true;
    }
    // TODO: Kiểm tra nếu item là current thì mới cần đk này:
    if (parent!.blockForm != null) {
      switch (parent!.blockForm!.formMode) {
        case FormMode.none:
        case FormMode.creation:
          return false;
        case FormMode.edit:
          break; // Do nothing
      }
    }
    //
    return parent!.__checkAncestorsSafeToDelete(null);
  }

  // TODO: Viet chi tiet hon:
  ///
  /// Check if Ancestor Blocks in Safe State to Create item in current Block.
  ///
  bool __checkAncestorsSafeToCreate() {
    if (parent == null) {
      return true;
    }
    //
    if (parent!.blockForm != null) {
      switch (parent!.blockForm!.formMode) {
        case FormMode.none:
        case FormMode.creation:
          return false;
        case FormMode.edit:
          break; // Do nothing
      }
    }
    //
    return parent!.__checkAncestorsSafeToCreate();
  }

  // TODO: Viet chi tiet hon:
  ///
  /// Check if Ancestor Blocks in Safe State to Edit item in current Block.
  ///
  bool __checkAncestorsSafeToEditItem({required ITEM? item}) {
    if (parent == null) {
      return true;
    }
    if (parent!.blockForm != null) {
      switch (parent!.blockForm!.formMode) {
        case FormMode.none:
        case FormMode.creation:
          return false;
        case FormMode.edit:
          break; // Do nothing
      }
    }
    return parent!.__checkAncestorsSafeToEditItem(item: null);
  }

  // ***************************************************************************
  // *********** __canXXX() method *********************************************
  // ***************************************************************************

  bool __canDeleteItem({required ITEM item, required bool checkAllow}) {
    if (__isDeleting) {
      return false;
    }
    //
    bool ancestorsSafe = __checkAncestorsSafeToDelete(item);
    if (!ancestorsSafe) {
      return false;
    }
    //
    return checkAllow ? __isAllowDeleteItem(item: item) : true;
  }

  bool __canCreateItem({required bool checkAllow}) {
    if (blockForm == null || this.__isPreparingFormCreation) {
      return false;
    }
    bool ancestorSafe = __checkAncestorsSafeToCreate();
    if (!ancestorSafe) {
      return false;
    }
    return checkAllow ? __isAllowCreateItem() : true;
  }

  bool __canResetForm({required bool checkAllow}) {
    if (blockForm == null || !blockForm!.isDirty() || this.__isSaving) {
      return false;
    }
    switch (blockForm!.data._formMode) {
      case FormMode.none:
        return false;
      case FormMode.creation:
        break; // Do nothing.
      case FormMode.edit:
        break; // Do nothing.
    }
    //
    bool allowReset = checkAllow ? __isAllowResetForm() : true;
    //
    if (allowReset) {
      return true;
    }
    return false;
  }

  bool __canSaveForm({required bool checkAllow}) {
    if (blockForm == null || this.__isSaving) {
      return false;
    }
    bool isAllow = false;
    switch (blockForm!.data._formMode) {
      case FormMode.none:
        return false;
      case FormMode.creation:
        isAllow = checkAllow ? __isAllowCreateItem() : true;
        break;
      case FormMode.edit:
        isAllow = checkAllow ? __isAllowUpdateItemCurrentItem() : true;
        break;
    }
    //
    if (isAllow && blockForm!.isDirty()) {
      return true;
    }
    return false;
  }

  bool __canEditItemOnForm({
    required ITEM item,
    required bool checkAllow,
  }) {
    if (blockForm == null || __isSaving) {
      return false;
    }
    //
    bool ancestorsSafe = __checkAncestorsSafeToEditItem(item: item);
    if (!ancestorsSafe) {
      return false;
    }
    switch (blockForm!.data._formMode) {
      case FormMode.none:
        return false;
      case FormMode.creation:
        break; // Do nothing.
      case FormMode.edit:
        break; // Do nothing.
    }
    return checkAllow ? _isAllowUpdateItem(item: item) : true;
  }

  ///
  /// Edit on edit-mode
  /// Edit on creation-mode
  ///
  bool __isEnableFormToModify({required bool checkAllow}) {
    if (blockForm != null) {
      switch (blockForm!.data._formMode) {
        case FormMode.creation:
          return true;
        case FormMode.edit:
          break; // Continue check below.
        case FormMode.none:
          return false;
      }
    }
    if (data.currentItemDetail == null || __isRefreshingCurrentItem) {
      return false;
    }
    //
    return __canEditItemOnForm(
      item: data.currentItem!,
      checkAllow: checkAllow,
    );
  }

  bool __canRefreshCurrentItem() {
    if (data.currentItemDetail == null || __isRefreshingCurrentItem) {
      return false;
    }
    //
    if (blockForm != null) {
      switch (blockForm!.data._formMode) {
        case FormMode.none:
        case FormMode.creation:
          return false;
        case FormMode.edit:
          break; // Do nothing
      }
    }
    //
    return true;
  }

  // ***************************************************************************
  // *********** canXXX() method ***********************************************
  // ***************************************************************************

  bool isValidState() {
    switch (queryDataState) {
      case DataState.pending:
        return false;
      case DataState.error:
        return false;
      case DataState.ready:
        break; // Continue checking.
    }
    return true;
  }

  bool canCreateItem() {
    return __canCreateItem(checkAllow: true);
  }

  bool canResetForm() {
    return __canResetForm(checkAllow: true);
  }

  bool canSaveForm() {
    return __canSaveForm(checkAllow: true);
  }

  bool canDeleteCurrentItem() {
    ITEM? currentItem = data.currentItem;
    if (currentItem == null) {
      return false;
    }
    return canDeleteItem(item: currentItem);
  }

  bool canDeleteItem({required ITEM item}) {
    return __canDeleteItem(item: item, checkAllow: true);
  }

  bool canEditItemOnForm({required ITEM item}) {
    return __canEditItemOnForm(item: item, checkAllow: true);
  }

  bool _isEnableFormToModify() {
    return __isEnableFormToModify(checkAllow: true);
  }

  bool canEditCurrentItemOnForm() {
    return __isEnableFormToModify(checkAllow: true);
  }

  ///
  /// Checks whether the current item can be refreshed.
  ///
  /// This method will return [true] if all the usual conditions are met.
  ///
  bool canRefreshCurrentItem() {
    return __canRefreshCurrentItem();
  }

  bool canShowFilterCriteria() {
    ILoggedInUser? loggedInUser = FlutterArtist.loggedInUser;
    return dataFilter != null &&
        loggedInUser != null &&
        loggedInUser.isSystemUser;
  }

  bool canShowFormInfo() {
    ILoggedInUser? loggedInUser = FlutterArtist.loggedInUser;
    return blockForm != null &&
        loggedInUser != null &&
        loggedInUser.isSystemUser;
  }

  bool __canQuery({required bool checkAllow}) {
    if (__isQuerying) {
      return false;
    }
    bool ancestorsSafe = __checkAncestorsSafeToQuery();
    if (!ancestorsSafe) {
      return false;
    }
    return checkAllow ? __isAllowQuery() : true;
  }

  bool canQuery() {
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
