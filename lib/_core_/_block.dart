part of '../flutter_artist.dart';

///
/// Block example:
/// ```dart
/// class EmployeeBlock
///       extends Block<int, EmployeeInfo, EmployeeData,
///                     EmptyFilerInput, EmptyFilterCriteria, EmptyExtraInput> {
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
/// [EXTRA_INPUT]: Additional form data are used to create a record in the Form.
/// For example: Create an employee with the specified department.
/// ```
/// class EmployeeExtraInput extends ExtraInput {
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
    EXTRA_INPUT extends ExtraInput // EmptyExtraInput
    > extends _XBase {
  late final Shelf shelf;

  @Deprecated("Xoa di, khong su dung")
  QueryMode _queryMode = QueryMode.lazy;

  @Deprecated("Xoa di, khong su dung")
  late QueryMode _tempQueryMode = _queryMode;

  QueryMode get queryMode => _queryMode;

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
        "${getFilterInputTypeAsString()}, ${getFilterCriteriaTypeAsString()}, ${getExtraInputTypeAsString()}>";
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

  final BlockForm<ID, ITEM, ITEM_DETAIL, FILTER_CRITERIA, EXTRA_INPUT>?
      blockForm;

  final List<Block> _childBlocks;

  List<Block> get childBlocks => [..._childBlocks];

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

  late final BlockData<ID, ITEM, ITEM_DETAIL, FILTER_INPUT, FILTER_CRITERIA,
          EXTRA_INPUT> data =
      _InternalBlockData<ID, ITEM, ITEM_DETAIL, FILTER_INPUT, FILTER_CRITERIA,
          EXTRA_INPUT>.empty(
    this,
    __pageable,
  );

  FormMode get formMode => blockForm?.data._formMode ?? FormMode.none;

  DataState get dataState => data._dataState;

  final Map<_WidgetState, bool> _blockFragmentWidgetStates = {};
  final Map<_WidgetState, bool> _controlBarWidgetStates = {};
  final Map<_WidgetState, bool> _controlWidgetStates = {};
  final Map<_WidgetState, bool> _paginationWidgetStates = {};

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
  })  : registerDataFilterName = dataFilterName,
        __pageSize = pageSize,
        __listenItemTypes = listenItemTypes,
        _childBlocks = childBlocks ?? [] {
    for (Block childBlock in _childBlocks) {
      childBlock.parent = this;
    }
    if (blockForm != null) {
      blockForm!.block = this;
    }
  }

  Type getItemType() {
    return ITEM;
  }

  Type itemDetailType() {
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

  String getExtraInputTypeAsString() {
    return EXTRA_INPUT.toString();
  }

  List<Block> get descendantBlocks {
    List<Block> ret = [];
    for (Block childBlock in _childBlocks) {
      ret.add(childBlock);
      ret.addAll(childBlock.descendantBlocks);
    }
    return ret;
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
    required _WidgetState widgetState,
    required bool isShowing,
  }) {
    _paginationWidgetStates[widgetState] = isShowing;
    if (isShowing) {
      FlutterArtist.storage._addRecentShelf(shelf);
    }
  }

  void _removePaginationWidgetState({
    required _WidgetState widgetState,
  }) {
    _paginationWidgetStates.remove(widgetState);
  }

  void _addControlBarWidgetState({
    required _WidgetState widgetState,
    required bool isShowing,
  }) {
    _controlBarWidgetStates[widgetState] = isShowing;
    if (isShowing) {
      FlutterArtist.storage._addRecentShelf(shelf);
    }
  }

  void _removeControlBarWidgetState({
    required _WidgetState widgetState,
  }) {
    _controlBarWidgetStates.remove(widgetState);
  }

  void _addControlWidgetState({
    required _WidgetState widgetState,
    required bool isShowing,
  }) {
    _controlWidgetStates[widgetState] = isShowing;
    if (isShowing) {
      FlutterArtist.storage._addRecentShelf(shelf);
    }
  }

  void _removeControlWidgetState({
    required _WidgetState widgetState,
  }) {
    _controlWidgetStates.remove(widgetState);
  }

  void _addBlockFragmentWidgetState({
    required _WidgetState widgetState,
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

  Map<_WidgetState, bool> _findMountedWidgetStates({
    required bool withPagination,
    required bool withBlockFragment,
    required bool withFilter,
    required bool withForm,
    required bool withControl,
    required bool withControlBar,
    required bool activeOnly,
  }) {
    Map<_WidgetState, bool> ret = {};
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
    for (_WidgetState controlBarState in _controlBarWidgetStates.keys) {
      bool visible = _controlBarWidgetStates[controlBarState] ?? false;
      if (visible && controlBarState.mounted) {
        return true;
      }
    }
    return false;
  }

  bool hasActiveControlWidget() {
    for (_WidgetState controlState in _controlWidgetStates.keys) {
      bool visible = _controlWidgetStates[controlState] ?? false;
      if (visible && controlState.mounted) {
        return true;
      }
    }
    return false;
  }

  bool hasActivePaginationWidget() {
    for (_WidgetState paginationState in _paginationWidgetStates.keys) {
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
  ///
  ///
  @nonVirtual
  Future<bool> query({
    ListBehavior listBehavior = ListBehavior.replace,
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
          suggestedSelection: suggestedSelection,
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
  Future<bool> _queryThisAndChildren({
    required _XBlock thisXBlock,
  }) async {
    __assertThisXBlock(thisXBlock);
    //
    if (!thisXBlock.needQuery) {
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
      // May throw _TransactionError:
      //
      _FilterCriteriaWrapper result = await dataFilter._prepareData(
        filterInput: filterInput,
      );
      filterCriteria = result.filterCriteria as FILTER_CRITERIA;
      dataFilter._filterCriteria = filterCriteria;
      xDataFilter.queried = true;
    } else {
      filterCriteria = dataFilter._filterCriteria! as FILTER_CRITERIA;
    }
    printLog(
        "${getClassName(this)} ~~~~~~~~~~~~> filterCriteria: ${filterCriteria}");
    //
    final QueryType queryType = thisXBlock.queryType;
    final ListBehavior listBehavior = thisXBlock.listBehavior;
    final PostQueryBehavior postQueryBehavior = thisXBlock.postQueryBehavior;
    final SuggestedSelection? suggestedSelection =
        thisXBlock.suggestedSelection;
    final PageableData? pageable = thisXBlock.pageable;
    //
    printLog(
        "${getClassName(this)} ~~~~~~~~~~~~> needQuery: ${thisXBlock.needQuery} - queryType: ${queryType}");
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
    PageData<ITEM>? pageData;
    DataState dataState = DataState.pending;
    //
    PageableData callingPageable;
    if (needRealQuery) {
      callingPageable =
          pageable ?? __pageable ?? const PageableData(page: 1, pageSize: null);
      //
      ApiResult<PageData<ITEM>?> result;
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
      pageData = PageData<ITEM>.empty();
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
          ITEM? firstItem = data.findFirstItem();
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
        data._dataState = DataState.ready;
        // Create New Item
        bool success = await __prepareToCreate(
          thisXBlock: thisXBlock,
          extraInput: null,
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
      if (itemParent != null && data.dataState == DataState.ready) {
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
  }

  // Private Method. Only for use in this class.
  Future<bool> __removeNotFoundItemAndRefreshChildren({
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
    final bool isCurrent = data.isCurrentItem(
      item: notFoundItem,
    );
    final ITEM? siblingItem = data.findSiblingItem(
      item: notFoundItem,
    );
    //
    __removeItemFromList(removeItem: notFoundItem);
    //
    if (isCurrent) {
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
    }
    return true;
  }

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
    ITEM refreshedItem =
        convertItemDetailToItem(itemDetail: refreshedItemDetail);
    data._insertOrReplaceItem(
      item: refreshedItem,
      itemDetail: refreshedItemDetail,
    );
    //
    bool editable = canEditItemOnForm(item: refreshedItemDetail);
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
      bool success = await blockForm!._prepareForm(
        extraInput: null,
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
      childXBlock.suggestedSelection = childSelectionDirective;
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
    //
    if (clearListForThis) {
      //
      // Apply "DataFilter._filterCriteria" for this Block.
      //
      final FILTER_CRITERIA? criteriaOfThisDataFilter =
          this._registeredOrDefaultDataFilter._filterCriteria;
      //
      PageData<ITEM> emptyAppPage = PageData.empty();
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
      bool success = await blockForm!._prepareForm(
        extraInput: null,
        refreshedItem: nullItemDetail,
        isNew: false,
        forceForm: false,
      );
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

  Future<bool> _executeQuickCreateWithOverlayAndRestorable({
    required QuickActionData data,
  }) async {
    return await FlutterArtist.executeTask(
      asyncFunction: () async {
        return await _executeQuickCreateWithRestorable(data: data);
      },
    );
  }

  Future<bool> _executeQuickCreateWithRestorable({
    required QuickActionData data,
  }) async {
    _XShelf xShelf = _XShelf(
      shelf: shelf,
      forceDataFilterOpt: null,
      forceQueryScalarOpts: [],
      forceQueryBlockOpts: _childBlocks
          .map(
            (b) => _BlockOpt(
              block: b,
              queryType: null,
              pageable: null,
              listBehavior: null,
              suggestedSelection: null,
              postQueryBehavior: null,
            ),
          )
          .toList(),
      forceQueryBlockFormOpts: [],
    );
    //
    _XBlock thisXBlock = xShelf.findXBlockByName(name)!;
    //
    try {
      shelf._backupAll();
      //
      bool success = await __executeQuickCreateAction(
        thisXBlock: thisXBlock,
        data: data,
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
        methodName: "__executeQuickCreateAction",
        error: e,
        stackTrace: stackTrace,
        showSnackBar: true,
      );
      return false;
    }
  }

  // Private Method. Only for use in this class.
  Future<bool> __executeQuickCreateAction({
    required _XBlock thisXBlock,
    required QuickActionData data,
  }) async {
    ApiResult<ITEM_DETAIL> result;
    try {
      result = await callApiQuickCreate(data: data);
      FlutterArtist.storage.fireSourceChanged(
        eventBlock: this,
        itemIdString: null,
      );
    } catch (e, stackTrace) {
      _handleError(
        shelf: shelf,
        methodName: 'callApiQuickCreate',
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
        calledMethodName: "callApiQuickCreate",
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

  Future<bool> _executeQuickUpdateWithOverlayAndRestorable({
    required ITEM item,
    required QuickActionData data,
  }) async {
    return await FlutterArtist.executeTask(
      asyncFunction: () async {
        return await __executeQuickUpdateActionWithRestorable(
          item: item,
          data: data,
        );
      },
    );
  }

  Future<bool> __executeQuickUpdateActionWithRestorable({
    required ITEM item,
    required QuickActionData data,
  }) async {
    _XShelf xShelf = _XShelf(
      shelf: shelf,
      forceDataFilterOpt: null,
      forceQueryScalarOpts: [],
      forceQueryBlockOpts: _childBlocks
          .map(
            (b) => _BlockOpt(
              block: b,
              queryType: null,
              pageable: null,
              listBehavior: null,
              suggestedSelection: null,
              postQueryBehavior: null,
            ),
          )
          .toList(),
      forceQueryBlockFormOpts: [],
    );
    //
    _XBlock thisXBlock = xShelf.findXBlockByName(name)!;
    //
    try {
      shelf._backupAll();
      bool success = await __executeQuickUpdateAction(
        thisXBlock: thisXBlock,
        item: item,
        data: data,
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
        methodName: "__executeQuickUpdateActionWithRestorable",
        error: e,
        stackTrace: stackTrace,
        showSnackBar: true,
      );
      //
      return false;
    }
  }

  Future<bool> __executeQuickUpdateAction({
    required _XBlock thisXBlock,
    required ITEM item,
    required QuickActionData data,
  }) async {
    __assertThisXBlock(thisXBlock);
    //
    ApiResult<ITEM_DETAIL> result;
    try {
      result = await callApiQuickUpdate(item: item, data: data);
      FlutterArtist.storage.fireSourceChanged(
        eventBlock: this,
        itemIdString: null,
      );
    } catch (e, stackTrace) {
      _handleError(
        shelf: shelf,
        methodName: 'callApiQuickUpdate',
        error: e,
        stackTrace: stackTrace,
        showSnackBar: true,
      );
      return false;
    }
    //
    try {
      return await _processSaveActionRestResult(
        thisXBlock: thisXBlock,
        calledMethodName: "callApiQuickUpdate",
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

  Future<bool> _executeQuickActionWithOverlayAndRestorable({
    required FILTER_INPUT? filterInput,
    required SuggestedSelection? suggestedSelection,
    required QuickActionData action,
    required AfterQuickAction? afterQuickAction,
  }) async {
    return await FlutterArtist.executeTask(
      asyncFunction: () async {
        bool success = await __executeQuickActionWithRestorable(
          filterInput: filterInput,
          suggestedSelection: suggestedSelection,
          data: action,
          afterQuickAction: afterQuickAction,
        );
        if (success) {
          try {
            BuildContext context = FlutterArtist.adapter.getCurrentContext();
            action.navigate(context);
          } catch (e, stackTrace) {
            print("Error: $e");
            print(stackTrace);
          }
        }
        return success;
      },
    );
  }

  Future<bool> __executeQuickActionWithRestorable({
    required FILTER_INPUT? filterInput,
    required SuggestedSelection? suggestedSelection,
    required QuickActionData data,
    required AfterQuickAction? afterQuickAction,
  }) async {
    _XShelf xShelf = _XShelf(
      shelf: shelf,
      forceDataFilterOpt: _DataFilterOpt(
        dataFilter: _registeredOrDefaultDataFilter,
        filterInput: filterInput,
      ),
      forceQueryScalarOpts: [],
      forceQueryBlockOpts: _childBlocks
          .map(
            (b) => _BlockOpt(
              block: b,
              queryType: null,
              pageable: null,
              listBehavior: null,
              suggestedSelection: null,
              postQueryBehavior: null,
            ),
          )
          .toList(),
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
        data: data,
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

  Future<bool> __executeQuickAction({
    required _XBlock thisXBlock,
    required QuickActionData data,
    required AfterQuickAction? afterQuickAction,
  }) async {
    __assertThisXBlock(thisXBlock);
    //
    ApiResult<void> result;
    try {
      result = await callApiQuickAction(data: data);
      if (result.errorMessage != null) {
        _handleRestError(
          shelf: shelf,
          methodName: "callApiQuickAction",
          message: result.errorMessage!,
          errorDetails: result.errorDetails,
          showSnackBar: true,
        );
        return false;
      } else {
        // Do nothing.
      }
    } catch (e, stackTrace) {
      _handleError(
        shelf: shelf,
        methodName: 'callApiQuickAction',
        error: e,
        stackTrace: stackTrace,
        showSnackBar: true,
      );
      return false;
    }
    if (afterQuickAction != null) {
      String methodName = "";
      try {
        bool success = false;
        switch (afterQuickAction) {
          case AfterQuickAction.refreshCurrentItem:
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
          case AfterQuickAction.query:
            methodName = "query";
            thisXBlock.needQuery = true;
            //
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
  bool hasCurrentItemAndAllowEdit() {
    return data.currentItemDetail != null &&
        _isAllowEdit(
          refreshedItem: data.currentItemDetail!,
        );
  }

  // TODO: Xem lai phuong thuc nay. No da duoc goi o dau.
  bool hasCurrentItemAndAllowDelete() {
    return data.currentItemDetail != null &&
        __isAllowDelete(
          refreshedItem: data.currentItemDetail!,
        );
  }

  bool needToKeepItemInList({
    required FILTER_CRITERIA? filterCriteria,
    required ITEM_DETAIL savedItem,
  });

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
    //
    FlutterArtist.storage.fireSourceChanged(
      eventBlock: this,
      itemIdString: null,
    );
    //
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
        bool success = await __removeNotFoundItemAndRefreshChildren(
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

  ///
  /// This method will call [callApiQuickAction],
  /// so you need to override [callApiQuickAction] method.
  ///
  Future<bool> executeQuickAction({
    FILTER_INPUT? filterInput,
    SuggestedSelection? suggestedSelection,
    required ActionConfirmation? actionConfirmation,
    required QuickActionData action,
    required AfterQuickAction? afterQuickAction,
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
    if (actionConfirmation != null) {
      bool confirm = false;
      BuildContext context = FlutterArtist.adapter.getCurrentContext();
      //
      switch (actionConfirmation.type) {
        case ActionConfirmationType.delete:
          confirm = await dialogs.showConfirmDeleteDialog(
            context: context,
            details: actionConfirmation.details ?? "",
          );
        case ActionConfirmationType.custom:
          confirm = await dialogs.showConfirmDialog(
            context: context,
            message: actionConfirmation.message,
            details: actionConfirmation.details ?? "",
          );
      }
      //
      if (!confirm) {
        return false;
      }
    }
    try {
      bool success = await _executeQuickActionWithOverlayAndRestorable(
        filterInput: filterInput,
        suggestedSelection: suggestedSelection,
        action: action,
        afterQuickAction: afterQuickAction,
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
      return false;
    } finally {
      shelf.updateAllUIComponents();
    }
  }

  Future<bool> executeQuickCreateAction<A extends QuickActionData>({
    required CustomConfirmation<A>? customConfirmation,
    required A action,
  }) async {
    //
    // Confirmation:
    //
    bool confirm = await __showConfirmDialogForAction(
      customConfirmation: customConfirmation,
      action: action,
    );
    if (!confirm) {
      return false;
    }
    //
    try {
      bool success =
          await _executeQuickCreateWithOverlayAndRestorable(data: action);
      shelf.updateAllUIComponents();
      return success;
    } catch (e, stackTrace) {
      _handleError(
        shelf: shelf,
        methodName: 'executeQuickCreateAction',
        error: e,
        stackTrace: stackTrace,
        showSnackBar: true,
      );
      //
      shelf.updateAllUIComponents();
      return false;
    }
  }

  Future<bool> __showDefaultConfirmDialogForAction(
    QuickActionData action,
  ) async {
    return await showConfirmDialog(
      message: 'Are you sure you want to perform this action?',
      details: action.actionInfo,
    );
  }

  Future<bool> __showConfirmDialogForAction<A extends QuickActionData>({
    required A action,
    required CustomConfirmation<A>? customConfirmation,
  }) async {
    if (!action.needToConfirm) {
      return true;
    }
    final CustomConfirmation<A> _confirmForAction =
        customConfirmation ?? __showDefaultConfirmDialogForAction;
    //
    try {
      return await _confirmForAction(action);
    } catch (e, stackTrace) {
      _handleError(
        shelf: shelf,
        methodName: "confirmForAction",
        error: e,
        stackTrace: stackTrace,
        showSnackBar: true,
      );
      return false;
    }
  }

  ///
  /// This method will call [callApiQuickUpdate] method.
  /// So you need to implement [callApiQuickUpdate] method.
  ///
  Future<bool> executeQuickUpdateAction<A extends QuickActionData>({
    required ITEM item,
    required CustomConfirmation<A>? customConfirmation,
    required A action,
  }) async {
    FlutterArtist.codeFlowLogger._addMethodCall(
      isLibCode: true,
      navigate: null,
      ownerClassInstance: this,
      methodName: "executeQuickUpdateAction",
      parameters: {
        "item": item,
        "data": action,
      },
    );
    //
    // Confirmation:
    //
    bool confirm = await __showConfirmDialogForAction(
      customConfirmation: customConfirmation,
      action: action,
    );
    if (!confirm) {
      return false;
    }
    //
    try {
      bool success = await _executeQuickUpdateWithOverlayAndRestorable(
        item: item,
        data: action,
      );
      shelf.updateAllUIComponents();
      return success;
    } catch (e, stackTrace) {
      _handleError(
        shelf: shelf,
        methodName: "quickUpdate",
        error: e,
        stackTrace: stackTrace,
        showSnackBar: true,
      );
      //
      shelf.updateAllUIComponents();
      return false;
    }
  }

  Future<bool> prepareToEdit({
    required ITEM item,
    Function()? navigate,
  }) async {
    FlutterArtist.codeFlowLogger._addMethodCall(
      isLibCode: true,
      navigate: navigate,
      ownerClassInstance: this,
      methodName: "prepareToEdit",
      parameters: {
        "item": item,
      },
    );
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

  Future<bool> prepareToShow({
    required ITEM item,
    Function()? navigate,
  }) async {
    FlutterArtist.codeFlowLogger._addMethodCall(
      isLibCode: true,
      navigate: navigate,
      ownerClassInstance: this,
      methodName: "prepareToShow",
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
      forceQueryBlockOpts: _childBlocks
          .map(
            (b) => _BlockOpt(
              block: b,
              queryType: null,
              pageable: null,
              listBehavior: null,
              suggestedSelection: null,
              postQueryBehavior: null,
            ),
          )
          .toList(),
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
        methodName: "prepareToEdit",
        error: e,
        stackTrace: stackTrace,
        showSnackBar: true,
      );
      //
      shelf._restoreAll();
      return false;
    }
  }

  ///
  /// Kiểm tra xem phần tử này có thực sự tồn tại không trước khi hiển thị nó trên giao diện.
  /// Trả về false nếu phần tử này không còn tồn tại trên máy chủ hoặc lỗi.
  ///
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
    ITEM_DETAIL refreshedItem;
    if (item is ITEM_DETAIL && justQueried) {
      refreshedItem = item;
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
          bool success = await __removeNotFoundItemAndRefreshChildren(
            thisXBlock: thisXBlock,
            notFoundItem: item,
          );
          if (!success) {
            return false;
          }
          return true;
        } else {
          refreshedItem = result.data!;
        }
      }
    }
    //
    printLog(
        "${getClassName(this)} ~~~~~~~~~~~~> refreshedItem: $refreshedItem");
    //
    bool success = await __insertOrReplaceItemInListAndRefreshChildren(
      thisXBlock: thisXBlock,
      refreshedItemDetail: refreshedItem,
      forceForm: forceForm,
    );
    printLog("${getClassName(this)} ~~~~~~~~~~~~> success: $success");
    if (!success) {
      return false;
    }
    return true;
  }

  bool __checkBeforeFormCreation({required bool showErrorMessage}) {
    if (blockForm == null) {
      if (showErrorMessage) {
        String msg = "${getClassName(this)} has no BlockForm";
        showErrorSnackBar(message: msg, errorDetails: null);
      }
      return false;
    }
    return true;
  }

  ///
  /// Prepare to create an item in a Form.
  ///
  Future<bool> prepareToCreate({
    EXTRA_INPUT? extraInput,
    required Function()? navigate,
  }) async {
    FlutterArtist.codeFlowLogger._addMethodCall(
      isLibCode: true,
      navigate: navigate,
      ownerClassInstance: this,
      methodName: "prepareToCreate",
      parameters: {"extraInput": extraInput},
    );
    //
    if (!__checkBeforeFormCreation(showErrorMessage: true)) {
      return false;
    }
    //
    extraInput?.formAction = FormAction.create;
    //
    bool success = await _prepareToCreateWithOverlayAndRestorable(
      extraInput: extraInput,
    );
    //
    if (success) {
      _executeNavigation(navigate: navigate);
    }
    return success;
  }

  Future<bool> _prepareToCreateWithOverlayAndRestorable({
    required EXTRA_INPUT? extraInput,
  }) async {
    if (!__checkBeforeFormCreation(showErrorMessage: false)) {
      return false;
    }
    return await FlutterArtist.executeTask(
      asyncFunction: () async {
        return await _prepareToCreateWithRestorable(
          extraInput: extraInput,
        );
      },
    );
  }

  Future<bool> _prepareToCreateWithRestorable({
    required EXTRA_INPUT? extraInput,
  }) async {
    if (!__checkBeforeFormCreation(showErrorMessage: false)) {
      return false;
    }
    _XShelf xShelf = _XShelf(
      shelf: shelf,
      forceDataFilterOpt: null,
      forceQueryScalarOpts: [],
      forceQueryBlockOpts: _childBlocks
          .map(
            (b) => _BlockOpt(
              block: b,
              queryType: null,
              pageable: null,
              listBehavior: null,
              suggestedSelection: null,
              postQueryBehavior: null,
            ),
          )
          .toList(),
      forceQueryBlockFormOpts: [],
    );
    //
    _XBlock thisXBlock = xShelf.findXBlockByName(name)!;
    //
    try {
      _backupAllFromRoot();
      //
      bool success = await __prepareToCreate(
        thisXBlock: thisXBlock,
        extraInput: extraInput,
      );
      if (!success) {
        _restoreAllFromRoot();
        return false;
      } else {
        _applyNewStateAllFromRoot();
        return true;
      }
    } catch (e, stackTrace) {
      _handleError(
        shelf: shelf,
        methodName: "prepareToCreate",
        error: e,
        stackTrace: stackTrace,
        showSnackBar: true,
      );
      //
      _restoreAllFromRoot();
      return false;
    }
  }

  // Private method. Only for use in this class.
  Future<bool> __prepareToCreate({
    required _XBlock thisXBlock,
    required EXTRA_INPUT? extraInput,
  }) async {
    FlutterArtist.codeFlowLogger._addMethodCall(
      isLibCode: true,
      navigate: null,
      ownerClassInstance: this,
      methodName: "__prepareToCreate",
      parameters: {"extraInput": extraInput},
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
      success = await blockForm!._prepareForm(
        extraInput: extraInput,
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
      return delete(currentItem);
    }
    return false;
  }

  Future<bool> showConfirmDialog(
      {required String message, String? details}) async {
    BuildContext context = FlutterArtist.adapter.getCurrentContext();
    bool confirm = await dialogs.showConfirmDialog(
      context: context,
      message: message,
      details: details ?? "",
    );
    return confirm;
  }

  Future<bool> showConfirmDeleteDialog({String? details}) async {
    BuildContext context = FlutterArtist.adapter.getCurrentContext();
    bool confirm = await dialogs.showConfirmDeleteDialog(
      context: context,
      details: details ?? "",
    );
    return confirm;
  }

  Future<void> showMessageDialog({
    required String message,
    String? detals,
  }) async {
    BuildContext context = FlutterArtist.adapter.getCurrentContext();
    await dialogs.showMessageDialog(
      context: context,
      message: message,
      details: detals ?? "",
    );
  }

  Future<bool> deleteItemById({required ID itemId}) async {
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
    final bool inList = item != null;
    //
    if (item == null) {
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
    bool success = await _deleteWithOverlayAndRestorable(item);
    return success;
  }

  Future<bool> delete(ITEM item) async {
    FlutterArtist.codeFlowLogger._addMethodCall(
      isLibCode: true,
      navigate: null,
      ownerClassInstance: this,
      methodName: "delete",
      parameters: {
        "item": item,
      },
    );
    //
    if (!canDeleteItem(item: item)) {
      return false;
    }
    bool confirm = await showConfirmDeleteDialog(details: getClassName(item));
    if (!confirm) {
      return false;
    }
    bool success = await _deleteWithOverlayAndRestorable(item);
    return success;
  }

  Future<bool> _deleteWithOverlayAndRestorable(ITEM item) async {
    return await FlutterArtist.executeTask(
      asyncFunction: () async {
        return await _deleteWithRestorable(item);
      },
    );
  }

  Future<bool> _deleteWithRestorable(ITEM item) async {
    _XShelf xShelf = _XShelf(
      shelf: shelf,
      forceDataFilterOpt: null,
      forceQueryScalarOpts: [],
      forceQueryBlockOpts: _childBlocks
          .map(
            (b) => _BlockOpt(
              block: b,
              queryType: null,
              pageable: null,
              listBehavior: null,
              suggestedSelection: null,
              postQueryBehavior: null,
            ),
          )
          .toList(),
      forceQueryBlockFormOpts: [],
    );
    //
    _XBlock thisXBlock = xShelf.findXBlockByName(name)!;
    //
    try {
      shelf._backupAll();
      bool success = await __deleteItem(
        thisXBlock: thisXBlock,
        item: item,
      );

      if (!success) {
        shelf._restoreAll();
      } else {
        shelf._applyNewStateAll();
      }
      return success;
    } catch (e, stackTrace) {
      _handleError(
        shelf: shelf,
        methodName: "delete",
        error: e,
        stackTrace: stackTrace,
        showSnackBar: true,
      );
      //
      shelf._restoreAll();
      return false;
    }
  }

  // Private method. Only for use in this class only.
  Future<bool> __deleteItem({
    required _XBlock thisXBlock,
    required ITEM item,
  }) async {
    try {
      final bool isCurrent = data.isCurrentItem(item: item);

      if (isCurrent && blockForm?.data._formMode == FormMode.creation) {
        return false;
      }
      if (blockForm?.data._formMode == FormMode.none) {
        // return false;
      }
      ApiResult<void> result;
      try {
        FlutterArtist.codeFlowLogger._addMethodCall(
          isLibCode: false,
          navigate: null,
          ownerClassInstance: this,
          methodName: "callApiDelete",
          parameters: {
            "item": item,
          },
        );
        //
        __refreshDeletingState(isDeleting: true);
        //
        result = await callApiDelete(item: item);
        FlutterArtist.storage.fireSourceChanged(
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
          methodName: "callApiDelete",
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
          methodName: "callApiDelete",
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

  void setCheckedItem(ITEM item) {
    data._setCheckedItem(item);
    __updateUIComponentAfterCheckedOrSelected();
  }

  // TODO: Kiểm tra nếu chưa có current thì sét thành current.
  void setSelectedItem(ITEM item) {
    data._setSelectedItem(item);
    __updateUIComponentAfterCheckedOrSelected();
  }

  // -------

  void setCheckedItems(List<ITEM> items) {
    data._setCheckedItems(items);
    __updateUIComponentAfterCheckedOrSelected();
  }

  // TODO: Kiểm tra nếu chưa có current thì sét thành current.
  void setSelectedItems(List<ITEM> items) {
    data._setSelectedItems(items);
    __updateUIComponentAfterCheckedOrSelected();
  }

  // -------

  void addCheckedItem(ITEM item) {
    data._addCheckedItem(item);
    __updateUIComponentAfterCheckedOrSelected();
  }

  // TODO: Kiểm tra nếu chưa có current thì sét thành current.
  void addSelectedItem(ITEM item) {
    data._addSelectedItem(item);
    __updateUIComponentAfterCheckedOrSelected();
  }

  // -------

  void addCheckedItems(List<ITEM> items) {
    data._addCheckedItems(items);
    __updateUIComponentAfterCheckedOrSelected();
  }

  // TODO: Kiểm tra nếu chưa có current thì sét thành current.
  void addSelectedItems(List<ITEM> items) {
    data._addSelectedItems(items);
    __updateUIComponentAfterCheckedOrSelected();
  }

  // -------

  void uncheckItem(ITEM item) {
    data._uncheckItem(item);
    __updateUIComponentAfterCheckedOrSelected();
  }

  // TODO: Kiểm tra nếu nếu đang là currentItem thì setCurrent null.
  void deselectItem(ITEM item) {
    data._deselectItemItems(item);
    __updateUIComponentAfterCheckedOrSelected();
  }

  // -------

  void uncheckAllItems() {
    data._uncheckAllItems();
    __updateUIComponentAfterCheckedOrSelected();
  }

  // TODO: Kiểm tra nếu có current thì set current null.
  void deselectAllItems() {
    data._deselectAll();
    __updateUIComponentAfterCheckedOrSelected();
  }

  // -------

  void checkAllItems() {
    data._checkAllItems();
    __updateUIComponentAfterCheckedOrSelected();
  }

  // TODO: Kiểm tra nếu chưa có current thì sét thành current.
  void selectAllItems() {
    data._selectAllItems();
    __updateUIComponentAfterCheckedOrSelected();
  }

  // ***************************************************************************
  // ************* API METHOD **************************************************
  // ***************************************************************************

  ///
  /// This method is called when you can [executeQuickUpdateAction] method.
  ///
  /// ```dart
  /// Future<ApiResult<D>> callApiQuickUpdate({
  ///     required I item,
  ///     required QuickActionData data,
  /// }) {
  ///     if(data is SomeAction1) {
  ///        // Do stuff
  ///     } else if(data is SomeAction2) {
  ///        // Do stuff
  ///     }
  /// }
  /// ```
  ///
  Future<ApiResult<ITEM_DETAIL>> callApiQuickUpdate({
    required ITEM item,
    required QuickActionData data,
  }) async {
    throw UnimplementedError("Override me!");
  }

  ///
  /// This method is called when you can [executeQuickCreateAction] method.
  /// ```dart
  /// Future<ApiResult<D>> callApiQuickCreate({
  ///     required QuickActionData data,
  /// }) {
  ///     if(data is SomeAction1) {
  ///        // Do stuff
  ///     } else if(data is SomeAction2) {
  ///        // Do stuff
  ///     }
  /// }
  /// ```
  ///
  Future<ApiResult<ITEM_DETAIL>> callApiQuickCreate({
    required QuickActionData data,
  }) async {
    throw UnimplementedError("Override me!");
  }

  Future<ApiResult<void>> callApiQuickAction({
    required QuickActionData data,
  }) async {
    throw UnimplementedError("Override me!");
  }

  Future<ApiResult<PageData<ITEM>?>> callApiQuery({
    required FILTER_CRITERIA filterCriteria,
    required PageableData pageable,
  });

  // Developer do not call this method!
  // Call delete instead of
  Future<ApiResult<void>> callApiDelete({required ITEM item});

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
    for (_WidgetState widgetState in _blockFragmentWidgetStates.keys) {
      if (widgetState.mounted) {
        widgetState.refreshState();
      }
    }
  }

  void updateControlBarWidgets() {
    for (_WidgetState widgetState in _controlBarWidgetStates.keys) {
      if (widgetState.mounted) {
        widgetState.refreshState();
      }
    }
  }

  void updateControlWidgets() {
    for (_WidgetState widgetState in _controlWidgetStates.keys) {
      if (widgetState.mounted) {
        widgetState.refreshState();
      }
    }
  }

  void updatePaginationWidgets() {
    for (_WidgetState widgetState in _paginationWidgetStates.keys) {
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
  bool isAllowCreate() {
    return true;
  }

  ///
  /// Allows edit an Item or not according to the application logic.
  ///
  bool isAllowEdit({required ITEM_DETAIL refreshedItem}) {
    return true;
  }

  ///
  /// Allows deleting an Item or not according to the application logic.
  ///
  bool isAllowDelete({required ITEM_DETAIL refreshedItem}) {
    return true;
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
        methodName: "isAllowEdit",
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
  bool __isAllowEditCurrentItem() {
    ITEM_DETAIL? currentItem = data.currentItemDetail;
    if (currentItem == null) {
      return false;
    }
    return _isAllowEdit(refreshedItem: currentItem);
  }

  ///
  /// Allows deleting an Item or not according to the application logic.
  ///
  bool _isAllowEdit({required ITEM_DETAIL refreshedItem}) {
    try {
      return isAllowEdit(refreshedItem: refreshedItem);
    } catch (e, stackTrace) {
      _handleError(
        shelf: shelf,
        methodName: "isAllowEdit",
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
  bool _isAllowCreate() {
    try {
      return isAllowCreate();
    } catch (e, stackTrace) {
      _handleError(
        shelf: shelf,
        methodName: "isAllowCreate",
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
  bool __isAllowDelete({required ITEM_DETAIL refreshedItem}) {
    try {
      return isAllowDelete(refreshedItem: refreshedItem);
    } catch (e, stackTrace) {
      _handleError(
        shelf: shelf,
        methodName: "isAllowDelete",
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
  bool _isAllowDeleteItem({required ITEM item}) {
    final bool isCurrent = data.isCurrentItem(item: item);
    if (!isCurrent) {
      // TODO: Xem lại chỗ này. cần kiểm tra với phương thức isAllowDelete().
      return true;
    } else {
      ITEM_DETAIL? currentItem = data.currentItemDetail;
      if (currentItem == null) {
        return false;
      }
      return __isAllowDelete(refreshedItem: currentItem);
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
    switch (parent!.formMode) {
      case FormMode.none:
      case FormMode.creation:
        return false;
      case FormMode.edit:
        break; // Do nothing
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
      switch (parent!.formMode) {
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
      switch (parent!.formMode) {
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
  bool __checkAncestorsSafeToEditItem({required ITEM_DETAIL? itemDetail}) {
    if (parent == null) {
      return true;
    }
    if (parent!.blockForm != null) {
      switch (parent!.formMode) {
        case FormMode.none:
        case FormMode.creation:
          return false;
        case FormMode.edit:
          break; // Do nothing
      }
    }
    return parent!.__checkAncestorsSafeToEditItem(itemDetail: null);
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
    return checkAllow ? _isAllowDeleteItem(item: item) : true;
  }

  bool __canCreateItem({required bool checkAllow}) {
    if (blockForm == null || this.__isPreparingFormCreation) {
      return false;
    }
    bool ancestorSafe = __checkAncestorsSafeToCreate();
    if (!ancestorSafe) {
      return false;
    }
    return checkAllow ? _isAllowCreate() : true;
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
    switch (blockForm!.data._formMode) {
      case FormMode.none:
        return false;
      case FormMode.creation:
        break; // Do nothing.
      case FormMode.edit:
        break; // Do nothing.
    }
    //
    bool allowEdit =
        checkAllow ? _isAllowCreate() && __isAllowEditCurrentItem() : true;
    //
    if (allowEdit && blockForm!.isDirty()) {
      return true;
    }
    return false;
  }

  bool __canEditItemOnForm({
    required ITEM_DETAIL item,
    required bool checkAllow,
  }) {
    if (blockForm == null || __isSaving) {
      return false;
    }
    //
    bool ancestorsSafe = __checkAncestorsSafeToEditItem(itemDetail: item);
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
    return checkAllow ? _isAllowEdit(refreshedItem: item) : true;
  }

  bool __canEditCurrentItemOnForm({required bool checkAllow}) {
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
      item: data.currentItemDetail!,
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

  // TODO: Đổi sang kiểu ITEM_DETAIL?
  bool canDeleteItem({required ITEM item}) {
    return __canDeleteItem(item: item, checkAllow: true);
  }

  bool canEditItemOnForm({required ITEM_DETAIL item}) {
    return __canEditItemOnForm(item: item, checkAllow: true);
  }

  bool canEditCurrentItemOnForm() {
    return __canEditCurrentItemOnForm(checkAllow: true);
  }

  ///
  /// Checks whether the current item can be refreshed.
  ///
  /// This method will return [true] if all the usual conditions are met.
  ///
  bool canRefreshCurrentItem() {
    return __canRefreshCurrentItem();
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
