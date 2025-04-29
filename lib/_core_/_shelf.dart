part of '../flutter_artist.dart';

abstract class Shelf extends _XBase {
  late final ShelfStructure _shelfStruct;

  String? get description => _shelfStruct.description;

  // All filterModels including the default filterModel.
  final List<FilterModel> _allFilterModels = [];

  List<String> get filterNames => [..._shelfStruct.filterModels.keys];

  // All formModels.
  final List<FormModel> _allFormModels = [];

  final Map<String, Activity> __activityMap = {};

  final List<Activity> __activities = [];

  List<Activity> get activities => [...__activities];

  final Map<String, Scalar> __scalarMap = {};

  final List<Scalar> __scalars = [];

  List<Scalar> get scalars => [...__scalars];

  final Map<String, Block> __blockMap = {};

  final List<Block> __rootBlocks = [];

  bool _isStructError = false;

  String? _structError;

  bool get isStructError => _isStructError;

  String? get structError => _structError;

  List<Block> get rootBlocks => [...__rootBlocks];

  int __lastLazyLoadId = 0;

  int __lazyLoadId = 0;

  final List<Block> __lazyBlocksToQuery = [];

  bool __lazyLoadLocked = false;

  String get name => FlutterArtist.storage._getShelfName(runtimeType);

  final Map<_RefreshableWidgetState, bool> _shelfWidgetStates = {};

  // ***************************************************************************
  // ***************************************************************************

  Shelf() {
    __onInit();
  }

  // ***************************************************************************
  // ***************************************************************************

  ///
  /// Very Dangerous Method. Call Internal only.
  ///
  String ___registerError(String message) {
    FlutterArtist.storage.__clear();
    //
    return "\n*********************************************************************************************\n"
        "$message"
        "\n\n  *** You may need to restart the application after editing the code. ***"
        "\n*********************************************************************************************\n";
  }

  // ***************************************************************************
  // ***************************************************************************

  void __onInit() {
    _shelfStruct = registerStructure();

    for (String filterModelName in _shelfStruct.filterModels.keys) {
      FilterModel filterModel = _shelfStruct.filterModels[filterModelName]!;
      filterModel.name = filterModelName;
      filterModel.shelf = this;
      //
      _allFilterModels.add(filterModel);
    }
    //
    // Activity:
    //
    final List<Activity> activities = _shelfStruct.activities;
    for (Activity activity in activities) {
      if (__activityMap.containsKey(activity.name)) {
        throw ___registerError(
            "Duplicated Activity '${activity.name}' in '${getClassName(this)}'\n"
            "Double-check ${getClassName(this)}.registerStructure() method");
      } else {
        __activityMap[activity.name] = activity;
      }
      activity.shelf = this;
    }
    //
    // Scalar:
    //
    final List<Scalar> scalars = _shelfStruct.scalars;
    for (Scalar scalar in scalars) {
      if (__scalarMap.containsKey(scalar.name)) {
        throw ___registerError(
            "Duplicated Scalar '${scalar.name}' in '${getClassName(this)}'\n"
            "Double-check ${getClassName(this)}.registerStructure() method");
      } else {
        __scalarMap[scalar.name] = scalar;
      }
      scalar.shelf = this;
      __scalars.add(scalar);
      //
      if (scalar.registerFilterModelName != null) {
        FilterModel? filterModel =
            _shelfStruct.filterModels[scalar.registerFilterModelName!];
        if (filterModel == null) {
          throw ___registerError(
              "FilterModel not found '${scalar.registerFilterModelName}' in '${getClassName(this)}'\n"
              "Double-check ${getClassName(this)}.registerStructure() method");
        }
        //
        const Type filterInputType = FilterInput;
        final String filterInputBase = filterInputType.toString();
        final String filterInputBF = filterModel.getFilterInputTypeAsString();
        final String filterInputB = scalar.getFilterInputTypeAsString();
        //
        if (filterInputBF == filterInputBase) {
          throw ___registerError(
              "You need to create your own class that extends the '$filterInputBase' class \n"
              "or use the 'EmptyFilterInput' class to use in the '${getClassName(filterModel)}' declaration \n\n"
              " >> Currently, ${getClassName(filterModel)}<FILTER_INPUT> = <$filterInputBF>");
        }
        //
        if (filterInputBF != filterInputB) {
          throw ___registerError(
              "The Scalar and its Filter-Input must have the same FILTER_INPUT type. \n\n"
              " >> ${getClassName(scalar)}<FILTER_INPUT> = <$filterInputB> \n"
              " >> ${getClassName(filterModel)}<FILTER_INPUT> = <$filterInputBF>");
        }
        // ----------------
        const Type filterCriteriaType = FilterCriteria;
        final String filterCriteriaBase = filterCriteriaType.toString();
        final String filterCriteriaBF =
            filterModel.getFilterCriteriaTypeAsString();
        final String filterCriteriaB = scalar.getFilterCriteriaTypeAsString();
        //
        if (filterCriteriaBF == filterCriteriaBase) {
          throw ___registerError(
              "You need to create your own class that extends the '$filterCriteriaBase' class \n"
              "or use the 'EmptyFilterCriteria' class to use in the '${getClassName(filterModel)}' declaration \n\n"
              " >> Currently, ${getClassName(filterModel)}<FILTER_CRITERIA> = <$filterCriteriaBF>");
        }
        //
        if (filterCriteriaBF != filterCriteriaB) {
          throw ___registerError(
              "The Scalar and its Filter-Model must have the same FILTER_CRITERIA type. \n\n"
              " >> ${getClassName(scalar)}<FILTER_CRITERIA> = <$filterCriteriaB> \n"
              " >> ${getClassName(filterModel)}<FILTER_CRITERIA> = <$filterCriteriaBF>");
        }
        //
        filterModel._scalars.add(scalar);
        scalar._registeredOrDefaultFilterModel = filterModel;
      } else {
        // Default FilterModel.
        FilterModel defaultFilterModel = _DefaultFilterModel(
          name: "${scalar.name}-@-default-scalar-filter-model",
          shelf: this,
        );
        defaultFilterModel._scalars.add(scalar);
        scalar._registeredOrDefaultFilterModel = defaultFilterModel;
        //
        _allFilterModels.add(defaultFilterModel);
        //
        const Type emptyFilterCriteriaType = EmptyFilterCriteria;
        final String filterCriteriaEmpty = emptyFilterCriteriaType.toString();
        final String filterCriteriaB = scalar.getFilterCriteriaTypeAsString();
        //
        if (filterCriteriaB != filterCriteriaEmpty) {
          throw ___registerError(
              "FILTER_CRITERIA of '${getClassName(scalar)}' scalar must be '$filterCriteriaEmpty' "
              "because this scalar does not have a FILTER_MODEL. \n\n"
              " >> Currently, ${getClassName(scalar)}<FILTER_CRITERIA> = <$filterCriteriaB>");
        }
      }
    }
    //
    // Block:
    //
    List<Block> rootBlocks = _shelfStruct.blocks;
    for (Block rootBlock in rootBlocks) {
      rootBlock.parent = null;
      __rootBlocks.add(rootBlock);
      __registerBlockCascade(rootBlock);
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  void __registerBlockCascade(Block block) {
    if (__blockMap.containsKey(block.name)) {
      throw ___registerError(
          "Duplicated block '${block.name}' in '${getClassName(this)}'\n"
          "Double-check ${getClassName(this)}.registerStructure() method");
    } else {
      __blockMap[block.name] = block;
      if (block.formModel != null) {
        _allFormModels.add(block.formModel!);
      }
    }
    //
    block.shelf = this;
    if (block.registerFilterModelName != null) {
      FilterModel? filterModel =
          _shelfStruct.filterModels[block.registerFilterModelName!];
      if (filterModel == null) {
        throw ___registerError(
            "FilterModel not found '${block.registerFilterModelName}' in '${getClassName(this)}'\n"
            "Double-check ${getClassName(this)}.registerStructure() method");
      }
      //
      //
      const Type filterInputType = FilterInput;
      final String filterInputBase = filterInputType.toString();
      final String filterInputBF = filterModel.getFilterInputTypeAsString();
      final String filterInputB = block.getFilterInputTypeAsString();
      //
      if (filterInputBF == filterInputBase) {
        throw ___registerError(
            "You need to create your own class that extends the '$filterInputBase' class \n"
            "or use the 'EmptyFilterInput' class to use in the '${getClassName(filterModel)}' declaration \n\n"
            " >> Currently, ${getClassName(filterModel)}<FILTER_INPUT> = <$filterInputBF>");
      }
      //
      if (filterInputBF != filterInputB) {
        throw ___registerError(
            "The Scalar and its Filter-Input must have the same FILTER_INPUT type.\n\n"
            " >> ${getClassName(block)}<FILTER_INPUT> = <$filterInputB> \n"
            " >> ${getClassName(filterModel)}<FILTER_INPUT> = <$filterInputBF>");
      }
      // -----------------
      const Type filterCriteriaType = FilterCriteria;
      final String filterCriteriaBase = filterCriteriaType.toString();
      final String filterCriteriaBF =
          filterModel.getFilterCriteriaTypeAsString();
      final String filterCriteriaB = block.getFilterCriteriaTypeAsString();
      //
      if (filterCriteriaBF == filterCriteriaBase) {
        throw ___registerError(
            "You need to create your own class that extends from '$filterCriteriaBase' "
            "as FILTER_CRITERIA for '${getClassName(filterModel)}'\n\n"
            " >> Currently, ${getClassName(filterModel)}<FILTER_CRITERIA> = <$filterCriteriaBF>");
      }
      //
      if (filterCriteriaBF != filterCriteriaB) {
        throw ___registerError(
            "The Block and its Filter-Model must have the same FILTER_CRITERIA type. \n"
            " >> ${getClassName(block)}<FILTER_CRITERIA> = <$filterCriteriaB> \n"
            " >> ${getClassName(filterModel)}<FILTER_CRITERIA> = <$filterCriteriaBF>");
      }
      //
      filterModel._blocks.add(block);
      block._registeredOrDefaultFilterModel = filterModel;
    } else {
      FilterModel defaultFilterModel = _DefaultFilterModel(
        name: "${block.name}-@-default-block-filter-model",
        shelf: this,
      );
      defaultFilterModel._blocks.add(block);
      block._registeredOrDefaultFilterModel = defaultFilterModel;
      //
      _allFilterModels.add(defaultFilterModel);
      //
      const Type emptyFilterCriteriaType = EmptyFilterCriteria;
      final String filterCriteriaEmpty = emptyFilterCriteriaType.toString();
      final String filterCriteriaB = block.getFilterCriteriaTypeAsString();
      //
      if (filterCriteriaB != filterCriteriaEmpty) {
        throw ___registerError(
            "Filter-Criteria of '${getClassName(block)}' block must be '$filterCriteriaEmpty' "
            "because this block does not have a FILTER_MODEL.\n\n"
            " >> Currently, ${getClassName(block)}<FILTER_CRITERIA> = <$filterCriteriaB>");
      }
    }
    //
    Type extraFormInputB = ExtraFormInput;
    String extraFormInputTypeB = extraFormInputB.toString();
    String extraFormInputTypeStr = block.getExtraFormInputTypeAsString();

    if (extraFormInputTypeStr == extraFormInputTypeB) {
      throw ___registerError(
          "You need to create your own class that extends the '$extraFormInputTypeB' class \n"
          "or use the 'EmptyExtraFormInput' class to use in the '${getClassName(block)}' declaration \n\n"
          " >> Currently, ${getClassName(block)}<EXTRA_FORM_INPUT> = <$extraFormInputTypeStr>");
    }
    //
    for (Block childBlock in block.childBlocks) {
      __registerBlockCascade(childBlock);
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  List<Block> get blocks {
    List<Block> ret = [];
    for (Block rootBlock in __rootBlocks) {
      ret.add(rootBlock);
      ret.addAll(rootBlock.descendantBlocks);
    }
    return ret;
  }

  // ***************************************************************************
  // ***************************************************************************

  ShelfStructure registerStructure();

  // ***************************************************************************
  // ***************************************************************************

  Future<void> showShelfStructureDialog() async {
    BuildContext context = FlutterArtist.adapter.getCurrentContext();
    await _showStorageDialog(context: context, shelf: this);
  }

  // ***************************************************************************
  // ***************************************************************************

  Future<void> showActiveUiComponentsDialog() async {
    BuildContext context = FlutterArtist.adapter.getCurrentContext();
    await _showActiveUIComponentsDialog(context: context, shelf: this);
  }

  // ***************************************************************************
  // ***************************************************************************
  // ***************************************************************************

  Scalar? findScalar(String scalarName) {
    return __scalarMap[scalarName];
  }

  // ***************************************************************************
  // ***************************************************************************

  Block? findBlock(String blockName) {
    return __blockMap[blockName];
  }

  // ***************************************************************************
  // ***************************************************************************

  Activity? findActivity(String activityName) {
    return __activityMap[activityName];
  }

  // ***************************************************************************
  // ***************************************************************************

  FilterModel? findFilterModel(String filterModelName) {
    return _shelfStruct.filterModels[filterModelName];
  }

  // ***************************************************************************
  // ******** UI COMPONENTS ****************************************************
  // ***************************************************************************

  void __findMountedWidgetStates({
    required List<Block> blocks,
    required bool withBlockFragment,
    required bool withFilter,
    required bool withForm,
    required bool withControlBar,
    required bool withControl,
    required bool activeOnly,
    required bool withPagination,
    required Map<_RefreshableWidgetState, _XState> founds,
  }) {
    for (Block block in blocks) {
      Map<_RefreshableWidgetState, _XState> m = block._findMountedWidgetStates(
        activeOnly: activeOnly,
        withPagination: withPagination,
        withBlockFragment: withBlockFragment,
        withFilter: withFilter,
        withForm: withForm,
        withControlBar: withControlBar,
        withControl: withControl,
      );
      founds.addAll(m);
      //
      __findMountedWidgetStates(
        withPagination: withPagination,
        withBlockFragment: withBlockFragment,
        withFilter: withFilter,
        withForm: withForm,
        withControlBar: withControlBar,
        withControl: withControl,
        activeOnly: activeOnly,
        blocks: block.childBlocks,
        founds: founds,
      );
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  Map<_RefreshableWidgetState, _XState> _findMountedWidgetStates({
    required bool withBlockFragment,
    required bool withPagination,
    required bool withFilter,
    required bool withForm,
    required bool withControlBar,
    required bool withControl,
    required bool activeOnly,
  }) {
    Map<_RefreshableWidgetState, _XState> founds = {};
    __findMountedWidgetStates(
      withPagination: withPagination,
      withBlockFragment: withBlockFragment,
      withFilter: withFilter,
      withForm: withForm,
      withControlBar: withControlBar,
      withControl: withControl,
      activeOnly: activeOnly,
      blocks: __rootBlocks,
      founds: founds,
    );
    return founds;
  }

  // ***************************************************************************
  // ****** UPDATE UI COMPONENTS ***********************************************
  // ***************************************************************************

  void updateAllUIComponents() {
    try {
      print("|----> ${getClassName(this)}.updateAllUIComponents()");
      __updateShelfWidgets();
      //
      for (FilterModel filterModel in _allFilterModels) {
        filterModel.updateAllUIComponents();
      }
      //
      for (Scalar scalar in __scalars) {
        scalar.updateAllUIComponents(withoutFilters: true);
      }
      //
      for (Block block in __rootBlocks) {
        __updateAllBlockUIComponentsCascade(block, withoutFilters: true);
      }
    } catch (e, stackTrace) {
      print("ERROR: $e");
      print(stackTrace);
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  void __updateAllBlockUIComponentsCascade(
    Block block, {
    required bool withoutFilters,
  }) {
    block.updateAllUIComponents(withoutFilters: withoutFilters);
    //
    for (Block childBlock in block._childBlocks) {
      __updateAllBlockUIComponentsCascade(
        childBlock,
        withoutFilters: withoutFilters,
      );
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  void __updateShelfWidgets() {
    for (_RefreshableWidgetState state in _shelfWidgetStates.keys) {
      if (state.mounted) {
        state.refreshState();
      }
    }
  }

  // ***************************************************************************
  // ***************************************************************************
  // ***************************************************************************

  void _addShelfWidgetState({
    required _RefreshableWidgetState widgetState,
    required bool isShowing,
  }) {
    _shelfWidgetStates[widgetState] = isShowing;
  }

  // ***************************************************************************
  // ***************************************************************************

  void _removeShelfWidgetState({required State widgetState}) {
    _shelfWidgetStates.remove(widgetState);
  }

  // ***************************************************************************
  // ***************************************************************************
  // ***************************************************************************

  Future<void> _startLoadDataForLazyUIComponentsIfNeed() async {
    if (__lazyLoadLocked) {
      await Future.doWhile(
        () => Future.delayed(const Duration(milliseconds: 1))
            .then((_) => __lazyLoadLocked),
      );
    }

    if (__lazyLoadId == __lastLazyLoadId) {
      __lazyLoadId++;
      __lazyBlocksToQuery.clear();
      //
      Future.delayed(
        const Duration(milliseconds: 0),
        () {
          __queryLazyList();
        },
      );
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  Future<void> __queryLazyList() async {
    __lazyLoadLocked = true;
    //
    final List<_ScalarOrBlockOrFormWrapper> lazyBlockOrForms =
        __findTopLazyScalarOrBlockOrForms();

    print(">>>> lazyBlockOrForms: $lazyBlockOrForms");
    //
    if (lazyBlockOrForms.isEmpty) {
      __lastLazyLoadId = __lazyLoadId;
      __lazyLoadLocked = false;
      return;
    } else {
      print("@@@@@@@@@@@@ Lazy Load - ID: $__lazyLoadId");
      print("@@@@@@@@@@@@ Lazy Load - Count: ${lazyBlockOrForms.length}");
      //
      __lastLazyLoadId = __lazyLoadId;

      await _queryLazyScalarOrBlockOrForms(
        // required QueryType queryType,  (???)
        scalarOrBlockOrFormWrappers: lazyBlockOrForms,
      );
      __lazyLoadLocked = false;
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  Future<void> _queryLazyScalarOrBlockOrForms({
    // required QueryType queryType,  (???)
    required List<_ScalarOrBlockOrFormWrapper> scalarOrBlockOrFormWrappers,
  }) async {
    if (scalarOrBlockOrFormWrappers.isEmpty) {
      return;
    }
    //
    final List<_ScalarOpt> scalarOpts = [];
    final List<_BlockOpt> blockOpts = [];
    final List<_FormModelOpt> formModelOpts = [];
    //
    for (_ScalarOrBlockOrFormWrapper wrapper in scalarOrBlockOrFormWrappers) {
      if (wrapper.scalar != null) {
        wrapper.scalar!._lazyLoadCount++;
        //
        scalarOpts.add(
          _ScalarOpt(scalar: wrapper.scalar!),
        );
      } else if (wrapper.block != null) {
        wrapper.block!._lazyLoadCount++;
        //
        blockOpts.add(
          _BlockOpt(
            block: wrapper.block!,
            // queryType: null,  (???)
            forceQuery: false,
            pageable: null,
            listBehavior: null,
            suggestedSelection: null,
            postQueryBehavior: null,
          ),
        );
      } else if (wrapper.formModel != null) {
        wrapper.formModel!._lazyLoadCount++;
        //
        formModelOpts.add(
          _FormModelOpt(formModel: wrapper.formModel!),
        );
      }
    }
    //
    print("@@@@@@@@@@@@ Query Lazy List: scalarOpts: $scalarOpts");
    print("@@@@@@@@@@@@ Query Lazy List: blockOpts: $blockOpts");
    print("@@@@@@@@@@@@ Query Lazy List: formModelOpts: $formModelOpts");
    //
    _XShelf xShelf = await _queryAll(
      forceFilterModelOpt: null,
      forceQueryScalarOpts: scalarOpts,
      forceQueryBlockOpts: blockOpts,
      forceQueryFormModelOpts: formModelOpts,
    );
  }

  // ***************************************************************************
  //
  //
  //
  // ***************************************************************************

  void __findLazyScalars(List<_ScalarOrBlockOrFormWrapper> founds) {
    for (Scalar scalar in __scalars) {
      if (scalar.hasActiveUIComponent() &&
          scalar.queryDataState == DataState.pending) {
        founds.add(_ScalarOrBlockOrFormWrapper.scalar(scalar));
      }
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  void __findTopLazyBlocksCascade(
    List<Block> blocks,
    List<_ScalarOrBlockOrFormWrapper> founds,
  ) {
    for (Block block in blocks) {
      // if (block.hasActiveBlockFragmentWidget(alsoCheckChildren: true) &&
      //     block.queryDataState == DataState.pending) {
      //   founds.add(_ScalarOrBlockOrFormWrapper.block(block));
      // } else if (block.formModel != null &&
      //     block.formModel!.hasActiveUIComponent() &&
      //     block.formModel!.formDataState == DataState.pending) {
      //   founds.add(_ScalarOrBlockOrFormWrapper.formModel(block.formModel!));
      // } else {
      //   __findTopLazyBlocksCascade(block._childBlocks, founds);
      // }
      //
      bool found = false;
      //
      // TODO: Mới kt các fragment, còn các cái khác thì sao? ItemsView?
      //
      if (block.hasActiveBlockFragmentWidget(alsoCheckChildren: true)) {
        if (block.queryDataState == DataState.pending) {
          founds.add(_ScalarOrBlockOrFormWrapper.block(block));
          found = true;
        }
      } else if (block.formModel != null &&
          block.formModel!.hasActiveUIComponent()) {
        if (block.formModel!.formDataState == DataState.pending) {
          founds.add(_ScalarOrBlockOrFormWrapper.formModel(block.formModel!));
          found = true;
        }
      }
      if (!found) {
        __findTopLazyBlocksCascade(block._childBlocks, founds);
      }
    }
  }

  // ***************************************************************************
  // ***************************************************************************

  List<_ScalarOrBlockOrFormWrapper> __findTopLazyScalarOrBlockOrForms() {
    final List<_ScalarOrBlockOrFormWrapper> founds = [];
    __findLazyScalars(founds);
    __findTopLazyBlocksCascade(__rootBlocks, founds);
    return founds;
  }

  // ***************************************************************************
  // ********** ACTIVE/MOUNTED COMPONENT ***************************************
  // ***************************************************************************

  bool _hasMountedScalarUIComponent() {
    for (Scalar scalar in scalars) {
      if (scalar.hasMountedUIComponent()) {
        return true;
      }
    }
    return false;
  }

  // ***************************************************************************
  // ***************************************************************************

  bool _hasMountedBlockUIComponentCascade(List<Block> blocks) {
    for (Block block in blocks) {
      if (block.hasMountedUIComponent()) {
        return true;
      }
      bool hasMounted = _hasMountedBlockUIComponentCascade(block._childBlocks);
      if (hasMounted) {
        return true;
      }
    }
    return false;
  }

  // ***************************************************************************
  // ***************************************************************************

  bool hasMountedUIComponent() {
    bool hasMounted = _shelfWidgetStates.isNotEmpty;
    if (hasMounted) {
      return true;
    }
    hasMounted = _hasMountedBlockUIComponentCascade(__rootBlocks);
    if (hasMounted) {
      return true;
    }
    hasMounted = _hasMountedScalarUIComponent();
    if (hasMounted) {
      return true;
    }
    return false;
  }

  // ***************************************************************************
  // ***************************************************************************

  Future<_XShelf> _queryAll({
    required _FilterModelOpt? forceFilterModelOpt,
    required List<_ScalarOpt> forceQueryScalarOpts,
    required List<_BlockOpt> forceQueryBlockOpts,
    required List<_FormModelOpt> forceQueryFormModelOpts,
  }) async {
    _XShelf xShelf = _XShelf(
      shelf: this,
      forceFilterModelOpt: forceFilterModelOpt,
      forceQueryScalarOpts: forceQueryScalarOpts,
      forceQueryBlockOpts: forceQueryBlockOpts,
      forceQueryFormModelOpts: forceQueryFormModelOpts,
    );
    //
    await _executeQueryXShelf(xShelf: xShelf);
    return xShelf;
  }

  // ***************************************************************************
  // ***************************************************************************

  Future<void> _executeQueryXShelf({
    required _XShelf xShelf,
  }) async {
    xShelf.printMe();
    //
    for (_XScalar xScalar in xShelf.allXScalars) {
      if (!xScalar.needQuery) {
        continue;
      }
      //
      // Add to Queue:
      //
      FlutterArtist.taskUnitQueue.addTaskUnit(
        _ScalarQueryTaskUnit(
          xScalar: xScalar,
        ),
      );
    }
    //
    for (_XBlock xBlock in xShelf.allRootXBlocks) {
      //
      // Add to Queue:
      //
      FlutterArtist.taskUnitQueue.addTaskUnit(
        _BlockQueryTaskUnit(
          xBlock: xBlock,
        ),
      );
    }
    //
    // for (_XFormModel xFormModel in xShelf.allXFormModels) {
    //   if (!xFormModel.forceForm) {
    //     continue;
    //   }
    //   //
    //   // Add to Queue:
    //   //
    //   FlutterArtist.taskUnitQueue.addTaskUnit(
    //     _FormModelLoadFormTaskUnit(
    //       xFormModel: xFormModel,
    //     ),
    //   );
    // }
    //
    await FlutterArtist.executor._executeTaskUnitQueue();
  }

  // ***************************************************************************
  // ***************************************************************************

  String _toString({
    required List<_ScalarOpt> forceQueryScalarOpts,
    required List<_BlockOpt> forceQueryBlockOpts,
    required List<_FormModelOpt> forceQueryFormModelOpts,
  }) {
    String info = "";
    if (forceQueryScalarOpts.isNotEmpty) {
      String s = forceQueryScalarOpts
          .map((opt) => getClassName(opt.scalar))
          .join(", ");
      if (info.isEmpty) {
        info = s;
      } else {
        info = "$info, $s";
      }
    }
    if (forceQueryBlockOpts.isNotEmpty) {
      String s =
          forceQueryBlockOpts.map((opt) => getClassName(opt.block)).join(", ");
      if (info.isEmpty) {
        info = s;
      } else {
        info = "$info, $s";
      }
    }
    if (forceQueryFormModelOpts.isNotEmpty) {
      String s = forceQueryFormModelOpts
          .map((opt) => getClassName(opt.formModel))
          .join(", ");
      if (info.isEmpty) {
        info = s;
      } else {
        info = "$info, $s";
      }
    }
    return info;
  }

  // ***************************************************************************
  // ***************************************************************************

  @override
  String toString() {
    return "${getClassName(this)}($name)";
  }
}
